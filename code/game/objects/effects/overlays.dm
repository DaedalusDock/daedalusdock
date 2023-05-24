/obj/effect/overlay
	name = "overlay"

/obj/effect/overlay/singularity_act()
	return

/obj/effect/overlay/singularity_pull()
	return

/obj/effect/overlay/beam//Not actually a projectile, just an effect.
	name="beam"
	icon='icons/effects/beam.dmi'
	icon_state="b_beam"
	var/atom/BeamSource

/obj/effect/overlay/beam/Initialize(mapload)
	. = ..()
	QDEL_IN(src, 10)

/obj/effect/overlay/palmtree_r
	name = "palm tree"
	icon = 'icons/misc/beach2.dmi'
	icon_state = "palm1"
	density = TRUE
	layer = WALL_OBJ_LAYER
	anchored = TRUE

/obj/effect/overlay/palmtree_l
	name = "palm tree"
	icon = 'icons/misc/beach2.dmi'
	icon_state = "palm2"
	density = TRUE
	layer = WALL_OBJ_LAYER
	anchored = TRUE

/obj/effect/overlay/coconut
	gender = PLURAL
	name = "coconuts"
	icon = 'icons/misc/beach.dmi'
	icon_state = "coconuts"

/obj/effect/overlay/sparkles
	gender = PLURAL
	name = "sparkles"
	icon = 'icons/effects/effects.dmi'
	icon_state = "shieldsparkles"
	anchored = TRUE

/// If you're wanting to use vis_contents as overlays, use this.
/obj/effect/overlay/vis
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	anchored = TRUE

//I don't want to have to write new(null, ...) at every use
/obj/effect/overlay/vis/New(icon, icon_state, layer, dir, alpha, flags = VIS_INHERIT_DIR|VIS_INHERIT_PLANE)
	vis_flags = flags
	src.icon = icon
	src.icon_state = icon_state
	if(layer)
		src.layer = layer
	if(dir)
		src.dir = dir
	if(alpha)
		src.alpha = alpha

	..(null)


/// Door overlay for animating closets
/obj/effect/overlay/closet_door
	anchored = TRUE
	plane = FLOAT_PLANE
	layer = FLOAT_LAYER
	vis_flags = VIS_INHERIT_ID
	appearance_flags = KEEP_TOGETHER | LONG_GLIDE | PIXEL_SCALE
