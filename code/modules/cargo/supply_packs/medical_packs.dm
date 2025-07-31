//////////////////////////////////////////////////////////////////////////////
//////////////////////////// Medical /////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/medical
	group = "Medical"
	access_view = ACCESS_MEDICAL
	crate_type = /obj/structure/closet/crate/medical

/datum/supply_pack/medical/bloodpacks
	name = "Blood Pack Variety Crate"
	desc = "Contains ten different blood packs for reintroducing blood to patients."
	cost = CARGO_CRATE_VALUE * 7
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
	name = "Defibrillator Crate"
	desc = "Contains a defibrillator for restarting hearts."
	cost = CARGO_CRATE_VALUE * 5
	contains = list(/obj/item/defibrillator/loaded)
	crate_name = "defibrillator crate"

/datum/supply_pack/medical/iv_drip
	name = "IV Drip Crate"
	desc = "Contains a single IV drip for administering blood to patients."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/machinery/iv_drip)
	crate_name = "iv drip crate"

/datum/supply_pack/medical/surgery
	name = "Surgical Tool Crate"
	desc = "Contains an array of surgical tools."
	cost = CARGO_CRATE_VALUE * 6
	contains = list(
		/obj/item/storage/backpack/duffelbag/med/surgery
	)
	crate_name = "surgical supplies crate"

/datum/supply_pack/medical/supplies
	name = "Medical Supplies"
	desc = "Contains a handful of bruise packs, sutures, burn ointment, and bone gel."
	cost = CARGO_CRATE_VALUE * 3
	crate_name = "advanced trauma crate"
	contains = list(
		/obj/item/stack/medical/bruise_pack,
		/obj/item/stack/medical/suture,
		/obj/item/stack/medical/bone_gel,
		/obj/item/stack/medical/ointment,
	)

/datum/supply_pack/medical/stasis_bags
	name = "Stasis Bags Crate"
	desc = "A shipment of stasis bags for medical triage."
	cost = CARGO_CRATE_VALUE * 8
	contains = list(
		/obj/item/bodybag/stasis,
		/obj/item/bodybag/stasis,
		/obj/item/bodybag/stasis,
	)
