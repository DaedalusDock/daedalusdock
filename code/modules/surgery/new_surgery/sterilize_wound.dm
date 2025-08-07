/datum/surgery_step/sterilize_wound
	name = "Sterilize wound"
	desc = "Sterilizes an open wound with a sterilizing reagent."
	allowed_tools = list(
		/obj/item/reagent_containers/spray = 100,
		/obj/item/reagent_containers/dropper = 100,
		/obj/item/reagent_containers/cup/bottle = 90,
		/obj/item/reagent_containers/cup/glass/flask = 90,
		/obj/item/reagent_containers/cup/beaker = 75,
		/obj/item/reagent_containers/cup/glass/bottle = 75,
		/obj/item/reagent_containers/cup/bucket = 50
	)

	can_infect = FALSE
	min_duration = 5 SECONDS
	max_duration = 6 SECONDS

/datum/surgery_step/sterilize_wound/assess_bodypart(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = ..()
	if(affected && !affected.is_disinfected() && check_chemicals(tool))
		return TRUE

/datum/surgery_step/sterilize_wound/begin_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)
	user.visible_message("[user] starts pouring the contents of [tool] on to [target]'s [affected.plaintext_zone].")
	target.apply_pain()
	playsound(target.loc, 'sound/effects/spritz.ogg', 50, TRUE, -6)
	..()

/datum/surgery_step/sterilize_wound/succeed_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)

	if (!istype(tool, /obj/item/reagent_containers))
		return

	var/obj/item/reagent_containers/container = tool

	var/amount = container.amount_per_transfer_from_this

	var/trans = container.reagents.trans_to(target, amount) //technically it's contact, but the reagents are being applied to internal tissue
	if (trans > 0)
		user.visible_message(
			span_notice("[user] rubs [target]'s [affected.plaintext_zone] down with the contents of [tool]."),
		)

	affected.disinfect()
	..()

/datum/surgery_step/sterilize_wound/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/bodypart/affected = target.get_bodypart(target_zone)

	if (!istype(tool, /obj/item/reagent_containers))
		return

	var/obj/item/reagent_containers/container = tool

	container.reagents.trans_to(target, container.reagents.total_volume)

	user.visible_message(
		span_warning("[user]'s hand slips, spilling [tool]'s contents over the [target]'s [affected.plaintext_zone].") ,
	)
	affected.disinfect()
	..()

/datum/surgery_step/sterilize_wound/proc/check_chemicals(obj/item/reagent_containers/tool)
	if(!istype(tool))
		return FALSE

	if(tool.reagents.has_reagent(/datum/reagent/space_cleaner/sterilizine))
		return TRUE

	var/datum/reagent/consumable/ethanol/alcohol = tool.reagents.has_reagent(/datum/reagent/consumable/ethanol)
	if(alcohol?.boozepwr >= 80)
		return TRUE
	return FALSE
