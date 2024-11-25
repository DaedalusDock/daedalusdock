/datum/action/cooldown/neck_bite
	name = "Neck Bite"
	check_flags = AB_CHECK_CONSCIOUS | AB_CHECK_HANDS_BLOCKED

/datum/action/cooldown/neck_bite/Activate(atom/target)
	var/mob/living/carbon/human/user = target
	var/mob/living/carbon/human/victim

	for(var/obj/item/hand_item/grab/grab in user.active_grabs)
		if((grab.current_grab.damage_stage < GRAB_NECK) || !ishuman(grab.affecting))
			continue

		if(can_bite(user, grab.affecting))
			victim = grab.affecting
			break

	if(isnull(victim))
		return FALSE


	user.visible_message(span_danger("[user] bites down on [victim]'s neck!"), vision_distance = COMBAT_MESSAGE_RANGE)

	var/datum/callback/checks_callback = CALLBACK(src, PROC_REF(can_bite), user, victim)
	if(!do_after(user, victim, 3 SECONDS, IGNORE_HELD_ITEM|IGNORE_SLOWDOWNS|DO_PUBLIC, extra_checks = checks_callback, display = image('goon/icons/actions.dmi', "bite")))
		return FALSE

	. = ..()

	spawn(-1)
		var/image/succ_image = image('goon/icons/actions.dmi', "blood")
		while(TRUE)
			if(!can_bite(user, victim))
				break

			if(!do_after(user, victim, 1 SECOND, IGNORE_HELD_ITEM|IGNORE_SLOWDOWNS|DO_PUBLIC, extra_checks = checks_callback, display = succ_image))
				break

			siphon_blood(user, victim)

/datum/action/cooldown/neck_bite/proc/siphon_blood(mob/living/carbon/human/user, mob/living/carbon/human/victim)
	user.visible_message(span_danger("[user] siphons blood from [victim]'s neck!"), vision_distance = COMBAT_MESSAGE_RANGE, ignored_mobs = victim)
	if(victim.stat == CONSCIOUS)
		to_chat(victim, span_danger("You can feel blood draining from your neck."))

	if(isturf(victim.loc))
		victim.add_splatter_floor(victim.loc, TRUE)

	victim.adjustBloodVolume(-10)
	user.adjustBloodVolumeUpTo(10, BLOOD_VOLUME_NORMAL)

	var/datum/antagonist/vampire/vamp_datum = user.mind.has_antag_datum(/datum/antagonist/vampire)
	vamp_datum.thirst_level.remove_points(2)

/datum/action/cooldown/neck_bite/proc/can_bite(mob/living/carbon/human/user, mob/living/carbon/human/victim)
	if(!owner)
		return FALSE

	if(victim.stat == DEAD)
		return FALSE

	if(!user.is_grabbing(victim))
		return FALSE

	var/obj/item/bodypart/head/head = victim.get_bodypart(BODY_ZONE_HEAD)
	if(!head || !IS_ORGANIC_LIMB(head))
		return FALSE

	if(victim.blood_volume < 100)
		return FALSE

	return TRUE
