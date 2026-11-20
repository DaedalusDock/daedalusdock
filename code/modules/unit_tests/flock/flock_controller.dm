/// A claimed flock wall that becomes a flock floor should move from claimed_walls to claimed_floors, and stay tracked.
/datum/unit_test/flock/claimed_wall_to_floor

/datum/unit_test/flock/claimed_wall_to_floor/Run()
	var/turf/T = get_room_wall()
	claim(T)
	TEST_ASSERT(istype(T, /turf/closed/wall/flock), "Claiming a wall did not convert it, got [T.type]")
	TEST_ASSERT(flock.claimed_walls[T], "Claimed wall was not in claimed_walls")

	T.ChangeTurf(/turf/open/floor/flock)

	TEST_ASSERT(flock.claimed_floors[T], "Flock wall that became a flock floor was not in claimed_floors")
	TEST_ASSERT(!flock.claimed_walls[T], "Flock wall that became a flock floor was still in claimed_walls")
	TEST_ASSERT_NOTNULL(flock_handler(T, COMSIG_TURF_CHANGE), "Flock stopped listening for changes on the re-claimed turf")

/// A claimed flock turf that becomes a non-flock turf should be untracked.
/datum/unit_test/flock/claimed_turf_destroyed

/datum/unit_test/flock/claimed_turf_destroyed/Run()
	var/turf/T = run_loc_floor_bottom_left
	claim(T)
	TEST_ASSERT(flock.claimed_floors[T], "Claimed floor was not in claimed_floors")

	T.ChangeTurf(/turf/open/floor/plating)

	TEST_ASSERT(!flock.claimed_floors[T], "Destroyed flock floor was still in claimed_floors")
	TEST_ASSERT(!flock.claimed_walls[T], "Destroyed flock floor was in claimed_walls")
	TEST_ASSERT_NULL(flock_handler(T, COMSIG_TURF_CHANGE), "Flock was still listening for changes on an unclaimed turf")

/// Freeing a reservation on a claimed turf must not remove the claim's turf change handler.
/datum/unit_test/flock/reservation_keeps_claim_handler

/datum/unit_test/flock/reservation_keeps_claim_handler/Run()
	var/mob/living/simple_animal/flock/drone/bird = new_drone()
	var/turf/T = get_room_wall()
	claim(T)

	// Deconstruction reserves this way.
	TEST_ASSERT(flock.reserve_turf(bird, T), "Failed to reserve claimed turf")
	flock.free_turf(bird)

	TEST_ASSERT(!flock.turf_reservations[T], "Turf was still reserved after free_turf()")
	TEST_ASSERT_NOTNULL(flock_handler(T, COMSIG_TURF_CHANGE), "Freeing a reservation removed the claimed turf's change handler")

	// And the claim still reacts to changes.
	T.ChangeTurf(/turf/open/floor/flock)
	TEST_ASSERT(flock.claimed_floors[T], "Claimed turf stopped being tracked after a reservation on it was freed")

// A reservation should be freed when the reserved turf changes.
/datum/unit_test/flock/reservation_freed_on_change

/datum/unit_test/flock/reservation_freed_on_change/Run()
	var/mob/living/simple_animal/flock/drone/bird = new_drone()
	var/turf/T = run_loc_floor_top_right
	remember_turf(T)

	TEST_ASSERT(flock.reserve_turf(bird, T), "Failed to reserve turf")
	TEST_ASSERT_NOTNULL(flock_handler(T, COMSIG_TURF_CHANGE), "Reservation did not register a turf change handler")

	T.ChangeTurf(/turf/open/floor/plating)

	TEST_ASSERT(!flock.turf_reservations[T], "Reservation was not freed when the turf changed")
	TEST_ASSERT(!flock.turf_reservations_by_flock[bird], "Reservation was still tracked for the drone after the turf changed")
	TEST_ASSERT_NULL(flock_handler(T, COMSIG_TURF_CHANGE), "Turf change handler was still registered after the reservation was freed")

/// Claiming a turf should clear its priority mark.
/datum/unit_test/flock/claim_clears_priority

/datum/unit_test/flock/claim_clears_priority/Run()
	var/turf/T = run_loc_floor_bottom_left
	flock.marked_for_conversion[T] = TRUE
	flock.add_notice(T, FLOCK_NOTICE_PRIORITY)

	claim(T)

	TEST_ASSERT(!flock.marked_for_conversion[T], "Claimed turf was still marked for conversion")
	TEST_ASSERT_NULL(T.get_alt_appearance(FLOCK_NOTICE_PRIORITY), "Claimed turf still had the priority notice")

