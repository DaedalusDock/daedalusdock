// Premade dispensers for mappers.

/obj/machinery/chem_dispenser/drinks
	name = "soda dispenser"
	desc = "Contains a large reservoir of soft drinks."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "soda_dispenser"
	base_icon_state = "soda_dispenser"
	has_panel_overlay = FALSE
	dispensed_temperature = WATER_MATTERSTATE_CHANGE_TEMP // magical mystery temperature of 274.5, where ice does not melt, and water does not freeze
	heater_coefficient = SOFT_DISPENSER_HEATER_COEFFICIENT
	amount = 10
	pixel_y = 6
	circuit = /obj/item/circuitboard/machine/chem_dispenser/drinks
	working_state = null
	nopower_state = null
	pass_flags = PASSTABLE
	spawn_cartridges = CARTRIDGE_LIST_DRINKS

/obj/machinery/chem_dispenser/drinks/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/simple_rotation)

/obj/machinery/chem_dispenser/drinks/setDir()
	var/old = dir
	. = ..()
	if(dir != old)
		update_appearance()  // the beaker needs to be re-positioned if we rotate

/obj/machinery/chem_dispenser/drinks/display_beaker()
	var/mutable_appearance/b_o = beaker_overlay || mutable_appearance(icon, "disp_beaker")
	switch(dir)
		if(NORTH)
			b_o.pixel_y = 7
			b_o.pixel_x = rand(-9, 9)
		if(EAST)
			b_o.pixel_x = 4
			b_o.pixel_y = rand(-5, 7)
		if(WEST)
			b_o.pixel_x = -5
			b_o.pixel_y = rand(-5, 7)
		else//SOUTH
			b_o.pixel_y = -7
			b_o.pixel_x = rand(-9, 9)
	return b_o

/obj/machinery/chem_dispenser/drinks/beer
	name = "booze dispenser"
	desc = "Contains a large reservoir of the good stuff."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "booze_dispenser"
	base_icon_state = "booze_dispenser"
	dispensed_temperature = WATER_MATTERSTATE_CHANGE_TEMP
	heater_coefficient = SOFT_DISPENSER_HEATER_COEFFICIENT
	circuit = /obj/item/circuitboard/machine/chem_dispenser/drinks/beer
	spawn_cartridges = CARTRIDGE_LIST_BOOZE

/obj/machinery/chem_dispenser/mini/mutagen
	name = "mini mutagen dispenser"
	desc = "Dispenses mutagen."
	spawn_cartridges = list(/datum/reagent/toxin/mutagen = /obj/item/reagent_containers/chem_cartridge/medium)


/obj/machinery/chem_dispenser/mini/mutagensaltpeter
	name = "botanical mini chemical dispenser"
	desc = "Dispenses chemicals useful for botany."

	spawn_cartridges = CARTRIDGE_LIST_BOTANY
