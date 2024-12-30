GLOBAL_VAR(posibrain_notify_cooldown)

/obj/item/organ/posibrain
	name = "positronic brain"
	desc = "A cube of shining metal, four inches to a side and covered in shallow grooves."
	icon = 'icons/obj/assemblies.dmi'
	icon_state = "posibrain"
	base_icon_state = "posibrain"
	w_class = WEIGHT_CLASS_NORMAL
	req_access = list(ACCESS_ROBOTICS)

	layer = ABOVE_MOB_LAYER
	zone = BODY_ZONE_CHEST
	slot = ORGAN_SLOT_POSIBRAIN
	organ_flags = ORGAN_SYNTHETIC

	organ_traits = list(TRAIT_ADVANCEDTOOLUSER, TRAIT_LITERATE, TRAIT_CAN_STRIP)

	maxHealth = 90
	low_threshold = 0.33
	high_threshold = 0.66
	relative_size = 60


	actions_types = list(
		/datum/action/innate/posibrain_print_laws,
		/datum/action/innate/posibrain_say_laws,
	)

	/// The current occupant.
	var/mob/living/brain/brainmob = null
	/// Populated by preferences, used for IPCs
	var/datum/ai_laws/shackles

	/// Keep track of suiciding
	var/suicided = FALSE

	///Message sent to the user when polling ghosts
	var/begin_activation_message = "<span class='notice'>You carefully locate the manual activation switch and start the positronic brain's boot process.</span>"
	///Message sent as a visible message on success
	var/success_message = "<span class='notice'>The positronic brain pings, and its lights start flashing. Success!</span>"
	///Message sent as a visible message on failure
	var/fail_message = "<span class='notice'>The positronic brain buzzes quietly, and the golden lights fade away. Perhaps you could try again?</span>"
	///Visible message sent when a player possesses the brain
	var/new_mob_message = "<span class='notice'>The positronic brain chimes quietly.</span>"
	///Examine message when the posibrain has no mob
	var/dead_message = "<span class='deadsay'>It appears to be completely inactive. The reset light is blinking.</span>"
	///Examine message when the posibrain cannot poll ghosts due to cooldown
	var/recharge_message = "<span class='warning'>The positronic brain isn't ready to activate again yet! Give it some time to recharge.</span>"

	///Can be set to tell ghosts what the brain will be used for
	var/ask_role = ""
	///Role assigned to the newly created mind
	var/posibrain_job_path = /datum/job/positronic_brain
	///World time tick when ghost polling will be available again
	var/next_ask
	///Delay after polling ghosts
	var/ask_delay = 60 SECONDS
	///One of these names is randomly picked as the posibrain's name on possession. If left blank, it will use the global posibrain names
	var/list/possible_names
	///Picked posibrain name
	var/picked_name
	///Whether this positronic brain is currently looking for a ghost to enter it.
	var/searching = FALSE
	///If it pings on creation immediately
	var/autoping = TRUE
	///List of all ckeys who has already entered this posibrain once before.
	var/list/ckeys_entered = list()

/obj/item/organ/posibrain/Initialize(mapload)
	. = ..()
	if(autoping)
		ping_ghosts("created", TRUE)
		create_brainmob()

/obj/item/organ/posibrain/Destroy(force)
	shackles = null
	if(brainmob)
		QDEL_NULL(brainmob)

	if(owner?.mind) //You aren't allowed to return to brains that don't exist
		owner.mind.set_current(null)
	return ..()

/obj/item/organ/posibrain/Topic(href, href_list)
	if(href_list["activate"])
		var/mob/dead/observer/ghost = usr
		if(istype(ghost))
			activate(ghost)

/obj/item/organ/posibrain/PreRevivalInsertion(special)
	if(brainmob)
		if(owner.key)
			owner.ghostize()

		if(brainmob.mind)
			brainmob.mind.transfer_to(owner)
		else
			owner.key = brainmob.key

		owner.set_suicide(brainmob.suiciding)

		QDEL_NULL(brainmob)

	else
		owner.set_suicide(suicided)

/obj/item/organ/posibrain/Insert(mob/living/carbon/C, special, drop_if_replaced)
	. = ..()
	if(!.)
		return

	name = initial(name)

/obj/item/organ/posibrain/Remove(mob/living/carbon/organ_owner, special)
	. = ..()
	if((!QDELING(src) || !QDELETED(owner)) && !special)
		transfer_identity(organ_owner)

