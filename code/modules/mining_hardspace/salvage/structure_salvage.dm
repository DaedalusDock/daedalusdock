///Contains all the associated code of deconstructing salvageable objects, deconstruction steps, salvage object abstracts, salvage object spawners, etc.

//How does Salvaging work?
//When a salvageable structure is generated it will be assigned an initial random deconstruction state from a list of eight, and set its hint.
//This state will then change to one of 8 random deconstruction steps, returning salvage upon completing the do_after()
//After salvaging from a structure, the remaining_attempts variable will be reduced by one.
//Salvage is dropped ontop of the structure's turf, to be collected by the operator.
//If remaining_attempts = 0 then set state to empty and prevent further salvage procs from being called.

///Salvageable machinery abstract, anything that returns salvage should be a subtype of this.
/obj/structure/salvage/
	name = "Salvage Struct Abstract"
	desc = "If your seeing this, let a developer know, because something has gone terribly fucky."
	icon = 'icons/obj/structures.dmi'
	icon_state = "wall_gear"

	var/remaining_attempts = 0 //Amount of remaining salvage attempts before the structure is empty and can be deconstructed.

///Abstract Salvage Step core datum
/datum/salvage_step
	var/name
	var/list/tools = list()
	var/tool_type = null
	var/time = 10

/datum/salvage_step/cutter
	name = "cut"
	tools = list(
		TOOL_SALVAGECUTTER = 100,
		TOOL_WELDER = 20
	)
	time = 20

/datum/salvage_step/boltgun
	name = "bolt"
	tools = list(
		TOOL_SALVAGEBOLTGUN = 100
	)
	time = 20

/datum/salvage_step/saw
	name = "saw"
	tools = list(
		TOOL_SALVAGESAW = 100
	)
	time = 20

/datum/salvage_step/wiretap
	name = "wiretap"
	tools = list(
		TOOL_SALVAGEWIRETAP = 100
		TOOL_MULTITOOL = 10 //Not complicated enough to do the task but she'll try her damndest
	)
	time = 20

///Abstract datum for salvage itself, equivilent of /datum/surgery/ for example.
/datum/salvage
	var/name = "salvage abstract" //name of a given salvage
	var/list/steps = list()
