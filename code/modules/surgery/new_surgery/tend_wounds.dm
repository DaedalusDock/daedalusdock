/datum/surgery_step/tend_wounds
	name = "Repair greivous physical trauma (organic)"
	desc = "Repairs extreme damage from cuts, bruises, and punctures."
	surgery_flags = SURGERY_NO_ROBOTIC
	allowed_tools = list(
		TOOL_HEMOSTAT = 100
	)
	looping = TRUE
	min_duration = 1 SECONDS
	max_duration = 2 SECONDS
	var/damage_type = BRUTE

	preop_sound = list('sound/surgery/hemostat1.ogg', 'sound/surgery/scalpel1.ogg')

/datum/surgery_step/tend_wounds/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = ..()
	if(!affected)
		return

	if(damage_type == BRUTE)
		if(affected.brute_dam >= affected.max_damage * 0.1)
			return affected
	else
		if(affected.burn_dam >= affected.max_damage * 0.1)
			return affected

/datum/surgery_step/tend_wounds/pre_surgery_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	if(damage_type == BRUTE)
		if(affected.brute_dam >= affected.max_damage * 0.1)
			. = TRUE
	else
		if(affected.burn_dam >= affected.max_damage * 0.1)
			. = TRUE
	if(!.)
		to_chat(user, span_warning("[target]'s [affected.plaintext_zone] [(damage_type == BRUTE) ? "trauma" : "burns"] cannot be repaired any more through surgery."))

/datum/surgery_step/tend_wounds/begin_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	user.visible_message(span_notice("[user] starts to mend [target]'s [affected.plaintext_zone]."), vision_distance = COMBAT_MESSAGE_RANGE)
	..()

/datum/surgery_step/tend_wounds/succeed_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	..()
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	user.visible_message(span_notice("[user] successfully mends [target]'s [affected.plaintext_zone]."), vision_distance = COMBAT_MESSAGE_RANGE)
	if(damage_type == BRUTE)
		affected.heal_damage(15)
	else
		affected.heal_damage(0, 15)

/datum/surgery_step/tend_wounds/burn
	name = "Repair third degree burns (organic)"
	desc = "Repairs extreme damage from burns."
	damage_type = BURN

/datum/surgery_step/tend_wounds/robotic
	name = "Repair greivous physical trauma (robotic)"
	desc = "Repairs extreme damage from dents or punctures"
	surgery_flags = SURGERY_NO_FLESH
	allowed_tools = list(
		TOOL_WELDER = 95
	)
	success_sound = 'sound/items/welder.ogg'

/datum/surgery_step/tend_wounds/robotic/pre_surgery_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	. = ..()
	if(!.)
		return

	if(!tool.tool_use_check(1))
		to_chat(user, span_warning("[tool] cannot be used right now."))
		return FALSE

/datum/surgery_step/tend_wounds/robotic/burn
	name = "Repair third degree burns (robotic)"
	desc = "Repairs extreme damage from burns."
	surgery_flags = SURGERY_NO_FLESH
