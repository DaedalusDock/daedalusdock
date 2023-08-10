//What?
/datum/reagent/carpet
	name = "Carpet"
	description = "For those that need a more creative way to roll out a red carpet."
	reagent_state = LIQUID
	color = "#771100"
	taste_description = "carpet" // Your tounge feels furry.
	var/carpet_type = /turf/open/floor/carpet
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/carpet/expose_turf(turf/exposed_turf, reac_volume)
	if(isopenturf(exposed_turf) && exposed_turf.turf_flags & IS_SOLID && !istype(exposed_turf, /turf/open/floor/carpet))
		exposed_turf.PlaceOnTop(carpet_type, flags = CHANGETURF_INHERIT_AIR)
	..()

/datum/reagent/carpet/black
	name = "Black Carpet"
	description = "The carpet also comes in... BLAPCK" //yes, the typo is intentional
	color = "#1E1E1E"
	taste_description = "licorice"
	carpet_type = /turf/open/floor/carpet/black
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/carpet/blue
	name = "Blue Carpet"
	description = "For those that really need to chill out for a while."
	color = "#0000DC"
	taste_description = "frozen carpet"
	carpet_type = /turf/open/floor/carpet/blue
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/carpet/cyan
	name = "Cyan Carpet"
	description = "For those that need a throwback to the years of using poison as a construction material. Smells like asbestos."
	color = "#00B4FF"
	taste_description = "asbestos"
	carpet_type = /turf/open/floor/carpet/cyan
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/carpet/green
	name = "Green Carpet"
	description = "For those that need the perfect flourish for green eggs and ham."
	color = "#A8E61D"
	taste_description = "Green" //the caps is intentional
	carpet_type = /turf/open/floor/carpet/green
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/carpet/orange
	name = "Orange Carpet"
	description = "For those that prefer a healthy carpet to go along with their healthy diet."
	color = "#E78108"
	taste_description = "orange juice"
	carpet_type = /turf/open/floor/carpet/orange
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/carpet/purple
	name = "Purple Carpet"
	description = "For those that need to waste copious amounts of healing jelly in order to look fancy."
	color = "#91D865"
	taste_description = "jelly"
	carpet_type = /turf/open/floor/carpet/purple
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/carpet/red
	name = "Red Carpet"
	description = "For those that need an even redder carpet."
	color = "#731008"
	taste_description = "blood and gibs"
	carpet_type = /turf/open/floor/carpet/red
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/carpet/royal
	name = "Royal Carpet?"
	description = "For those that break the game and need to make an issue report."

/datum/reagent/carpet/royal/affect_blood(mob/living/carbon/C, removed)
	var/obj/item/organ/liver/liver = C.getorganslot(ORGAN_SLOT_LIVER)
	if(liver)
		// Heads of staff and the captain have a "royal metabolism"
		if(HAS_TRAIT(liver, TRAIT_ROYAL_METABOLISM))
			if(prob(10))
				to_chat(C, "You feel like royalty.")
			if(prob(5))
				spawn(-1)
					C.say(pick("Peasants..","This carpet is worth more than your contracts!","I could fire you at any time..."), forced = "royal carpet")

		// The quartermaster, as a semi-head, has a "pretender royal" metabolism
		else if(HAS_TRAIT(liver, TRAIT_PRETENDER_ROYAL_METABOLISM))
			if(prob(15))
				to_chat(C, "You feel like an impostor...")

/datum/reagent/carpet/royal/black
	name = "Royal Black Carpet"
	description = "For those that feel the need to show off their timewasting skills."
	color = "#000000"
	taste_description = "royalty"
	carpet_type = /turf/open/floor/carpet/royalblack
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/carpet/royal/blue
	name = "Royal Blue Carpet"
	description = "For those that feel the need to show off their timewasting skills.. in BLUE."
	color = "#5A64C8"
	taste_description = "blueyalty" //also intentional
	carpet_type = /turf/open/floor/carpet/royalblue
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/carpet/neon
	name = "Neon Carpet"
	description = "For those who like the 1980s, vegas, and debugging."
	color = COLOR_ALMOST_BLACK
	taste_description = "neon"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	carpet_type = /turf/open/floor/carpet/neon

