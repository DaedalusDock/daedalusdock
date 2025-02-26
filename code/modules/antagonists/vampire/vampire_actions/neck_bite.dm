/datum/action/cooldown/neck_bite
	name = "Feed"
	desc = "Sate the thirst by sinking your teeth into the neck of a humanoid."
	button_icon = 'goon/icons/actions.dmi'
	button_icon_state = "bite"

	check_flags = AB_CHECK_CONSCIOUS | AB_CHECK_HANDS_BLOCKED

	var/static/list/bitable_typecache

/datum/action/cooldown/neck_bite/New(Target, original)
	. = ..()
	if(isnull(bitable_typecache))
		var/list/to_typecache = typesof(/mob/living/carbon/human, /mob/living/simple_animal) - typesof(/mob/living/simple_animal/bot)
		bitable_typecache = typecacheof(to_typecache)

/datum/action/cooldown/neck_bite/process()
	// Kind of hacky but I can't be bothered to care. We can accurately track all unavailable -> available transitions, but not the other way around.
	if(IsAvailable())
		build_all_button_icons(UPDATE_BUTTON_STATUS)

/datum/action/cooldown/neck_bite/Grant(mob/granted_to)
	. = ..()
	RegisterSignal(
		granted_to,
		list(
			COMSIG_LIVING_START_GRAB,
			COMSIG_LIVING_NO_LONGER_GRABBING,
			COMSIG_LIVING_GRAB_DOWNGRADE,
			COMSIG_LIVING_GRAB_UPGRADE
		),
		PROC_REF(on_owner_grab_change)
	)
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
	var/mob/living/victim = select_target()

	var/datum/antagonist/vampire/vamp_datum = user.mind.has_antag_datum(/datum/antagonist/vampire)
	var/datum/callback/checks_callback = CALLBACK(src, PROC_REF(can_bite), user, victim)

	if(vamp_datum.thirst_stage != THIRST_STAGE_BLOODLUST)
		if(!do_after(user, victim, 3 SECONDS, DO_IGNORE_HELD_ITEM|DO_IGNORE_SLOWDOWNS|DO_PUBLIC, extra_checks = checks_callback, display = image('goon/icons/actions.dmi', "bite")))
			return FALSE

	. = ..()

	bite_mob(target, victim)


/// Called when biting a human.
/datum/action/cooldown/neck_bite/proc/bite_mob(mob/living/carbon/human/user, mob/living/victim)
	set waitfor = FALSE

	var/victim_is_human = ishuman(victim)
	var/message = "<b>[user]</b> bites down on <b>[victim]</b>."
	if(victim_is_human)
		message = "<b>[user]</b> bites down on <b>[victim]</b>'s neck."

	user.visible_message(span_danger("[message]"), vision_distance = COMBAT_MESSAGE_RANGE)

	ADD_TRAIT(user, TRAIT_MUTE, ref(src))
	ADD_TRAIT(victim, TRAIT_MUTE, ref(src))

	if(victim_is_human)
		var/obj/item/bodypart/head/head = victim.get_bodypart(BODY_ZONE_HEAD)
		head.create_wound_easy(/datum/wound/neck_bite, 10)

	var/datum/callback/checks_callback = CALLBACK(src, PROC_REF(can_bite), user, victim)
	var/image/succ_image = image('goon/icons/actions.dmi', "blood")

	while(TRUE)
		if(!can_bite(user, victim))
			break

		if(!do_after(user, victim, 1 SECOND, DO_IGNORE_HELD_ITEM|DO_IGNORE_SLOWDOWNS|DO_PUBLIC, extra_checks = checks_callback, display = succ_image))
			break

		siphon_blood(user, victim)

	var/message_remove = "<b>[user]</b> removes [user.p_their()] teeth from </b>[victim]</b>."
	if(victim_is_human)
		message_remove = "<b>[user]</b> removes [user.p_their()] teeth from </b>[victim]</b>'s neck."

	user.visible_message(span_notice("[message_remove]"))

	REMOVE_TRAIT(victim, TRAIT_MUTE, ref(src))
	REMOVE_TRAIT(user, TRAIT_MUTE, ref(src))

