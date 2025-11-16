#define POPCOUNT_SURVIVORS "survivors" //Not dead at roundend
#define POPCOUNT_ESCAPEES "escapees" //Not dead and on centcom/shuttles marked as escaped
#define POPCOUNT_SHUTTLE_ESCAPEES "shuttle_escapees" //Emergency shuttle only.
#define POPCOUNT_ESCAPEES_HUMANONLY "human_escapees"
#define ROUNDEND_PERSONAL_LAST "personal last round"
#define ROUNDEND_SERVER_LAST "server last round"
#define ROUNDEND_CURRENT "current round"

/datum/controller/subsystem/ticker/proc/gather_roundend_feedback()
	gather_antag_data()
	record_nuke_disk_location()
	var/json_file = file("[GLOB.log_directory]/round_end_data.json")
	// All but npcs sublists and ghost category contain only mobs with minds
	var/list/file_data = list("escapees" = list("humans" = list(), "silicons" = list(), "others" = list(), "npcs" = list()), "abandoned" = list("humans" = list(), "silicons" = list(), "others" = list(), "npcs" = list()), "ghosts" = list(), "additional data" = list())
	var/num_survivors = 0 //Count of non-brain non-camera mobs with mind that are alive
	var/num_escapees = 0 //Above and on centcom z
	var/num_human_escapees = 0 //Above but humans only
	var/num_shuttle_escapees = 0 //Above and on escape shuttle
	var/list/list_of_human_escapees = list() //References to all escaped humans
	var/list/list_of_mobs_on_shuttle = list()
	var/list/area/shuttle_areas
	if(SSshuttle?.emergency)
		shuttle_areas = SSshuttle.emergency.shuttle_areas

	for(var/mob/M in GLOB.mob_list)
		var/list/mob_data = list()
		if(isnewplayer(M))
			continue

		var/escape_status = "abandoned" //default to abandoned
		var/category = "npcs" //Default to simple count only bracket
		var/count_only = TRUE //Count by name only or full info

		mob_data["name"] = M.name
		if(M.mind)
			count_only = FALSE
			mob_data["ckey"] = M.mind.key
			if(M.onCentCom())
				list_of_mobs_on_shuttle += M
			if(M.stat != DEAD && !isbrain(M) && !iscameramob(M))
				num_survivors++
				if(EMERGENCY_ESCAPED_OR_ENDGAMED && (M.onCentCom() || M.onSyndieBase()))
					num_escapees++
					if(ishuman(M))
						num_human_escapees++
						list_of_human_escapees += M
					escape_status = "escapees"
					if(shuttle_areas[get_area(M)])
						num_shuttle_escapees++
			if(isliving(M))
				var/mob/living/L = M
				mob_data["location"] = get_area(L)
				mob_data["health"] = L.health
				if(ishuman(L))
					var/mob/living/carbon/human/H = L
					category = "humans"
					if(H.mind)
						mob_data["job"] = H.mind.assigned_role.title
					else
						mob_data["job"] = "Unknown"
					mob_data["species"] = H.dna.species.name
				else if(issilicon(L))
					category = "silicons"
					if(isAI(L))
						mob_data["module"] = "AI"
					else if(ispAI(L))
						mob_data["module"] = "pAI"
					else if(iscyborg(L))
						var/mob/living/silicon/robot/R = L
						mob_data["module"] = R.model.name
				else
					category = "others"
					mob_data["typepath"] = M.type
		//Ghosts don't care about minds, but we want to retain ckey data etc
		if(isobserver(M))
			count_only = FALSE
			escape_status = "ghosts"
			if(!M.mind)
				mob_data["ckey"] = M.key
			category = null //ghosts are one list deep
		//All other mindless stuff just gets counts by name
		if(count_only)
			var/list/npc_nest = file_data["[escape_status]"]["npcs"]
			var/name_to_use = initial(M.name)
			if(ishuman(M))
				name_to_use = "Unknown Minervan" //Monkeymen and other mindless corpses
			if(npc_nest.Find(name_to_use))
				file_data["[escape_status]"]["npcs"][name_to_use] += 1
			else
				file_data["[escape_status]"]["npcs"][name_to_use] = 1
		else
			//Mobs with minds and ghosts get detailed data
			if(category)
				var/pos = length(file_data["[escape_status]"]["[category]"]) + 1
				file_data["[escape_status]"]["[category]"]["[pos]"] = mob_data
			else
				var/pos = length(file_data["[escape_status]"]) + 1
				file_data["[escape_status]"]["[pos]"] = mob_data

	GLOB.end_state = new
	GLOB.end_state.count()
	var/station_integrity = min(PERCENT(GLOB.start_state.score(GLOB.end_state)), 100)
	file_data["additional data"]["station integrity"] = station_integrity
	WRITE_FILE(json_file, json_encode(file_data))

	SSblackbox.record_feedback("nested tally", "round_end_stats", num_survivors, list("survivors", "total"))
	SSblackbox.record_feedback("nested tally", "round_end_stats", num_escapees, list("escapees", "total"))
	SSblackbox.record_feedback("nested tally", "round_end_stats", GLOB.joined_player_list.len, list("players", "total"))
	SSblackbox.record_feedback("nested tally", "round_end_stats", GLOB.joined_player_list.len - num_survivors, list("players", "dead"))
	. = list()
	.[POPCOUNT_SURVIVORS] = num_survivors
	.[POPCOUNT_ESCAPEES] = num_escapees
	.[POPCOUNT_ESCAPEES_HUMANONLY] = num_human_escapees
	.[POPCOUNT_SHUTTLE_ESCAPEES] = num_shuttle_escapees
	.["all_mobs_on_shuttle"] = list_of_mobs_on_shuttle
	.["human_escapees_list"] = list_of_human_escapees
	.["station_integrity"] = station_integrity

