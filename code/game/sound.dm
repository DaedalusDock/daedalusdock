
///Default override for echo
/sound
	echo = list(
		0, // Direct
		0, // DirectHF
		-10000, // Room, -10000 means no low frequency sound reverb
		-10000, // RoomHF, -10000 means no high frequency sound reverb
		0, // Obstruction
		0, // ObstructionLFRatio
		0, // Occlusion
		0.25, // OcclusionLFRatio
		1.5, // OcclusionRoomRatio
		1.0, // OcclusionDirectRatio
		0, // Exclusion
		1.0, // ExclusionLFRatio
		0, // OutsideVolumeHF
		0, // DopplerFactor
		0, // RolloffFactor
		0, // RoomRolloffFactor
		1.0, // AirAbsorptionFactor
		0, // Flags (1 = Auto Direct, 2 = Auto Room, 4 = Auto RoomHF)
	)
	environment = SOUND_ENVIRONMENT_NONE //Default to none so sounds without overrides dont get reverb

/**
 * playsound is a proc used to play a 3D sound in a specific range. This uses SOUND_RANGE + extra_range to determine that.
 *
 * source - Origin of sound.
 * soundin - Either a file, or a string that can be used to get an SFX.
 * vol - The volume of the sound, excluding falloff and pressure affection.
 * vary - bool that determines if the sound changes pitch every time it plays.
 * extrarange - modifier for sound range. This gets added on top of SOUND_RANGE.
 * falloff_exponent - Rate of falloff for the audio. Higher means quicker drop to low volume. Should generally be over 1 to indicate a quick dive to 0 rather than a slow dive.
 * frequency - playback speed of audio.
 * channel - The channel the sound is played at.
 * pressure_affected - Whether or not difference in pressure affects the sound (E.g. if you can hear in space).
 * ignore_walls - Whether or not the sound can pass through walls.
 * falloff_distance - Distance at which falloff begins. Sound is at peak volume (in regards to falloff) aslong as it is in this range.
 */
/proc/playsound(atom/source, soundin, vol as num, vary, extrarange as num, falloff_exponent = SOUND_FALLOFF_EXPONENT, frequency = null, channel = 0, pressure_affected = TRUE, ignore_walls = TRUE, falloff_distance = SOUND_DEFAULT_FALLOFF_DISTANCE, use_reverb = TRUE)
	if(isarea(source))
		CRASH("playsound(): source is an area")
	if(isnull(vol))
		CRASH("Playsound received a null volume, this is probably wrong!")
	if(islist(soundin))
		CRASH("Playsound received a list, this is unsupported")

	var/turf/turf_source = get_turf(source)

	if (!turf_source || !soundin || !vol)
		return

	//allocate a channel if necessary now so its the same for everyone
	channel = channel || SSsounds.random_available_channel()

	var/sound/S = sound(get_sfx(soundin))
	var/maxdistance = SOUND_RANGE + extrarange
	var/source_z = turf_source.z
	var/list/listeners = SSmobs.clients_by_zlevel[source_z].Copy()

	. = list()//output everything that successfully heard the sound

	var/turf/above_turf = GetAbove(turf_source)
	var/turf/below_turf = GetBelow(turf_source)

	if(ignore_walls)

		if(above_turf && istransparentturf(above_turf))
			listeners += SSmobs.clients_by_zlevel[above_turf.z]

		if(below_turf && istransparentturf(turf_source))
			listeners += SSmobs.clients_by_zlevel[below_turf.z]

	else //these sounds don't carry through walls
		listeners = get_hearers_in_view(maxdistance, turf_source)

		if(above_turf && istransparentturf(above_turf))
			listeners += get_hearers_in_view(maxdistance, above_turf)

		if(below_turf && istransparentturf(turf_source))
			listeners += get_hearers_in_view(maxdistance, below_turf)

	listeners |= SSmobs.dead_players_by_zlevel[source_z]
	if(length(SSmobs.flock_cameras_by_zlevel[source_z]))
		listeners |= SSmobs.flock_cameras_by_zlevel[source_z]

	for(var/mob/listening_mob in listeners)//observers always hear through walls
		if(get_dist(listening_mob, turf_source) <= maxdistance)
			listening_mob.playsound_local(turf_source, soundin, vol, vary, frequency, falloff_exponent, channel, pressure_affected, S, maxdistance, falloff_distance, 1, use_reverb)
			. += listening_mob

