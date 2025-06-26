/obj/item/clothing/mask/joy
	name = "joy mask"
	desc = "Express your happiness or hide your sorrows with this laughing face with crying tears of joy cutout."
	icon_state = "joy"
	mutantrace_variation = STYLE_MUZZLE

//NCR Facewrap

/obj/item/clothing/mask/ncr_facewrap
	name = "desert facewrap"
	desc = "A facewrap commonly employed by NCR troops in desert environments."
	icon_state = "ncr_facewrap"
	w_class = WEIGHT_CLASS_TINY
	flags_inv = HIDEFACE
	flags_cover = MASKCOVERSMOUTH
	visor_flags_cover = MASKCOVERSMOUTH
	gas_transfer_coefficient = 0.9
	permeability_coefficient = 0.01
	armor = list(BLUNT = 0, PUNCTURE = 0, LASER = 0,ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 0, ACID = 0)
	actions_types = list(/datum/action/item_action/adjust)

/obj/item/clothing/mask/ncr_facewrap/attack_self(mob/user)
	adjustmask(user)

///////////////////
//LEGION BANDANAS//
///////////////////

/obj/item/clothing/mask/bandana/legion
	name = "legion mask template"
	desc = "Should not exist."
	icon = 'modular_fallout/master_files/icons/fallout/clothing/masks.dmi'
	mob_overlay_icon = 'modular_fallout/master_files/icons/fallout/onmob/clothes/mask.dmi'
	flags_inv = HIDEFACE
	visor_flags_inv = HIDEFACE
	adjusted_flags = null
	actions_types = list(/datum/action/item_action/adjust)

/obj/item/clothing/mask/bandana/legion/camp
	name = "camp duty bandana"
	desc = "Simple black cloth intended for men on camp duty."
	icon_state = "legaux"

/obj/item/clothing/mask/bandana/legion/legrecruit
	name = "recruit bandana"
	desc = "A coarse dark recruit bandana."
	icon_state = "legrecruit"

/obj/item/clothing/mask/bandana/legion/legprime
	name = "prime bandana"
	desc = "A dark linen bandana worn by primes"
	icon_state = "legdecan"

/obj/item/clothing/mask/bandana/legion/legvet
	name = "veteran bandana"
	desc = "A veterans bandana in red."
	icon_state = "legvet"

/obj/item/clothing/mask/bandana/legion/legdecan
	name = "decanus bandana"
	desc = "A fine decan bandana in dark red."
	icon = 'modular_fallout/master_files/icons/fallout/clothing/masks.dmi'
	mob_overlay_icon = 'modular_fallout/master_files/icons/fallout/onmob/clothes/mask.dmi'
	icon_state = "legdecan"

/obj/item/clothing/mask/bandana/legion/legcenturion
	name = "centurion bandana"
	desc = "A high quality bandana made for a centurion."
	icon_state = "legcenturion"


//Desert facewrap

/obj/item/clothing/mask/facewrap
	name = "desert headwrap"
	desc = "A headwrap to help shield the face from sand and other dirt."
	icon_state = "facewrap"
	inhand_icon_state = "facewrap"
	flags_inv = HIDEFACE|HIDEHAIR|HIDEFACIALHAIR
	flags_cover = MASKCOVERSMOUTH
	visor_flags_inv = HIDEFACE
	visor_flags_cover = MASKCOVERSMOUTH

//Society Mask

/obj/item/clothing/mask/society
	name = "golden facemask"
	desc = "A burlap sack with eyeholes."
	icon_state = "societymask"
	inhand_icon_state = "societymask"
	flags_inv = HIDEFACE

/obj/item/clothing/mask/bandana/momentobandana
	name = "momento bandana"
	desc = "A bandana that serves the user as a reminder of the past."
	icon_state = "momento"
	flags_inv = HIDEFACE
	visor_flags_inv = HIDEFACE
	adjusted_flags = null
	actions_types = list(/datum/action/item_action/adjust)
