//Fallout 13 super mutants directory

/mob/living/simple_animal/hostile/supermutant
	name = "super mutant"
	desc = "A huge and ugly mutant humanoid."
	icon = 'modular_fallout/master_files/icons/fallout/mobs/hostile/supermutants.dmi'
	icon_state = "hulk_113_s"
	icon_living = "hulk_113_s"
	icon_dead = "hulk_113_s"
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID
	speak_chance = 10
	speak = list("GRRRRRR!", "ARGH!", "NNNNNGH!", "HMPH!", "ARRRRR!")
	speak_emote = list("shouts", "yells")
	move_to_delay = 5
	stat_attack = UNCONSCIOUS
	robust_searching = 1
	environment_smash = ENVIRONMENT_SMASH_WALLS
	emote_taunt_sound = list('modular_fallout/master_files/sound/mobs/supermutant/attack1.ogg', 'modular_fallout/master_files/sound/mobs/supermutant/attack2.ogg', 'modular_fallout/master_files/sound/mobs/supermutant/attack3.ogg')
	emote_taunt = list("yells")
	taunt_chance = 30
	turns_per_move = 5
	response_help_simple = "touches"
	response_disarm_simple = "pushes"
	response_harm_simple = "hits"
	maxHealth = 300
	health = 300
	force_threshold = 15
	faction = list("hostile", "supermutant")
	melee_damage_lower = 45
	melee_damage_upper = 55
	mob_size = MOB_SIZE_LARGE
	move_resist = MOVE_FORCE_OVERPOWERING
	attack_verb_simple = "smashes"
	attack_sound = "punch"
	idlesound = list('modular_fallout/master_files/sound/mobs/supermutant/idle1.ogg', 'modular_fallout/master_files/sound/mobs/supermutant/idle2.ogg', 'modular_fallout/master_files/sound/mobs/supermutant/idle3.ogg', 'modular_fallout/master_files/sound/mobs/supermutant/idle4.ogg' )
	death_sound = list('modular_fallout/master_files/sound/mobs/supermutant/death1.ogg', 'modular_fallout/master_files/sound/mobs/supermutant/death2.ogg')
	aggrosound = list('modular_fallout/master_files/sound/mobs/supermutant/alert1.ogg', 'modular_fallout/master_files/sound/mobs/supermutant/alert2.ogg', 'modular_fallout/master_files/sound/mobs/supermutant/alert3.ogg', 'modular_fallout/master_files/sound/mobs/supermutant/alert4.ogg')

/mob/living/simple_animal/hostile/supermutant/playable
	health = 500
	maxHealth = 500
	emote_taunt_sound = null
	emote_taunt = null
	aggrosound = null
	idlesound = null
	see_in_dark = 8
	wander = 0
	anchored = FALSE
	dextrous = TRUE

/mob/living/simple_animal/hostile/supermutant/Aggro()
	..()
	summon_backup(15)

/mob/living/simple_animal/hostile/supermutant/bullet_act(obj/projectile/Proj)
	if(!Proj)
		return
	if(prob(85) || Proj.damage > 26)
		return ..()
	else
		visible_message("<span class='danger'>\The [Proj] is deflected harmlessly by \the [src]'s thick skin!</span>")
		return FALSE

/mob/living/simple_animal/hostile/supermutant/death(gibbed)
	icon_state = icon_dead
	anchored = FALSE
	..()

