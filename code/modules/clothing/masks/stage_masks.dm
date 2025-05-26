/obj/item/clothing/mask/utopia
	name = "aetherite mask"
	desc = "A jovial stage mask."

	icon_state = "utopiacomedy"
	inhand_icon_state = null

	armor = list(BLUNT = 0, PUNCTURE = 5, SLASH = 10, LASER = 10, ENERGY = 0, BOMB = 0, BIO = 50, FIRE = 10, ACID = 10)

	w_class = WEIGHT_CLASS_SMALL
	resistance_flags = FLAMMABLE

	body_parts_covered = NONE
	flags_cover = MASKCOVERSEYES | MASKCOVERSMOUTH
	flags_inv = HIDESNOUT | HIDEEYES | HIDEFACE

	permeability_coefficient = 0.25

/obj/item/clothing/mask/utopia/tragedy
	name = "aetherite mask"
	desc = "A stage mask depicting utter despair."
	icon_state = "utopiatragedy"
