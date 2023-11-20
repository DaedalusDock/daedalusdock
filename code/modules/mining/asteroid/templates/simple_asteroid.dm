/datum/mining_template/simple_asteroid
	abstract_type = /datum/mining_template/simple_asteroid

	name = "Asteroid"
	rarity = -1
	size = 3

	var/is_hollow = FALSE

/datum/mining_template/simple_asteroid/randomize()
	. = ..()
	is_hollow = prob(15)

/datum/mining_template/simple_asteroid/get_description()
	. = ..()
	if(is_hollow)
		. += "<div>&gt; HOLLOW</div>"

/datum/mining_template/simple_asteroid/Generate()
	var/list/turfs = ReserveTurfsForAsteroidGeneration(center, size)
	var/datum/callback/asteroid_cb = CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(GenerateRoundAsteroid), src, center, /turf/closed/mineral/asteroid/tospace, null, turfs, is_hollow)
	SSmapping.generate_asteroid(src, asteroid_cb)

/datum/mining_template/simple_asteroid/Populate(list/turfs)
	InsertAsteroidMaterials(src, turfs, rand(2, 6), rand(0, 30))

/// An asteroid with predetermined material makeup
/datum/mining_template/simple_asteroid/seeded
	rarity = MINING_COMMON

	/// How many ore veins will we generate
	var/vein_count = 0
	/// Predetermined ore makeup
	var/list/determined_ore = list()

	/// An offset vein count for the description
	var/vein_approximation = 0
	/// The most abundant material, used for description
	var/highest_material_makeup

/datum/mining_template/simple_asteroid/seeded/randomize()
	. = ..()
	vein_count = rand(2,6)
	vein_approximation = max(vein_count + rand(-1, 2), 1)

	SeedOre()

	var/list/datum/ore/ore_appearances = list()
	for(var/datum/ore/O as anything in determined_ore)
		UNLINT(ore_appearances[O]++)

	sortTim(ore_appearances, GLOBAL_PROC_REF(cmp_numeric_asc), TRUE)

	highest_material_makeup = uppertext(ore_appearances[1].name)

/// Set our weighted_ores list
/datum/mining_template/simple_asteroid/seeded/proc/SeedOre()
	PRIVATE_PROC(TRUE)

	var/list/ore_pool
	for(var/i in 1 to vein_count)
		switch(rand(1, 100))
			if(90 to 100)
				ore_pool = SSmaterials.rare_ores
			if(50 to 89)
				ore_pool = SSmaterials.uncommon_ores
			else
				ore_pool = SSmaterials.common_ores

		determined_ore += pick(ore_pool)

/datum/mining_template/simple_asteroid/seeded/get_description()
	. = ..()
	. += "<div>&gt; APPROX. VEIN COUNT &gt; [vein_approximation]</div>"
	. += "<div>&gt; HIGH DENSITY &gt; [highest_material_makeup]</div>"

/datum/mining_template/simple_asteroid/seeded/Populate(list/turfs)
	InsertAsteroidMaterials(src, turfs, vein_count, determined_ore = determined_ore)
