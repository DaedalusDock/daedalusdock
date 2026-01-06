/obj/item/stack/telecrystal
	name = "telecrystals"
	desc = "It seems to be pulsing with suspiciously enticing energies."
	singular_name = "telecrystal"
	stack_name = "pile"

	icon = 'icons/obj/telescience.dmi'
	icon_state = "telecrystal"
	dye_color = DYE_SYNDICATE
	w_class = WEIGHT_CLASS_TINY
	max_amount = 50
	item_flags = NOBLUDGEON
	merge_type = /obj/item/stack/telecrystal

	dynamically_set_name = TRUE

/obj/item/stack/telecrystal/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	. = ..()
	if(. & ITEM_INTERACT_ANY_BLOCKER)
		return

	if(interacting_with == user) //You can't go around smacking people with crystals to find out if they have an uplink or not.
		for(var/obj/item/implant/uplink/I in user.implants)
			if(I?.imp_in)
				var/datum/component/uplink/hidden_uplink = I.GetComponent(/datum/component/uplink)
				if(hidden_uplink)
					hidden_uplink.add_telecrystals(amount)
					use(amount)
					to_chat(user, span_notice("You press [src] onto yourself and charge your hidden uplink."))
					return ITEM_INTERACT_SUCCESS


/obj/item/stack/telecrystal/five
	amount = 5

/obj/item/stack/telecrystal/twenty
	amount = 20
