#define ALL_GASIDS xgm_gas_data.gases

/datum/unit_test/atmospherics/machinery
	abstract_type = /datum/unit_test/atmospherics/machinery
	var/list/test_cases = list()

/datum/unit_test/atmospherics/machinery/should_conserve_moles
	abstract_type = /datum/unit_test/atmospherics/machinery/should_conserve_moles
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



/datum/unit_test/atmospherics/machinery/should_conserve_moles/pump_gas
	name = "ATMOS/MACHINERY: pump_gas() Should Conserves Moles"

/datum/unit_test/atmospherics/machinery/should_conserve_moles/pump_gas/Run()
	for(var/case_name in test_cases)
		var/gas_mix_data = test_cases[case_name]
		var/list/before_gas_mixes = create_gas_mixes(gas_mix_data)
		var/list/after_gas_mixes = create_gas_mixes(gas_mix_data)

		pump_gas(after_gas_mixes["source"], after_gas_mixes["sink"], null, INFINITY)

		check_moles_conserved(case_name, before_gas_mixes, after_gas_mixes)

	return 1

/datum/unit_test/atmospherics/machinery/should_conserve_moles/pump_gas_passive
	name = "ATMOS/MACHINERY: pump_gas_passive() Should Conserves Moles"

/datum/unit_test/atmospherics/machinery/should_conserve_moles/pump_gas_passive/Run()
	for(var/case_name in test_cases)
		var/gas_mix_data = test_cases[case_name]
		var/list/before_gas_mixes = create_gas_mixes(gas_mix_data)
		var/list/after_gas_mixes = create_gas_mixes(gas_mix_data)

		pump_gas_passive(after_gas_mixes["source"], after_gas_mixes["sink"], null)

		check_moles_conserved(case_name, before_gas_mixes, after_gas_mixes)

	return 1

/datum/unit_test/atmospherics/machinery/should_conserve_moles/scrub_gas
	name = "ATMOS/MACHINERY: scrub_gas() Should Conserves Moles"

/datum/unit_test/atmospherics/machinery/should_conserve_moles/scrub_gas/Run()
	var/list/filtering = xgm_gas_data.gases

	for(var/case_name in test_cases)
		var/gas_mix_data = test_cases[case_name]
		var/list/before_gas_mixes = create_gas_mixes(gas_mix_data)
		var/list/after_gas_mixes = create_gas_mixes(gas_mix_data)

		scrub_gas(filtering, after_gas_mixes["source"], after_gas_mixes["sink"], null, INFINITY)

		check_moles_conserved(case_name, before_gas_mixes, after_gas_mixes)

	return 1

/datum/unit_test/atmospherics/machinery/should_conserve_moles/filter_gas
	name = "ATMOS/MACHINERY: filter_gas() Should Conserves Moles"

/datum/unit_test/atmospherics/machinery/should_conserve_moles/filter_gas/Run()
	var/list/filtering = xgm_gas_data.gases

	for(var/case_name in test_cases)
		var/gas_mix_data = test_cases[case_name]
		var/list/before_gas_mixes = create_gas_mixes(gas_mix_data)
		var/list/after_gas_mixes = create_gas_mixes(gas_mix_data)

		filter_gas(filtering, after_gas_mixes["source"], after_gas_mixes["sink"], after_gas_mixes["source"], null, INFINITY)

		check_moles_conserved(case_name, before_gas_mixes, after_gas_mixes)

	return 1

/datum/unit_test/atmospherics/machinery/should_conserve_moles/filter_gas_multi
	name = "ATMOS/MACHINERY: filter_gas_multi() Should Conserves Moles"

/datum/unit_test/atmospherics/machinery/should_conserve_moles/filter_gas_multi/Run()
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

/datum/unit_test/atmospherics/machinery/should_conserve_moles/mix_gas
	name = "ATMOS/MACHINERY: mix_gas() Should Conserves Moles"

/datum/unit_test/atmospherics/machinery/should_conserve_moles/mix_gas/Run()
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
