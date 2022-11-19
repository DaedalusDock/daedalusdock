/// This file contains the handlers for the following parts of Hardspess:
/// Salvage, salvage tiers, and salvage operators/structures (such as the actual harvestable machinery), and tools used for gathering salvage.

//Iron, glass, titanium, silver, uranium, plasma, gold, diamond, bluespace

///SALVAGE TIERS

///Salvage is split into five tiers, each containing more materials than the prior tier, but in turn being rarer/more difficult to obtain.
///Tier 1 salvage - Iron, glass, titanium.
///Tier 2 salvage - Iron, glass, titanium, silver.
///Tier 3 salvage - Iron, glass, titanium, silver, uranium, plasma.
///Tier 4 salvage - Iron, glass, titanium, silver, uranium, plasma, gold, diamond.
///Tier 5 salvage - Iron, glass, titanium, silver, uranium, plasma, gold, diamond, bluespace.

/obj/item/salvage/
	name = "Abstract Salvage"
	desc = "You shouldn't have this. Make a github issue report if you somehow got this item. Fuck."
	icon = 'icons/obj/device.dmi'
	icon_state = "mining1"
	custom_materials = list(/datum/material/alloy/alien = 2000)
	w_class = WEIGHT_CLASS_TINY

///Tier 1 Salvage Objects
/obj/item/salvage/tier1
	name = "Tier 1 Salvage"

/obj/item/salvage/tier1/circuit
	name = "Burned Circuit Board"
	desc = "A multi-role circuit board. This one appears very badly burned, and neigh useless."

/obj/item/salvage/tier1/copperwire
	name = "Scrap Copper Wire"
	desc = "A one meter length of salvaged copper wiring. Commonly pilfered in old-earth Romania and sold as a commodity for illicit substances."

///Tier 2 Salvage Objects
/obj/item/salvage/tier2
	name = "Tier 2 Salvage"

/obj/item/salvage/tier2/circuit
	name = "Lightly-Singed Circuit Board"
	desc = "A multi-role circuit board. This one appears only lightly burnt, preserving more of its components."

/obj/item/salvage/tier2/copperwire
	name = "Scrap Ti-Al Alloy Wire"
	desc = "A one meter length of salvaged titanium-aluminum alloy wiring. Useful for refining into titanium."

///Tier 3 Salvage Objects
/obj/item/salvage/tier3
	name = "Tier 3 Salvage"

/obj/item/salvage/tier3/circuit
	name = "Circuit Board"
	desc = "A multi-role circuit board. This one appears to be in about average shape, proving to be easier to salvage."

/obj/item/salvage/tier3/copperwire
	name = "Silver-impregnated Ti-Al Alloy Wire"
	desc = "A one meter length of salvaged titanium-aluminum alloy wiring, impregnated with silver for neigh-supercondutor level transmission."

///Tier 4 Salvage Objects
/obj/item/salvage/tier4
	name = "Tier 4 Salvage"

/obj/item/salvage/tier4/circuit
	name = "Well-preserved Circuit Board"
	desc = "A multi-role circuit board. This one appears to be in particularly good shape, providing higher quality materials such as gold."

/obj/item/salvage/tier4/copperwire
	name = "Gold-impregnated Ti-Al Alloy Wire"
	desc = "A one meter length of salvaged titanium-aluminum alloy wiring, impregnated with a silver-gold matrix, capable of handling superconductor cryogenics."

///Tier 5 Salvage Objects
/obj/item/salvage/tier5
	name = "Tier 5 Salvage"

/obj/item/salvage/tier5/circuit
	name = "Pristine Circuit Board"
	desc = "Funne circuit board"

/obj/item/salvage/tier5/copperwire
	name = "Diamond Lattice Fiber Optic"
	desc = "Highly valueable crystal latticed fiber optic's used for transmitting data over long distance."

///Salvage Kits and affiliated

/obj/item/salvage_scanner
	name = "salvage scanner"
	desc = "An advanced tool used for identifying the value of salvage in the field."
	icon = 'icons/obj/device.dmi'
	icon_state = "analyzer"

/obj/item/storage/belt/salvage
	name = "Abstract Salvage Kit"
	desc = "The Kit To Pierce The Heavens. If you have this item please file an issue report."
	icon_state = "explorer1"

/obj/item/storage/belt/salvage/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_w_class = WEIGHT_CLASS_NORMAL
	STR.max_combined_w_class = 21
	STR.set_holdable(list(
		/obj/item/crowbar,
		/obj/item/screwdriver,
		/obj/item/weldingtool,
		/obj/item/wirecutters,
		/obj/item/wrench,
		/obj/item/salvage_scanner
		))

/obj/item/storage/belt/salvage/tier1
	name = "Apprentice Salvage Kit"
	desc = "A low end, cheaply made set of tools designed to be handed out to new-hires for the purpose of preforming salvage operations. Can hold most tools, and has a holster for the salvage scanner."

