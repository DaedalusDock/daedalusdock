/datum/surgery_step/insert_pill
	name = "Insert pill dental implant"
	desc = "Implants a pill for the patient to activate by biting down hard."
	allowed_tools = list(
		/obj/item/reagent_containers/pill = 100
	)
	min_duration = 1 SECOND
	max_duration = 3 SECONDS
	surgery_flags = SURGERY_NO_ROBOTIC | SURGERY_NO_STUMP | SURGERY_NEEDS_DEENCASEMENT

/datum/surgery_step/insert_pill/begin_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	. = ..()
	user.visible_message(span_notice("[user] begins inserting [tool] into [target]'s tooth."), vision_distance = COMBAT_MESSAGE_RANGE)

/datum/surgery_step/insert_pill/succeed_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!istype(tool, /obj/item/reagent_containers/pill)) //what
		return FALSE

	user.transferItemToLoc(tool, target, TRUE)

	var/datum/action/item_action/hands_free/activate_pill/pill_action = new(tool)
	pill_action.name = "Activate [tool.name]"
	pill_action.build_all_button_icons()
	pill_action.target = tool
	pill_action.Grant(target) //The pill never actually goes in an inventory slot, so the owner doesn't inherit actions from it

	user.visible_message(span_notice("[user] inserts [tool] into [target]'s tooth."), vision_distance = COMBAT_MESSAGE_RANGE)
	..()

/datum/surgery_step/insert_pill/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!istype(tool, /obj/item/reagent_containers/pill)) //what
		return

	var/obj/item/reagent_containers/pill/pill = tool
	pill.consume(target, user)
	user.visible_message(span_warning("[pill] slips out of [user]'s hand, right down [target]'s throat!"), vision_distance = COMBAT_MESSAGE_RANGE)
	..()

/datum/action/item_action/hands_free/activate_pill
	name = "Activate Pill"

/datum/action/item_action/hands_free/activate_pill/Trigger(trigger_flags)
	if(!..())
		return FALSE
	var/obj/item/item_target = target
	to_chat(owner, span_notice("You grit your teeth and burst the implanted [item_target.name]!"))
	log_combat(owner, null, "swallowed an implanted pill", target)
	if(item_target.reagents.total_volume)
		item_target.reagents.trans_to(owner, item_target.reagents.total_volume, transfered_by = owner, methods = INGEST)
	qdel(target)
	return TRUE
