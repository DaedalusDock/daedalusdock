/mob/living/simple_animal/hostile/asteroid/hivelord
	name = "hivelord"
	desc = "A truly alien creature, it is a mass of unknown organic material, constantly fluctuating. When attacking, pieces of it split off and attack in tandem with the original."
	icon = 'icons/mob/lavaland/lavaland_monsters.dmi'
	icon_state = "Hivelord"
	icon_living = "Hivelord"
	icon_aggro = "Hivelord_alert"
	icon_dead = "Hivelord_dead"
	icon_gib = "syndicate_gib"
	mob_biotypes = MOB_ORGANIC
	move_to_delay = 14
	ranged = 1
	vision_range = 5
	aggro_vision_range = 9
	move_delay_modifier = 3
	maxHealth = 75
	health = 75
	harm_intent_damage = 5
	melee_damage_lower = 0
	melee_damage_upper = 0
	attack_verb_continuous = "lashes out at"
	attack_verb_simple = "lash out at"
	speak_emote = list("telepathically cries")
	attack_sound = 'sound/weapons/pierce.ogg'
	throw_message = "falls right through the strange body of the"
	ranged_cooldown = 0
	ranged_cooldown_time = 20
	obj_damage = 0
	environment_smash = ENVIRONMENT_SMASH_NONE
	retreat_distance = 3
	minimum_distance = 3
	pass_flags = PASSTABLE
	loot = list(/obj/item/organ/regenerative_core)
	var/brood_type = /mob/living/simple_animal/hostile/asteroid/hivelordbrood
	var/has_clickbox = TRUE

/mob/living/simple_animal/hostile/asteroid/hivelord/Initialize(mapload)
	. = ..()
	if(has_clickbox)
		AddComponent(/datum/component/clickbox, icon_state = "hivelord", max_scale = INFINITY, dead_state = "hivelord_dead") //they writhe so much.

/mob/living/simple_animal/hostile/asteroid/hivelord/OpenFire(the_target)
	if(world.time >= ranged_cooldown)
		var/mob/living/simple_animal/hostile/asteroid/hivelordbrood/A = new brood_type(src.loc)

		A.flags_1 |= (flags_1 & ADMIN_SPAWNED_1)
		A.GiveTarget(target)
		A.friends = friends
		A.faction = faction.Copy()
		ranged_cooldown = world.time + ranged_cooldown_time

/mob/living/simple_animal/hostile/asteroid/hivelord/AttackingTarget()
	OpenFire()
	return TRUE

/mob/living/simple_animal/hostile/asteroid/hivelord/death(gibbed, cause_of_death = "Unknown")
	mouse_opacity = MOUSE_OPACITY_ICON
	..(gibbed)

//A fragile but rapidly produced creature
/mob/living/simple_animal/hostile/asteroid/hivelordbrood
	name = "hivelord brood"
	desc = "A fragment of the original Hivelord, rallying behind its original. One isn't much of a threat, but..."
	icon = 'icons/mob/lavaland/lavaland_monsters.dmi'
	icon_state = "Hivelordbrood"
	icon_living = "Hivelordbrood"
	icon_aggro = "Hivelordbrood"
	icon_dead = "Hivelordbrood"
	icon_gib = "syndicate_gib"
	move_to_delay = 1
	friendly_verb_continuous = "buzzes near"
	friendly_verb_simple = "buzz near"
	vision_range = 10
	move_delay_modifier = 3
	maxHealth = 1
	health = 1
	harm_intent_damage = 5
	melee_damage_lower = 2
	melee_damage_upper = 2
	attack_verb_continuous = "slashes"
	attack_verb_simple = "slash"
	speak_emote = list("telepathically cries")
	attack_sound = 'sound/weapons/pierce.ogg'
	attack_vis_effect = ATTACK_EFFECT_SLASH
	throw_message = "falls right through the strange body of the"
	obj_damage = 0
	environment_smash = ENVIRONMENT_SMASH_NONE
	pass_flags = PASSTABLE | PASSMOB
	density = FALSE
	del_on_death = 1
	var/clickbox_state = "hivelord"
	var/clickbox_max_scale = INFINITY

/mob/living/simple_animal/hostile/asteroid/hivelordbrood/Initialize(mapload)
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(death)), 100)
	AddElement(/datum/element/simple_flying)
	AddComponent(/datum/component/swarming)
	AddComponent(/datum/component/clickbox, icon_state = clickbox_state, max_scale = clickbox_max_scale)
