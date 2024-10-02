/obj/structure/flock/egg
	icon_state = "egg"
	name = "glowing doodad"
	desc = "Some sort of small machine. It looks like its getting ready for something."
	flock_desc = "Will soon hatch into a Flockdrone."

	anchored = FALSE
	density = FALSE

	max_integrity = 30

	flock_id = "Second-Stage Assembler"
	build_time = 6 SECONDS


/obj/structure/flock/egg/finish_building()
	. = ..()

	spawn_mobs()
	qdel(src)

/obj/structure/flock/egg/proc/spawn_mobs()
	new /mob/living/simple_animal/flock/drone(get_turf(src), flock)

/obj/structure/flock/egg/bit
	flock_id = "Secondary Second-Stage Assembler"
	flock_desc = "Will soon hatch into Flockbits."

/obj/structure/flock/egg/bit/spawn_mobs()
	for(var/i in 1 to 3)
		new /mob/living/simple_animal/flock/bit(get_turf(src), flock)