/datum/action/cooldown/neck_bite/proc/siphon_blood(mob/living/carbon/human/user, mob/living/victim)
	var/blood_delta = VAMPIRE_BLOOD_DRAIN_RATE
	var/thirst_delta = VAMPIRE_BLOOD_DRAIN_RATE * VAMPIRE_BLOOD_THIRST_EXCHANGE_COEFF

	var/victim_is_human = ishuman(victim)

	var/message = "<b>[user]</b> siphons blood from <b>[victim]</b>."
	if(victim_is_human)
		message = "<b>[user]</b> siphons blood from <b>[victim]</b>'s neck."

	user.visible_message(span_danger("[message]"), vision_distance = COMBAT_MESSAGE_RANGE, ignored_mobs = victim)

	if(victim_is_human && victim.stat == CONSCIOUS)
		to_chat(victim, span_danger("You feel blood being siphoned from your neck."))

	if(isturf(victim.loc))
		victim.add_splatter_floor(victim.loc, TRUE)

	GLOB.blood_controller.drain_blood(victim, victim_is_human ? blood_delta : 20)

	// Take blood from the victim. Or damage them
	if(victim_is_human)
		victim.adjustBloodVolume(-blood_delta)
	else
		victim.adjustBruteLoss(5)

	// Restore blood to the chomper.
	user.adjustBloodVolumeUpTo(blood_delta, BLOOD_VOLUME_NORMAL + 100)

	// Restore nutrition and health to the chomper.
	if(user.nutrition < NUTRITION_LEVEL_FULL)
		user.set_nutrition(min(user.nutrition + 10, NUTRITION_LEVEL_FULL))
		user.satiety = min(user.satiety + 20, MAX_SATIETY)

	user.heal_overall_damage(2.5, 2.5, BODYTYPE_ORGANIC)

	// Reduce Thirst of the chomper.
	var/datum/antagonist/vampire/vamp_datum = user.mind.has_antag_datum(/datum/antagonist/vampire)
	vamp_datum.thirst_level.remove_points(thirst_delta)
	vamp_datum.update_thirst_stage()

	// Add the chomper's saliva to the victim.
	victim.add_trace_DNA(user, user.get_trace_dna())

	// Add the victim to the blood track list.
	if(victim_is_human &&!(WEAKREF(victim) in vamp_datum.past_victim_refs))
		vamp_datum.past_victim_refs += WEAKREF(victim)
		var/datum/action/cooldown/blood_track/track = locate() in owner.actions
		if(track)
			track.build_all_button_icons(UPDATE_BUTTON_STATUS)

	// Draining an opposing vampire really, really messes them up.
	var/datum/antagonist/vampire/victim_vamp_datum = victim.mind?.has_antag_datum(/datum/antagonist/vampire)
	if(victim_vamp_datum)
		victim_vamp_datum.thirst_level.add_points(thirst_delta)
		victim_vamp_datum.update_thirst_stage()

	else if(victim_is_human && prob(1)) // A chance to spread the plague!
		var/datum/pathogen/blood_plague/vampirism = new /datum/pathogen/blood_plague
		if(victim.try_contract_pathogen(vampirism, FALSE, TRUE))
			message_admins("[key_name_admin(user)] spread The Sanguine Plague to [key_name_admin(victim)].")
			log_game("ANTAGS: [key_name(user)] spread The Sanguine Plague to [key_name(victim)].")

	build_all_button_icons(UPDATE_BUTTON_STATUS)

/datum/action/cooldown/neck_bite/proc/can_bite(mob/living/carbon/human/user, mob/living/victim, error_string_ptr)
	if(!owner)
		return FALSE

	if(victim.stat == DEAD)
		if(error_string_ptr)
			*error_string_ptr = "You cannot feast on the dead."
		return FALSE

	if(!user.is_grabbing(victim))
		return FALSE

	// Everything below this point requires a human.
	if(!ishuman(victim))
		return TRUE

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

	for(var/obj/item/hand_item/grab/grab in user.active_grabs)
		var/mob/living/potential_victim = grab.affecting
		if(!bitable_typecache[potential_victim.type] || !(potential_victim.mob_biotypes & MOB_ORGANIC))
			if(ismob(potential_victim) && error_string_ptr)
				*error_string_ptr = "You cannot feast on [potential_victim]."
			continue

		var/needed_grab = GRAB_AGGRESSIVE
		if(vamp_datum.thirst_stage != THIRST_STAGE_BLOODLUST && ishuman(potential_victim))
			needed_grab = GRAB_NECK

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