/obj/item/storage/belt/salvage/tier1/full
	preload = TRUE

/obj/item/storage/belt/salvage/tier1/full/PopulateContents()
	SSwardrobe.provide_type(/obj/item/crowbar/salvage/tier1, src)
	SSwardrobe.provide_type(/obj/item/screwdriver/salvage/tier1, src)
	SSwardrobe.provide_type(/obj/item/weldingtool/salvage/tier1, src)
	SSwardrobe.provide_type(/obj/item/wirecutters/salvage/tier1, src)
	SSwardrobe.provide_type(/obj/item/wrench/salvage/tier1, src)
	SSwardrobe.provide_type(/obj/item/salvage_scanner, src)

/obj/item/storage/belt/salvage/tier1/full/get_types_to_preload()
	var/list/to_preload = list()
	to_preload += /obj/item/crowbar/salvage/tier1
	to_preload += /obj/item/screwdriver/salvage/tier1
	to_preload += /obj/item/weldingtool/salvage/tier1
	to_preload += /obj/item/wirecutters/salvage/tier1
	to_preload += /obj/item/wrench/salvage/tier1
	to_preload += /obj/item/salvage_scanner

	return to_preload

/obj/item/storage/belt/salvage/tier2
	name = "Journeyman Salvage Kit"
	desc = "An intermediate, more advanced set of tools designed for more aptly acquiring harder to get salvage, for the deft worker on the go! Comes with a holster for the salvage scanner."

/obj/item/storage/belt/salvage/tier2/full
	preload = TRUE

/obj/item/storage/belt/salvage/tier2/full/PopulateContents()
	SSwardrobe.provide_type(/obj/item/crowbar/salvage/tier2, src)
	SSwardrobe.provide_type(/obj/item/screwdriver/salvage/tier2, src)
	SSwardrobe.provide_type(/obj/item/weldingtool/salvage/tier2, src)
	SSwardrobe.provide_type(/obj/item/wirecutters/salvage/tier2, src)
	SSwardrobe.provide_type(/obj/item/wrench/salvage/tier2, src)
	SSwardrobe.provide_type(/obj/item/salvage_scanner, src)

/obj/item/storage/belt/salvage/tier2/full/get_types_to_preload()
	var/list/to_preload = list()
	to_preload += /obj/item/crowbar/salvage/tier2
	to_preload += /obj/item/screwdriver/salvage/tier2
	to_preload += /obj/item/weldingtool/salvage/tier2
	to_preload += /obj/item/wirecutters/salvage/tier2
	to_preload += /obj/item/wrench/salvage/tier2
	to_preload += /obj/item/salvage_scanner

	return to_preload

/obj/item/storage/belt/salvage/tier3
	name = "Master Salvage Kit"
	desc = "An advanced, specialized set of powertools expertly crafted for the purpose of acquiring large quantities of high value salvage. Comes with a holster for the salvage scanner."

/obj/item/storage/belt/salvage/tier3/full
	preload = TRUE

/obj/item/storage/belt/salvage/tier3/full/PopulateContents()
	SSwardrobe.provide_type(/obj/item/crowbar/power/salvage, src)
	SSwardrobe.provide_type(/obj/item/screwdriver/power/salvage, src)
	SSwardrobe.provide_type(/obj/item/weldingtool/experimental/salvage, src)
	SSwardrobe.provide_type(/obj/item/salvage_scanner, src)

/obj/item/storage/belt/salvage/tier3/full/get_types_to_preload()
	var/list/to_preload = list()
	to_preload += /obj/item/crowbar/power/salvage
	to_preload += /obj/item/screwdriver/power/salvage
	to_preload += /obj/item/weldingtool/experimental/salvage
	to_preload += /obj/item/salvage_scanner

	return to_preload

///Salvage Tools
///These are essentially a better version of standard tools with explicit bonuses to salvaging.
///I also let borgs have access to salvaging, their tools are considered to be SALVAGE_POWER_LOW, so on part with on-station power tools.

///Tier 1 Salvage Tools
///Tier 1 Salvage tools can get tier 3 and lower salvage.
/obj/item/crowbar/salvage/tier1
	name = "apprentice prybar"
	desc = "A specialized prybar given to licensed Apprentice Salvage Operators, via their Salvage Kit. Reinforced with plastanium chisels for extra force."
	toolspeed = 0.6
	salvage_power = SALVAGE_POWER_MEDIUM

/obj/item/screwdriver/salvage/tier1
	name = "apprentice ratcheting screwdriver"
	desc = "A specialized ratcheting screwdrive given to licensed Apprentice Salvage Operators, via their Salvage Kit. Comes with an extra thin tip for tight grooves."
	toolspeed = 0.6
	salvage_power = SALVAGE_POWER_MEDIUM

