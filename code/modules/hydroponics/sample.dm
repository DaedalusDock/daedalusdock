/datum/plant/sample
	name = "plant sample"

/obj/item/seeds/sample
	name = "plant sample"
	icon_state = "sample-empty"

	plant_type = /datum/plant/sample

	var/sample_color = "#FFFFFF"

/obj/item/seeds/sample/Initialize(mapload)
	. = ..()
	plant_datum.base_potency = -1
	plant_datum.harvest_yield = -1

	if(sample_color)
		var/mutable_appearance/filling = mutable_appearance(icon, "sample-filling")
		filling.color = sample_color
		add_overlay(filling)

/obj/item/seeds/sample/alienweed
	name = "alien weed sample"
	icon_state = "alienweed"
	sample_color = null
