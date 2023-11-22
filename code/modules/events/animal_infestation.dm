/datum/round_event_control/animal_infestation/vermin
	name = "Animal Infestation: Vermin"
	typepath = /datum/round_event/animal_infestation/vermin
	weight = 10

/datum/round_event_control/animal_infestation/passive
	name = "Animal Infestation: Passive"
	typepath = /datum/round_event/animal_infestation/passive
	weight = 5

/datum/round_event_control/animal_infestation/dangerous
	name = "Animal Infestation: Dangerous"
	typepath = /datum/round_event/animal_infestation/dangerous
	weight = 4
	earliest_start = 20 MINUTES
	min_players = 10 //let's not dump hostile mobs on a lowpop round.

/datum/round_event/animal_infestation
	var/mob_count
	var/min_spawns = 5
	var/max_spawns = 10
	var/spawn_turfs = list()
	var/area_name
	var/mob/living/mob_to_spawn
	var/descriptor
	var/message = ""

	//list of possible mobs and adjectives to describe them
	var/list/possible_mobs = list(
	/mob/living/simple_animal/mouse = "squeaking",
	)

/datum/round_event/animal_infestation/setup()
	var/initial_turf = find_safe_turf()
	if(!initial_turf)
		CRASH("Infestation event could find no safe turfs")
	area_name = get_area_name(initial_turf)
	if(!length(possible_mobs))
		CRASH("Infestation event had an empty mob list")
	mob_to_spawn = pick(possible_mobs)
	descriptor = possible_mobs[mob_to_spawn]
	mob_count = rand(min_spawns, max_spawns)

	FOR_DVIEW(var/turf/T, 7, initial_turf, INVISIBILITY_LIGHTING)
		if(is_safe_turf(T))
			if(!(locate(/mob/living/carbon) in viewers(T))) //don't spawn mobs in front of players
				spawn_turfs += T
	FOR_DVIEW_END

	if(!length(spawn_turfs))
		//if there's no good turfs, just use the initial turf
		spawn_turfs += initial_turf

	announce_to_ghosts(initial_turf)

/datum/round_event/animal_infestation/announce(fake)
	if(fake)
		descriptor = possible_mobs[pick(possible_mobs)] //just pick a random adjective for false alarms

/datum/round_event/animal_infestation/start()
	var/spawns_left = mob_count
	while(spawns_left > 0)
		if(!length(spawn_turfs))
			spawns_left = 0
			return
		new mob_to_spawn(pick_n_take(spawn_turfs))
		spawns_left -= 1

//event variants
/datum/round_event/animal_infestation/vermin
	min_spawns = 5
	max_spawns = 15
	possible_mobs = list(
	/mob/living/simple_animal/mouse = "squeaking",
	/mob/living/basic/cockroach = "skittering",
	/mob/living/simple_animal/hostile/lizard = "scaled",
	)

/datum/round_event/animal_infestation/vermin/announce(fake)
	. = ..()
	priority_announce("\A [pick("infestation", "nest", "army", "invasion", "colony", "swarm")] of [descriptor] [pick("vermin", "pests", "critters", "things")] has been detected in [area_name]. Further infestation is likely if left unchecked.",
	"Long-Range Sensor Relay", "Minor Lifesigns Detected")

/datum/round_event/animal_infestation/passive
	min_spawns = 3
	max_spawns = 8
	possible_mobs = list(
	/mob/living/basic/cow = "milkable",
	/mob/living/simple_animal/chicken = "clucking",
	/mob/living/simple_animal/butterfly = "fluttering",
	/mob/living/simple_animal/sloth = "lazy",
	/mob/living/simple_animal/parrot = "colorful",
	/mob/living/simple_animal/pet/fox = "shrieking",
	/mob/living/simple_animal/pet/gondola = "silent",
	/mob/living/simple_animal/rabbit = "hopping",
	/mob/living/simple_animal/pet/penguin = "black-and-white",
	/mob/living/simple_animal/pet/cat = "aloof",
	/mob/living/simple_animal/pet/dog/corgi = "canine",
	/mob/living/simple_animal/pet/dog/pug = "wheezing",
	/mob/living/simple_animal/crab = "shelled",
	/mob/living/simple_animal/deer = "hooved",
	/mob/living/simple_animal/hostile/ant = "hungry",
	/mob/living/simple_animal/hostile/mushroom = "fungal",
	/mob/living/simple_animal/hostile/asteroid/gutlunch/grublunch = "warbling",
	/mob/living/simple_animal/hostile/asteroid/goldgrub = "shiny",
	/mob/living/simple_animal/hostile/retaliate/frog = "hopping",
	)

/datum/round_event/animal_infestation/passive/announce(fake)
	. = ..()
	priority_announce("\A [pick("flock", "pack", "gathering", "group", "herd", "whole bunch")] of [descriptor] [pick("animals", "beasts", "creatures", "lifeforms", "things")] has been detected in [area_name]. Please ensure this does not impact productivity.",
	"Long-Range Sensor Relay", "Lifesigns Detected")

/datum/round_event/animal_infestation/dangerous
	min_spawns = 2
	max_spawns = 5 //some of these mobs are a serious threat
	possible_mobs = list(
	/mob/living/simple_animal/hostile/retaliate/bat = "flapping",
	/mob/living/simple_animal/hostile/retaliate/goat = "temperamental",
	/mob/living/simple_animal/hostile/gorilla = "muscular",
	/mob/living/simple_animal/hostile/alien/drone = "alien",
	/mob/living/simple_animal/hostile/bee = "buzzing",
	/mob/living/simple_animal/hostile/retaliate/goose = "honking",
	/mob/living/simple_animal/hostile/retaliate/clown = "silly",
	/mob/living/simple_animal/hostile/killertomato = "juicy",
	/mob/living/simple_animal/hostile/mimic = "disguised",
	/mob/living/simple_animal/hostile/netherworld/migo = "noisy",
	/mob/living/simple_animal/hostile/netherworld/blankbody = "humanoid",
	/mob/living/simple_animal/hostile/asteroid/fugu = "growing",
	/mob/living/simple_animal/slime = "gelatinous",
	/mob/living/simple_animal/hostile/hivebot = "robotic",
	/mob/living/simple_animal/hostile/bear = "ursine",
	)

/datum/round_event/animal_infestation/dangerous/announce(fake)
	. = ..()
	priority_announce("A dangerous [pick("horde", "pack", "group", "swarm", "force", "amount")] of [descriptor] [pick("animals", "monsters", "beasts", "creatures")] has been detected in [area_name]. Security personnel are encouraged to investigate and clear the area if necessary.",
	"Long-Range Sensor Relay", "Hostile Lifesigns Detected")
