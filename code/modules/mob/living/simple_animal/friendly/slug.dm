/mob/living/simple_animal/slug
	name = "maintenance slug"
	desc = "Gigantomilax Robusticus, also known as the Maintenance Slug for their habit of occupying the dark tunnels of space stations. Their slime is known to be a good disinfectant and cleaning fluid."
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
	speed = 10
	density = FALSE
	pass_flags = PASSTABLE | PASSGRILLE | PASSMOB
	mob_size = MOB_SIZE_TINY
	gold_core_spawnable = FRIENDLY_SPAWN

/mob/living/simple_animal/slug/Initialize(mapload)
	AddComponent(/datum/component/udder, /obj/item/udder/slug, null, null, /datum/reagent/slug_slime)
	. = ..()

/mob/living/simple_animal/slug/glubby
	name = "Glubby"
	desc = "He's just misunderstood."
	gold_core_spawnable = NO_SPAWN
