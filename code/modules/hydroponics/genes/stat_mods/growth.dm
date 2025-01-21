/datum/plant_gene/growth_mod
	abstract_type = /datum/plant_gene/growth_mod
	var/mod = 1

/datum/plant_gene/growth_mod/tick(delta_time, obj/machinery/hydroponics/tray, datum/plant/plant, datum/plant_tick/plant_tick)
	. = ..()
	if(.)
		return

	plant_tick.plant_growth_delta = max(1, plant_tick.plant_growth_delta + mod)

/datum/plant_gene/growth_mod/fast
	name = "Rapid Growth"
	desc = "This gene causes a plant to grow more rapidly with no drawbacks."

	mod = 2

/datum/plant_gene/growth_mod/slow
	name = "Stunted Growth"
	desc = "This gene slows down a plant's growth rate."
	mod = -1
	is_negative = TRUE
