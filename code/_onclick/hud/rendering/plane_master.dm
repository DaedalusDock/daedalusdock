/atom/movable/screen/plane_master
	screen_loc = "CENTER"
	icon_state = "blank"
	appearance_flags = PLANE_MASTER|NO_CLIENT_COLOR
	blend_mode = BLEND_OVERLAY
	plane = LOWEST_EVER_PLANE
	var/show_alpha = 255
	var/hide_alpha = 0

	//--rendering relay vars--
	///integer: what plane we will relay this planes render to
	var/render_relay_plane = RENDER_PLANE_GAME
	///bool: Whether this plane should get a render target automatically generated
	var/generate_render_target = TRUE
	///integer: blend mode to apply to the render relay in case you dont want to use the plane_masters blend_mode
	var/blend_mode_override
	///reference: current relay this plane is utilizing to render
	var/atom/movable/render_plane_relay/relay

/atom/movable/screen/plane_master/proc/Show(override)
	alpha = override || show_alpha

/atom/movable/screen/plane_master/proc/Hide(override)
	alpha = override || hide_alpha

//Why do plane masters need a backdrop sometimes? Read https://secure.byond.com/forum/?post=2141928
//Trust me, you need one. Period. If you don't think you do, you're doing something extremely wrong.
/atom/movable/screen/plane_master/proc/backdrop(mob/mymob)
	SHOULD_CALL_PARENT(TRUE)
	if(!isnull(render_relay_plane))
		relay_render_to_plane(mymob, render_relay_plane)

///Contains just the floor
/atom/movable/screen/plane_master/floor
	name = "floor plane master"
	plane = FLOOR_PLANE
	blend_mode = BLEND_OVERLAY

///Contains most things in the game world
/atom/movable/screen/plane_master/game_world
	name = "game world plane master"
	plane = GAME_PLANE
	blend_mode = BLEND_OVERLAY

/atom/movable/screen/plane_master/seethrough
	name = "Seethrough"
	plane = SEETHROUGH_PLANE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/atom/movable/screen/plane_master/massive_obj
	name = "massive object plane master"
	plane = MASSIVE_OBJ_PLANE
	blend_mode = BLEND_OVERLAY

/atom/movable/screen/plane_master/ghost
	name = "ghost plane master"
	plane = GHOST_PLANE
	blend_mode = BLEND_OVERLAY
	render_relay_plane = RENDER_PLANE_NON_GAME

/atom/movable/screen/plane_master/point
	name = "point plane master"
	plane = POINT_PLANE
	blend_mode = BLEND_OVERLAY

/**
 * Plane master handling byond internal blackness
 * vars are set as to replicate behavior when rendering to other planes
 * do not touch this unless you know what you are doing
 */
/atom/movable/screen/plane_master/blackness
	name = "darkness plane master"
	plane = BLACKNESS_PLANE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	blend_mode = BLEND_MULTIPLY
	blend_mode_override = BLEND_OVERLAY
	appearance_flags = PLANE_MASTER | NO_CLIENT_COLOR | PIXEL_SCALE
	//byond internal end

///Contains all lighting objects
/atom/movable/screen/plane_master/lighting
	name = "lighting plane master"
	plane = LIGHTING_PLANE
	blend_mode_override = BLEND_MULTIPLY
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT


/atom/movable/screen/plane_master/lighting/backdrop(mob/mymob)
	. = ..()
	mymob.overlay_fullscreen("lighting_backdrop_lit", /atom/movable/screen/fullscreen/lighting_backdrop/lit)
	mymob.overlay_fullscreen("lighting_backdrop_unlit", /atom/movable/screen/fullscreen/lighting_backdrop/unlit)

/*!
 * This system works by exploiting BYONDs color matrix filter to use layers to handle emissive blockers.
 *
 * Emissive overlays are pasted with an atom color that converts them to be entirely some specific color.
 * Emissive blockers are pasted with an atom color that converts them to be entirely some different color.
 * Emissive overlays and emissive blockers are put onto the same plane.
 * The layers for the emissive overlays and emissive blockers cause them to mask eachother similar to normal BYOND objects.
 * A color matrix filter is applied to the emissive plane to mask out anything that isn't whatever the emissive color is.
 * This is then used to alpha mask the lighting plane.
 */
/atom/movable/screen/plane_master/lighting/Initialize(mapload)
	. = ..()
	add_filter("emissives", 1, alpha_mask_filter(render_source = EMISSIVE_RENDER_TARGET, flags = MASK_INVERSE))
	add_filter("object_lighting", 2, alpha_mask_filter(render_source = O_LIGHTING_VISUAL_RENDER_TARGET, flags = MASK_INVERSE))

