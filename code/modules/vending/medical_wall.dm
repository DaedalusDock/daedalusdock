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
		/obj/item/healthanalyzer/wound = 2,
		/obj/item/stack/medical/bone_gel/twelve = 2
	)
	contraband = list(
		/obj/item/reagent_containers/pill/tox = 2,
		/obj/item/reagent_containers/pill/morphine = 2,
	)
	refill_canister = /obj/item/vending_refill/wallmed
	default_price = PAYCHECK_HARD //Double the medical price due to being meant for public consumption, not player specfic
	extra_price = PAYCHECK_HARD * 1.5
	payment_department = ACCOUNT_MED
	tiltable = FALSE
	light_mask = "wallmed-light-mask"

	discount_access = ACCESS_MEDICAL

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/vending/wallmed, 32)

/obj/item/vending_refill/wallmed
	machine_name = "NanoMed"
	icon_state = "refill_medical"
