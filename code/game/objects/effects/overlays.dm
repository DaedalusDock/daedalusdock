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

/obj/effect/overlay/ai_holder
	icon = 'goon/icons/obj/96x96.dmi'
	icon_state = "oldai-01"

	var/mob/living/silicon/ai/ai

	vis_flags = VIS_INHERIT_ID | VIS_INHERIT_LAYER | VIS_INHERIT_PLANE
	pixel_x = -32
	pixel_y = -32

/obj/effect/overlay/ai_holder/Destroy(force)
	ai = null
	return ..()

/obj/effect/overlay/ai_holder/update_overlays()
	. = ..()
	if(ai.stat != CONSCIOUS)
		return

	. += image(icon, "oldai-[ai.face_state]")
	. += emissive_appearance(icon, "oldai-[ai.face_state]", alpha = 70)

	. += image(icon, "oldai-faceoverlay")
	. += emissive_appearance(icon, "oldai-faceoverlay", alpha = 70)

	var/image/light = image(icon, "oldai-light")
	light.plane = ABOVE_LIGHTING_PLANE
	. += light

/// Fade away the face. Kind of hacky but I don't care.
/obj/effect/overlay/ai_holder/proc/death_animation(progress = 1)
	cut_overlays()
	if(QDELETED(ai) || progress >= 4) // There's 4 face fade states.
		return

	if(ai.stat == CONSCIOUS)
		update_appearance() // Reset to the normal living state.
		return

	var/list/new_overlays = list()
	new_overlays += image(icon, "oldai-face_fade0[progress]")
	new_overlays += emissive_appearance(icon, "oldai-face_fade0[progress]", alpha = 70)

	new_overlays += image(icon, "oldai-faceoverlay")
	new_overlays += emissive_appearance(icon, "oldai-faceoverlay", alpha = 70)

	var/image/light = image(icon, "oldai-light")
	light.plane = ABOVE_LIGHTING_PLANE
	new_overlays += light
	add_overlay(new_overlays)

	addtimer(CALLBACK(src, PROC_REF(death_animation), progress + 1), 0.5 SECONDS)