/atom/movable/screen/plane_master/additive_lighting
	name = "additive lighting plane master"
	plane = LIGHTING_PLANE_ADDITIVE
	blend_mode_override = BLEND_ADD
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/**
 * Handles emissive overlays and emissive blockers.
 */
/atom/movable/screen/plane_master/emissive
	name = "emissive plane master"
	plane = EMISSIVE_PLANE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	render_target = EMISSIVE_RENDER_TARGET
	render_relay_plane = null

/atom/movable/screen/plane_master/emissive/Initialize(mapload)
	. = ..()
	add_filter("em_block_masking", 1, color_matrix_filter(GLOB.em_mask_matrix))

/atom/movable/screen/plane_master/above_lighting
	name = "above lighting plane master"
	plane = ABOVE_LIGHTING_PLANE
	blend_mode = BLEND_OVERLAY

///Contains space parallax
/atom/movable/screen/plane_master/parallax
	name = "parallax plane master"
	plane = PLANE_SPACE_PARALLAX
	blend_mode = BLEND_MULTIPLY
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/atom/movable/screen/plane_master/parallax_white
	name = "parallax whitifier plane master"
	plane = PLANE_SPACE

/atom/movable/screen/plane_master/pipecrawl
	name = "pipecrawl plane master"
	plane = PIPECRAWL_IMAGES_PLANE
	blend_mode = BLEND_OVERLAY

/atom/movable/screen/plane_master/pipecrawl/Initialize(mapload)
	. = ..()
	// Makes everything on this plane slightly brighter
	// Has a nice effect, makes thing stand out
	color = list(1.2,0,0,0, 0,1.2,0,0, 0,0,1.2,0, 0,0,0,1, 0,0,0,0)
	// This serves a similar purpose, I want the pipes to pop
	add_filter("pipe_dropshadow", 1, drop_shadow_filter(x = -1, y= -1, size = 1, color = "#0000007A"))

/atom/movable/screen/plane_master/camera_static
	name = "camera static plane master"
	plane = CAMERA_STATIC_PLANE
	blend_mode = BLEND_OVERLAY

/atom/movable/screen/plane_master/o_light_visual
	name = "overlight light visual plane master"
	plane = O_LIGHTING_VISUAL_PLANE
	render_target = O_LIGHTING_VISUAL_RENDER_TARGET
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	blend_mode = BLEND_MULTIPLY
	blend_mode_override = BLEND_MULTIPLY

/atom/movable/screen/plane_master/runechat
	name = "runechat plane master"
	plane = RUNECHAT_PLANE
	blend_mode = BLEND_OVERLAY
	render_relay_plane = RENDER_PLANE_NON_GAME

/atom/movable/screen/plane_master/gravpulse
	name = "gravpulse plane"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	plane = GRAVITY_PULSE_PLANE
	blend_mode = BLEND_ADD
	blend_mode_override = BLEND_ADD
	render_target = GRAVITY_PULSE_RENDER_TARGET
	render_relay_plane = null

/atom/movable/screen/plane_master/heat
	name = "heat plane"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	plane = HEAT_PLANE
	render_target = HEAT_COMPOSITE_RENDER_TARGET
	render_relay_plane = null
	var/obj/gas_heat_object = null

/atom/movable/screen/plane_master/heat/New()
	. = ..()
	gas_heat_object = new /obj/effect/abstract/particle_emitter/heat(null, -1)
	gas_heat_object.particles?.count = 250
	gas_heat_object.particles?.spawning = 15
	add_viscontents(gas_heat_object)

/atom/movable/screen/plane_master/area
	name = "area plane"
	plane = AREA_PLANE

/atom/movable/screen/plane_master/radtext
	name = "radtext plane"
	plane = RAD_TEXT_PLANE
	render_relay_plane = RENDER_PLANE_NON_GAME

/atom/movable/screen/plane_master/balloon_chat
	name = "balloon alert plane"
	plane = BALLOON_CHAT_PLANE
	render_relay_plane = RENDER_PLANE_NON_GAME

/atom/movable/screen/plane_master/fullscreen
	name = "fullscreen alert plane"
	plane = FULLSCREEN_PLANE
	render_relay_plane = RENDER_PLANE_NON_GAME
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/atom/movable/screen/plane_master/hud
	name = "HUD plane"
	plane = HUD_PLANE
	render_relay_plane = RENDER_PLANE_NON_GAME

/atom/movable/screen/plane_master/above_hud
	name = "above HUD plane"
	plane = ABOVE_HUD_PLANE
	render_relay_plane = RENDER_PLANE_NON_GAME
