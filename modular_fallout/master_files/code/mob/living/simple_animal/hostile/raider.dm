/*IN THIS FILE:
-All Raider Mobs
*/

//Base Raider Mob
/mob/living/simple_animal/hostile/raider
	name = "Raider"
	desc = "Another murderer churned out by the wastes."
	icon = 'modular_fallout/master_files/icons/fallout/mobs/hostile/wastemobs.dmi'
	icon_state = "raider_melee"
	icon_living = "raider_melee"
	icon_dead = "raider_generic_dead"
	icon_gib = "syndicate_gib"
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID
	turns_per_move = 5
	maxHealth = 140
	health = 140
	melee_damage_lower = 25
	melee_damage_upper = 50
	attack_verb_simple = "punches"
	attack_sound = 'modular_fallout/master_files/sound/weapons/bladeslice.ogg'
	faction = list("raider")
	check_friendly_fire = TRUE
	status_flags = CANPUSH
	del_on_death = FALSE
	loot = list(/obj/item/melee/onehanded/knife/survival)


/datum/outfit/raider
	name = "Raider"
	uniform = /obj/item/clothing/under/f13/rag
	suit = /obj/item/clothing/suit/armor/f13/medium/iconoclast
	shoes = /obj/item/clothing/shoes/f13/explorer
	gloves = /obj/item/clothing/gloves/f13/leather
	head = /obj/item/clothing/head/helmet/f13/firefighter

/obj/effect/mob_spawn/human/corpse/raider
	name = "Raider"
	outfit = /obj/effect/mob_spawn/human/corpse/raider

/mob/living/simple_animal/hostile/raider/Aggro()
	..()
	summon_backup(15)
	say("HURRY, HURRY, HURRY!!!")

// Thief mob
/mob/living/simple_animal/hostile/raider/thief
	desc = "Another murderer churned out by the wastes. This one looks like they have sticky fingers..."

/mob/living/simple_animal/hostile/raider/thief/movement_delay()
	return -2

/mob/living/simple_animal/hostile/raider/thief/AttackingTarget()
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		if(H.stat == UNCONSCIOUS)
			var/back_target = H.back
			if(back_target)
				H.dropItemToGround(back_target, TRUE)
				src.transferItemToLoc(back_target, src, TRUE)
			var/belt_target = H.belt
			if(belt_target)
				H.dropItemToGround(belt_target, TRUE)
				src.transferItemToLoc(belt_target, src, TRUE)
			var/shoe_target = H.shoes
			if(shoe_target)
				H.dropItemToGround(shoe_target, TRUE)
				src.transferItemToLoc(shoe_target, src, TRUE)
			retreat_distance = 50
		else
			. = ..()

/mob/living/simple_animal/hostile/raider/thief/death(gibbed)
	for(var/obj/I in contents)
		src.dropItemToGround(I)
	. = ..()

//Ranged Raider Mob
/mob/living/simple_animal/hostile/raider/ranged
	icon_state = "raider_ranged"
	icon_living = "raider_ranged"
	ranged = TRUE
	maxHealth = 115
	health = 115
	retreat_distance = 4
	minimum_distance = 6
	projectiletype = /obj/projectile/bullet/c9mm/op
	projectilesound = 'modular_fallout/master_files/sound/f13weapons/ninemil.ogg'
	loot = list(/obj/effect/mob_spawn/human/corpse/npc_raider)

/datum/outfit/npc_raider
	name = "NPC Raider"
	uniform = /obj/item/clothing/under/f13/rag
	suit = /obj/item/clothing/suit/armor/f13/medium/iconoclast
	shoes = /obj/item/clothing/shoes/f13/explorer
	gloves = /obj/item/clothing/gloves/f13/leather
	head = /obj/item/clothing/head/helmet/f13/firefighter

/obj/effect/mob_spawn/human/corpse/npc_raider
	name = "Raider"
	outfit = /datum/outfit/npc_raider

//Legendary Melee Raider Mob
/mob/living/simple_animal/hostile/raider/legendary
	name = "Legendary Raider"
	desc = "Another murderer churned out by the wastes - this one seems a bit faster than the average..."
	color = "#FFFF00"
	maxHealth = 450
	health = 450
	move_to_delay = 1.2
	obj_damage = 300
	aggro_vision_range = 15
	loot = list(/obj/item/melee/onehanded/knife/survival, /obj/item/food/kebab/human)

//Legendary Ranged Raider Mob
/mob/living/simple_animal/hostile/raider/ranged/legendary
	name = "Legendary Raider"
	desc = "Another murderer churned out by the wastes, wielding a decent pistol and looking very strong"
	color = "#FFFF00"
	maxHealth = 600
	health = 600
	retreat_distance = 1
	minimum_distance = 2
	projectiletype = /obj/projectile/bullet/m44
	projectilesound = 'modular_fallout/master_files/sound/f13weapons/44mag.ogg'
	extra_projectiles = 1
	aggro_vision_range = 15
	obj_damage = 300
	loot = list(/obj/item/gun/ballistic/revolver/m29)

