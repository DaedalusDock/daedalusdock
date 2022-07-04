//WHEN ADDING A NEW GAS, ADD IT TO constants.js!!

/datum/xgm_gas/alium
	id = GAS_ALIEN
	name = "Aliether"
	hidden_from_codex = TRUE
	symbol_html = "X"
	symbol = "X"

/datum/xgm_gas/alium/New()
	var/num = rand(100,999)
	name = "Compound #[num]"
	specific_heat = rand(1, 400)	// J/(mol*K)
	molar_mass = rand(20,800)/1000	// kg/mol
	if(prob(40))
		flags |= XGM_GAS_FUEL
	else if(prob(40)) //it's prooobably a bad idea for gas being oxidizer to itself.
		flags |= XGM_GAS_OXIDIZER
	if(prob(40))
		flags |= XGM_GAS_CONTAMINANT
	if(prob(40))
		flags |= XGM_GAS_FUSION_FUEL
	if(!flags)
		flags |= XGM_GAS_NOBLE

	symbol_html = "X<sup>[num]</sup>"
	symbol = "X-[num]"
	if(prob(50))
		tile_color = RANDOM_RGB
		overlay_limit = 0.5

//COMMON GASES
/datum/xgm_gas/oxygen
	id = GAS_OXYGEN
	name = "Oxygen"
	specific_heat = 20	// J/(mol*K)
	molar_mass = 0.032	// kg/mol
	flags = XGM_GAS_OXIDIZER | XGM_GAS_FUSION_FUEL | XGM_GAS_COMMON
	symbol_html = "O<sub>2</sub>"
	symbol = "O2"
	purchaseable = TRUE
	base_value = 0.2

/datum/xgm_gas/nitrogen
	id = GAS_NITROGEN
	name = "Nitrogen"
	specific_heat = 20	// J/(mol*K)
	molar_mass = 0.028	// kg/mol
	flags = XGM_GAS_COMMON
	symbol_html = "N<sub>2</sub>"
	symbol = "N2"
	purchaseable = TRUE
	base_value = 0.1

/datum/xgm_gas/carbon_dioxide
	id = GAS_CO2
	name = "Carbon Dioxide"
	specific_heat = 30	// J/(mol*K)
	molar_mass = 0.044	// kg/mol
	flags = XGM_GAS_COMMON
	symbol_html = "CO<sub>2</sub>"
	symbol = "CO2"
	purchaseable = TRUE
	base_value = 0.2

/datum/xgm_gas/sleeping_agent
	id = GAS_N2O
	name = "Nitrous Oxide"
	specific_heat = 40	// J/(mol*K)
	molar_mass = 0.044	// kg/mol. N2O
	tile_overlay = "sleeping_agent"
	overlay_limit = 0.5
	flags = XGM_GAS_OXIDIZER | XGM_GAS_COMMON //N2O is a powerful oxidizer
	//breathed_product = /datum/reagent/nitrous_oxide
	symbol_html = "N<sub>2</sub>O"
	symbol = "N2O"
	base_value = 3

/datum/xgm_gas/vapor
	id = GAS_STEAM
	name = "Steam"
	tile_overlay = "generic"
	overlay_limit = 0.5
	specific_heat = 30	// J/(mol*K)
	molar_mass = 0.020	// kg/mol
	flags = XGM_GAS_COMMON
	breathed_product = /datum/reagent/water
	condensation_point = 308.15 // 35C. Dew point is ~20C but this is better for gameplay considerations.
	symbol_html = "H<sub>2</sub>O"
	symbol = "H2O"

/datum/xgm_gas/phoron
	id = GAS_PLASMA
	name = "Plasma"

	//Note that this has a significant impact on TTV yield.
	//Because it is so high, any leftover phoron soaks up a lot of heat and drops the yield pressure.
	specific_heat = 200	// J/(mol*K)

	//Hypothetical group 14 (same as carbon), period 8 element.
	//Using multiplicity rule, it's atomic number is 162
	//and following a N/Z ratio of 1.5, the molar mass of a monatomic gas is:
	molar_mass = 0.405	// kg/mol

	tile_overlay = "plasma"
	overlay_limit = MOLES_PHORON_VISIBLE
	flags = XGM_GAS_FUEL | XGM_GAS_CONTAMINANT | XGM_GAS_FUSION_FUEL | XGM_GAS_COMMON
	breathed_product = /datum/reagent/toxin/plasma
	symbol_html = "Ph"
	symbol = "Ph"
	base_value = 2

//SM & R-UST GASES
/datum/xgm_gas/hydrogen
	id = GAS_HYDROGEN
	name = "Hydrogen"
	specific_heat = 100	// J/(mol*K)
	molar_mass = 0.002	// kg/mol
	flags = XGM_GAS_FUEL|XGM_GAS_FUSION_FUEL
	burn_product = GAS_STEAM
	symbol_html = "H<sub>2</sub>"
	symbol = "H2"

/datum/xgm_gas/hydrogen/deuterium
	id = GAS_DEUTERIUM
	name = "Deuterium"
	specific_heat = 80
	molar_mass = 0.004
	symbol_html = "<sup>2</sup>H"
	symbol = "2H"

/datum/xgm_gas/hydrogen/tritium
	id = GAS_TRITIUM
	name = "Tritium"
	molar_mass = 0.006
	specific_heat = 60
	symbol_html = "<sup>3</sup>H"
	symbol = "T"

