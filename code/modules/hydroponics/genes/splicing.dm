/datum/plant_gene/splicability
	abstract_type = /datum/plant_gene/splicability

	var/modifier = 20

/datum/plant_gene/splicability/positive
	name = "Splice Enabler"
	desc = "Chromosomal alterations enable seeds from this plant to be spliced with others more easily."

/datum/plant_gene/splicability/negative
	name = "Splice Blocker"
	desc = "Chromosomal alterations prevent seeds from this plant from being spliced as easily."

	modifier = -20
	is_negative = TRUE

/datum/plant_gene/splicability/negative/disabled
	name = "Splice Disabler"
	desc = "Chromosomal alterations prevent seeds from this plant from being spliced at all."

	modifier = -INFINITY