/datum/reagent/carpet/neon/simple_white
	name = "Simple White Neon Carpet"
	description = "For those who like fluorescent lighting."
	color = LIGHT_COLOR_HALOGEN
	taste_description = "sodium vapor"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	carpet_type = /turf/open/floor/carpet/neon/simple/white

/datum/reagent/carpet/neon/simple_red
	name = "Simple Red Neon Carpet"
	description = "For those who like a bit of uncertainty."
	color = COLOR_RED
	taste_description = "neon hallucinations"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	carpet_type = /turf/open/floor/carpet/neon/simple/red

/datum/reagent/carpet/neon/simple_orange
	name = "Simple Orange Neon Carpet"
	description = "For those who like some sharp edges."
	color = COLOR_ORANGE
	taste_description = "neon spines"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	carpet_type = /turf/open/floor/carpet/neon/simple/orange

/datum/reagent/carpet/neon/simple_yellow
	name = "Simple Yellow Neon Carpet"
	description = "For those who need a little stability in their lives."
	color = COLOR_YELLOW
	taste_description = "stabilized neon"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	carpet_type = /turf/open/floor/carpet/neon/simple/yellow

/datum/reagent/carpet/neon/simple_lime
	name = "Simple Lime Neon Carpet"
	description = "For those who need a little bitterness."
	color = COLOR_LIME
	taste_description = "neon citrus"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	carpet_type = /turf/open/floor/carpet/neon/simple/lime

/datum/reagent/carpet/neon/simple_green
	name = "Simple Green Neon Carpet"
	description = "For those who need a little bit of change in their lives."
	color = COLOR_GREEN
	taste_description = "radium"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	carpet_type = /turf/open/floor/carpet/neon/simple/green

/datum/reagent/carpet/neon/simple_teal
	name = "Simple Teal Neon Carpet"
	description = "For those who need a smoke."
	color = COLOR_TEAL
	taste_description = "neon tobacco"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	carpet_type = /turf/open/floor/carpet/neon/simple/teal

/datum/reagent/carpet/neon/simple_cyan
	name = "Simple Cyan Neon Carpet"
	description = "For those who need to take a breath."
	color = COLOR_DARK_CYAN
	taste_description = "neon air"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	carpet_type = /turf/open/floor/carpet/neon/simple/cyan

/datum/reagent/carpet/neon/simple_blue
	name = "Simple Blue Neon Carpet"
	description = "For those who need to feel joy again."
	color = COLOR_NAVY
	taste_description = "neon blue"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	carpet_type = /turf/open/floor/carpet/neon/simple/blue

/datum/reagent/carpet/neon/simple_purple
	name = "Simple Purple Neon Carpet"
	description = "For those that need a little bit of exploration."
	color = COLOR_PURPLE
	taste_description = "neon hell"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	carpet_type = /turf/open/floor/carpet/neon/simple/purple

/datum/reagent/carpet/neon/simple_violet
	name = "Simple Violet Neon Carpet"
	description = "For those who want to temp fate."
	color = COLOR_VIOLET
	taste_description = "neon hell"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	carpet_type = /turf/open/floor/carpet/neon/simple/violet

/datum/reagent/carpet/neon/simple_pink
	name = "Simple Pink Neon Carpet"
	description = "For those just want to stop thinking so much."
	color = COLOR_PINK
	taste_description = "neon pink"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	carpet_type = /turf/open/floor/carpet/neon/simple/pink

/datum/reagent/carpet/neon/simple_black
	name = "Simple Black Neon Carpet"
	description = "For those who need to catch their breath."
	color = COLOR_BLACK
	taste_description = "neon ash"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	carpet_type = /turf/open/floor/carpet/neon/simple/black
