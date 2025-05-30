
///BSA unlocked by head ID swipes
GLOBAL_VAR_INIT(bsa_unlock, FALSE)

// Crew has to build a bluespace cannon
// Cargo orders part for high price
// Requires high amount of power
// Requires high level stock parts
/datum/station_goal/bluespace_cannon
	name = "Bluespace Artillery"

/datum/station_goal/bluespace_cannon/get_report()
	return {"Our military presence is inadequate in your sector.
		We need you to construct BSA-[rand(1,99)] Artillery position aboard your station.

		Base parts are available for shipping via cargo.
		-Nanotrasen Naval Command"}

/datum/station_goal/bluespace_cannon/on_report()
	//Unlock BSA parts
	var/datum/supply_pack/engineering/bsa/P = SSshuttle.supply_packs[/datum/supply_pack/engineering/bsa]
	P.special_enabled = TRUE

/datum/station_goal/bluespace_cannon/check_completion()
	if(..())
		return TRUE
	var/obj/machinery/bsa/full/B = locate()
	if(B && !B.machine_stat)
		return TRUE
	return FALSE

/obj/machinery/bsa
	icon = 'icons/obj/machines/particle_accelerator.dmi'
	density = TRUE
	anchored = TRUE

/obj/machinery/bsa/wrench_act(mob/living/user, obj/item/tool)
	. = ..()
	default_unfasten_wrench(user, tool, time = 1 SECONDS)
	return ITEM_INTERACT_SUCCESS

/obj/machinery/bsa/back
	name = "Bluespace Artillery Generator"
	desc = "Generates cannon pulse. Needs to be linked with a fusor."
	icon_state = "power_box"

/obj/machinery/bsa/back/multitool_act(mob/living/user, obj/item/I)
	if(!multitool_check_buffer(user, I)) //make sure it has a data buffer
		return
	var/obj/item/multitool/M = I
	M.buffer = src
	to_chat(user, span_notice("You store linkage information in [I]'s buffer."))
	return TRUE

/obj/machinery/bsa/front
	name = "Bluespace Artillery Bore"
	desc = "Do not stand in front of cannon during operation. Needs to be linked with a fusor."
	icon_state = "emitter_center"

/obj/machinery/bsa/front/multitool_act(mob/living/user, obj/item/I)
	if(!multitool_check_buffer(user, I)) //make sure it has a data buffer
		return
	var/obj/item/multitool/M = I
	M.buffer = src
	to_chat(user, span_notice("You store linkage information in [I]'s buffer."))
	return TRUE

/obj/machinery/bsa/middle
	name = "Bluespace Artillery Fusor"
	desc = "Contents classified by Nanotrasen Naval Command. Needs to be linked with the other BSA parts using a multitool."
	icon_state = "fuel_chamber"
	var/datum/weakref/back_ref
	var/datum/weakref/front_ref

/obj/machinery/bsa/middle/multitool_act(mob/living/user, obj/item/I)
	if(!multitool_check_buffer(user, I))
		return
	var/obj/item/multitool/M = I
	if(M.buffer)
		if(istype(M.buffer, /obj/machinery/bsa/back))
			back_ref = WEAKREF(M.buffer)
			to_chat(user, span_notice("You link [src] with [M.buffer]."))
			M.buffer = null
		else if(istype(M.buffer, /obj/machinery/bsa/front))
			front_ref = WEAKREF(M.buffer)
			to_chat(user, span_notice("You link [src] with [M.buffer]."))
			M.buffer = null
	else
		to_chat(user, span_warning("[I]'s data buffer is empty!"))
	return TRUE

/obj/machinery/bsa/middle/proc/check_completion()
	var/obj/machinery/bsa/front/front = front_ref?.resolve()
	var/obj/machinery/bsa/back/back = back_ref?.resolve()
	if(!front || !back)
		return "No linked parts detected!"
	if(!front.anchored || !back.anchored || !anchored)
		return "Linked parts unwrenched!"
	if(front.y != y || back.y != y || !(front.x > x && back.x < x || front.x < x && back.x > x) || front.z != z || back.z != z)
		return "Parts misaligned!"
	if(!has_space())
		return "Not enough free space!"

/obj/machinery/bsa/middle/proc/has_space()
	var/cannon_dir = get_cannon_direction()
	var/x_min
	var/x_max
	switch(cannon_dir)
		if(EAST)
			x_min = x - 4 //replace with defines later
			x_max = x + 6
		if(WEST)
			x_min = x + 4
			x_max = x - 6

	for(var/turf/T in block(locate(x_min,y-1,z),locate(x_max,y+1,z)))
		if(T.density || isspaceturf(T))
			return FALSE
	return TRUE

/obj/machinery/bsa/middle/proc/get_cannon_direction()
	var/obj/machinery/bsa/front/front = front_ref?.resolve()
	var/obj/machinery/bsa/back/back = back_ref?.resolve()
	if(!front || !back)
		return
	if(front.x > x && back.x < x)
		return EAST
	else if(front.x < x && back.x > x)
		return WEST


/obj/machinery/bsa/full
	name = "Bluespace Artillery"
	desc = "Long range bluespace artillery."
	icon = 'icons/obj/lavaland/cannon.dmi'
	icon_state = "orbital_cannon1"
	var/static/mutable_appearance/top_layer
	var/ex_power = 3
	var/power_used_per_shot = 2000000 //enough to kil standard apc - todo : make this use wires instead and scale explosion power with it
	var/ready
	pixel_y = -32
	pixel_x = -192
	bound_width = 352
	bound_x = -192
	appearance_flags = LONG_GLIDE //Removes default TILE_BOUND

/obj/machinery/bsa/full/wrench_act(mob/living/user, obj/item/I)
	return FALSE

/obj/machinery/bsa/full/proc/get_front_turf()
	switch(dir)
		if(WEST)
			return locate(x - 7,y,z)
		if(EAST)
			return locate(x + 7,y,z)
	return get_turf(src)

/obj/machinery/bsa/full/proc/get_back_turf()
	switch(dir)
		if(WEST)
			return locate(x + 5,y,z)
		if(EAST)
			return locate(x - 5,y,z)
	return get_turf(src)

/obj/machinery/bsa/full/proc/get_target_turf()
	switch(dir)
		if(WEST)
			return locate(1,y,z)
		if(EAST)
			return locate(world.maxx,y,z)
	return get_turf(src)

/obj/machinery/bsa/full/Initialize(mapload, cannon_direction = WEST)
	. = ..()
	top_layer ||= mutable_appearance(icon, layer = ABOVE_MOB_LAYER)
	switch(cannon_direction)
		if(WEST)
			setDir(WEST)
			top_layer.icon_state = "top_west"
			icon_state = "cannon_west"
		if(EAST)
			setDir(EAST)
			pixel_x = -128
			bound_x = -128
			top_layer.icon_state = "top_east"
			icon_state = "cannon_east"
	add_overlay(top_layer)
	reload()

/obj/machinery/bsa/full/proc/fire(mob/user, turf/bullseye)
	reload()

	var/turf/point = get_front_turf()
	var/turf/target = get_target_turf()
	var/atom/movable/blocker
	for(var/T in get_line(get_step(point, dir), target))
		var/turf/tile = T
		if(SEND_SIGNAL(tile, COMSIG_ATOM_BSA_BEAM) & COMSIG_ATOM_BLOCKS_BSA_BEAM)
			blocker = tile
		else
			for(var/AM in tile)
				var/atom/movable/stuff = AM
				if(SEND_SIGNAL(stuff, COMSIG_ATOM_BSA_BEAM) & COMSIG_ATOM_BLOCKS_BSA_BEAM)
					blocker = stuff
					break
		if(blocker)
			target = tile
			break
		else
			EX_ACT(tile, EXPLODE_DEVASTATE) //also fucks everything else on the turf
	point.Beam(target, icon_state = "bsa_beam", time = 5 SECONDS, maxdistance = world.maxx) //ZZZAP
	new /obj/effect/temp_visual/bsa_splash(point, dir)

	if(!blocker)
		message_admins("[ADMIN_LOOKUPFLW(user)] has launched an artillery strike targeting [ADMIN_VERBOSEJMP(bullseye)].")
		log_game("[key_name(user)] has launched an artillery strike targeting [AREACOORD(bullseye)].")
		explosion(bullseye, devastation_range = ex_power, heavy_impact_range = ex_power*2, light_impact_range = ex_power*4, explosion_cause = src)
	else
		message_admins("[ADMIN_LOOKUPFLW(user)] has launched an artillery strike targeting [ADMIN_VERBOSEJMP(bullseye)] but it was blocked by [blocker] at [ADMIN_VERBOSEJMP(target)].")
		log_game("[key_name(user)] has launched an artillery strike targeting [AREACOORD(bullseye)] but it was blocked by [blocker] at [AREACOORD(target)].")


/obj/machinery/bsa/full/proc/reload()
	ready = FALSE
	use_power(power_used_per_shot)
	addtimer(CALLBACK(src,"ready_cannon"),600)

/obj/machinery/bsa/full/proc/ready_cannon()
	ready = TRUE

/obj/structure/filler
	name = "big machinery part"
	density = TRUE
	anchored = TRUE
	invisibility = INVISIBILITY_ABSTRACT
	var/obj/machinery/parent

/obj/structure/filler/ex_act()
	return FALSE

/obj/machinery/computer/bsa_control
	name = "bluespace artillery control"
	use_power = NO_POWER_USE
	circuit = /obj/item/circuitboard/computer/bsa_control
	icon = 'icons/obj/machines/particle_accelerator.dmi'
	icon_state = "control_boxp"
	icon_keyboard = ""

	var/datum/weakref/cannon_ref
	var/notice
	var/target
	var/area_aim = FALSE //should also show areas for targeting

/obj/machinery/computer/bsa_control/ui_state(mob/user)
	return GLOB.physical_state

/obj/machinery/computer/bsa_control/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "BluespaceArtillery", name)
		ui.open()