//NOBLE GASES
/datum/xgm_gas/helium
	id = GAS_HELIUM
	name = "Helium"
	specific_heat = 80	// J/(mol*K)
	molar_mass = 0.004	// kg/mol
	flags = XGM_GAS_FUSION_FUEL | XGM_GAS_NOBLE
	symbol_html = "He"
	symbol = "He"

/datum/xgm_gas/argon
	id = GAS_ARGON
	name = "Argon"
	specific_heat = 10	// J/(mol*K)
	molar_mass = 0.018	// kg/mol
	flags = XGM_GAS_NOBLE
	symbol_html = "Ar"
	symbol = "Ar"
	purchaseable = TRUE
	base_value = 0.2

// If narcosis is ever simulated, krypton has a narcotic potency seven times greater than regular airmix.
/datum/xgm_gas/krypton
	id = GAS_KRYPTON
	name = "Krypton"
	specific_heat = 5	// J/(mol*K)
	molar_mass = 0.036	// kg/mol
	flags = XGM_GAS_NOBLE
	symbol_html = "Kr"
	symbol = "Kr"
	purchaseable = TRUE
	base_value = 0.2

/datum/xgm_gas/neon
	id = GAS_NEON
	name = "Neon"
	specific_heat = 20	// J/(mol*K)
	molar_mass = 0.01	// kg/mol
	flags = XGM_GAS_NOBLE
	symbol_html = "Ne"
	symbol = "Ne"
	purchaseable = TRUE
	base_value = 0.2

/datum/xgm_gas/xenon
	id = GAS_XENON
	name = "Xenon"
	specific_heat = 3	// J/(mol*K)
	molar_mass = 0.054	// kg/mol
	flags = XGM_GAS_NOBLE
	breathed_product = /datum/reagent/nitrous_oxide/xenon
	symbol_html = "Xe"
	symbol = "Xe"
	purchaseable = TRUE
	base_value = 5

/datum/xgm_gas/boron
	id = GAS_BORON
	name = "Boron"
	specific_heat = 11
	molar_mass = 0.011
	flags = XGM_GAS_FUSION_FUEL | XGM_GAS_NOBLE
	breathed_product = /datum/reagent/toxin/boron
	symbol_html = "B"
	symbol = "B"

//MISC ELEMENTS
/datum/xgm_gas/methane
	id = GAS_METHANE
	name = "Methane"
	specific_heat = 30	// J/(mol*K)
	molar_mass = 0.016	// kg/mol
	flags = XGM_GAS_FUEL
	symbol_html = "CH<sub>4</sub>"
	symbol = "CH4"

/datum/xgm_gas/ammonia
	id = GAS_AMMONIA
	name = "Ammonia"
	specific_heat = 20	// J/(mol*K)
	molar_mass = 0.017	// kg/mol
	breathed_product = /datum/reagent/ammonia
	symbol_html = "NH<sub>3</sub>"
	symbol = "NH3"

/datum/xgm_gas/chlorine
	id = GAS_CHLORINE
	name = "Chlorine"
	tile_color = "#c5f72d"
	overlay_limit = 0.5
	specific_heat = 5	// J/(mol*K)
	molar_mass = 0.017	// kg/mol
	tile_overlay = "chlorine"
	overlay_limit = 0.1
	flags = XGM_GAS_OXIDIZER
	breathed_product = /datum/reagent/chlorine
	symbol_html = "Cl"
	symbol = "Cl"
	purchaseable = TRUE
	base_value = 7

//MISC COMPOUNDS
/datum/xgm_gas/methyl_bromide
	id = GAS_METHYL_BROMIDE
	name = "Methyl Bromide"
	specific_heat = 42.59 // J/(mol*K)
	molar_mass = 0.095 // kg/mol
	//breathed_product = /datum/reagent/toxin/methyl_bromide
	symbol_html = "CH<sub>3</sub>Br"
	symbol = "CH3Br"

/datum/xgm_gas/nitrodioxide
	id = GAS_NO2
	name = "Nitrogen Dioxide"
	tile_color = "#ca6409"
	specific_heat = 37	// J/(mol*K)
	molar_mass = 0.054	// kg/mol
	flags = XGM_GAS_OXIDIZER
	breathed_product = /datum/reagent/toxin
	symbol_html = "NO<sub>2</sub>"
	symbol = "NO2"

/datum/xgm_gas/nitricoxide
	id = GAS_NO
	name = "Nitric Oxide"
	specific_heat = 10	// J/(mol*K)
	molar_mass = 0.030	// kg/mol
	flags = XGM_GAS_OXIDIZER
	symbol_html = "NO"
	symbol = "NO"

/datum/xgm_gas/sulfurdioxide
	id = GAS_SULFUR
	name = "Sulfur Dioxide"
	specific_heat = 30	// J/(mol*K)
	molar_mass = 0.044	// kg/mol
	symbol_html = "SO<sub>2</sub>"
	symbol = "SO2"

/datum/xgm_gas/carbon_monoxide
	id = GAS_CO
	name = "Carbon Monoxide"
	specific_heat = 30	// J/(mol*K)
	molar_mass = 0.028	// kg/mol
	breathed_product = /datum/reagent/carbon_monoxide
	symbol_html = "CO"
	symbol = "CO"

