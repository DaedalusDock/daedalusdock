/obj/structure/flock/egg
	icon = 'icons/misc/featherzone.dmi'
	icon_state = "egg"
	name = "glowing doodad"
	desc = "Some sort of small machine. It looks like its getting ready for something."

	anchored = FALSE
	density = FALSE

	max_integrity = 30

	flock_id = "Second-Stage Assembler"
	build_time = 6 SECONDS


/obj/structure/flock/egg/finish_building()
	. = ..()

	spawn_mobs()

/obj/structure/flock/egg/proc/spawn_mobs()
	new /mob/living/simple_animal/flock/drone(get_turf(src), flock)


/obj/structure/flock/egg
	flock_id = "Secondary Second-Stage Assembler"

/obj/structure/flock/egg/spawn_mobs()
	for(var/i in 1 to 3)
		new /mob/living/simple_animal/flock/bit(get_turf(src), flock)