/obj/machinery/computer/bsa_control/ui_data()
	var/obj/machinery/bsa/full/cannon = cannon_ref?.resolve()
	var/list/data = list()
	data["ready"] = cannon ? cannon.ready : FALSE
	data["connected"] = cannon
	data["notice"] = notice
	data["unlocked"] = GLOB.bsa_unlock
	if(target)
		data["target"] = get_target_name()
	return data

/obj/machinery/computer/bsa_control/ui_act(action, params)
	. = ..()
	if(.)
		return

	switch(action)
		if("build")
			cannon_ref = WEAKREF(deploy())
			. = TRUE
		if("fire")
			fire(usr)
			. = TRUE
		if("recalibrate")
			calibrate(usr)
			. = TRUE
	update_appearance()

/obj/machinery/computer/bsa_control/proc/calibrate(mob/user)
	if(!GLOB.bsa_unlock)
		return
	var/list/gps_locators = list()
	for(var/datum/component/gps/G in GLOB.GPS_list) //nulls on the list somehow
		if(G.tracking)
			gps_locators[G.gpstag] = G

	var/list/options = gps_locators
	if(area_aim)
		options += GLOB.teleportlocs
	var/victim = tgui_input_list(user, "Select target", "Artillery Targeting", options)
	if(isnull(victim))
		return
	if(isnull(options[victim]))
		return
	target = options[victim]
	log_game("[key_name(user)] has aimed the artillery strike at [target].")


