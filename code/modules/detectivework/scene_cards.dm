/obj/item/storage/scene_cards
	name = "crime scene markers box"
	desc = "A cardboard box for crime scene marker cards."
	icon = 'icons/obj/forensics.dmi'
	icon_state = "cards"
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/storage/scene_cards/Initialize(mapload)
	. = ..()
	atom_storage.max_specific_storage = /obj/item/scene_card::w_class
	atom_storage.max_total_storage = /obj/item/scene_card::w_class * 7
	atom_storage.max_slots = 9

/obj/item/storage/scene_cards/PopulateContents()
	new /obj/item/scene_card/n1(src)
	new /obj/item/scene_card/n2(src)
	new /obj/item/scene_card/n3(src)
	new /obj/item/scene_card/n4(src)
	new /obj/item/scene_card/n5(src)
	new /obj/item/scene_card/n6(src)
	new /obj/item/scene_card/n7(src)

/obj/item/scene_card
	name = "crime scene marker"
	desc = "Plastic cards used to mark points of interests on the scene."
	icon = 'icons/obj/forensics.dmi'
	icon_state = "card1"
	w_class = WEIGHT_CLASS_TINY
	layer = ABOVE_MOB_LAYER
	var/number = 1

/obj/item/scene_card/Initialize(mapload)
	. = ..()
	desc += " This one is marked with [number]."
	update_appearance(UPDATE_ICON_STATE)

/obj/item/scene_card/update_icon_state()
	icon_state = "card[number]"
	return ..()

/obj/item/scene_card/attack_turf(atom/attacked_turf, mob/living/user, params)
	. = ..()
	if(!isopenturf(attacked_turf))
		return

	if(user.Adjacent(attacked_turf) && user.transferItemToLoc(src, attacked_turf))
		user.visible_message(span_notice("[user] places a [src.name] on [attacked_turf]."))
		return TRUE

/obj/item/scene_card/n1
	number = 1

/obj/item/scene_card/n2
	number = 2

/obj/item/scene_card/n3
	number = 3

/obj/item/scene_card/n4
	number = 4

/obj/item/scene_card/n5
	number = 5

/obj/item/scene_card/n6
	number = 6

/obj/item/scene_card/n7
	number = 7

