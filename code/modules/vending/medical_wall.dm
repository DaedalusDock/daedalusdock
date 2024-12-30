/obj/machinery/vending/wallmed
	name = "\improper NanoMed"
	desc = "Wall-mounted Medical Equipment dispenser."
	icon_state = "wallmed"
	icon_deny = "wallmed-deny"
	panel_type = "panel-wall"
	density = FALSE
	products = list(
		/obj/item/reagent_containers/syringe = 3,
		/obj/item/reagent_containers/pill/bicaridine = 7,
		/obj/item/reagent_containers/pill/kelotane = 7,
		/obj/item/reagent_containers/pill/dylovene = 2,
		/obj/item/stack/medical/bone_gel/twelve = 2
	)
	contraband = list(
		/obj/item/reagent_containers/pill/tox = 2,
		/obj/item/reagent_containers/pill/morphine = 2,
	)
	refill_canister = /obj/item/vending_refill/wallmed
	// These are not meant to be used by medical staff, hence the large cost.
	default_price = PAYCHECK_ASSISTANT * 4
	extra_price = PAYCHECK_ASSISTANT * 6
	payment_department = ACCOUNT_MED
	tiltable = FALSE
	light_mask = "wallmed-light-mask"

	discount_access = ACCESS_MEDICAL

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/vending/wallmed, 32)

/obj/item/vending_refill/wallmed
	machine_name = "NanoMed"
	icon_state = "refill_medical"