/obj/item/weldingtool/salvage/tier1
	name = "apprentice salvage cutter"
	desc = "A specialized salvage beam cutter given to licensed Apprentice Salvage Operators, via their Salvage Kit. Boasts a larger than average fuel capacity."
	toolspeed = 0.6
	heat = 4200
	max_fuel = 30
	salvage_power = SALVAGE_POWER_MEDIUM

/obj/item/wirecutters/salvage/tier1
	name = "apprentice electric wirecutters"
	desc = "A specialized pair of electric wirecutters given to licensed Apprentice Salvage Operators, via their Salvage Kit. Self powered by a small hydrogen cell."
	toolspeed = 0.6
	salvage_power = SALVAGE_POWER_MEDIUM

/obj/item/wrench/salvage/tier1
	name = "apprentice pneumatic wrench"
	desc = "A specialized pneumatic impact-wrench given to licensed Apprentice Salvage Operators, via their Salvage Kit. Connects to the operators RIG for pneumatic driving of bolts."
	toolspeed = 0.6
	salvage_power = SALVAGE_POWER_MEDIUM

///Tier 2 Salvage Tools
///Tier 2 Salvage tools can get tier 4 and lower salvage.
/obj/item/crowbar/salvage/tier2
	name = "journeyman prybar"
	desc = "A specialized prybar given to licensed Journeyman Salvage Operators, via their Salvage Kit. Reinforced with a plasteel core, it is a signifigant improvement over its predecessor."
	toolspeed = 0.4
	salvage_power = SALVAGE_POWER_HIGH

/obj/item/screwdriver/salvage/tier2
	name = "journeyman powered driver"
	desc = "A specialized powered bitdriver given to licensed Journeyman Salvage Operators, via their Salvage Kit. Includes interchangeable bits, and powered driving for faster removal of components."
	toolspeed = 0.4
	salvage_power = SALVAGE_POWER_HIGH

/obj/item/weldingtool/salvage/tier2
	name = "journeyman salvage cutter"
	desc = "A specialized high capacity salvage beam cutter given to licensed Journeyman Salvage Operators, via their Salvage Kit. Boasts a signifigantly larger tank than its predecessors, and burns hotter."
	toolspeed = 0.4
	heat = 4400
	max_fuel = 35
	salvage_power = SALVAGE_POWER_HIGH

/obj/item/wirecutters/salvage/tier2
	name = "journeyman pneumatic wirecutters"
	desc = "A specialized pair of pneumatically driven wirecutters given to licensed Journeyman Salvage Operators, via their Salvage Kit. Makes cutting high gauge wires signifigantly easier."
	toolspeed = 0.4
	salvage_power = SALVAGE_POWER_HIGH

/obj/item/wrench/salvage/tier2 //Totally not a thinly veiled Prey reference. Not at all.
	name = "journeyman dyn-spanner"
	desc = "A specialized dynamic spanner given to licensed Journeyman Salvage Operators, via their Salvage Kit. It can dynamically adjust size to any bolt, and is weighty enough to make a decent weapon in a pinch."
	toolspeed = 0.4
	force = 8
	throwforce = 10
	salvage_power = SALVAGE_POWER_HIGH

///Tier 3 Salvage tools
///Tier 3 Salvage tools can get tier 5 and lower salvage.
/obj/item/crowbar/power/salvage
	name = "master salvage jaws"
	desc = "A pair of highly specialized salvage jaws given only to licensed Master Salvage Operators, via their Salvage Kit. It can swap toolheads internally to be used as either a prying tool or a pair of hydraulic wirecutters."
	toolspeed = 0.2
	salvage_power = SALVAGE_POWER_MAX

/obj/item/screwdriver/power/salvage
	name = "master salvage impact"
	desc = "A highly specialized self-powered impact gun given only to licensed Master Salvage Operators, via their Salvage Kit. It can swap toolheads internally to be used as either a high strength drill or an impact driver."
	toolspeed = 0.2
	salvage_power = SALVAGE_POWER_MAX

/obj/item/weldingtool/experimental/salvage
	name = "master salvage cutter"
	desc = "A highly specialized beam cutter given to licensed Master Salvage Operators, via their Salvage Kit. It is capable of a much hotter beam, resulting in faster cutting times, whilst also being able to self-refuel its large internal resivoir."
	toolspeed = 0.2
	heat = 4500
	max_fuel = 40
	salvage_power = SALVAGE_POWER_MAX

///Salvageable Structures

/obj/structure/salvage
	name = "Abstract Salvage"
	desc = "You shouldn't see this. Make a github issue report if you somehow see this structure. Fuck."
	density = TRUE
	anchored = TRUE
	var/sal_state = UNHARVESTED

