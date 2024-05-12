/datum/chemical_reaction/lube
	results = list(/datum/reagent/lube = 4)
	required_reagents = list(/datum/reagent/water = 1, /datum/reagent/silicon = 1, /datum/reagent/oxygen = 1)


/datum/chemical_reaction/impedrezene
	results = list(/datum/reagent/impedrezene = 2)
	required_reagents = list(/datum/reagent/mercury = 1, /datum/reagent/oxygen = 1, /datum/reagent/consumable/sugar = 1)


/datum/chemical_reaction/cryptobiolin
	results = list(/datum/reagent/cryptobiolin = 3)
	required_reagents = list(/datum/reagent/potassium = 1, /datum/reagent/oxygen = 1, /datum/reagent/consumable/sugar = 1)


/datum/chemical_reaction/glycerol
	results = list(/datum/reagent/glycerol = 1)
	required_reagents = list(/datum/reagent/consumable/cornoil = 3, /datum/reagent/toxin/acid = 1)


/datum/chemical_reaction/sodiumchloride
	results = list(/datum/reagent/consumable/salt = 3)
	required_reagents = list(/datum/reagent/water = 1, /datum/reagent/sodium = 1, /datum/reagent/chlorine = 1)


/datum/chemical_reaction/hydrochloric
	results = list(/datum/reagent/toxin/acid/hydrochloric = 3)
	required_reagents = list(/datum/reagent/hydrogen = 1, /datum/reagent/chlorine = 1, /datum/reagent/water = 1)

/datum/chemical_reaction/stable_plasma
	results = list(/datum/reagent/stable_plasma = 1)
	required_reagents = list(/datum/reagent/toxin/plasma = 1)
	required_catalysts = list(/datum/reagent/stabilizing_agent = 1)

/datum/chemical_reaction/unstable_mutagen
	results = list(/datum/reagent/toxin/mutagen = 1)
	required_reagents = list(/datum/reagent/chlorine = 1, /datum/reagent/toxin/plasma = 1, /datum/reagent/uranium/radium = 1)

/datum/chemical_reaction/plasma_solidification
	required_reagents = list(/datum/reagent/iron = 5, /datum/reagent/consumable/frostoil = 5, /datum/reagent/toxin/plasma = 20)
	mob_react = FALSE
	reaction_flags = REACTION_INSTANT


/datum/chemical_reaction/plasma_solidification/on_reaction(datum/reagents/holder, datum/equilibrium/reaction, created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i in 1 to created_volume)
		new /obj/item/stack/sheet/mineral/plasma(location)

/datum/chemical_reaction/gold_solidification
	required_reagents = list(/datum/reagent/consumable/frostoil = 5, /datum/reagent/gold = 20, /datum/reagent/iron = 1)
	mob_react = FALSE
	reaction_flags = REACTION_INSTANT


/datum/chemical_reaction/gold_solidification/on_reaction(datum/reagents/holder, datum/equilibrium/reaction, created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i in 1 to created_volume)
		new /obj/item/stack/sheet/mineral/gold(location)

/datum/chemical_reaction/uranium_solidification
	required_reagents = list(/datum/reagent/consumable/frostoil = 5, /datum/reagent/uranium = 20, /datum/reagent/potassium = 1)
	mob_react = FALSE
	reaction_flags = REACTION_INSTANT


/datum/chemical_reaction/uranium_solidification/on_reaction(datum/reagents/holder, datum/equilibrium/reaction, created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i in 1 to created_volume)
		new /obj/item/stack/sheet/mineral/uranium(location)

/datum/chemical_reaction/capsaicincondensation
	results = list(/datum/reagent/consumable/condensedcapsaicin = 5)
	required_reagents = list(/datum/reagent/consumable/capsaicin = 1, /datum/reagent/consumable/ethanol = 5)


/datum/chemical_reaction/soapification
	required_reagents = list(/datum/reagent/liquidgibs = 10, /datum/reagent/lye = 10) // requires two scooped gib tiles
	required_temp = 374
	mob_react = FALSE
	reaction_flags = REACTION_INSTANT


