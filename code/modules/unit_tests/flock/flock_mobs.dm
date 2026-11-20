/// Flock deaths should be counted.
/datum/unit_test/flock/stat_deaths

/datum/unit_test/flock/stat_deaths/Run()
	var/mob/living/simple_animal/flock/drone/bird = new_drone()
	var/deaths = flock.stat_deaths

	bird.death()

	TEST_ASSERT_EQUAL(flock.stat_deaths, deaths + 1, "Drone death was not counted")

/// The health notice should never use an icon state that doesn't exist (hp-10 to hp-100).
/datum/unit_test/flock/health_notice_icon

/datum/unit_test/flock/health_notice_icon/Run()
	var/mob/living/simple_animal/flock/drone/bird = new_drone()
	bird.adjustBruteLoss(bird.maxHealth - 1)

	var/datum/atom_hud/alternate_appearance/basic/flock/notice = bird.get_alt_appearance(FLOCK_NOTICE_HEALTH)
	TEST_ASSERT_NOTNULL(notice, "Drone had no health notice")
	TEST_ASSERT_EQUAL(notice.image.icon_state, "hp-10", "Health notice at 1 HP used the wrong icon state")

/// A controlled drone should report "controlled" to the flock UI.
/datum/unit_test/flock/controlled_task_text

/datum/unit_test/flock/controlled_task_text/Run()
	var/mob/living/simple_animal/flock/drone/bird = new_drone()
	var/mob/camera/flock/trace/ghost_bird = allocate(/mob/camera/flock/trace, run_loc_floor_bottom_left, flock)

	bird.controlled_by = ghost_bird
	var/task = bird.get_flock_data()["task"]
	bird.controlled_by = null

	TEST_ASSERT_EQUAL(task, "controlled", "Controlled drone reported the wrong task")

/// Leaving flockphase inside a wall should put the drone on a turf it can occupy.
/datum/unit_test/flock/phase_out_of_wall

/datum/unit_test/flock/phase_out_of_wall/Run()
	var/mob/living/simple_animal/flock/drone/bird = new_drone()
	var/turf/wall = get_room_wall()
	claim(wall)
	TEST_ASSERT(istype(wall, /turf/closed/wall/flock), "Failed to make a flock wall, got [wall.type]")

	bird.substrate.add_points(50)
	bird.forceMove(wall)
	bird.start_flockphase()
	bird.stop_flockphase(TRUE)

	var/turf/landed = bird.loc
	TEST_ASSERT(isturf(landed), "Drone was not on a turf after leaving flockphase")
	TEST_ASSERT(landed != wall, "Drone stayed inside the wall after leaving flockphase")
	TEST_ASSERT(landed.can_flock_occupy(bird), "Drone was moved to a turf it cannot occupy ([landed.type])")

/// A camera from another flock should not be able to take control of a drone.
/datum/unit_test/flock/take_control_other_flock

/datum/unit_test/flock/take_control_other_flock/Run()
	var/mob/living/simple_animal/flock/drone/bird = new_drone()
	var/datum/flock/other_flock = new
	var/mob/camera/flock/trace/intruder = allocate(/mob/camera/flock/trace, run_loc_floor_bottom_left, other_flock)

	TEST_ASSERT(!bird.take_control(intruder), "A camera from another flock took control of a drone")
	TEST_ASSERT_NULL(bird.controlled_by, "Drone was marked as controlled by another flock's camera")

/// Releasing control of a drone with no flock should not runtime.
/datum/unit_test/flock/release_control_no_flock

/datum/unit_test/flock/release_control_no_flock/Run()
	var/mob/living/simple_animal/flock/drone/bird = new_drone()
	var/mob/camera/flock/trace/ghost_bird = allocate(/mob/camera/flock/trace, run_loc_floor_bottom_left, flock)

	flock.free_unit(bird)
	TEST_ASSERT_NULL(bird.flock, "free_unit() did not clear the drone's flock")

	bird.controlled_by = ghost_bird
	bird.release_control()

	TEST_ASSERT_NULL(bird.controlled_by, "release_control() did not clear controlled_by")

/// Diffracting a drone should create bits in the same flock.
/datum/unit_test/flock/diffract_keeps_flock

/datum/unit_test/flock/diffract_keeps_flock/Run()
	var/mob/living/simple_animal/flock/drone/bird = new_drone()
	var/turf/T = get_turf(bird)
	var/bits_before = length(flock.bits)

	bird.split_into_bits()

	TEST_ASSERT_EQUAL(length(flock.bits), bits_before + 3, "Diffracting did not add 3 bits to the drone's flock")
	for(var/mob/living/simple_animal/flock/bit/bitty_bird in T)
		TEST_ASSERT_EQUAL(bitty_bird.flock, flock, "Diffracted bit joined the wrong flock")
