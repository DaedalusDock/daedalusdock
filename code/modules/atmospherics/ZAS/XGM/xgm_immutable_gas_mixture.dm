/datum/gas_mixture/immutable
	temperature = TCMB
	var/initial_temperature = TCMB

/datum/gas_mixture/immutable/updateValues()
	temperature = initial_temperature
	return ..()

/datum/gas_mixture/immutable/adjustGas(gasid, moles, update = 1)
	return

/datum/gas_mixture/immutable/remove()
	return new type

/datum/gas_mixture/immutable/add()
	return TRUE

/datum/gas_mixture/immutable/subtract()
	return TRUE

/datum/gas_mixture/immutable/divide()
	return TRUE

/datum/gas_mixture/immutable/multiply()
	return TRUE

/datum/gas_mixture/immutable/adjustGasWithTemp(gasid, moles, temp, update = 1)
	return

/datum/gas_mixture/immutable/adjustMultipleGases()
	return

/datum/gas_mixture/immutable/adjustMultipleGasesWithTemp()
	return

/datum/gas_mixture/immutable/merge()
	return

/datum/gas_mixture/immutable/copyFrom()
	return

/datum/gas_mixture/immutable/getHeatCapacity()
	return HEAT_CAPACITY_VACUUM

/datum/gas_mixture/immutable/removeRatio()
	return new type

/datum/gas_mixture/immutable/removeVolume()
	return new type

/datum/gas_mixture/immutable/removeByFlag()
	return new type

/datum/gas_mixture/immutable/shareRatio(datum/gas_mixture/other, connecting_tiles, share_size, one_way)
	. = ..()
	temperature = initial_temperature


