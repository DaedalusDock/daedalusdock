/*IN THIS FILE:
-Handy
-Gutsy
-Protectrons
-Robobrains
-Assaultrons
*/

/mob/living/simple_animal/hostile/handy
	name = "mr. handy"
	desc = "A crazed pre-war household assistant robot, armed with a cutting saw."
	icon = 'modular_fallout/master_files/icons/fallout/mobs/robots.dmi'
	icon_state = "handy"
	icon_living = "handy"
	icon_dead = "gib7"
	gender = NEUTER
	mob_biotypes = MOB_ROBOTIC
	move_resist = MOVE_FORCE_OVERPOWERING // Can't be pulled
	health = 160
	maxHealth = 160
	healable = FALSE
	stat_attack = UNCONSCIOUS
	melee_damage_lower = 28
	melee_damage_upper = 28
	robust_searching = TRUE
	attack_verb_simple = "saws"
	faction = list("wastebot")
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	speak_emote = list("states")
	gold_core_spawnable = HOSTILE_SPAWN
	del_on_death = TRUE
	deathmessage = "blows apart!"
	taunt_chance = 30
	blood_volume = 0

	emote_taunt_sound = list('modular_fallout/master_files/sound/mobs/handy/taunt1.ogg', 'modular_fallout/master_files/sound/mobs/handy/taunt2.ogg')
	emote_taunt = list("raises a saw")

	aggrosound = list('modular_fallout/master_files/sound/mobs/handy/aggro1.ogg', 'modular_fallout/master_files/sound/mobs/handy/aggro2.ogg')
	idlesound = list('modular_fallout/master_files/sound/mobs/handy/idle1.wav', 'modular_fallout/master_files/sound/mobs/handy/idle2.ogg', 'modular_fallout/master_files/sound/mobs/handy/idle3.ogg')

	death_sound = 'modular_fallout/master_files/sound/mobs/handy/robo_death.ogg'
	attack_sound = 'modular_fallout/master_files/sound/mobs/handy/attack.wav'

	damage_coeff = list(BRUTE = 1, BURN = 1, TOX = 0, CLONE = 0, STAMINA = 0, OXY = 0)
	loot = list(/obj/effect/decal/cleanable/robot_debris, /obj/item/stack/crafting/electronicparts/three)

/mob/living/simple_animal/hostile/handy/playable
	health = 300
	maxHealth = 300
	attack_verb_simple = "shoots a burst of flame at"
	emote_taunt_sound = null
	emote_taunt = null
	aggrosound = null
	idlesound = null
	see_in_dark = 8
	wander = FALSE
	force_threshold = 10
	anchored = FALSE
	del_on_death = FALSE
	dextrous = TRUE
	ranged = FALSE

/mob/living/simple_animal/hostile/handy/Initialize()
	. = ..()
	add_overlay("eyes-[initial(icon_state)]")

/mob/living/simple_animal/hostile/handy/nsb //NSB + Raider Bunker specific
	name = "mr.handy"
	aggro_vision_range = 15
	faction = list("raider")
	obj_damage = 300

