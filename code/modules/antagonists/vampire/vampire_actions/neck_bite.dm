/datum/action/cooldown/neck_bite
	name = "Feed"
	desc = "Sate the thirst by sinking your teeth into the neck of a humanoid."
	button_icon = 'goon/icons/actions.dmi'
	button_icon_state = "bite"

	check_flags = AB_CHECK_CONSCIOUS | AB_CHECK_HANDS_BLOCKED

/datum/action/cooldown/neck_bite/process()
	// Kind of hacky but I can't be bothered to care. We can accurately track all unavailable -> available transitions, but not the other way around.
	if(IsAvailable())
		build_all_button_icons(UPDATE_BUTTON_STATUS)

/datum/action/cooldown/neck_bite/Grant(mob/granted_to)
	. = ..()
	RegisterSignal(granted_to, list(COMSIG_LIVING_START_GRAB, COMSIG_LIVING_NO_LONGER_GRABBING, COMSIG_LIVING_GRAB_DOWNGRADE, COMSIG_LIVING_GRAB_UPGRADE), PROC_REF(on_owner_grab_change))
	START_PROCESSING(SSslowprocess, src)

/datum/action/cooldown/neck_bite/Remove(mob/removed_from)
	. = ..()
	UnregisterSignal(removed_from, list(COMSIG_LIVING_START_GRAB, COMSIG_LIVING_NO_LONGER_GRABBING, COMSIG_LIVING_GRAB_DOWNGRADE, COMSIG_LIVING_GRAB_UPGRADE))
	START_PROCESSING(SSslowprocess, src)

/datum/action/cooldown/neck_bite/IsAvailable(feedback)
	. = ..()
	if(!.)
		return

	var/error = ""
	if(!select_target(&error))
		if(feedback && error)
			to_chat(owner, span_warning(error))
		return FALSE

	return TRUE

/datum/action/cooldown/neck_bite/Activate(atom/target)
	var/mob/living/carbon/human/user = target
	var/mob/living/carbon/human/victim = select_target()

	var/datum/antagonist/vampire/vamp_datum = user.mind.has_antag_datum(/datum/antagonist/vampire)
	var/datum/callback/checks_callback = CALLBACK(src, PROC_REF(can_bite), user, victim)

	if(vamp_datum.thirst_stage != THIRST_STAGE_BLOODLUST)
		if(!do_after(user, victim, 3 SECONDS, DO_IGNORE_HELD_ITEM|DO_IGNORE_SLOWDOWNS|DO_PUBLIC, extra_checks = checks_callback, display = image('goon/icons/actions.dmi', "bite")))
			return FALSE

	. = ..()

	spawn(-1)
		user.visible_message(span_danger("<b>[user]</b> bites down on <b>[victim]</b>'s neck."), vision_distance = COMBAT_MESSAGE_RANGE)

		ADD_TRAIT(user, TRAIT_MUTE, ref(src))
		ADD_TRAIT(victim, TRAIT_MUTE, ref(src))
		var/obj/item/bodypart/head/head = victim.get_bodypart(BODY_ZONE_HEAD)
		head.create_wound_easy(/datum/wound/neck_bite, 10)

		var/image/succ_image = image('goon/icons/actions.dmi', "blood")
		while(TRUE)
			if(!can_bite(user, victim))
				break

			if(!do_after(user, victim, 1 SECOND, DO_IGNORE_HELD_ITEM|DO_IGNORE_SLOWDOWNS|DO_PUBLIC, extra_checks = checks_callback, display = succ_image))
				user.visible_message(span_notice("<b>[user]</b> removes [p_their()] teeth from </b>[victim]</b>'s neck."))
				break

			siphon_blood(user, victim)

		REMOVE_TRAIT(victim, TRAIT_MUTE, ref(src))
		REMOVE_TRAIT(user, TRAIT_MUTE, ref(src))

