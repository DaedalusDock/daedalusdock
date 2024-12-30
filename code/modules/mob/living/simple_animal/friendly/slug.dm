/mob/living/simple_animal/slug
	name = "maintenance slug"
	desc = "Gigantomilax Robusticus, also known as the 'Maintenance Slug' for their habit of occupying the dark tunnels of space stations. Their slime is known to be a good disinfectant and cleaning fluid."
	icon_state = "slug"
	icon_living = "slug"
	icon_dead = "slug_dead"
	turns_per_move = 5
	response_help_continuous = "gently pats"
	response_help_simple = "gently pat"
	response_disarm_continuous = "nudges"
	response_disarm_simple = "nudge"
	response_harm_continuous = "splats"
	response_harm_simple = "splat"
	maxHealth = 5
	health = 5
	move_delay_modifier = 1 SECOND
	density = FALSE
	pass_flags = PASSTABLE | PASSGRILLE | PASSMOB
	mob_size = MOB_SIZE_TINY
	mob_biotypes = MOB_ORGANIC
	gold_core_spawnable = FRIENDLY_SPAWN
	var/udder = /obj/item/udder/slug

/mob/living/simple_animal/slug/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/udder, udder, null, null, /datum/reagent/slug_slime)

//cargo's badass loose-cannon pet slug who doesn't play by the rules
/mob/living/simple_animal/slug/glubby
	name = "Glubby"
	desc = "He's just misunderstood."
	icon_state = "glubby"
	icon_living = "glubby"
	icon_dead = "glubby_dead"
	gold_core_spawnable = NO_SPAWN
