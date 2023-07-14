/datum/surgery_step/tend_wounds
	name = "Repair physical trauma"
	surgery_candidate_flags = SURGERY_NO_ROBOTIC
	allowed_tools = list(
		TOOL_HEMOSTAT = 100
	)
	looping = TRUE
	min_duration = 1 SECONDS
	max_duration = 2 SECONDS
	var/damage_type = BRUTE

	preop_sound = list('sound/surgery/hemostat1.ogg', 'sound/surgery/scalpel1.ogg')

/datum/surgery_step/tend_wounds/pre_surgery_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	. = affected.get_damage() >= affected.max_damage * 0.5
	if(!.)
		to_chat(user, span_warning("[target]'s [affected.plaintext_zone] cannot be repaired any more through surgery."))

/datum/surgery_step/tend_wounds/begin_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	user.visible_message(span_notice("[user] starts to mend [target]'s [affected.plaintext_zone]."))
	..()

/datum/surgery_step/tend_wounds/succeed_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	..()
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	user.visible_message(span_notice("[user] successfully mends [target]'s [affected.plaintext_zone]."))
	if(damage_type == BRUTE)
		affected.heal_damage(15)
	else
		affected.heal_damage(0, 15)

/datum/surgery_step/tend_wounds/burn
	name = "Repair third degree burns"
	damage_type = BURN

/datum/surgery_step/tend_wounds/robotic
	surgery_candidate_flags = SURGERY_NO_FLESH
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

/datum/surgery_step/tend_wounds/robotic/succeed_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	..()
	tool.use(1)

/datum/surgery_step/tend_wounds/robotic/burn
	name = "Repair third degree burns"
	surgery_candidate_flags = SURGERY_NO_FLESH