/mob/living/simple_animal/hostile/handy/gutsy
	name = "mr. gutsy"
	desc = "A pre-war combat robot based off the Mr. Handy design, armed with plasma weaponry and a deadly close-range flamer."
	icon_state = "gutsy"
	icon_living = "gutsy"
	icon_dead = "gib7"
	health = 200
	maxHealth = 200
	melee_damage_lower = 72
	melee_damage_upper = 72
	attack_sound = 'sound/items/welder.ogg'
	attack_verb_simple = "shoots a burst of flame at"
	projectilesound = 'modular_fallout/master_files/sound/weapons/laser.ogg'
	projectiletype = /obj/projectile/f13plasma/scatter
	extra_projectiles = 2
	ranged = TRUE
	retreat_distance = 2
	minimum_distance = 2
	check_friendly_fire = TRUE
	loot = list(/obj/effect/decal/cleanable/robot_debris, /obj/item/stack/crafting/electronicparts/three, /obj/item/stock_parts/cell/ammo/mfc)

	emote_taunt_sound = list('modular_fallout/master_files/sound/mobs/gutsy/taunt1.ogg', 'modular_fallout/master_files/sound/mobs/gutsy/taunt2.ogg', 'modular_fallout/master_files/sound/mobs/gutsy/taunt3.ogg', 'modular_fallout/master_files/sound/mobs/gutsy/taunt4.ogg')
	emote_taunt = list("raises a flamer")

	aggrosound = list('modular_fallout/master_files/sound/mobs/gutsy/aggro1.ogg', 'modular_fallout/master_files/sound/mobs/gutsy/aggro2.ogg', 'modular_fallout/master_files/sound/mobs/gutsy/aggro3.ogg', 'modular_fallout/master_files/sound/mobs/gutsy/aggro4.ogg', 'modular_fallout/master_files/sound/mobs/gutsy/aggro5.ogg', 'modular_fallout/master_files/sound/mobs/gutsy/aggro6.ogg')
	idlesound = list('modular_fallout/master_files/sound/mobs/gutsy/idle1.ogg', 'modular_fallout/master_files/sound/mobs/gutsy/idle2.ogg', 'modular_fallout/master_files/sound/mobs/gutsy/idle3.ogg')

/mob/living/simple_animal/hostile/handy/gutsy/playable
	health = 340
	maxHealth = 340
	move_to_delay = 1
	attack_verb_simple = "shoots a burst of flame at"
	emote_taunt_sound = null
	emote_taunt = null
	aggrosound = null
	idlesound = null
	see_in_dark = 8
	environment_smash = 2 //can break lockers, but not walls
	wander = FALSE
	force_threshold = 10
	anchored = FALSE
	del_on_death = FALSE
	dextrous = TRUE
	ranged = FALSE

/mob/living/simple_animal/hostile/handy/gutsy/nsb //NSB + Raider Bunker specific
	name = "mr. gutsy"
	aggro_vision_range = 15
	faction = list("raider")
	obj_damage = 300

/mob/living/simple_animal/hostile/handy/liberator
	name = "liberator"
	desc = "A small pre-War droned used by the People's Liberation Army."
	icon_state = "liberator"
	icon_living = "leberator"
	icon_dead = "liberator_d"
	icon_gib = "liberator_g"
	health = 80
	maxHealth = 80
	melee_damage_lower = 5
	melee_damage_upper = 10
	attack_verb_simple = "slaps"
	attack_sound = 'modular_fallout/master_files/sound/weapons/punch1.ogg'
	projectilesound = 'modular_fallout/master_files/sound/weapons/laser.ogg'
	projectiletype = /obj/projectile/beam/laser/pistol
	extra_projectiles = 1
	ranged = TRUE
	retreat_distance = 2
	minimum_distance = 2
	check_friendly_fire = TRUE
	loot = list(/obj/effect/decal/cleanable/robot_debris, /obj/item/stack/crafting/electronicparts/three, /obj/item/stock_parts/cell/ammo/mfc)
	emote_taunt_sound = null
	emote_taunt = list("levels its laser")
	aggrosound = null
	idlesound = null
	death_sound = null
	attack_sound = null

/mob/living/simple_animal/hostile/handy/liberator/yellow
	name = "liberator"
	desc = "A small pre-War droned used by the People's Liberation Army."
	icon_state = "liberator_y"
	icon_living = "leberator_y"
	icon_dead = "liberator_y_d"

/mob/living/simple_animal/hostile/handy/robobrain
	name = "robobrain"
	desc = "A next-gen cybor developed by General Atomic International"
	icon_state = "robobrain"
	icon_living = "robobrain"
	icon_dead = "robobrain_d"
	health = 200
	maxHealth = 200
	melee_damage_lower = 30
	melee_damage_upper = 45
	attack_verb_simple = "slaps"
	attack_sound = 'modular_fallout/master_files/sound/weapons/punch1.ogg'
	projectilesound = 'modular_fallout/master_files/sound/weapons/laser.ogg'
	projectiletype = /obj/projectile/beam/laser
	extra_projectiles = 1
	ranged = TRUE
	retreat_distance = 2
	minimum_distance = 2
	check_friendly_fire = TRUE
	loot = list(/obj/effect/decal/cleanable/robot_debris, /obj/item/stack/crafting/electronicparts/three, /obj/item/stock_parts/cell/ammo/mfc)
	emote_taunt_sound = null
	emote_taunt = list("levels its laser")
	aggrosound = null
	idlesound = null
	death_sound = null
	attack_sound = null

