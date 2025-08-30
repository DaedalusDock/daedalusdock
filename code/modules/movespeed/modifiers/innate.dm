/datum/movespeed_modifier/strained_muscles
	modifier = -0.3
	blacklisted_movetypes = (FLYING|FLOATING)

/datum/movespeed_modifier/pai_spacewalk
	modifier = -0.83
	flags = IGNORE_NOSLOW

/datum/movespeed_modifier/species
	movetypes = ~FLYING
	variable = TRUE

/datum/movespeed_modifier/dna_vault_speedup
	blacklisted_movetypes = (FLYING|FLOATING)
	modifier = 0.27
