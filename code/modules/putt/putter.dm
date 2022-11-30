/obj/item/putter
	name = "putter"
	desc = "Get swinging!"
	icon = 'icons/obj/ballgame.dmi'
	icon_state = "putter"
	inhand_icon_state = "screwdriver" //placeholder
	lefthand_file = 'icons/mob/inhands/equipment/tools_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/tools_righthand.dmi'
	force = 5

	var/obj/puttball/aim_target //the ball we're hitting.
	var/mob/current_user //who's lining up the shot?

	var/aiming = FALSE //are we lining up a shot right now?

	//starting velocity and angle of the shot
	var/start_vel = 5
	var/start_angle = 0

	//min and max velocity for the shot
	var/min_vel = 1
	var/max_vel = 10

	//min and max angle (0 faces east, higher numbers move counter-clockwise, negative numbers are fine)
	var/min_angle = -90
	var/max_angle = 90

/obj/item/putter/pre_attack(atom/A, mob/user)
	if(!istype(A, /obj/puttball))
		return ..() //not a ball
	//start aiming
	if(!aiming)
		current_user = user
		aim_target = A
		if(aim_target.moving)
			return //can't aim at a moving ball
		start_putting(user, get_dir(get_turf(user), get_turf(aim_target)))
		return TRUE
	//otherwise hit the ball and stop aiming
	if(!current_user || !aim_target)
		return ..()//something must have been deleted

	if(aim_target.moving)
		return //can't hit a moving ball either

	user.visible_message(span_warning("[user] swings [src] at [aim_target]!"), span_warning("You swing [src] at [aim_target]!"))
	playsound(src, 'sound/items/puttputt/ball_hit.ogg', 50, FALSE)
	aim_target.swing()
	stop_putting()
	return TRUE

/obj/item/putter/proc/start_putting(mob/user, direction)
	aiming = TRUE
	aim_target.putting = TRUE
	RegisterSignal(user, COMSIG_MOB_CLIENT_PRE_MOVE, .proc/move_aim)

	switch(direction) //this is dumb, but byond directions are weird.
		if(NORTH)
			min_angle = 0
			max_angle = 180
			start_angle = 90
		if(SOUTH)
			min_angle = -180
			max_angle = 0
			start_angle = -90
		if(WEST)
			min_angle = 90
			max_angle = 270
			start_angle = 180
		if(EAST)
			min_angle = -90
			max_angle = 90
			start_angle = 0
		if(NORTHWEST)
			min_angle = 45
			max_angle = 225
			start_angle = 135
		if(NORTHEAST)
			min_angle = -45
			max_angle = 135
			start_angle = 45
		if(SOUTHWEST)
			min_angle = 135
			max_angle = 315
			start_angle = 225
		if(SOUTHEAST)
			min_angle = -135
			max_angle = 45
			start_angle = -45

	aim_target.putt_angle = start_angle
	aim_target.putt_vel = start_vel
	aim_target.update_shot()

/obj/item/putter/proc/stop_putting()
	aiming = FALSE
	UnregisterSignal(current_user, COMSIG_MOB_CLIENT_PRE_MOVE)
	current_user = null
	aim_target = null

/obj/item/putter/proc/move_aim(datum/source, list/move_args)
	var/direction = move_args[MOVE_ARG_DIRECTION]
	switch(direction)
		if(NORTH)
			if(aim_target.putt_vel < max_vel)
				aim_target.putt_vel += 1
		if(SOUTH)
			if(aim_target.putt_vel > min_vel)
				aim_target.putt_vel -= 1
		if(WEST)
			if(aim_target.putt_angle < max_angle)
				aim_target.putt_angle += 2
		if(EAST)
			if(aim_target.putt_angle > min_angle)
				aim_target.putt_angle -= 2
		if(NORTHWEST)
			if(aim_target.putt_vel < max_vel)
				aim_target.putt_vel += 1
			if(aim_target.putt_angle < max_angle)
				aim_target.putt_angle += 2
		if(NORTHEAST)
			if(aim_target.putt_vel < max_vel)
				aim_target.putt_vel += 1
			if(aim_target.putt_angle > min_angle)
				aim_target.putt_angle -= 2
		if(SOUTHWEST)
			if(aim_target.putt_vel > min_vel)
				aim_target.putt_vel -= 1
			if(aim_target.putt_angle < max_angle)
				aim_target.putt_angle += 2
		if(SOUTHEAST)
			if(aim_target.putt_vel > min_vel)
				aim_target.putt_vel -= 1
			if(aim_target.putt_angle > min_angle)
				aim_target.putt_angle -= 2

	aim_target.update_shot()
	return COMSIG_MOB_CLIENT_BLOCK_PRE_MOVE //stop the mob from actually moving
