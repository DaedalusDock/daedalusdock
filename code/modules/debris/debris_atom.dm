/atom
	///Icon state of debris when impacted by a projectile
	var/tmp/debris_icon_state = null
	///Velocity of debris particles
	var/tmp/debris_velocity = -15
	///Amount of debris particles
	var/tmp/debris_amount = 8
	///Scale of particle debris
	var/tmp/debris_scale = 0.7

/atom/proc/spawn_debris(obj/projectile/P)
	set waitfor = FALSE

	var/angle = !isnull(P.Angle) ? P.Angle : round(get_angle(P.starting, src), 1)
	var/x_component = sin(angle) * debris_velocity
	var/y_component = cos(angle) * debris_velocity
	var/x_component_smoke = sin(angle) * -15
	var/y_component_smoke = cos(angle) * -15
	var/obj/effect/abstract/particle_holder/debris_visuals
	var/obj/effect/abstract/particle_holder/smoke_visuals
	var/position_offset = rand(-6,6)

	smoke_visuals = new(src, /particles/impact_smoke)
	smoke_visuals.particles.position = list(position_offset, position_offset)
	smoke_visuals.particles.velocity = list(x_component_smoke, y_component_smoke)

	if(debris_icon_state && !istype(P, /obj/projectile/energy))
		debris_visuals = new(src, /particles/debris)
		debris_visuals.particles.position = generator(GEN_CIRCLE, position_offset, position_offset)
		debris_visuals.particles.velocity = list(x_component, y_component)
		debris_visuals.layer = ABOVE_OBJ_LAYER + 0.02
		debris_visuals.particles.icon_state = debris_icon_state
		debris_visuals.particles.count = debris_amount
		debris_visuals.particles.spawning = debris_amount
		debris_visuals.particles.scale = debris_scale

	smoke_visuals.layer = ABOVE_OBJ_LAYER + 0.01
	addtimer(CALLBACK(src, PROC_REF(__remove_debris), smoke_visuals, debris_visuals), 0.7 SECONDS)

/atom/proc/__remove_debris(obj/effect/abstract/particle_holder/smoke_visuals, obj/effect/abstract/particle_holder/debris_visuals)
	QDEL_NULL(smoke_visuals)
	QDEL_NULL(debris_visuals)
