SUBSYSTEM_DEF(vote)
	name = "Vote"
	wait = 1 SECOND

	flags = SS_KEEP_TIMING|SS_NO_INIT

	runlevels = RUNLEVEL_LOBBY | RUNLEVELS_DEFAULT
	priority = FIRE_PRIORITY_PING

	/// The current active vote, if there is one
	var/datum/vote/current_vote
	/// Who or what started the vote, string
	var/initiator
	/// REALTIMEOFDAY start time
	var/started_time
	/// Time remaining in DS
	var/time_remaining

	/// List of ckeys who have the vote menu open.
	var/list/voting = list()

	/// A list of action datums to garbage collect when it's over
	var/list/datum/action/generated_actions = list()

// Called by master_controller
/datum/controller/subsystem/vote/fire()
	if(isnull(current_vote))
		return

	time_remaining = round((started_time + CONFIG_GET(number/vote_period) - REALTIMEOFDAY)/10)
	if(time_remaining < 0)
		SStgui.close_uis(src)
		finish_vote()

/datum/controller/subsystem/vote/proc/reset()
	initiator = null
	time_remaining = null
	started_time = null
	QDEL_NULL(current_vote)
	QDEL_LIST(generated_actions)

/datum/controller/subsystem/vote/proc/finish_vote()
	current_vote.tally_votes()
	announce_result()
	current_vote.after_completion()
	reset()

/datum/controller/subsystem/vote/proc/announce_result()
	var/text

	if(current_vote.winners.len > 0)
		text += "<b>[capitalize(current_vote.name)] Vote</b>"

		for(var/option in current_vote.options)
			var/votes = current_vote.tally[option] || 0

			text += "\n<b>[option]:</b> [votes]"

		if(!istype(current_vote, /datum/vote/custom))
			if(current_vote.winners.len > 1)
				text = "\n<b>Vote Tied Between:</b>"
				for(var/option in current_vote.winners)
					text += "\n\t[option]"
			text += "\n<b>Vote Result: [current_vote.real_winner]</b>"

		else
			text += "\n<b>Did not vote:</b> [length(current_vote.non_voters)]"
	else
		text += "<b>Vote Result: Inconclusive - No Votes!</b>"

	log_vote(text)
	to_chat(world, "\n<span class='infoplain'><font color='purple'>[text]</font></span>")

/datum/controller/subsystem/vote/proc/submit_vote(user, vote)
	if(!vote)
		return FALSE

	current_vote.try_vote(user, vote)

/datum/controller/subsystem/vote/proc/initiate_vote(vote_type, initiator_key)
	if(!ispath(vote_type, /datum/vote))
		CRASH("Passed bad path into initiate_vote(): [vote_type]")

	//Server is still intializing.
	if(!MC_RUNNING(init_stage))
		to_chat(usr, span_warning("Cannot start vote, server is not done initializing."))
		return FALSE

	var/is_admin_running = FALSE
	if(GLOB.admin_datums[initiator_key] || initiator_key == "server")
		is_admin_running = TRUE

	if(started_time)
		var/next_allowed_time = (started_time + CONFIG_GET(number/vote_delay))
		if(current_vote)
			to_chat(usr, span_warning("There is already a vote in progress! please wait for it to finish."))
			return FALSE

		if(next_allowed_time > world.time && !is_admin_running)
			to_chat(usr, span_warning("A vote was initiated recently, you must wait [DisplayTimeText(next_allowed_time-world.time)] before a new vote can be started!"))
			return FALSE

	var/datum/vote/new_vote = new vote_type()

	if(!istype(new_vote, /datum/vote/custom))
		if(!new_vote.can_run(is_admin_running))
			return FALSE
		current_vote = new_vote

	else
		if(!is_admin_running)
			return FALSE

		var/question = tgui_input_text(usr, "What is the vote for?", "Custom Vote")
		if(!question)
			return FALSE

		new_vote.name = question

		for(var/i in 1 to 10)
			var/option = tgui_input_text(usr, "Please enter an option or hit cancel to finish", "Options", max_length = MAX_NAME_LEN)
			if(!option || current_vote || !usr.client)
				break

			new_vote.options.Add(capitalize(option))

		current_vote = new_vote

	initiator = initiator_key
	started_time = REALTIMEOFDAY

	var/text = "[capitalize(current_vote.name)] vote started by [initiator || "server"]."

	log_vote(text)

	var/vp = CONFIG_GET(number/vote_period)
	to_chat(world, "\n[systemtext("<font color='purple'><b>[text]</b>\nType <b>vote</b> or click <a href='byond://winset?command=vote'>here</a> to place your votes.\nYou have [DisplayTimeText(vp)] to vote.</font>")]")

	time_remaining = round(vp/10)
	for(var/client/C in GLOB.clients)
		var/datum/action/vote/V = new
		V.Grant(C.mob)
		V.name = "Vote: [current_vote.name]"

		C.persistent_client.player_actions += V
		generated_actions += V

		if(C.prefs.toggles & SOUND_ANNOUNCEMENTS)
			SEND_SOUND(C, sound('sound/misc/bloop.ogg'))
	return TRUE


