/datum/mining_template
	abstract_type = /datum/mining_template
	var/name = ""
	var/description = ""
	var/rarity = null
	var/randomly_appear = FALSE

/// Called during SSmapping.generate_asteroid(). Here is where you mangle the geometry provided by the asteroid generator function.
/// Atoms at this stage are NOT initialized
/datum/mining_template/proc/Generate(turf/center, list/turfs)

/// Called during SSmapping.generate_asteroid() after all atoms have been initialized.
/datum/mining_template/proc/AfterInitialize(turf/center, list/atoms)
	return

/datum/mining_template/simple_asteroid
	name = "Asteroid"
	rarity = -1

/proc/TestLoadAsteroid()
	var/time = world.timeofday
	var/turf/center = get_turf(usr)
	var/datum/mining_template/template = new
	var/size = 5

	var/list/turfs = ReserveTurfsForAsteroidGeneration(center, size)
	var/datum/callback/asteroid_cb = CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(GenerateRoundAsteroid), template, center, /turf/closed/mineral/asteroid/tospace, 7, turfs, TRUE)
	SSmapping.generate_asteroid(template, center, asteroid_cb)

	to_chat(usr, span_warning("Asteroid took [DisplayTimeText(world.timeofday - time, 0.01)] to generate."))

	sleep(5 SECONDS)

	time = world.timeofday
	CleanupAsteroidMagnet(center, 5)
	to_chat(usr, span_warning("Asteroid took [DisplayTimeText(world.timeofday - time, 0.01)] to destroy."))
