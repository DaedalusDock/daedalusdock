/* IN THIS FILE
-Ghouls
*/

//Base Ghoul
/mob/living/simple_animal/hostile/ghoul
	name = "feral ghoul"
	desc = "A ghoul that has lost its mind and become aggressive."
	icon = 'modular_fallout/master_files/icons/fallout/mobs/hostile/wastemobs.dmi'
	icon_state = "feralghoul"
	icon_living = "feralghoul"
	icon_dead = "feralghoul_dead"
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID
	robust_searching = 1
	turns_per_move = 5
	speak_emote = list("growls")
	emote_see = list("screeches")
	maxHealth = 60
	health = 60
	move_to_delay = 3
	harm_intent_damage = 8
	melee_damage_lower = 15
	melee_damage_upper = 15
	attack_verb_simple = "claw"
	attack_sound = 'sound/hallucinations/growl1.ogg'
	atmos_requirements = list("min_oxy" = 5, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 1, "min_co2" = 0, "max_co2" = 5, "min_n2" = 0, "max_n2" = 0)
	unsuitable_atmos_damage = 20
	gold_core_spawnable = HOSTILE_SPAWN
	faction = list("hostile")
	decompose = TRUE
	sharpness = SHARP_EDGED //They need to cut their finger nails
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/human/ghoul = 2,
							/obj/item/stack/sheet/animalhide/human = 1,
							/obj/item/stack/sheet/bone = 1)

	emote_taunt_sound = list('modular_fallout/master_files/sound/mobs/ghoul/taunt.ogg')
	emote_taunt = list("gurgles", "stares")
	taunt_chance = 30
	aggrosound = list('modular_fallout/master_files/sound/mobs/ghoul/aggro1.ogg', 'modular_fallout/master_files/sound/mobs/ghoul/aggro2.ogg')
	idlesound = list('modular_fallout/master_files/sound/mobs/ghoul/idle.ogg')
	death_sound = 'modular_fallout/master_files/sound/mobs/ghoul/ghoul_death.ogg'

// Ghoul Reaver
/mob/living/simple_animal/hostile/ghoul/reaver
	name = "feral ghoul reaver"
	desc = "A ghoul that has lost its mind and become aggressive. This one is strapped with metal armor, and appears far stronger."
	icon = 'modular_fallout/master_files/icons/fallout/mobs/hostile/wastemobs.dmi'
	icon_state = "ghoulreaver"
	icon_living = "ghoulreaver"
	icon_dead = "ghoulreaver_dead"
	move_to_delay = 2
	maxHealth = 120
	health = 120
	harm_intent_damage = 8
	melee_damage_lower = 25
	melee_damage_upper = 25

/mob/living/simple_animal/hostile/ghoul/reaver/Initialize()
	. = ..()

/mob/living/simple_animal/hostile/ghoul/reaver/Aggro()
	..()
	summon_backup(10)

//Cold Feral Ghoul
/mob/living/simple_animal/hostile/ghoul/coldferal
	name = "cold ghoul feral"
	desc = "A ghoul that has lost its mind and become aggressive. This one is strapped with metal armor, and appears far stronger."
	icon = 'modular_fallout/master_files/icons/fallout/mobs/hostile/wastemobs.dmi'
	icon_state = "cold_feral"
	icon_living = "cold_feral"
	icon_dead = "cold_feral_dead"
	move_to_delay = 1.5
	maxHealth = 200
	health = 200
	harm_intent_damage = 8
	melee_damage_lower = 15
	melee_damage_upper = 15

//Frozen Feral Ghoul
/mob/living/simple_animal/hostile/ghoul/frozenreaver
	name = "frozen ghoul reaver"
	desc = "A ghoul that has lost its mind and become aggressive. This one is strapped with metal armor, and appears far stronger."
	icon = 'modular_fallout/master_files/icons/fallout/mobs/hostile/wastemobs.dmi'
	icon_state = "frozen_reaver"
	icon_living = "frozen_reaver"
	icon_dead = "frozen_reaver_dead"
	move_to_delay = 1.5
	maxHealth = 200
	health = 200
	harm_intent_damage = 8
	melee_damage_lower = 15
	melee_damage_upper = 15

//Legendary Ghoul
/mob/living/simple_animal/hostile/ghoul/legendary
	name = "legendary ghoul"
	desc = "A ghoul that has lost its mind and become aggressive. This one has exceptionally large, bulging muscles. It looks quite strong."
	icon_state = "glowinghoul"
	icon_living = "glowinghoul"
	icon_dead = "glowinghoul_dead"
	color = "#FFFF00"
	maxHealth = 600
	health = 600
	move_to_delay = 2.5
	harm_intent_damage = 8
	melee_damage_lower = 30
	melee_damage_upper = 35
	mob_size = 5

