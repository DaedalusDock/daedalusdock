//these are items that don't fit in a category, and don't justify adding a new category.
//Try to avoid adding to this if you can so it's easier to find recipes.

/datum/slapcraft_recipe/mousetrap
	name = "mouse trap"
	examine_hint = "You could add a metal rod to make a mouse trap..."
	category = SLAP_CAT_MISC
	steps = list(
		/datum/slapcraft_step/stack/cardboard/one,
		/datum/slapcraft_step/stack/rod/one
	)
	result_type = /obj/item/assembly/mousetrap

//paper
/datum/slapcraft_recipe/papersack
	name = "paper sack"
	examine_hint = "With a cutting tool and more paper, you could make a bag..."
	category = SLAP_CAT_MISC
	steps = list(
		/datum/slapcraft_step/item/paper,
		/datum/slapcraft_step/attack/sharp,
		/datum/slapcraft_step/item/paper/second
	)
	result_type = /obj/item/storage/box/papersack

/datum/slapcraft_recipe/papercup
	name = "paper cup"
	examine_hint = "If you cut this and add a second sheet of paper, you could make a cup..."
	category = SLAP_CAT_MISC
	steps = list(
		/datum/slapcraft_step/item/paper,
		/datum/slapcraft_step/attack/sharp,
	)
	result_type = /obj/item/reagent_containers/cup/glass/sillycup

/datum/slapcraft_recipe/paperframe
	name = "paper frame"
	examine_hint = "With a plank of wood and some paper, you could make a paper frame for a wall or window..."
	category = SLAP_CAT_MISC
	steps = list(
		/datum/slapcraft_step/stack/wood/one,
		/datum/slapcraft_step/item/paper,
		/datum/slapcraft_step/item/paper/second,
		/datum/slapcraft_step/item/paper/third,
		/datum/slapcraft_step/item/paper/fourth,
		/datum/slapcraft_step/item/paper/fifth //okay maybe we need paper as a sheet type
	)
	result_type = /obj/item/stack/sheet/paperframes
