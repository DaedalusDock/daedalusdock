#define ALL_GASIDS xgm_gas_data.gases

/datum/unit_test/atmos_machinery
	//template = /datum/unit_test/atmos_machinery
	var/list/test_cases = list()

/datum/unit_test/atmos_machinery/Run()
	return

/datum/unit_test/atmos_machinery/proc/create_gas_mixes(gas_mix_data)
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

/datum/unit_test/atmos_machinery/proc/gas_amount_changes(list/before_gas_mixes, list/after_gas_mixes)
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

/datum/unit_test/atmos_machinery/proc/check_moles_conserved(case_name, list/before_gas_mixes, list/after_gas_mixes)
	var/failed = FALSE
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
			failed |= TRUE

	if(!failed)
		pass("conserved moles of each gas ID.")

/datum/unit_test/atmos_machinery/conserve_moles
	//template = /datum/unit_test/atmos_machinery/conserve_moles
	test_cases = list(
		uphill = list(
			source = list(
				initial_gas = list(
					GAS_OXYGEN         = 5,
					GAS_NITROGEN       = 10,
					GAS_CO2 = 5,
					GAS_PHORON         = 10,
					GAS_N2O = 5,
				),
				temperature = T20C - 5,
			),
			sink = list(
				initial_gas = list(
					GAS_OXYGEN         = 10,
					GAS_NITROGEN       = 20,
					GAS_CO2 = 10,
					GAS_PHORON         = 20,
					GAS_N2O = 10,
				),
				temperature = T20C + 5,
			)
		),
		downhill = list(
			source = list(
				initial_gas = list(
					GAS_OXYGEN         = 10,
					GAS_NITROGEN       = 20,
					GAS_CO2 = 10,
					GAS_PHORON         = 20,
					GAS_N2O = 10,
				),
				temperature = T20C + 5,
			),
			sink = list(
				initial_gas = list(
					GAS_OXYGEN         = 5,
					GAS_NITROGEN       = 10,
					GAS_CO2 = 5,
					GAS_PHORON         = 10,
					GAS_N2O = 5,
				),
				temperature = T20C - 5,
			),
		),
		flat = list(
			source = list(
				initial_gas = list(
					GAS_OXYGEN         = 10,
					GAS_NITROGEN       = 20,
					GAS_CO2 = 10,
					GAS_PHORON         = 20,
					GAS_N2O = 10,
				),
				temperature = T20C,
			),
			sink = list(
				initial_gas = list(
					GAS_OXYGEN         = 10,
					GAS_NITROGEN       = 20,
					GAS_CO2 = 10,
					GAS_PHORON         = 20,
					GAS_N2O = 10,
				),
				temperature = T20C,
			),
		),
		vacuum_sink = list(
			source = list(
				initial_gas = list(
					GAS_OXYGEN         = 10,
					GAS_NITROGEN       = 20,
					GAS_CO2 = 10,
					GAS_PHORON         = 20,
					GAS_N2O = 10,
				),
				temperature = T20C,
			),
			sink = list(
				initial_gas = list(),
				temperature = 0,
			),
		),
		vacuum_source = list(
			source = list(
				initial_gas = list(),
				temperature = 0,
			),
			sink = list(
				initial_gas = list(
					GAS_OXYGEN         = 10,
					GAS_NITROGEN       = 20,
					GAS_CO2 = 10,
					GAS_PHORON         = 20,
					GAS_N2O = 10,
				),
				temperature = T20C,
			),
		),
	)

/datum/unit_test/atmos_machinery/conserve_moles/Run()
	return

/datum/unit_test/atmos_machinery/conserve_moles/pump_gas
	//name = "ATMOS MACHINERY: pump_gas() Conserves Moles"

/datum/unit_test/atmos_machinery/conserve_moles/pump_gas/Run()
	for(var/case_name in test_cases)
		var/gas_mix_data = test_cases[case_name]
		var/list/before_gas_mixes = create_gas_mixes(gas_mix_data)
		var/list/after_gas_mixes = create_gas_mixes(gas_mix_data)

		pump_gas(after_gas_mixes["source"], after_gas_mixes["sink"], null, INFINITY)

		check_moles_conserved(case_name, before_gas_mixes, after_gas_mixes)

	return 1

