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

	var/tmp/airflow_xo
	var/tmp/airflow_yo
	///If the movable is dense by default, it won't step into tiles containing other dense objects
	var/tmp/airflow_originally_not_dense
	var/tmp/airflow_process_delay
	var/tmp/airflow_skip_speedcheck

///Applies the effects of the mob colliding with another movable due to airflow.
/mob/proc/airflow_stun(delta_p)
	return

/mob/living/airflow_stun(delta_p)
	if(stat == 2)
		return FALSE
	if(pulledby || pulling)
		return FALSE
	if(last_airflow_stun > world.time - zas_settings.airflow_stun_cooldown)
		return FALSE
	if(!(status_flags & CANSTUN) && !(status_flags & CANKNOCKDOWN))
		return FALSE
	if(buckled)
		return FALSE
	if(body_position == LYING_DOWN) //Lying down protects you from Z A S M O M E N T S
		return FALSE
	if(HAS_TRAIT(src, TRAIT_NEGATES_GRAVITY)) //Magboots
		return FALSE
	if(IsKnockdown()) //Uhhh maybe?
		return FALSE

	Knockdown(zas_settings.airflow_stun * clamp((delta_p / zas_settings.airflow_stun_pressure), 1, 3))
	visible_message(
		span_danger("[src] is thrown to the floor by a gust of air!"),
		span_danger("A sudden rush of air knocks you over!"),
		span_hear("You hear a gust of air, followed by a soft thud.")
	)

	last_airflow_stun = world.time

/mob/living/silicon/airflow_stun(delta_p)
	return

/mob/living/simple_animal/slime/airflow_stun(delta_p)
	return

///Checks to see if airflow can move this movable.
/atom/movable/proc/check_airflow_movable(n)
	//We're just hoping nothing goes wrong
	return TRUE

/mob/check_airflow_movable(n)
	if(status_flags & GODMODE)
		return FALSE
	if(n < zas_settings.airflow_heavy_pressure)
		return FALSE
	if(HAS_TRAIT(src, TRAIT_NEGATES_GRAVITY)) //Magboots
		return FALSE
	return ..()

/mob/living/silicon/check_airflow_movable()
	return 0

/obj/check_airflow_movable(n)
	if(anchored)
		return FALSE
	if(n < zas_settings.airflow_dense_pressure)
		if(airflow_dest)
			if(!airflow_originally_not_dense)
				return FALSE
		else if(density)
			return FALSE
	return ..()

/obj/item/check_airflow_movable(n)
	switch(w_class)
		if(0,1,2)
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

/atom/movable/Bump(atom/A)
	if(airflow_speed > 0 && airflow_dest)
		var/turf/T = get_turf(A)
		if(airborne_acceleration > 1)
			airflow_hit(A)
			A.airflow_hit_act(src)
		else if(istype(src, /mob/living/carbon/human) && ismovable(A) && !(A:airflow_originally_not_dense))
			to_chat(src, "<span class='notice'>You are pinned against [A] by airflow!</span>")
			src:Stun(1 SECONDS) // :)
		/*
		If the turf of the atom we bumped is NOT dense, then we check if the flying object is dense.
		We check the special var because flying objects gain density so they can Bump() objects.
		If the object is NOT normally dense, we remove our density and the target's density,
		enabling us to step into their turf. Then, we set the density back to the way its supposed to be for airflow.
		*/
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
	SHOULD_CALL_PARENT(TRUE)
	airflow_speed = 0
	airflow_dest = null
	airborne_acceleration = 0
	A.airflow_hit_act(src)

/mob/living/airflow_hit(atom/A)
	var/b_loss = AIRBORNE_DAMAGE(src)
	apply_damage(b_loss, BRUTE)
	return ..()

/mob/living/carbon/airflow_hit(atom/A)
	if(istype(A, /obj/structure) || iswallturf(A))
		if(airflow_speed > 10)
			Paralyze(round(airflow_speed * zas_settings.airflow_stun))
			Stun(round(airflow_speed * zas_settings.airflow_stun) + 3)
			loc.add_blood_DNA(return_blood_DNA())
			visible_message(
				span_danger("[src] splats against \the [A]!"),
				span_userdanger("You slam into \the [A] with tremendous force!"),
				span_hear("You hear a loud thud.")
			)
			INVOKE_ASYNC(emote("scream"))
		else
			Stun(round(airflow_speed * zas_settings.airflow_stun/2))
			visible_message(
				span_danger("[src] slams into \the [A]!"),
				span_userdanger("You're thrown against \the [A] by pressure!"),
				span_hear("You hear a loud thud.")
			)

	return ..()

///Called when "flying" calls airflow_hit() on src
/atom/proc/airflow_hit_act(atom/movable/flying)
	return

/mob/living/airflow_hit_act(atom/movable/flying)
	. = ..()
	src.visible_message(
		span_danger("A flying [flying.name] slams into \the [src]!"),
		span_danger("You're hit by a flying [flying]!"),
		span_danger("You hear a soft thud.")
	)

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
	if(!flying.airflow_originally_not_dense)
		src.visible_message(
			span_danger("A flying [flying.name] slams into \the [src]!"),
			null,
			span_danger("You hear a loud slam!")
		)

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
