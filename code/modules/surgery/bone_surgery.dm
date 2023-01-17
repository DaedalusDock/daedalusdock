/datum/surgery/repair_bone
	name = "Repair bone fracture"
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/repair_bone,
		/datum/surgery_step/set_bone,
		/datum/surgery_step/close)
	target_mobtypes = list(/mob/living/carbon/human)
	possible_locs = list(BODY_ZONE_R_ARM,BODY_ZONE_L_ARM,BODY_ZONE_R_LEG,BODY_ZONE_L_LEG,BODY_ZONE_CHEST,BODY_ZONE_HEAD)
	requires_real_bodypart = TRUE

/datum/surgery/repair_bone/can_start(mob/living/user, mob/living/carbon/target)
	if(!istype(target))
		return FALSE
	if(..())
		var/obj/item/bodypart/targeted_bodypart = target.get_bodypart(user.zone_selected)
		return(targeted_bodypart.check_bones() & CHECKBONES_BROKEN)

/datum/surgery_step/set_bone
	name = "set bone (bonesetter)"
	implements = list(
		/obj/item/bonesetter = 100,
		TOOL_CROWBAR = 30,
	)
	time = 40

/datum/surgery_step/set_bone/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(surgery.operated_bodypart.check_bones() & CHECKBONES_BROKEN)
		display_results(user, target, span_notice("You begin to reset the bone in [target]'s [parse_zone(user.zone_selected)]..."),
			span_notice("[user] begins to reset the bone in [target]'s [parse_zone(user.zone_selected)] with [tool]."),
			span_notice("[user] begins to reset the bone in [target]'s [parse_zone(user.zone_selected)]."))
		display_pain(target, "Your [parse_zone(user.zone_selected)] aches with pain!")
	else
		user.visible_message(span_notice("[user] looks for [target]'s [parse_zone(user.zone_selected)]."), span_notice("You look for [target]'s [parse_zone(user.zone_selected)]..."))


/datum/surgery_step/set_bone/success(mob/living/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	if(surgery.operated_bodypart.check_bones() & CHECKBONES_BROKEN)
		display_results(user, target, span_notice("You successfully reset the bone in [target]'s [parse_zone(target_zone)]."),
			span_notice("[user] successfully reset the bone in [target]'s [parse_zone(target_zone)] with [tool]!"),
			span_notice("[user] successfully reset the bone in [target]'s [parse_zone(target_zone)]!"))
		log_combat(user, target, "reset the bone in", addition="COMBAT_MODE: [uppertext(user.combat_mode)]")
		surgery.operated_bodypart.heal_bones()

	else if(surgery.operated_bodypart.check_bones() & CHECKBONES_OK)
		display_results(user, target,
			span_notice("You successfully set the bone in the WRONG place in [target]'s [parse_zone(target_zone)]."),
			span_notice("[user] successfully set the bone in the WRONG place in [target]'s [parse_zone(target_zone)] with [tool]!"),
			span_notice("[user] successfully set the bone in the WRONG place in [target]'s [parse_zone(target_zone)]!")
		)
		log_combat(usr, target, "incorrectly set a bone in ", addition="COMBAT_MODE: [uppertext(user.combat_mode)]")
		surgery.operated_bodypart.break_bones()
	else
		to_chat(user, span_notice("There is no bone there!"))

	return ..()

/datum/surgery_step/set_bone/failure(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery, fail_prob = 0)
	..()
	if(istype(tool, /obj/item/stack))
		var/obj/item/stack/used_stack = tool
		used_stack.use(1)
	if(surgery.operated_bodypart.check_bones() & CHECKBONES_OK)
		surgery.operated_bodypart.break_bones()
		surgery.operated_bodypart.receive_damage(5)

/datum/surgery_step/repair_bone
	name = "repair bone (gel/tape)"
	implements = list(
		/obj/item/stack/medical/bone_gel = 100,
		/obj/item/stack/sticky_tape/surgical = 100,
		/obj/item/stack/sticky_tape/super = 50,
		/obj/item/stack/sticky_tape = 30
	)
	time = 4 SECONDS

/datum/surgery_step/repair_bone/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_notice("You begin to repair the fracture in [target]'s [parse_zone(user.zone_selected)]..."),
		span_notice("[user] begins to repair the fracture in [target]'s [parse_zone(user.zone_selected)] with [tool]."),
		span_notice("[user] begins to repair the fracture in [target]'s [parse_zone(user.zone_selected)]."))
	display_pain(target, "Your [parse_zone(user.zone_selected)] aches with pain!")

	return ..()


/datum/surgery_step/repair_bone/success(mob/living/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	if(istype(tool, /obj/item/stack))
		var/obj/item/stack/used_stack = tool
		used_stack.use(1)
	display_results(user, target, span_notice("You successfully repair the fracture in [target]'s [parse_zone(target_zone)]."),
		span_notice("[user] successfully repairs the fracture in [target]'s [parse_zone(target_zone)] with [tool]!"),
		span_notice("[user] successfully repairs the fracture in [target]'s [parse_zone(target_zone)]!"))
	log_combat(user, target, "repaired a broken bone in", addition="COMBAT_MODE: [uppertext(user.combat_mode)]")

	return ..()


