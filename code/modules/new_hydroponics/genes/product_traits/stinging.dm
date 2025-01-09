/*
 * Injects a number of chemicals from the plant when you throw it at someone or they slip on it.
 * At 0 potency it can inject 1 unit of its chemicals, while at 100 potency it can inject 20 units.
 */
/datum/plant_gene/trait/stinging
	name = "Hypodermic Prickles"
	examine_line = "<span class='info'>It's quite prickley.</span>"
	trait_ids = REAGENT_TRANSFER_ID
	mutability_flags = PLANT_GENE_REMOVABLE | PLANT_GENE_MUTATABLE | PLANT_GENE_GRAFTABLE

/datum/plant_gene/trait/stinging/on_new_plant(obj/item/product, newloc)
	. = ..()
	if(!.)
		return

	RegisterSignal(product, COMSIG_PLANT_ON_SLIP, PROC_REF(prickles_inject))
	RegisterSignal(product, COMSIG_MOVABLE_IMPACT, PROC_REF(prickles_inject))

/*
 * Injects a target with a number of reagents from our plant.
 *
 * our_plant - our plant that's injecting someone
 * target - the atom being hit on thrown or slipping on our plant
 */
/datum/plant_gene/trait/stinging/proc/prickles_inject(obj/item/our_plant, atom/target)
	SIGNAL_HANDLER

	if(!isliving(target) || !our_plant.reagents?.total_volume)
		return

	var/mob/living/living_target = target
	var/obj/item/seeds/our_seed = our_plant.get_plant_seed()
	if(living_target.reagents && living_target.can_inject())
		var/injecting_amount = max(1, our_seed.potency * 0.2) // Minimum of 1, max of 20
		our_plant.reagents.trans_to(living_target, injecting_amount, methods = INJECT)
		to_chat(target, span_danger("You are pricked by [our_plant]!"))
		log_combat(our_plant, living_target, "pricked and attempted to inject reagents from [our_plant] to [living_target]. Last touched by: [our_plant.fingerprintslast].")
		our_plant.investigate_log("pricked and injected [key_name(living_target)] and injected [injecting_amount] reagents at [AREACOORD(living_target)]. Last touched by: [our_plant.fingerprintslast].", INVESTIGATE_BOTANY)