/mob/living/simple_animal/hostile/handy/robobrain/AttackingTarget()
	. = ..()

/mob/living/simple_animal/hostile/handy/robobrain/nsb //NSB + Raider Bunker specific
	name = "robobrain"
	aggro_vision_range = 15
	faction = list("raider")
	obj_damage = 300
	health = 300
	maxHealth = 300

/mob/living/simple_animal/hostile/handy/protectron
	name = "protectron"
	desc = "A pre-war security robot armed with deadly lasers."
	icon_state = "protectron"
	icon_living = "protectron"
	icon_dead = "protectron_dead"
	health = 130
	maxHealth = 130
	move_to_delay = 4
	melee_damage_lower = 5 //severely reduced melee damage here because its silly to have a ranged mob also be a cqc master
	melee_damage_upper = 10
	extra_projectiles = 0 //removed extra projectiles to make these easier to deal with on super lowpop
	stat_attack = CONSCIOUS
	ranged = TRUE
	retreat_distance = 2
	minimum_distance = 2
	attack_verb_simple = "slaps"
	attack_sound = 'modular_fallout/master_files/sound/weapons/punch1.ogg'
	projectilesound = 'modular_fallout/master_files/sound/weapons/laser.ogg'
	projectiletype = /obj/projectile/beam/laser/pistol
	faction = list("wastebot")
	check_friendly_fire = TRUE
	loot = list(/obj/effect/decal/cleanable/robot_debris, /obj/item/stack/crafting/electronicparts/five)

	emote_taunt_sound = list('modular_fallout/master_files/sound/mobs/protectron/taunt1.ogg', 'modular_fallout/master_files/sound/mobs/protectron/taunt2.ogg', 'modular_fallout/master_files/sound/mobs/protectron/taunt3.ogg')
	emote_taunt = list("raises a laser")

	aggrosound = list('modular_fallout/master_files/sound/mobs/protectron/aggro1.ogg', 'modular_fallout/master_files/sound/mobs/protectron/aggro2.ogg', 'modular_fallout/master_files/sound/mobs/protectron/aggro3.ogg', 'modular_fallout/master_files/sound/mobs/protectron/aggro4.ogg')
	idlesound = list('modular_fallout/master_files/sound/mobs/protectron/idle1.ogg', 'modular_fallout/master_files/sound/mobs/protectron/idle2.ogg', 'modular_fallout/master_files/sound/mobs/protectron/idle3.ogg', 'modular_fallout/master_files/sound/mobs/protectron/idle4.ogg',)

/mob/living/simple_animal/hostile/handy/protectron/playable
	ranged = FALSE
	melee_damage_lower = 35
	melee_damage_upper = 45
	health = 400
	maxHealth = 400
	move_to_delay = 2
	attack_verb_simple = "clamps"
	emote_taunt_sound = null
	emote_taunt = null
	aggrosound = null
	idlesound = null
	see_in_dark = 8
	environment_smash = 1 //can break lockers, but not walls
	wander = FALSE
	force_threshold = 10
	anchored = FALSE
	del_on_death = FALSE

/mob/living/simple_animal/hostile/handy/protectron/nsb //NSB + Raider Bunker specific
	name = "protectron"
	aggro_vision_range = 15
	faction = list("raider")
	obj_damage = 300

