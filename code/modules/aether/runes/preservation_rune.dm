/obj/effect/aether_rune/preserve
	rune_type = "preserve"
	invocation_name = "\improper Mummification"
	required_blood_amt = 100
	required_helpers = 1

	invocation_phrases = list(
		"Hak shanto khantick" = 3 SECONDS,
		"Gahn vidi telshishi" = 2.5 SECONDS,
		"Untinthan khoshoal mon vinshi" = 2 SECONDS,
	)

/obj/effect/aether_rune/preserve/setup_blackboard()
	blackboard = list(
		RUNE_BB_TOME = null,
		RUNE_BB_INVOKER = null,
		RUNE_BB_TARGET_MOB = null,
		RUNE_BB_BLOOD_CONTAINER = null
	)

/obj/effect/aether_rune/revival/find_target_mob()
	for(var/mob/living/carbon/human/H in loc)
		if(H.stat != DEAD)
			continue
		return H

/obj/effect/aether_rune/preserve/succeed_invoke(mob/living/carbon/human/target_mob)
	for(var/obj/item/organ/O in target_mob.processing_organs)
		if(O.organ_flags & (ORGAN_SYNTHETIC|ORGAN_MUMMIFIED) || istype(O, /obj/item/organ/brain))
			continue

		O.set_max_health(round(O.get_max_health() * 0.75))
		O.set_germ_level(0)
		O.organ_flags |= ORGAN_MUMMIFIED
		O.name = "mummified [O.name]"
		O.add_atom_colour(COLOR_YELLOW, FIXED_COLOUR_PRIORITY)
	target_mob.add_splatter_floor(get_turf(target_mob))
	target_mob.setBloodVolume(0)
	return ..()

/obj/effect/aether_rune/preserve/invoke_failure_effects(datum/ritual_failure/failure_reason, failure_source)
	switch(failure_reason)
		if(/datum/ritual_failure/target_mob_moved, /datum/ritual_failure/target_mob_getup)
			switch(rand(1,10))
				if(1)
					huskify(failure_source)
				if(2 to 10)
					rip_out_organs(failure_source)
		else
			rip_out_organs(failure_source)


/obj/effect/aether_rune/preserve/proc/rip_out_organs(mob/living/carbon/human/victim)
	var/list/organs = victim.processing_organs.Copy()
	organs -= locate(/obj/item/organ/brain) in organs
	if(!length(organs))
		return

	var/turf/victim_turf = get_turf(victim)
	victim.add_splatter_floor(victim_turf)

	for(var/i in 1 to rand(1, 2))
		if(!length(organs))
			return

		var/obj/item/organ/picked_organ = pick_n_take(organs)
		picked_organ.Remove(victim)
		picked_organ.forceMove(victim_turf)
		playsound(loc, 'sound/misc/splort.ogg', 80, TRUE)

		var/turf/target_turf = get_random_perimeter_turf(src, 3)
		picked_organ.throw_at(target_turf, rand(1,3), 1)

/obj/effect/aether_rune/preserve/proc/huskify(mob/living/carbon/human/victim)
	victim.become_husk(MIRACLE_TRAIT)
