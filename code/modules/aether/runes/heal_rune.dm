/obj/effect/aether_rune/heal
	rune_type = "heal"

/obj/effect/aether_rune/wipe_state()
	for(var/item in blackboard[RUNE_BB_HEAL_REAGENT_CONTAINERS])
		unregister_item(item)
	return ..()

/obj/effect/aether_rune/heal/pre_invoke(mob/living/user, obj/item/aether_tome/tome)
	. = ..()
	blackboard[RUNE_BB_HEAL_REAGENT_CONTAINERS] = list()

	for(var/obj/item/reagent_containers/reagent_container in orange(1, src))
		if(!reagent_container.is_open_container())
			continue

		if(\
			reagent_container.reagents.has_reagent(/datum/reagent/tincture/woundseal) || \
			reagent_container.reagents.has_reagent(/datum/reagent/tincture/burnboil) || \
			reagent_container.reagents.has_reagent(/datum/reagent/tincture/siphroot) || \
			reagent_container.reagents.has_reagent(/datum/reagent/tincture/calomel) \
		)
			register_item(reagent_container)
			blackboard[RUNE_BB_HEAL_REAGENT_CONTAINERS] += reagent_container

/obj/effect/aether_rune/heal/can_invoke()
	. = ..()
	if(!.)
		return

	return length(blackboard[RUNE_BB_HEAL_REAGENT_CONTAINERS])

/obj/effect/aether_rune/heal/succeed_invoke(mob/living/carbon/human/target_mob)
	visible_message(span_statsgood("Strands of [target_mob.p_s()] skin knit themselves together over [target_mob.p_their()] wounds."))

	var/woundseal = 0
	var/burnboil = 0
	var/siphroot = 0
	var/calomel = 0
	for(var/obj/item/reagent_containers/reagent_container in blackboard[RUNE_BB_HEAL_REAGENT_CONTAINERS])
		woundseal += reagent_container.reagents.get_reagent_amount(/datum/reagent/tincture/woundseal)
		burnboil += reagent_container.reagents.get_reagent_amount(/datum/reagent/tincture/burnboil)
		siphroot += reagent_container.reagents.get_reagent_amount(/datum/reagent/tincture/siphroot)
		calomel += reagent_container.reagents.get_reagent_amount(/datum/reagent/tincture/calomel)
		reagent_container.reagents.del_reagent(/datum/reagent/tincture/woundseal)
		reagent_container.reagents.del_reagent(/datum/reagent/tincture/burnboil)
		reagent_container.reagents.del_reagent(/datum/reagent/tincture/siphroot)
		reagent_container.reagents.del_reagent(/datum/reagent/tincture/calomel)

	target_mob.heal_overall_damage(
		woundseal * 8,
		burnboil * 8,
		BODYTYPE_ORGANIC,
	)

	if(calomel)
		target_mob.adjustToxLoss(calomel * -10)
	if(siphroot)
		target_mob.adjustBloodVolume(siphroot * 10)
		if(target_mob.blood_volume >= BLOOD_VOLUME_NORMAL && siphroot >= 10)
			target_mob.set_heartattack(FALSE)
	return ..()

/obj/effect/aether_rune/heal/fail_invoke(failure_reason, failure_source)
	if(failure_reason == RUNE_FAIL_GRACEFUL)
		return ..()

	var/mob/living/carbon/human/target_mob = blackboard[RUNE_BB_TARGET_MOB]
	var/list/blood_dna = target_mob.get_blood_dna_list()
	visible_message(span_statsbad("Untamed energy floods into [target_mob], and [target_mob.p_their()] body rapidly expands."))

	for(var/_dir in GLOB.alldirs)
		target_mob.spray_blood(_dir, 3)

	target_mob.gib()

	switch(failure_reason)
		if(RUNE_FAIL_TARGET_MOB_MOVED, RUNE_FAIL_TARGET_STOOD_UP)
			for(var/mob/living/carbon/human/H in touching_rune + blackboard[RUNE_BB_INVOKER])
				cover_in_blood(H, blood_dna)

		if(RUNE_FAIL_HELPER_REMOVED_HAND, RUNE_FAIL_INVOKER_INCAP)
			cover_in_blood(failure_source, blood_dna)

	return ..()

/obj/effect/aether_rune/heal/proc/cover_in_blood(mob/living/carbon/human/victim, list/blood_dna_list)
	victim.add_blood_DNA_to_items(blood_dna_list)
