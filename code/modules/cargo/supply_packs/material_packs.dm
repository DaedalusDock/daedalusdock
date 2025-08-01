/datum/supply_pack/materials
	group = "Materials (Raw)"

/datum/supply_pack/materials/cardboard50
	name = "50 Cardboard Sheets"
	desc = "Create a bunch of boxes."
	cost = CARGO_CRATE_VALUE + (/datum/material/cardboard::value_per_unit * MINERAL_MATERIAL_AMOUNT * 50)
	contains = list(/obj/item/stack/sheet/cardboard/fifty)
	crate_name = "cardboard sheets crate"

/datum/supply_pack/materials/glass50
	name = "50 Glass Sheets"
	desc = "Let some nice light in with fifty glass sheets!"
	cost = CARGO_CRATE_VALUE + (/datum/material/glass::value_per_unit * MINERAL_MATERIAL_AMOUNT * 50)
	contains = list(/obj/item/stack/sheet/glass/fifty)
	crate_name = "glass sheets crate"

/datum/supply_pack/materials/iron50
	name = "50 Iron Sheets"
	desc = "Any construction project begins with a good stack of fifty iron sheets!"
	cost = CARGO_CRATE_VALUE + (/datum/material/iron::value_per_unit * MINERAL_MATERIAL_AMOUNT * 50)
	contains = list(/obj/item/stack/sheet/iron/fifty)
	crate_name = "iron sheets crate"

/datum/supply_pack/materials/plasteel20
	name = "20 Plasteel Sheets"
	desc = "Reinforce the station's integrity with twenty plasteel sheets!"
	cost = CARGO_CRATE_VALUE + (/datum/material/alloy/plasteel::value_per_unit * MINERAL_MATERIAL_AMOUNT * 20)
	contains = list(/obj/item/stack/sheet/plasteel/twenty)
	crate_name = "plasteel sheets crate"

/datum/supply_pack/materials/plastic50
	name = "50 Plastic Sheets"
	desc = "Build a limitless amount of toys with fifty plastic sheets!"
	cost = CARGO_CRATE_VALUE + (/datum/material/plastic::value_per_unit * MINERAL_MATERIAL_AMOUNT * 50)
	contains = list(/obj/item/stack/sheet/plastic/fifty)
	crate_name = "plastic sheets crate"

/datum/supply_pack/materials/wood50
	name = "50 Wood Planks"
	desc = "Turn cargo's boring metal groundwork into beautiful panelled flooring and much more with fifty wooden planks!"
	cost = CARGO_CRATE_VALUE + (/datum/material/wood::value_per_unit * MINERAL_MATERIAL_AMOUNT * 50)
	contains = list(/obj/item/stack/sheet/mineral/wood/fifty)
	crate_name = "wood planks crate"

/datum/supply_pack/materials/gas_canisters
	cost = CARGO_CRATE_VALUE
	contains = list(/obj/machinery/portable_atmospherics/canister)
	crate_type = /obj/structure/closet/crate/large

/datum/supply_pack/materials/gas_canisters/generate_supply_packs()
	var/list/canister_packs = list()

	var/obj/machinery/portable_atmospherics/canister/fakeCanister = /obj/machinery/portable_atmospherics/canister
	// This is the amount of moles in a default canister
	var/moleCount = (initial(fakeCanister.maximum_pressure) * initial(fakeCanister.filled)) * initial(fakeCanister.volume) / (R_IDEAL_GAS_EQUATION * T20C)

	for(var/gasType in xgm_gas_data.gases)
		var/name = xgm_gas_data.name[gasType]
		if(!xgm_gas_data.purchaseable[gasType])
			continue
		var/datum/supply_pack/materials/pack = new
		pack.name = "Canister ([name])"
		pack.desc = "Contains a canister of [name]."
		if(xgm_gas_data.flags[gasType] & XGM_GAS_FUEL)
			pack.desc = "[pack.desc] Requires Atmospherics access to open."
			pack.access = ACCESS_ATMOSPHERICS
			pack.access_view = ACCESS_ATMOSPHERICS
		pack.crate_name = "[name] canister crate"
		pack.id = "[type]([name])"

		pack.cost = cost + (moleCount * xgm_gas_data.base_value[gasType])
		pack.cost = CEILING(pack.cost, 10)

		pack.contains = list(GLOB.gas_id_to_canister[gasType])

		pack.crate_type = crate_type

		canister_packs += pack

	////AIRMIX SPECIAL BABY
	var/datum/supply_pack/materials/airpack = new
	airpack.name = "Canister (Airmix)"
	airpack.desc = "Contains a canister of breathable air."
	airpack.crate_name = "airmix canister crate"
	airpack.id = "[type](airmix)"
	airpack.cost = 200
	airpack.contains = list(/obj/machinery/portable_atmospherics/canister/air)
	airpack.crate_type = crate_type
	canister_packs += airpack

	return canister_packs
