/*
Contains helper procs for airflow, handled in /connection_group.
This entire system is an absolute mess.
*/
#define AIRBORNE_DAMAGE(airborne_thing) (min(airborne_thing.airflow_speed, (airborne_thing.airborne_acceleration*2)) * zas_settings.airflow_damage)

/mob
	var/tmp/last_airflow_stun = 0

/atom/movable
	///The location the atom is trying to step towards during airflow.
	var/tmp/turf/airflow_dest
	///The speed the object is travelling during airflow
	var/tmp/airflow_speed = 0
	///Time (ticks) spent in airflow
	var/tmp/airflow_time = 0
	///Time (ticks) since last airflow movement
	var/tmp/last_airflow = 0
	var/tmp/airborne_acceleration = 0

///Applies the effects of the mob colliding with another movable due to airflow.
/mob/proc/airflow_stun()
	return

/mob/living/airflow_stun()
	if(stat == 2)
		return FALSE
	if(last_airflow_stun > world.time - zas_settings.airflow_stun_cooldown)
		to_chat(src, "<span class='notice'>Air suddenly rushes past you!</span>")
		return FALSE
	if(!(status_flags & CANSTUN) && !(status_flags & CANKNOCKDOWN))
		to_chat(src, "<span class='notice'>Air suddenly rushes past you, but you manage to keep your footing!</span>")
		return FALSE
	if(buckled)
		to_chat(src, "<span class='notice'>Air suddenly rushes past you!</span>")
		return FALSE
	if(!body_position == LYING_DOWN)
		to_chat(src, "<span class='warning'>The sudden rush of air knocks you over!</span>")

	Knockdown(zas_settings.airflow_stun SECONDS)
	last_airflow_stun = world.time

/mob/living/silicon/airflow_stun()
	return

/mob/living/simple_animal/slime/airflow_stun()
	return

///NEEDS IMPLIMENATION, SEE: LINDA_turf_tile.dm
/atom/movable/proc/experience_pressure_difference()
	return

///Checks to see if airflow can move this movable.
/atom/movable/proc/check_airflow_movable(n)
	if(anchored && !ismob(src))
		return FALSE

	if(!isobj(src) && n < zas_settings.airflow_dense_pressure)
		return FALSE

	return TRUE

/mob/check_airflow_movable(n)
	if(n < zas_settings.airflow_heavy_pressure)
		return FALSE
	if(HAS_TRAIT(src, TRAIT_NEGATES_GRAVITY)) //Magboots
		return FALSE
	return TRUE

/mob/living/silicon/check_airflow_movable()
	return 0

/obj/check_airflow_movable(n)
	if(n < zas_settings.airflow_dense_pressure)
		return FALSE

	return ..()

/obj/item/check_airflow_movable(n)
	switch(w_class)
		if(1,2)
			if(n < zas_settings.airflow_lightest_pressure) return 0
		if(3)
			if(n < zas_settings.airflow_light_pressure) return 0
		if(4,5)
			if(n < zas_settings.airflow_medium_pressure) return 0
		if(6)
			if(n < zas_settings.airflow_heavy_pressure) return 0
		if(7 to INFINITY)
			if(n < zas_settings.airflow_dense_pressure) return 0
	return ..()

///Seemingly redundant, look to remove.
/atom/movable/proc/AirflowCanMove(n)
	return 1

/mob/AirflowCanMove(n)
	if(status_flags & GODMODE)
		return 0
	if(buckled)
		return 0
	var/obj/item/clothing/shoes = get_item_by_slot(ITEM_SLOT_FEET)
	if(istype(shoes) && (shoes.clothing_flags & NOSLIP))
		return 0
	return 1

/atom/movable/Bump(atom/A)
	if(airflow_speed > 0 && airflow_dest)
		var/turf/T = get_turf(A)
		if(airborne_acceleration > 1)
			airflow_hit(A)
			A.airflow_hit_act(src)
		else if(istype(src, /mob/living/carbon/human))
			to_chat(src, "<span class='notice'>You are pinned against [A] by airflow!</span>")
		if(!T.density)
			if(ismovable(A) && A:airflow_originally_not_dense)
				set_density(FALSE)
				A.set_density(FALSE)
				step_towards(src, airflow_dest)
				set_density(TRUE)
				A.set_density(TRUE)
	else
		airflow_speed = 0
		airflow_time = 0
		airborne_acceleration = 0
		. = ..()

///Called when src collides with A during airflow
/atom/movable/proc/airflow_hit(atom/A)
	airflow_speed = 0
	airflow_dest = null
	airborne_acceleration = 0

/mob/living/airflow_hit(atom/A)
	var/b_loss = AIRBORNE_DAMAGE(src)
	apply_damage(b_loss, BRUTE)
	if(istype(A, /obj/structure) || iswallturf(A))
		if(airflow_speed > 10)
			Paralyze(round(airflow_speed * zas_settings.airflow_stun))
			Stun(round(airflow_speed * zas_settings.airflow_stun) + 3)
		else
			Stun(round(airflow_speed * zas_settings.airflow_stun/2))

	return ..()

/mob/living/carbon/airflow_hit(atom/A)
	if (prob(33))
		loc.add_blood_DNA(return_blood_DNA())
	return ..()

///Called when "flying" calls airflow_hit() on src
/atom/proc/airflow_hit_act(atom/movable/flying)
	src.visible_message(
		span_danger("A flying [flying.name] slams into \the [src]!"),
		span_danger("You're hit by a flying [flying]!"),
		span_danger("You hear a loud slam!")
	)

/mob/living/airflow_hit_act(atom/movable/flying)
	. = ..()
	playsound(src.loc, "punch", 25, 1, -1)
	var/weak_amt
	if(istype(flying,/obj/item))
		weak_amt = flying:w_class*2 ///Heheheh
	else if(!flying.airflow_originally_not_dense) //If the object is dense by default (this var is stupidly named)
		weak_amt = 5 //Getting crushed by a flying canister or computer is going to fuck you up
	else
		weak_amt = rand(1, 3)

	src.Knockdown(weak_amt SECONDS)

/obj/airflow_hit_act(atom/movable/flying)
	. = ..()
	playsound(src.loc, "smash.ogg", 25, 1, -1)

	if(!uses_integrity)
		return

	take_damage(zas_settings.airflow_damage, BRUTE)

/mob/living/carbon/human/airflow_hit_act(atom/movable/flying)
	. = ..()
	if (prob(33))
		loc.add_blood_DNA(return_blood_DNA())

	var/b_loss = AIRBORNE_DAMAGE(flying)

	apply_damage(b_loss/3, BRUTE, BODY_ZONE_HEAD)

	apply_damage(b_loss/3, BRUTE, BODY_ZONE_CHEST)


	if(airflow_speed > 10)
		Paralyze(round(flying.airflow_speed * zas_settings.airflow_stun))
		Stun(round(flying.airflow_speed * zas_settings.airflow_stun) + 3)
	else
		Stun(round(flying.airflow_speed * zas_settings.airflow_stun/2))

/zone/proc/movables()
	RETURN_TYPE(/list)
	. = list()
	for(var/turf/T in contents)
		for(var/atom/movable/A as anything in T)
			if(!A.simulated || A.anchored)
				continue
			. += A

#undef AIRBORNE_DAMAGE