/mob/proc/playsound_local(turf/turf_source, soundin, vol as num, vary, frequency, falloff_exponent = SOUND_FALLOFF_EXPONENT, channel = 0, pressure_affected = TRUE, sound/sound_to_use, max_distance, falloff_distance = SOUND_DEFAULT_FALLOFF_DISTANCE, distance_multiplier = 1, use_reverb = TRUE, wait = FALSE)
	if(!client || !can_hear())
		return

	if(!sound_to_use)
		sound_to_use = sound(get_sfx(soundin))

	sound_to_use.wait = wait
	sound_to_use.channel = channel || SSsounds.random_available_channel()
	sound_to_use.volume = vol

	if(vary)
		if(frequency)
			sound_to_use.frequency = frequency
		else
			sound_to_use.frequency = get_rand_frequency()

	if(isturf(turf_source))
		var/turf/turf_loc = get_turf(src)

		//sound volume falloff with distance
		var/distance = get_dist(turf_loc, turf_source) * distance_multiplier

		if(max_distance && falloff_exponent) //If theres no max_distance we're not a 3D sound, so no falloff.
			sound_to_use.volume -= (max(distance - falloff_distance, 0) ** (1 / falloff_exponent)) / ((max(max_distance, distance) - falloff_distance) ** (1 / falloff_exponent)) * sound_to_use.volume
			//https://www.desmos.com/calculator/sqdfl8ipgf

		if(pressure_affected)
			//Atmosphere affects sound
			var/pressure_factor = 1
			var/datum/gas_mixture/hearer_env = turf_loc.unsafe_return_air()
			var/datum/gas_mixture/source_env = turf_source.unsafe_return_air()

			if(hearer_env && source_env)
				var/pressure = min(hearer_env.returnPressure(), source_env.returnPressure())
				if(pressure < ONE_ATMOSPHERE)
					pressure_factor = max((pressure - SOUND_MINIMUM_PRESSURE)/(ONE_ATMOSPHERE - SOUND_MINIMUM_PRESSURE), 0)
			else //space
				pressure_factor = 0

			if(distance <= 1)
				pressure_factor = max(pressure_factor, 0.15) //touching the source of the sound

			sound_to_use.volume *= pressure_factor
			//End Atmosphere affecting sound

		if(sound_to_use.volume <= 0)
			return FALSE

		var/dx = turf_source.x - turf_loc.x // Hearing from the right/left
		sound_to_use.x = dx * distance_multiplier
		var/dz = turf_source.y - turf_loc.y // Hearing from infront/behind
		sound_to_use.z = dz * distance_multiplier
		var/dy = (turf_source.z - turf_loc.z) * 5 * distance_multiplier // Hearing from  above / below, multiplied by 5 because we assume height is further along coords.
		sound_to_use.y = dy

		sound_to_use.falloff = max_distance || 1 //use max_distance, else just use 1 as we are a direct sound so falloff isnt relevant.

		// Sounds can't have their own environment. A sound's environment will be:
		// 1. the mob's
		// 2. the area's (defaults to SOUND_ENVRIONMENT_NONE)
		if(sound_environment_override != SOUND_ENVIRONMENT_NONE)
			sound_to_use.environment = sound_environment_override
		else
			var/area/A = get_area(src)
			sound_to_use.environment = A.sound_environment

		if(use_reverb && sound_to_use.environment != SOUND_ENVIRONMENT_NONE) //We have reverb, reset our echo setting
			sound_to_use.echo[3] = 0 //Room setting, 0 means normal reverb
			sound_to_use.echo[4] = 0 //RoomHF setting, 0 means normal reverb.

	SEND_SOUND(src, sound_to_use)
	if(LAZYLEN(observers))
		for(var/mob/dead/observer/O as anything in observers)
			SEND_SOUND(src, sound_to_use)
	return TRUE

