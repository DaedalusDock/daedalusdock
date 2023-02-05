/obj/effect/temp_visual/shockwave
	icon = 'icons/effects/shockwave.dmi'
	icon_state = "shockwave"
	plane = GRAVITY_PULSE_PLANE
	pixel_x = -496
	pixel_y = -496

/obj/effect/temp_visual/shockwave/Initialize(mapload, radius)
	. = ..()
	deltimer(timerid)
	timerid = QDEL_IN(src, 0.5 * radius)
	transform = matrix().Scale(32 / 1024, 32 / 1024)
	animate(src, time = 1/2 * radius, transform=matrix().Scale((32 / 1024) * radius * 1.5, (32 / 1024) * radius * 1.5))
