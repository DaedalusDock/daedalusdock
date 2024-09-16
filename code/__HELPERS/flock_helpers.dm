/turf/proc/canpass_flock(mob/living/simple_animal/flock/passer)
	if(density && (!(pass_flags_self & passer.pass_flags)))
		return FALSE

	var/pass_dir = get_dir(passer, src)
	for(var/atom/movable/AM as anything in src)
		if(AM.density && !(AM.CanPass(passer, pass_dir)))
			return FALSE

	return TRUE

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
			// if(FLOCK_TYPE_BIT)
			// 	name = "[pick(consonants_upper)].[rand(10,99)].[rand(10,99)]"

	while(attempts <= 10 && findname(name))

	return name

/atom/proc/can_flock_convert()
	return FALSE

/turf/open/floor/can_flock_convert()
	return TRUE

/turf/open/floor/flock/can_flock_convert()
	return TRUE