/datum/chemical_reaction/soapification/on_reaction(datum/reagents/holder, datum/equilibrium/reaction, created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i in 1 to created_volume)
		new /obj/item/soap/homemade(location)

/datum/chemical_reaction/omegasoapification
	required_reagents = list(/datum/reagent/consumable/potato_juice = 10, /datum/reagent/monkey_powder = 10, /datum/reagent/drug/krokodil = 10, /datum/reagent/toxin/acid/nitracid = 10, /datum/reagent/consumable/ethanol/hooch = 10, /datum/reagent/drug/pumpup = 10, /datum/reagent/consumable/space_cola = 10)
	required_temp = 999
	optimal_temp = 999
	overheat_temp = 1200
	mob_react = FALSE
	reaction_flags = REACTION_INSTANT


/datum/chemical_reaction/omegasoapification/on_reaction(datum/reagents/holder, datum/equilibrium/reaction, created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i in 1 to created_volume)
		new /obj/item/soap/omega(location)

/datum/chemical_reaction/candlefication
	required_reagents = list(/datum/reagent/liquidgibs = 5, /datum/reagent/oxygen = 5) //
	required_temp = 374
	mob_react = FALSE
	reaction_flags = REACTION_INSTANT


/datum/chemical_reaction/candlefication/on_reaction(datum/reagents/holder, datum/equilibrium/reaction, created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i in 1 to created_volume)
		new /obj/item/candle(location)

/datum/chemical_reaction/meatification
	required_reagents = list(/datum/reagent/liquidgibs = 10, /datum/reagent/consumable/nutriment = 10, /datum/reagent/carbon = 10)
	mob_react = FALSE
	reaction_flags = REACTION_INSTANT


/datum/chemical_reaction/meatification/on_reaction(datum/reagents/holder, datum/equilibrium/reaction, created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i in 1 to created_volume)
		new /obj/item/food/meat/slab/meatproduct(location)
	return

/datum/chemical_reaction/carbondioxide
	results = list(/datum/reagent/carbondioxide = 3)
	required_reagents = list(/datum/reagent/carbon = 1, /datum/reagent/oxygen = 2)
	required_temp = 777 // pure carbon isn't especially reactive.


/datum/chemical_reaction/nitrous_oxide
	results = list(/datum/reagent/nitrous_oxide = 5)
	required_reagents = list(/datum/reagent/ammonia = 2, /datum/reagent/nitrogen = 1, /datum/reagent/oxygen = 2)
	required_temp = 525
	optimal_temp = 550
	overheat_temp = 575
	temp_exponent_factor = 0.2
	thermic_constant = 35 //gives a bonus 15C wiggle room
	rate_up_lim = 25 //Give a chance to pull back

/datum/chemical_reaction/nitrous_oxide/overheated(datum/reagents/holder, datum/equilibrium/equilibrium, step_volume_added)
	return //This is empty because the explosion reaction will occur instead (see pyrotechnics.dm). This is just here to update the lookup ui.


//Technically a mutation toxin
/datum/chemical_reaction/mulligan
	results = list(/datum/reagent/mulligan = 1)
	required_reagents = list(/datum/reagent/mutationtoxin/jelly = 1, /datum/reagent/toxin/mutagen = 1)



////////////////////////////////// VIROLOGY //////////////////////////////////////////

/datum/chemical_reaction/virus_food
	results = list(/datum/reagent/consumable/virus_food = 15)
	required_reagents = list(/datum/reagent/water = 5, /datum/reagent/consumable/milk = 5)

/datum/chemical_reaction/virus_food_mutagen
	results = list(/datum/reagent/toxin/mutagen/mutagenvirusfood = 1)
	required_reagents = list(/datum/reagent/toxin/mutagen = 1, /datum/reagent/consumable/virus_food = 1)

