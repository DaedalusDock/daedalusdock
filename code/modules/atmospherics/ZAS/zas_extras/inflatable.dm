/obj/item/inflatable
	name = "inflatable"
	w_class = WEIGHT_CLASS_NORMAL
	icon = 'modular_pariah/master_files/icons/obj/inflatable.dmi'
	max_integrity = 10
	var/deploy_path = null

/obj/item/inflatable/attack_self(mob/user, modifiers)
	if(!deploy_path)
		return
	user.dropItemToGround(src)
	anchored = TRUE
	add_fingerprint(user)

	user.visible_message(
		span_notice("\The [user] pulls the inflation cord on \the [src]."),
		span_notice("You pull the inflation cord on \the [src]."),
		span_hear("You can hear rushing air."),
		vision_distance = 5
	)

	addtimer(CALLBACK(src, PROC_REF(inflate), user), 2 SECONDS)

/obj/item/inflatable/proc/inflate(mob/user)
	var/turf/T = get_turf(src)
	if(!T)
		anchored = FALSE
		visible_message(span_notice("\The [src] fails to inflate here."))
		return
	if(T.contains_dense_objects())
		anchored = FALSE
		visible_message(span_notice("\The [src] is blocked and fails to inflate."))
		return

	playsound(loc, 'sound/items/zip.ogg', 75, 1)
	var/obj/structure/inflatable/R = new deploy_path(T)
	transfer_fingerprints_to(R)
	if(user)
		R.add_fingerprint(user)
	update_integrity(R.get_integrity())
	qdel(src)

/obj/item/inflatable/wall
	name = "inflatable wall"
	desc = "A folded membrane which rapidly expands into a large cubical shape on activation."
	icon_state = "folded_wall"
	deploy_path = /obj/structure/inflatable/wall

/obj/item/inflatable/door
	name = "inflatable door"
	desc = "A folded membrane which rapidly expands into a simple door on activation."
	icon_state = "folded_door"
	deploy_path = /obj/structure/inflatable/door

/obj/item/inflatable/shelter
	name = "inflatable shelter"
	desc = "A special plasma shelter designed to resist great heat and temperatures so that victims can survive until rescue."
	icon_state = "folded"
	deploy_path = /obj/structure/inflatable/shelter

/obj/structure/inflatable
	name = "inflatable"
	desc = "An inflated membrane. Do not puncture."
	density = TRUE
	anchored = TRUE
	opacity = 0
	icon = 'modular_pariah/master_files/icons/obj/inflatable.dmi'
	icon_state = "wall"
	can_atmos_pass = CANPASS_DENSITY
	max_integrity = 10


	var/undeploy_path = null
	var/taped

	var/max_pressure_diff = 50 * ONE_ATMOSPHERE // In Baystation this is a Rigsuit level of protection
	var/max_temp = 5000 //In Baystation this is the heat protection value of a space suit.

/obj/structure/inflatable/wall
	name = "inflatable wall"
	undeploy_path = /obj/item/inflatable/wall
	can_atmos_pass = CANPASS_NEVER

/obj/structure/inflatable/Initialize()
	. = ..()
	zas_update_loc()

/obj/structure/inflatable/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/structure/inflatable/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/structure/inflatable/process()
	check_environment()

/obj/structure/inflatable/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	playsound(src, 'sound/effects/glasshit.ogg', 75, TRUE)

/obj/structure/inflatable/proc/check_environment()
	var/min_pressure = INFINITY
	var/max_pressure = 0
	var/max_local_temp = 0

	for(var/check_dir in GLOB.cardinals)
		var/turf/T = get_step(src, check_dir)
		var/datum/gas_mixture/env = T.unsafe_return_air()
		var/pressure = env.returnPressure()
		min_pressure = min(min_pressure, pressure)
		max_pressure = max(max_pressure, pressure)
		max_local_temp = max(max_local_temp, env.temperature)

	if(prob(50) && (max_pressure - min_pressure > max_pressure_diff || max_local_temp > max_temp))
		var/initial_damage_percentage = round(atom_integrity / max_integrity * 100)
		take_damage(1)
		var/damage_percentage = round(atom_integrity / max_integrity * 100)
		if (damage_percentage >= 70 && initial_damage_percentage < 70)
			visible_message(span_warning("\The [src] is barely holding up!"))
		else if (damage_percentage >= 30 && initial_damage_percentage < 30)
			visible_message(span_warning("\The [src] is taking damage!"))

