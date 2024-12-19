/datum/unit_test/atmospherics/gas_validation
	name = "ATMOS: XGM Gasses must have valid configuration"

/datum/unit_test/atmospherics/gas_validation/Run()
	for(var/gas_id in xgm_gas_data.gases)
		if(xgm_gas_data.flags[gas_id] & XGM_GAS_FUEL)
			if(!(xgm_gas_data.burn_product[gas_id] in xgm_gas_data.gases))
				TEST_FAIL("[xgm_gas_data.name[gas_id]] is set as a fuel but has an invalid burn product.")

