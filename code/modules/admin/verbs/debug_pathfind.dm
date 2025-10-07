
#ifdef DEBUG_PATHFINDING

GLOBAL_LIST(__pathfinding_debug_info)
GLOBAL_VAR_INIT(__pathfinding_debug_generate, FALSE)
// Start and clear the pathfinding debug info.
#define START_PATH_DEBUG GLOB.__pathfinding_debug_generate = TRUE; GLOB.__pathfinding_debug_info = null
#define STOP_PATH_DEBUG GLOB.__pathfinding_debug_generate = FALSE

#else

#define START_PATH_DEBUG
#define STOP_PATH_DEBUG

#endif

/client/proc/debug_pathfinding(turf/T as null|turf in world)
	set name = "Pathfind To..."
	set category = "Debug"

	if(!check_rights(R_DEBUG))
		return

	// If executed with no argument (Via Command element), and they have a marked datum, use that.
	if(!T && usr.client.holder.marked_datum)
		T = usr.client.holder.marked_datum
	else if(!T)
		to_chat(usr, span_warning("No turf marked or targeted."))
		return
	//If the user's marked datum is a turf, ask to use that instead of the click target.
	else if(isturf(usr.client.holder.marked_datum))
		T = (tgui_alert(
			usr,
			"Your marked datum, ([usr.client.holder.marked_datum]), is a turf. Do you want to path to that instead?",
			"Marked Datum Query",
			list("Yes", "No")) == "Yes") ? usr.client.holder.marked_datum : T

	var/method = tgui_input_list(usr, "Pathfinding Method", "Pathfind To...", list("AStar", "JPS"))
	if(!method)
		return

	var/include_diagonals = tgui_alert(usr, "Include diagonals?", "Pathfind To...", list("Yes", "No")) == "Yes"

	var/datum/callback/path_heuristic
	if(method == "AStar")
		#define CHEBYSHEV "Chebyshev - get_dist"
		#define EUCLIDEAN "Euclidean - get_dist_euclidean"
		#define MANHATTAN "Manhattan - get_dist_manhattan"
		#define OCTILE "Octile - get_dist_octile - Experimental"
		path_heuristic = tgui_input_list(usr, "Choose Heuristic", "Cost Judgement",
			list(
				CHEBYSHEV,
				EUCLIDEAN,
				MANHATTAN,
				OCTILE
				)
			)
		switch(path_heuristic)
			if(CHEBYSHEV)
				path_heuristic = CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(_get_dist)) //Uses the SDQL2 wrapper for Internal Reasons:tm:
			if(EUCLIDEAN)
				path_heuristic = CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(get_dist_euclidean))
			if(MANHATTAN)
				path_heuristic = CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(get_dist_manhattan))
			if(OCTILE)
				path_heuristic = CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(get_dist_octile))
			else
				CRASH("Debug pathfind ended up with invalid heuristic: [path_heuristic]")

		#undef CHEBYSHEV
		#undef EUCLIDEAN
		#undef MANHATTAN
		#undef OCTILE

	var/static/list/images
	var/list/path

	var/list/access = null
	if(isliving(usr))
		var/mob/living/L = usr
		access = L.get_idcard()?.GetAccess()

	var/time = world.timeofday
	START_PATH_DEBUG //Enable node list dumping.
	switch(method)
		if("AStar")
			path = SSpathfinder.astar_pathfind_now(usr, T, 100, 0, access, TRUE, null, FALSE, include_diagonals, path_heuristic)

		if("JPS")
			path = SSpathfinder.jps_pathfind_now(usr, T, 100, 0, access, TRUE, TRUE, FALSE, include_diagonals ? DIAGONAL_REMOVE_CLUNKY : DIAGONAL_REMOVE_ALL)
	STOP_PATH_DEBUG //Disable node list dumping.

	if(!length(path))
		to_chat(usr, span_alert("Pathfinding could not be completed."))
		return

	to_chat(usr, span_info("Path length [path.len] took [(world.timeofday - time) / 10] seconds to complete."))

	LAZYINITLIST(images)
	if(length(images))
		for(var/image/I as anything in images)
			usr.client.images -= I

	for(var/index in 1 to path.len)
		var/turf/current_turf = path[index]
		var/image/path_display
		if(index == 1)
			path_display = image('icons/turf/floors.dmi', current_turf, "pure_white")
			path_display.plane = ABOVE_LIGHTING_PLANE
			path_display.alpha = 200
			path_display.color = "#FF0000"
			path_display.layer = 2 // Render above whiteness, but below maptext.

		else if(index == path.len)
			path_display = image('icons/turf/floors.dmi', current_turf, "pure_white")
			path_display.plane = ABOVE_LIGHTING_PLANE
			path_display.alpha = 200
			path_display.color = "#00FF00"
			path_display.layer = 2 // Render above whiteness, but below maptext.

		else
			path_display = image('icons/effects/navigation.dmi', loc = current_turf)
			path_display.plane = ABOVE_LIGHTING_PLANE
			path_display.color = COLOR_BLUE //So it stands out better against the white.
			path_display.alpha = 200

			var/turf/turf_ahead = path[index+1]
			var/turf/turf_behind = path[index-1]
			var/dir_1 = 0
			var/dir_2 = 0

			dir_1 = turn(angle2dir(get_angle(turf_ahead, current_turf)), 180)
			dir_2 = turn(angle2dir(get_angle(turf_behind, current_turf)), 180)
			if(dir_1 > dir_2)
				dir_1 = dir_2
				dir_2 = turn(angle2dir(get_angle(turf_ahead, current_turf)), 180)

			path_display.icon_state = "[dir_1]-[dir_2]"
			#ifndef DEBUG_PATHFINDING //Disables this for hygiene.
			path_display.maptext = MAPTEXT("[index]|[get_dist_euclidean(current_turf, T)]")
			#else
			path_display.alpha = 255 //Make it solid if we're doing debug rendering.
			path_display.layer = 2 // Render above whiteness, but below maptext.
			#endif


		images += path_display
		usr.client.images += path_display
#ifndef DEBUG_PATHFINDING
	return
#else
	if(!GLOB.__pathfinding_debug_info)
		return
	var/list/__pathfinding_debug_info = GLOB.__pathfinding_debug_info
	to_chat(usr, span_info("Debug Enabled: Nodes Passed: [__pathfinding_debug_info.len]"))
	//I'm going to just access kapu's stuff by number.
	for(var/index in 1 to __pathfinding_debug_info.len)
		var/list/current_node = __pathfinding_debug_info[index]
		var/image/node_display = image('icons/turf/floors.dmi', current_node[1], "pure_white")
		node_display.plane = ABOVE_LIGHTING_PLANE
		node_display.alpha = 200
		node_display.layer = 1 //Render on the very bottom.

		images += node_display
		usr.client.images += node_display
		// Draw a second, empty image just for the maptext.
		node_display = image('icons/turf/floors.dmi', current_node[1], "invisible")
		node_display.maptext = MAPTEXT("H:[truncate("[current_node[4]]",5)]<br>G:[truncate("[current_node[3]]",5)]<br>F:[truncate("[current_node[2]]",5)]")
		node_display.maptext_width = 64
		node_display.plane = ABOVE_LIGHTING_PLANE
		node_display.layer = 3 // Render above everything else.
		images += node_display
		usr.client.images += node_display
#endif