/obj/structure/inflatable/examine(mob/user)
	. = ..()
	if (taped)
		to_chat(user, span_notice("It's being held together by duct tape."))

/obj/structure/inflatable/attackby(obj/item/W, mob/user, params)
	if(!istype(W)) //|| istype(W, /obj/item/inflatable_dispenser))
		return

	if(!isturf(user.loc))
		return //can't do this stuff whilst inside objects and such
	if(isliving(user))
		var/mob/living/living_user = user
		if(living_user.combat_mode)
			if (W.sharpness & SHARP_POINTY || W.force > 10)
				attack_generic(user, W.force, BRUTE)
			return

	if(istype(W, /obj/item/stack/sticky_tape) && (max_integrity - atom_integrity) >= 3)
		if(taped)
			to_chat(user, span_notice("\The [src] can't be patched any more with \the [W]!"))
			return TRUE
		else
			taped = TRUE
			to_chat(user, span_notice("You patch some damage in \the [src] with \the [W]!"))
			repair_damage(3)
			return TRUE

	..()

/obj/structure/inflatable/atom_break(damage_flag)
	. = ..()
	deflate(TRUE)

/obj/structure/inflatable/proc/deflate(violent)
	playsound(loc, 'sound/machines/hiss.ogg', 75, 1)
	if(violent)
		visible_message("[src] rapidly deflates!")
		var/obj/item/inflatable/torn/R = new /obj/item/inflatable/torn(loc)
		src.transfer_fingerprints_to(R)
		qdel(src)
	else
		if(!undeploy_path)
			return
		visible_message("\The [src] slowly deflates.")
		addtimer(CALLBACK(src, PROC_REF(after_deflate)), 5 SECONDS, TIMER_STOPPABLE)

/obj/structure/inflatable/proc/after_deflate()
	if(QDELETED(src))
		return
	var/obj/item/inflatable/R = new undeploy_path(src.loc)
	src.transfer_fingerprints_to(R)
	R.update_integrity(src.get_integrity())
	qdel(src)

/obj/structure/inflatable/verb/hand_deflate()
	set name = "Deflate"
	set category = "Object"
	set src in oview(1)

	if(!usr.Adjacent(src))
		return FALSE
	if(!usr.Adjacent(src))
		return FALSE
	if(!iscarbon(usr))
		return FALSE

	var/mob/living/carbon/user = usr
	if(user.handcuffed || user.stat != CONSCIOUS || user.incapacitated())
		return FALSE

	verbs -= /obj/structure/inflatable/verb/hand_deflate
	deflate()
	return TRUE

/obj/structure/inflatable/attack_generic(mob/user, damage, attack_verb)
	. = ..()
	if(.)
		user.visible_message("<span class='danger'>[user] [attack_verb] open the [src]!</span>")
	else
		user.visible_message("<span class='danger'>[user] [attack_verb] at [src]!</span>")


/obj/structure/inflatable/door //Based on mineral door code
	name = "inflatable door"
	density = TRUE
	anchored = TRUE
	opacity = 0

	icon_state = "door_closed"
	undeploy_path = /obj/item/inflatable/door

	var/state = 0 //closed, 1 == open
	var/isSwitchingStates = 0

/obj/structure/inflatable/door/attack_ai(mob/user as mob) //those aren't machinery, they're just big fucking slabs of a mineral
	if(isAI(user)) //so the AI can't open it
		return

/obj/structure/inflatable/door/attack_robot(mob/living/user)
	if(get_dist(user,src) <= 1) //not remotely though
		return TryToSwitchState(user)

