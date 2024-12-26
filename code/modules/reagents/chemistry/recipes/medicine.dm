
/datum/chemical_reaction/inaprovaline
	results = list(/datum/reagent/medicine/inaprovaline = 3)
	required_reagents = list(/datum/reagent/acetone = 1, /datum/reagent/carbon = 1, /datum/reagent/consumable/sugar = 1, /datum/reagent/phenol = 1)

/datum/chemical_reaction/dylovene
	results = list(/datum/reagent/medicine/dylovene = 3)
	required_reagents = list(/datum/reagent/silicon = 1, /datum/reagent/potassium = 1, /datum/reagent/ammonia = 1)

/datum/chemical_reaction/bicaridine
	results = list(/datum/reagent/medicine/bicaridine = 2)
	required_reagents = list(/datum/reagent/phosphorus = 1, /datum/reagent/carbon = 1, /datum/reagent/acetone = 1)

/datum/chemical_reaction/meralyne
	results = list(/datum/reagent/medicine/meralyne = 2)
	required_reagents = list(/datum/reagent/medicine/bicaridine = 1, /datum/reagent/medicine/epinephrine = 1, /datum/reagent/acetone = 1)
	inhibitors = list(/datum/reagent/consumable/sugar = 1) // Messes up with inaprovaline

/datum/chemical_reaction/meralyne/overheated(datum/reagents/holder, datum/equilibrium/equilibrium, step_volume_added)
	. = ..()
	explode_fire_vortex(holder, equilibrium, 2, 2, "overheat", TRUE)

/datum/chemical_reaction/kelotane
	results = list(/datum/reagent/medicine/kelotane = 2)
	required_reagents = list(/datum/reagent/silicon = 1, /datum/reagent/carbon = 1)
	is_cold_recipe = TRUE
	optimal_temp = (-50 CELSIUS) - 50
	required_temp = -50 CELSIUS
	overheat_temp = NO_OVERHEAT

/datum/chemical_reaction/dermaline
	results = list(/datum/reagent/medicine/dermaline = 3)
	required_reagents = list(/datum/reagent/acetone = 1, /datum/reagent/phosphorus = 1, /datum/reagent/medicine/kelotane = 1)
	optimal_temp = (-50 CELSIUS) - 25
	required_temp = -50 CELSIUS
	overheat_temp = NO_OVERHEAT
	is_cold_recipe = TRUE

/datum/chemical_reaction/dermaline/overheated(datum/reagents/holder, datum/equilibrium/equilibrium, step_volume_added)
	. = ..()
	explode_fire_vortex(holder, equilibrium, 2, 2, "overheat", TRUE)

/datum/chemical_reaction/dexalin
	results = list(/datum/reagent/medicine/dexalin = 1)
	required_reagents = list(/datum/reagent/acetone = 2, /datum/reagent/toxin/plasma = 0.1)
	inhibitors = list(/datum/reagent/water = 1) // Messes with cryox
	thermic_constant = 20 // Harder to ignite plasma

/datum/chemical_reaction/tricordrazine
	results =  list(/datum/reagent/medicine/tricordrazine = 5)
	required_reagents = list(/datum/reagent/medicine/bicaridine = 1, /datum/reagent/medicine/kelotane = 1, /datum/reagent/medicine/dylovene = 1)

/datum/chemical_reaction/ryetalyn
	results = list(/datum/reagent/medicine/ryetalyn = 2)
	required_reagents = list(/datum/reagent/medicine/potass_iodide = 1, /datum/reagent/carbon = 1)

/datum/chemical_reaction/cryoxadone
	results = list(/datum/reagent/medicine/cryoxadone = 3)
	required_reagents = list(/datum/reagent/medicine/dexalin = 1, /datum/reagent/consumable/ice = 1, /datum/reagent/acetone = 1)
	required_temp = (-25 CELSIUS) - 100
	optimal_temp = (-25 CELSIUS) - 50
	overheat_temp = -25 CELSIUS
	mix_message = "The solution turns into a blue sludge."

/datum/chemical_reaction/clonexadone
	results = list(/datum/reagent/medicine/clonexadone = 2)
	required_reagents = list(/datum/reagent/medicine/cryoxadone = 1, /datum/reagent/sodium = 1)
	required_temp = -100 CELSIUS
	optimal_temp = -100 CELSIUS
	overheat_temp = -75 CELSIUS
	mix_message = "The solution thickens into translucent slime."

/datum/chemical_reaction/hyperzine
	results = list(/datum/reagent/medicine/hyperzine = 3)
	required_reagents = list(/datum/reagent/consumable/sugar = 1, /datum/reagent/phosphorus = 1, /datum/reagent/sulfur = 1)