/datum/action/cooldown/neck_bite/proc/siphon_blood(mob/living/carbon/human/user, mob/living/carbon/human/victim)
	user.visible_message(span_danger("<b>[user]</b> siphons blood from <b>[victim]</b>'s neck."), vision_distance = COMBAT_MESSAGE_RANGE, ignored_mobs = victim)
	if(victim.stat == CONSCIOUS)
		to_chat(victim, span_danger("You can feel blood draining from your neck."))

	if(isturf(victim.loc))
		victim.add_splatter_floor(victim.loc, TRUE)

	GLOB.blood_controller.drain_blood(victim, VAMPIRE_BLOOD_DRAIN_RATE)

	victim.adjustBloodVolume(-VAMPIRE_BLOOD_DRAIN_RATE)
	user.adjustBloodVolumeUpTo(VAMPIRE_BLOOD_DRAIN_RATE, BLOOD_VOLUME_NORMAL + 100)

	if(user.nutrition < NUTRITION_LEVEL_FULL)
		user.set_nutrition(min(user.nutrition + 10, NUTRITION_LEVEL_FULL))
		user.satiety = min(user.satiety + 20, MAX_SATIETY)

	user.heal_overall_damage(2.5, 2.5, BODYTYPE_ORGANIC)

	var/datum/antagonist/vampire/vamp_datum = user.mind.has_antag_datum(/datum/antagonist/vampire)
	vamp_datum.thirst_level.remove_points(VAMPIRE_BLOOD_DRAIN_RATE * VAMPIRE_BLOOD_THIRST_EXCHANGE_COEFF)
	vamp_datum.update_thirst_stage()

	if(!(WEAKREF(victim) in vamp_datum.past_victim_refs))
		vamp_datum.past_victim_refs += WEAKREF(victim)
		var/datum/action/cooldown/blood_track/track = locate() in owner.actions
		if(track)
			track.build_all_button_icons(UPDATE_BUTTON_STATUS)

	victim.add_trace_DNA(user, user.get_trace_dna())

	// Draining an opposing vampire really, really messes them up.
	var/datum/antagonist/vampire/victim_vamp_datum = victim.mind?.has_antag_datum(/datum/antagonist/vampire)
	if(victim_vamp_datum)
		victim_vamp_datum.thirst_level.add_points(-(VAMPIRE_BLOOD_DRAIN_RATE * VAMPIRE_BLOOD_THIRST_EXCHANGE_COEFF))
		victim_vamp_datum.update_thirst_stage()

	else if(prob(1)) // A chance to spread the plague!
		var/datum/pathogen/blood_plague/vampirism = new /datum/pathogen/blood_plague
		if(victim.try_contract_pathogen(vampirism, FALSE, TRUE))
			message_admins("[key_name_admin(user)] spread The Sanguine Plague to [key_name_admin(victim)].")
			log_game("ANTAGS: [key_name(user)] spread The Sanguine Plague to [key_name(victim)].")

	build_all_button_icons(UPDATE_BUTTON_STATUS)

/datum/action/cooldown/neck_bite/proc/can_bite(mob/living/carbon/human/user, mob/living/carbon/human/victim, error_string_ptr)
	if(!owner)
		return FALSE

	if(victim.stat == DEAD)
		if(error_string_ptr)
			*error_string_ptr = "You cannot feast on the dead."
		return FALSE

	if(!user.is_grabbing(victim))
		return FALSE

	var/obj/item/bodypart/head/head = victim.get_bodypart(BODY_ZONE_HEAD)
	if(!head || !IS_ORGANIC_LIMB(head))
		if(error_string_ptr)
			*error_string_ptr = "[victim] does not have a neck."
		return FALSE

	if(victim.blood_volume < VAMPIRE_BLOOD_DRAIN_PER_TARGET)
		if(error_string_ptr)
			*error_string_ptr = "[victim] does not have enough blood."
		return FALSE

	if(GLOB.blood_controller.get_blood_remaining(victim) < VAMPIRE_BLOOD_DRAIN_RATE)
		if(error_string_ptr)
			*error_string_ptr = "You must wait before draining [victim] again."
		return FALSE

	return TRUE

/// Gets a possible victim, or returns null.
/datum/action/cooldown/neck_bite/proc/select_target(error_string_ptr)
	var/mob/living/carbon/human/user = owner

	if(!length(user.active_grabs))
		if(error_string_ptr)
			*error_string_ptr = "You aren't holding anyone."
		return null

	var/datum/antagonist/vampire/vamp_datum = user.mind.has_antag_datum(/datum/antagonist/vampire)

	var/needed_grab = vamp_datum.thirst_stage == THIRST_STAGE_BLOODLUST ? GRAB_AGGRESSIVE : GRAB_NECK

	for(var/obj/item/hand_item/grab/grab in user.active_grabs)
		var/mob/living/carbon/human/potential_victim = grab.affecting
		if(!ishuman(potential_victim) || ismonkey(potential_victim))
			if(ismob(potential_victim) && error_string_ptr)
				*error_string_ptr = "You cannot feast on [potential_victim]."
			continue

		if((grab.current_grab.damage_stage < needed_grab))
			if(error_string_ptr)
				*error_string_ptr = "You need a stronger grip on [potential_victim]."
			continue

		if(can_bite(user, potential_victim, error_string_ptr))
			return potential_victim

	return null

/// Called when the owner grabs or releases an object.
/datum/action/cooldown/neck_bite/proc/on_owner_grab_change(datum/source)
	SIGNAL_HANDLER

	build_all_button_icons(UPDATE_BUTTON_STATUS)
