/obj/machinery/seed_splicer
	name = "seed splicer"
	desc = "Extracts and bags seeds from produce."
	icon = 'icons/obj/hydroponics/equipment.dmi'
	icon_state = "sextractor"
	density = TRUE
	circuit = /obj/item/circuitboard/machine/seed_extractor

/obj/machinery/seed_splicer/proc/splice(obj/item/seeds/seed_one, obj/item/seeds/seed_two)
	var/datum/plant/plant_one = seed_one.plant_datum
	var/datum/plant/plant_two = seed_two.plant_datum

	if(!plant_one || !plant_two)
		return
