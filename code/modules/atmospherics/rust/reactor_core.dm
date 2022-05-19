#define MAX_FIELD_STR 10000
#define MIN_FIELD_STR 1

/obj/machinery/power/reactor_core
	name = "\improper R-UST Mk. 10 Tokamak Reactor"
	desc = "An enormous solenoid for generating extremely high power electromagnetic fields."
	icon = 'icons/obj/machines/rust/fusion_core.dmi'
	icon_state = "core0"
	layer = ABOVE_ALL_MOB_LAYER
	density = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usage = IDLE_POWER_USE
	active_power_usage = 1000 //multiplied by field strength
	anchored = FALSE

	var/is_on = FALSE
	var/obj/effect/reactor_em_field/owned_field
	var/field_strength = 1//0.01
	var/initial_id_tag

	var/list/all_rods = list()
	var/list/control_rods = list()
	var/list/moderator_rods = list()
	var/list/fuel_rods = list()

	var/list/rods_by_slot = list(
		REACTOR_SLOT_1 = null,
		REACTOR_SLOT_2 = null,
		REACTOR_SLOT_3 = null,
		REACTOR_SLOT_4 = null,
		REACTOR_SLOT_5 = null,
		REACTOR_SLOT_6 = null,
		REACTOR_SLOT_7 = null,
		REACTOR_SLOT_8 = null,
		REACTOR_SLOT_9 = null
	)

/obj/machinery/power/reactor_core/mapped
	anchored = TRUE

/obj/machinery/power/reactor_core/process()
	if((machine_stat & BROKEN) || !use_power_from_net(use_power) || !owned_field)
		if(is_on)
			Shutdown()
/*
/obj/machinery/power/reactor_core/Topic(href, href_list)
	if(..())
		return 1
	if(href_list["str"])
		var/dif = text2num(href_list["str"])
		field_strength = min(max(field_strength + dif, MIN_FIELD_STR), MAX_FIELD_STR)
		change_power_consumption(500 * field_strength, POWER_USE_ACTIVE)
		if(owned_field)
			owned_field.ChangeFieldStrength(field_strength)
*/

/obj/machinery/power/reactor_core/proc/Startup()
	if(owned_field)
		return
	owned_field = new(loc, src)
	owned_field.set_field_strength(field_strength)
	icon_state = "core1"
	update_use_power(ACTIVE_POWER_USE)
	is_on = TRUE
	return TRUE

/obj/machinery/power/reactor_core/proc/Shutdown(force_rupture)
	if(owned_field)
		icon_state = "core0"
		if(force_rupture || owned_field.plasma_temperature > 1000)
			owned_field.rupture()
		else
			owned_field.radiate_all()
		qdel(owned_field)
		owned_field = null
	update_use_power(IDLE_POWER_USE)
	is_on = FALSE

/obj/machinery/power/reactor_core/proc/add_particles(name, quantity = 1)
	if(owned_field)
		owned_field.add_particles(name, quantity)
		return TRUE

/obj/machinery/power/reactor_core/bullet_act(obj/projectile/Proj)
	if(owned_field)
		. = owned_field.bullet_act(Proj)

/obj/machinery/power/reactor_core/proc/set_strength(value)
	value = clamp(value, MIN_FIELD_STR, MAX_FIELD_STR)
	field_strength = value
	active_power_usage = value*5
	if(owned_field)
		owned_field.set_field_strength(value)

/obj/machinery/power/reactor_core/attack_hand(mob/user)
	. = ..()
	if(!.)
		visible_message("<span class='notice'>\The [user] hugs \the [src] to make it feel better!</span>")
		if(owned_field)
			Shutdown()
		return TRUE

/obj/machinery/power/reactor_core/attackby(obj/item/W, mob/user)
	if(owned_field)
		to_chat(user,"<span class='warning'>Shut \the [src] off first!</span>")
		return

	if(W.tool_behaviour & TOOL_WRENCH)
		anchored = !anchored
		if(W.use_tool(user, 4 SECONDS))
			if(anchored)
				user.visible_message("[user.name] secures [src.name] to the floor.", \
					"You secure the [src.name] to the floor.", \
					"You hear a ratchet.")
			else
				user.visible_message("[user.name] unsecures [src.name] from the floor.", \
					"You unsecure the [src.name] from the floor.", \
					"You hear a ratchet.")
		return

	return ..()

/obj/machinery/power/reactor_core/proc/Jumpstart(field_temperature)
	field_strength = 501 // Generally a good size.
	Startup()
	if(!owned_field)
		return FALSE
	owned_field.plasma_temperature = field_temperature
	return TRUE

/obj/machinery/power/reactor_core/proc/check_core_status()
	if(machine_stat & BROKEN)
		return FALSE
	/*if(idle_power_usage > avail())
		return FALSE*/
	return TRUE