/mob/living/simple_animal/pet/dog/mutant    //This is a supermutant, totally not a dog, and he is friendly
	name = "Brah-Min"
	desc = "A large, docile supermutant. Adopted by Kebab-town as a sort of watch dog for their brahmin herd."
	icon = 'modular_fallout/master_files/icons/fallout/mobs/hostile/supermutants.dmi'
	icon_state = "hulk_brahmin_s"
	icon_dead = "hulk_brahmin_s"
	maxHealth = 300
	health = 300
	speak_chance = 7 //30 //Oh my god he never shuts up.
	move_resist = MOVE_FORCE_OVERPOWERING
	mob_size = MOB_SIZE_LARGE
	speak = list("Hey! These my brahmins!", "And I say, HEY-YEY-AAEYAAA-EYAEYAA! HEY-YEY-AAEYAAA-EYAEYAA! I SAID HEY, what's going on?", "What do you want from my brahmins?!", "Me gonna clean brahmin poop again now!", "I love brahmins, brahmins are good, just poop much!", "Do not speak to my brahmins ever again, you hear?!", "Bad raiders come to steal my brahmins - I crush with shovel!", "Do not come to my brahmins! Do not touch my brahmins! Do not look at my brahmins!", "I'm watching you, and my brahmins watch too!", "Brahmins say moo, and I'm saying - hey, get your ugly face out of my way!", "I... I remember, before the fire... THERE WERE NO BRAHMINS!", "No! No wind brahmin here! Wind brahmin lie!")
	speak_emote = list("shouts", "yells")
	emote_hear = list("yawns", "mumbles","sighs")
	emote_see = list("raises his shovel", "shovels some dirt away", "waves his shovel above his head angrily")
	response_help_simple  = "touches"
	response_disarm_simple = "pushes"
	response_harm_simple   = "punches"
//	butcher_results = list(/obj/item/weapon/reagent_containers/food/snacks/bearsteak = 3)

/mob/living/simple_animal/pet/dog/mutant/death(gibbed)
	icon_state = icon_dead
	anchored = FALSE
	if(!gibbed)
		visible_message("<span class='danger'>\the [src] shouts something incoherent about brahmins for the last time and stops moving...</span>")
	..()

/mob/living/simple_animal/hostile/supermutant/meleemutant
	desc = "A huge and ugly mutant humanoid.  This one is brandishing a sledgehammer."
	icon = 'modular_fallout/master_files/icons/fallout/mobs/hostile/supermutants.dmi'
	icon_state = "hulk_melee_s"
	icon_living = "hulk_melee_s"
	icon_dead = "hulk_melee_s"
	maxHealth = 350
	health = 350
	force_threshold = 15
	melee_damage_lower = 45
	melee_damage_upper = 65
	attack_sound = "hit_swing"

/mob/living/simple_animal/hostile/supermutant/meleemutant/death(gibbed)
	icon_state = icon_dead
	anchored = FALSE
	..()

/mob/living/simple_animal/hostile/supermutant/rangedmutant
	desc = "A huge and ugly mutant humanoid.  This one is armed with a poorly maintained hunting rifle."
	icon = 'modular_fallout/master_files/icons/fallout/mobs/hostile/supermutants.dmi'
	icon_state = "hulk_ranged_s"
	icon_living = "hulk_ranged_s"
	icon_dead = "hulk_ranged_s"
	ranged = 1
	maxHealth = 400
	health = 400
	retreat_distance = 4
	minimum_distance = 6
	projectiletype = /obj/projectile/bullet/a762/sport/simple
	projectilesound = 'modular_fallout/master_files/sound/f13weapons/hunting_rifle.ogg'
	loot = list(/obj/item/ammo_box/a308)

/mob/living/simple_animal/hostile/supermutant/rangedmutant/death(gibbed)
	icon_state = icon_dead
	anchored = FALSE
	..()

/mob/living/simple_animal/hostile/supermutant/legendary
	name = "legendary super mutant"
	desc = "A huge and ugly mutant humanoid.He has a faint yellow glow to him, scars adorn his body. This super mutant is a grizzled vetern of combat. Look out!"
	color = "#FFFF00"
	icon_state = "hulk_113_s"
	icon_living = "hulk_113_s"
	icon_dead = "hulk_113_s"
	melee_damage_lower = 55
	melee_damage_upper = 70
	maxHealth = 950
	health = 950
	mob_size = 5

/mob/living/simple_animal/hostile/supermutant/legendary/death(gibbed)
	icon_state = icon_dead
	anchored = FALSE
	..()