/datum/unit_test/atmos_machinery/conserve_moles/pump_gas_passive
	//name = "ATMOS MACHINERY: pump_gas_passive() Conserves Moles"

/datum/unit_test/atmos_machinery/conserve_moles/pump_gas_passive/Run()
	for(var/case_name in test_cases)
		var/gas_mix_data = test_cases[case_name]
		var/list/before_gas_mixes = create_gas_mixes(gas_mix_data)
		var/list/after_gas_mixes = create_gas_mixes(gas_mix_data)

		pump_gas_passive(after_gas_mixes["source"], after_gas_mixes["sink"], null)

		check_moles_conserved(case_name, before_gas_mixes, after_gas_mixes)

	return 1

/datum/unit_test/atmos_machinery/conserve_moles/scrub_gas
	//name = "ATMOS MACHINERY: scrub_gas() Conserves Moles"

/datum/unit_test/atmos_machinery/conserve_moles/scrub_gas/Run()
	var/list/filtering = xgm_gas_data.gases

	for(var/case_name in test_cases)
		var/gas_mix_data = test_cases[case_name]
		var/list/before_gas_mixes = create_gas_mixes(gas_mix_data)
		var/list/after_gas_mixes = create_gas_mixes(gas_mix_data)

		scrub_gas(filtering, after_gas_mixes["source"], after_gas_mixes["sink"], null, INFINITY)

		check_moles_conserved(case_name, before_gas_mixes, after_gas_mixes)

	return 1

/datum/unit_test/atmos_machinery/conserve_moles/filter_gas
//	name = "ATMOS MACHINERY: filter_gas() Conserves Moles"

/datum/unit_test/atmos_machinery/conserve_moles/filter_gas/Run()
	var/list/filtering = xgm_gas_data.gases

	for(var/case_name in test_cases)
		var/gas_mix_data = test_cases[case_name]
		var/list/before_gas_mixes = create_gas_mixes(gas_mix_data)
		var/list/after_gas_mixes = create_gas_mixes(gas_mix_data)

		filter_gas(filtering, after_gas_mixes["source"], after_gas_mixes["sink"], after_gas_mixes["source"], null, INFINITY)

		check_moles_conserved(case_name, before_gas_mixes, after_gas_mixes)

	return 1

/datum/unit_test/atmos_machinery/conserve_moles/filter_gas_multi
	//name = "ATMOS MACHINERY: filter_gas_multi() Conserves Moles"

/datum/unit_test/atmos_machinery/conserve_moles/filter_gas_multi/Run()
	for(var/case_name in test_cases)
		var/gas_mix_data = test_cases[case_name]
		var/list/before_gas_mixes = create_gas_mixes(gas_mix_data)
		var/list/after_gas_mixes = create_gas_mixes(gas_mix_data)

		var/list/filtering = list()
		for(var/gasid in xgm_gas_data.gases)
			filtering[gasid] = after_gas_mixes["sink"] //just filter everything to sink

		filter_gas_multi(filtering, after_gas_mixes["source"], after_gas_mixes["sink"], null, INFINITY)

		check_moles_conserved(case_name, before_gas_mixes, after_gas_mixes)

	return 1

/datum/unit_test/atmos_machinery/conserve_moles/mix_gas
	//name = "ATMOS MACHINERY: mix_gas() Conserves Moles"

/datum/unit_test/atmos_machinery/conserve_moles/mix_gas/Run()
	for(var/case_name in test_cases)
		var/gas_mix_data = test_cases[case_name]
		var/list/before_gas_mixes = create_gas_mixes(gas_mix_data)
		var/list/after_gas_mixes = create_gas_mixes(gas_mix_data)

		var/list/mix_sources = list()
		for(var/gasid in ALL_GASIDS)
			var/datum/gas_mixture/mix_source = after_gas_mixes["sink"]
			mix_sources[mix_source] = 1.0/xgm_gas_data.gases.len //doesn't work as a macro for some reason

		mix_gas(mix_sources, after_gas_mixes["sink"], null, INFINITY)

		check_moles_conserved(case_name, before_gas_mixes, after_gas_mixes)

	return 1
#undef ALL_GASIDS