/obj/structure/inflatable/door/attack_hand(mob/user as mob)
	. = ..()
	if(.)
		return
	return TryToSwitchState(user)

/obj/structure/inflatable/door/proc/TryToSwitchState(atom/user)
	if(isSwitchingStates) return
	if(ismob(user))
		var/mob/M = user
		if(M.client)
			if(iscarbon(M))
				var/mob/living/carbon/C = M
				if(!C.handcuffed)
					SwitchState()
			else
				SwitchState()

/obj/structure/inflatable/door/proc/SwitchState()
	if(state)
		Close()
	else
		Open()

/obj/structure/inflatable/door/proc/Open()
	isSwitchingStates = 1
	z_flick("door_opening",src)
	addtimer(CALLBACK(src, PROC_REF(FinishOpen)), 1 SECONDS, TIMER_STOPPABLE)

/obj/structure/inflatable/door/proc/FinishOpen()
	set_density(0)
	set_opacity(0)
	state = 1
	update_icon()
	isSwitchingStates = 0
	zas_update_loc()

/obj/structure/inflatable/door/proc/Close()
	// If the inflatable is blocked, don't close
	for(var/turf/T in locs)
		for(var/atom/movable/AM as anything in T)
			if(AM.density)
				return

	isSwitchingStates = 1
	z_flick("door_closing",src)
	addtimer(CALLBACK(src, PROC_REF(FinishClose)), 1 SECONDS, TIMER_STOPPABLE)

/obj/structure/inflatable/door/proc/FinishClose()
	set_density(1)
	set_opacity(0)
	state = 0
	update_icon()
	isSwitchingStates = 0
	zas_update_loc()

/obj/structure/inflatable/door/update_icon()
	. = ..()
	if(state)
		icon_state = "door_open"
	else
		icon_state = "door_closed"


/obj/structure/inflatable/door/deflate(violent=0)
	playsound(loc, 'sound/machines/hiss.ogg', 75, 1)
	if(violent)
		visible_message("[src] rapidly deflates!")
		var/obj/item/inflatable/door/torn/R = new /obj/item/inflatable/door/torn(loc)
		src.transfer_fingerprints_to(R)
		qdel(src)
	else
		visible_message("[src] slowly deflates.")
		spawn(50)
			var/obj/item/inflatable/door/R = new /obj/item/inflatable/door(loc)
			src.transfer_fingerprints_to(R)
			qdel(src)

//inflatable shelters from vg
/obj/structure/inflatable/shelter
	name = "inflatable shelter"
	density = TRUE
	anchored = FALSE
	opacity = 0
	can_buckle = TRUE
	icon_state = "shelter_base"
	undeploy_path = /obj/item/inflatable/shelter
	var/list/exiting = list()
	var/datum/gas_mixture/cabin_air

/obj/structure/inflatable/shelter/Initialize()
	. = ..()
	cabin_air = new
	cabin_air.volume = CELL_VOLUME / 3
	cabin_air.temperature = T20C + 20
	cabin_air.adjustMultipleGases(
		GAS_OXYGEN, MOLES_O2STANDARD,
		GAS_NITROGEN, MOLES_N2STANDARD)

/obj/structure/inflatable/shelter/examine(mob/user)
	. = ..()
	. += span_notice("Click to enter. Use grab on shelter to force target inside. Use resist to exit. Right click to deflate.")
	var/list/living_contents = list()
	for(var/mob/living/L in contents)
		living_contents += L.name
	if(length(living_contents))
		. += span_notice("You can see [english_list(living_contents)] inside.")

/obj/structure/inflatable/shelter/attack_hand(mob/user)
	if(!isturf(user.loc))
		to_chat(user, span_warning("You can't climb into \the [src] from here!"))
		return FALSE
	user.visible_message(span_notice("[user] begins to climb into \the [src]."), span_notice("You begin to climb into \the [src]."))
	if(do_after(user, src, 3 SECONDS))
		enter_shelter(user)

