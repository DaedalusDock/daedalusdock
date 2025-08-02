//////////////////////////////////////////////////////////////////////////////
//////////////////////////// Medical /////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/medical
	group = "Medical"
	crate_type = /obj/structure/closet/crate/medical

/datum/supply_pack/medical/bloodpacks
	name = "Blood Pack Variety Crate"
	desc = "Contains ten different blood packs for reintroducing blood to patients."
	cost = PAYCHECK_ASSISTANT * 12.1 + CARGO_CRATE_VALUE
	contains = list(
		/obj/item/reagent_containers/blood,
		/obj/item/reagent_containers/blood,
		/obj/item/reagent_containers/blood/a_plus,
		/obj/item/reagent_containers/blood/a_minus,
		/obj/item/reagent_containers/blood/b_plus,
		/obj/item/reagent_containers/blood/b_minus,
		/obj/item/reagent_containers/blood/o_plus,
		/obj/item/reagent_containers/blood/o_minus,
		/obj/item/reagent_containers/blood/lizard,
		/obj/item/reagent_containers/blood/ethereal
	)
	crate_name = "blood freezer"
	crate_type = /obj/structure/closet/crate/freezer

/datum/supply_pack/medical/defibs
	name = "Defibrillator"
	desc = "Contains a defibrillator for restarting hearts."
	cost = PAYCHECK_ASSISTANT * 16.2 + CARGO_CRATE_VALUE
	contains = list(/obj/item/defibrillator/loaded)
	crate_name = "defibrillator crate"

/datum/supply_pack/medical/iv_drip
	name = "IV Drip"
	desc = "Contains a single IV drip for administering blood to patients."
	cost = PAYCHECK_ASSISTANT * 3 + CARGO_CRATE_VALUE
	contains = list(/obj/machinery/iv_drip)
	crate_name = "iv drip crate"

/datum/supply_pack/medical/surgery
	name = "Surgical Tool Bundle"
	desc = "Contains an array of surgical tools."
	cost = PAYCHECK_ASSISTANT * 13.8 + CARGO_CRATE_VALUE
	contains = list(
		/obj/item/storage/backpack/duffelbag/med/surgery
	)
	crate_name = "surgical supplies crate"

/datum/supply_pack/medical/supplies
	name = "Medical Supplies"
	desc = "Contains a handful of bruise packs, sutures, burn ointment, and bone gel."
	cost = PAYCHECK_ASSISTANT * 2.5 + CARGO_CRATE_VALUE
	crate_name = "advanced trauma crate"
	contains = list(
		/obj/item/stack/medical/bruise_pack,
		/obj/item/stack/medical/suture,
		/obj/item/stack/medical/bone_gel,
		/obj/item/stack/medical/ointment,
	)

/datum/supply_pack/medical/stasis_bags
	name = "Stasis Bag Bundle"
	desc = "A shipment of stasis bags for medical triage."
	cost = PAYCHECK_ASSISTANT * 45.8 + CARGO_CRATE_VALUE
	contains = list(
		/obj/item/bodybag/stasis,
		/obj/item/bodybag/stasis,
		/obj/item/bodybag/stasis,
	)

/datum/supply_pack/medical/firstaidbrute
	name = "Medical Kit (Blunt Trauma)"
	desc = "A single brute medkit."
	cost = PAYCHECK_ASSISTANT * 5.2 + CARGO_CRATE_VALUE
	contains = list(/obj/item/storage/medkit/brute)

/datum/supply_pack/medical/firstaidburns
	name = "Medical Kit (Burn)"
	desc = "A single burn medkit."
	cost = PAYCHECK_ASSISTANT * 5.2 + CARGO_CRATE_VALUE
	contains = list(/obj/item/storage/medkit/fire)

/datum/supply_pack/medical/firstaid
	name = "Medical Kit (First Aid)"
	desc = "A single medkit, fit for healing most types of bodily harm."
	cost = PAYCHECK_ASSISTANT * 5.2 + CARGO_CRATE_VALUE
	contains = list(/obj/item/storage/medkit/regular)

/datum/supply_pack/medical/firstaidoxygen
	name = "Medical Kit (Oxygen Deprivation)"
	desc = "A single oxygen deprivation medkit."
	cost = PAYCHECK_ASSISTANT * 5.2 + CARGO_CRATE_VALUE
	contains = list(/obj/item/storage/medkit/o2)

/datum/supply_pack/medical/firstaidtoxins
	name = "Medical Kit (Toxin)"
	desc = "A single first aid kit focused on healing damage dealt by heavy toxins."
	cost = PAYCHECK_ASSISTANT * 5.2 + CARGO_CRATE_VALUE
	contains = list(/obj/item/storage/medkit/toxin)

/datum/supply_pack/medical/medipen_twopak
	name = "Autoinjector Two-Pak"
	desc = "Contains one standard epinephrine autoinjector and one standard emergency medkit autoinjector. For when you want to prepare for the worst."
	cost = PAYCHECK_ASSISTANT * 3.6 + CARGO_CRATE_VALUE
	contains = list(
		/obj/item/reagent_containers/hypospray/medipen,
		/obj/item/reagent_containers/hypospray/medipen/ekit
	)