/datum/controller/subsystem/ticker/proc/gather_antag_data()
	var/team_gid = 1
	var/list/team_ids = list()

	for(var/datum/antagonist/A in GLOB.antagonists)
		if(!A.owner)
			continue

		var/list/antag_info = list()
		antag_info["key"] = A.owner.key
		antag_info["name"] = A.owner.name
		antag_info["antagonist_type"] = A.type
		antag_info["antagonist_name"] = A.name //For auto and custom roles
		antag_info["objectives"] = list()
		antag_info["team"] = list()
		var/datum/team/T = A.get_team()
		if(T)
			antag_info["team"]["type"] = T.type
			antag_info["team"]["name"] = T.name
			if(!team_ids[T])
				team_ids[T] = team_gid++
			antag_info["team"]["id"] = team_ids[T]

		if(A.objectives.len)
			for(var/datum/objective/O in A.objectives)
				var/result = O.check_completion() ? "SUCCESS" : "FAIL"
				antag_info["objectives"] += list(list("objective_type"=O.type,"text"=O.explanation_text,"result"=result))
		SSblackbox.record_feedback("associative", "antagonists", 1, antag_info)

/datum/controller/subsystem/ticker/proc/record_nuke_disk_location()
	var/disk_count = 1
	for(var/obj/item/disk/nuclear/nuke_disk as anything in SSpoints_of_interest.real_nuclear_disks)
		var/list/data = list()
		var/turf/disk_turf = get_turf(nuke_disk)
		if(disk_turf)
			data["x"] = disk_turf.x
			data["y"] = disk_turf.y
			data["z"] = disk_turf.z
		var/atom/outer = get_atom_on_turf(nuke_disk, /mob/living)
		if(outer != nuke_disk)
			if(isliving(outer))
				var/mob/living/disk_holder = outer
				data["holder"] = disk_holder.real_name
			else
				data["holder"] = outer.name

		SSblackbox.record_feedback("associative", "roundend_nukedisk", disk_count, data)
		disk_count++

