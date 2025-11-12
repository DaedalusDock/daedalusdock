/datum/job/flock
	title = ROLE_FLOCK
	spawn_type = /mob/camera/flock
	spawn_logic = JOBSPAWN_FORCE_FIXED

/datum/job/flock/get_roundstart_spawn_point_fixed()
	return pick_safe(GLOB.blobstart)

/datum/job/flock/overmind
	title = ROLE_FLOCK
	spawn_type = /mob/camera/flock/overmind
	spawn_logic = JOBSPAWN_FORCE_FIXED
