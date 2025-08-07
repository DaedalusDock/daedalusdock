// Reagents whose primary purpose is to be upgraded to another reagent.
/datum/chemical_reaction/acetone
	results = list(/datum/reagent/acetone = 3)
	required_reagents = list(/datum/reagent/fuel/oil = 1, /datum/reagent/fuel = 1, /datum/reagent/oxygen = 1)

/datum/chemical_reaction/oil
	results = list(/datum/reagent/fuel/oil = 3)
	required_reagents = list(/datum/reagent/fuel = 1, /datum/reagent/hydrogen = 1, /datum/reagent/carbon = 1)

/datum/chemical_reaction/glycerol
	results = list(/datum/reagent/glycerol = 1)
	required_reagents = list(/datum/reagent/consumable/cornoil = 3, /datum/reagent/toxin/acid = 1)

/datum/chemical_reaction/phenol
	results = list(/datum/reagent/phenol = 3)
	required_reagents = list(/datum/reagent/water = 1, /datum/reagent/chlorine = 1, /datum/reagent/fuel/oil = 1)

/datum/chemical_reaction/hydrazine
	results = list(/datum/reagent/hydrazine = 3)
	required_reagents = list(/datum/reagent/ammonia = 1, /datum/reagent/hydrogen = 1, /datum/reagent/oxygen = 1)
