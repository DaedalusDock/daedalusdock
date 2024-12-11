/datum/plant_gene
	var/name = "BAD GENE"
	var/desc = ""

	/// Chance for this gene to develop fully and become active.
	var/development_chance = 10
	/// Is this gene considered bad.
	var/is_negative = FALSE

	/// Chance to process
	var/process_chance = 100

/// Processing effects. Return TRUE to cancel effects for children.
/datum/plant_gene/proc/tick(delta_time, obj/machinery/hydroponics/tray, datum/plant/plant, datum/plant_tick/plant_tick)
	SHOULD_CALL_PARENT(TRUE)

	if(!DT_PROB(process_chance, delta_time))
		return TRUE

/**
 * Returns the plant's growth state.
 * Args:
 * * gene_holder: The plant's plant_gene_holder
 * * stat: Desired stat
 * * base_val: The value of the gene holder's stat, before any gene modifiers.
 */
/datum/plant_gene/proc/get_stat_modifier(datum/plant_gene_holder/gene_holder, stat, base_val)
	return 0
