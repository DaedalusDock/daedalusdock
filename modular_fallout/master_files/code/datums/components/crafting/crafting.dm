/datum/component/personal_crafting/get_surroundings(atom/a)
	.=..()

	for(var/obj/machinery/M in get_environment(a))
		if(M.machine_tool_behaviour)
			.["tool_behaviour"] += M.machine_tool_behaviour
			.["other"][M.type] += 1

/datum/component/personal_crafting/check_tools(atom/a, datum/crafting_recipe/R, list/contents)
	.=..()
	for(var/obj/machinery/M in a.contents)
		present_qualities.Add(M.machine_tool_behaviour)
