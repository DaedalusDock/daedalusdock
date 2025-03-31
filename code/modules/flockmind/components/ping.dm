/datum/component/flock_ping
	var/duration = 5 SECONDS
	var/outline_color = "#00ff9d"
	var/outline_thickness = 1
	var/animate = TRUE

	var/datum/atom_hud/alternate_appearance/basic/flock/hud_ref

/datum/component/flock_ping/Initialize(duration)
	. = ..()
	if(!ismovable(parent) && !isturf(parent))
		return COMPONENT_INCOMPATIBLE

	if(duration)
		src.duration = duration

/datum/component/flock_ping/RegisterWithParent()
	. = ..()
	//this cast looks horribly unsafe, but we've guaranteed that parent is a type with vis_contents in Initialize
	var/atom/movable/target = parent

	target.render_target = REF(target)

	var/image/outline = new()
	outline.loc = target
	outline.render_source = target.render_target
	outline.render_target = ref(outline)
	outline.appearance_flags |= KEEP_TOGETHER
	outline.vis_contents += target
	outline.filters += outline_filter(size = outline_thickness, color = outline_color)
	outline.filters += alpha_mask_filter(render_source = outline.render_target, flags = MASK_INVERSE)

	if(animate)
		animate(outline, time = duration/9, alpha = 100, loop = 10)
		animate(time = duration/9, alpha = 255)

	hud_ref = target.add_alt_appearance(/datum/atom_hud/alternate_appearance/basic/flock, "ping", outline)

	if(duration == INFINITY)
		return

	addtimer(CALLBACK(src, PROC_REF(cleanup)), duration)

/datum/component/flock_ping/UnregisterFromParent()
	. = ..()
	var/atom/movable/target = parent
	target.remove_alt_appearance("ping")

/datum/component/flock_ping/proc/cleanup()
	qdel(src)
