/// A copy of is_blocked_turf(), ignoring flock mobs
/turf/proc/can_flock_occupy(atom/source_atom)
	if(density)
		return FALSE

	for(var/atom/movable/movable_content as anything in contents)
		// We don't want to block ourselves or consider any ignored atoms.
		if((movable_content == source_atom) || isflockmob(movable_content))
			continue
		// If the thing is dense AND we're including mobs or the thing isn't a mob AND if there's a source atom and
		// it cannot pass through the thing on the turf,  we consider the turf blocked.
		if(movable_content.density)
			if(source_atom && movable_content.CanPass(source_atom, get_dir(src, source_atom)))
				continue
			return FALSE

	return TRUE

/proc/flock_pointer(atom/from, atom/towards)
	var/image/pointer = image(icon = 'icons/hud/screen1.dmi', icon_state = "arrow_greyscale", loc = from)

	pointer.plane = HUD_PLANE
	pointer.appearance_flags |= RESET_COLOR
	pointer.color = "#00ff9dff"

	var/angle = 180 + get_angle(from, towards)
	var/matrix/final_matrix = pointer.transform.Scale(2,2)
	final_matrix = final_matrix.Turn(angle)
	pointer.transform = final_matrix

	pointer.pixel_x = sin(angle) * -48
	pointer.pixel_y = cos(angle) * -48
	return pointer

/proc/flock_realname(flock_type)
	var/attempts = 0
	var/name = ""
	do
		attempts++

		switch(flock_type)
			if(FLOCK_TYPE_OVERMIND)
				name = "\proper[pick(GLOB.consonants_lower)][pick(GLOB.vowels_lower)].[pick(GLOB.consonants_lower)][pick(GLOB.vowels_lower)]"
			if(FLOCK_TYPE_TRACE)
				name = "[pick(GLOB.consonants_upper)][pick(GLOB.vowels_lower)].[pick(GLOB.vowels_lower)]"
			if(FLOCK_TYPE_DRONE)
				name = "\proper[pick(GLOB.consonants_lower)][pick(GLOB.vowels_lower)].[pick(GLOB.consonants_lower)][pick(GLOB.vowels_lower)].[pick(GLOB.consonants_lower)][pick(GLOB.vowels_lower)]"
			if(FLOCK_TYPE_BIT)
				name = "[pick(GLOB.consonants_upper)].[rand(10,99)].[rand(10,99)]"

	while(attempts <= 10 && findname(name))

	return name

/proc/flock_name(flock_type)
	var/attempts = 0
	var/name = ""
	do
		attempts++

		switch(flock_type)
			if(FLOCK_TYPE_DRONE)
				name = "[pick(GLOB.flockdrone_name_adjectives)] [pick(GLOB.flockdrone_name_nouns)]"
			if(FLOCK_TYPE_BIT)
				name = "[pick(GLOB.consonants_upper)].[rand(10,99)].[rand(10,99)]"

	while(attempts <= 10 && findname(name))

	return name

/atom/proc/can_flock_convert()
	return FALSE

/turf/open/floor/can_flock_convert()
	return TRUE

/turf/open/floor/flock/can_flock_convert()
	return TRUE
