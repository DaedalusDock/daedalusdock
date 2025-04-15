/datum/unit_test/miracle
	abstract_type = /datum/unit_test/miracle

	var/mob/living/carbon/human/invoker
	var/mob/living/carbon/human/target
	var/obj/item/aether_tome/tome
	var/obj/item/reagent_containers/glass/bottle/blood_bottle
	var/obj/effect/aether_rune/rune

/datum/unit_test/miracle/Destroy()
	invoker = null
	target = null
	tome = null
	rune = null
	blood_bottle = null
	return ..()

/datum/unit_test/miracle/proc/allocate_rune(rune_path)
	var/obj/effect/aether_rune/rune = allocate(rune_path, run_loc_floor_bottom_left)
	rune.required_helpers = 0

	for(var/phrase in rune.invocation_phrases)
		rune.invocation_phrases[phrase] = 0.1 SECONDS
	return rune

/// Sets up the rune with an invoker and target
/datum/unit_test/miracle/proc/setup(rune_path)
	invoker = ALLOCATE_BOTTOM_LEFT()
	target = ALLOCATE_BOTTOM_LEFT()
	tome = ALLOCATE_BOTTOM_LEFT()

	rune = allocate_rune(rune_path)

	if(rune.required_blood_amt)
		blood_bottle = ALLOCATE_BOTTOM_LEFT()
		blood_bottle.reagents.add_reagent(/datum/reagent/blood, rune.required_blood_amt)

	invoker.forceMove(get_step(invoker, NORTH))
	invoker.put_in_active_hand(tome)
	target.set_body_position(LYING_DOWN)

/// Start the miracle by clicking on the rune.
/datum/unit_test/miracle/proc/start_miracle()
	invoker.ClickOn(rune)

	var/timeout = world.time + 1 SECOND
	UNTIL(isnull(rune.timed_action) || (world.time >= timeout))
