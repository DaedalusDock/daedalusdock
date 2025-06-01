// Eldritch armor. Looks cool, hood lets you cast heretic spells.
/obj/item/clothing/head/hooded/cult_hoodie/eldritch
	name = "ominous hood"
	icon_state = "eldritch"
	desc = "A torn, dust-caked hood. Strange eyes line the inside."
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	flash_protect = FLASH_PROTECTION_WELDER
	clothing_traits = list(TRAIT_ALLOW_HERETIC_CASTING)

/obj/item/clothing/head/hooded/cult_hoodie/eldritch/examine(mob/user)
	. = ..()
	if(!IS_HERETIC(user))
		return

	. += span_notice("Allows you to cast heretic spells while the hood is up.")

/obj/item/clothing/suit/hooded/cultrobes/eldritch
	name = "ominous armor"
	desc = "A ragged, dusty set of robes. Strange eyes line the inside."
	icon_state = "eldritch_armor"
	inhand_icon_state = "eldritch_armor"
	flags_inv = HIDESHOES|HIDEJUMPSUIT
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS
	allowed = list(/obj/item/melee/sickly_blade)
	hoodtype = /obj/item/clothing/head/hooded/cult_hoodie/eldritch
	// Slightly better than normal cult robes
	armor = list(BLUNT = 50, PUNCTURE = 50, SLASH = 0, LASER = 50, ENERGY = 50, BOMB = 35, BIO = 20, FIRE = 20, ACID = 20)

/obj/item/clothing/suit/hooded/cultrobes/eldritch/examine(mob/user)
	. = ..()
	if(!IS_HERETIC(user))
		return

	. += span_notice("Allows you to cast heretic spells while the hood is up.")

// Void cloak. Turns invisible with the hood up, lets you hide stuff.
/obj/item/clothing/head/hooded/cult_hoodie/void
	name = "void hood"
	icon_state = "void_cloak"
	flags_inv = NONE
	flags_cover = NONE
	desc = "Black like tar, doesn't reflect any light. Runic symbols line the outside, with each flash you loose comprehension of what you are seeing."
	item_flags = EXAMINE_SKIP
	armor = list(BLUNT = 30, PUNCTURE = 30, SLASH = 0, LASER = 30, ENERGY = 30, BOMB = 15, BIO = 0, FIRE = 0, ACID = 0)

/obj/item/clothing/head/hooded/cult_hoodie/void/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NO_STRIP, REF(src))

/obj/item/clothing/suit/hooded/cultrobes/void
	name = "void cloak"
	desc = "Black like tar, doesn't reflect any light. Runic symbols line the outside, with each flash you loose comprehension of what you are seeing."
	icon_state = "void_cloak"
	inhand_icon_state = "void_cloak"
	allowed = list(/obj/item/melee/sickly_blade)
	hoodtype = /obj/item/clothing/head/hooded/cult_hoodie/void
	flags_inv = NONE
	// slightly worse than normal cult robes
	armor = list(BLUNT = 30, PUNCTURE = 30, SLASH = 0, LASER = 30, ENERGY = 30, BOMB = 15, BIO = 0, FIRE = 0, ACID = 0)
	alternative_mode = TRUE

/obj/item/clothing/suit/hooded/cultrobes/void/Initialize(mapload)
	. = ..()

	create_storage(type = /datum/storage/pockets/void_cloak)

/obj/item/clothing/suit/hooded/cultrobes/void/on_hood_unequip(mob/living/wearer, obj/item/clothing/hood)
	if (!HAS_TRAIT(src, TRAIT_NO_STRIP))
		return

	to_chat(wearer, span_notice("The kaleidoscope of colours collapses around you, as the cloak shifts to visibility!"))
	item_flags &= ~EXAMINE_SKIP
	REMOVE_TRAIT(src, TRAIT_NO_STRIP, src)

/obj/item/clothing/suit/hooded/cultrobes/void/pre_hood_equip(mob/living/wearer, obj/item/clothing/hood)
	if(!IS_HERETIC_OR_MONSTER(wearer))
		to_chat(wearer, span_warning("You can't force the hood onto your head."))
		return FALSE
	return TRUE

/obj/item/clothing/suit/hooded/cultrobes/void/on_hood_equip(mob/living/wearer, obj/item/clothing/hood)
	to_chat(wearer, span_notice("The light shifts around you, rendering the cloak hidden from sight."))
	item_flags |= EXAMINE_SKIP
	ADD_TRAIT(src, TRAIT_NO_STRIP, src)