/obj/structure/inflatable/shelter/user_buckle_mob(mob/living/M, mob/user, check_loc = TRUE)
	if(!in_range(user, src) || !in_range(M, src))
		return FALSE
	if(!isturf(user.loc) || !isturf(M.loc))
		return FALSE
	if(do_after(user, src, 3 SECONDS, DO_PUBLIC, display = src))
		if(!in_range(M, src) || !isturf(M.loc))
			return FALSE //in case the target has moved
		enter_shelter(M)
		return

/obj/structure/inflatable/shelter/Destroy()
	for(var/atom/movable/AM as anything in src)
		AM.forceMove(loc)
	qdel(cabin_air)
	cabin_air = null
	exiting = null
	return ..()

/obj/structure/inflatable/shelter/remove_air(amount)
	return cabin_air.remove(amount)

/obj/structure/inflatable/shelter/return_air()
	return cabin_air

/obj/structure/inflatable/shelter/proc/enter_shelter(mob/user)
	user.forceMove(src)
	update_icon()
	user.visible_message(span_notice("[user] enters \the [src]."), span_notice("You enter \the [src]."))
	RegisterSignal(user, COMSIG_PARENT_QDELETING, PROC_REF(remove_vis))

/obj/structure/inflatable/shelter/proc/remove_vis(mob/user, force)
	remove_viscontents(user)

/obj/structure/inflatable/shelter/container_resist_act(mob/living/user)
	if (user.loc != src)
		exiting -= user
		to_chat(user, span_warning("You cannot climb out of something you aren't even in!"))
		return
	if(user in exiting)
		exiting -= user
		to_chat(user, span_warning("You stop climbing free of \the [src]."))
		return
	user.visible_message(span_notice("[user] starts climbing out of \the [src]."), span_notice("You start climbing out of \the [src]."))
	exiting += user

	if(do_after(user, src, 5 SECONDS))
		if (user in exiting)
			user.forceMove(get_turf(src))
			update_icon()
			exiting -= user
			UnregisterSignal(user, COMSIG_PARENT_QDELETING)
			user.visible_message(span_notice("[user] climbs out of \the [src]."), span_notice("You climb out of \the [src]."))


/obj/structure/inflatable/shelter/update_overlays()
	. = ..()
	cut_viscontents()
	for(var/mob/living/L in contents)
		add_viscontents(L)
	if(length(contents))
		. += mutable_appearance(icon, "shelter_top", ABOVE_MOB_LAYER)

/obj/item/inflatable/torn
	name = "torn inflatable wall"
	desc = "A folded membrane which rapidly expands into a large cubical shape on activation. It is too torn to be usable."
	icon = 'modular_pariah/master_files/icons/obj/inflatable.dmi'
	icon_state = "folded_wall_torn"

/obj/item/inflatable/torn/attack_self(mob/user)
	to_chat(user, span_notice("The inflatable wall is too torn to be inflated!"))
	add_fingerprint(user)

/obj/item/inflatable/door/torn
	name = "torn inflatable door"
	desc = "A folded membrane which rapidly expands into a simple door on activation. It is too torn to be usable."
	icon = 'modular_pariah/master_files/icons/obj/inflatable.dmi'
	icon_state = "folded_door_torn"

/obj/item/inflatable/door/torn/attack_self(mob/user)
	to_chat(user, span_notice("The inflatable door is too torn to be inflated!"))
	add_fingerprint(user)

/obj/item/storage/briefcase/inflatable
	name = "inflatable barrier case"
	desc = "A carrying case for inflatable walls and doors."
	icon_state = "inflatable"
	w_class = WEIGHT_CLASS_NORMAL
	max_integrity = 150
	force = 8
	hitsound = SFX_SWING_HIT
	throw_range = 4
	var/startswith = list(/obj/item/inflatable/door = 2, /obj/item/inflatable/wall = 4)

/obj/item/storage/briefcase/inflatable/Initialize()
	. = ..()
	atom_storage.set_holdable(list(/obj/item/inflatable))

/obj/item/storage/briefcase/inflatable/PopulateContents()
	for(var/path in startswith)
		for(var/i in 1 to startswith[path])
			new path(src)
