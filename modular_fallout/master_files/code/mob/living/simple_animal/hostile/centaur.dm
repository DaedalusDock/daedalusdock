/mob/living/simple_animal/hostile/centaur
	name = "Centaur"
	desc = "The result of infection by FEV gone horribly wrong."
	icon = 'modular_fallout/master_files/icons/fallout/mobs/hostile/mutants/monsters.dmi'
	icon_state = "centaur"
	icon_living = "centaur"
	icon_dead = "centaur_d"
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID
	robust_searching = 1
	turns_per_move = 5
	speak_emote = list("growls")
	emote_see = list("screeches")
	maxHealth = 100
	health = 100
	move_to_delay = 2
	harm_intent_damage = 8
	melee_damage_lower = 15
	melee_damage_upper = 15
	ranged = 1
	retreat_distance = 5
	minimum_distance = 5
	attack_verb_simple = "whipped"
	attack_sound = 'sound/hallucinations/growl1.ogg'
	atmos_requirements = list("min_oxy" = 5, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 1, "min_co2" = 0, "max_co2" = 5, "min_n2" = 0, "max_n2" = 0)
	unsuitable_atmos_damage = 20
	robust_searching = 0
	stat_attack = UNCONSCIOUS
	gold_core_spawnable = HOSTILE_SPAWN
	faction = list("hostile", "supermutant")
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/human/centaur = 3,
							/obj/item/stack/sheet/animalhide/human = 2,
							/obj/item/stack/sheet/bone = 2)
	projectiletype = /obj/projectile/neurotox
	projectilesound = 'modular_fallout/master_files/sound/mobs/centaur/spit.ogg'

	emote_taunt_sound = list('modular_fallout/master_files/sound/mobs/centaur/taunt.ogg')
	emote_taunt = list("grunts")
	taunt_chance = 30
	aggrosound = list('modular_fallout/master_files/sound/mobs/centaur/aggro1.ogg', )
	idlesound = list('modular_fallout/master_files/sound/mobs/centaur/idle1.ogg', 'modular_fallout/master_files/sound/mobs/centaur/idle2.ogg')
	death_sound = 'modular_fallout/master_files/sound/mobs/centaur/centaur_death.ogg'
	attack_sound = 'modular_fallout/master_files/sound/mobs/centaur/lash.ogg'

/obj/projectile/neurotox
	name = "spit"
	damage = 30
	icon_state = "toxin"

/mob/living/simple_animal/hostile/centaur/strong // Mostly for FEV mutation
	maxHealth = 400
	health = 400
	melee_damage_lower = 35
	melee_damage_upper = 35
	armor_penetration = 10
