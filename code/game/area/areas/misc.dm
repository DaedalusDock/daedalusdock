// Areas that don't fit any of the other files, or only serve one purpose.

/area/space
	icon_state = "space"
	requires_power = TRUE
	always_unpowered = TRUE

	area_lighting = AREA_LIGHTING_STATIC

	power_light = FALSE
	power_equip = FALSE
	power_environ = FALSE
	area_flags = UNIQUE_AREA | NO_ALERTS
	outdoors = TRUE
	ambience_index = AMBIENCE_SPACE
	flags_1 = CAN_BE_DIRTY_1
	sound_environment = SOUND_AREA_SPACE
	ambient_buzz = null

/area/space/nearstation
	icon_state = "space_near"
	area_flags = UNIQUE_AREA | NO_ALERTS | AREA_USES_STARLIGHT

/area/misc/start
	name = "start area"
	icon_state = "start"
	requires_power = FALSE
	area_lighting = AREA_LIGHTING_STATIC
	has_gravity = STANDARD_GRAVITY

/area/misc/testroom
	name = "Test Room"
	icon_state = "test_room"

	requires_power = FALSE
	has_gravity = STANDARD_GRAVITY
	// FUCK YOU NEVER CHANGE MY LIGHTING -kapu1178, 2023
	area_lighting = AREA_LIGHTING_STATIC //The unit test area should always be luminosity = 1
	luminosity = 1
