//Fallout 13 eyebot directory

/mob/living/simple_animal/hostile/eyebot
	name = "eyebot"
	desc = "A hovering, propaganda-spewing reconnaissance and surveillance robot with radio antennas pointing out its back and loudspeakers blaring out the front."
	icon = 'modular_fallout/master_files/icons/fallout/mobs/hostile/animal.dmi'
	icon_state = "eyebot"
	icon_living = "eyebot"
	icon_dead = "eyebot_d"
	icon_gib = "eyebot_d"
	speak_chance = 0
	turns_per_move = 6
	environment_smash = 0
	response_help_simple = "touches"
	response_disarm_simple = "shoves"
	response_harm_simple = "hits"
	move_to_delay = 3
	stat_attack = 1
	robust_searching = 1
	maxHealth = 70
	health = 70
	healable = 0
	mob_biotypes = MOB_ROBOTIC
	blood_volume = 0

	faction = list("hostile", "enclave", "wastebot", "ghoul", "cazador", "supermutant", "bighorner")

	harm_intent_damage = 8
	melee_damage_lower = 2
	melee_damage_upper = 3
	minimum_distance = 6
	retreat_distance = 14
	attack_verb_simple = "punches"
	attack_sound = "punch"
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	unsuitable_atmos_damage = 15
	status_flags = CANPUSH
	vision_range = 7 //reduced from 13 to 7 because who needs that kind of shit in their life
	aggro_vision_range = 7 //as above
	ranged = 1
	projectiletype = /obj/projectile/beam/laser/lasgun
	projectilesound = 'modular_fallout/master_files/sound/weapons/resonator_fire.ogg'

	aggrosound = list('modular_fallout/master_files/sound/mobs/eyebot/aggro.ogg', )
	idlesound = list('modular_fallout/master_files/sound/mobs/eyebot/idle1.ogg', 'modular_fallout/master_files/sound/mobs/eyebot/idle2.ogg')
	death_sound = 'modular_fallout/master_files/sound/mobs/eyebot/robo_death.ogg'
	speak_emote = list("states")

/mob/living/simple_animal/hostile/eyebot/New()
	..()
	name = "ED-[rand(1,99)]"

/mob/living/simple_animal/hostile/eyebot/playable
	ranged = FALSE
	health = 200
	maxHealth = 200
	attack_verb_simple = "zaps"
	emote_taunt_sound = null
	emote_taunt = null
	aggrosound = null
	idlesound = null
	see_in_dark = 8
	wander = 0
	anchored = FALSE
	del_on_death = FALSE
	dextrous = TRUE
	move_to_delay = -1

/mob/living/simple_animal/hostile/eyebot/floatingeye
	name = "floating eyebot"
	desc = "A quick-observation robot commonly found in pre-War military installations.<br>The floating eyebot uses a powerful taser to keep intruders in line."
	icon_state = "floatingeye"
	icon_living = "floatingeye"
	icon_dead = "floatingeye_d"
	icon_gib = "floatingeye_d"

	retreat_distance = 4
	faction = list("hostile", "bs")

	projectiletype = /obj/projectile/energy/electrode
	projectilesound = 'modular_fallout/master_files/sound/weapons/resonator_blast.ogg'

/mob/living/simple_animal/hostile/eyebot/floatingeye/New()
	..()
	name = "FEB-[rand(1,99)]"

/mob/living/simple_animal/pet/dog/eyebot //It's a propaganda eyebot, not a dog, but...
	name = "propaganda eyebot"
	desc = "This eyebot's weapons module has been removed and replaced with a loudspeaker. It appears to be shouting Pre-War propaganda."
	icon = 'modular_fallout/master_files/icons/fallout/mobs/hostile/animal.dmi'
	icon_state = "eyebot"
	icon_living = "eyebot"
	icon_dead = "eyebot_d"
	icon_gib = "eyebot_d"
	maxHealth = 60
	health = 60
	speak_chance = 8
	gender = NEUTER
	mob_biotypes = MOB_ROBOTIC
	faction = list("hostile", "enclave", "wastebot", "ghoul", "cazador", "supermutant", "bighorner")
	speak = list("America will never fall to communist invasion.", "Democracy is truth. Communism is death.", "Communism is the very definition of failure!", "Freedom is always worth fighting for.", "Memorial site recognized. Patriotism subroutines engaged. Honoring the fallen is the duty of every red blooded American.", "Cultural database accessed. Quoting New England poet Robert Frost: 'Freedom lies in being bold.'", "Defending Life, Liberty, and the pursuit of Happiness.")
	speak_emote = list("states")
	emote_hear = list()
	emote_see = list()
	response_help_simple  = "shakes the radio of"
	response_disarm_simple = "pushes"
	response_harm_simple   = "punches"
	attack_sound = 'modular_fallout/master_files/sound/voice/liveagain.ogg'
	butcher_results = list(/obj/effect/gibspawner/robot = 1)
	blood_volume = 0

/mob/living/simple_animal/pet/dog/eyebot/playable
	health = 200
	maxHealth = 200
	attack_verb_simple = "zaps"
	aggrosound = null
	speak_chance = 0
	idlesound = null
	see_in_dark = 8
	wander = 0
	force_threshold = 10
	anchored = FALSE
	del_on_death = FALSE
	dextrous = TRUE

//Junkers
/mob/living/simple_animal/hostile/eyebot/reinforced
	name = "reinforced eyebot"
	desc = "An eyebot with beefier protection, and extra electronic aggression."
	color = "#B85C00"
	maxHealth = 150
	health = 150
	faction = list("raider", "wastebot")
	extra_projectiles = 1
	melee_damage_lower = 20
	melee_damage_upper = 30
	minimum_distance = 4
	retreat_distance = 6
