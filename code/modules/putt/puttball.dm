/obj/puttball
	name = "putt ball"
	desc = "A specialized ball, meant to be hit with proper putting equipment."
	icon = 'icons/obj/ballgame.dmi'
	icon_state = "ball"

	animate_movement = NO_STEPS //No need for this. We're moving that ball for real.

	var/putting = FALSE //is someone lining up a shot?
	var/moving = FALSE //is the ball in motion
	var/obj/effect/puttpointer/pointer //the arrow that helps you line up the shot
	var/putt_vel = 0 //strength of the lined up shot
	var/putt_angle = 0 //angle of the lined up shot

	//location on a 32x32 grid.
	var/ball_x = 16
	var/ball_y = 16

	//x and y velocity
	var/vel_x = 0
	var/vel_y = 0

	var/ball_angle = 0 //should be between 0 and 360. 0 is considered East, and it increments counter-clockwise.
	var/ball_velocity = 0 //the velocity of the ball, before converting to x and y velocity.

	var/friction = 0.1 //how much velocity is lost every update


/obj/puttball/proc/start_movement()
	START_PROCESSING(SSprojectiles, src) //this will be moved to a seperate subsystem when I make that.
	moving = TRUE

/obj/puttball/proc/end_movement()
	STOP_PROCESSING(SSprojectiles, src)
	moving = FALSE

//Lining up your shot
/obj/puttball/proc/update_shot()
	if(!putting)
		return
	if(!pointer)
		pointer = new /obj/effect/puttpointer(get_turf(src))

	var/matrix/M = matrix()
	M.Scale(((putt_vel / 5)), 1)
	M.Turn(fix_angle((putt_angle * -1)))
	M.Translate(pixel_x, pixel_y)
	pointer.transform = M

/obj/puttball/proc/swing()
	putting = FALSE
	qdel(pointer)
	pointer = null
	ball_angle = fix_angle(putt_angle)
	ball_velocity = putt_vel
	start_movement()

/obj/puttball/proc/fix_angle(angle)//fixes an angle below 0 or above 360
	if(!(angle > 360) && !(angle < 0))
		return angle //early return if it doesn't need to change
	var/new_angle
	if(angle > 360)
		new_angle = angle - 360
	if(angle < 0)
		new_angle = angle + 360
	return new_angle

/// BALL MOVEMENT ///
/obj/puttball/proc/bounce(bounce_angle)
	ball_angle = ((180 - bounce_angle) - ball_angle)
	if(ball_angle < 0)
		ball_angle += 360

	//velocity loss for collision. might need to adjust this number. (maybe scaled based on current velocity??)
	ball_velocity -= 1

	playsound(src, 'sound/items/puttputt/ball_bounce.ogg', 50, TRUE)

/obj/puttball/process(delta_time)
	ball_angle = fix_angle(ball_angle)
	if(ball_velocity <= 0)
		ball_velocity = 0
		end_movement()

	vel_x = (ball_velocity * (cos(ball_angle)))
	vel_y = (ball_velocity * (sin(ball_angle)))

	ball_velocity -= friction

	ball_x += vel_x
	ball_y += vel_y

	if(ball_x > 32)
		if(Move(get_step(src, EAST)))
			ball_x = 0
		else
			ball_x = 32
			bounce(0)
	if(ball_x < 0)
		if(Move(get_step(src, WEST)))
			ball_x = 32
		else
			ball_x = 0
			bounce(0)

	if(ball_y > 32)
		if(Move(get_step(src, NORTH)))
			ball_y = 0
		else
			ball_y = 32
			bounce(180)
	if(ball_y < 0)
		if(Move(get_step(src, SOUTH)))
			ball_y = 32
		else
			ball_y = 0
			bounce(180)

	//change the pixel offset of the ball so that we can see it "move"
	pixel_x = (ball_x - 16)
	pixel_y = (ball_y - 16)

/obj/effect/puttpointer
	icon = 'icons/obj/ballgame.dmi'
	icon_state = "arrow"
