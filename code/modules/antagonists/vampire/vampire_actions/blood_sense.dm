/datum/action/cooldown/blood_sense
	name = "Blood Sense"
	desc = "Find out information about a target using their scent."
	button_icon = 'goon/icons/actions.dmi'
	button_icon_state = "blood_static"

	ranged_mousepointer = 'icons/effects/mouse_pointers/cult_target.dmi'

	cooldown_time = 15 SECONDS
	click_to_activate = TRUE

/datum/action/cooldown/blood_sense/is_valid_target(atom/cast_on)
	. = ..()
	if(cast_on == owner)
		return FALSE

	if(!ishuman(cast_on))
		return FALSE

/datum/action/cooldown/blood_sense/Activate(atom/target)
	var/mob/living/carbon/human/human_owner = owner
	if(human_owner.internal || human_owner.external)
		to_chat(owner, span_warning("You are unable to catch a scent while wearing [human_owner.internal || human_owner.external]."))
		return

	var/turf/T = get_turf(owner)
	if(T.is_below_sound_pressure())
		to_chat(owner, span_notice("You are unable to catch a scent here."))
		return

	. = ..()

	owner.emote("sniff")

	var/list/message = list()
	var/mob/living/carbon/human/human_target = target

	if(IS_VAMPIRE(human_target))
		var/datum/antagonist/vampire/target_vampire_datum = human_target.mind.has_antag_datum(/datum/antagonist/vampire)
		message += "[human_target.p_they(TRUE)] [human_target.p_are()] an Afflicted."
		if(target_vampire_datum.thirst_stage >= THIRST_STAGE_HUNGRY)
			message += "[human_target.p_they(TRUE)] [human_target.p_are()] <b>[target_vampire_datum.get_thirst_stage_string()].</b>"

	else if(IS_CHANGELING(human_target))
		message += "It is neither human nor Afflicted."

	else if(IS_CULTIST(human_target))
		message += "[human_target.p_their(TRUE)] blood is foul, you should stay away."

	var/blood_remaining = GLOB.blood_controller.get_blood_remaining(target)
	if(blood_remaining == VAMPIRE_BLOOD_DRAIN_PER_TARGET)
		message += "[human_target.p_they(TRUE)] appear[human_target.p_s()] juicy and full of life."

	else if(blood_remaining in ceil(VAMPIRE_BLOOD_DRAIN_PER_TARGET * 0.66) to VAMPIRE_BLOOD_DRAIN_PER_TARGET) //66% to 100%
		message += "[human_target.p_they(TRUE)] appear[human_target.p_s()] quite ripe."

	else if(blood_remaining in ceil(VAMPIRE_BLOOD_DRAIN_PER_TARGET * 0.33) to ceil(VAMPIRE_BLOOD_DRAIN_PER_TARGET * 0.66)) // 33% to 66%
		message += "[human_target.p_they(TRUE)] appear[human_target.p_s()] to be a suitable meal."

	else
		message += "[human_target.p_they(TRUE)] appear[human_target.p_s()] to have little left to offer."

	to_chat(owner, span_obviousnotice(jointext(message, "<br>")))