/datum/chemical_reaction/virus_food_synaptizine
	results = list(/datum/reagent/medicine/synaptizine/synaptizinevirusfood = 1)
	required_reagents = list(/datum/reagent/medicine/synaptizine = 1, /datum/reagent/consumable/virus_food = 1)

/datum/chemical_reaction/virus_food_plasma
	results = list(/datum/reagent/toxin/plasma/plasmavirusfood = 1)
	required_reagents = list(/datum/reagent/toxin/plasma = 1, /datum/reagent/consumable/virus_food = 1)
	thermic_constant = 20 // Harder to ignite plasma

/datum/chemical_reaction/virus_food_plasma_synaptizine
	results = list(/datum/reagent/toxin/plasma/plasmavirusfood/weak = 2)
	required_reagents = list(/datum/reagent/medicine/synaptizine = 1, /datum/reagent/toxin/plasma/plasmavirusfood = 1)
	thermic_constant = 20 // Harder to ignite plasma

/datum/chemical_reaction/virus_food_mutagen_sugar
	results = list(/datum/reagent/toxin/mutagen/mutagenvirusfood/sugar = 2)
	required_reagents = list(/datum/reagent/consumable/sugar = 1, /datum/reagent/toxin/mutagen/mutagenvirusfood = 1)

/datum/chemical_reaction/virus_food_mutagen_salineglucose
	results = list(/datum/reagent/toxin/mutagen/mutagenvirusfood/sugar = 2)
	required_reagents = list(/datum/reagent/medicine/saline_glucose = 1, /datum/reagent/toxin/mutagen/mutagenvirusfood = 1)

/datum/chemical_reaction/virus_food_uranium
	results = list(/datum/reagent/uranium/uraniumvirusfood = 1)
	required_reagents = list(/datum/reagent/uranium = 1, /datum/reagent/consumable/virus_food = 1)

/datum/chemical_reaction/virus_food_uranium_plasma
	results = list(/datum/reagent/uranium/uraniumvirusfood/unstable = 1)
	required_reagents = list(/datum/reagent/uranium = 5, /datum/reagent/toxin/plasma/plasmavirusfood = 1)

/datum/chemical_reaction/virus_food_uranium_plasma_gold
	results = list(/datum/reagent/uranium/uraniumvirusfood/stable = 1)
	required_reagents = list(/datum/reagent/uranium = 10, /datum/reagent/gold = 10, /datum/reagent/toxin/plasma = 1)

/datum/chemical_reaction/virus_food_uranium_plasma_silver
	results = list(/datum/reagent/uranium/uraniumvirusfood/stable = 1)
	required_reagents = list(/datum/reagent/uranium = 10, /datum/reagent/silver = 10, /datum/reagent/toxin/plasma = 1)

/datum/chemical_reaction/mix_virus
	results = list(/datum/reagent/blood = 1)
	required_reagents = list(/datum/reagent/consumable/virus_food = 1)
	required_catalysts = list(/datum/reagent/blood = 1)
	var/level_min = 1
	var/level_max = 2
	reaction_flags = REACTION_INSTANT

/datum/chemical_reaction/mix_virus/on_reaction(datum/reagents/holder, datum/equilibrium/reaction, created_volume)
	var/datum/reagent/blood/B = locate(/datum/reagent/blood) in holder.reagent_list
	if(B?.data)
		var/datum/disease/advance/D = locate(/datum/disease/advance) in B.data["viruses"]
		if(D)
			D.Evolve(level_min, level_max)


/datum/chemical_reaction/mix_virus/mix_virus_2
	required_reagents = list(/datum/reagent/toxin/mutagen = 1)
	level_min = 2
	level_max = 4

/datum/chemical_reaction/mix_virus/mix_virus_3
	required_reagents = list(/datum/reagent/toxin/plasma = 1)
	level_min = 4
	level_max = 6

/datum/chemical_reaction/mix_virus/mix_virus_4
	required_reagents = list(/datum/reagent/uranium = 1)
	level_min = 5
	level_max = 6

/datum/chemical_reaction/mix_virus/mix_virus_5
	required_reagents = list(/datum/reagent/toxin/mutagen/mutagenvirusfood = 1)
	level_min = 3
	level_max = 3

