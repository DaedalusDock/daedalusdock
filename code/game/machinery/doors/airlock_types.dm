/*
	Station Airlocks Regular
*/

/obj/machinery/door/airlock/command
	assemblytype = /obj/structure/door_assembly/door_assembly_com
	normal_integrity = 450
	airlock_paint = "#334E6D"
	stripe_paint = "#43769D"

/obj/machinery/door/airlock/security
	assemblytype = /obj/structure/door_assembly/door_assembly_sec
	normal_integrity = 450
	airlock_paint = "#9F2828"
	stripe_paint = "#D27428"

/obj/machinery/door/airlock/engineering
	assemblytype = /obj/structure/door_assembly/door_assembly_eng
	airlock_paint = "#A28226"
	stripe_paint = "#7F292F"

/obj/machinery/door/airlock/medical
	assemblytype = /obj/structure/door_assembly/door_assembly_med
	airlock_paint = "#BBBBBB"
	stripe_paint = "#5995BA"

/obj/machinery/door/airlock/hydroponics	//Hydroponics front doors!
	assemblytype = /obj/structure/door_assembly/door_assembly_hydro
	airlock_paint = "#559958"
	stripe_paint = "#0650A4"

/obj/machinery/door/airlock/maintenance
	name = "maintenance access"
	assemblytype = /obj/structure/door_assembly/door_assembly_mai
	normal_integrity = 250
	stripe_paint = "#B69F3C"

/obj/machinery/door/airlock/maintenance/external
	name = "external airlock access"
	assemblytype = /obj/structure/door_assembly/door_assembly_extmai
	stripe_paint = "#9F2828"

/obj/machinery/door/airlock/mining
	name = "mining airlock"
	assemblytype = /obj/structure/door_assembly/door_assembly_min
	airlock_paint = "#967032"
	stripe_paint = "#5F350B"

/obj/machinery/door/airlock/atmos
	name = "atmospherics airlock"
	assemblytype = /obj/structure/door_assembly/door_assembly_atmo
	airlock_paint = "#A28226"
	stripe_paint = "#469085"

/obj/machinery/door/airlock/research
	assemblytype = /obj/structure/door_assembly/door_assembly_research
	airlock_paint = "#BBBBBB"
	stripe_paint = "#563758"

/obj/machinery/door/airlock/freezer
	name = "freezer airlock"
	assemblytype = /obj/structure/door_assembly/door_assembly_fre
	airlock_paint = "#BBBBBB"

/obj/machinery/door/airlock/science
	assemblytype = /obj/structure/door_assembly/door_assembly_science
	airlock_paint = "#BBBBBB"
	stripe_paint = "#6633CC"

/obj/machinery/door/airlock/virology
	assemblytype = /obj/structure/door_assembly/door_assembly_viro
	airlock_paint = "#BBBBBB"
	stripe_paint = "#2a7a25"

//////////////////////////////////
/*
	Station Airlocks Glass
*/

/obj/machinery/door/airlock/glass
	opacity = FALSE
	glass = TRUE

/obj/machinery/door/airlock/glass/incinerator
	autoclose = FALSE
	frequency = FREQ_AIRLOCK_CONTROL
	heat_proof = TRUE
	req_access = list(ACCESS_SYNDICATE)

/obj/machinery/door/airlock/glass/incinerator/syndicatelava_interior
	name = "Turbine Interior Airlock"
	id_tag = INCINERATOR_SYNDICATELAVA_AIRLOCK_INTERIOR

/obj/machinery/door/airlock/glass/incinerator/syndicatelava_exterior
	name = "Turbine Exterior Airlock"
	id_tag = INCINERATOR_SYNDICATELAVA_AIRLOCK_EXTERIOR

/obj/machinery/door/airlock/command/glass
	opacity = FALSE
	glass = TRUE
	normal_integrity = 400

/obj/machinery/door/airlock/engineering/glass
	opacity = FALSE
	glass = TRUE

/obj/machinery/door/airlock/engineering/glass/critical
	critical_machine = TRUE //stops greytide virus from opening & bolting doors in critical positions, such as the SM chamber.

/obj/machinery/door/airlock/security/glass
	opacity = FALSE
	glass = TRUE
	normal_integrity = 400

/obj/machinery/door/airlock/medical/glass
	opacity = FALSE
	glass = TRUE

/obj/machinery/door/airlock/hydroponics/glass //Uses same icon as medical/glass, maybe update it with its own unique icon one day?
	opacity = FALSE
	glass = TRUE

