///ensures that get_turf_pixel() returns turfs within the bounds of the map,
///even when called on a movable with its sprite out of bounds
/datum/unit_test/get_turf_pixel

/datum/unit_test/get_turf_pixel/Run()
	//we need long larry to peek over the top edge of the earth
	var/turf/north = locate(1, world.maxy, run_loc_floor_bottom_left.z)

	//hes really long, so hes really good at peaking over the edge of the map
	var/obj/effect/turfpixeltester/E = allocate(/obj/effect/turfpixeltester, north)
	TEST_ASSERT(istype(get_turf_pixel(E), /turf), "get_turf_pixel() isnt clamping an atom whos sprite is above the bounds of the world inside of the map.")

/obj/effect/turfpixeltester
	icon = 'icons/mob/lavaland/96x96megafauna.dmi'
	icon_state = "bubblegum"