/mob/living/simple_animal/hostile/supermutant/nightkin
	name = "nightkin"
	desc = "A blue variant of the standard Super Mutant, equiped with steathboys."
	icon = 'modular_fallout/master_files/icons/fallout/mobs/hostile/supermutants.dmi'
	icon_state = "night_s"
	icon_living = "night_s"
	icon_dead = "night_s"
	maxHealth = 350
	health = 350
	alpha = 80
	force_threshold = 15
	melee_damage_lower = 45
	melee_damage_upper = 70
	attack_verb_simple = "slashes"
	attack_sound = "sound/weapons/bladeslice.ogg"

/mob/living/simple_animal/hostile/supermutant/nightkin/Aggro()
	..()
	summon_backup(15)
	alpha = 255

/mob/living/simple_animal/hostile/supermutant/nightkin/death(gibbed)
	icon_state = icon_dead
	anchored = FALSE
	..()

/mob/living/simple_animal/hostile/supermutant/nightkin/rangedmutant
	name = "nightkin veteran"
	desc = "A blue variant of the standard Super Mutant, equiped with steathboys.  This one is holding an Assault Rifle."
	icon = 'modular_fallout/master_files/icons/fallout/mobs/hostile/supermutants.dmi'
	icon_state = "night_ranged_s"
	icon_living = "night_ranged_s"
	icon_dead = "night_ranged_s"
	maxHealth = 400
	health = 400
	ranged = 1
	alpha = 80
	force_threshold = 15
	melee_damage_lower = 45
	melee_damage_upper = 55
	attack_verb_simple = "smashes"
	attack_sound = "punch"
	extra_projectiles = 1
	retreat_distance = 4
	minimum_distance = 6
	projectiletype = /obj/projectile/bullet/a556/simple
	projectilesound = 'modular_fallout/master_files/sound/f13weapons/assaultrifle_fire.ogg'
	loot = list(/obj/item/ammo_box/magazine/m556/rifle)

/mob/living/simple_animal/hostile/supermutant/nightkin/rangedmutant/Aggro()
	..()
	summon_backup(15)
	alpha = 255

/mob/living/simple_animal/hostile/supermutant/nightkin/rangedmutant/death(gibbed)
	icon_state = icon_dead
	anchored = FALSE
	..()

/mob/living/simple_animal/hostile/supermutant/nightkin/elitemutant
	name = "nightkin elite"
	desc = "A blue variant of the standard Super Mutant, and a remnant of the Masters Army."
	icon = 'modular_fallout/master_files/icons/fallout/mobs/hostile/supermutants.dmi'
	icon_state = "night_boss_s"
	icon_living = "night_boss_s"
	icon_dead = "night_boss_s"
	ranged = 1
	maxHealth = 500
	health = 500
	alpha = 80
	force_threshold = 15
	melee_damage_lower = 45
	melee_damage_upper = 55
	attack_verb_simple = "smashes"
	attack_sound = "punch"
	retreat_distance = 5
	minimum_distance = 7
	projectiletype = /obj/projectile/f13plasma/repeater
	projectilesound = 'modular_fallout/master_files/sound/f13weapons/plasma_rifle.ogg'
	loot = list(/obj/item/stock_parts/cell/ammo/mfc)

/mob/living/simple_animal/hostile/supermutant/nightkin/elitemutant/Aggro()
	..()
	summon_backup(15)
	alpha = 255

/mob/living/simple_animal/hostile/supermutant/nightkin/elitemutant/death(gibbed)
	icon_state = icon_dead
	anchored = FALSE
	..()

//Cult Of Rain
/mob/living/simple_animal/hostile/supermutant/meleemutant/rain
	name = "super mutant rain cultist"
	desc = "A super mutant covered in blue markings that has been indoctrinated into the Cult Of Rain. This one wields a sledgehammer blessed by the rain gods."
	color = "#6B87C0"
	speak_chance = 10
	speak = list("The rain cleanses!", "Sacrifices for the rain gods!", "The thunder guides my fury!", "I am become the storm, destroyer of all heretics!", "The priests will be pleased with my sacrifices!")
	maxHealth = 450
	health = 450
	damage_coeff = list(BRUTE = 0.5, BURN = 1, TOX = 0, CLONE = 0, STAMINA = 0, OXY = 0)
	melee_damage_lower = 50
	melee_damage_upper = 70

