/obj/item/reagent_containers/cup/bottle/blackpowder
	name = "blackpowder bottle"
	desc = "A large bottle containing black powder."
	volume = 60
	list_reagents = list(/datum/reagent/gunpowder/blackpowder = 60)

/obj/item/reagent_containers/cup/bottle/FEV_solution
	name = " FEV bottle"
	desc = "A small vial of the Forced Evolutionary Virus. You think that consuming this would be a bad idea."
	list_reagents = list(/datum/reagent/toxin/FEV_solution = 30)

/obj/item/reagent_containers/cup/bottle/gaia
	name = "gaia bottle"
	desc = "A large bottle containing gaia."
	volume = 60
	list_reagents = list(/datum/reagent/medicine/gaia = 60)

/obj/item/reagent_containers/cup/bottle/primitive
	icon = 'modular_fallout/master_files/icons/fallout/objects/medicine/drugs.dmi'
	icon_state = "bottle_primitive"
	possible_transfer_amounts = list(5,10,15,20,30,60)
	volume = 60
/*
/obj/item/reagent_containers/cup/bottle/primitive/update_overlays()
	. = ..()
	if(!cached_icon)
		cached_icon = icon_state
	if(reagents.total_volume)
		return
*/
/obj/item/reagent_containers/cup/bottle/welding_fuel
	name = "welding fuel bottle"
	list_reagents = list(/datum/reagent/fuel = 30)
