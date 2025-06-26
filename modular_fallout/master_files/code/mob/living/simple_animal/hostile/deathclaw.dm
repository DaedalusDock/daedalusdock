/*IN THIS FILE:
-Deathclaws
*/

//Base Deathclaw
/mob/living/simple_animal/hostile/deathclaw
	name = "deathclaw"
	desc = "A massive, reptilian creature with powerful muscles, razor-sharp claws, and aggression to match."
	icon = 'modular_fallout/master_files/icons/fallout/mobs/hostile/mutants/deathclaw.dmi'
	icon_state = "deathclaw"
	icon_living = "deathclaw"
	icon_dead = "deathclaw_dead"
	icon_gib = "deathclaw_gib"
	gender = MALE
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	robust_searching = TRUE
	speak = list("ROAR!","Rawr!","GRRAAGH!","Growl!")
	speak_emote = list("growls", "roars")
	emote_hear = list("grumbles.","grawls.")
	emote_taunt = list("stares ferociously", "stomps")
	speak_chance = 10
	taunt_chance = 25
	move_to_delay = -1
	see_in_dark = 8
	decompose = FALSE
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/deathclaw = 4,
							/obj/item/stack/sheet/animalhide/deathclaw = 2,
							/obj/item/stack/sheet/bone = 4)
	response_help_simple  = "pets"
	response_disarm_simple = "gently pushes aside"
	response_harm_simple   = "hits"
	maxHealth = 750
	health = 750
	obj_damage = 200
	armor_penetration = 70
	melee_damage_lower = 80
	melee_damage_upper = 85
	attack_verb_simple = "claws"
	attack_sound = 'modular_fallout/master_files/sound/weapons/bladeslice.ogg'
	faction = list("deathclaw")
	gold_core_spawnable = HOSTILE_SPAWN
	var/charging = FALSE
	sharpness = SHARP_EDGED
	move_resist = MOVE_FORCE_OVERPOWERING

	emote_taunt_sound = list('modular_fallout/master_files/sound/mobs/deathclaw/taunt.ogg')
	aggrosound = list('modular_fallout/master_files/sound/mobs/deathclaw/aggro1.ogg', 'modular_fallout/master_files/sound/mobs/deathclaw/aggro2.ogg', )
	idlesound = list('modular_fallout/master_files/sound/mobs/deathclaw/idle.ogg',)
	death_sound = 'modular_fallout/master_files/sound/mobs/deathclaw/death.ogg'

/mob/living/simple_animal/hostile/deathclaw/playable
	emote_taunt_sound = null
	emote_taunt = null
	aggrosound = null
	idlesound = null
	see_in_dark = 8
	environment_smash = 2 //can smash walls
	wander = 0

// Mother death claw
/mob/living/simple_animal/hostile/deathclaw/mother
	name = "mother deathclaw"
	desc = "A massive, reptilian creature with powerful muscles, razor-sharp claws, and aggression to match. This one is an angry mother."
	gender = FEMALE
	maxHealth = 1000
	health = 1000
	stat_attack = UNCONSCIOUS
	melee_damage_lower = 76
	melee_damage_upper = 78
	armor_penetration = 0.75
	color = rgb(95,104,94)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/deathclaw = 6,
							/obj/item/stack/sheet/animalhide/deathclaw = 3)

//Legendary Deathclaw
/mob/living/simple_animal/hostile/deathclaw/legendary
	name = "legendary deathclaw"
	desc = "A massive, reptilian creature with powerful muscles, razor-sharp claws, and aggression to match. This one is a legendary enemy."
	maxHealth = 1500
	health = 1500
	color = "#FFFF00"
	stat_attack = UNCONSCIOUS
	melee_damage_lower = 80
	melee_damage_upper = 85
	armor_penetration = 0.85

/mob/living/simple_animal/hostile/deathclaw/legendary/death(gibbed)
	var/turf/T = get_turf(src)
	if(prob(60))
		new /obj/item/melee/unarmed/deathclawgauntlet(T)
	. = ..()

/mob/living/simple_animal/hostile/deathclaw/bullet_act(obj/projectile/Proj)
	if(!Proj)
		return
	if(prob(10))
		visible_message(span_danger("\The [src] growls, enraged!"))

		addtimer(CALLBACK(src, .proc/Charge), 3)
	if(prob(85) || Proj.damage > 30) //prob(x) = chance for proj to actually do something, adjust depending on how OP you want deathclaws to be
		return ..()
	else
		visible_message(span_danger("\The [Proj] bounces off \the [src]'s thick hide!"))
		return 0

/mob/living/simple_animal/hostile/deathclaw/do_attack_animation(atom/A, visual_effect_icon, obj/item/used_item, no_effect)
	if(!charging)
		..()

/mob/living/simple_animal/hostile/deathclaw/AttackingTarget()
	if(!charging)
		return ..()

/mob/living/simple_animal/hostile/deathclaw/Goto(target, delay, minimum_distance)
	if(!charging)
		..()

/mob/living/simple_animal/hostile/deathclaw/Move()
	if(charging)
		new /obj/effect/temp_visual/decoy/fading(loc,src)
		DestroySurroundings()
	. = ..()
	if(charging)
		DestroySurroundings()

/mob/living/simple_animal/hostile/deathclaw/proc/Charge()
	var/turf/T = get_turf(target)
	if(!T || T == loc)
		return
	charging = TRUE
	visible_message(span_danger(">[src] charges!"))
	DestroySurroundings()
	walk(src, 0)
	setDir(get_dir(src, T))
	var/obj/effect/temp_visual/decoy/D = new /obj/effect/temp_visual/decoy(loc,src)
	animate(D, alpha = 0, color = "#FF0000", transform = matrix()*2, time = 1)
	throw_at(T, get_dist(src, T), 1, src, 0, callback = CALLBACK(src, .proc/charge_end))

/mob/living/simple_animal/hostile/deathclaw/proc/charge_end(list/effects_to_destroy)
	charging = FALSE
	if(target)
		Goto(target, move_to_delay, minimum_distance)

/mob/living/simple_animal/hostile/deathclaw/Bump(atom/A)
	if(charging)
		if(isturf(A) || isobj(A) && A.density)
			A.ex_act(EXPLODE_HEAVY)
		DestroySurroundings()
	..()

/mob/living/simple_animal/hostile/deathclaw/throw_impact(atom/A)
	if(!charging)
		return ..()

	else if(isliving(A))
		var/mob/living/L = A
		L.visible_message(span_danger("[src] slams into [L]!"), span_userdanger("[src] slams into you!"))
		L.apply_damage(melee_damage_lower/2, BRUTE)
		playsound(get_turf(L), 'sound/effects/meteorimpact.ogg', 100, 1)
		shake_camera(L, 4, 3)
		shake_camera(src, 2, 3)
		var/throwtarget = get_edge_target_turf(src, get_dir(src, get_step_away(L, src)))
		L.throw_at(throwtarget, 3)


	charging = FALSE
	charging = FALSE
