/datum/plant_gene/damage_mod
	abstract_type = /datum/plant_gene/damage_mod

	var/multiplier = 1

/datum/plant_gene/damage_mod/resistance
	name = "Damage Resistance"
	desc = "Enables the plant to take less damage from anything that would harm it."

	multiplier = 0.5

/datum/plant_gene/damage_mod/vulnerability
	name = "Vulnerability"
	desc = "Frail growth makes this plant much more susceptible to any kind of damage."

	multiplier = 2
	is_negative = TRUE

/datum/plant_gene/continous_damage
	name = "Poor Health"
	desc = "A harmful gene strain that will cause gradual and continuous damage to the plant."

	is_negative = TRUE
	var/damage = 0.2

/datum/plant_gene/continous_damage/tick(delta_time, obj/machinery/hydroponics/tray, datum/plant/plant, datum/plant_tick/plant_tick)
	. = ..()
	if(.)
		return

	plant_tick.plant_health_delta -= damage

/datum/plant_gene/continous_damage/sudden_death
	name = "Terminator"
	desc = "A drastic genetic fault which can rarely cause plants to suddenly die."

	process_chance = 1
	damage = INFINITY
