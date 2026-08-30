/// Projections into the spirit theatre from sleeping players.
/obj/effect/simulacrum
	density = TRUE

	var/datum/mind/owning_mind
	var/obj/effect/landmark/ghost_theatre_sleeper/used_landmark

/obj/effect/simulacrum/Initialize(mapload, mob/body, _mind, _landmark)
	. = ..()

	owning_mind = _mind
	used_landmark = _landmark

	used_landmark.using_this = src

	appearance = body.appearance
	appearance_flags |= NO_CLIENT_COLOR
	setDir(NORTH)
	transform = matrix()
	color = list(
		0.45, 0.75, 1.00, 0,
		0.45, 0.75, 1.00, 0,
		0.45, 0.75, 1.00, 0,
		0,    0,    0,    1
	)

	name = "simulacrum of [owning_mind.name]"

	alpha = 0
	animate(src, alpha = 255, easing = SINE_EASING|EASE_IN, time = 5 SECONDS)

/obj/effect/simulacrum/Destroy(force)
	owning_mind = null
	used_landmark.using_this = null
	used_landmark = null
	return ..()
