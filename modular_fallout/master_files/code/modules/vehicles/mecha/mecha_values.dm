TYPEINFO_DEF(/obj/vehicle/sealed/mecha/combat/gygax)
	default_armor = list(BLUNT = 40, PUNCTURE = 40, SLASH = 60, LASER = 50, ENERGY = 0, BOMB = 25, BIO = 0, FIRE = 100, ACID = 100)

/obj/vehicle/sealed/mecha/combat/gygax
	desc = "A lightweight, nimble combat/peacekeeping exosuit developed by Vault-Tec."
	name = "\improper Gygax"
	icon_state = "gygax"
	base_icon_state = "gygax"
	allow_diagonal_movement = TRUE
	movedelay = 3
	max_integrity = 300
	operation_req_access = list()
	internals_req_access = list()
	leg_overload_coeff = 80
	force = 25
	wreckage = /obj/structure/mecha_wreckage/gygax
	max_equip_by_category = list(
		MECHA_UTILITY = 3,
		MECHA_POWER = 1,
		MECHA_ARMOR = 1,
	)
	step_energy_drain = 3

TYPEINFO_DEF(/obj/vehicle/sealed/mecha/combat/durand)
	default_armor = list(BLUNT = 60, PUNCTURE = 60, SLASH = 90, LASER = 50, ENERGY = 0, BOMB = 25, BIO = 0, FIRE = 100, ACID = 100)

/obj/vehicle/sealed/mecha/combat/durand
	desc = "A medium-weight combat exosuit developed by Vault-Tec, the Durand is a well-armored exosuit with a built-in energy projector."
	name = "\improper Durand"
	icon_state = "durand"
	base_icon_state = "durand"
	movedelay = 4
	max_integrity = 300
	operation_req_access = list()
	internals_req_access = list()
	force = 50
	wreckage = /obj/structure/mecha_wreckage/durand
	max_equip_by_category = list(
		MECHA_UTILITY = 3,
		MECHA_POWER = 1,
		MECHA_ARMOR = 1,
	)

TYPEINFO_DEF(/obj/vehicle/sealed/mecha/combat/marauder)
	default_armor = list(BLUNT = 80, PUNCTURE = 80, SLASH = 90, LASER = 50, ENERGY = 0, BOMB = 50, BIO = 0, FIRE = 100, ACID = 100)

/obj/vehicle/sealed/mecha/combat/marauder
	desc = "A large, menacing combat exosuit developed by Vault-Tec. The chassis is extremely well-armored, but lacks high-pressure hydraulic pumps found in earlier models."
	name = "\improper Marauder"
	icon_state = "marauder"
	base_icon_state = "marauder"
	movedelay = 5
	max_integrity = 400
	operation_req_access = list()
	internals_req_access = list()
	wreckage = /obj/structure/mecha_wreckage/marauder
	force = 10
	max_equip_by_category = list(
		MECHA_UTILITY = 2,
		MECHA_POWER = 1,
		MECHA_ARMOR = 1,
	)
	bumpsmash = FALSE

TYPEINFO_DEF(/obj/vehicle/sealed/mecha/working/clarke)
	default_armor = list(BLUNT = 40, PUNCTURE = 20, SLASH = 40, LASER = 10, ENERGY = 0, BOMB = 25, BIO = 0, FIRE = 100, ACID = 100)

/obj/vehicle/sealed/mecha/working/ripley/mk2/clarke
	desc = "Combining man and machine for a better, stronger engineer. Can even resist lava!"
	name = "\improper Clarke"
	icon_state = "clarke"
	base_icon_state = "clarke"
	max_integrity = 300
	operation_req_access = list()
	internals_req_access = list()
	movedelay = 2
	equip_by_category = list(
		MECHA_L_ARM = null,
		MECHA_R_ARM = null,
		MECHA_UTILITY = list(/obj/item/mecha_parts/mecha_equipment/orebox_manager),
		MECHA_POWER = list(),
		MECHA_ARMOR = list(),
	)
	max_equip_by_category = list(
		MECHA_UTILITY = 4,
		MECHA_POWER = 1,
		MECHA_ARMOR = 1,
	)
	wreckage = /obj/structure/mecha_wreckage/clarke
	enter_delay = 40
