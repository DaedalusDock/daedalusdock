/obj/item/reagent_containers/spray/luminol
	name = "luminol bottle"
	desc = "A white bottle allegedly containing luminol."
	icon_state = "luminol"

	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(10)
	volume = 250

/obj/item/reagent_containers/spray/luminol/Initialize(mapload, vol)
	. = ..()
	reagents.add_reagent(/datum/reagent/luminol, volume)
