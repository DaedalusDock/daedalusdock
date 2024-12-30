/// Inert structures, such as girders, machine frames, and crates/lockers.
/obj/structure
	icon = 'icons/obj/structures.dmi'
	//pressure_resistance = 8
	max_integrity = 300
	interaction_flags_atom = INTERACT_ATOM_ATTACK_HAND | INTERACT_ATOM_UI_INTERACT
	layer = BELOW_OBJ_LAYER
	flags_ricochet = RICOCHET_HARD
	receive_ricochet_chance_mod = 0.6
	pass_flags_self = PASSSTRUCTURE
	blocks_emissive = EMISSIVE_BLOCK_GENERIC
	var/broken = FALSE

/obj/structure/Initialize(mapload)
	. = ..()

	#ifdef UNIT_TESTS
	ASSERT_SORTED_SMOOTHING_GROUPS(smoothing_groups)
	ASSERT_SORTED_SMOOTHING_GROUPS(canSmoothWith)
	#endif

	SETUP_SMOOTHING()
	if(!isnull(smoothing_flags))
		QUEUE_SMOOTH(src)
		QUEUE_SMOOTH_NEIGHBORS(src)
		if(smoothing_flags & SMOOTH_CORNERS)
			icon_state = ""

	GLOB.cameranet.updateVisibility(src)

/obj/structure/Destroy()
	GLOB.cameranet.updateVisibility(src)
	QUEUE_SMOOTH_NEIGHBORS(src)
	return ..()

/obj/structure/ui_act(action, params)
	add_fingerprint(usr)
	return ..()

/obj/structure/examine(mob/user)
	. = ..()
	if(!(resistance_flags & INDESTRUCTIBLE))
		if(resistance_flags & ON_FIRE)
			. += span_alert("FIRE!!")
		if(broken)
			. += span_alert("It appears to be broken.")

		var/examine_status = examine_status(user)
		if(examine_status)
			. += examine_status

/obj/structure/proc/examine_status(mob/user) //An overridable proc, mostly for falsewalls.
	var/healthpercent = (atom_integrity/max_integrity) * 100
	switch(healthpercent)
		if(50 to 99)
			return  "It looks slightly damaged."
		if(25 to 50)
			return  "It appears heavily damaged."
		if(0 to 25)
			if(!broken)
				return  span_warning("It's falling apart!")

/obj/structure/rust_heretic_act()
	take_damage(500, BRUTE, SLASH, 1)

/obj/structure/zap_act(power, zap_flags)
	if(zap_flags & ZAP_OBJ_DAMAGE)
		take_damage(power/8000, BURN, "energy")
	power -= power/2000 //walls take a lot out of ya
	. = ..()

/obj/structure/onZImpact(turf/impacted_turf, levels, message)
	. = ..()
	var/atom/highest
	for(var/atom/movable/hurt_atom as anything in impacted_turf)
		if(hurt_atom == src)
			continue
		if(!hurt_atom.density)
			continue
		if(isobj(hurt_atom) || ismob(hurt_atom))
			if(hurt_atom.layer > highest?.layer)
				highest = hurt_atom

	if(!highest)
		return

	if(isobj(highest))
		var/obj/O = highest
		if(!O.uses_integrity)
			return
		O.take_damage(10 * levels)

	if(ismob(highest))
		var/mob/living/L = highest
		var/armor = L.run_armor_check(BODY_ZONE_HEAD, BLUNT)
		L.apply_damage(80 * levels, blocked = armor, spread_damage = TRUE)
		L.Paralyze(10 SECONDS)

	visible_message(span_warning("[src] slams into [highest] from above!"))

/obj/structure/attack_grab(mob/living/user, atom/movable/victim, obj/item/hand_item/grab/grab, list/params)
	. = ..()
	if(!user.combat_mode)
		return
	if(!grab.target_zone == BODY_ZONE_HEAD)
		return
	if (!grab.current_grab.enable_violent_interactions)
		to_chat(user, span_warning("You need a better grip to do that!"))
		return TRUE

	var/mob/living/affecting_mob = grab.get_affecting_mob()
	if(!istype(affecting_mob))
		to_chat(user, span_warning("You need to be grabbing a living creature to do that!"))
		return TRUE

	// Slam their face against the table.
	var/blocked = affecting_mob.run_armor_check(BODY_ZONE_HEAD, BLUNT)
	if (prob(30 * ((100-blocked)/100)))
		affecting_mob.Knockdown(10 SECONDS)

	affecting_mob.apply_damage(30, BRUTE, BODY_ZONE_HEAD, blocked)
	visible_message(span_danger("<b>[user]</b> slams <b>[affecting_mob]</b>'s face against \the [src]!"))
	playsound(loc, 'sound/items/trayhit1.ogg', 50, 1)

	take_damage(rand(1,5), BRUTE)
	for(var/obj/item/shard/S in loc)
		if(prob(50))
			affecting_mob.visible_message(span_danger("\The [S] slices into [affecting_mob]'s face!"), span_danger("\The [S] slices into your face!"))
			S.melee_attack_chain(user, victim, params)
	qdel(grab)
	return TRUE
