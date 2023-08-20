/datum/chemical_reaction/mindbreaker
	results = list(/datum/reagent/toxin/mindbreaker = 5)
	required_reagents = list(/datum/reagent/silicon = 1, /datum/reagent/hydrogen = 1, /datum/reagent/medicine/dylovene = 1)
	mix_message = "The mixture turns into a vivid red liquid."
	required_temp = 100
	optimal_temp = 450
	overheat_temp = 900
	temp_exponent_factor = 2.5
	thermic_constant = 150
	rate_up_lim = 15

/datum/chemical_reaction/zombiepowder
	results = list(/datum/reagent/toxin/zombiepowder = 2)
	required_reagents = list(/datum/reagent/toxin/carpotoxin = 5, /datum/reagent/medicine/morphine = 5, /datum/reagent/copper = 5)
	required_temp = 90 CELSIUS
	optimal_temp = 95 CELSIUS
	overheat_temp = 99 CELSIUS
	mix_message = "The solution boils off to form a fine powder."

/datum/chemical_reaction/toxin
	results = list(/datum/reagent/toxin = 2)
	required_reagents = list(/datum/reagent/consumable/ethanol = 1, /datum/reagent/mercury = 1, /datum/reagent/medicine/dylovene = 1)
