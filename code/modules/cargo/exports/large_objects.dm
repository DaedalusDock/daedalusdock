/datum/export/large/crate
	cost = CARGO_CRATE_VALUE
	k_elasticity = 0
	unit_name = "crate"
	export_types = list(/obj/structure/closet/crate)
	exclude_types = list(/obj/structure/closet/crate/large, /obj/structure/closet/crate/wooden, /obj/structure/closet/crate/mail, /obj/structure/closet/crate/coffin)

/datum/export/large/crate/total_printout(datum/export_report/ex, notes = TRUE) // That's why a goddamn metal crate costs that much.
	. = ..()
	if(. && notes)
		. += " Thanks for participating in the Hermes Crate Recycling Program."

/datum/export/large/crate/wooden
	cost = CARGO_CRATE_VALUE/5
	unit_name = "large wooden crate"
	export_types = list(/obj/structure/closet/crate/large)
	exclude_types = list()

/datum/export/large/crate/wooden/ore
	unit_name = "ore box"
	export_types = list(/obj/structure/ore_box)

/datum/export/large/crate/wood
	cost = CARGO_CRATE_VALUE * 0.48
	unit_name = "wooden crate"
	export_types = list(/obj/structure/closet/crate/wooden)
	exclude_types = list()

/datum/export/large/reagent_dispenser
	cost = CARGO_CRATE_VALUE * 0.5 // +0-400 depending on amount of reagents left
	var/contents_cost = CARGO_CRATE_VALUE * 0.8

/datum/export/large/reagent_dispenser/get_cost(obj/O)
	var/obj/structure/reagent_dispensers/D = O
	var/ratio = D.reagents.total_volume / D.reagents.maximum_volume

	return ..() + round(contents_cost * ratio)

/datum/export/large/reagent_dispenser/water
	unit_name = "watertank"
	export_types = list(/obj/structure/reagent_dispensers/watertank)
	contents_cost = CARGO_CRATE_VALUE * 0.4

/datum/export/large/reagent_dispenser/fuel
	unit_name = "fueltank"
	export_types = list(/obj/structure/reagent_dispensers/fueltank)

/datum/export/large/reagent_dispenser/beer
	unit_name = "beer keg"
	contents_cost = CARGO_CRATE_VALUE * 3.5
	export_types = list(/obj/structure/reagent_dispensers/beerkeg)


/datum/export/large/pipedispenser
	cost = CARGO_CRATE_VALUE * 2.5
	unit_name = "pipe dispenser"
	export_types = list(/obj/machinery/pipedispenser)

/datum/export/large/emitter
	cost = CARGO_CRATE_VALUE * 2.75
	unit_name = "emitter"
	export_types = list(/obj/machinery/power/emitter)

/datum/export/large/field_generator
	cost = CARGO_CRATE_VALUE * 2.75
	unit_name = "field generator"
	export_types = list(/obj/machinery/field/generator)

/datum/export/large/tesla_coil
	cost = CARGO_CRATE_VALUE * 2.25
	unit_name = "tesla coil"
	export_types = list(/obj/machinery/power/energy_accumulator/tesla_coil)

/datum/export/large/supermatter
	cost = CARGO_CRATE_VALUE * 16
	unit_name = "supermatter shard"
	//export_types = list(/obj/machinery/power/supermatter/shard)

/datum/export/large/grounding_rod
	cost = CARGO_CRATE_VALUE * 1.2
	unit_name = "grounding rod"
	export_types = list(/obj/machinery/power/energy_accumulator/grounding_rod)

/datum/export/large/iv
	cost = CARGO_CRATE_VALUE * 0.25
	unit_name = "iv drip"
	export_types = list(/obj/machinery/iv_drip)

/datum/export/large/barrier
	cost = CARGO_CRATE_VALUE * 0.25
	unit_name = "security barrier"
	export_types = list(/obj/item/grenade/barrier, /obj/structure/barricade/security)

/datum/export/large/gas_canister
	cost = CARGO_CRATE_VALUE * 0.05 //Base cost of canister. You get more for nice gases inside.
	unit_name = "Gas Canister"
	export_types = list(/obj/machinery/portable_atmospherics/canister)
	k_elasticity = 0.00033

/datum/export/large/gas_canister/get_cost(obj/O)
	var/obj/machinery/portable_atmospherics/canister/C = O
	var/worth = cost
	var/datum/gas_mixture/canister_mix = C.return_air()
	var/list/gases_to_check = xgm_gas_data.gases

	for(var/gasID in gases_to_check)
		if(canister_mix.getGroupGas(gasID) > 0)
			worth += get_gas_value(gasID, canister_mix.getGroupGas(gasID))

	return worth

/datum/export/large/gas_canister/proc/get_gas_value(gastype, moles)
	var/baseValue = xgm_gas_data.base_value[gastype]
	return round((baseValue/k_elasticity) * (1 - NUM_E**(-1 * k_elasticity * moles)))