/mob/verb/vote()
	set category = "OOC"
	set name = "Vote"
	SSvote.ui_interact(usr)

/datum/controller/subsystem/vote/ui_state()
	return GLOB.always_state

/datum/controller/subsystem/vote/ui_interact(mob/user, datum/tgui/ui)
	// Tracks who is voting
	if(user.client?.ckey)
		voting |= user.client.ckey

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Vote")
		ui.open()

/datum/controller/subsystem/vote/ui_data(mob/user)
	var/list/data = list(
		"allow_vote_map" = CONFIG_GET(flag/allow_vote_map),
		"allow_vote_restart" = CONFIG_GET(flag/allow_vote_restart),
		"choices" = list(),
		"lower_admin" = !!user.client?.holder,
		"mode" = current_vote?.name,
		"question" = current_vote?.name,
		"selected_choice" = current_vote?.voters[user.client?.ckey],
		"time_remaining" = time_remaining,
		"upper_admin" = check_rights_for(user.client, R_ADMIN),
		"voting" = list(),
	)

	if(!!user.client?.holder)
		data["voting"] = voting

	for(var/option in current_vote?.options)
		data["choices"] += list(list(
			"name" = option,
			"votes" = current_vote.tally[option] || 0
		))

	return data

/datum/controller/subsystem/vote/ui_act(action, params)
	. = ..()
	if(.)
		return

	var/upper_admin = FALSE
	if(usr.client.holder)
		if(check_rights_for(usr.client, R_ADMIN))
			upper_admin = TRUE

	switch(action)
		if("cancel")
			if(usr.client.holder)
				usr.log_message("[key_name_admin(usr)] cancelled a vote.", LOG_ADMIN)
				message_admins("[key_name_admin(usr)] has cancelled the current vote.")
				reset()

		if("toggle_restart")
			if(usr.client.holder && upper_admin)
				CONFIG_SET(flag/allow_vote_restart, !CONFIG_GET(flag/allow_vote_restart))

		if("toggle_map")
			if(usr.client.holder && upper_admin)
				CONFIG_SET(flag/allow_vote_map, !CONFIG_GET(flag/allow_vote_map))

		if("restart")
			if(CONFIG_GET(flag/allow_vote_restart) || usr.client.holder)
				initiate_vote(/datum/vote/restart, usr.ckey)

		if("map")
			if(CONFIG_GET(flag/allow_vote_map) || usr.client.holder)
				initiate_vote(/datum/vote/change_map, usr.ckey)

		if("custom")
			if(usr.client.holder)
				initiate_vote(/datum/vote/custom, usr.ckey)

		//PARIAH EDIT ADDITION BEGIN - autotransfer
		if("transfer")
			if(check_rights(R_ADMIN))
				initiate_vote(/datum/vote/crew_transfer, usr.ckey)

		//PARIAH EDIT ADDITION END
		if("vote")
			submit_vote(usr, round(text2num(params["index"])))
	return TRUE

/datum/controller/subsystem/vote/ui_close(mob/user)
	voting -= user.client?.ckey

/datum/action/vote
	name = "Vote!"
	button_icon_state = "vote"

/datum/action/vote/IsAvailable(feedback = FALSE)
	return TRUE

/datum/action/vote/Trigger(trigger_flags)
	. = ..()
	if(!.)
		return

	owner.vote()
	Remove(owner)

// We also need to remove our action from the player actions when we're cleaning up.
/datum/action/vote/Remove(mob/removed_from)
	if(removed_from.persistent_client)
		removed_from.persistent_client?.player_actions -= src

	else if(removed_from.ckey)
		var/datum/persistent_client/persistent_client = GLOB.persistent_clients_by_ckey[removed_from.ckey]
		persistent_client?.player_actions -= src

	return ..()