/datum/chemical_reaction/mix_virus/mix_virus_6
	required_reagents = list(/datum/reagent/toxin/mutagen/mutagenvirusfood/sugar = 1)
	level_min = 4
	level_max = 4

/datum/chemical_reaction/mix_virus/mix_virus_7
	required_reagents = list(/datum/reagent/toxin/plasma/plasmavirusfood/weak = 1)
	level_min = 5
	level_max = 5

/datum/chemical_reaction/mix_virus/mix_virus_8
	required_reagents = list(/datum/reagent/toxin/plasma/plasmavirusfood = 1)
	level_min = 6
	level_max = 6

/datum/chemical_reaction/mix_virus/mix_virus_9
	required_reagents = list(/datum/reagent/medicine/synaptizine/synaptizinevirusfood = 1)
	level_min = 1
	level_max = 1

/datum/chemical_reaction/mix_virus/mix_virus_10
	required_reagents = list(/datum/reagent/uranium/uraniumvirusfood = 1)
	level_min = 6
	level_max = 7

/datum/chemical_reaction/mix_virus/mix_virus_11
	required_reagents = list(/datum/reagent/uranium/uraniumvirusfood/unstable = 1)
	level_min = 7
	level_max = 7

/datum/chemical_reaction/mix_virus/mix_virus_12
	required_reagents = list(/datum/reagent/uranium/uraniumvirusfood/stable = 1)
	level_min = 8
	level_max = 8

/datum/chemical_reaction/mix_virus/rem_virus
	required_reagents = list(/datum/reagent/medicine/synaptizine = 1)
	required_catalysts = list(/datum/reagent/blood = 1)

/datum/chemical_reaction/mix_virus/rem_virus/on_reaction(datum/reagents/holder, datum/equilibrium/reaction, created_volume)
	var/datum/reagent/blood/B = locate(/datum/reagent/blood) in holder.reagent_list
	if(B?.data)
		var/datum/disease/advance/D = locate(/datum/disease/advance) in B.data["viruses"]
		if(D)
			D.Devolve()

/datum/chemical_reaction/mix_virus/neuter_virus
	required_reagents = list(/datum/reagent/space_cleaner = 1)
	required_catalysts = list(/datum/reagent/blood = 1)

/datum/chemical_reaction/mix_virus/neuter_virus/on_reaction(datum/reagents/holder, datum/equilibrium/reaction, created_volume)
	var/datum/reagent/blood/B = locate(/datum/reagent/blood) in holder.reagent_list
	if(B?.data)
		var/datum/disease/advance/D = locate(/datum/disease/advance) in B.data["viruses"]
		if(D)
			D.Neuter()



////////////////////////////////// foam and foam precursor ///////////////////////////////////////////////////


/datum/chemical_reaction/surfactant
	results = list(/datum/reagent/fluorosurfactant = 5)
	required_reagents = list(/datum/reagent/fluorine = 2, /datum/reagent/carbon = 2, /datum/reagent/toxin/acid = 1)
	reaction_flags = REACTION_INSTANT


/datum/chemical_reaction/foam
	required_reagents = list(/datum/reagent/fluorosurfactant = 1, /datum/reagent/water = 1)
	mob_react = FALSE
	reaction_flags = REACTION_INSTANT

/datum/chemical_reaction/foam/on_reaction(datum/reagents/holder, datum/equilibrium/reaction, created_volume)
	holder.create_foam(/datum/effect_system/fluid_spread/foam, 2*created_volume, notification = span_danger("The solution spews out foam!"))


/datum/chemical_reaction/metalfoam
	required_reagents = list(/datum/reagent/aluminium = 3, /datum/reagent/foaming_agent = 1, /datum/reagent/toxin/acid/fluacid = 1)
	mob_react = FALSE
	reaction_flags = REACTION_INSTANT