//Glowing Ghoul
/mob/living/simple_animal/hostile/ghoul/glowing
	name = "glowing feral ghoul"
	desc = "A feral ghoul that has absorbed massive amounts of radiation, causing them to glow in the dark and radiate constantly."
	icon_state = "glowinghoul"
	icon_living = "glowinghoul"
	icon_dead = "glowinghoul_dead"
	maxHealth = 100
	health = 100
	move_to_delay = 2
	harm_intent_damage = 8
	melee_damage_lower = 25
	melee_damage_upper = 25
	light_system = OVERLAY_LIGHT
	light_outer_range  = 2

/mob/living/simple_animal/hostile/ghoul/glowing/Initialize(mapload)
	. = ..()
	// we only heal BRUTELOSS because each type directly heals a simplemob's health
	// therefore setting it to BRUTELOSS | FIRELOSS | TOXLOSS | OXYLOSS would mean healing 4x as much
	// aka 40% of max life every tick, which is basically unkillable
	// TODO: refactor this if simple_animals ever get damage types
	AddComponent(/datum/component/glow_heal, chosen_targets = /mob/living/simple_animal/hostile/ghoul, allow_revival = FALSE, restrict_faction = null, type_healing = BRUTELOSS)

/mob/living/simple_animal/hostile/ghoul/glowing/Aggro()
	..()
	summon_backup(10)

#warn fix ghoul radiation
/*
/mob/living/simple_animal/hostile/ghoul/glowing/AttackingTarget()
	. = ..()
	if(. && ishuman(target))
		var/mob/living/carbon/human/H = target
		H.apply_effect(20, EFFECT_IRRADIATE, 0)
*/
/mob/living/simple_animal/hostile/ghoul/glowing/strong // FEV mutation
	maxHealth = 320
	health = 320
	move_to_delay = 1.4 // Nyooom
	melee_damage_lower = 35
	melee_damage_upper = 35
	armor_penetration = 10

//Alive Ghoul
/mob/living/simple_animal/hostile/ghoul/soldier
	name = "ghoul soldier"
	desc = "Have you ever seen a living ghoul before?<br>Ghouls are necrotic post-humans - decrepit, rotting, zombie-like mutants."
	icon = 'modular_fallout/master_files/icons/fallout/mobs/hostile/wastemobs.dmi'
	icon_state = "soldier_ghoul"
	icon_living = "soldier_ghoul"
	icon_dead = "soldier_ghoul_d"
	icon_gib = "syndicate_gib"
	maxHealth = 90
	health = 90

//Alive Ghoul
/mob/living/simple_animal/hostile/ghoul/soldier/armored
	name = "armored ghoul soldier"
	desc = "Have you ever seen a living ghoul before?<br>Ghouls are necrotic post-humans - decrepit, rotting, zombie-like mutants."
	icon = 'modular_fallout/master_files/icons/fallout/mobs/hostile/wastemobs.dmi'
	icon_state = "soldier_ghoul_a"
	icon_living = "soldier_ghoul_a"
	icon_dead = "soldier_ghoul_a_d"
	icon_gib = "syndicate_gib"
	maxHealth = 100
	health = 100

//Alive Ghoul
/mob/living/simple_animal/hostile/ghoul/scorched
	name = "scorched ghoul soldier"
	desc = "Have you ever seen a living ghoul before?<br>Ghouls are necrotic post-humans - decrepit, rotting, zombie-like mutants."
	icon = 'modular_fallout/master_files/icons/fallout/mobs/hostile/wastemobs.dmi'
	icon_state = "scorched_m"
	icon_living = "scorched_m"
	icon_dead = "scorched_m_d"
	icon_gib = "syndicate_gib"
	speak_chance = 1
	environment_smash = 0
	response_help_simple = "hugs"
	response_disarm_simple = "pushes aside"
	response_harm_simple = "growl"
	move_to_delay = 4
	faction = list("scorched", "hostile")
	death_sound = null
	melee_damage_upper = 20
	aggro_vision_range = 10
	attack_verb_simple = "punches"
	attack_sound = "punch"

//Alive Ghoul Ranged
/mob/living/simple_animal/hostile/ghoul/scorched/ranged
	name = "Ranged Ghoul Solder"
	desc = "Have you ever seen a living ghoul before?<br>Ghouls are necrotic post-humans - decrepit, rotting, zombie-like mutants."
	icon = 'modular_fallout/master_files/icons/fallout/mobs/hostile/wastemobs.dmi'
	icon_state = "scorched_r"
	icon_living = "scorched_r"
	icon_dead = "scorched_r_d"
	icon_gib = "syndicate_gib"
	speak_chance = 1
	turns_per_move = 5
	environment_smash = 0
	response_help_simple = "hugs"
	response_disarm_simple = "pushes aside"
	response_harm_simple = "ow"
	move_to_delay = 4
	ranged = TRUE
	ranged_cooldown_time = 200
	projectiletype = /obj/projectile/bullet/c9mm/simple
	projectilesound = 'modular_fallout/master_files/sound/f13weapons/hunting_rifle.ogg'
	faction = list("scorched", "hostile")
	melee_damage_lower = 15
	melee_damage_upper = 20
	aggro_vision_range = 10
	attack_verb_simple = "shoots"
	attack_sound = "punch"

