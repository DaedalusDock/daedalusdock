/datum/mining_template/simple_asteroid
	abstract_type = /datum/mining_template/simple_asteroid

	name = "Asteroid"
	rarity = -1
	size = 3

	/// Will the asteroid generate with a hollow core.
	var/is_hollow = FALSE
	/// Probability of turning into a comet instead of an asteroid.
	var/comet_prob = 10
	/// Type of turf used in generation.
	var/turf_path = /turf/closed/mineral/asteroid/tospace
	/// Type of open turf used in generation if hollow.
	var/openturf_path = /turf/open/misc/asteroid/airless/tospace

/datum/mining_template/simple_asteroid/randomize()
	. = ..()
	is_hollow = prob(15)
	if(prob(comet_prob))
		make_comet()

/datum/mining_template/simple_asteroid/get_description()
	. = ..()
	if(is_hollow)
		. += "<div>&gt; HOLLOW</div>"

/datum/mining_template/simple_asteroid/Generate()
	var/list/turfs = ReserveTurfsForAsteroidGeneration(center, size)
	var/datum/callback/asteroid_cb = CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(GenerateRoundAsteroid), src, center, turf_path, null, turfs, is_hollow)
	SSmapping.generate_asteroid(src, asteroid_cb)

/datum/mining_template/simple_asteroid/Populate(list/turfs)
	InsertAsteroidMaterials(src, turfs, rand(2, 6), rand(0, 30))

/// Generates a comet instead of an asteroid.
/datum/mining_template/simple_asteroid/proc/make_comet()
	name = "Comet"
	turf_path = /turf/closed/mineral/iron/ice/tospace
	openturf_path = /turf/open/misc/asteroid/snow/ice/airless/tospace

/// An asteroid with predetermined material makeup.
/datum/mining_template/simple_asteroid/seeded
	abstract_type = /datum/mining_template/simple_asteroid/seeded

	rarity = MINING_COMMON

	/// How many ore veins will we generate
	var/vein_count = 0
	/// Predetermined ore makeup, typepath -> # of ore.
	var/alist/determined_ore = alist()

	/// An offset vein count for the description
	var/vein_approximation = 0
	/// The most abundant material, used for description
	var/highest_material_makeup

	// Bounds for random vein counts. Ignored if vein_count is not zero. Ore datum vein counts take priority.
	var/vein_count_lower = 2
	var/vein_count_upper = 4

/datum/mining_template/simple_asteroid/seeded/randomize()
	. = ..()
	if(!vein_count)
		vein_count = rand(vein_count_lower, vein_count_upper)

	vein_approximation = max(vein_count + rand(-2, 2), 1)

	SeedOre()

	var/highest_count = 0
	for(var/_ore_path, ore_count in determined_ore)
		if(ore_count < highest_count)
			continue

		if(ore_count == highest_count && prob(50))
			continue

		var/datum/ore/ore_path = _ore_path
		highest_count = ore_count
		highest_material_makeup = initial(ore_path.name)

/// Set our determined_ore list
/datum/mining_template/simple_asteroid/seeded/proc/SeedOre()
	PROTECTED_PROC(TRUE)

	return determined_ore

/datum/mining_template/simple_asteroid/seeded/get_description()
	. = ..()
	. += "<div>&gt; APPROX. VEIN COUNT &gt; [vein_approximation]</div>"
	. += "<div>&gt; HIGH DENSITY &gt; [highest_material_makeup]</div>"

/datum/mining_template/simple_asteroid/seeded/Populate(list/turfs)
	InsertAsteroidMaterials(src, turfs, vein_count, determined_ore = determined_ore)

/// Iron.
/datum/mining_template/simple_asteroid/seeded/iron
	rarity = MINING_COMMON

/datum/mining_template/simple_asteroid/seeded/low_tier/SeedOre()
	determined_ore = alist(/datum/ore/iron = rand(vein_count_lower, vein_count_upper))

/// Silver n' Gold, rare chance of including some diamonds.
/datum/mining_template/simple_asteroid/seeded/mid_tier
	rarity = MINING_UNCOMMON

/datum/mining_template/simple_asteroid/seeded/mid_tier/SeedOre()
	if(prob(75)) // % chance to be one ore instead of multiple.
		var/ore_type
		switch(rand(1, 2))
			if(1)
				ore_type = /datum/ore/silver
			if(2)
				ore_type = /datum/ore/gold

		determined_ore = alist((ore_type) = rand(vein_count_lower, vein_count_upper))
		return

	var/veins = rand(vein_count_lower, vein_count_upper)
	for(var/i in 1 to veins)
		var/ore_type
		switch(rand(1, 100))
			if(1 to 49)
				ore_type = /datum/ore/silver
			if(2 to 99)
				ore_type = /datum/ore/gold
			if(100)
				ore_type = /datum/ore/diamond

		determined_ore[ore_type] += 1

/// Diamond and titanium, rarely, uranium
/datum/mining_template/simple_asteroid/seeded/high_tier
	rarity = MINING_RARE

	vein_count_lower = 1
	vein_count_upper = 3

/datum/mining_template/simple_asteroid/seeded/high_tier/SeedOre()
	if(prob(75))
		var/ore_type
		switch(rand(1, 2))
			if(1)
				ore_type = /datum/ore/diamond
			if(2)
				ore_type = /datum/ore/titanium

		determined_ore = alist((ore_type) = rand(vein_count_lower, vein_count_upper))
		return

	var/veins = rand(vein_count_lower, vein_count_upper)
	for(var/i in 1 to veins)
		var/ore_type
		switch(rand(1, 100))
			if(1 to 49)
				ore_type = /datum/ore/diamond
			if(2 to 99)
				ore_type = /datum/ore/titanium
			if(100)
				ore_type = /datum/ore/uranium

		determined_ore[ore_type] += 1

/// Randomly populates with ore. This can yield insane results so be careful.
/datum/mining_template/simple_asteroid/seeded/random
	rarity = MINING_RARE

/datum/mining_template/simple_asteroid/seeded/random/SeedOre()
	var/list/ore_pool
	for(var/i in 1 to vein_count)
		switch(rand(1, 100))
			if(95 to 100)
				ore_pool = SSmaterials.rare_ores
			if(65 to 89)
				ore_pool = SSmaterials.uncommon_ores
			else
				ore_pool = SSmaterials.common_ores

		determined_ore[pick(ore_pool)] += 1