/datum/chemical_reaction/metalfoam/on_reaction(datum/reagents/holder, datum/equilibrium/reaction, created_volume)
	holder.create_foam(/datum/effect_system/fluid_spread/foam/metal, 5*created_volume, /obj/structure/foamedmetal, span_danger("The solution spews out a metallic foam!"))

/datum/chemical_reaction/ironfoam
	required_reagents = list(/datum/reagent/iron = 3, /datum/reagent/foaming_agent = 1, /datum/reagent/toxin/acid/fluacid = 1)
	mob_react = FALSE
	reaction_flags = REACTION_INSTANT


/datum/chemical_reaction/ironfoam/on_reaction(datum/reagents/holder, datum/equilibrium/reaction, created_volume)
	holder.create_foam(/datum/effect_system/fluid_spread/foam/metal/iron, 5 * created_volume, /obj/structure/foamedmetal/iron, span_danger("The solution spews out a metallic foam!"))

/datum/chemical_reaction/foaming_agent
	results = list(/datum/reagent/foaming_agent = 1)
	required_reagents = list(/datum/reagent/lithium = 1, /datum/reagent/hydrogen = 1)


/////////////////////////////// Cleaning and hydroponics /////////////////////////////////////////////////

/datum/chemical_reaction/ammonia
	results = list(/datum/reagent/ammonia = 3)
	required_reagents = list(/datum/reagent/hydrogen = 3, /datum/reagent/nitrogen = 1)


/datum/chemical_reaction/diethylamine
	results = list(/datum/reagent/diethylamine = 2)
	required_reagents = list (/datum/reagent/ammonia = 1, /datum/reagent/consumable/ethanol = 1)


/datum/chemical_reaction/plantbgone
	results = list(/datum/reagent/toxin/plantbgone = 5)
	required_reagents = list(/datum/reagent/toxin = 1, /datum/reagent/water = 4)


/datum/chemical_reaction/weedkiller
	results = list(/datum/reagent/toxin/plantbgone/weedkiller = 5)
	required_reagents = list(/datum/reagent/toxin = 1, /datum/reagent/ammonia = 4)

/datum/chemical_reaction/pestkiller
	results = list(/datum/reagent/toxin/pestkiller = 5)
	required_reagents = list(/datum/reagent/toxin = 1, /datum/reagent/consumable/ethanol = 4)


//////////////////////////////////// Other goon stuff ///////////////////////////////////////////

/datum/chemical_reaction/acetone
	results = list(/datum/reagent/acetone = 3)
	required_reagents = list(/datum/reagent/fuel/oil = 1, /datum/reagent/fuel = 1, /datum/reagent/oxygen = 1)

/datum/chemical_reaction/oil
	results = list(/datum/reagent/fuel/oil = 3)
	required_reagents = list(/datum/reagent/fuel = 1, /datum/reagent/carbon = 1, /datum/reagent/hydrogen = 1)


/datum/chemical_reaction/phenol
	results = list(/datum/reagent/phenol = 3)
	required_reagents = list(/datum/reagent/water = 1, /datum/reagent/chlorine = 1, /datum/reagent/fuel/oil = 1)


/datum/chemical_reaction/ash
	results = list(/datum/reagent/ash = 1)
	required_reagents = list(/datum/reagent/fuel/oil = 1)
	required_temp = 480


/datum/chemical_reaction/colorful_reagent
	results = list(/datum/reagent/colorful_reagent = 5)
	required_reagents = list(/datum/reagent/stable_plasma = 1, /datum/reagent/uranium/radium = 1, /datum/reagent/drug/space_drugs = 1, /datum/reagent/medicine/cryoxadone = 1, /datum/reagent/consumable/triple_citrus = 1)

/datum/chemical_reaction/life
	required_reagents = list(/datum/reagent/medicine/strange_reagent = 1, /datum/reagent/medicine/synthflesh = 1, /datum/reagent/blood = 1)
	required_temp = 374
	reaction_flags = REACTION_INSTANT