/mob/living/simple_animal/pet/dog/protectron //Not an actual dog
	name = "Trading Protectron"
	desc = "A standard RobCo RX2 V1.16.4 \"Trade-o-Vend\", loaded with Trade protocols.<br>Looks like it was kept operational for an indefinite period of time. Its body is covered in cracks and dents of various sizes.<br>As it has been repaired countless times, it's amazing the machine is still functioning at all."
	icon = 'modular_fallout/master_files/icons/fallout/mobs/hostile/animal.dmi'
	icon_state = "protectron"
	icon_living = "protectron"
	icon_dead = "protectron_d"
	maxHealth = 200
	health = 200
	speak_chance = 5
	mob_biotypes = MOB_ROBOTIC
	faction = list("neutral", "silicon", "dog", "hostile", "pirate", "wastebot", "wolf", "plants", "turret", "enclave", "ghoul", "cazador", "supermutant", "gecko", "slime", "radscorpion", "skeleton", "carp", "bs", "bighorner")
	speak = list("Howdy partner! How about you spend some of them there hard earned caps on some of this fine merchandise.", "Welcome back partner! Hoo-wee it's a good day to buy some personal protection!", "Stop, this is a robbery! At these prices you are robbing me.", "Legion? NCR? Raider? Hell we don't care, as long as you got the caps.", "What a fine day partner. A fine day indeed.", "Reminds me of what my grandpappy used to say, make a snap decision now and never question it. You look like you could use some product there partner.", "Lotta critters out there want to chew you up partner, you could use a little hand with that now couldn't you?")
	speak_emote = list()
	emote_hear = list()
	emote_see = list()
	response_help_simple  = "shakes its manipulator"
	response_disarm_simple = "pushes"
	response_harm_simple   = "punches"
	attack_sound = 'modular_fallout/master_files/sound/voice/liveagain.ogg'
	butcher_results = list(/obj/effect/gibspawner/robot = 1)
	blood_volume = 0

/mob/living/simple_animal/hostile/handy/assaultron
	name = "assaultron"
	desc = "A deadly close combat robot developed by RobCo in a vaguely feminine, yet ominous chassis."
	icon_state = "assaultron"
	icon_living = "assaultron"
	gender = FEMALE //Pffffffffffffffffffffff
	icon_dead = "gib7"
	health = 450
	mob_biotypes = MOB_ROBOTIC
	maxHealth = 450
	move_to_delay = 0
	melee_damage_lower = 55
	melee_damage_upper = 60
	environment_smash = 2 //can smash walls
	attack_verb_simple = "grinds their claws on"
	faction = list("wastebot")
	loot = list(/obj/effect/decal/cleanable/robot_debris, /obj/item/stack/crafting/electronicparts/three, /obj/item/stock_parts/cell/ammo/mfc)

	emote_taunt_sound = FALSE
	emote_taunt = FALSE

	aggrosound = FALSE
	idlesound = FALSE

/mob/living/simple_animal/hostile/handy/assaultron/nsb //NSB + Raider Bunker specific.
	name = "assaultron"
	aggro_vision_range = 15
	faction = list("raider")
	obj_damage = 300

/mob/living/simple_animal/hostile/handy/assaultron/playable
	see_in_dark = 8
	force_threshold = 15
	wander = 0
	anchored = FALSE
	del_on_death = FALSE
	dextrous = TRUE

//Junkers
/mob/living/simple_animal/hostile/handy/gutsy/flamer
	name = "Mr. Burnsy"
	desc = "A modified mr. gutsy, equipped with a more precise flamer, ditching it's plasma weaponry."
	color = "#B85C00"
	projectilesound = 'sound/magic/fireball.ogg'
	projectiletype = modular_fallout/code/modules/projectiles/projectile/bullet/shotgun/incendiary
	extra_projectiles = 1

/mob/living/simple_animal/hostile/handy/assaultron/laser
	name = "red eye assaultron"
	desc = "A modified assaultron. It's eye has been outfitted with a deadly laser."
	color = "#B85C00"
	ranged = TRUE
	retreat_distance = null
	minimum_distance = 1
	projectilesound = 'modular_fallout/master_files/sound/weapons/laser.ogg'
	projectiletype = /obj/projectile/beam/laser/lasgun
