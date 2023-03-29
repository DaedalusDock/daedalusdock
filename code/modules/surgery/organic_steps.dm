
//make incision
/datum/surgery_step/incise
	name = "make incision"
	implements = list(
		TOOL_SCALPEL = 100,
		/obj/item/melee/energy/sword = 75,
		/obj/item/knife = 65,
		/obj/item/shard = 45,
		/obj/item = 30) // 30% success with any sharp item.
	time = 16
	preop_sound = 'sound/surgery/scalpel1.ogg'
	success_sound = 'sound/surgery/scalpel2.ogg'

/datum/surgery_step/incise/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(surgery.operated_bodypart?.how_open())
		var/datum/wound/incision = surgery.operated_bodypart.get_incision()
		to_chat(user, span_notice("The [incision.desc] provides enough access."))
		return TRUE

	display_results(user, target, span_notice("You begin to make an incision in [target]'s [parse_zone(target_zone)]..."),
		span_notice("[user] begins to make an incision in [target]'s [parse_zone(target_zone)]."),
		span_notice("[user] begins to make an incision in [target]'s [parse_zone(target_zone)]."))
	display_pain(target, "You feel a stabbing in your [parse_zone(target_zone)].")

/datum/surgery_step/incise/tool_check(mob/user, obj/item/tool)
	if(implement_type == /obj/item && !tool.get_sharpness())
		return FALSE

	return TRUE

/datum/surgery_step/incise/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	if ishuman(target)
		var/mob/living/carbon/human/human_target = target
		if (!(NOBLOOD in human_target.dna.species.species_traits))
			display_results(user, target, span_notice("Blood pools around the incision in [human_target]'s [parse_zone(target_zone)]."),
				span_notice("Blood pools around the incision in [human_target]'s [parse_zone(target_zone)]."),
				span_notice("Blood pools around the incision in [human_target]'s [parse_zone(target_zone)]."))
			var/obj/item/bodypart/target_bodypart = target.get_bodypart(target_zone)
			if(target_bodypart)
				target_bodypart.adjustBleedStacks(10)
				target_bodypart.create_wound(WOUND_CUT, target_bodypart.minimum_break_damage/2, TRUE)
	return ..()

/datum/surgery_step/incise/nobleed/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_notice("You begin to <i>carefully</i> make an incision in [target]'s [parse_zone(target_zone)]..."),
		span_notice("[user] begins to <i>carefully</i> make an incision in [target]'s [parse_zone(target_zone)]."),
		span_notice("[user] begins to <i>carefully</i> make an incision in [target]'s [parse_zone(target_zone)]."))
	display_pain(target, "You feel a <i>careful</i> stabbing in your [parse_zone(target_zone)].")

//clamp bleeders
/datum/surgery_step/clamp_bleeders
	name = "clamp bleeders"
	implements = list(
		TOOL_HEMOSTAT = 100,
		TOOL_WIRECUTTER = 60,
		/obj/item/stack/package_wrap = 35,
		/obj/item/stack/cable_coil = 15)
	time = 24
	preop_sound = 'sound/surgery/hemostat1.ogg'

/datum/surgery_step/clamp_bleeders/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_notice("You begin to clamp bleeders in [target]'s [parse_zone(target_zone)]..."),
		span_notice("[user] begins to clamp bleeders in [target]'s [parse_zone(target_zone)]."),
		span_notice("[user] begins to clamp bleeders in [target]'s [parse_zone(target_zone)]."))
	display_pain(target, "You feel a pinch as the bleeding in your [parse_zone(target_zone)] is slowed.")

/datum/surgery_step/clamp_bleeders/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results)
	if (ishuman(target))
		var/mob/living/carbon/human/human_target = target
		var/obj/item/bodypart/target_bodypart = human_target.get_bodypart(target_zone)
		if(target_bodypart)
			target_bodypart.clamp_wounds()
	return ..()

//retract skin
/datum/surgery_step/retract_skin
	name = "retract skin"
	implements = list(
		TOOL_RETRACTOR = 100,
		TOOL_SCREWDRIVER = 45,
		TOOL_WIRECUTTER = 35,
		/obj/item/stack/rods = 35)
	time = 24
	preop_sound = 'sound/surgery/retractor1.ogg'
	success_sound = 'sound/surgery/retractor2.ogg'

/datum/surgery_step/retract_skin/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/obj/item/bodypart/affected = surgery.operated_bodypart
	if(affected)
		if(affected.how_open() >= SURGERY_RETRACTED)
			var/datum/wound/cut/incision = affected.get_incision()
			to_chat(user, span_notice("The [incision.desc] provides enough access, a larger incision isn't needed."))
			return TRUE

	display_results(user, target, span_notice("You begin to retract the skin in [target]'s [parse_zone(target_zone)]..."),
		span_notice("[user] begins to retract the skin in [target]'s [parse_zone(target_zone)]."),
		span_notice("[user] begins to retract the skin in [target]'s [parse_zone(target_zone)]."))
	display_pain(target, "You feel a severe stinging pain spreading across your [parse_zone(target_zone)] as the skin is pulled back!")

/datum/surgery_step/retract_skin/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results)
	if(surgery.operated_bodypart)
		surgery.operated_bodypart.open_incision()
		surgery.operated_bodypart.update_damage()
	return ..()

