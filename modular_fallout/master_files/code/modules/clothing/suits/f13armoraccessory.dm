/obj/item/clothing/armoraccessory
	name = "Accessory"
	desc = "Something has gone wrong!"
	icon = 'icons/obj/clothing/accessories.dmi'
	icon_state = "plasma"
	inhand_icon_state = ""	//no inhands
	slot_flags = 0
	w_class = WEIGHT_CLASS_SMALL
	var/above_suit = FALSE
	var/minimize_when_attached = TRUE // TRUE if shown as a small icon in corner, FALSE if overlayed
	var/datum/component/storage/detached_pockets

/obj/item/clothing/armoraccessory/proc/attach(obj/item/clothing/suit/U, user)
	var/datum/component/storage/storage = GetComponent(/datum/component/storage)
	if(storage)
		if(SEND_SIGNAL(U, COMSIG_CONTAINS_STORAGE))
			return FALSE
		U.TakeComponent(storage)
		detached_pockets = storage
	U.attached_accessory = src
	forceMove(U)
	layer = FLOAT_LAYER
	plane = FLOAT_PLANE
	if(minimize_when_attached)
		transform *= 0.5	//halve the size so it doesn't overpower the under
		pixel_x += 8
		pixel_y -= 8
	U.add_overlay(src)

	if (islist(U.armor) || isnull(U.armor)) 										// This proc can run before /obj/Initialize has run for U and src,
		U.armor = getArmor(arglist(U.armor))	// we have to check that the armor list has been transformed into a datum before we try to call a proc on it
																					// This is safe to do as /obj/Initialize only handles setting up the datum if actually needed.
	if (islist(armor) || isnull(armor))
		armor = getArmor(arglist(armor))

	U.armor = U.armor.attachArmor(armor)

	if(isliving(user))
		on_suit_equip(U, user)

	return TRUE

/obj/item/clothing/armoraccessory/proc/detach(obj/item/clothing/suit/U, user)
	if(detached_pockets && detached_pockets.parent == U)
		TakeComponent(detached_pockets)

	U.armor = U.armor.detachArmor(armor)

	if(isliving(user))
		on_suit_dropped(U, user)

	if(minimize_when_attached)
		transform *= 2
		pixel_x -= 8
		pixel_y += 8
	layer = initial(layer)
	plane = initial(plane)
	U.cut_overlays()
	U.attached_accessory = null
	U.accessory_overlay = null

/obj/item/clothing/armoraccessory/proc/on_suit_equip(obj/item/clothing/suit/U, user)
	return

/obj/item/clothing/armoraccessory/proc/on_suit_dropped(obj/item/clothing/suit/U, user)
	return

/obj/item/clothing/armoraccessory/AltClick(mob/user)
	. = ..()
	if(istype(user) && user.canUseTopic(src, BE_CLOSE, ismonkey(user)))
		if(initial(above_suit))
			above_suit = !above_suit
			to_chat(user, "[src] will be worn [above_suit ? "above" : "below"] your suit.")
			return TRUE

/obj/item/clothing/armoraccessory/examine(mob/user)
	. = ..()
	. += "<span class='notice'>\The [src] can be attached to a suit. Alt-click to remove it once attached.</span>"
	if(initial(above_suit))
		. += "<span class='notice'>\The [src] can be worn above or below your suit. Alt-click to toggle.</span>"

/obj/item/clothing/armoraccessory/kevlar
	name = "kevlar plating"
	desc = "Light-weight kevlar plates that slide in underneath your armor, increasing your protection against projectiles."
	armor = list("linemelee" = 20)