/obj/structure/salvage/attackby(obj/item/W, mob/user, params)
	user.changeNext_move(CLICK_CD_MELEE)
	if (!ISADVANCEDTOOLUSER(user))
		to_chat(user, span_warning("You don't have the dexterity to do this!")) //If a fucking rabbit somehow manages to get to the hulk, god help them.
		return

	//get the user's location
	if(!isturf(user.loc))
		return //can't do this stuff whilst inside objects and such

	add_fingerprint(user)
	try_salvage(W, user)

/obj/structure/salvage/examine(mob/user)
	. = ..()
	. += deconstruction_hints(user)

/obj/structure/salvage/proc/deconstruction_hints(mob/user)
	switch(sal_state)
		if(UNHARVESTED)
			return span_notice("You could probably cut open its panel with a <b>welding tool..</b>")
		if(CUT)
			return span_notice("It looks like you could <b>unscrew</b> a few salvageable components here..")
		if(HARVEST1)
			return span_notice("It looks like you could remove some salvageable material with a <b>prying</b> tool..")
		if(HARVEST2)
			return span_notice("It looks like you could undo some <b>bolts</b> on some components here..")
		if(HARVEST3)
			return span_notice("It looks like you could snip some <b>wires</b> here..")
		if(EMPTY)
			return span_notice("It looks like you've taken everything you can from this. <b>It is empty of useful salvage.</b>")

/obj/structure/salvage/proc/try_salvage(obj/item/tool, mob/user)
	switch(sal_state)
		if(EMPTY)
			to_chat(user, span_warning("Theres nothing left to harvest in the [src]!"))
		if(UNHARVESTED)
			if(tool.tool_behaviour == TOOL_WELDER)
				to_chat(user, span_notice("You start to cut the shell open..."))
				if(tool.use_tool(src, user, 40, volume=100))
					if(!istype(src, /obj/structure/salvage) || sal_state != UNHARVESTED)
						return TRUE
					tool.play_tool_sound(src, 100)
					sal_state = CUT
					to_chat(user, span_notice("You cut the shell of the [src] open."))
		if(CUT)
			if(tool.tool_behaviour == TOOL_SCREWDRIVER)
				to_chat(user, span_notice("You start to unscrew the component..."))
				if(tool.use_tool(src, user, 40, volume=100))
					if(!istype(src, /obj/structure/salvage) || sal_state != CUT)
						return TRUE
					tool.play_tool_sound(src, 100)
					sal_state = HARVEST1
					to_chat(user, span_notice("You remove some harvestable components from the [src]. <b>Theres still plenty left to harvest.</b>"))
		if(HARVEST1)
			if(tool.tool_behaviour == TOOL_CROWBAR)
				to_chat(user, span_notice("You start to pry out the component..."))
				if(tool.use_tool(src, user, 40, volume=100))
					if(!istype(src, /obj/structure/salvage) || sal_state != HARVEST1)
						return TRUE
					tool.play_tool_sound(src, 100)
					sal_state = HARVEST2
					to_chat(user, span_notice("You remove some harvestable components from the [src]. <b>Theres still some left to harvest.</b>"))
		if(HARVEST2)
			if(tool.tool_behaviour == TOOL_WRENCH)
				to_chat(user, span_notice("You start to unwrench the component..."))
				if(tool.use_tool(src, user, 40, volume=100))
					if(!istype(src, /obj/structure/salvage) || sal_state != HARVEST2)
						return TRUE
					tool.play_tool_sound(src, 100)
					sal_state = HARVEST3
					to_chat(user, span_notice("You remove some harvestable components from the [src]. <b>Theres very little left to harvest.</b>"))
		if(HARVEST3)
			if(tool.tool_behaviour == TOOL_WIRECUTTER)
				to_chat(user, span_notice("You start to excise the component..."))
				if(tool.use_tool(src, user, 40, volume=100))
					if(!istype(src, /obj/structure/salvage) || sal_state != HARVEST3)
						return TRUE
					tool.play_tool_sound(src, 100)
					sal_state = EMPTY
					to_chat(user, span_notice("You remove some harvestable components from the [src]. <b>Theres nothing left to harvest.</b>"))

/obj/structure/salvage/terminal
	name = "Debug Terminal"
	desc = "Salvage structure debug object. Used for testing if salvaging actually works, lmao."
	icon = 'icons/obj/computer.dmi'
	icon_state = "computer_broken"

/obj/structure/salvage/machine
	name = "Debug Machine"
	desc = "Salvage structure debug object. Used for testing if salvaging actually works, lmao."
	icon = 'icons/obj/machines/dominator.dmi'
	icon_state = "dominator-Blue"

/obj/structure/salvage/wildcard
	name = "Debug Wildcard"
	desc = "Salvage structure debug object. Used for testing if salvaging actually works, lmao."
	icon = 'icons/obj/machines/particle_accelerator.dmi'
	icon_state = "control_boxp3"
