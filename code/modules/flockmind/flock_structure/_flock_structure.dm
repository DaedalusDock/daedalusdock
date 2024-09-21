/obj/structure/flock
	name = "CALL A CODER AAAAAAAAAA"
	icon = 'goon/icons/mob/featherzone.dmi'
	anchored = TRUE
	density = TRUE

	var/datum/flock/flock

/obj/structure/flock/Initialize(mapload, join_flock)
	. = ..()
	if(join_flock)
		flock = join_flock

/obj/structure/flock/get_flock_id()
	return "the [name]"