/obj/machinery/computer/bsa_control/proc/get_target_name()
	if(istype(target, /area))
		return get_area_name(target, TRUE)
	else if(istype(target, /datum/component/gps))
		var/datum/component/gps/G = target
		return G.gpstag

/obj/machinery/computer/bsa_control/proc/get_impact_turf()
	if(istype(target, /area))
		return pick(get_area_turfs(target))
	else if(istype(target, /datum/component/gps))
		var/datum/component/gps/G = target
		return get_turf(G.parent)

/obj/machinery/computer/bsa_control/proc/fire(mob/user)
	var/obj/machinery/bsa/full/cannon = cannon_ref?.resolve()
	if(!cannon)
		notice = "No Cannon Exists!"
		return
	if(cannon.machine_stat)
		notice = "Cannon unpowered!"
		return
	notice = null
	cannon.fire(user, get_impact_turf())

/obj/machinery/computer/bsa_control/proc/deploy(force=FALSE)
	var/obj/machinery/bsa/full/prebuilt = locate() in range(7) //In case of adminspawn
	if(prebuilt)
		return prebuilt

	var/obj/machinery/bsa/middle/centerpiece = locate() in range(7)
	if(!centerpiece)
		notice = "No BSA parts detected nearby."
		return null
	notice = centerpiece.check_completion()
	if(notice)
		return null
	//Totally nanite construction system not an immersion breaking spawning
	var/datum/effect_system/fluid_spread/smoke/s = new
	s.set_up(4, location = get_turf(centerpiece))
	s.start()
	var/obj/machinery/bsa/full/cannon = new(get_turf(centerpiece),centerpiece.get_cannon_direction())
	QDEL_NULL(centerpiece.front_ref)
	QDEL_NULL(centerpiece.back_ref)
	qdel(centerpiece)
	return cannon