/obj/machinery/door/airlock/research/glass
	opacity = FALSE
	glass = TRUE

/obj/machinery/door/airlock/research/glass/incinerator
	autoclose = FALSE
	frequency = FREQ_AIRLOCK_CONTROL
	heat_proof = TRUE
	req_access = list(ACCESS_ORDNANCE)

/obj/machinery/door/airlock/research/glass/incinerator/ordmix_interior
	name = "Mixing Room Interior Airlock"
	id_tag = INCINERATOR_ORDMIX_AIRLOCK_INTERIOR

/obj/machinery/door/airlock/research/glass/incinerator/ordmix_exterior
	name = "Mixing Room Exterior Airlock"
	id_tag = INCINERATOR_ORDMIX_AIRLOCK_EXTERIOR

/obj/machinery/door/airlock/mining/glass
	opacity = FALSE
	glass = TRUE

/obj/machinery/door/airlock/atmos/glass
	opacity = FALSE
	glass = TRUE

/obj/machinery/door/airlock/atmos/glass/critical
	critical_machine = TRUE //stops greytide virus from opening & bolting doors in critical positions, such as the SM chamber.

/obj/machinery/door/airlock/science/glass
	opacity = FALSE
	glass = TRUE

/obj/machinery/door/airlock/virology/glass
	opacity = FALSE
	glass = TRUE

/obj/machinery/door/airlock/maintenance/glass
	opacity = FALSE
	glass = TRUE

/obj/machinery/door/airlock/maintenance/external/glass
	opacity = FALSE
	glass = TRUE
	normal_integrity = 200

//////////////////////////////////
/*
	Station Airlocks Mineral
*/

/obj/machinery/door/airlock/gold
	name = "gold airlock"
	assemblytype = /obj/structure/door_assembly/door_assembly_gold
	airlock_paint = "#9F891F"

/obj/machinery/door/airlock/gold/glass
	opacity = FALSE
	glass = TRUE

/obj/machinery/door/airlock/silver
	name = "silver airlock"
	assemblytype = /obj/structure/door_assembly/door_assembly_silver
	airlock_paint = "#C9C9C9"

/obj/machinery/door/airlock/silver/glass
	opacity = FALSE
	glass = TRUE

/obj/machinery/door/airlock/diamond
	name = "diamond airlock"
	assemblytype = /obj/structure/door_assembly/door_assembly_diamond
	normal_integrity = 1000
	explosion_block = 2
	airlock_paint = "#4AB4B4"

/obj/machinery/door/airlock/diamond/glass
	normal_integrity = 950
	opacity = FALSE
	glass = TRUE

/obj/machinery/door/airlock/uranium
	name = "uranium airlock"
	assemblytype = /obj/structure/door_assembly/door_assembly_uranium
	airlock_paint = "#174207"
	var/last_event = 0
	//Is this airlock actually radioactive?
	var/actually_radioactive = TRUE

/obj/machinery/door/airlock/uranium/process()
	if(actually_radioactive && world.time > last_event+20)
		if(prob(50))
			radiate()
		last_event = world.time
	..()

/obj/machinery/door/airlock/uranium/proc/radiate()
	radiation_pulse(
		src,
		max_range = 2,
		threshold = RAD_LIGHT_INSULATION,
		chance = URANIUM_IRRADIATION_CHANCE,
		minimum_exposure_time = URANIUM_RADIATION_MINIMUM_EXPOSURE_TIME,
	)

/obj/machinery/door/airlock/uranium/glass
	opacity = FALSE
	glass = TRUE

/obj/machinery/door/airlock/uranium/safe
	actually_radioactive = FALSE

/obj/machinery/door/airlock/uranium/glass/safe
	actually_radioactive = FALSE

/obj/machinery/door/airlock/plasma
	name = "plasma airlock"
	desc = "No way this can end badly."
	assemblytype = /obj/structure/door_assembly/door_assembly_plasma
	airlock_paint = "#65217B"
	material_flags = MATERIAL_EFFECTS
	material_modifier = 0.25

/obj/machinery/door/airlock/plasma/Initialize(mapload)
	custom_materials = custom_materials ? custom_materials : list(/datum/material/plasma = 20000)
	. = ..()

/obj/machinery/door/airlock/plasma/block_superconductivity() //we don't stop the heat~
	return 0

/obj/machinery/door/airlock/plasma/glass
	opacity = FALSE
	glass = TRUE

