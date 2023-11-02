/datum/mining_template
	abstract_type = /datum/mining_template
	var/name = "PLACEHOLDER NAME"
	var/description = "PLACEHOLDER DESC"
	var/rarity = null
	var/randomly_appear = FALSE
	/// The size (radius, chebyshev distance). Will be clamped to the size of the asteroid magnet in New().
	var/size = 7
	/// The center turf.
	var/turf/center

	// Asteroid Map location
	var/x
	var/y

/datum/mining_template/New(center, max_size)
	. = ..()
	src.center = center
	if(size)
		size = max(size, max_size)

/// The proc to call to completely generate an asteroid
/datum/mining_template/proc/Generate()
	return

/// Called during SSmapping.generate_asteroid(). Here is where you mangle the geometry provided by the asteroid generator function.
/// Atoms at this stage are NOT initialized
/datum/mining_template/proc/Populate(list/turfs)
	return
/// Called during SSmapping.generate_asteroid() after all atoms have been initialized.
/datum/mining_template/proc/AfterInitialize(list/atoms)
	return

/datum/mining_template/simple_asteroid
	name = "Asteroid"
	rarity = -1
	size = 3

/datum/mining_template/simple_asteroid/Generate()
	var/is_hollow = prob(15)
	var/list/turfs = ReserveTurfsForAsteroidGeneration(center, size)
	var/datum/callback/asteroid_cb = CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(GenerateRoundAsteroid), src, center, /turf/closed/mineral/asteroid/tospace, null, turfs, is_hollow)
	SSmapping.generate_asteroid(src, asteroid_cb)

/datum/mining_template/simple_asteroid/Populate(list/turfs)
	InsertAsteroidMaterials(src, turfs, rand(2, 6), rand(0, 30))
