/obj/item/reagent_containers/pill/patch
	name = "chemical patch"
	desc = "A chemical patch for touch based applications."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bandaid"
	inhand_icon_state = "bandaid"
	possible_transfer_amounts = list()
	volume = 15
	apply_type = TOUCH
	apply_method = "apply"
	self_delay = 2 SECONDS
	other_delay = 1 SECOND
	dissolvable = FALSE

/obj/item/reagent_containers/pill/patch/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!ishuman(interacting_with))
		return NONE

	var/mob/living/carbon/human/L = interacting_with
	var/obj/item/bodypart/affecting = L.get_bodypart(deprecise_zone(user.zone_selected))
	if(!affecting)
		to_chat(user, span_warning("The limb is missing."))
		return ITEM_INTERACT_BLOCKING
	if(!IS_ORGANIC_LIMB(affecting))
		to_chat(user, span_notice("Medicine will not work on a robotic limb."))
		return ITEM_INTERACT_BLOCKING

	return ..()

/obj/item/reagent_containers/pill/patch/canconsume(mob/eater, mob/user)
	if(!iscarbon(eater))
		return FALSE
	return TRUE // Masks were stopping people from "eating" patches. Thanks, inheritance.

/obj/item/reagent_containers/pill/patch/on_consumption(mob/M, mob/user)
	if(!reagents.total_volume)
		return

	reagents.trans_to(M, reagents.total_volume, transfered_by = user, methods = TOUCH)
	reagents.clear_reagents()

/obj/item/reagent_containers/pill/patch/synthflesh
	name = "synthflesh patch"
	desc = "Helps with brute and burn injuries. Slightly toxic."
	list_reagents = list(/datum/reagent/medicine/synthflesh = 15)
	icon_state = "bandaid_both"

/obj/item/reagent_containers/pill/patch/styptic_powder
	name = "styptic patch"
	desc = "A patch for aiding the healing of cuts and abrasions."
	list_reagents = list(/datum/reagent/medicine/styptic_powder = 15)
	icon_state = "bandaid_brute"

/obj/item/reagent_containers/pill/patch/silver_sulfadiazine
	name = "silver sulfadiazine patch"
	desc = "A path which soothes burns on flesh."
	list_reagents = list(/datum/reagent/medicine/silver_sulfadiazine = 15)
	icon_state = "bandaid_burn"