/obj/machinery/door/airlock/bananium
	name = "bananium airlock"
	desc = "Honkhonkhonk"
	assemblytype = /obj/structure/door_assembly/door_assembly_bananium
	airlock_paint = "#FFFF00"
	doorOpen = 'sound/items/bikehorn.ogg'

/obj/machinery/door/airlock/bananium/glass
	opacity = FALSE
	glass = TRUE

/obj/machinery/door/airlock/sandstone
	name = "sandstone airlock"
	assemblytype = /obj/structure/door_assembly/door_assembly_sandstone
	airlock_paint = "#C09A72"

/obj/machinery/door/airlock/sandstone/glass
	opacity = FALSE
	glass = TRUE

/obj/machinery/door/airlock/wood
	name = "wooden airlock"
	assemblytype = /obj/structure/door_assembly/door_assembly_wood
	airlock_paint = "#805F44"

/obj/machinery/door/airlock/wood/glass
	opacity = FALSE
	glass = TRUE

/obj/machinery/door/airlock/titanium
	name = "shuttle airlock"
	assemblytype = /obj/structure/door_assembly/door_assembly_titanium
	airlock_paint = "#b3c0c7"
	normal_integrity = 400

/obj/machinery/door/airlock/titanium/glass
	normal_integrity = 350
	opacity = FALSE
	glass = TRUE

/obj/machinery/door/airlock/bronze
	name = "bronze airlock"
	assemblytype = /obj/structure/door_assembly/door_assembly_bronze
	airlock_paint = "#9c5f05"

/obj/machinery/door/airlock/bronze/seethru
	assemblytype = /obj/structure/door_assembly/door_assembly_bronze/seethru
	opacity = FALSE
	glass = TRUE
//////////////////////////////////
/*
	Station2 Airlocks
*/

/obj/machinery/door/airlock/public
	icon = 'icons/obj/doors/airlocks/station2/airlock.dmi'
	glass_fill_overlays = 'icons/obj/doors/airlocks/station2/glass_overlays.dmi'
	assemblytype = /obj/structure/door_assembly/door_assembly_public

/obj/machinery/door/airlock/public/glass
	opacity = FALSE
	glass = TRUE

/obj/machinery/door/airlock/public/glass/incinerator
	autoclose = FALSE
	frequency = FREQ_AIRLOCK_CONTROL
	heat_proof = TRUE
	req_one_access = list(ACCESS_ATMOSPHERICS, ACCESS_MAINT_TUNNELS)

/obj/machinery/door/airlock/public/glass/incinerator/atmos_interior
	name = "Turbine Interior Airlock"
	id_tag = INCINERATOR_ATMOS_AIRLOCK_INTERIOR

/obj/machinery/door/airlock/public/glass/incinerator/atmos_exterior
	name = "Turbine Exterior Airlock"
	id_tag = INCINERATOR_ATMOS_AIRLOCK_EXTERIOR

//////////////////////////////////
/*
	External Airlocks
*/

/obj/machinery/door/airlock/external
	name = "external airlock"
	icon = 'icons/obj/doors/airlocks/external/airlock.dmi'
	color_overlays = 'icons/obj/doors/airlocks/external/airlock_color.dmi'
	glass_fill_overlays = 'icons/obj/doors/airlocks/external/glass_overlays.dmi'
	overlays_file = 'icons/obj/doors/airlocks/external/overlays.dmi'
	airlock_paint = "#9F2828"
	assemblytype = /obj/structure/door_assembly/door_assembly_ext
	req_access = list(ACCESS_EXTERNAL_AIRLOCKS)

	/// Whether or not the airlock can be opened without access from a certain direction while powered, or with bare hands from any direction while unpowered OR pressurized.
	var/space_dir = null

/obj/machinery/door/airlock/external/Initialize(mapload, ...)
	// default setting is for mapping only, let overrides work
	if(!mapload || req_access_txt || req_one_access_txt)
		req_access = null

	return ..()

/obj/machinery/door/airlock/external/LateInitialize()
	. = ..()
	if(space_dir)
		unres_sides |= space_dir

/obj/machinery/door/airlock/external/examine(mob/user)
	. = ..()
	if(space_dir)
		. += span_notice("It has labels indicating that it has an emergency mechanism to open from the [dir2text(space_dir)] side with <b>just your hands</b> even if there's no power.")

