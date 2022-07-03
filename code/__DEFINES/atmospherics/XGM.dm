// XGM gas flags.
#define XGM_GAS_FUEL        (1<<0)
#define XGM_GAS_OXIDIZER    (1<<1)
#define XGM_GAS_CONTAMINANT (1<<2)
#define XGM_GAS_FUSION_FUEL (1<<3)
#define XGM_GAS_NOBLE		(1<<4)
#define XGM_GAS_COMMON		(1<<5)

//"Common" station gases.
#define GAS_OXYGEN				"oxygen"
#define GAS_NITROGEN			"nitrogen"
#define GAS_CO2					"carbon_dioxide"
#define GAS_N2O					"sleeping_agent"
#define GAS_PLASMA				"plasma"
#define GAS_STEAM				"water"

//Gases for use with the SM or R-UST
#define GAS_HYDROGEN			"hydrogen" //H
#define GAS_DEUTERIUM			"deuterium" //2H
#define GAS_TRITIUM				"tritium" //3H

//Noble gases
#define GAS_BORON				"boron"
#define GAS_HELIUM				"helium"
#define GAS_ARGON				"argon"
#define GAS_KRYPTON				"krypton"
#define GAS_NEON				"neon"
#define GAS_XENON				"xenon"

//Random bullshit for random gases, feel free to use elsewhere.
#define GAS_AMMONIA				"ammonia"
#define GAS_CHLORINE			"chlorine"
#define GAS_SULFUR				"sulfurdioxide"
#define GAS_METHANE				"methane"

//Random bullshit: compound edition
#define GAS_METHYL_BROMIDE		"methyl_bromide"
#define GAS_NO					"nitricoxide"
#define GAS_NO2					"nitrodioxide"
#define GAS_CO					"carbon_monoxide"

//A placeholder for a random gas generated each round.
#define GAS_ALIEN				"aliether"

///All gases that are not placeholders.
#define ASSORTED_GASES (xgm_gas_data.gases - GAS_ALIEN)
///All gases that a player will reliably encounter every round or close to it.
GLOBAL_LIST_EMPTY(common_gases) //Filled in by xgm_gas_data/New()
///All the noble gases.
GLOBAL_LIST_EMPTY(noble_gases) //Filled in by xgm_gas_data/New()
