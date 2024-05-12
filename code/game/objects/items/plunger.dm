/obj/item/plunger
	name = "plunger"
	desc = "It's a plunger for plunging."
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "plunger"
	worn_icon_state = "plunger"

	slot_flags = ITEM_SLOT_MASK
	flags_inv = HIDESNOUT

	///time*plunge_mod = total time we take to plunge an object
	var/plunge_mod = 1
	///whether we do heavy duty stuff like geysers
	var/reinforced = TRUE

/obj/item/plunger/attack_obj(obj/O, mob/living/user, params)
	if(!O.plunger_act(src, user, reinforced))
		return ..()

/obj/item/plunger/throw_impact(atom/hit_atom, datum/thrownthing/tt)
	. = ..()
	if(tt.target_zone != BODY_ZONE_HEAD)
		return
	if(iscarbon(hit_atom))
		var/mob/living/carbon/H = hit_atom
		if(!H.wear_mask)
			H.equip_to_slot_if_possible(src, ITEM_SLOT_MASK)
			H.visible_message(span_warning("The plunger slams into [H]'s face!"), span_warning("The plunger suctions to your face!"))

///A faster reinforced plunger
/obj/item/plunger/reinforced
	name = "reinforced plunger"
	desc = "It's an M. 7 Reinforced Plunger© for heavy duty plunging."
	icon_state = "reinforced_plunger"
	worn_icon_state = "reinforced_plunger"
	reinforced = TRUE
	plunge_mod = 0.5

	custom_premium_price = PAYCHECK_MEDIUM * 8