/datum/surgery_step/retract_skin/failure(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery, fail_prob)
	display_results(user, target,
		span_warning("Your hand slips, tearing the edges of the incision on [target]'s [surgery.operated_bodypart.name] with [tool]!"),
		span_warning("[user]'s hand slips, tearing the edges of the incision on [target]'s [surgery.operated_bodypart.name] with [tool]!")
	)
	display_pain(target, "You feel a stinging pain on your [parse_zone(target_zone)]")
	if(surgery.operated_bodypart)
		surgery.operated_bodypart.receive_damage(12, sharpness = (SHARP_EDGED|SHARP_POINTY))
	return ..()

//close incision
/datum/surgery_step/close
	name = "mend incision"
	implements = list(
		TOOL_CAUTERY = 100,
		/obj/item/gun/energy/laser = 90,
		TOOL_WELDER = 70,
		/obj/item = 30) // 30% success with any hot item.
	time = 24
	preop_sound = 'sound/surgery/cautery1.ogg'
	success_sound = 'sound/surgery/cautery2.ogg'

/datum/surgery_step/close/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_notice("You begin to mend the incision in [target]'s [parse_zone(target_zone)]..."),
		span_notice("[user] begins to mend the incision in [target]'s [parse_zone(target_zone)]."),
		span_notice("[user] begins to mend the incision in [target]'s [parse_zone(target_zone)]."))
	display_pain(target, "Your [parse_zone(target_zone)] is being burned!")

/datum/surgery_step/close/tool_check(mob/user, obj/item/tool)
	if(implement_type == TOOL_WELDER || implement_type == /obj/item)
		return tool.get_temperature()

	return TRUE

/datum/surgery_step/close/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results)
	if (ishuman(target))
		var/mob/living/carbon/human/human_target = target
		var/obj/item/bodypart/target_bodypart = human_target.get_bodypart(target_zone)
		var/datum/wound/W = target_bodypart.get_incision()
		if(W)
			W.close_wound()
		if(target_bodypart.clamped())
			target_bodypart.remove_clamps()

		target_bodypart.update_damage() //Also calls refresh_bleed_rate()

	return ..()



//saw bone
/datum/surgery_step/saw
	name = "saw bone"
	implements = list(
		TOOL_SAW = 100,
		/obj/item/melee/arm_blade = 75,
		/obj/item/fireaxe = 50,
		/obj/item/hatchet = 35,
		/obj/item/knife/butcher = 25,
		/obj/item = 20) //20% success (sort of) with any sharp item with a force>=10
	time = 54
	preop_sound = list(
		/obj/item/circular_saw = 'sound/surgery/saw.ogg',
		/obj/item/melee/arm_blade = 'sound/surgery/scalpel1.ogg',
		/obj/item/fireaxe = 'sound/surgery/scalpel1.ogg',
		/obj/item/hatchet = 'sound/surgery/scalpel1.ogg',
		/obj/item/knife/butcher = 'sound/surgery/scalpel1.ogg',
		/obj/item = 'sound/surgery/scalpel1.ogg',
	)
	success_sound = 'sound/surgery/organ2.ogg'

/datum/surgery_step/saw/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_notice("You begin to saw through the bone in [target]'s [parse_zone(target_zone)]..."),
		span_notice("[user] begins to saw through the bone in [target]'s [parse_zone(target_zone)]."),
		span_notice("[user] begins to saw through the bone in [target]'s [parse_zone(target_zone)]."))
	display_pain(target, "You feel a horrid ache spread through the inside of your [parse_zone(target_zone)]!")

/datum/surgery_step/saw/tool_check(mob/user, obj/item/tool)
	if(implement_type == /obj/item && !(tool.get_sharpness() && (tool.force >= 10)))
		return FALSE
	return TRUE

/datum/surgery_step/saw/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results)
	surgery.operated_bodypart.break_bones()
	display_results(user, target, span_notice("You saw [target]'s [parse_zone(target_zone)] open."),
		span_notice("[user] saws [target]'s [parse_zone(target_zone)] open!"),
		span_notice("[user] saws [target]'s [parse_zone(target_zone)] open!"))
	display_pain(target, "It feels like something just broke in your [parse_zone(target_zone)]!")
	return ..()

//drill bone
/datum/surgery_step/drill
	name = "drill bone"
	implements = list(
		TOOL_DRILL = 100,
		/obj/item/screwdriver/power = 80,
		/obj/item/pickaxe/drill = 60,
		TOOL_SCREWDRIVER = 25,
		/obj/item/kitchen/spoon = 20)
	time = 30

/datum/surgery_step/drill/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_notice("You begin to drill into the bone in [target]'s [parse_zone(target_zone)]..."),
		span_notice("[user] begins to drill into the bone in [target]'s [parse_zone(target_zone)]."),
		span_notice("[user] begins to drill into the bone in [target]'s [parse_zone(target_zone)]."))
	display_pain(target, "You feel a horrible piercing pain in your [parse_zone(target_zone)]!")

/datum/surgery_step/drill/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	display_results(user, target, span_notice("You drill into [target]'s [parse_zone(target_zone)]."),
		span_notice("[user] drills into [target]'s [parse_zone(target_zone)]!"),
		span_notice("[user] drills into [target]'s [parse_zone(target_zone)]!"))
	return ..()