/mob/living/simple_animal/hostile/supermutant/rangedmutant/rain
	name = "super mutant rain cultist"
	desc = "A super mutant covered in blue markings that has been indoctrinated into the Cult Of Rain. This one wields a hunting rifle blessed by the rain gods."
	color = "#6B87C0"
	speak_chance = 10
	speak = list("The rain cleanses!", "Sacrifices for the rain gods!", "The thunder guides my fury!", "I am become the storm, destroyer of all heretics!", "The priests will be pleased with my sacrifices!")
	maxHealth = 450
	health = 450
	damage_coeff = list(BRUTE = 1, BURN = 0.5, TOX = 0, CLONE = 0, STAMINA = 0, OXY = 0)
	melee_damage_lower = 50
	melee_damage_upper = 70

/mob/living/simple_animal/hostile/supermutant/nightkin/rain
	name = "nightkin berserker rain priest"
	desc = "A nightkin that spreads the word of the Cult Of Rain. They are covered in dark blue markings, indicating that they have been blessed by the rain god Odile."
	color = "#6666FF"
	speak_chance = 10
	speak = list("The rain speaks through me!", "Witness the gifts of rain!", "The great flood will come upon us! Do not fear it!", "My life for the rain gods!", "The rain gods can always use more sacrifices!")
	maxHealth = 450
	health = 450
	damage_coeff = list(BRUTE = -0.1, BURN = 1, TOX = 0, CLONE = 0, STAMINA = 0, OXY = 0)
	melee_damage_lower = 60
	melee_damage_upper = 70
	var/charging = FALSE

/mob/living/simple_animal/hostile/supermutant/nightkin/rain/bullet_act(obj/projectile/Proj)
	if(!Proj)
		return
	if(prob(30))
		visible_message(span_danger("\The [src] lets out a vicious war cry!"))
		addtimer(3)
		Charge()
	if(prob(85) || Proj.damage > 30)
		return ..()
	else
		visible_message(span_danger("\The [Proj] is abosrbed by \the [src]'s thick skin, strengthening it!"))
		return 0

/mob/living/simple_animal/hostile/supermutant/nightkin/rain/do_attack_animation(atom/A, visual_effect_icon, obj/item/used_item, no_effect)
	if(!charging)
		..()

/mob/living/simple_animal/hostile/supermutant/nightkin/rain/AttackingTarget()
	if(!charging)
		return ..()

/mob/living/simple_animal/hostile/supermutant/nightkin/rain/Goto(target, delay, minimum_distance)
	if(!charging)
		..()

/mob/living/simple_animal/hostile/supermutant/nightkin/rain/Move()
	if(charging)
		new /obj/effect/temp_visual/decoy/fading(loc,src)
		DestroySurroundings()
	. = ..()
	if(charging)
		DestroySurroundings()

/mob/living/simple_animal/hostile/supermutant/nightkin/rain/proc/Charge()
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
	addtimer(3)
	throw_at(T, get_dist(src, T), 1, src, 0, callback = CALLBACK(src, .proc/charge_end))

/mob/living/simple_animal/hostile/supermutant/nightkin/rain/proc/charge_end(list/effects_to_destroy)
	charging = FALSE
	if(target)
		Goto(target, move_to_delay, minimum_distance)

/mob/living/simple_animal/hostile/supermutant/nightkin/rain/Bump(atom/A)
	if(charging)
		if(isturf(A) || isobj(A) && A.density)
			A.ex_act(EXPLODE_HEAVY)
		DestroySurroundings()
	..()

/mob/living/simple_animal/hostile/supermutant/nightkin/rain/throw_impact(atom/A)
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


