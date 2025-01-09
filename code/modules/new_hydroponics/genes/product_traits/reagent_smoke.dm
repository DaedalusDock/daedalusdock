/// Explodes into reagent-filled smoke when squashed.
/datum/plant_gene/trait/smoke
	name = "Gaseous Decomposition"
	mutability_flags = PLANT_GENE_REMOVABLE | PLANT_GENE_MUTATABLE | PLANT_GENE_GRAFTABLE

/datum/plant_gene/trait/smoke/on_new_plant(obj/item/product, newloc)
	. = ..()
	if(!.)
		return

	RegisterSignal(product, COMSIG_PLANT_ON_SQUASH, PROC_REF(make_smoke))

/*
 * Makes a cloud of reagent smoke.
 *
 * our_plant - our plant being squashed and smoked
 * target - the atom the plant was squashed on
 */
/datum/plant_gene/trait/smoke/proc/make_smoke(obj/item/our_plant, atom/target)
	SIGNAL_HANDLER

	our_plant.investigate_log("made smoke at [AREACOORD(target)]. Last touched by: [our_plant.fingerprintslast].", INVESTIGATE_BOTANY)
	var/datum/effect_system/fluid_spread/smoke/chem/smoke = new ()
	var/obj/item/seeds/our_seed = our_plant.get_plant_seed()
	var/splat_location = get_turf(target)
	var/smoke_amount = round(sqrt(our_seed.potency * 0.1), 1)
	smoke.attach(splat_location)
	smoke.set_up(smoke_amount, location = splat_location, carry = our_plant.reagents, silent = FALSE)
	smoke.start()
	our_plant.reagents.clear_reagents()