/obj/machinery/door/airlock/external/cyclelinkairlock()
	. = ..()
	var/obj/machinery/door/airlock/external/cycle_linked_external_airlock = cyclelinkedairlock
	if(istype(cycle_linked_external_airlock))
		cycle_linked_external_airlock.space_dir |= space_dir
		space_dir |= cycle_linked_external_airlock.space_dir

/obj/machinery/door/airlock/external/try_safety_unlock(mob/user)
	if(space_dir && density)
		if(!hasPower())
			to_chat(user, span_notice("You begin unlocking the airlock safety mechanism..."))
			if(do_after(user, src, 15 SECONDS))
				try_to_crowbar(null, user, TRUE)
				return TRUE
		else
			// always open from the space side
			// get_dir(src, user) & space_dir, checked in unresricted_sides
			var/should_safety_open = shuttledocked || cyclelinkedairlock?.shuttledocked || is_safe_turf(get_step(src, space_dir), TRUE, FALSE)
			return try_to_activate_door(user, should_safety_open)

	return ..()

/// Access free external airlock
/obj/machinery/door/airlock/external/ruin
	req_access = null

/obj/machinery/door/airlock/external/glass
	opacity = FALSE
	glass = TRUE

/// Access free external glass airlock
/obj/machinery/door/airlock/external/glass/ruin
	req_access = null

//////////////////////////////////
/*
	CentCom Airlocks
*/

/obj/machinery/door/airlock/centcom //Use grunge as a station side version, as these have special effects related to them via phobias and such.
	icon = 'icons/obj/doors/airlocks/centcom/airlock.dmi'
	assemblytype = /obj/structure/door_assembly/door_assembly_centcom
	normal_integrity = 1000
	security_level = 6
	explosion_block = 2

/obj/machinery/door/airlock/grunge
	icon = 'icons/obj/doors/airlocks/centcom/airlock.dmi'
	assemblytype = /obj/structure/door_assembly/door_assembly_grunge

//////////////////////////////////
/*
	Vault Airlocks
*/

/obj/machinery/door/airlock/vault
	name = "vault door"
	icon = 'icons/obj/doors/airlocks/vault/airlock.dmi'
	overlays_file = 'icons/obj/doors/airlocks/vault/overlays.dmi'
	assemblytype = /obj/structure/door_assembly/door_assembly_vault
	explosion_block = 2
	normal_integrity = 400 // reverse engieneerd: 400 * 1.5 (sec lvl 6) = 600 = original
	security_level = 6
	has_fill_overlays = FALSE

//////////////////////////////////
/*
	Hatch Airlocks
*/

/obj/machinery/door/airlock/hatch
	name = "airtight hatch"
	icon = 'icons/obj/doors/airlocks/hatch/airlock.dmi'
	stripe_overlays = 'icons/obj/doors/airlocks/hatch/airlock_stripe.dmi'
	assemblytype = /obj/structure/door_assembly/door_assembly_hatch

/obj/machinery/door/airlock/maintenance_hatch
	name = "maintenance hatch"
	icon = 'icons/obj/doors/airlocks/hatch/airlock.dmi'
	stripe_overlays = 'icons/obj/doors/airlocks/hatch/airlock_stripe.dmi'
	overlays_file = 'icons/obj/doors/airlocks/hatch/overlays.dmi'
	assemblytype = /obj/structure/door_assembly/door_assembly_mhatch
	stripe_paint = "#B69F3C"

//////////////////////////////////
/*
	High Security Airlocks
*/

/obj/machinery/door/airlock/highsecurity
	name = "high tech security airlock"
	icon = 'icons/obj/doors/airlocks/highsec/airlock.dmi'
	color_overlays = null
	stripe_overlays = null
	has_fill_overlays = FALSE
	assemblytype = /obj/structure/door_assembly/door_assembly_highsecurity
	explosion_block = 2
	normal_integrity = 500
	security_level = 1
	damage_deflection = 30

//////////////////////////////////
/*
	Shuttle Airlocks
*/

/obj/machinery/door/airlock/shuttle
	name = "shuttle airlock"
	assemblytype = /obj/structure/door_assembly/door_assembly_shuttle
	airlock_paint = "#b3c0c7"

/obj/machinery/door/airlock/shuttle/glass
	opacity = FALSE
	glass = TRUE

/obj/machinery/door/airlock/abductor
	name = "alien airlock"
	desc = "With humanity's current technological level, it could take years to hack this advanced airlock... or maybe we should give a screwdriver a try?"
	assemblytype = /obj/structure/door_assembly/door_assembly_abductor
	damage_deflection = 30
	explosion_block = 3
	hackProof = TRUE
	aiControlDisabled = AI_WIRE_DISABLED
	normal_integrity = 700
	security_level = 1
	airlock_paint = "#333333"
	stripe_paint = "#6633CC"