//Raider Boss Mob
/mob/living/simple_animal/hostile/raider/ranged/boss
	name = "Raider Boss"
	icon_state = "raider_boss"
	icon_living = "raider_boss"
	icon_dead = "raider_boss_dead"
	maxHealth = 170
	health = 170
	extra_projectiles = 3
	projectiletype = /obj/projectile/bullet/c45/op
	loot = list(/obj/item/gun/ballistic/automatic/smg/greasegun, /obj/item/clothing/suit/f13/medium/combat/mk2/dark, /obj/item/clothing/suit/f13/medium/combat/mk2, /obj/item/clothing/under/f13/ravenharness)

/mob/living/simple_animal/hostile/raider/ranged/boss/Aggro()
	..()
	summon_backup(15)
	say("KILL 'EM, FELLAS!")

//Firefighter Mob
/mob/living/simple_animal/hostile/raider/firefighter
	icon_state = "firefighter_raider"
	icon_living = "firefighter_raider"
	icon_dead = "firefighter_raider_dead"
	loot = list(/obj/item/twohanded/fireaxe)

//Biker Raider Mob
/mob/living/simple_animal/hostile/raider/ranged/biker
	icon_state = "biker_raider"
	icon_living = "biker_raider"
	icon_dead = "biker_raider_dead"
	melee_damage_lower = 20
	melee_damage_upper = 20
	maxHealth = 200
	health = 200
	projectiletype = /obj/projectile/bullet/a556/match
	projectilesound = 'modular_fallout/master_files/sound/f13weapons/magnum_fire.ogg'
	casingtype = /obj/item/ammo_casing/a556
	loot = list(/obj/item/gun/ballistic/revolver/thatgun, /obj/item/clothing/suit/f13/medium/combat/rusted, /obj/item/clothing/head/helmet/f13/raidercombathelmet)

/datum/outfit/raider_biker
	uniform = /obj/item/clothing/under/f13/ncrcf
	suit = /obj/item/clothing/suit/f13/medium/combat/rusted
	shoes = /obj/item/clothing/shoes/f13/explorer
	gloves = /obj/item/clothing/gloves/f13/leather/fingerless
	head = /obj/item/clothing/head/helmet/f13/raidercombathelmet
	neck = /obj/item/clothing/neck/mantle/brown

/obj/effect/mob_spawn/human/corpse/raider/ranged/biker
	name = "Raider Biker"
	outfit = /datum/outfit/raider_biker

//Baseball Raider Mob
/mob/living/simple_animal/hostile/raider/baseball
	icon_state = "baseball_raider"
	icon_living = "baseball_raider"
	icon_dead = "baseball_raider_dead"
	retreat_distance = 1
	minimum_distance = 1
	melee_damage_lower = 40
	melee_damage_upper = 40
	maxHealth = 200
	health = 200
	loot = list(/obj/item/twohanded/baseball)


/datum/outfit/raider_mechanic
	uniform = /obj/item/clothing/under/f13/mechanic
	suit = /obj/item/clothing/suit/armor/f13/medium/yankee
	shoes = /obj/item/clothing/shoes/f13/explorer
	gloves = /obj/item/clothing/gloves/f13/leather/fingerless
	head = /obj/item/clothing/head/helmet/f13/raider/yankee

/obj/effect/mob_spawn/human/corpse/raider/baseball
	name = "Raider Mechanic"
	outfit = /datum/outfit/raider_mechanic

//Tribal Raider Mob
/mob/living/simple_animal/hostile/raider/tribal
	icon_state = "tribal_raider"
	icon_living = "tribal_raider"
	icon_dead = "tribal_raider_dead"
	melee_damage_lower = 40
	melee_damage_upper = 40
	loot = list(/obj/item/twohanded/spear)

/datum/outfit/raider_tribal
	uniform = /obj/item/clothing/under/f13/raiderrags
	suit = /obj/item/clothing/suit/armored/light/tribalraider
	shoes = /obj/item/clothing/shoes/f13/rag
	mask = /obj/item/clothing/mask/facewrap
	head = /obj/item/clothing/head/helmet/f13/fiend

/obj/effect/mob_spawn/human/corpse/raider/tribal
	name = "Raider Tribal"
	outfit = /datum/outfit/raider_tribal

