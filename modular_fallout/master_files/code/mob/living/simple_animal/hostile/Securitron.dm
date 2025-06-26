/* IN THIS FILE:
-Securitron
-Sentry Bot
*/

//Securitron
/mob/living/simple_animal/hostile/securitron
	name = "securitron"
	desc = "A pre-War type of securitron.<br>Extremely dangerous machine."
	icon = 'modular_fallout/master_files/icons/fallout/mobs/hostile/robots.dmi'
	icon_state = "Securitron"
	icon_living = "Securitron"
	icon_dead = "gib7"
	icon_gib = "Securitron_d"
	speak_chance = 1
	turns_per_move = 5
	environment_smash = 0
	response_help_simple = "pokes"
	response_disarm_simple = "shoves"
	response_harm_simple = "hits"
	move_to_delay = 5
	stat_attack = CONSCIOUS
	robust_searching = TRUE
	maxHealth = 150
	health = 150
	blood_volume = 0
	del_on_death = TRUE
	healable = FALSE
	faction = list("wastebot")
	mob_biotypes = MOB_ROBOTIC
	emote_hear = list("Beeps.")
	speak = list("Stop Right There Criminal.")
	harm_intent_damage = 8
	melee_damage_lower = 5
	melee_damage_upper = 10
	minimum_distance = 1
	retreat_distance = 4
	extra_projectiles = 2
	attack_verb_simple = "punches"
	attack_sound = "punch"
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	vision_range = 12
	aggro_vision_range = 15
	projectiletype = /obj/projectile/bullet/c9mm/simple
	projectilesound = 'modular_fallout/master_files/sound/f13weapons/varmint_rifle.ogg'
	emote_taunt = list("readies its arm gun")
	check_friendly_fire = TRUE
	ranged = TRUE
	move_resist = MOVE_FORCE_OVERPOWERING

/mob/living/simple_animal/hostile/securitron/nsb //NSB + Raider Bunker specific
	name = "Securitron"
	aggro_vision_range = 15
	faction = list("raider")
	obj_damage = 300
	retreat_distance = 0 //perish, mortal

/mob/living/simple_animal/hostile/securitron/bullet_act(obj/projectile/Proj)
	if(!Proj)
		CRASH("[src] securitron invoked bullet_act() without a projectile")
	if(prob(5) && health > 1)
		visible_message(span_danger("\The [src] releases a defensive flashbang!"))
		var/flashbang_turf = get_turf(src)
		if(!flashbang_turf)
			return
		var/obj/item/grenade/flashbang/S = new /obj/item/grenade/flashbang(flashbang_turf)
		S.preprime(user = null)
	if(prob(75) || Proj.damage > 26) //prob(x) = chance for proj to actually do something, adjust depending on how OP you want sentrybots to be
		return ..()
	else
		visible_message(span_danger("\The [Proj] bounces off \the [src]'s armor plating!"))
		return FALSE

/mob/living/simple_animal/hostile/securitron/proc/do_death_beep()
	playsound(src, 'sound/machines/triple_beep.ogg', 75, TRUE)
	visible_message(span_warning("You hear an ominous beep coming from [src]!"), span_warning("You hear an ominous beep!"))

/mob/living/simple_animal/hostile/securitron/proc/self_destruct()
	explosion(src,1,2,4,4)

/mob/living/simple_animal/hostile/securitron/death()
	do_sparks(3, TRUE, src)
	for(var/i in 1 to 3)
		addtimer(CALLBACK(src, .proc/do_death_beep), i * 1 SECONDS)
	addtimer(CALLBACK(src, .proc/self_destruct), 4 SECONDS)
	return ..()

/mob/living/simple_animal/hostile/securitron/Aggro()
	. = ..()
	summon_backup(15)

//Sentry Bot
/mob/living/simple_animal/hostile/securitron/sentrybot
	name = "sentry bot"
	desc = "A pre-war military robot armed with a deadly gatling laser and covered in thick armor plating."
	icon_state = "sentrybot"
	icon_living = "sentrybot"
	icon_dead = "sentrybot"
	health = 210
	maxHealth = 210
	del_on_death = FALSE
	melee_damage_lower = 48
	melee_damage_upper = 72
	extra_projectiles = 4 //5 projectiles
	ranged_cooldown_time = 12 //brrrrrrrrrrrrt
	retreat_distance = 2
	minimum_distance = 2
	attack_verb_simple = "pulverizes"
	attack_sound = 'modular_fallout/master_files/sound/weapons/punch1.ogg'
	projectilesound = 'modular_fallout/master_files/sound/weapons/laser.ogg'
	projectiletype = /obj/projectile/beam/laser/pistol/ultraweak
	emote_taunt_sound = list('modular_fallout/master_files/sound/mobs/sentry/taunt1.ogg', 'modular_fallout/master_files/sound/mobs/sentry/taunt2.ogg', 'modular_fallout/master_files/sound/mobs/sentry/taunt3.ogg', 'modular_fallout/master_files/sound/mobs/sentry/taunt4.ogg', 'modular_fallout/master_files/sound/mobs/sentry/taunt5.ogg', 'modular_fallout/master_files/sound/mobs/sentry/taunt6.ogg')
	emote_taunt = list("spins its barrels")
	aggrosound = list('modular_fallout/master_files/sound/mobs/sentry/aggro1.ogg', 'modular_fallout/master_files/sound/mobs/sentry/aggro2.ogg', 'modular_fallout/master_files/sound/mobs/sentry/aggro3.ogg', 'modular_fallout/master_files/sound/mobs/sentry/aggro4.ogg', 'modular_fallout/master_files/sound/mobs/sentry/aggro5.ogg')
	idlesound = list('modular_fallout/master_files/sound/mobs/sentry/idle1.ogg', 'modular_fallout/master_files/sound/mobs/sentry/idle2.ogg', 'modular_fallout/master_files/sound/mobs/sentry/idle3.ogg', 'modular_fallout/master_files/sound/mobs/sentry/idle4.ogg')
	var/warned = FALSE
	loot = list(/obj/effect/decal/cleanable/robot_debris, /obj/item/stack/crafting/electronicparts/five, /obj/item/stock_parts/cell/ammo/mfc)

