/area
	luminosity = 1

	///The mutable appearance we underlay to show light
	var/mutable_appearance/lighting_effect = null
	///Whether this area has a currently active base lighting, bool
	var/tmp/area_has_base_lighting = FALSE
	/// What type of lighting this area uses
	var/area_lighting = AREA_LIGHTING_DYNAMIC

	// Base lighting vars. Only used if area_lighting is AREA_LIGHTING_STATIC
	///alpha 1-255 of lighting_effect and thus baselighting intensity. If you want this to be zero, use AREA_LIGHTING_NONE instead!
	var/base_lighting_alpha = 255
	///The colour of the light acting on this area
	var/base_lighting_color = COLOR_WHITE


GLOBAL_REAL_VAR(mutable_appearance/fullbright_overlay) = create_fullbright_overlay()

/proc/create_fullbright_overlay(color)
	var/mutable_appearance/lighting_effect = mutable_appearance('icons/effects/alphacolors.dmi', "white")
	lighting_effect.plane = LIGHTING_PLANE
	lighting_effect.layer = LIGHTING_PRIMARY_LAYER
	lighting_effect.blend_mode = BLEND_ADD
	if(color)
		lighting_effect.color = color
	return lighting_effect

/area/proc/set_base_lighting(new_base_lighting_color = -1, new_alpha = -1)
	if(base_lighting_alpha == new_alpha && base_lighting_color == new_base_lighting_color)
		return FALSE
	if(new_alpha != -1)
		base_lighting_alpha = new_alpha
	if(new_base_lighting_color != -1)
		base_lighting_color = new_base_lighting_color
	update_base_lighting()
	return TRUE

/area/vv_edit_var(var_name, var_value)
	switch(var_name)
		if(NAMEOF(src, base_lighting_color))
			set_base_lighting(new_base_lighting_color = var_value)
			return TRUE
		if(NAMEOF(src, base_lighting_alpha))
			set_base_lighting(new_alpha = var_value)
			return TRUE
		if(NAMEOF(src, area_lighting))
			if(area_lighting == AREA_LIGHTING_DYNAMIC)
				create_area_lighting_objects()
			else
				remove_area_lighting_objects()

	return ..()

/area/proc/update_base_lighting()
	var/should_have_base_lighting = area_lighting == AREA_LIGHTING_STATIC
	if(!area_has_base_lighting && !should_have_base_lighting)
		return

	if(!area_has_base_lighting)
		add_base_lighting()
		return

	remove_base_lighting()

	if(should_have_base_lighting)
		add_base_lighting()

/area/proc/remove_base_lighting()
	cut_overlays()
	lighting_effect = null
	area_has_base_lighting = FALSE
	luminosity = 0
	blend_mode = BLEND_DEFAULT

/area/proc/add_base_lighting()
	lighting_effect = mutable_appearance('icons/effects/alphacolors.dmi', "white")
	lighting_effect.plane = LIGHTING_PLANE
	lighting_effect.layer = LIGHTING_PRIMARY_LAYER
	lighting_effect.blend_mode = BLEND_ADD
	lighting_effect.alpha = base_lighting_alpha
	lighting_effect.color = base_lighting_color
	lighting_effect.appearance_flags = RESET_TRANSFORM | RESET_ALPHA | RESET_COLOR
	add_overlay(lighting_effect)

	area_has_base_lighting = TRUE
	luminosity = 1
	blend_mode = BLEND_MULTIPLY

//Non static lighting areas.
//Any lighting area that wont support static lights.
//These areas will NOT have corners generated.

///regenerates lighting objects for turfs in this area, primary use is VV changes
/area/proc/create_area_lighting_objects()
	for(var/turf/T in src)
		if(T.always_lit)
			continue
		T.lighting_build_overlay()
		CHECK_TICK

///Removes lighting objects from turfs in this area if we have them, primary use is VV changes
/area/proc/remove_area_lighting_objects()
	for(var/turf/T in src)
		if(T.always_lit)
			continue
		T.lighting_clear_overlay()
		CHECK_TICK
