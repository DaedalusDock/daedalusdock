/datum/crafting_recipe/upgraded_gauze
	name = "Improved Gauze"
	result = /obj/item/stack/gauze/adv/one
	time = 50
	reqs = list(/obj/item/stack/gauze = 1,
				/datum/reagent/space_cleaner = 10)
	category = CAT_MEDICAL
	blacklist = list(/obj/item/stack/gauze/improvised)

/datum/crafting_recipe/brute_pack
	name = "Suture Pack"
	result = /obj/item/stack/medical/suture/five
	time = 50
	reqs = list(/obj/item/stack/gauze = 1,
				/datum/reagent/medicine/bicaridine = 15)
	category = CAT_MEDICAL

/datum/crafting_recipe/suture
	name = "Improvised Suture"
	result = /obj/item/stack/medical/suture/emergency/five
	time = 30
	reqs = list(/obj/item/stack/gauze/improvised = 1,
				/datum/reagent/consumable/ethanol = 10)
	category = CAT_MEDICAL

/datum/crafting_recipe/ointment
	name = "Improvised Ointment"
	result = /obj/item/stack/medical/ointment/five
	time = 30
	reqs = list(/obj/item/stack/gauze/improvised = 1,
				/obj/item/food/grown/agave = 1)
	category = CAT_MEDICAL

/datum/crafting_recipe/burn_pack
	name = "Regenerative Mesh"
	result = /obj/item/stack/medical/mesh/five
	time = 50
	reqs = list(/obj/item/stack/gauze = 1,
				/datum/reagent/medicine/kelotane = 15)
	category = CAT_MEDICAL

/datum/crafting_recipe/healpowder
	name = "Healing powder"
	result = /obj/item/reagent_containers/pill/patch/healingpowder
	reqs = list(/obj/item/food/grown/broc = 3,
				/obj/item/food/grown/xander = 3)
	time = 35
	category = CAT_MEDICAL

/datum/crafting_recipe/bitterdrink
	name = "Bottle Bitterdrink"
	result = /obj/item/reagent_containers/pill/patch/bitterdrink
	reqs = list(/datum/reagent/medicine/bitter_drink = 30)
	time = 20
	category = CAT_MEDICAL

/datum/crafting_recipe/bitterdrink5
	name = "Bottle Bitterdrink (x5)"
	result = /obj/item/storage/box/medicine/bitterdrink5
	reqs = list(/datum/reagent/medicine/bitter_drink = 150)
	time = 60
	category = CAT_MEDICAL

/datum/crafting_recipe/healpoultice
	name = "Healing poultice"
	result = /obj/item/reagent_containers/pill/patch/healpoultice
	reqs = list(/obj/item/food/grown/broc = 2,
				/obj/item/food/grown/xander = 2,
				/obj/item/food/grown/feracactus = 2,
				/obj/item/food/grown/fungus = 2,
				/obj/item/food/grown/pungafruit = 2)
	time = 45
	category = CAT_MEDICAL

/*/datum/crafting_recipe/berserkerpowder
	name = "Berserker Powder"
	result = /obj/item/reagent_containers/pill/patch/healingpowder/berserker
	reqs = list(/obj/item/food/grown/broc = 3,
				/obj/item/food/grown/xander = 3,
				/obj/item/food/grown/feracactus = 3,
				/obj/item/food/grown/fungus = 3)
	time = 45
	category = CAT_MEDICAL
*/
/*
/datum/crafting_recipe/smell_salts
	name = "Smelling salts"
	result = /obj/item/smelling_salts/crafted
	reqs = list(/datum/reagent/ammonia = 10,                                 //Ammonia forces a intake of respiratory breath reflex, which is the foundation of all good smelling salts.
				/obj/item/food/onion_slice = 4,    //Sliced onions, 2 total split into 4 slices.
				/obj/item/food/grown/garlic = 2,   //Pungent garlic.
				/obj/item/food/grown/bee_balm = 2) //Beebalm was a smelling salt utilized in the victorian era for vaporous herbal remedies to things like sore throats.
	time = 50
	category = CAT_MEDICAL
*/
/datum/crafting_recipe/improvisedstimpak
	name = "Imitation Stimpak"
	result = /obj/item/reagent_containers/hypospray/medipen/stimpak/imitation
	reqs = list(/obj/item/food/grown/broc = 4,
				/obj/item/food/grown/xander = 4,
				/obj/item/reagent_containers/syringe = 1)
	tool_behaviors = list(TOOL_WORKBENCH)
	time = 45
	category = CAT_MEDICAL

/datum/crafting_recipe/stimpak
	name = "Stimpak"
	result = /obj/item/reagent_containers/hypospray/medipen/stimpak
	reqs = list(/datum/reagent/medicine/stimpak = 10,
				/obj/item/reagent_containers/syringe = 1)
	time = 1 //you're just filling a hypospray with stim fluid...
	category = CAT_MEDICAL

/datum/crafting_recipe/stimpak5
	name = "Stimpak (x5)"
	result = /obj/item/storage/box/medicine/stimpaks/stimpaks5
	reqs = list(/datum/reagent/medicine/stimpak = 50,
				/obj/item/reagent_containers/syringe = 5)
	time = 5 //you're just filling 5 hypospray with stim fluid...
	category = CAT_MEDICAL

