///Contains all the associated code of deconstructing salvageable objects, deconstruction steps, salvage object abstracts, salvage object spawners, etc.

//How does Salvaging work?
//When a salvageable structure is generated it will be assigned an initial random deconstruction state from a list of eight, and set its hint.
//This state will then change to one of 8 random deconstruction steps, returning salvage upon completing the do_after()
//After salvaging from a structure, the remaining_attempts variable will be reduced by one.
//Salvage is dropped ontop of the structure's turf, to be collected by the operator.
//If remaining_attempts = 0 then set state to empty and prevent further salvage procs from being called.

///Salvageable machinery abstract, anything that returns salvage should be a subtype of this.
/obj/structure/salvage
	name = "Salvage Struct Abstract"
	desc = "If your seeing this, let a developer know, because something has gone terribly fucky."
	icon = 'icons/obj/structures.dmi'
	icon_state = "wall_gear"

	///Operation datum created on init
	var/datum/salvage_operation/current_operation = /datum/salvage_operation/random
	///Amount of remaining salvage attempts before the structure is empty and can be deconstructed.
	var/remaining_attempts = 0
	///How complex is the given structure, and as a result, how difficult is it to get useful salvage from? Modifies probability of successful salvage.
	var/salvage_difficulty = SALVAGE_DIFFICULTY_EFFORTLESS
	///Boolean determining if the salvageable object is empty and can be scrapped for materials. Used in the step hints proc.
	var/is_empty = FALSE
	///What junk salvage can drop from this object upon partial success?
	var/list/junk_salvage = list(
		/obj/item/salvage = 1
	)
	///What common salvage can drop from this object upon success?
	var/list/common_salvage = list(
		/obj/item/salvage = 3
	)
	///What rare salvage can drop from this object upon bonus success?
	var/list/rare_salvage = list(
		/obj/item/salvage = 5
	)

/obj/structure/salvage/Initialize(mapload)
	. = ..()
	if(ispath(current_operation))
		current_operation = new current_operation

/obj/structure/salvage/examine(mob/user)
	. += ..()
	. += step_hints(user)

/obj/structure/salvage/proc/step_hints(mob/user)
	if(remaining_attempts > 0)
		return span_notice("Placeholder")
	else
		return span_notice("[src] is just a bare frame. You can scrap it for materials with a <i>cutting implement.</i>")

/obj/structure/salvage/attackby(obj/item/tool, mob/user)
	if(target.remaining_attempts == 0 && tool.tool_behaviour != TOOL_WELDER && tool.tool_behaviour != TOOL_SALVAGECUTTER) //Is there anything left to salvage?
		to_chat(user,span_warning("[target] is just a bare frame. You can scrap it for materials with a <i>cutting implement.</i>"))
		return

	if(target.remaining_attempts == 0 && tool.tool_behaviour == TOOL_WELDER || tool.tool_behaviour == TOOL_SALVAGECUTTER)
		to_chat(user,span_notice("You start cutting [target] apart for materials.."))
		do_after(user,5 SECONDS, target)
		to_chat(user,span_notice("You cut [target] apart for materials."))
		new /obj/item/stack/sheet(src,5)
		new /obj/item/stack/sheet/glass(src,2)

	if(!(tool.tool_behaviour in tools)) //Is obj/item/tool a valid tool for the step?
		to_chat(user,span_warning("[tool] doesn't seem to be suited for salvaging [target].."))
		return
	else
		current_operation.current_step.try_salvage(user,tool,src)
	else
		to_chat(user, span_warning("This doesn't look like it would work for this purpose.."))
