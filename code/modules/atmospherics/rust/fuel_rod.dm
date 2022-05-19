/obj/item/fuel_rod
	name = "fuel rod"
	desc = "A heavy container filled with a reactive substance"
	icon = 'icons/obj/machines/rust/fuel_rod.dmi'
	flags_1 = CONDUCT_1
	hitsound = 'sound/weapons/smash.ogg'
	force = 5
	throwforce = 10
	throw_speed = 1
	throw_range = 4
	custom_materials = list(/datum/material/iron = 500)

	var/obj/machinery/power/reactor_core/parent
	var/max_volume
	///The amount of contents being exposed to the air, as a decimal
	var/exposure_rate = 0

/obj/item/fuel_rod/proc/return_volume()
	return

/obj/item/fuel_rod/gas
	name = "fuel rod (gas)"
	desc = "A long and heavy container used for storing highly compressed gas."

	max_volume = FUEL_ROD_GAS_VOLUME
	var/datum/gas_mixture/air_contents = null

/obj/item/fuel_rod/gas/Initialize(mapload)
	. = ..()
	air_contents = new(max_volume)

/obj/item/fuel_rod/gas/return_volume()
	return air_contents.removeVolume(exposure_rate * air_contents.volume)

/obj/item/fuel_rod/reagent
	name = "fuel rod (reagent)"

	max_volume = FUEL_ROD_REAGENT_VOLUME

/obj/item/fuel_rod/reagent/Initialize(mapload)
	. = ..()
	create_reagents(max_volume, TRANSPARENT)

/obj/item/fuel_rod/reagent/return_volume()
	return reagents.trans_to(parent, max_volume * exposure_rate, show_message = FALSE)