/datum/chemical_reaction/life/on_reaction(datum/reagents/holder, datum/equilibrium/reaction, created_volume)
	chemical_mob_spawn(holder, rand(1, round(created_volume, 1)), "Life (hostile)") //defaults to HOSTILE_SPAWN

/datum/chemical_reaction/life_friendly
	required_reagents = list(/datum/reagent/medicine/strange_reagent = 1, /datum/reagent/medicine/synthflesh = 1, /datum/reagent/consumable/sugar = 1)
	required_temp = 374
	reaction_flags = REACTION_INSTANT


/datum/chemical_reaction/life_friendly/on_reaction(datum/reagents/holder, datum/equilibrium/reaction, created_volume)
	chemical_mob_spawn(holder, rand(1, round(created_volume, 1)), "Life (friendly)", FRIENDLY_SPAWN)

/datum/chemical_reaction/corgium
	required_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/colorful_reagent = 1, /datum/reagent/medicine/strange_reagent = 1, /datum/reagent/blood = 1)
	required_temp = 374
	reaction_flags = REACTION_INSTANT


/datum/chemical_reaction/corgium/on_reaction(datum/reagents/holder, datum/equilibrium/reaction, created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i in rand(1, created_volume) to created_volume) // More lulz.
		new /mob/living/simple_animal/pet/dog/corgi(location)
	..()

//monkey powder heehoo
/datum/chemical_reaction/monkey_powder
	results = list(/datum/reagent/monkey_powder = 5)
	required_reagents = list(/datum/reagent/consumable/banana = 1, /datum/reagent/consumable/nutriment=2, /datum/reagent/liquidgibs = 1)
	reaction_flags = REACTION_INSTANT


/datum/chemical_reaction/monkey
	required_reagents = list(/datum/reagent/monkey_powder = 50, /datum/reagent/water = 1)
	mix_message = "<span class='danger'>Expands into a brown mass before shaping itself into a monkey!.</span>"

/datum/chemical_reaction/monkey/on_reaction(datum/reagents/holder, datum/equilibrium/reaction, created_volume)
	var/mob/living/carbon/M = holder.my_atom
	var/location = get_turf(M)
	if(istype(M, /mob/living/carbon))
		if(ismonkey(M))
			M.gib()
		else
			M.vomit(blood = TRUE, stun = TRUE) //not having a redo of itching powder (hopefully)
	new /mob/living/carbon/human/species/monkey(location, TRUE)

//water electrolysis
/datum/chemical_reaction/electrolysis
	results = list(/datum/reagent/oxygen = 1.5, /datum/reagent/hydrogen = 3)
	required_reagents = list(/datum/reagent/consumable/liquidelectricity = 1, /datum/reagent/water = 5)


//butterflium
/datum/chemical_reaction/butterflium
	required_reagents = list(/datum/reagent/colorful_reagent = 1, /datum/reagent/medicine/omnizine = 1, /datum/reagent/medicine/strange_reagent = 1, /datum/reagent/consumable/nutriment = 1)
	reaction_flags = REACTION_INSTANT


/datum/chemical_reaction/butterflium/on_reaction(datum/reagents/holder, datum/equilibrium/reaction, created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i in rand(1, created_volume) to created_volume)
		new /mob/living/simple_animal/butterfly(location)
	..()
//scream powder
/datum/chemical_reaction/scream
	required_reagents = list(/datum/reagent/medicine/strange_reagent = 1, /datum/reagent/consumable/cream = 5)
	required_temp = 374
	reaction_flags = REACTION_INSTANT


/datum/chemical_reaction/scream/on_reaction(datum/reagents/holder, datum/equilibrium/reaction, created_volume)
	playsound(holder.my_atom, pick(list( 'sound/voice/human/malescream_1.ogg', 'sound/voice/human/malescream_2.ogg', 'sound/voice/human/malescream_3.ogg', 'sound/voice/human/malescream_4.ogg', 'sound/voice/human/malescream_5.ogg', 'sound/voice/human/malescream_6.ogg', 'sound/voice/human/femalescream_1.ogg', 'sound/voice/human/femalescream_2.ogg', 'sound/voice/human/femalescream_3.ogg', 'sound/voice/human/femalescream_4.ogg', 'sound/voice/human/femalescream_5.ogg', 'sound/voice/human/wilhelm_scream.ogg')), created_volume*5,TRUE)

