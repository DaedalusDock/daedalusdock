// This is for admins. Allows quick smacking down of cartridges for player/debug use.
/client/proc/spawn_chemdisp_cartridge(size in list("small", "medium", "large"), reagent in subtypesof(/datum/reagent))
	set name = "Spawn Chemical Dispenser Cartridge"
	set category = "Admin.Events"

	var/obj/item/reagent_containers/chem_cartridge/C
	switch(size)
		if("small") C = new /obj/item/reagent_containers/chem_cartridge/small(usr.loc)
		if("medium") C = new /obj/item/reagent_containers/chem_cartridge/medium(usr.loc)
		if("large") C = new /obj/item/reagent_containers/chem_cartridge/large(usr.loc)
	C.reagents.add_reagent(reagent, C.volume)
	var/datum/reagent/R = reagent
	C.setLabel(initial(R.name))
	log_admin("[usr] spawned a [size] reagent container containing [reagent]")