/datum/crafting_recipe/improvisedstimpak5
	name = "Imitation Stimpak (x5)"
	result = /obj/item/storage/box/medicine/stimpaks/stimpaks5/imitation
	reqs = list(/obj/item/food/grown/broc = 20,
				/obj/item/food/grown/xander = 20,
				/obj/item/reagent_containers/syringe = 5)
	tool_behaviors = list(TOOL_WORKBENCH)
	time = 60
	category = CAT_MEDICAL

/datum/crafting_recipe/superstimpak
	name = "Super Stimpak"
	result = /obj/item/reagent_containers/hypospray/medipen/stimpak/super
	reqs = list(/obj/item/reagent_containers/hypospray/medipen/stimpak = 1,
				/obj/item/stack/sheet/leather = 2,
				/obj/item/food/grown/mutfruit = 2)
	tool_behaviors = list(TOOL_WORKBENCH)
	blacklist = list(/obj/item/reagent_containers/hypospray/medipen/stimpak/imitation)
	time = 50
	category = CAT_MEDICAL
	blacklist = list(/obj/item/reagent_containers/hypospray/medipen/stimpak/super,
					/obj/item/reagent_containers/hypospray/medipen/stimpak/custom)

/datum/crafting_recipe/superstimpak5
	name = "Super Stimpak (x5)"
	result = /obj/item/storage/box/medicine/stimpaks/superstimpaks5
	reqs = list(/obj/item/reagent_containers/hypospray/medipen/stimpak = 5,
				/obj/item/stack/sheet/leather = 10,
				/obj/item/food/grown/mutfruit = 10)
	tool_behaviors = list(TOOL_WORKBENCH)
	blacklist = list(/obj/item/reagent_containers/hypospray/medipen/stimpak/imitation)
	time = 60
	category = CAT_MEDICAL
	blacklist = list(/obj/item/reagent_containers/hypospray/medipen/stimpak/super,
					/obj/item/reagent_containers/hypospray/medipen/stimpak/custom)

/datum/crafting_recipe/salvage_stimpak
	name = "Salvage injector"
	result = /obj/item/reagent_containers/syringe
	reqs = list(/obj/item/reagent_containers/hypospray/medipen/stimpak = 1)
	time = 20
	tool_behaviors = list(TOOL_WORKBENCH)
	category = CAT_MEDICAL


/datum/crafting_recipe/jet
	name = "Jet"
	result = /obj/item/reagent_containers/pill/patch/jet
	reqs = list(/obj/item/clothing/mask/cigarette = 1,
				/datum/reagent/consumable/milk = 10,
				/obj/item/toy/crayon/spraycan = 1)
	time = 35
	tool_behaviors = list(TOOL_WORKBENCH)
	category = CAT_MEDICAL
	always_availible = FALSE

/datum/crafting_recipe/turbo
	name = "Turbo"
	result = /obj/item/reagent_containers/pill/patch/turbo
	reqs = list(/obj/item/food/grown/feracactus = 2,
				/obj/item/food/grown/agave = 2,
				/datum/reagent/consumable/ethanol/whiskey = 15)
	time = 35
	tool_behaviors = list(TOOL_WORKBENCH)
	category = CAT_MEDICAL
	always_availible = FALSE

/datum/crafting_recipe/psycho
	name = "Psycho"
	result = /obj/item/reagent_containers/hypospray/medipen/psycho
	reqs = list(/obj/item/food/grown/feracactus = 3,
				/obj/item/food/grown/fungus = 3,
				/datum/reagent/consumable/nuka_cola = 10)
	time = 35
	tool_behaviors = list(TOOL_WORKBENCH)
	category = CAT_MEDICAL
	always_availible = FALSE

/datum/crafting_recipe/medx
	name = "Med-X"
	result = /obj/item/reagent_containers/hypospray/medipen/medx
	reqs = list(/obj/item/reagent_containers/syringe = 1,
				/obj/item/food/grown/pungafruit = 2,
				/obj/item/food/grown/datura = 2,
				/obj/item/food/grown/coyotetobacco = 2,
				/obj/item/food/grown/xander = 2,
				/obj/item/food/grown/broc = 2)
	time = 35
	tool_behaviors = list(TOOL_WORKBENCH, TOOL_WELDER)
	category = CAT_MEDICAL
	always_availible = FALSE

/datum/crafting_recipe/buffout
	name = "Buffout"
	result = /obj/item/storage/pill_bottle/chem_tin/buffout
	reqs = list(/obj/item/storage/pill_bottle = 1,
				/obj/item/food/grown/buffalogourd = 10,
				/obj/item/food/grown/yucca = 10,
				/obj/item/food/grown/mutfruit = 5,
				/datum/reagent/consumable/nuka_cola = 60)
	time = 50
	tool_behaviors = list(TOOL_WORKBENCH)
	category = CAT_MEDICAL
	always_availible = FALSE

/datum/crafting_recipe/extract_gaia
	name = "Extract gaia"
	result = /obj/item/reagent_containers/cup/bottle/gaia
	reqs = list(/obj/item/food/grown/ambrosia/gaia  = 6,
	/datum/reagent/water = 50)
	time = 20
	tool_behaviors = list(TOOL_WORKBENCH)
	category = CAT_MEDICAL
