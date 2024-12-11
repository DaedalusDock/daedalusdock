PROCESSING_SUBSYSTEM_DEF(hydroponics)
	name = "Hydroponics"
	flags = SS_HIBERNATE


/datum/controller/subsystem/processing/hydroponics/proc/splice_alleles(allele_one, allele_two, value_one, value_two)
	if(allele_one == allele_two)
		// Both were dominant or recessive, average them
		return round((value_one + value_two) / 2)

	var/dominance = allele_one - allele_two

	// Allele 1 was dominant. (1 - 0 == 1)
	if(dominance > 0)
		return value_one

	// Allele 1 was recessive. (0 - 1 == -1)
	else
		return value_two
