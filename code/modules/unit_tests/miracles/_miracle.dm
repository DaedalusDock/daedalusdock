/datum/unit_test/miracle
	abstract_type = /datum/unit_test/miracle

/datum/unit_test/miracle/proc/allocate_rune(rune_path)
	var/obj/effect/aether_rune/rune = allocate(rune_path, run_loc_floor_bottom_left)
	rune.required_helpers = 0

	for(var/phrase in rune.invocation_phrases)
		rune.invocation_phrases[phrase] = 0.1 SECONDS
	return rune

/datum/unit_test/miracle/proc/await_miracle(/obj/effect/aether_rune/rune)
	sleep(1 SECOND)