/mob/living/simple_animal/hostile/ghoul/wyomingghost
	name = "ghost soldier"
	desc = "A figure clad in armor that stands silent except for the slight wheezing coming from them, a dark orange and black liquid pumps through a clear tube into the gas mask. The armor they wear seems to be sealed to their skin."
	icon = 'modular_fallout/master_files/icons/fallout/mobs/hostile/wastemobs.dmi'
	icon_state = "wyomingghost"
	icon_living = "wyomingghost"
	icon_dead = "wyomingghost_dead"
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID
	robust_searching = 1
	turns_per_move = 5
	speak_emote = list("wheezes")
	emote_see = list("stares")
	maxHealth = 150
	health = 150
	move_to_delay = 2
	harm_intent_damage = 8
	melee_damage_lower = 15
	melee_damage_upper = 15
	attack_verb_simple = "attacks"
	attack_sound = 'sound/hallucinations/growl1.ogg'
	atmos_requirements = list("min_oxy" = 5, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 1, "min_co2" = 0, "max_co2" = 5, "min_n2" = 0, "max_n2" = 0)
	unsuitable_atmos_damage = 20
	gold_core_spawnable = HOSTILE_SPAWN
	faction = list("supermutant","ghoul")
	decompose = FALSE
	sharpness = SHARP_EDGED //They need to cut their finger nails

//Halloween Event Ghouls
/mob/living/simple_animal/hostile/ghoul/zombie
	name = "ravenous feral ghoul"
	desc = "A ferocious feral ghoul, hungry for human meat."
	faction = list("ghoul")
	stat_attack = UNCONSCIOUS
	maxHealth = 200
	health = 200

/mob/living/simple_animal/hostile/ghoul/zombie/AttackingTarget()
	. = ..()
	if(. && ishuman(target))
		var/mob/living/carbon/human/H = target
		try_to_ghoul_zombie_infect(H)

/mob/living/simple_animal/hostile/ghoul/zombie/reaver
	name = "ravenous feral ghoul reaver"
	desc = "A ferocious feral ghoul, hungry for human meat. This one is strapped with metal armor, and appears far stronger."
	icon = 'modular_fallout/master_files/icons/fallout/mobs/hostile/wastemobs.dmi'
	icon_state = "ghoulreaver"
	icon_living = "ghoulreaver"
	icon_dead = "ghoulreaver_dead"
	move_to_delay = 2
	maxHealth = 270
	health = 270
	harm_intent_damage = 8
	melee_damage_lower = 30
	melee_damage_upper = 30

/mob/living/simple_animal/hostile/ghoul/zombie/glowing
	name = "ravenous glowing feral ghoul"
	desc = "A ferocious feral ghoul, hungry for human meat. This one has absorbed massive amounts of radiation, causing them to glow in the dark and radiate constantly."
	icon_state = "glowinghoul"
	icon_living = "glowinghoul"
	icon_dead = "glowinghoul_dead"
	maxHealth = 240
	health = 240
	move_to_delay = 2
	harm_intent_damage = 8
	melee_damage_lower = 30
	melee_damage_upper = 30
	light_system = OVERLAY_LIGHT
	light_outer_range  = 2

/mob/living/simple_animal/hostile/ghoul/zombie/glowing/Initialize(mapload)
	. = ..()
	// we only heal BRUTELOSS because each type directly heals a simplemob's health
	// therefore setting it to BRUTELOSS | FIRELOSS | TOXLOSS | OXYLOSS would mean healing 4x as much
	// aka 40% of max life every tick, which is basically unkillable
	// TODO: refactor this if simple_animals ever get damage types
	AddComponent(/datum/component/glow_heal, chosen_targets = /mob/living/simple_animal/hostile/ghoul, allow_revival = FALSE, restrict_faction = null, type_healing = BRUTELOSS)

/mob/living/simple_animal/hostile/ghoul/zombie/glowing/Aggro()
	..()
	summon_backup(10)

/mob/living/simple_animal/hostile/ghoul/zombie/legendary
	name = "legendary ravenous ghoul"
	desc = "A ferocious feral ghoul, hungry for human meat. This one has exceptionally large, bulging muscles. It looks quite strong."
	icon_state = "glowinghoul"
	icon_living = "glowinghoul"
	icon_dead = "glowinghoul_dead"
	color = "#FFFF00"
	maxHealth = 650
	health = 650
	move_to_delay = 2.5
	harm_intent_damage = 8
	melee_damage_lower = 30
	melee_damage_upper = 35
	mob_size = 5
