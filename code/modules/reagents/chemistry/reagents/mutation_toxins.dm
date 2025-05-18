#define MUT_MSG_IMMEDIATE 1
#define MUT_MSG_EXTENDED 2
#define MUT_MSG_ABOUT2TURN 3

/datum/reagent/mutationtoxin
	name = "Stable Mutation Toxin"
	description = "A humanizing toxin."
	color = "#5EFF3B" //RGB: 94, 255, 59
	metabolization_rate = 0.1 //metabolizes to prevent micro-dosage
	taste_description = "slime"
	chemical_flags = REAGENT_IGNORE_MOB_SIZE | REAGENT_SPECIAL
	var/race = /datum/species/human
	var/list/mutationtexts = list( "You don't feel very well." = MUT_MSG_IMMEDIATE,
									"Your skin feels a bit abnormal." = MUT_MSG_IMMEDIATE,
									"Your limbs begin to take on a different shape." = MUT_MSG_EXTENDED,
									"Your appendages begin morphing." = MUT_MSG_EXTENDED,
									"You feel as though you're about to change at any moment!" = MUT_MSG_ABOUT2TURN)
	var/cycles_to_turn = 20 //the current_cycle threshold / iterations needed before one can transform

/datum/reagent/mutationtoxin/affect_blood(mob/living/carbon/human/H, removed)
	if(!istype(H))
		return
	if(!(H.dna?.species) || !(H.mob_biotypes & MOB_ORGANIC))
		return

	if(prob(10))
		var/list/pick_ur_fav = list()
		var/filter = NONE
		if(current_cycle <= (cycles_to_turn*0.3))
			filter = MUT_MSG_IMMEDIATE
		else if(current_cycle <= (cycles_to_turn*0.8))
			filter = MUT_MSG_EXTENDED
		else
			filter = MUT_MSG_ABOUT2TURN

		for(var/i in mutationtexts)
			if(mutationtexts[i] == filter)
				pick_ur_fav += i
		to_chat(H, span_warning("[pick(pick_ur_fav)]"))

	if(current_cycle >= cycles_to_turn)
		var/datum/species/species_type = race
		H.set_species(species_type)
		holder.del_reagent(type)
		to_chat(H, span_warning("You've become \a [lowertext(initial(species_type.name))]!"))
		return

/datum/reagent/mutationtoxin/classic //The one from plasma on green slimes
	name = "Mutation Toxin"
	description = "A corruptive toxin."
	color = "#13BC5E" // rgb: 19, 188, 94
	race = /datum/species/jelly/slime


/datum/reagent/mutationtoxin/lizard
	name = "Jinan Mutation Toxin"
	description = "A lizarding toxin."
	color = "#5EFF3B" //RGB: 94, 255, 59
	race = /datum/species/lizard
	taste_description = "dragon's breath but not as cool"


/datum/reagent/mutationtoxin/fly
	name = "Fly Mutation Toxin"
	description = "An insectifying toxin."
	color = "#5EFF3B" //RGB: 94, 255, 59
	race = /datum/species/fly
	taste_description = "trash"
	chemical_flags = REAGENT_NO_RANDOM_RECIPE

/datum/reagent/mutationtoxin/moth
	name = "Gamuioda Mutation Toxin"
	description = "A glowing toxin."
	color = "#5EFF3B" //RGB: 94, 255, 59
	race = /datum/species/moth
	taste_description = "clothing"
	chemical_flags = REAGENT_NO_RANDOM_RECIPE

/datum/reagent/mutationtoxin/pod
	name = "Podperson Mutation Toxin"
	description = "A vegetalizing toxin."
	color = "#5EFF3B" //RGB: 94, 255, 59
	race = /datum/species/pod
	taste_description = "flowers"
	chemical_flags = REAGENT_NO_RANDOM_RECIPE

/datum/reagent/mutationtoxin/jelly
	name = "Imperfect Mutation Toxin"
	description = "A jellyfying toxin."
	color = "#5EFF3B" //RGB: 94, 255, 59
	race = /datum/species/jelly
	taste_description = "grandma's gelatin"


/datum/reagent/mutationtoxin/jelly/affect_blood(mob/living/carbon/human/H, removed)
	. = ..()
	if(isjellyperson(H))
		to_chat(H, span_warning("Your jelly shifts and morphs, turning you into another subspecies!"))
		var/species_type = pick(subtypesof(/datum/species/jelly))
		H.set_species(species_type)
		holder.del_reagent(type)
		return TRUE
	if(current_cycle >= cycles_to_turn) //overwrite since we want subtypes of jelly
		var/datum/species/species_type = pick(subtypesof(race))
		H.set_species(species_type)
		holder.del_reagent(type)
		to_chat(H, span_warning("You've become \a [initial(species_type.name)]!"))
		return TRUE

/datum/reagent/mutationtoxin/abductor
	name = "Abductor Mutation Toxin"
	description = "An alien toxin."
	color = "#5EFF3B" //RGB: 94, 255, 59
	race = /datum/species/abductor
	taste_description = "something out of this world... no, universe!"
	chemical_flags = REAGENT_NO_RANDOM_RECIPE

/datum/reagent/mutationtoxin/android
	name = "Android Mutation Toxin"
	description = "A robotic toxin."
	color = "#5EFF3B" //RGB: 94, 255, 59
	race = /datum/species/android
	taste_description = "circuitry and steel"
	chemical_flags = REAGENT_NO_RANDOM_RECIPE

//BLACKLISTED RACES
/datum/reagent/mutationtoxin/skeleton
	name = "Skeleton Mutation Toxin"
	description = "A scary toxin."
	color = "#5EFF3B" //RGB: 94, 255, 59
	race = /datum/species/skeleton
	taste_description = "milk... and lots of it"
	chemical_flags = REAGENT_NO_RANDOM_RECIPE

/datum/reagent/mutationtoxin/zombie
	name = "Zombie Mutation Toxin"
	description = "An undead toxin."
	color = "#5EFF3B" //RGB: 94, 255, 59
	race = /datum/species/zombie //Not the infectious kind. The days of xenobio zombie outbreaks are long past.
	taste_description = "brai...nothing in particular"
	chemical_flags = REAGENT_NO_RANDOM_RECIPE

//DANGEROUS RACES
/datum/reagent/mutationtoxin/shadow
	name = "Shadow Mutation Toxin"
	description = "A dark toxin."
	color = "#5EFF3B" //RGB: 94, 255, 59
	race = /datum/species/shadow
	taste_description = "the night"
	chemical_flags = REAGENT_NO_RANDOM_RECIPE

#undef MUT_MSG_IMMEDIATE
#undef MUT_MSG_EXTENDED
#undef MUT_MSG_ABOUT2TURN