/datum/chemical_reaction/tramadol
	results = list(/datum/reagent/medicine/tramadol = 3)
	required_reagents = list(/datum/reagent/medicine/epinephrine = 1, /datum/reagent/consumable/ethanol = 1, /datum/reagent/acetone = 1)

/datum/chemical_reaction/oxycodone
	results = list(/datum/reagent/medicine/tramadol/oxycodone = 1)
	required_reagents = list(/datum/reagent/consumable/ethanol = 1, /datum/reagent/medicine/tramadol = 1)
	required_catalysts = list(/datum/reagent/toxin/plasma = 5)

/datum/chemical_reaction/spaceacillin
	results = list(/datum/reagent/medicine/spaceacillin = 2)
	required_reagents = list(/datum/reagent/cryptobiolin = 1, /datum/reagent/medicine/epinephrine = 1)

/datum/chemical_reaction/synaptizine
	results = list(/datum/reagent/medicine/synaptizine = 3)
	required_reagents = list(/datum/reagent/consumable/sugar = 1, /datum/reagent/lithium = 1, /datum/reagent/water = 1)
	required_temp = 30 CELSIUS
	optimal_temp = 80 CELSIUS
	overheat_temp = 130 CELSIUS

/datum/chemical_reaction/alkysine
	results = list(/datum/reagent/medicine/alkysine = 2)
	required_reagents = list(/datum/reagent/toxin/acid/hydrochloric = 1, /datum/reagent/ammonia = 1, /datum/reagent/medicine/dylovene = 1)

/datum/chemical_reaction/morphine
	results = list(/datum/reagent/medicine/morphine = 2)
	required_reagents = list(/datum/reagent/carbon = 2, /datum/reagent/hydrogen = 2, /datum/reagent/consumable/ethanol = 1, /datum/reagent/oxygen = 1)
	required_temp = 480

/datum/chemical_reaction/imidazoline
	results = list(/datum/reagent/medicine/imidazoline = 2)
	required_reagents = list(/datum/reagent/carbon = 1, /datum/reagent/phosphorus = 1, /datum/reagent/medicine/dylovene = 1)

/datum/chemical_reaction/peridaxon
	results = list(/datum/reagent/medicine/peridaxon = 2)
	required_reagents = list(/datum/reagent/medicine/bicaridine = 2, /datum/reagent/medicine/clonexadone = 2)
	required_catalysts = list(/datum/reagent/toxin/plasma = 5)

/datum/chemical_reaction/leporazine
	results = list(/datum/reagent/medicine/leporazine = 2)
	required_reagents = list(/datum/reagent/silicon = 1, /datum/reagent/copper = 1)
	required_catalysts = list(/datum/reagent/toxin/plasma = 5)

/datum/chemical_reaction/coagulant
	results = list(/datum/reagent/medicine/coagulant = 2)
	required_reagents = list(/datum/reagent/calcium = 1, /datum/reagent/phosphorus = 1, /datum/reagent/glycerol = 1)

/datum/chemical_reaction/epinephrine
	results = list(/datum/reagent/medicine/epinephrine = 6)
	required_reagents = list(/datum/reagent/diethylamine = 1, /datum/reagent/oxygen = 1, /datum/reagent/chlorine = 1, /datum/reagent/hydrogen = 1)

/datum/chemical_reaction/ephedrine
	results = list(/datum/reagent/medicine/ephedrine = 4)
	required_reagents = list(/datum/reagent/consumable/sugar = 1, /datum/reagent/fuel/oil = 1, /datum/reagent/hydrogen = 1, /datum/reagent/diethylamine = 1)
	mix_message = "The solution fizzes and gives off toxic fumes."
	required_temp = 200
	optimal_temp = 300
	overheat_temp = 500
	temp_exponent_factor = 0.1
	thermic_constant = -0.25
	rate_up_lim = 15

/datum/chemical_reaction/ephedrine/overheated(datum/reagents/holder, datum/equilibrium/equilibrium, vol_added)
	default_explode(holder, equilibrium.reacted_vol, 0, 25)

/datum/chemical_reaction/haloperidol
	results = list(/datum/reagent/medicine/haloperidol = 4)
	required_reagents = list(/datum/reagent/chlorine = 1, /datum/reagent/fluorine = 1, /datum/reagent/aluminium = 1, /datum/reagent/medicine/potass_iodide = 1, /datum/reagent/fuel/oil = 1)