/datum/chemical_reaction/hair_dye
	results = list(/datum/reagent/hair_dye = 5)
	required_reagents = list(/datum/reagent/colorful_reagent = 1, /datum/reagent/uranium/radium = 1, /datum/reagent/drug/space_drugs = 1)

/datum/chemical_reaction/saltpetre
	results = list(/datum/reagent/saltpetre = 3)
	required_reagents = list(/datum/reagent/potassium = 1, /datum/reagent/nitrogen = 1, /datum/reagent/oxygen = 3)


/datum/chemical_reaction/lye
	results = list(/datum/reagent/lye = 3)
	required_reagents = list(/datum/reagent/sodium = 1, /datum/reagent/hydrogen = 1, /datum/reagent/oxygen = 1)
	required_temp = 10 //So hercuri still shows life.


/datum/chemical_reaction/lye2
	results = list(/datum/reagent/lye = 2)
	required_reagents = list(/datum/reagent/ash = 1, /datum/reagent/water = 1, /datum/reagent/carbon = 1)


/datum/chemical_reaction/royal_bee_jelly
	results = list(/datum/reagent/royal_bee_jelly = 5)
	required_reagents = list(/datum/reagent/toxin/mutagen = 10, /datum/reagent/consumable/honey = 40)


/datum/chemical_reaction/laughter
	results = list(/datum/reagent/consumable/laughter = 10) // Fuck it. I'm not touching this one.
	required_reagents = list(/datum/reagent/consumable/sugar = 1, /datum/reagent/consumable/banana = 1)


/datum/chemical_reaction/plastic_polymers
	required_reagents = list(/datum/reagent/fuel/oil = 5, /datum/reagent/toxin/acid = 2, /datum/reagent/ash = 3)
	required_temp = 374 //lazily consistent with soap & other crafted objects generically created with heat.
	reaction_flags = REACTION_INSTANT


/datum/chemical_reaction/plastic_polymers/on_reaction(datum/reagents/holder, datum/equilibrium/reaction, created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i in 1 to created_volume)
		new /obj/item/stack/sheet/plastic(location)

/datum/chemical_reaction/pax
	results = list(/datum/reagent/pax = 3)
	required_reagents = list(/datum/reagent/toxin/mindbreaker = 1, /datum/reagent/medicine/synaptizine = 1, /datum/reagent/water = 1)


/datum/chemical_reaction/yuck
	results = list(/datum/reagent/yuck = 4)
	required_reagents = list(/datum/reagent/fuel = 3)
	required_container = /obj/item/food/deadmouse



/datum/chemical_reaction/slimejelly
	results = list(/datum/reagent/toxin/slimejelly = 5)
	required_reagents = list(/datum/reagent/fuel/oil = 3, /datum/reagent/uranium/radium = 2, /datum/reagent/consumable/tinlux =1)
	required_container = /obj/item/food/grown/mushroom/glowshroom
	mix_message = "The mushroom's insides bubble and pop and it becomes very limp."


/datum/chemical_reaction/slime_extractification
	required_reagents = list(/datum/reagent/toxin/slimejelly = 30, /datum/reagent/consumable/frostoil = 5, /datum/reagent/toxin/plasma = 5)
	mix_message = "The mixture condenses into a ball."
	reaction_flags = REACTION_INSTANT


/datum/chemical_reaction/slime_extractification/on_reaction(datum/reagents/holder, datum/equilibrium/reaction, created_volume)
	var/location = get_turf(holder.my_atom)
	new /obj/item/slime_extract/grey(location)

/datum/chemical_reaction/cellulose_carbonization
	results = list(/datum/reagent/carbon = 1)
	required_reagents = list(/datum/reagent/cellulose = 1)
	required_temp = 512


