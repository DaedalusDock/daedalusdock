///This file contains all of the relevant code related to the basic steps for salvage, used whenever a salvage structure does not have pre-defined steps.
/// Used in part with /datum/salvage_operation/random primarily.
/// Please speak to Gonenoculer5 (Gonenoculer5#9550 on Discord) before modifying these essential procs, or you will be fed to the Husk Overmind. Thanks!

/datum/salvage_step/cutter
	tools = list(
		TOOL_SALVAGECUTTER = 100
	)
	time = 1

/datum/salvage_step/boltgun
	tools = list(
		TOOL_SALVAGEBOLTGUN = 100
	)
	time = 1

/datum/salvage_step/saw
	tools = list(
		TOOL_SALVAGESAW = 100
	)
	time = 1

/datum/salvage_step/wiretap
	tools = list(
		TOOL_SALVAGEWIRETAP = 100
	)
	time = 1