/obj/item/organ/posibrain/on_life()
	if (!owner || owner.stat)
		return
	if (damage < (maxHealth * low_threshold))
		return

	if (prob(1) && !owner.has_status_effect(/datum/status_effect/confusion))
		to_chat(owner, span_warning("Your comprehension of spacial positioning goes temporarily awry."))
		owner.adjust_timed_status_effect(12 SECONDS, /datum/status_effect/confusion)

	if (prob(1) && owner.eye_blurry < 1)
		to_chat(owner, span_warning("Your optical interpretations become transiently erratic."))
		owner.adjust_blurriness(6)

	var/obj/item/organ/ears/E = owner.getorganslot(ORGAN_SLOT_EARS)
	if (E && prob(1) && E.deaf < 1)
		to_chat(owner, span_warning("Your capacity to differentiate audio signals briefly fails you."))
		E.deaf += 6
	if (prob(1) && !owner.has_status_effect(/datum/status_effect/speech/slurring))
		to_chat(owner, span_warning("Your ability to form coherent speech struggles to keep up."))
		owner.adjust_timed_status_effect(12 SECONDS, /datum/status_effect/speech/slurring/generic)

	if (damage < (maxHealth * high_threshold))
		return

	if (prob(2))
		if (prob(15) && !owner.IsSleeping())
			owner.visible_message("\The [owner] suddenly halts all activity.")
			owner.Sleeping(20 SECONDS)

		else if (owner.anchored || isspaceturf(get_turf(owner)))
			owner.visible_message("<i>\The [owner] seizes and twitches!</i>")
			owner.Stun(4 SECONDS)
		else
			owner.visible_message("<i>\The [owner] seizes and clatters down in a heap!</i>", null, pick("Clang!", "Crash!", "Clunk!"))
			owner.Knockdown(4 SECONDS)

	if (prob(2))
		var/obj/item/organ/cell/C = owner.getorganslot(ORGAN_SLOT_CELL)
		if (C && C.get_charge() > 250)
			C.use(250)
			to_chat(owner, span_warning("Your chassis power routine fluctuates wildly."))
			var/datum/effect_system/spark_spread/S = new
			S.set_up(2, 0, loc)
			S.start()

///Notify ghosts that the posibrain is up for grabs
/obj/item/organ/posibrain/proc/ping_ghosts(msg, newlymade)
	if(newlymade || GLOB.posibrain_notify_cooldown <= world.time)
		notify_ghosts("[name] [msg] in [get_area(src)]! [ask_role ? "Personality requested: \[[ask_role]\]" : ""]", ghost_sound = !newlymade ? 'sound/effects/ghost2.ogg':null, notify_volume = 75, enter_link = "<a href=?src=[REF(src)];activate=1>(Click to enter)</a>", source = src, action = NOTIFY_ATTACK, flashwindow = FALSE, ignore_key = POLL_IGNORE_POSIBRAIN, notify_suiciders = FALSE)
		if(!newlymade)
			GLOB.posibrain_notify_cooldown = world.time + ask_delay

/obj/item/organ/posibrain/attack_self(mob/user)
	if(!brainmob)
		create_brainmob()
	if(!(GLOB.ghost_role_flags & GHOSTROLE_SILICONS))
		to_chat(user, span_warning("Central Command has temporarily outlawed posibrain sentience in this sector..."))
	if(is_occupied())
		to_chat(user, span_warning("This [name] is already active!"))
		return
	if(next_ask > world.time)
		to_chat(user, recharge_message)
		return
	//Start the process of requesting a new ghost.
	to_chat(user, begin_activation_message)
	ping_ghosts("requested", FALSE)
	next_ask = world.time + ask_delay
	searching = TRUE
	update_appearance()
	addtimer(CALLBACK(src, PROC_REF(check_success)), ask_delay)

/obj/item/organ/posibrain/AltClick(mob/living/user)
	if(!istype(user) || !user.canUseTopic(src, USE_CLOSE))
		return
	var/input_seed = tgui_input_text(user, "Enter a personality seed", "Enter seed", ask_role, MAX_NAME_LEN)
	if(isnull(input_seed))
		return
	if(!istype(user) || !user.canUseTopic(src, USE_CLOSE))
		return
	to_chat(user, span_notice("You set the personality seed to \"[input_seed]\"."))
	ask_role = input_seed
	update_appearance()

/obj/item/organ/posibrain/proc/check_success()
	searching = FALSE
	update_appearance()
	if(QDELETED(brainmob))
		return
	if(brainmob.client)
		visible_message(success_message)
		playsound(src, 'sound/machines/ping.ogg', 15, TRUE)
	else
		visible_message(fail_message)

///ATTACK GHOST IGNORING PARENT RETURN VALUE
/obj/item/organ/posibrain/attack_ghost(mob/user)
	activate(user)

/obj/item/organ/posibrain/proc/is_occupied()
	if(brainmob.key)
		return TRUE
	if(iscyborg(loc))
		var/mob/living/silicon/robot/R = loc
		if(R.mmi == src)
			return TRUE
	return FALSE

///Two ways to activate a positronic brain. A clickable link in the ghost notif, or simply clicking the object itself.
/obj/item/organ/posibrain/proc/activate(mob/user)
	if(QDELETED(brainmob))
		return
	if(user.ckey in ckeys_entered)
		to_chat(user, span_warning("You cannot re-enter [src] a second time!"))
		return
	if(is_occupied() || is_banned_from(user.ckey, ROLE_POSIBRAIN) || QDELETED(brainmob) || QDELETED(src) || QDELETED(user))
		return
	if(user.suiciding) //if they suicided, they're out forever.
		to_chat(user, span_warning("[src] fizzles slightly. Sadly it doesn't take those who suicided!"))
		return
	var/posi_ask = tgui_alert(user, "Become a [name]? (Warning, You can no longer be revived, and all past lives will be forgotten!)", "Confirm", list("Yes","No"))
	if(posi_ask != "Yes" || QDELETED(src))
		return
	if(brainmob.suiciding) //clear suicide status if the old occupant suicided.
		brainmob.set_suicide(FALSE)
	transfer_personality(user)

