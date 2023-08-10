
/datum/chemical_reaction/inaprovaline
	results = list(/datum/reagent/inaprovaline = 3)
	required_reagents = list(/datum/reagent/acetone = 1, /datum/reagent/carbon = 1, /datum/reagent/sugar = 1)

/datum/chemical_reaction/dylovene
	results = list(/datum/reagent/dylovene = 3)
	required_reagents = list(/datum/reagent/silicon = 1, /datum/reagent/potassium = 1, /datum/reagent/ammonia = 1)

/datum/chemical_reaction/bicaridine
	results = list(/datum/reagent/bicaridine = 2)
	required_reagents = list(/datum/reagent/phosphorus = 1, /datum/reagent/carbon = 1)

/datum/chemical_reaction/meralyne
	results = list(/datum/reagent/medicine/meralyne = 2)
	required_reagents = list(/datum/reagent/bicaridine = 1, /datum/reagent/inaprovaline = 1)
	inhibitors = list(/datum/reagent/sugar = 1) // Messes up with inaprovaline
	required_temp = (-50 CELSIUS) - 100
	optimal_temp = (-50 CELSIUS) - 25
	overheat_temp = -50 CELSIUS

/datum/chemical_reaction/meralyne/overheated(datum/reagents/holder, datum/equilibrium/equilibrium, step_volume_added)
	. = ..()
	explode_fire_vortex(holder, equilibrium, 2, 2, "overheat", TRUE)

/datum/chemical_reaction/kelotane
	results = list(/datum/reagent/kelotane = 2)
	required_reagents = list(/datum/reagent/silicon = 1, /datum/reagent/carbon = 1)

/datum/chemical_reaction/dermaline
	results = list(/datum/reagent/dermaline = 3)
	required_reagents = list(/datum/reagent/acetone = 1, /datum/reagent/phosphorus = 1, /datum/reagent/kelotane = 1)
	required_temp = (-50 CELSIUS) - 100
	optimal_temp = (-50 CELSIUS) - 25
	overheat_temp =  = -50 CELSIUS

/datum/chemical_reaction/dermaline/overheated(datum/reagents/holder, datum/equilibrium/equilibrium, step_volume_added)
	. = ..()
	explode_fire_vortex(holder, equilibrium, 2, 2, "overheat", TRUE)

/datum/chemical_reaction/dexalin
	results = list(/datum/reagent/medicine/dexalin = 1)
	required_reagents = list(/datum/reagent/acetone = 2, /datum/reagent/toxin/plasma = 0.1)
	inhibitors = list(/datum/reagent/water = 1) // Messes with cryox

/datum/chemical_reaction/tricordrazine
	results =  list(/datum/reagent/medicine/tricordrazine = 2)
	required_reagents = list(/datum/reagent/inaprovaline = 1, /datum/reagent/dylovene = 1)

/datum/chemical_reaction/ryetalyn
	results = list(/datum/reagent/medicine/ryetalyn = 2)
	required_reagents = list(/datum/reagent/potass_iodide = 1, /datum/reagent/carbon = 1)

/datum/chemical_reaction/cryoxadone
	result = list(/datum/reagent/medicine/cryoxadone = 3)
	required_reagents = list(/datum/reagent/dexalin = 1, /datum/reagent/drink/ice = 1, /datum/reagent/acetone = 1)
	required_temp = (-25 CELSIUS) - 100
	optimal_temp = (-25 CELSIUS) - 50
	overheat_temp = -25 CELSIUS
	mix_message = "The solution turns into a blue sludge."

/datum/chemical_reaction/clonexadone
	results = list(/datum/reagent/medicine/clonexadone = 2)
	required_reagents = list(/datum/reagent/medicine/cryoxadone = 1, /datum/reagent/sodium = 1)
	minimum_temperature = -100 CELSIUS
	optimal_temp = -100 CELSIUS
	overheat_temp = -75 CELSIUS
	mix_message = "The solution thickens into translucent slime."

/datum/chemical_reaction/hyperzine
	results = list(/datum/reagent/medicine/hyperzine = 3)
	required_reagents = list(/datum/reagent/sugar = 1, /datum/reagent/phosphorus = 1, /datum/reagent/sulfur = 1)

/datum/chemical_reaction/tramadol
	results = list(/datum/reagent/medicine/tramadol = 3)
	required_reagents = list(/datum/reagent/medicine/inaprovaline = 1, /datum/reagent/ethanol = 1, /datum/reagent/acetone = 1)

/datum/chemical_reaction/oxycodone
	results = list(/datum/reagent/medicine/tramadol/oxycodone = 1)
	required_reagents = list(/datum/reagent/ethanol = 1, /datum/reagent/medicine/tramadol = 1)
	catalysts = list(/datum/reagent/toxin/phoron = 5)

/datum/chemical_reaction/venaxilin
	results = list(/datum/reagent/medicine/venaxilin = 1)
	required_reagents = list(/datum/reagent/medicine/dylovene = 1, /datum/reagent/medicine/spaceacillin = 1, /datum/reagent/toxin/venom = 1)
	result_amount = 1
	required_temp = 50 CELSIUS
	optimal_temp = 75 CELSIUS
	overheat_temp = 100 CELSIUS
	mix_message = "The solution steams and becomes cloudy."
#warn come back to ^

/datum/chemical_reaction/spaceacillin
	results = list(/datum/reagent/medicine/spaceacillin = 2)
	required_reagents = list(/datum/reagent/cryptobiolin = 1, /datum/reagent/medicine/inaprovaline = 1)

/datum/chemical_reaction/synaptizine
	results = list(/datum/reagent/medicine/synaptizine = 3)
	required_reagents = list(/datum/reagent/sugar = 1, /datum/reagent/lithium = 1, /datum/reagent/water = 1)
	required_temp = 30 CELSIUS
	optimal_temp = 80 CELSIUS
	overheat_temp = 130 CELSIUS

/datum/chemical_reaction/alkysine
	results = list(/datum/reagent/alkysine = 2)
	required_reagents = list(/datum/reagent/toxin/acid/hydrochloric = 1, /datum/reagent/ammonia = 1, /datum/reagent/medicine/dylovene = 1)