/mob/living/simple_animal/hostile/securitron/sentrybot/Life()
	..()
	if (!warned)
		if (health <= 50)
			warned = TRUE
			playsound(src, 'modular_fallout/master_files/sound/mobs/sentry/systemfailure.ogg', 75, FALSE)

// Lil chew-chew
/mob/living/simple_animal/hostile/securitron/sentrybot/chew
	name = "lil' chew-chew"
	desc = "An oddly scorched pre-war military robot armed with a deadly gatling laser and covered in thick, oddly blue armor plating, the name Lil' Chew-Chew scratched onto it's front armour crudely, highlighted by small bits of white paint. There seems to be an odd pack on the monstrosity of a sentrie's back, a chute at the bottom of it - there's the most scorch-marks on the robot here, so it's safe to assume this robot is capable of explosions. Better watch out!"
	extra_projectiles = 6
	health = 1000
	maxHealth = 1000 //CHONK
	obj_damage = 300
	retreat_distance = 0
	environment_smash = ENVIRONMENT_SMASH_RWALLS //wall-obliterator. perish.
	color = "#75FFE2"
	aggro_vision_range = 15
	flags_1 = PREVENT_CONTENTS_EXPLOSION_1 //cannot self-harm with it's explosion spam

/mob/living/simple_animal/hostile/securitron/sentrybot/chew/bullet_act(obj/projectile/Proj)
	if(!Proj)
		CRASH("[src] sentrybot invoked bullet_act() without a projectile")
	if(prob(10) && health > 1)
		visible_message(span_danger("\The [src] releases a defensive explosive!"))
		explosion(get_turf(src),-1,-1,2, flame_range = 4) //perish, mortal - explosion size identical to craftable IED
	if(prob(75) || Proj.damage > 30) //prob(x) = chance for proj to actually do something, adjust depending on how OP you want sentrybots to be
		return ..()
	else
		visible_message(span_danger("\The [Proj] bounces off \the [src]'s armor plating!"))
		return FALSE

//Raider friendly Sentry bot
/mob/living/simple_animal/hostile/securitron/sentrybot/nsb
	name = "sentry bot"
	aggro_vision_range = 15
	faction = list("raider")
	obj_damage = 300

//Raider friendly Sentry bot with non-lethals
/mob/living/simple_animal/hostile/securitron/sentrybot/nsb/riot //NSB + Raider Bunker specific.
	name = "riot-control sentry bot"
	desc = "A pre-war military robot armed with a modified breacher shotgun and covered in thick armor plating."
	projectilesound = 'modular_fallout/master_files/sound/f13weapons/riot_shotgun.ogg'
	projectiletype = /obj/projectile/bullet/shotgun_beanbag
	retreat_distance = 0
	environment_smash = 2 //wall-busts

//Playable Sentrybot
/mob/living/simple_animal/hostile/securitron/sentrybot/playable
	health = 750   //El Beef
	maxHealth = 750
	move_to_delay = 1
	attack_verb_simple = "clamps"
	emote_taunt_sound = null
	emote_taunt = null
	aggrosound = null
	idlesound = null
	ranged = FALSE
	see_in_dark = 8
	environment_smash = 2 //can smash walls
	wander = 0
	force_threshold = 15

/mob/living/simple_animal/hostile/securitron/sentrybot/playable/death()
	return ..()

//Junkers
/mob/living/simple_animal/hostile/securitron/sentrybot/suicide
	name = "explosive sentry bot"
	desc = "A pre-war military robot armed with a deadly gatling laser and covered in thick armor plating. Don't get too close to this one, it looks like it's rigged to blow!"
	maxHealth = 200
	health = 200
	color = "#B85C00"
	retreat_distance = null
	minimum_distance = 1

/mob/living/simple_animal/hostile/securitron/sentrybot/suicide/AttackingTarget()
	if(ishuman(target))
		addtimer(CALLBACK(src, .proc/do_death_beep), 1 SECONDS)
		addtimer(CALLBACK(src, .proc/self_destruct), 2 SECONDS)