/obj/item/organ/posibrain/proc/transfer_identity(mob/living/L)
	name = "[initial(name)] ([L])"

	if(brainmob)
		return
	if(!L.mind)
		return

	brainmob = new(src) //We dont use create_brainmob() because thats for ghost spawns
	brainmob.set_real_name(L.real_name)
	brainmob.timeofhostdeath = L.timeofdeath
	brainmob.suiciding = suicided
	if(L.has_dna())
		var/mob/living/carbon/C = L
		if(!brainmob.stored_dna)
			brainmob.stored_dna = new /datum/dna/stored(brainmob)
		C.dna.copy_dna(brainmob.stored_dna)
		if(HAS_TRAIT(L, TRAIT_BADDNA))
			LAZYSET(brainmob.status_traits, TRAIT_BADDNA, L.status_traits[TRAIT_BADDNA])
	if(L.mind && L.mind.current)
		L.mind.transfer_to(brainmob)

	brainmob.set_stat(CONSCIOUS)
	brainmob.grant_language(/datum/language/machine, TRUE, TRUE, LANGUAGE_MMI)
	update_appearance()

///Moves the candidate from the ghost to the posibrain
/obj/item/organ/posibrain/proc/transfer_personality(mob/candidate)
	if(QDELETED(brainmob))
		return
	if(is_occupied()) //Prevents hostile takeover if two ghosts get the prompt or link for the same brain.
		to_chat(candidate, span_warning("This [name] was taken over before you could get to it! Perhaps it might be available later?"))
		return FALSE
	if(candidate.mind && !isobserver(candidate))
		candidate.mind.transfer_to(brainmob)
	else
		brainmob.ckey = candidate.ckey
	name = "[initial(name)] ([brainmob.name])"
	var/policy = get_policy(ROLE_POSIBRAIN)
	if(policy)
		to_chat(brainmob, policy)
	brainmob.mind.set_assigned_role(SSjob.GetJobType(posibrain_job_path))
	brainmob.set_stat(CONSCIOUS)

	visible_message(new_mob_message)
	check_success()
	ckeys_entered |= brainmob.ckey
	return TRUE


/obj/item/organ/posibrain/examine(mob/user)
	. = ..()
	if(brainmob?.key)
		switch(brainmob.stat)
			if(CONSCIOUS)
				if(!brainmob.client)
					. += "It appears to be in stand-by mode." //afk
			if(DEAD)
				. += span_deadsay("It appears to be completely inactive.")
	else
		. += "[dead_message]"
		if(ask_role)
			. += span_notice("Current consciousness seed: \"[ask_role]\"")
		. += span_boldnotice("Alt-click to set a consciousness seed, specifying what [src] will be used for. This can help generate a personality interested in that role.")

/obj/item/organ/posibrain/update_icon_state()
	. = ..()
	if(searching)
		icon_state = "[base_icon_state]-searching"
		return
	if(brainmob?.key)
		icon_state = "[base_icon_state]-occupied"
		return
	icon_state = "[base_icon_state]"
	return

/obj/item/organ/posibrain/attackby(obj/item/O, mob/user, params)
	return

/// Proc to hook behavior associated to the change in value of the [/obj/item/mmi/var/brainmob] variable.
/obj/item/organ/posibrain/proc/set_brainmob(mob/living/brain/new_brainmob)
	if(brainmob == new_brainmob)
		return FALSE
	. = brainmob
	SEND_SIGNAL(src, COMSIG_MMI_SET_BRAINMOB, new_brainmob)
	brainmob = new_brainmob
	if(new_brainmob)
		ADD_TRAIT(new_brainmob, TRAIT_IMMOBILIZED, BRAIN_UNAIDED)
		ADD_TRAIT(new_brainmob, TRAIT_HANDS_BLOCKED, BRAIN_UNAIDED)
	if(.)
		var/mob/living/brain/old_brainmob = .
		ADD_TRAIT(old_brainmob, TRAIT_IMMOBILIZED, BRAIN_UNAIDED)
		ADD_TRAIT(old_brainmob, TRAIT_HANDS_BLOCKED, BRAIN_UNAIDED)

/obj/item/organ/posibrain/proc/create_brainmob()
	var/_brainmob = new /mob/living/brain(src)
	set_brainmob(_brainmob)

	var/new_name
	if(!LAZYLEN(possible_names))
		new_name = pick(GLOB.posibrain_names)
	else
		new_name = pick(possible_names)

	brainmob.set_real_name("[new_name]-[rand(100, 999)]")
	brainmob.forceMove(src)
	brainmob.container = src
	brainmob.grant_language(/datum/language/machine, TRUE, TRUE, LANGUAGE_MMI)

/obj/item/organ/posibrain/ipc
	autoping = FALSE
