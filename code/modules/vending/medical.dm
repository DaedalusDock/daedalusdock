/obj/machinery/vending/medical
	name = "\improper NanoMed Plus"
	desc = "Medical drug dispenser."
	icon_state = "med"
	icon_deny = "med-deny"
	panel_type = "panel11"
	product_ads = "Go save some lives!;The best stuff for your medbay.;Only the finest tools.;Natural chemicals!;This stuff saves lives.;Don't you want some?;Ping!"
	req_access = list(ACCESS_MEDICAL)
	products = list(
		/obj/item/stack/gauze = 8,
		/obj/item/reagent_containers/syringe = 12,
		/obj/item/reagent_containers/dropper = 3,
		/obj/item/healthanalyzer = 4,
		/obj/item/wrench/medical = 1,
		/obj/item/stack/sticky_tape/surgical = 3,
		/obj/item/stack/medical/ointment = 2,
		/obj/item/stack/medical/bruise_pack = 2,
		/obj/item/stack/medical/bone_gel/twelve = 4
	)
	contraband = list(
		/obj/item/storage/box/hug/medical = 1
	)
	premium = list(
		/obj/item/reagent_containers/hypospray/medipen = 3,
		/obj/item/storage/belt/medical = 3,
		/obj/item/sensor_device = 2,
		/obj/item/pinpointer/crew = 2,
		/obj/item/storage/medkit/advanced = 2,
		/obj/item/shears = 1,
		/obj/item/storage/organbox = 1
	)
	refill_canister = /obj/item/vending_refill/medical
	default_price = PAYCHECK_EASY
	extra_price = PAYCHECK_COMMAND
	payment_department = ACCOUNT_MED
	light_mask = "med-light-mask"

/obj/item/vending_refill/medical
	machine_name = "NanoMed Plus"
	icon_state = "refill_medical"

/obj/machinery/vending/medical/syndicate_access
	name = "\improper SyndiMed Plus"
	req_access = list(ACCESS_SYNDICATE)

//Created out of a necessity to get these dumb chems out of the medical tools vendor.
/obj/machinery/vending/drugs
	name = "\improper NanoDrug Plus"
	desc = "Medical drugs dispenser."
	icon_state = "drug"
	icon_deny = "drug-deny"
	panel_type = "panel11"
	product_ads = "Go save some lives!;The best stuff for your medbay.;Only the finest tools.;Natural chemicals!;This stuff saves lives.;Don't you want some?;Ping!"
	req_access = list(ACCESS_MEDICAL)
	products = list(/obj/item/reagent_containers/pill/bicaridine = 7,
					/obj/item/reagent_containers/pill/kelotane = 7,
					/obj/item/reagent_containers/syringe/dexalin = 2,
					/obj/item/reagent_containers/pill/insulin = 5,
					/obj/item/reagent_containers/glass/bottle/dylovene = 2,
					/obj/item/reagent_containers/glass/bottle/epinephrine = 3,
					/obj/item/reagent_containers/glass/bottle/morphine = 4,
					/obj/item/reagent_containers/glass/bottle/potass_iodide = 1,
					/obj/item/reagent_containers/glass/bottle/saline_glucose = 3,
					/obj/item/reagent_containers/glass/bottle/toxin = 3,
					/obj/item/reagent_containers/syringe/antiviral = 6,
				)
	contraband = list(/obj/item/reagent_containers/pill/tox = 3,
					/obj/item/reagent_containers/pill/morphine = 4,
					/obj/item/reagent_containers/pill/dylovene = 6)
	premium = list(/obj/item/reagent_containers/medigel/synthflesh = 2,
					/obj/item/storage/pill_bottle/haloperidol = 2)
	default_price = 50
	extra_price = 100
	payment_department = ACCOUNT_MED
	refill_canister = /obj/item/vending_refill/drugs

	discount_access = ACCESS_MEDICAL

/obj/item/vending_refill/drugs
	machine_name = "NanoDrug Plus"
	icon_state = "refill_medical"