/datum/chemical_reaction/potass_iodide
	results = list(/datum/reagent/medicine/potass_iodide = 2)
	required_reagents = list(/datum/reagent/potassium = 1, /datum/reagent/iodine = 1)
	mix_message = "The solution settles calmly and emits gentle fumes."

/datum/chemical_reaction/salgu_solution
	results = list(/datum/reagent/medicine/saline_glucose = 3)
	required_reagents = list(/datum/reagent/consumable/salt = 1, /datum/reagent/consumable/sugar = 1, /datum/reagent/water = 1)

/datum/chemical_reaction/synthflesh
	results = list(/datum/reagent/medicine/synthflesh = 3)
	required_reagents = list(/datum/reagent/carbon = 1, /datum/reagent/blood = 1, /datum/reagent/medicine/meralyne = 1)
	mix_message = "The mixture bubbles, emitting an acrid reek."

/datum/chemical_reaction/atropine
	results = list(/datum/reagent/medicine/atropine = 4)
	required_reagents = list(/datum/reagent/consumable/ethanol = 1, /datum/reagent/diethylamine = 1, /datum/reagent/acetone = 1, /datum/reagent/phenol = 1, /datum/reagent/toxin/acid = 1)
	mix_message = "A horrid smell like something died drifts from the mixture."

/datum/chemical_reaction/chlorpromazine
	results = list(/datum/reagent/medicine/chlorpromazine = 2)
	required_reagents = list(/datum/reagent/cryptobiolin = 1, /datum/reagent/medicine/haloperidol = 1, /datum/reagent/chlorine = 1)

/datum/chemical_reaction/inacusiate
	results = list(/datum/reagent/medicine/inacusiate = 2)
	required_reagents = list(/datum/reagent/water = 1, /datum/reagent/carbon = 1, /datum/reagent/medicine/dylovene = 1)
	mix_message = "The mixture sputters loudly and becomes a light grey color."
	required_temp = 300
	optimal_temp = 400
	overheat_temp = 500
	temp_exponent_factor = 0.35
	thermic_constant = 20
	rate_up_lim = 3

/datum/chemical_reaction/ipecac
	results = list(/datum/reagent/medicine/ipecac = 2)
	required_reagents = list(/datum/reagent/glycerol = 1, /datum/reagent/consumable/ethanol = 1, /datum/reagent/medicine/dylovene = 1)

/datum/chemical_reaction/charcoal
	results = list(/datum/reagent/medicine/activated_charcoal = 3)
	required_reagents = list(/datum/reagent/ash = 1, /datum/reagent/consumable/salt = 1)
	mix_message = "The mixture yields a fine black powder."
	mix_sound = 'sound/effects/fuse.ogg'

/datum/chemical_reaction/antihol
	results = list(/datum/reagent/medicine/antihol = 2)
	required_reagents = list(/datum/reagent/consumable/ethanol = 1, /datum/reagent/medicine/activated_charcoal = 1)
	mix_message = "A minty and refreshing smell drifts from the effervescent mixture."

/datum/chemical_reaction/diphenhydramine
	results = list(/datum/reagent/medicine/diphenhydramine = 4)
	// Chlorine is a good enough substitute for bromine right?
	required_reagents = list(/datum/reagent/fuel/oil = 1, /datum/reagent/carbon = 1, /datum/reagent/chlorine = 1, /datum/reagent/diethylamine = 1, /datum/reagent/consumable/ethanol = 1)
	mix_message = "The mixture fizzes gently."

/datum/chemical_reaction/styptic_powder
	results = list(/datum/reagent/medicine/styptic_powder = 2)
	required_reagents = list(
		/datum/reagent/aluminium = 1,
		/datum/reagent/hydrogen = 1,
		/datum/reagent/oxygen = 1,
		/datum/reagent/medicine/bicaridine = 1,
	)
	mix_message = "The solution yields an astringent powder."

/datum/chemical_reaction/silver_sulfadiazine
	results = list(
		/datum/reagent/medicine/silver_sulfadiazine = 5,
		/datum/reagent/silicon = 1, // The silicon from the kelotane gets left over.
	)
	// 	C10H9AgN4O2S is the chemical compound for silver sulf in real life. we conveniently have all of these chemicals, so let's replicate it here
	required_reagents = list(
		/datum/reagent/medicine/kelotane = 1, // Kelotane brings the carbon
		/datum/reagent/ammonia = 1, // Ammonia brings the hydrogen and nitrogen
		/datum/reagent/silver = 1,
		/datum/reagent/oxygen = 1,
		/datum/reagent/sulfur = 1
	)
	mix_message = "A strong and cloying odor begins to bubble from the mixture."
