SUBSYSTEM_DEF(holomap)
	name = "Holomap"
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_HOLOMAP
	var/list/holomaps_by_z

/datum/controller/subsystem/holomap/Initialize(start_timeofday)
	holomaps_by_z = new /list(world.maxz)
	generate_holomaps()
	return ..()

/datum/controller/subsystem/holomap/proc/generate_holomaps()
	for(var/z_value in SSmapping.levels_by_trait(ZTRAIT_STATION))
		var/icon/canvas = icon('icons/blanks/480x480.dmi', "nothing")
		var/area/A

		for(var/turf/T as anything in block(1, 1, z_value, world.maxx, world.maxy, z_value))
			A = T.loc

			if(isnull(A.holomap_color))
				continue

			var/obj/structure/window/W
			if(iswallturf(T) || locate(/obj/structure/low_wall, T) || ((W = locate(/obj/structure/window, T)) && W.fulltile))
				if(istype(A, /area/station/maintenance))
					var/is_edge_turf = FALSE
					for(var/dir in GLOB.cardinals)
						var/turf/other = get_step(T, dir)
						var/area/other_area = other.loc

						// This check is for "Is the turf bordering a non-station turf OR a non-maintenance turf?"
						if(!istype(other_area, /area/station) || (other_area.holomap_color != A.holomap_color))
							is_edge_turf = TRUE
							break

					if(!is_edge_turf)
						canvas.DrawBox(A.holomap_color, T.x, T.y)
						continue

				canvas.DrawBox(HOLOMAP_COLOR_WALL, T.x, T.y)

			else
				canvas.DrawBox(A.holomap_color, T.x, T.y)

		var/file_name = SANITIZE_FILENAME("holomap_[SSmapping.config.map_name]_z[z_value]")
		holomaps_by_z[z_value] = SSassets.transport.register_asset(file_name, canvas)
		fcopy(canvas, "icons/holomap[z_value].png")