/proc/sound_to_playing_players(soundin, volume = 100, vary = FALSE, frequency = 0, channel = 0, pressure_affected = FALSE, sound/S)
	if(!S)
		S = sound(get_sfx(soundin))
	for(var/m in GLOB.player_list)
		if(ismob(m) && !isnewplayer(m))
			var/mob/M = m
			M.playsound_local(M, null, volume, vary, frequency, null, channel, pressure_affected, S)

/mob/proc/stop_sound_channel(chan)
	SEND_SOUND(src, sound(null, repeat = 0, wait = 0, channel = chan))

/mob/proc/set_sound_channel_volume(channel, volume)
	var/sound/S = sound(null, FALSE, FALSE, channel, volume)
	S.status = SOUND_UPDATE
	SEND_SOUND(src, S)

/proc/get_rand_frequency()
	return rand(32000, 55000) //Frequency stuff only works with 45kbps oggs.

/proc/get_sfx(soundin)
	if(istext(soundin))
		soundin = get_sfx_pariah(soundin) //PARIAH EDIT ADDITION - This overrides the default sound effects too, so use it to modularly change a sound effect output.
		switch(soundin)
			if (SFX_SHATTER)
				soundin = pick('sound/effects/glassbr1.ogg','sound/effects/glassbr2.ogg','sound/effects/glassbr3.ogg')
			if (SFX_EXPLOSION)
				soundin = pick('sound/effects/explosion1.ogg','sound/effects/explosion2.ogg')
			if (SFX_EXPLOSION_CREAKING)
				soundin = pick('sound/effects/explosioncreak1.ogg', 'sound/effects/explosioncreak2.ogg')
			if (SFX_HULL_CREAKING)
				soundin = pick('sound/effects/creak1.ogg', 'sound/effects/creak2.ogg', 'sound/effects/creak3.ogg')
			if (SFX_SPARKS)
				soundin = pick('sound/effects/sparks1.ogg','sound/effects/sparks2.ogg','sound/effects/sparks3.ogg','sound/effects/sparks4.ogg')
			if (SFX_RUSTLE)
				soundin = pick('sound/effects/rustle1.ogg','sound/effects/rustle2.ogg','sound/effects/rustle3.ogg','sound/effects/rustle4.ogg','sound/effects/rustle5.ogg')
			if (SFX_BODYFALL)
				soundin = pick('sound/effects/bodyfall1.ogg','sound/effects/bodyfall2.ogg','sound/effects/bodyfall3.ogg','sound/effects/bodyfall4.ogg')
			if (SFX_PUNCH)
				soundin = pick('sound/weapons/attack/punch.ogg','sound/weapons/attack/punch_2.ogg', 'sound/weapons/attack/punch_3.ogg', 'sound/weapons/attack/punch_4.ogg')
			if (SFX_CLOWN_STEP)
				soundin = pick('sound/effects/clownstep1.ogg','sound/effects/clownstep2.ogg')
			if (SFX_SUIT_STEP)
				soundin = pick('sound/effects/suitstep1.ogg','sound/effects/suitstep2.ogg')
			if (SFX_SWING_HIT)
				soundin = pick('sound/weapons/genhit1.ogg', 'sound/weapons/genhit2.ogg', 'sound/weapons/genhit3.ogg')
			if (SFX_HISS)
				soundin = pick('sound/voice/hiss1.ogg','sound/voice/hiss2.ogg','sound/voice/hiss3.ogg','sound/voice/hiss4.ogg')
			if (SFX_PAGE_TURN)
				soundin = pick('sound/effects/pageturn1.ogg', 'sound/effects/pageturn2.ogg','sound/effects/pageturn3.ogg')
			if (SFX_RICOCHET)
				soundin = pick( 'sound/weapons/effects/ric1.ogg', 'sound/weapons/effects/ric2.ogg','sound/weapons/effects/ric3.ogg','sound/weapons/effects/ric4.ogg','sound/weapons/effects/ric5.ogg')
			if (SFX_TERMINAL_TYPE)
				soundin = pick('sound/machines/terminal_button01.ogg', 'sound/machines/terminal_button02.ogg', 'sound/machines/terminal_button03.ogg', \
								'sound/machines/terminal_button04.ogg', 'sound/machines/terminal_button05.ogg', 'sound/machines/terminal_button06.ogg', \
								'sound/machines/terminal_button07.ogg', 'sound/machines/terminal_button08.ogg')
			if (SFX_DESECRATION)
				soundin = pick('sound/misc/desecration-01.ogg', 'sound/misc/desecration-02.ogg', 'sound/misc/desecration-03.ogg')
			if (SFX_IM_HERE)
				soundin = pick('sound/hallucinations/im_here1.ogg', 'sound/hallucinations/im_here2.ogg')
			if (SFX_CAN_OPEN)
				soundin = pick('sound/effects/can_open1.ogg', 'sound/effects/can_open2.ogg', 'sound/effects/can_open3.ogg')
			if(SFX_BULLET_MISS)
				soundin = pick('sound/weapons/bulletflyby.ogg', 'sound/weapons/bulletflyby2.ogg', 'sound/weapons/bulletflyby3.ogg')
			if(SFX_REVOLVER_SPIN)
				soundin = pick('sound/weapons/gun/revolver/spin1.ogg', 'sound/weapons/gun/revolver/spin2.ogg', 'sound/weapons/gun/revolver/spin3.ogg')
			if(SFX_LAW)
				soundin = pick('sound/voice/beepsky/god.ogg', 'sound/voice/beepsky/iamthelaw.ogg', 'sound/voice/beepsky/secureday.ogg', 'sound/voice/beepsky/radio.ogg', 'sound/voice/beepsky/insult.ogg', 'sound/voice/beepsky/creep.ogg')
			if(SFX_HONKBOT_E)
				soundin = pick('sound/items/bikehorn.ogg', 'sound/items/AirHorn2.ogg', 'sound/misc/sadtrombone.ogg', 'sound/items/AirHorn.ogg', 'sound/effects/reee.ogg',  'sound/items/WEEOO1.ogg', 'sound/voice/beepsky/iamthelaw.ogg', 'sound/voice/beepsky/creep.ogg','sound/magic/Fireball.ogg' ,'sound/effects/pray.ogg', 'sound/voice/hiss1.ogg','sound/machines/buzz-sigh.ogg', 'sound/machines/ping.ogg', 'sound/weapons/flashbang.ogg', 'sound/weapons/bladeslice.ogg')
			if("goose")
				soundin = pick('sound/creatures/goose1.ogg', 'sound/creatures/goose2.ogg', 'sound/creatures/goose3.ogg', 'sound/creatures/goose4.ogg')
			if(SFX_WARPSPEED)
				soundin = 'sound/runtime/hyperspace/hyperspace_begin.ogg'
			if(SFX_SM_CALM)
				soundin = pick('sound/machines/sm/accent/normal/1.ogg', 'sound/machines/sm/accent/normal/2.ogg', 'sound/machines/sm/accent/normal/3.ogg', 'sound/machines/sm/accent/normal/4.ogg', 'sound/machines/sm/accent/normal/5.ogg', 'sound/machines/sm/accent/normal/6.ogg', 'sound/machines/sm/accent/normal/7.ogg', 'sound/machines/sm/accent/normal/8.ogg', 'sound/machines/sm/accent/normal/9.ogg', 'sound/machines/sm/accent/normal/10.ogg', 'sound/machines/sm/accent/normal/11.ogg', 'sound/machines/sm/accent/normal/12.ogg', 'sound/machines/sm/accent/normal/13.ogg', 'sound/machines/sm/accent/normal/14.ogg', 'sound/machines/sm/accent/normal/15.ogg', 'sound/machines/sm/accent/normal/16.ogg', 'sound/machines/sm/accent/normal/17.ogg', 'sound/machines/sm/accent/normal/18.ogg', 'sound/machines/sm/accent/normal/19.ogg', 'sound/machines/sm/accent/normal/20.ogg', 'sound/machines/sm/accent/normal/21.ogg', 'sound/machines/sm/accent/normal/22.ogg', 'sound/machines/sm/accent/normal/23.ogg', 'sound/machines/sm/accent/normal/24.ogg', 'sound/machines/sm/accent/normal/25.ogg', 'sound/machines/sm/accent/normal/26.ogg', 'sound/machines/sm/accent/normal/27.ogg', 'sound/machines/sm/accent/normal/28.ogg', 'sound/machines/sm/accent/normal/29.ogg', 'sound/machines/sm/accent/normal/30.ogg', 'sound/machines/sm/accent/normal/31.ogg', 'sound/machines/sm/accent/normal/32.ogg', 'sound/machines/sm/accent/normal/33.ogg')
			if(SFX_SM_DELAM)
				soundin = pick('sound/machines/sm/accent/delam/1.ogg', 'sound/machines/sm/accent/delam/2.ogg', 'sound/machines/sm/accent/delam/3.ogg', 'sound/machines/sm/accent/delam/4.ogg', 'sound/machines/sm/accent/delam/5.ogg', 'sound/machines/sm/accent/delam/6.ogg', 'sound/machines/sm/accent/delam/7.ogg', 'sound/machines/sm/accent/delam/8.ogg', 'sound/machines/sm/accent/delam/9.ogg', 'sound/machines/sm/accent/delam/10.ogg', 'sound/machines/sm/accent/delam/11.ogg', 'sound/machines/sm/accent/delam/12.ogg', 'sound/machines/sm/accent/delam/13.ogg', 'sound/machines/sm/accent/delam/14.ogg', 'sound/machines/sm/accent/delam/15.ogg', 'sound/machines/sm/accent/delam/16.ogg', 'sound/machines/sm/accent/delam/17.ogg', 'sound/machines/sm/accent/delam/18.ogg', 'sound/machines/sm/accent/delam/19.ogg', 'sound/machines/sm/accent/delam/20.ogg', 'sound/machines/sm/accent/delam/21.ogg', 'sound/machines/sm/accent/delam/22.ogg', 'sound/machines/sm/accent/delam/23.ogg', 'sound/machines/sm/accent/delam/24.ogg', 'sound/machines/sm/accent/delam/25.ogg', 'sound/machines/sm/accent/delam/26.ogg', 'sound/machines/sm/accent/delam/27.ogg', 'sound/machines/sm/accent/delam/28.ogg', 'sound/machines/sm/accent/delam/29.ogg', 'sound/machines/sm/accent/delam/30.ogg', 'sound/machines/sm/accent/delam/31.ogg', 'sound/machines/sm/accent/delam/32.ogg', 'sound/machines/sm/accent/delam/33.ogg')
			if(SFX_HYPERTORUS_CALM)
				soundin = pick('sound/machines/sm/accent/normal/1.ogg', 'sound/machines/sm/accent/normal/2.ogg', 'sound/machines/sm/accent/normal/3.ogg', 'sound/machines/sm/accent/normal/4.ogg', 'sound/machines/sm/accent/normal/5.ogg', 'sound/machines/sm/accent/normal/6.ogg', 'sound/machines/sm/accent/normal/7.ogg', 'sound/machines/sm/accent/normal/8.ogg', 'sound/machines/sm/accent/normal/9.ogg', 'sound/machines/sm/accent/normal/10.ogg', 'sound/machines/sm/accent/normal/11.ogg', 'sound/machines/sm/accent/normal/12.ogg', 'sound/machines/sm/accent/normal/13.ogg', 'sound/machines/sm/accent/normal/14.ogg', 'sound/machines/sm/accent/normal/15.ogg', 'sound/machines/sm/accent/normal/16.ogg', 'sound/machines/sm/accent/normal/17.ogg', 'sound/machines/sm/accent/normal/18.ogg', 'sound/machines/sm/accent/normal/19.ogg', 'sound/machines/sm/accent/normal/20.ogg', 'sound/machines/sm/accent/normal/21.ogg', 'sound/machines/sm/accent/normal/22.ogg', 'sound/machines/sm/accent/normal/23.ogg', 'sound/machines/sm/accent/normal/24.ogg', 'sound/machines/sm/accent/normal/25.ogg', 'sound/machines/sm/accent/normal/26.ogg', 'sound/machines/sm/accent/normal/27.ogg', 'sound/machines/sm/accent/normal/28.ogg', 'sound/machines/sm/accent/normal/29.ogg', 'sound/machines/sm/accent/normal/30.ogg', 'sound/machines/sm/accent/normal/31.ogg', 'sound/machines/sm/accent/normal/32.ogg', 'sound/machines/sm/accent/normal/33.ogg')
			if(SFX_HYPERTORUS_MELTING)
				soundin = pick('sound/machines/sm/accent/delam/1.ogg', 'sound/machines/sm/accent/delam/2.ogg', 'sound/machines/sm/accent/delam/3.ogg', 'sound/machines/sm/accent/delam/4.ogg', 'sound/machines/sm/accent/delam/5.ogg', 'sound/machines/sm/accent/delam/6.ogg', 'sound/machines/sm/accent/delam/7.ogg', 'sound/machines/sm/accent/delam/8.ogg', 'sound/machines/sm/accent/delam/9.ogg', 'sound/machines/sm/accent/delam/10.ogg', 'sound/machines/sm/accent/delam/11.ogg', 'sound/machines/sm/accent/delam/12.ogg', 'sound/machines/sm/accent/delam/13.ogg', 'sound/machines/sm/accent/delam/14.ogg', 'sound/machines/sm/accent/delam/15.ogg', 'sound/machines/sm/accent/delam/16.ogg', 'sound/machines/sm/accent/delam/17.ogg', 'sound/machines/sm/accent/delam/18.ogg', 'sound/machines/sm/accent/delam/19.ogg', 'sound/machines/sm/accent/delam/20.ogg', 'sound/machines/sm/accent/delam/21.ogg', 'sound/machines/sm/accent/delam/22.ogg', 'sound/machines/sm/accent/delam/23.ogg', 'sound/machines/sm/accent/delam/24.ogg', 'sound/machines/sm/accent/delam/25.ogg', 'sound/machines/sm/accent/delam/26.ogg', 'sound/machines/sm/accent/delam/27.ogg', 'sound/machines/sm/accent/delam/28.ogg', 'sound/machines/sm/accent/delam/29.ogg', 'sound/machines/sm/accent/delam/30.ogg', 'sound/machines/sm/accent/delam/31.ogg', 'sound/machines/sm/accent/delam/32.ogg', 'sound/machines/sm/accent/delam/33.ogg')
			if(SFX_CRUNCHY_BUSH_WHACK)
				soundin = pick('sound/effects/crunchybushwhack1.ogg', 'sound/effects/crunchybushwhack2.ogg', 'sound/effects/crunchybushwhack3.ogg')
			if(SFX_TREE_CHOP)
				soundin = pick('sound/effects/treechop1.ogg', 'sound/effects/treechop2.ogg', 'sound/effects/treechop3.ogg')
			if(SFX_ROCK_TAP)
				soundin = pick('sound/effects/rocktap1.ogg', 'sound/effects/rocktap2.ogg', 'sound/effects/rocktap3.ogg')
			if(SFX_BREAK_BONE)
				soundin= pick('sound/effects/bonebreak1.ogg','sound/effects/bonebreak2.ogg','sound/effects/bonebreak3.ogg','sound/effects/bonebreak4.ogg')
			if(SFX_PAINT)
				soundin= pick('sound/effects/paint_1.ogg','sound/effects/paint_2.ogg','sound/effects/paint_3.ogg')
			if(SFX_BLOCK_BIG_METAL)
				soundin = pick('sound/weapons/block/metal_block_01.ogg','sound/weapons/block/metal_block_02.ogg','sound/weapons/block/metal_block_03.ogg','sound/weapons/block/metal_block_04.ogg','sound/weapons/block/metal_block_05.ogg','sound/weapons/block/metal_block_06.ogg')
			if(SFX_KEYBOARD)
				soundin = pick('goon/sounds/keyboard1.ogg','goon/sounds/keyboard2.ogg','goon/sounds/keyboard3.ogg')
	return soundin
