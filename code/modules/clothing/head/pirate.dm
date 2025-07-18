/obj/item/clothing/head/pirate
	name = "pirate hat"
	desc = "Yarr."
	icon_state = "pirate"
	inhand_icon_state = "pirate"
	dog_fashion = /datum/dog_fashion/head/pirate

/obj/item/clothing/head/pirate
	var/datum/language/piratespeak/L = new

/obj/item/clothing/head/pirate/equipped(mob/user, slot)
	. = ..()
	if(!ishuman(user))
		return
	if(slot == ITEM_SLOT_HEAD)
		user.grant_language(/datum/language/piratespeak/, TRUE, TRUE, LANGUAGE_HAT)
		to_chat(user, span_boldnotice("You suddenly know how to speak like a pirate!"))

/obj/item/clothing/head/pirate/unequipped(mob/user)
	. = ..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(H.get_item_by_slot(ITEM_SLOT_HEAD) == src && !QDELETED(src)) //This can be called as a part of destroy
		user.remove_language(/datum/language/piratespeak/, TRUE, TRUE, LANGUAGE_HAT)
		to_chat(user, span_boldnotice("You can no longer speak like a pirate."))

TYPEINFO_DEF(/obj/item/clothing/head/pirate/armored)
	default_armor = list(BLUNT = 30, PUNCTURE = 50, SLASH = 0, LASER = 30, ENERGY = 40, BOMB = 30, BIO = 30, FIRE = 60, ACID = 75)

/obj/item/clothing/head/pirate/armored
	strip_delay = 40
	equip_delay_other = 20

/obj/item/clothing/head/pirate/captain
	name = "pirate captain hat"
	icon_state = "hgpiratecap"
	inhand_icon_state = "hgpiratecap"

/obj/item/clothing/head/bandana
	name = "pirate bandana"
	desc = "Yarr."
	icon_state = "bandana"
	inhand_icon_state = "bandana"


TYPEINFO_DEF(/obj/item/clothing/head/bandana/armored)
	default_armor = list(BLUNT = 30, PUNCTURE = 50, SLASH = 0, LASER = 30, ENERGY = 40, BOMB = 30, BIO = 30, FIRE = 60, ACID = 75)

/obj/item/clothing/head/bandana/armored
	strip_delay = 40
	equip_delay_other = 20