//Sulphite Brawler Mob
/mob/living/simple_animal/hostile/raider/sulphite
	name = "Sulphite Brawler"
	desc = "A raider with low military grade armor and a shishkebab"
	icon_state = "melee_sulphite"
	icon_living = "melee_sulphite"
	icon_dead= "melee_sulphite_dead"
	maxHealth = 220
	health = 220
	melee_damage_lower = 40
	melee_damage_upper = 55
	loot = list(/obj/item/gun/ballistic/automatic/pistol/m1911/custom, /obj/item/clothing/suit/armored/heavy/metal, /obj/item/clothing/head/helmet/f13/metalmask/mk2)

//Metal Raider Mob
/mob/living/simple_animal/hostile/raider/ranged/sulphiteranged
	icon_state = "metal_raider"
	icon_living = "metal_raider"
	icon_dead = "metal_raider_dead"
	maxHealth = 180
	health = 180
	projectiletype = /obj/projectile/bullet/c45/op
	projectilesound = 'modular_fallout/master_files/sound/weapons/gunshot.ogg'
	loot = list(/obj/item/gun/ballistic/automatic/pistol/m1911/custom, /obj/item/clothing/suit/armored/heavy/metal, /obj/item/clothing/head/helmet/f13/metalmask/mk2)

//Junkers
/mob/living/simple_animal/hostile/raider/junker
	name = "Junker"
	desc = "A raider from the Junker gang."
	faction = list("raider", "wastebot")
	icon_state = "melee_sulphite"
	icon_living = "melee_sulphite"
	icon_dead= "melee_sulphite_dead"
	color = "#B85C00"
	maxHealth = 220
	health = 220
	melee_damage_lower = 40
	melee_damage_upper = 55
	loot = null

/mob/living/simple_animal/hostile/raider/ranged/boss/junker
	name = "Junker Footman"
	desc = "A Junker raider, outfitted in reinforced combat raider armor with extra metal plates."
	color = "#B85C00"
	faction = list("raider", "wastebot")
	maxHealth = 245
	health = 245
	damage_coeff = list(BRUTE = 1, BURN = 0.75, TOX = 0, CLONE = 0, STAMINA = 0, OXY = 0)
	melee_damage_lower = 25
	melee_damage_upper = 50

/mob/living/simple_animal/hostile/raider/junker/creator
	name = "Junker Field Creator"
	desc = "A Junker raider, specialized in spitting out eyebots on the fly with any scrap they can find."
	icon_state = "ranged_sulphitemob"
	icon_living = "ranged_sulphitemob"
	icon_dead = "melee_sulphite_dead"
	maxHealth = 180
	health = 180
	ranged = TRUE
	retreat_distance = 6
	minimum_distance = 8
	projectiletype = /obj/projectile/bullet/c45/op
	projectilesound = 'modular_fallout/master_files/sound/weapons/gunshot.ogg'
	var/list/spawned_mobs = list()
	var/max_mobs = 3
	var/mob_types = list(/mob/living/simple_animal/hostile/eyebot/reinforced)
	var/spawn_delay = 0
	var/spawn_time = 15 SECONDS
	var/spawn_text = "flies from"

/mob/living/simple_animal/hostile/raider/junker/creator/Initialize()
	. = ..()
	GLOB.mob_nests += src

/mob/living/simple_animal/hostile/raider/junker/creator/death()
	GLOB.mob_nests -= src
	. = ..()

/mob/living/simple_animal/hostile/raider/junker/creator/Destroy()
	GLOB.mob_nests -= src
	. = ..()

/mob/living/simple_animal/hostile/raider/junker/creator/Aggro()
	..()
	summon_backup(10)

/mob/living/simple_animal/hostile/raider/junker/creator/proc/spawn_mob()
	if(world.time < spawn_delay)
		return 0
	spawn_delay = world.time + spawn_time
	if(spawned_mobs.len >= max_mobs)
		return FALSE
	var/chosen_mob_type = pick_weight(mob_types)
	var/mob/living/simple_animal/L = new chosen_mob_type(get_turf(src))
	L.flags_1 |= (flags_1 & ADMIN_SPAWNED_1)
	spawned_mobs += L
	L.nest = src
	visible_message("<span class='danger'>[L] [spawn_text] [src].</span>")

/mob/living/simple_animal/hostile/raider/junker/boss
	name = "Junker Boss"
	desc = "A Junker boss, clad in hotrod power armor, and wielding a deadly rapid-fire shrapnel cannon."
	icon_state = "boss_mob"
	icon_living = "boss_mob"
	icon_dead = "boss_mob_dead"
	maxHealth = 450
	health = 450
	ranged = TRUE
	retreat_distance = 4
	minimum_distance = 6
	extra_projectiles = 9
	ranged_cooldown_time = 15
	projectiletype = /obj/projectile/bullet/shrapnel
	projectilesound = 'modular_fallout/master_files/sound/f13weapons/auto5.ogg'