/// Egg cost should only count eggs, not every structure.
/datum/unit_test/flock/egg_cost_ignores_structures

/datum/unit_test/flock/egg_cost_ignores_structures/Run()
	flock.update_egg_cost()
	var/expected = flock.current_egg_cost

	// Enough structures that counting them would change the rounded cost.
	var/turf/T = run_loc_floor_top_right
	for(var/i in 1 to 5)
		allocate(/obj/structure/flock/interceptor, T, flock)

	flock.update_egg_cost()
	TEST_ASSERT_EQUAL(flock.current_egg_cost, expected, "Non-egg structures changed the egg cost")

/// Designate Ignore should toggle, and switching between ignored and enemy should keep exactly one state.
/datum/unit_test/flock/ignore_toggle

/datum/unit_test/flock/ignore_toggle/Run()
	var/mob/camera/flock/trace/ghost_bird = allocate(/mob/camera/flock/trace, run_loc_floor_bottom_left, flock)
	var/mob/living/carbon/human/target = allocate(/mob/living/carbon/human, run_loc_floor_top_right)

	var/datum/action/cooldown/flock/designate_ignore/ignore_action = locate() in ghost_bird.actions
	if(!ignore_action)
		ignore_action = new
		ignore_action.Grant(ghost_bird)

	var/datum/action/cooldown/flock/designate_enemy/enemy_action = locate() in ghost_bird.actions
	if(!enemy_action)
		enemy_action = new
		enemy_action.Grant(ghost_bird)

	ignore_action.Activate(target)
	TEST_ASSERT(flock.is_mob_ignored(target), "Target was not ignored")
	TEST_ASSERT_NOTNULL(target.get_alt_appearance(FLOCK_NOTICE_IGNORE), "Ignored target had no ignore notice")
	TEST_ASSERT_EQUAL("[flock_handler(target, COMSIG_PARENT_QDELETING)]", "on_ignore_gone", "Ignored target had the wrong qdel handler")

	ignore_action.Activate(target)
	TEST_ASSERT(!flock.is_mob_ignored(target), "Designating an ignored target again did not un-ignore it")
	TEST_ASSERT_NULL(target.get_alt_appearance(FLOCK_NOTICE_IGNORE), "Un-ignored target still had the ignore notice")
	TEST_ASSERT_NULL(flock_handler(target, COMSIG_PARENT_QDELETING), "Un-ignored target still had a qdel handler")

	enemy_action.Activate(target)
	TEST_ASSERT(flock.is_mob_enemy(target), "Target was not made an enemy")

	ignore_action.Activate(target)
	TEST_ASSERT(flock.is_mob_ignored(target), "Ignoring an enemy did not ignore it")
	TEST_ASSERT(!flock.is_mob_enemy(target), "Ignoring an enemy left it as an enemy")
	TEST_ASSERT_EQUAL("[flock_handler(target, COMSIG_PARENT_QDELETING)]", "on_ignore_gone", "Enemy switched to ignored had the wrong qdel handler")

	enemy_action.Activate(target)
	TEST_ASSERT(flock.is_mob_enemy(target), "Designating an ignored target as an enemy did not make it an enemy")
	TEST_ASSERT(!flock.is_mob_ignored(target), "Designating an ignored target as an enemy left it ignored")
	TEST_ASSERT_EQUAL("[flock_handler(target, COMSIG_PARENT_QDELETING)]", "on_enemy_gone", "Ignored target switched to enemy had the wrong qdel handler")

/// Removing an ignore from an atom should remove it from mobs buckled to it.
/datum/unit_test/flock/remove_ignore_buckled

/datum/unit_test/flock/remove_ignore_buckled/Run()
	var/obj/structure/chair/chair = allocate(/obj/structure/chair, run_loc_floor_bottom_left)
	var/mob/living/carbon/human/sitter = allocate(/mob/living/carbon/human, run_loc_floor_bottom_left)
	chair.buckle_mob(sitter, TRUE)
	TEST_ASSERT(sitter in chair.buckled_mobs, "Failed to buckle the mob")

	flock.add_ignore(chair)
	TEST_ASSERT(flock.is_mob_ignored(sitter), "Ignoring a chair did not ignore the buckled mob")

	flock.remove_ignore(chair)
	TEST_ASSERT(!flock.is_mob_ignored(sitter), "Un-ignoring a chair did not un-ignore the buckled mob")
