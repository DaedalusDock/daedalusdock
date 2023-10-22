/datum/mining_template
	abstract_type = /datum/mining_template
	var/name = ""
	var/description = ""
	var/rarity = null
	var/randomly_appear = FALSE

/datum/mining_template/proc/Generate(turf/center, list/turfs)
	. = list() + turfs

/datum/mining_template/simple_asteroid
	name = "Asteroid"
	rarity = -1

/datum/mining_template/simple_asteroid/Generate(turf/center, list/turfs)
	. = ..()


/proc/TestLoadAsteroid()
	var/turf/center = get_turf(usr)
	var/datum/mining_template/template = new
	var/size = 5

	var/list/turfs = ReserveTurfsForAsteroidGeneration(center, size)
	var/datum/callback/asteroid_cb = CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(GenerateRoundAsteroid), template, center, /turf/closed/mineral/asteroid/tospace, 7, turfs, TRUE)
	SSmapping.generate_asteroid(template, asteroid_cb)
