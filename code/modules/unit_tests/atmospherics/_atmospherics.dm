/datum/unit_test/atmospherics
	abstract_type = /datum/unit_test/atmospherics

/datum/unit_test/atmospherics/proc/create_gas_mixes(gas_mix_data)
	var/list/gas_mixes = list()
	for(var/mix_name in gas_mix_data)
		var/list/mix_data = gas_mix_data[mix_name]

		var/datum/gas_mixture/gas_mix = new (CELL_VOLUME, mix_data["temperature"])

		var/list/initial_gas = mix_data["initial_gas"]
		if(initial_gas.len)
			var/list/gas_args = list()
			for(var/gasid in initial_gas)
				gas_args += gasid
				gas_args += initial_gas[gasid]
			gas_mix.adjustMultipleGases(arglist(gas_args))

		gas_mixes[mix_name] = gas_mix
	return gas_mixes

/datum/unit_test/atmospherics/proc/gas_amount_changes(list/before_gas_mixes, list/after_gas_mixes)
	var/list/result = list()
	for(var/mix_name in before_gas_mixes & after_gas_mixes)
		var/change = list()

		var/datum/gas_mixture/before = before_gas_mixes[mix_name]
		var/datum/gas_mixture/after = after_gas_mixes[mix_name]

		var/list/all_gases = before.gas | after.gas
		for(var/gasid in all_gases)
			change[gasid] = after.getGroupGas(gasid) - before.getGroupGas(gasid)

		result[mix_name] = change

	return result

/datum/unit_test/atmospherics/proc/check_moles_conserved(case_name, list/before_gas_mixes, list/after_gas_mixes)
	for(var/gasid in xgm_gas_data.gases)
		var/before = 0
		for(var/gasmix in before_gas_mixes)
			var/datum/gas_mixture/G = before_gas_mixes[gasmix]
			before += G.getGroupGas(gasid)

		var/after = 0
		for(var/gasmix in after_gas_mixes)
			var/datum/gas_mixture/G = after_gas_mixes[gasmix]
			after += G.getGroupGas(gasid)

		if(abs(before - after) > ATMOS_PRECISION)
			Fail("expected [before] moles of [gasid], found [after] moles.")
