///This file contains all of the relevant code related to the abstract datums, procs, and similar for handling how salvage is created, such as:
/// - /datum/salvage_operation - Abstract for step holders
/// - /datum/salvage_step - Abstract for steps
/// - /datum/salvage_step/proc/try_salvage - Proc to check to see if tools and states are valid
/// - /datum/salvage_step/proc/drop_salvage - Drop salvage based on chance to succeed depending on difficulty, success chance, and success modifier.
/// Please speak to Gonenoculer5 (Gonenoculer5#9550 on Discord) before modifying these essential procs, or you will be fed to the Husk Overmind. Thanks!





///Abstract datum for storing groups of steps which are referenced for deconstruction and returning salvage upon completion. Primarily used for static step lists.
/datum/salvage_operation
	var/abstract_type = /datum/salvage_operation ///Defines the abstract type
	var/name = "Salvage Operation Abstract" ///Name of the step
	var/list/steps = list(/datum/salvage_operation/random) ///List of steps to complete the salvage. Defaults to random.
	var/current_step ///Defines what the current step of an operation is. Used for examine hints in /obj/structure/salvage/proc/step_hints().

///Detect the basetype (or sub-basetypes) easily
/datum/salvage_operation/proc/is_abstract()
	return abstract_type == type

///Default salvage operation for any obj/structure/salvage that does not otherwise have a defined /datum/salvage_operation subtype requrement.
/datum/salvage_operation/random
	name = "Random Steps"
	var/steps_count = 8 ///Number of random steps. Default is 8, as the minimum number of operations is eight.

/datum/salvage_operation/random/New() //Picks a random step from all available subtypes of /datum/salvage_step stored in SShardspace.steptypes. Might make this a for loop later but this works.
	while(steps_count > steps.len)
		var/big_steppy = pick(SShardspace.steptypes)
		steps += big_steppy

///Abstract datum for individual steps, which are stored in a list within a /datum/salvage_operation/ subtype.
/datum/salvage_step
	var/abstract_type = /datum/salvage_step ///Defines the abstract of a step.
	var/list/tools = list() ///Defines what tools are valid for completing this step, and their success rate, in the format of list(tool1 = 100,TOOL2_BEHAVIOR = 50, etc.) Accepts defines as valid entries, do not put typepaths here please.
	var/time = 5 SECONDS ///How long it takes to complete the step, in seconds. Default is 5 SECONDS.

///Detect the basetype (or sub-basetypes) easily.
/datum/salvage_step/proc/is_abstract()
	return abstract_type == type

///Try to salvage something from the structure.
/datum/salvage_step/proc/try_salvage(mob/user, obj/item/tool, obj/structure/salvage/target)
	if(target.remaining_attempts == 0 && tool.tool_behaviour != TOOL_WELDER && tool.tool_behaviour != TOOL_SALVAGECUTTER) //Is there anything left to salvage?
		to_chat(user,span_warning("[target] is just a bare frame. You can scrap it for materials with a <i>cutting implement.</i>"))
		return

	if(target.remaining_attempts == 0 && tool.tool_behaviour == TOOL_WELDER && tool.tool_behaviour == TOOL_SALVAGECUTTER)
		to_chat(user,span_notice("You start cutting [target] apart for materials.."))
		do_after(user,5 SECONDS, target)
		to_chat(user,span_notice("You cut [target] apart for materials."))
		new /obj/item/stack/sheet(src,5)
		new /obj/item/stack/sheet/glass(src,2)

	if(!(tool.tool_behaviour in tools)) //Is obj/item/tool a valid tool for the step?
		to_chat(user,span_warning("[tool] doesn't seem to be suited for salvaging [target].."))
		return

	do_after(user,time,target)
	drop_salvage(user, tool, target)

///Try to drop salvage onto the ground, depending on if the user failed or succeeded in salvaging, depending on the tool = probability list.
/datum/salvage_step/proc/drop_salvage(mob/user, obj/item/tool, obj/structure/salvage/target)
	var/difficulty = target.salvage_difficulty //Holds the value of var/salvage_difficulty for math purposes.
	var/success_chance = tools[tool.tool_behaviour] //Holds the value of what the tools list's respective value is, from the list. I.e TOOL_SALVAGECUTTER = 100 would translate to successrate = 100.
	var/success_modifier = tool.success_modifier //Holds the value of the tools flat modifier to its success rate, added on after initial calculation.
	var/prob_result = ((success_chance*difficulty)+success_modifier) //Final number for probability of sucessfully getting something, getting everything, and getting a bonus. See salvage.dm for more information on how this all works together.
	var/bonus_success = FALSE //Did we get a bonus drop due to having an advanced tool?
	var/success = FALSE //Did we successfully salvage all of it?
	var/partial_success = FALSE //Did we successfully salvage anything at all?

	switch(prob_result)
		if(0 to 20)
			to_chat(user,span_warning("You completely fumble with [tool], destroying any useable salvage you could have gotten from [target] this time."))

		if(21 to 40)
			partial_success = TRUE

		if(41 to 60)
			success = TRUE

		if(60 to 100)
			var/luck = rand(1,2)
			if(luck > 1)
				bonus_success = TRUE
			success = TRUE

		if(101 to INFINITY)
			var/luck = rand(1,5)
			if(luck > 2)
				bonus_success = TRUE
			success = TRUE

	if(partial_success) //Gives the user a roll of junk salvage for partially succeeding.
		to_chat(user,span_notice("You manage to remove a small amount of salvage from [target], successfully."))
		var/picked_path = pick(target.junk_salvage)
		for(var/i in 1 to target.junk_salvage[picked_path])
			new picked_path(get_turf(src))

	if(success) //Gives the user a roll of salvage for succeeding.
		to_chat(user,span_notice("You manage to remove some salvage from [target] successfully."))
		if(difficulty > 30)
			var/picked_path = pick(target.common_salvage)
			for(var/i in 1 to target.common_salvage[picked_path])
				new picked_path(get_turf(src))
		else
			var/picked_path = pick(target.rare_salvage)
			for(var/i in 1 to target.rare_salvage[picked_path])
				new picked_path(get_turf(src))

	if(bonus_success) //Gives the user an additional roll of salvage for using a better tool.
		to_chat(user,span_notice("You managed to remove some additional salvage from [target]!"))
		var/picked_path = pick(target.common_salvage)
		for(var/i in 1 to target.common_salvage[picked_path])
			new picked_path(get_turf(src))

	target.remaining_attempts-- //Whether they failed or succeeded, remaining_attempts MUST increment by one.
	if(target.remaining_attempts == 0)
		target.is_empty = TRUE