//////////////////////////////////
/*
	Cult Airlocks
*/

/obj/machinery/door/airlock/cult
	name = "cult airlock"
	assemblytype = /obj/structure/door_assembly/door_assembly_cult
	hackProof = TRUE
	aiControlDisabled = AI_WIRE_DISABLED
	req_access = list(ACCESS_BLOODCULT)
	damage_deflection = 10
	airlock_paint = "#333333"
	stripe_paint = "#610000"
	var/openingoverlaytype = /obj/effect/temp_visual/cult/door
	var/friendly = FALSE
	var/stealthy = FALSE

/obj/machinery/door/airlock/cult/Initialize(mapload)
	. = ..()
	new openingoverlaytype(loc)

/obj/machinery/door/airlock/cult/canAIControl(mob/user)
	return (IS_CULTIST(user) && !isAllPowerCut())

/obj/machinery/door/airlock/cult/on_break()
	if(!panel_open)
		panel_open = TRUE

/obj/machinery/door/airlock/cult/isElectrified()
	return FALSE

/obj/machinery/door/airlock/cult/hasPower()
	return TRUE

/obj/machinery/door/airlock/cult/allowed(mob/living/L)
	if(!density)
		return TRUE
	if(friendly || IS_CULTIST(L) || istype(L, /mob/living/simple_animal/shade) || isconstruct(L))
		if(!stealthy)
			new openingoverlaytype(loc)
		return TRUE
	else
		if(!stealthy)
			new /obj/effect/temp_visual/cult/sac(loc)
			var/atom/throwtarget
			throwtarget = get_edge_target_turf(src, get_dir(src, get_step_away(L, src)))
			SEND_SOUND(L, sound(pick('sound/hallucinations/turn_around1.ogg','sound/hallucinations/turn_around2.ogg'),0,1,50))
			flash_color(L, flash_color="#960000", flash_time=20)
			L.Paralyze(40)
			L.throw_at(throwtarget, 5, 1)
		return FALSE

/obj/machinery/door/airlock/cult/proc/conceal()
	icon = 'icons/obj/doors/airlocks/station/airlock.dmi'
	overlays_file = 'icons/obj/doors/airlocks/station/overlays.dmi'
	name = "airlock"
	desc = "It opens and closes."
	stealthy = TRUE
	update_appearance()

/obj/machinery/door/airlock/cult/proc/reveal()
	icon = initial(icon)
	overlays_file = initial(overlays_file)
	name = initial(name)
	desc = initial(desc)
	stealthy = initial(stealthy)
	update_appearance()

/obj/machinery/door/airlock/cult/narsie_act()
	return

/obj/machinery/door/airlock/cult/emp_act(severity)
	return

/obj/machinery/door/airlock/cult/friendly
	friendly = TRUE

/obj/machinery/door/airlock/cult/glass
	glass = TRUE
	opacity = FALSE

/obj/machinery/door/airlock/cult/glass/friendly
	friendly = TRUE

/obj/machinery/door/airlock/cult/unruned
	assemblytype = /obj/structure/door_assembly/door_assembly_cult/unruned
	openingoverlaytype = /obj/effect/temp_visual/cult/door/unruned

/obj/machinery/door/airlock/cult/unruned/friendly
	friendly = TRUE

/obj/machinery/door/airlock/cult/unruned/glass
	glass = TRUE
	opacity = FALSE

/obj/machinery/door/airlock/cult/unruned/glass/friendly
	friendly = TRUE

/obj/machinery/door/airlock/cult/weak
	name = "brittle cult airlock"
	desc = "An airlock hastily corrupted by blood magic, it is unusually brittle in this state."
	normal_integrity = 150
	damage_deflection = 5
	armor = list(MELEE = 0, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 0, BIO = 0, FIRE = 0, ACID = 0)

//////////////////////////////////
/*
	Misc Airlocks
*/

/obj/machinery/door/airlock/glass_large
	name = "large glass airlock"
	icon = 'icons/obj/doors/airlocks/glass_large/glass_large.dmi'
	overlays_file = 'icons/obj/doors/airlocks/glass_large/overlays.dmi'
	opacity = FALSE
	assemblytype = null
	glass = TRUE
	bound_width = 64 // 2x1

/obj/machinery/door/airlock/glass_large/narsie_act()
	return
