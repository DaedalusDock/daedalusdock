TYPEINFO_DEF(/obj/item/clothing/shoes/sandal)
	default_materials = list(/datum/material/wood = MINERAL_MATERIAL_AMOUNT * 0.5)

/obj/item/clothing/shoes/sandal
	desc = "A pair of rather plain wooden sandals."
	name = "sandals"
	icon_state = "wizard"
	strip_delay = 5
	equip_delay_other = 50
	permeability_coefficient = 0.9
	can_be_tied = FALSE


/obj/item/clothing/shoes/sandal/magic
	name = "magical sandals"
	desc = "A pair of sandals imbued with magic."
	resistance_flags = FIRE_PROOF | ACID_PROOF
