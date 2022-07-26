
/obj/effect/heat
	icon = 'icons/effects/fire.dmi'
	icon_state = "3"
	render_target = HEAT_RENDER_TARGET

/particles/heat
	width = 500
	height = 500
	count = 600
	spawning = 35
	lifespan = 1.85 SECONDS
	fade = 1.25 SECONDS
	position = generator("box", list(-16, -16), list(16, 0), NORMAL_RAND)
	friction = 0.15
	gradient = list(0, COLOR_WHITE, 0.75, COLOR_ORANGE)
	color_change = 0.1
	color = 0
	gravity = list(0, 1)
	drift = generator("circle", 0.4, NORMAL_RAND)
	velocity = generator("circle", 0, 3, NORMAL_RAND)

///This is a special stripped down alternative to a particle_holder. Generally, I don't recommend using it.
/obj/particle_emitter
	name = ""
	anchored = TRUE
	mouse_opacity = 0
	appearance_flags = PIXEL_SCALE

/obj/particle_emitter/Initialize(mapload, time, _color)
	. = ..()
	if(time > 0)
		QDEL_IN(src, time)
	color = _color

/obj/particle_emitter/proc/enable(on)
	if(on)
		particles.spawning = initial(particles.spawning)
	else
		particles.spawning = 0

/obj/particle_emitter/heat
	particles = new/particles/heat
	render_target = HEAT_RENDER_TARGET

/obj/particle_emitter/heat/Initialize(mapload, time, _color)
	. = ..()
	filters += filter(type = "blur", size = 1)

/obj/effect/gas_overlay/heat
	name = "gas"
	desc = "You shouldn't be clicking this."
	plane = HEAT_PLANE
	gas_id = "heat"
	render_source = HEAT_RENDER_TARGET

/obj/effect/gas_overlay/heat/Initialize(mapload, gas)
	. = ..()
	icon = null
	icon_state = null
