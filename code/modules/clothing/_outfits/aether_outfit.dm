// Masks
/obj/item/clothing/mask/utopia
	name = "acolyte mask"
	desc = "A stage mask depicting utter despair."

	icon_state = "aethertragedy"
	inhand_icon_state = null

	armor = list(BLUNT = 0, PUNCTURE = 5, SLASH = 10, LASER = 10, ENERGY = 0, BOMB = 0, BIO = 50, FIRE = 10, ACID = 10)

	w_class = WEIGHT_CLASS_SMALL
	resistance_flags = FLAMMABLE

	body_parts_covered = NONE
	flags_cover = MASKCOVERSEYES | MASKCOVERSMOUTH
	flags_inv = HIDESNOUT | HIDEEYES | HIDEFACE

	permeability_coefficient = 0.25

/obj/item/clothing/mask/utopia/augur
	name = "augur mask"
	desc = "A jovial stage mask."
	icon_state = "aethercomedy"

	permeability_coefficient = 0.01
	clothing_flags = parent_type::clothing_flags | MASKINTERNALS

/obj/item/clothing/mask/utopia/augur/equipped(mob/living/M, slot)
	. = ..()
	if((slot & slot_flags) && !istype(M.mind?.assigned_role, /datum/job/augur))
		M.apply_status_effect(/datum/status_effect/augur_mask)

/obj/item/clothing/mask/utopia/augur/unequipped(mob/living/M)
	. = ..()
	M.remove_status_effect(/datum/status_effect/augur_mask)

// Robes
#warn descs for lore n shiet
/obj/item/clothing/under/aether_robes
	name = "aether robes"
	icon = 'icons/obj/clothing/under/medical.dmi'
	worn_icon = 'icons/mob/clothing/under/medical.dmi'
	icon_state = "aetherrobe"

	supports_variations_flags = NONE

	permeability_coefficient = 0.5
	armor = list(BLUNT = 0, PUNCTURE = 0, SLASH = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 50, FIRE = 0, ACID = 0)

/obj/item/clothing/under/aether_robes/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/hooded, /obj/item/clothing/head/aether_hood)

/obj/item/clothing/head/aether_hood
	name = "aether robe veil"
	icon_state = "aetherhood"

	flags_inv = HIDEHAIR | HIDEEARS

	permeability_coefficient = 0.8
	armor = list(BLUNT = 0, PUNCTURE = 0, SLASH = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 25, FIRE = 0, ACID = 0)

/obj/item/clothing/shoes/really_blue_sneakers
	name = "blue shoes"
	icon_state = "sneakers_blue"
	inhand_icon_state = "sneakers_blue"

	permeability_coefficient = 0.01