/datum/controller/subsystem/ticker/proc/gather_newscaster()
	var/json_file = file("[GLOB.log_directory]/newscaster.json")
	var/list/file_data = list()
	var/pos = 1
	for(var/V in GLOB.news_network.network_channels)
		var/datum/feed_channel/channel = V
		if(!istype(channel))
			stack_trace("Non-channel in newscaster channel list")
			continue
		file_data["[pos]"] = list("channel name" = "[channel.channel_name]", "author" = "[channel.author]", "censored" = channel.censored ? 1 : 0, "author censored" = channel.author_censor ? 1 : 0, "messages" = list())
		for(var/M in channel.messages)
			var/datum/feed_message/message = M
			if(!istype(message))
				stack_trace("Non-message in newscaster channel messages list")
				continue
			var/list/comment_data = list()
			for(var/C in message.comments)
				var/datum/feed_comment/comment = C
				if(!istype(comment))
					stack_trace("Non-message in newscaster message comments list")
					continue
				comment_data += list(list("author" = "[comment.author]", "time stamp" = "[comment.time_stamp]", "body" = "[comment.body]"))
			file_data["[pos]"]["messages"] += list(list("author" = "[message.author]", "time stamp" = "[message.time_stamp]", "censored" = message.body_censor ? 1 : 0, "author censored" = message.author_censor ? 1 : 0, "photo file" = "[message.photo_file]", "photo caption" = "[message.caption]", "body" = "[message.body]", "comments" = comment_data))
		pos++
	if(GLOB.news_network.wanted_issue.active)
		file_data["wanted"] = list("author" = "[GLOB.news_network.wanted_issue.scanned_user]", "criminal" = "[GLOB.news_network.wanted_issue.criminal]", "description" = "[GLOB.news_network.wanted_issue.body]", "photo file" = "[GLOB.news_network.wanted_issue.photo_file]")
	WRITE_FILE(json_file, json_encode(file_data))

/datum/controller/subsystem/ticker/proc/declare_completion()
	set waitfor = FALSE

	to_chat(world, "<hr>")
	to_chat(world, span_big(systemtext("The round has ended.")))
	log_game("The round has ended.")

	for(var/datum/callback/roundend_callbacks as anything in round_end_events)
		roundend_callbacks.InvokeAsync()
	LAZYCLEARLIST(round_end_events)

	popcount = gather_roundend_feedback()
	INVOKE_ASYNC(SScredits, TYPE_PROC_REF(/datum/controller/subsystem/credits, draft)) //Must always come after popcount is set
	for(var/client/C in GLOB.clients)
		C.playcreditsmusic(50)

	CHECK_TICK

	display_report(popcount)

	CHECK_TICK

	// Add AntagHUD to everyone, see who was really evil the whole time!
	for(var/datum/atom_hud/alternate_appearance/basic/antagonist_hud/antagonist_hud in GLOB.active_alternate_appearances)
		for(var/mob/player as anything in GLOB.player_list)
			antagonist_hud.show_to(player)

	CHECK_TICK

	//Set news report and mode result
	mode.set_round_result()

	send2adminchat("Server", "Round just ended.")

	if(length(CONFIG_GET(keyed_list/cross_server)))
		send_news_report()

	CHECK_TICK

	handle_hearts()
	set_observer_default_invisibility(0, span_warning("The round is over! You are now visible to the living."))

	CHECK_TICK

	//These need update to actually reflect the real antagonists
	//Print a list of antagonists to the server log
	var/list/total_antagonists = list()
	//Look into all mobs in world, dead or alive
	for(var/datum/antagonist/A in GLOB.antagonists)
		if(!A.owner)
			continue
		if(!(A.name in total_antagonists))
			total_antagonists[A.name] = list()
		total_antagonists[A.name] += "[key_name(A.owner)]"

	CHECK_TICK

	//Now print them all into the log!
	log_game("Antagonists at round end were...")
	for(var/antag_name in total_antagonists)
		var/list/L = total_antagonists[antag_name]
		log_game("[antag_name]s :[L.Join(", ")].")

	CHECK_TICK

	for(var/mob/M in popcount["human_escapees_list"])
		M.client?.give_award(/datum/award/achievement/survive_the_night, M)

	CHECK_TICK

	SSdbcore.SetRoundEnd()

	//Collects persistence features
	SSpersistence.collect_data()
	SSpersistent_paintings.save_paintings()

	//stop collecting feedback during grifftime
	SSblackbox.Seal()

	sleep(50)
	ready_for_reboot = TRUE
	standard_reboot()

/datum/controller/subsystem/ticker/proc/standard_reboot()
	if(ready_for_reboot)
		if(GLOB.station_was_nuked)
			Reboot("Station destroyed by Nuclear Device.", "nuke")
		else
			Reboot("Round ended.", "proper completion")
	else
		CRASH("Attempted standard reboot without ticker roundend completion")


