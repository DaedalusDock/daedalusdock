/mob/living/simple_animal/hostile/retaliate/hog
	name = "feral hog"
	desc = "A huge, mangy looking hog. Aggravating it might not be a good idea."
	icon_state = "hog"
	icon_living = "hog"
	icon_dead = "hog_dead"
	icon_gib = "brownbear_gib"
	speed = 0
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
	var/territorial = TRUE
	var/rename = TRUE

/mob/living/simple_animal/hostile/retaliate/hog/Initialize(mapload)
	. = ..()
	if(territorial)
		AddComponent(/datum/component/connect_range, src, list(COMSIG_ATOM_ENTERED = PROC_REF(checkEntered)), 1, FALSE)
	if(rename)
		switch (gender)
			if(MALE)
				name = "feral boar"
			if(FEMALE)
				name = "feral sow"

/mob/living/simple_animal/hostile/retaliate/hog/Aggro()
	..()
	hogAlert()

/mob/living/simple_animal/hostile/retaliate/hog/proc/checkEntered(datum/source, atom/movable/arrived)
	if(arrived == src)
		return
	if(!ismob(arrived))
		return
	Retaliate()

/mob/living/simple_animal/hostile/retaliate/hog/Moved(atom/old_loc, movement_dir, forced, list/old_locs, momentum_change = TRUE)
	. = ..()
	if(prob(15))
		playsound(src, 'sound/creatures/hog/hoggrunt.ogg', 50, TRUE)

/mob/living/simple_animal/hostile/retaliate/hog/proc/hogAlert() //YOU HAVE ALERTED THE HOG
	var/obj/effect/overlay/vis/overlay = new()
	overlay.icon = 'icons/mob/animal.dmi'
	overlay.icon_state = "hog_alert_overlay"
	overlay.layer += 1
	vis_contents += overlay
	QDEL_IN(overlay, 1.5 SECONDS)
	playsound(src, 'sound/creatures/hog/hogscream.ogg', 50, TRUE)

/mob/living/simple_animal/hostile/retaliate/hog/security
	name = "Lieutenant Hoggison"
	desc = "A large, greasy hog that was rescued by security during an illegal pork trafficking operation. This pig is now the beloved pet of security, despite all the jokes made by the crew."
	icon_state = "hog_officer"
	icon_living = "hog_officer"
	faction = list("neutral")
	territorial = FALSE
	rename = FALSE
