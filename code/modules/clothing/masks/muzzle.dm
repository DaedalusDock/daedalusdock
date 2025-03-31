/obj/item/clothing/mask/muzzle
	name = "muzzle"
	desc = "To stop that awful noise."
	icon_state = "muzzle"
	inhand_icon_state = "blindfold"
	clothing_flags = BLOCKS_SPEECH
	flags_cover = MASKCOVERSMOUTH
	w_class = WEIGHT_CLASS_SMALL
	equip_delay_other = 20

/obj/item/clothing/mask/muzzle/attack_paw(mob/user, list/modifiers)
	if(iscarbon(user))
		var/mob/living/carbon/carbon_user = user
		if(src == carbon_user.wear_mask)
			to_chat(user, span_warning("You need help taking this off!"))
			return
	..()

/obj/item/clothing/mask/muzzle/breath
	name = "surgery mask"
	desc = "To silence those pesky patients before putting them under."
	icon_state = "breathmuzzle"
	inhand_icon_state = "breathmuzzle"
	body_parts_covered = NONE
	clothing_flags = MASKINTERNALS | BLOCKS_SPEECH
	permeability_coefficient = 0.01
	equip_delay_other = 25 // my sprite has 4 straps, a-la a head harness. takes a while to equip, longer than a muzzle

/obj/item/clothing/mask/muzzle/tape
	name = "tape piece"
	icon = 'icons/obj/tapes.dmi'
	worn_icon = 'icons/obj/tapes.dmi'
	icon_state = "tape_piece"
	worn_icon_state = "tape_piece_worn"
	inhand_icon_state = null
	item_flags = DROPDEL
	equip_delay_other = 40
	strip_delay = 40
	color = "#787878"
	///Dertermines whether the tape piece does damage when ripped off of someone.
	var/harmful_strip = FALSE
	///The ammount of damage dealt when the tape piece is ripped off of someone.
	var/stripping_damage = 0

/obj/item/clothing/mask/muzzle/tape/unequipped(mob/living/user)
	. = ..()
	if(user.get_item_by_slot(ITEM_SLOT_MASK) != src)
		return
	playsound(user, 'sound/items/duct_tape_rip.ogg', 50, TRUE)
	if(harmful_strip)
		user.apply_damage(stripping_damage, BRUTE, BODY_ZONE_HEAD)
		user.emote("scream")
		to_chat(user, span_userdanger("You feel a massive pain as hundreds of tiny spikes tear free from your face!"))

/obj/item/clothing/mask/muzzle/tape/super
	name = "super tape piece"
	color = "#f0b541"
	strip_delay = 80

/obj/item/clothing/mask/muzzle/tape/surgical
	name = "surgical tape piece"
	color = null
	equip_delay_other = 30
	strip_delay = 30

/obj/item/clothing/mask/muzzle/tape/pointy
	name = "pointy tape piece"
	color = "#ad2f45"
	harmful_strip = TRUE
	stripping_damage = 10

/obj/item/clothing/mask/muzzle/tape/pointy/super
	name = "super pointy tape piece"
	strip_delay = 60
	stripping_damage = 20
