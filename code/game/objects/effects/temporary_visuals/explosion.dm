/obj/effect/temp_visual/shockwave
	icon = 'icons/effects/shockwave.dmi'
	icon_state = "shockwave"
	plane = GRAVITY_PULSE_PLANE
	appearance_flags = LONG_GLIDE|PIXEL_SCALE
	pixel_x = -496
	pixel_y = -496

	randomdir = FALSE

/obj/effect/temp_visual/shockwave/Initialize(mapload, radius)
	duration = 0.5 * radius
	. = ..()
	transform = matrix().Scale(32 / 1024, 32 / 1024)
	animate(
		src,
		time = duration,
		transform=matrix().Scale((32 / 1024) * radius * 1.5, (32 / 1024) * radius * 1.5),
		easing = QUAD_EASING|EASE_OUT
	)
