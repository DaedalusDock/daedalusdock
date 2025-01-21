/datum/plant_gene/yield_mod
	abstract_type = /datum/plant_gene/yield_mod
	var/multiplier = 1

/datum/plant_gene/yield_mod/positive
	name = "Enhanced Yield"
	desc = "This gene allows a plant to grow a greater number of items without any harm done."

	multiplier = 1.2

/datum/plant_gene/yield_mod/negative
	name = "Stunted Yield"
	desc = "This gene reduces the amount of viable items a plant will produce."

	multiplier = 0.5
	is_negative = TRUE
