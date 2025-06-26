//Enclave/Remnants

/obj/item/clothing/suit/armor/f13/combat/enclave
	name = "enclave combat armor"
	desc = "(VI) An old set of pre-war combat armor, painted black."
	icon_state = "enclave_new"
	inhand_icon_state = "enclave_new"
	armor = list("tier" = 6, ENERGY = 75, BOMB = 70, BIO = 80, RAD = 80, FIRE = 80, ACID = 50)

/obj/item/clothing/suit/armor/f13/environmentalsuit
	name = "enclave envirosuit"
	desc = "(II) An advanced white and airtight environmental suit. It seems to be equipped with a fire-resistant seal and a refitted internals system. This one looks to have been developed by the Enclave sometime after the Great War. You'd usually exclusively see this on scientists of the Enclave."
	icon_state = "envirosuit"
	inhand_icon_state = "envirosuit"
	w_class = WEIGHT_CLASS_BULKY
	gas_transfer_coefficient = 0.9
	permeability_coefficient = 0.5
	clothing_flags = THICKMATERIAL
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	armor = list("tier" = 2,ENERGY = 10, BOMB = 10, BIO = 100, RAD = 100, FIRE = 50, ACID = 100)
	strip_delay = 60
	equip_delay_other = 60
	flags_inv = HIDEJUMPSUIT
	rad_flags = RAD_PROTECT_CONTENTS | RAD_NO_CONTAMINATE

/obj/item/clothing/suit/armor/f13/combat/remnant
	name = "remnant combat armor"
	desc = "(VI) A dark armor, used commonly in espionage or shadow ops."
	icon_state = "remnant"
	inhand_icon_state = "remnant"
	armor = list("tier" = 6, ENERGY = 75, BOMB = 70, BIO = 80, RAD = 80, FIRE = 80, ACID = 50)
