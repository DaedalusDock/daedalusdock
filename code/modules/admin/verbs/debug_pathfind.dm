
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

/client/proc/debug_pathfinding(turf/T as turf)
	set name = "Pathfind To..."
	set category = "Debug"

	if(!check_rights(R_DEBUG))
		return

	var/method = tgui_input_list(usr, "Pathfinding Method", "Pathfind To...", list("AStar", "JPS"))
	if(!method)
		return

	var/include_diagonals = tgui_alert(usr, "Include diagonals?", "Pathfind To...", list("Yes", "No")) == "Yes"

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
			path = SSpathfinder.astar_pathfind_now(usr, T, 50, 0, access, TRUE, null, FALSE, include_diagonals)

		if("JPS")
			path = SSpathfinder.jps_pathfind_now(usr, T, 50, 0, access, TRUE, TRUE, FALSE, include_diagonals ? DIAGONAL_REMOVE_CLUNKY : DIAGONAL_REMOVE_ALL)
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

		else if(index == path.len)
			path_display = image('icons/turf/floors.dmi', current_turf, "pure_white")
			path_display.plane = ABOVE_LIGHTING_PLANE
			path_display.alpha = 200
			path_display.color = "#00FF00"

		else
			path_display = image('icons/effects/navigation.dmi', loc = current_turf)
			path_display.plane = ABOVE_LIGHTING_PLANE
			path_display.color = COLOR_CYAN
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
			#endif

		images += path_display
		usr.client.images += path_display
#ifndef DEBUG_PATHFINDING
	return
#else
	if(!GLOB.__pathfinding_debug_info)
		return
	var/list/__pathfinding_debug_info = GLOB.__pathfinding_debug_info
	//I'm going to just access kapu's stuff by number.
	for(var/index in 1 to __pathfinding_debug_info.len)
		var/list/current_node = __pathfinding_debug_info[index]
		var/image/node_display = image('icons/turf/floors.dmi', current_node[1], "pure_white")
		node_display.plane = ABOVE_LIGHTING_PLANE
		node_display.alpha = 200

		node_display.maptext = MAPTEXT("H:[truncate("[current_node[4]]",4)]<br>G:[truncate("[current_node[3]]",4)]<br>F:[truncate("[current_node[2]]",4)]")

		images += node_display
		usr.client.images += node_display
#endif
