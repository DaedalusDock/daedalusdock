/mob/living/simple_animal/hostile/retaliate/hog
	name = "feral hog"
	desc = "A huge, mangy looking hog. Aggravating it might not be a good idea."
	icon_state = "hog"
	icon_living = "hog"
	icon_dead = "hog_dead"
	icon_gib = "brownbear_gib"
	move_delay_modifier = 0
	maxHealth = 80
	health = 80
	harm_intent_damage = 5
	turns_per_move = 5
	melee_damage_lower = 20
	melee_damage_upper = 25
	response_help_continuous = "squeezes"
	response_help_simple = "squeeze"
	attack_verb_continuous = "rams"
	attack_verb_simple = "ram"
	butcher_results = list(/obj/item/food/meat/slab = 5) //i would add pork but i don't want to touch crafting menu cooking
	attack_sound = 'sound/creatures/hog/hogattack.ogg'
	deathsound = 'sound/creatures/hog/hogdeath.ogg'
	obj_damage = 80 //do not underestimate the destructive ability of an angry hog
	environment_smash = ENVIRONMENT_SMASH_STRUCTURES
	attack_vis_effect = ATTACK_EFFECT_SMASH
	ranged_cooldown_time = 10 SECONDS
	speak_emote = list("oinks")
	can_buckle = TRUE
	var/territorial = TRUE
	var/rename = TRUE

/mob/living/simple_animal/hostile/retaliate/hog/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/ridable, /datum/component/riding/creature/hog)
	if(territorial)
		AddComponent(/datum/component/connect_range, src, list(COMSIG_ATOM_ENTERED = PROC_REF(checkEntered)), 1, FALSE)
	if(rename)
		switch (gender)
			if(MALE)
				name = "feral boar"
			if(FEMALE)
				name = "feral sow"

/mob/living/simple_animal/hostile/retaliate/hog/Life(delta_time = SSMOBS_DT, times_fired)
	. = ..()
	if(stat == CONSCIOUS)
		if(prob(5))
			playsound(src, 'sound/creatures/hog/hoggrunt.ogg', 50, TRUE)
		var/obj/item/food/fooditem = locate(/obj/item/food) in view(1, src)
		if(fooditem && Adjacent(fooditem))
			consume(fooditem)

/mob/living/simple_animal/hostile/retaliate/hog/AttackingTarget()
	if(istype(target, /obj/item/food))
		consume(target)
		return
	if(ismob(target))
		var/mob/living/moving_target = target
		if(moving_target.buckled == src)
			return
	return ..()

/mob/living/simple_animal/hostile/retaliate/hog/proc/consume(atom/movable/fooditem)
	playsound(src, 'sound/items/eatfood.ogg', 50, TRUE)
	visible_message("[name] eats the [fooditem].")
	qdel(fooditem)
	if(health == maxHealth)
		return
	health += 5
	if(health > maxHealth)
		health = maxHealth

/mob/living/simple_animal/hostile/retaliate/hog/proc/checkEntered(datum/source, atom/movable/arrived)
	if(stat != CONSCIOUS) //not 100% sure if this is needed
		return
	if(arrived == src)
		return
	if(!ismob(arrived))
		return
	if(target)
		return
	hogAlert()
	Retaliate()

/mob/living/simple_animal/hostile/retaliate/hog/proc/hogAlert() //YOU HAVE ALERTED THE HOG
	var/obj/effect/overlay/vis/overlay = new()
	overlay.icon = 'icons/mob/animal.dmi'
	overlay.icon_state = "hog_alert_overlay"
	overlay.layer += 1
	add_viscontents(overlay)
	QDEL_IN(overlay, 1.5 SECONDS)
	playsound(src, 'sound/creatures/hog/hogscream.ogg', 50, TRUE)

/mob/living/simple_animal/hostile/retaliate/hog/proc/flingRider(atom/rider) //shouldn't trigger if the hog has a client.
	playsound(src, 'sound/creatures/hog/hogscream.ogg', 50, TRUE)
	emote("spin")

/mob/living/simple_animal/hostile/retaliate/hog/security
	name = "Lieutenant Hoggison"
	desc = "A large, greasy hog that was rescued by security during an illegal pork trafficking operation. This pig is now the beloved pet of security, despite all the jokes made by the crew."
	icon_state = "hog_officer"
	icon_living = "hog_officer"
	melee_damage_lower = 15 //life as a domestic pet has reduced this hog's combat ability.
	melee_damage_upper = 15
	obj_damage = 40
	territorial = FALSE
	rename = FALSE