/mob/living/simple_animal/hostile/supermutant/nightkin/rangedmutant/rain
	name = "nightkin guardian rain priest"
	desc = "A nightkin that spreads the word of the Cult Of Rain. They are covered in dark blue markings, indicating that they have been blessed by the rain god Ignacio."
	color = "#6666FF"
	speak_chance = 10
	speak = list("The rain speaks through me!", "Witness the gifts of rain!", "The great flood will come upon us! Do not fear it!", "My life for the rain gods!", "The rain gods can always use more sacrifices!")
	maxHealth = 450
	health = 450
	damage_coeff = list(BRUTE = 1, BURN = -0.25, TOX = 0, CLONE = 0, STAMINA = 0, OXY = 0)
	melee_damage_lower = 60
	melee_damage_upper = 70
	extra_projectiles = 2
	retreat_distance = 2
	minimum_distance = 4

/mob/living/simple_animal/hostile/supermutant/nightkin/rangedmutant/rain/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/glow_heal, chosen_targets = /mob/living/simple_animal/hostile/supermutant, allow_revival = FALSE, restrict_faction = null, type_healing = BRUTELOSS | FIRELOSS)

/mob/living/simple_animal/hostile/supermutant/nightkin/rangedmutant/rain/bullet_act(obj/projectile/Proj)
	if(!Proj)
		return
	if(prob(20))
		visible_message(span_danger("\The [src] lets out a vicious war cry!"))
		fire_release()
	if(prob(85) || Proj.damage > 30)
		return ..()
	else
		visible_message(span_danger("\The [Proj] is absorbed by \the [src]'s thick skin, strengthening it!"))
		return 0

/mob/living/simple_animal/hostile/supermutant/nightkin/rangedmutant/rain/proc/fire_release()
	playsound(get_turf(src),'sound/magic/fireball.ogg', 200, 1)

	for(var/d in GLOB.cardinals)
		INVOKE_ASYNC(src, .proc/fire_release_wall, d)

/mob/living/simple_animal/hostile/supermutant/nightkin/rangedmutant/rain/proc/fire_release_wall(dir)
	var/list/hit_things = list(src)
	var/turf/E = get_edge_target_turf(src, dir)
	var/range = 10
	var/turf/previousturf = get_turf(src)
	for(var/turf/J in getline(src,E))
		if(!range || (J != previousturf && (!previousturf.atmos_adjacent_turfs || !previousturf.atmos_adjacent_turfs[J])))
			break
		range--
		new /obj/effect/hotspot(J)
		J.hotspot_expose(500, 500, 1)
		for(var/mob/living/L in J.contents - hit_things)
			if(istype(L, /mob/living/simple_animal/hostile/supermutant/nightkin/rangedmutant/rain))
				continue
			L.adjustFireLoss(20)
			to_chat(L, "<span class='userdanger'>You're hit by the nightkin's release of energy!</span>")
			hit_things += L
		previousturf = J
		addtimer(1)

/mob/living/simple_animal/hostile/supermutant/nightkin/elitemutant/rain
	name = "nightkin rain lord"
	desc = "A nightkin that writes the word of the Cult Of Rain. They are covered in dark blue markings and are adorned in pieces of bone armor, indicating that they are blessed by the rain god Hyacinth."
	color = "#6666FF"
	speak_chance = 10
	speak = list("The great flood will come, I will make sure of it!", "Rain god Odile, I call upon you for wrath!", "Rain god Hyacinth, I call upon you for a tranquil mind!", "Rain god Ignacio, I call upon you for protection!", "The storm rages within!")
	maxHealth = 550
	health = 550
	damage_coeff = list(BRUTE = 0.5, BURN = 0.5, TOX = 0, CLONE = 0, STAMINA = 0, OXY = 0)
	melee_damage_lower = 60
	melee_damage_upper = 70
	extra_projectiles = 1

/mob/living/simple_animal/hostile/supermutant/nightkin/elitemutant/rain/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/glow_heal, chosen_targets = /mob/living/simple_animal/hostile/supermutant, allow_revival = TRUE, restrict_faction = null, type_healing = BRUTELOSS | FIRELOSS)