/client/proc/roundend_report_file()
	return "data/roundend_reports/[ckey].html"

/// Displays the round end report of the current round. report_type may be passed to show the user's last round, or the server's last round.
/datum/controller/subsystem/ticker/proc/show_roundend_report(client/C, report_type = ROUNDEND_CURRENT)
	var/datum/browser/roundend_report = new(C, "roundend", null, 800, 600)

	var/content
	var/filepath = C.roundend_report_file()
	switch(report_type)
		if(ROUNDEND_PERSONAL_LAST)
			content = file2text(filepath)
		if(ROUNDEND_SERVER_LAST)
			content = file2text("data/server_last_roundend_report.html")
		if(ROUNDEND_CURRENT) // Generate and show personalized report of this round.
			if(!SSticker.round_end_report)
				CRASH("Attempted to generate a roundend report before the round was over.")

			content = SSticker.round_end_report.generate_for_client(C, filepath)
			fdel(filepath)
			text2file(content, filepath)
		else
			CRASH("Bad report type: [report_type]")

	var/google_font_shim = {"
	<link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Notable&family=Pirata+One&family=Playfair+Display:ital,wght@0,400..900;1,400..900&family=Quantico:ital,wght@0,400;0,700;1,400;1,700&family=Special+Elite&display=swap" rel="stylesheet">
	"}

	roundend_report.set_content(content)
	roundend_report.add_head_content(google_font_shim)
	roundend_report.stylesheets = list()
	roundend_report.add_stylesheet("roundend", 'html/browser/roundend.css')
	roundend_report.add_stylesheet("font-awesome", 'html/font-awesome/css/all.min.css')

	roundend_report.open(FALSE)

/datum/controller/subsystem/ticker/proc/display_report(list/popcount)
	round_end_report = new()
	round_end_report.compile(popcount)
	round_end_report.write_log()

	for(var/client/C in GLOB.clients)
		show_roundend_report(C)
		give_show_report_button(C)
		CHECK_TICK

/proc/cmp_antag_category(datum/antagonist/A,datum/antagonist/B)
	return sorttext(B.roundend_category,A.roundend_category)

/datum/controller/subsystem/ticker/proc/give_show_report_button(client/C)
	var/datum/action/report/R = new
	C.persistent_client.player_actions += R
	R.Grant(C.mob)
	to_chat(C,"<span class='infoplain'><a href='?src=[REF(R)];report=1'>Show roundend report again</a></span>")

/datum/action/report
	name = "Show roundend report"
	button_icon_state = "round_end"

/datum/action/report/Trigger(trigger_flags)
	if(owner && SSticker.round_end_report && SSticker.current_state == GAME_STATE_FINISHED)
		SSticker.show_roundend_report(owner.client)

/datum/action/report/IsAvailable(feedback = FALSE)
	return 1

/datum/action/report/Topic(href,href_list)
	if(usr != owner)
		return
	if(href_list["report"])
		Trigger()
		return

/proc/printplayer(datum/mind/ply, fleecheck)
	var/jobtext = ""
	if(!is_unassigned_job(ply.assigned_role))
		jobtext = " the <b>[ply.assigned_role.title]</b>"

	var/text = "<b>[ply.key]</b> was <b>[ply.name]</b>[jobtext] and"

	if(ply.current)
		if(ply.current.stat == DEAD)
			text += " [span_redtext("died")]"
		else
			text += " [span_greentext("survived")]"
		if(fleecheck)
			var/turf/T = get_turf(ply.current)
			if(!T || !is_station_level(T.z))
				text += " while [span_redtext("fleeing the station")]"
		if(ply.current.real_name != ply.name)
			text += " as <b>[ply.current.real_name]</b>"
	else
		text += " [span_redtext("had their body destroyed")]"
	return text

/proc/printplayerlist(list/players,fleecheck)
	var/list/parts = list()

	parts += "<ul class='playerlist'>"
	for(var/datum/mind/M in players)
		parts += "<li>[printplayer(M,fleecheck)]</li>"
	parts += "</ul>"
	return parts.Join()

/proc/printobjectives(list/objectives)
	if(!length(objectives))
		return

	var/list/objective_parts = list()
	var/count = 1
	for(var/datum/objective/objective in objectives)
		objective_parts += "<b>[objective.objective_name] #[count]</b>: [objective.explanation_text] [objective.get_roundend_suffix()]"
		count++
	return objective_parts.Join("<br>")

/datum/controller/subsystem/ticker/proc/save_admin_data()
	if(IsAdminAdvancedProcCall())
		to_chat(usr, "<span class='admin prefix'>Admin rank DB Sync blocked: Advanced ProcCall detected.</span>")
		return
	if(CONFIG_GET(flag/admin_legacy_system)) //we're already using legacy system so there's nothing to save
		return
	else if(load_admins(TRUE)) //returns true if there was a database failure and the backup was loaded from
		return
	sync_ranks_with_db()
	var/list/sql_admins = list()
	for(var/i in GLOB.protected_admins)
		var/datum/admins/A = GLOB.protected_admins[i]
		sql_admins += list(list("ckey" = A.target, "rank" = A.rank.name))
	SSdbcore.MassInsert(format_table_name("admin"), sql_admins, duplicate_key = TRUE)
	var/datum/db_query/query_admin_rank_update = SSdbcore.NewQuery("UPDATE [format_table_name("player")] p INNER JOIN [format_table_name("admin")] a ON p.ckey = a.ckey SET p.lastadminrank = a.rank")
	query_admin_rank_update.Execute()
	qdel(query_admin_rank_update)

	//json format backup file generation stored per server
	var/json_file = file("data/admins_backup.json")
	var/list/file_data = list(
		"ranks" = list(),
		"admins" = list(),
		"connections" = list(),
	)
	for(var/datum/admin_rank/R in GLOB.admin_ranks)
		file_data["ranks"]["[R.name]"] = list()
		file_data["ranks"]["[R.name]"]["include rights"] = R.include_rights
		file_data["ranks"]["[R.name]"]["exclude rights"] = R.exclude_rights
		file_data["ranks"]["[R.name]"]["can edit rights"] = R.can_edit_rights

	for(var/admin_ckey in GLOB.admin_datums + GLOB.deadmins)
		var/datum/admins/admin = GLOB.admin_datums[admin_ckey]

		if(!admin)
			admin = GLOB.deadmins[admin_ckey]
			if (!admin)
				continue

		file_data["admins"][admin_ckey] = admin.rank.name

		if (admin.owner)
			file_data["connections"][admin_ckey] = list(
				"cid" = admin.owner.computer_id,
				"ip" = admin.owner.address,
			)

	fdel(json_file)
	WRITE_FILE(json_file, json_encode(file_data))

/datum/controller/subsystem/ticker/proc/update_everything_flag_in_db()
	for(var/datum/admin_rank/R in GLOB.admin_ranks)
		var/list/flags = list()
		if(R.include_rights == R_EVERYTHING)
			flags += "flags"
		if(R.exclude_rights == R_EVERYTHING)
			flags += "exclude_flags"
		if(R.can_edit_rights == R_EVERYTHING)
			flags += "can_edit_flags"
		if(!flags.len)
			continue
		var/flags_to_check = flags.Join(" != [R_EVERYTHING] AND ") + " != [R_EVERYTHING]"
		var/datum/db_query/query_check_everything_ranks = SSdbcore.NewQuery(
			"SELECT flags, exclude_flags, can_edit_flags FROM [format_table_name("admin_ranks")] WHERE rank = :rank AND ([flags_to_check])",
			list("rank" = R.name)
		)
		if(!query_check_everything_ranks.Execute())
			qdel(query_check_everything_ranks)
			return
		if(query_check_everything_ranks.NextRow()) //no row is returned if the rank already has the correct flag value
			var/flags_to_update = flags.Join(" = [R_EVERYTHING], ") + " = [R_EVERYTHING]"
			var/datum/db_query/query_update_everything_ranks = SSdbcore.NewQuery(
				"UPDATE [format_table_name("admin_ranks")] SET [flags_to_update] WHERE rank = :rank",
				list("rank" = R.name)
			)
			if(!query_update_everything_ranks.Execute())
				qdel(query_update_everything_ranks)
				return
			qdel(query_update_everything_ranks)
		qdel(query_check_everything_ranks)
