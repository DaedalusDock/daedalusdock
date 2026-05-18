/datum/chemical_reaction/calomel
	reaction_flags = REACTION_INSTANT
	results = list(/datum/reagent/tincture/calomel = 1)
	required_reagents = list(
		/datum/reagent/ichor = 1,
		/datum/reagent/ash = 0.2,
	)

/datum/chemical_reaction/burnboil
	reaction_flags = REACTION_INSTANT
	results = list(/datum/reagent/tincture/burnboil = 2)
	required_reagents = list(
		/datum/reagent/ichor = 1,
		/datum/reagent/consumable/aloejuice = 0.5, // Soothes burns
		/datum/reagent/consumable/orangejuice = 0.5, // Is orange
	)

/datum/chemical_reaction/woundseal
	reaction_flags = REACTION_INSTANT
	results = list(/datum/reagent/tincture/woundseal = 2)
	required_reagents = list(
		/datum/reagent/ichor = 1,
		/datum/reagent/consumable/capsaicin = 0.5, // Base of pain medicine
		/datum/reagent/consumable/garlic = 0.5, // Fights germs, affects blood pressure
	)

/datum/chemical_reaction/siphroot
	reaction_flags = REACTION_INSTANT
	results = list(/datum/reagent/tincture/siphroot = 2)
	required_reagents = list(
		/datum/reagent/ichor = 1,
		/datum/reagent/consumable/tomatojuice = 1, // Is red
	)