/datum/chemical_reaction/space_cleaner
	results = list(/datum/reagent/space_cleaner = 3)
	required_reagents = list(/datum/reagent/water = 1, /datum/reagent/oxygen = 1, /datum/reagent/chlorine = 1)

/datum/chemical_reaction/holywater
	results = list(/datum/reagent/water/holywater = 1)
	required_reagents = list(/datum/reagent/water/hollowwater = 1)
	required_catalysts = list(/datum/reagent/water/holywater = 1)

/datum/chemical_reaction/silver_solidification
	required_reagents = list(/datum/reagent/silver = 20, /datum/reagent/carbon = 10)
	required_temp = 630
	mob_react = FALSE
	reaction_flags = REACTION_INSTANT


/datum/chemical_reaction/silver_solidification/on_reaction(datum/reagents/holder, datum/equilibrium/reaction, created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i in 1 to created_volume)
		new /obj/item/stack/sheet/mineral/silver(location)

/datum/chemical_reaction/bone_gel
	required_reagents = list(/datum/reagent/bone_dust = 10, /datum/reagent/carbon = 10)
	required_temp = 630
	mob_react = FALSE
	reaction_flags = REACTION_INSTANT

	mix_message = "The solution clarifies, leaving an ashy gel."

/datum/chemical_reaction/bone_gel/on_reaction(datum/reagents/holder, datum/equilibrium/reaction, created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i in 1 to created_volume)
		new /obj/item/stack/medical/bone_gel(location)

////Ice and water

/datum/chemical_reaction/ice
	results = list(/datum/reagent/consumable/ice = 1.09)//density
	required_reagents = list(/datum/reagent/water = 1)
	is_cold_recipe = TRUE
	required_temp = WATER_MATTERSTATE_CHANGE_TEMP-0.5 //274 So we can be sure that basic ghetto rigged stuff can freeze
	optimal_temp = 200
	overheat_temp = 0
	thermic_constant = 0
	rate_up_lim = 50
	mix_message = "The solution freezes up into ice!"
	reaction_flags = REACTION_COMPETITIVE

/datum/chemical_reaction/water
	results = list(/datum/reagent/water = 0.92)//rough density excahnge
	required_reagents = list(/datum/reagent/consumable/ice = 1)
	required_temp = WATER_MATTERSTATE_CHANGE_TEMP+0.5
	optimal_temp = 350
	overheat_temp = NO_OVERHEAT
	thermic_constant = 0
	rate_up_lim = 50
	mix_message = "The ice melts back into water!"


////////////////////////////////////

/datum/chemical_reaction/ants // Breeding ants together, high sugar cost makes this take a while to farm.
	results = list(/datum/reagent/ants = 3)
	required_reagents = list(/datum/reagent/ants = 2, /datum/reagent/consumable/sugar = 8)
	required_temp = 50
	reaction_flags = REACTION_INSTANT


/datum/chemical_reaction/ant_slurry // We're basically gluing ants together with synthflesh & maint sludge to make a bigger ant.
	required_reagents = list(/datum/reagent/ants = 50, /datum/reagent/medicine/synthflesh = 20, /datum/reagent/drug/maint/sludge = 5)
	required_temp = 480
	reaction_flags = REACTION_INSTANT

/datum/chemical_reaction/ant_slurry/on_reaction(datum/reagents/holder, datum/equilibrium/reaction, created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i in rand(1, created_volume) to created_volume)
		new /mob/living/simple_animal/hostile/ant(location)
	..()

/datum/chemical_reaction/plastic_polymers
	required_reagents = list(/datum/reagent/fuel/oil = 5, /datum/reagent/toxin/acid = 2, /datum/reagent/ash = 3)
	required_temp = 374 //lazily consistent with soap & other crafted objects generically created with heat.
	reaction_flags = REACTION_INSTANT

/datum/chemical_reaction/plastic_polymers/on_reaction(datum/reagents/holder, datum/equilibrium/reaction, created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i in 1 to created_volume)
		new /obj/item/stack/sheet/plastic(location)
