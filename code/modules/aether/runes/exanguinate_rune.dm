/obj/effect/aether_rune/exanguinate
	rune_type = "exanguinate"

	required_helpers = 1
	required_blood_amt = 0

	invocation_phrases = list(
		"Bes' arlo" = 1.5 SECONDS,
		"Lahin shlotov sha layef" = 3 SECONDS,
		"shshloboksha racha" = 2.5 SECONDS,
	)

/obj/effect/aether_rune/exanguinate/setup_blackboard()
	blackboard = list(
		RUNE_BB_TOME = null,
		RUNE_BB_INVOKER = null,
		RUNE_BB_TARGET_MOB = null,
		RUNE_BB_EXANGUINATE_CONTAINERS = list(),
	)

/obj/effect/aether_rune/exanguinate/find_target_mob()
	var/mob/living/carbon/human/H = ..()
	if(!H)
		return null

	if(!H.blood_volume)
		return null

	if(H.get_blood_id() != /datum/reagent/blood)
		return null

	return H

/obj/effect/aether_rune/exanguinate/wipe_state()
	for(var/item in blackboard[RUNE_BB_EXANGUINATE_CONTAINERS])
		unregister_item(item)
	return ..()

/obj/effect/aether_rune/exanguinate/pre_invoke()
	. = ..()

	for(var/obj/item/reagent_containers/reagent_container in orange(1, src))
		if(!reagent_container.is_open_container())
			continue

		register_item(reagent_container)
		blackboard[RUNE_BB_EXANGUINATE_CONTAINERS] += reagent_container

/obj/effect/aether_rune/exanguinate/can_invoke()
	. = ..()
	if(!.)
		return

	if(!length(blackboard[RUNE_BB_EXANGUINATE_CONTAINERS]))
		return FALSE

/obj/effect/aether_rune/exanguinate/succeed_invoke(mob/living/carbon/human/target_mob)
	var/list/reagent_containers = blackboard[RUNE_BB_EXANGUINATE_CONTAINERS]
	var/list/not_full_containers = reagent_containers.Copy()

	var/list/blood_data = target_mob.get_blood_data(target_mob.get_blood_id())
	var/blood_to_disperse = target_mob.blood_volume
	var/blood_spent = 0

	while(length(not_full_containers) && (blood_to_disperse > 0))
		for(var/obj/item/reagent_containers/container as anything in not_full_containers)
			var/blood_share = min(rand(5,10), blood_to_disperse)
			var/not_used = container.reagents.add_reagent(/datum/reagent/blood, blood_share, blood_data.Copy(), no_react = TRUE)

			if(container.reagents.holder_full())
				not_full_containers -= container

			blood_spent += blood_share - not_used
			blood_to_disperse -= blood_share - not_used

	for(var/obj/item/reagent_containers/container as anything in reagent_containers)
		container.reagents.handle_reactions()

	if(blood_to_disperse - blood_spent > 100) // 100+ blood remaining
		blood_spent += 100
		for(var/_dir in GLOB.alldirs)
			if(prob(50))
				target_mob.spray_blood(_dir, 3)

	target_mob.add_splatter_floor(get_turf(target_mob))
	target_mob.adjustBloodVolume(-blood_spent)

	target_mob.visible_message(span_statsgood("Hundreds of blood globules spring out from [target_mob] and leap into the nearby containers."))
	playsound(src, 'sound/effects/wounds/blood2.ogg', 50)
	playsound(src, 'sound/effects/wounds/crack1.ogg', 50)
	return ..()
