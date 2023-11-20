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
	///Fuel, Control, Moderator
	var/rod_type
	///The reactor slot this rod occupies
	var/occupied_slot
	var/max_volume
	///The amount of contents being exposed to the air, as a decimal
	var/exposure_rate = 0

/obj/item/fuel_rod/Destroy(force)
	if(parent)
		remove(parent)
	return ..()

/obj/item/fuel_rod/proc/return_volume()
	return

/obj/item/fuel_rod/proc/insert(obj/machinery/power/reactor_core/reactor, slot, mob/user) // No, you can't put two in one slot. Im sorry.
	if(reactor.rods_by_slot[slot])
		to_chat(user, span_notice("There is already a fuel rod in that slot."))
		return

	parent = reactor
	parent.rods_by_slot[slot] = src
	parent.all_rods += src
	occupied_slot = slot

	switch(rod_type)
		if(ROD_FUEL)
			parent.fuel_rods += src
		if(ROD_CONTROL)
			parent.control_rods += src
		if(ROD_MODERATOR)
			parent.moderator_rods += src


/obj/item/fuel_rod/proc/remove(mob/user) // PULL OUT PULL OUT
	if(!parent)
		CRASH("Fuel rod remove() called with no parent")

	if(user)
		INVOKE_ASYNC(user, TYPE_PROC_REF(/mob, put_in_hands), src)
	else
		forceMove(get_turf(parent))

	parent.rods_by_slot[occupied_slot] = null
	parent.all_rods -= src
	occupied_slot = null
	switch(rod_type)
		if(ROD_FUEL)
			parent.fuel_rods -= src
		if(ROD_CONTROL)
			parent.control_rods -= src
		if(ROD_MODERATOR)
			parent.moderator_rods -= src
	parent = null

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
