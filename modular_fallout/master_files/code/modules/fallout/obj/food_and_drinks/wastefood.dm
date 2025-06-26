//FOOD FALLOUT 13///////

/obj/item/food/soup/macaco
	name = "Macaco soup"
	desc = "To think, the monkey would've beat you to death and steal your gun."
	icon_state = "macaco"
	food_reagents = list( /datum/reagent/consumable/nutriment/vitamin = 1, /datum/reagent/medicine/omnizine = 5,  /datum/reagent/consumable/nutriment/vitamin = 5)
	tastes = list("Monkey" = 1)
	foodtypes = MEAT | VEGETABLES

/////PLANTS Fallout 13///////

/obj/item/seeds/buffalogourd
	name = "pack of buffalo gourd seeds"
	desc = "These seeds grow into buffalo vines.<br><b>they appear to be edible once cooked!</b>"
	icon_state = "seed-gourd"
	plant_type = /datum/plant/buffalogourd

/datum/plant/buffalogourd
	species = "buffalo gourd"
	product_path  = /obj/item/food/grown/buffalogourd
	growing_icon = 'modular_fallout/master_files/icons/obj/hydroponics/growing_vegetables.dmi'
	icon_grow = "gourd-grow"
	icon_dead = "gourd-dead"
	icon_harvest = "gourd-harvest"
	reagents_per_potency = list(/datum/reagent/water = 0.2,  /datum/reagent/toxin = 0.1)
	base_harvest_amt = 5
	base_endurance = 40
	base_maturation = 10
	base_production = 1
	base_harvest_yield = 3
	growthstages = 3

/obj/item/seeds/buffalogourd/microwave_act(obj/machinery/microwave/MW) //The act allows it to be cooked over a bonfire grille too.
	..()
	new /obj/item/food/roastseeds/buffalogourd(drop_location())
	qdel(src)

/obj/item/food/roastseeds/buffalogourd //Inherits from pumpkin.dm's roast seeds, similarity commented out for clarity
	name = "roasted gourd seeds"
	desc = "Well prepared crispy buffalo gourd seeds, full of chewy protein."
	//icon_state = "roasted_seeds"
	list_reagents = list(/datum/reagent/consumable/cooking_oil = 1, /datum/reagent/consumable/nutriment = 2, /datum/reagent/consumable/nutriment/vitamin = 1.5)
	//bitesize = 2
	//w_class = WEIGHT_CLASS_TINY
	//tastes = list("crunchy" = 1)
	foodtypes = GRAIN

/obj/item/food/grown/buffalogourd
	name = "buffalo gourd"
	desc = "A bitter tasting vine plant, with a watery fleshy texture."
	icon_state = "buffalo_gourd"
	filling_color = "#008000"
	bite_consumption_mod = 3
	foodtypes = FRUIT | GROSS
	juice_results = list(/datum/reagent/lye= 0.5) // The oil made from the gourd plant itself is used in Native American soap.
	distill_reagent = list(/datum/chemical_reaction/pestkiller= 0.25) //Native Americans used the extract of gourd as small vermin pesticide.
	plant_datum = /datum/plant/buffalogourd

/obj/item/seeds/coyotetobacco
	name = "pack of coyote tobacco seeds"
	desc = "These seeds grow into coyote tobacco plants."
	icon_state = "seed-coyote"
	plant_type = /datum/plant/coyotetobacco

/datum/plant/coyotetobacco
	species = "coyote tobacco"
	product_path  = /obj/item/food/grown/coyotetobacco
	innate_genes = list(/datum/plant_gene/product_trait/plant_type/weed_hardy)
	base_maturation = 5
	base_production = 5
	base_harvest_yield = 10
	growthstages = 4
	growing_icon = 'modular_fallout/master_files/icons/obj/hydroponics/growing_vegetables.dmi'
	icon_grow = "coyote-grow"
	icon_dead = "coyote-dead"
	icon_harvest = "coyote-harvest"
	reagents_per_potency = list(/datum/reagent/drug/nicotine = 0.1,  /datum/reagent/consumable/nutriment = 0.1)

/obj/item/food/grown/coyotetobacco
	name = "coyote tobacco leaves"
	desc = "This tobacco like plant is commonly used by tribals for a great variety of medicinal and ceremonial purposes."
	icon_state = "Coyote Tobacco"
	filling_color = "#008000"
	juice_results = list(/datum/reagent/consumable/tea/coyotetea = 0)
	distill_reagent = /datum/reagent/consumable/ethanol/deathroach
	plant_datum = /datum/plant/coyotetobacco

/obj/item/seeds/feracactus
	name = "pack of barrel cactus seeds"
	desc = "These seeds grow into a barrel cactus."
	icon_state = "seed-feracactus"
	plant_type = /datum/plant/feracactus


/datum/plant/feracactus
	growing_icon = 'modular_fallout/master_files/icons/obj/hydroponics/growing_fruits.dmi'
	icon_grow = "feracactus-grow"
	icon_dead = "feracactus-dead"
	icon_harvest = "feracactus-harvest"
	species = "barrel cactus"
	product_path = /obj/item/food/grown/feracactus
	base_endurance = 20
	base_harvest_yield = 2
	growthstages = 2
	base_production = 5
	base_maturation = 5
	reagents_per_potency = list(/datum/reagent/consumable/nutriment = 0.1, /datum/reagent/medicine/dylovene = 0.1,)

/obj/item/food/grown/feracactus
	name = "barrel cactus fruit"
	desc = "Carefully harvested spineless barrel-cactus fruit, it feels dry to the touch but appears more than edible."
	icon_state = "feracactus"
	filling_color = "#FF6347"
	foodtypes = FRUIT
	juice_results = list(/datum/reagent/consumable/tea/feratea = 0)
	distill_reagent = /datum/reagent/consumable/ethanol/yellowpulque
	plant_datum = /datum/plant/feracactus


/obj/item/seeds/poppy/broc
	name = "pack of broc seeds"
	desc = "These seeds grow into broc flowers."
	icon_state = "seed-broc"
	plant_type = /datum/plant/broc

/datum/plant/broc
	species = "broc"
	product_path = /obj/item/food/grown/broc
	base_endurance = 10
	base_harvest_yield = 4
	growthstages = 3
	base_production = 4
	base_maturation = 4
	growing_icon = 'modular_fallout/master_files/icons/obj/hydroponics/growing_flowers.dmi'
	icon_harvest = "broc-harvest"
	icon_grow = "broc-grow"
	icon_dead = "broc-dead"
	//mutatelist = list(/obj/item/seeds/geraniumseed, /obj/item/seeds/lilyseed)
	reagents_per_potency = list(/datum/reagent/medicine/dexalin = 0.2, /datum/reagent/medicine/saline_glucose = 0.05, /datum/reagent/consumable/nutriment = 0.1, /datum/reagent/medicine/bicaridine = 0.1,)

/obj/item/food/grown/broc
	name = "broc flower"
	desc = "This vibrant, orange flower grows on tall stalks in the wasteland and exhibits moderate healing properties, even when unprocessed."
	icon_state = "broc"
	//slot_flags = SLOT_HEAD
	filling_color = "#FF6347"
	juice_results = list(/datum/reagent/consumable/tea/broctea = 0)
	distill_reagent = /datum/reagent/consumable/ethanol/brocbrew
	plant_datum = /datum/plant/broc

/obj/item/seeds/xander
	name = "pack of xander seeds"
	desc = "These seeds grow into xander roots."
	icon_state = "seed-xander"
	plant_type = /datum/plant/xander

/datum/plant/xander
	species = "xander"
	product_path = /obj/item/food/grown/xander
	base_endurance = 10
	base_harvest_yield = 3
	growthstages = 4
	base_production = 4
	base_maturation = 4
	growing_icon = 'modular_fallout/master_files/icons/obj/hydroponics/growing_vegetables.dmi'
	icon_grow = "xander-grow"
	icon_harvest = "xander-harvest"
	icon_dead = "xander-dead"
	reagents_per_potency = list(/datum/reagent/medicine/dylovene = 0.2, /datum/reagent/medicine/saline_glucose = 0.05, /datum/reagent/consumable/nutriment = 0.1)

/obj/item/food/grown/xander
	name = "xander root"
	desc = "Xander roots are large, hardy, turnip-like roots with mild healing properties."
	icon_state = "xander"
	filling_color = "#FF6347"
	juice_results = list(/datum/reagent/consumable/tea/xandertea = 0)
	distill_reagent = /datum/reagent/consumable/ethanol/salgam
	plant_datum = /datum/plant/xander

/*HRP*/

/obj/item/seeds/horsenettle
	name = "pack of horsenettle seeds"
	desc = "These seeds grow into white horsenettles."
	icon_state = "seed-horsenettle"
	plant_type = /datum/plant/horsenettle

/datum/plant/horsenettle
	species = "horsenettle"
	product_path = /obj/item/food/grown/horsenettle
	base_endurance = 40
	base_harvest_yield = 4
	growthstages = 4
	growing_icon = 'modular_fallout/master_files/icons/obj/hydroponics/growing_vegetables.dmi'
	icon_grow = "horsenettle-grow"
	icon_dead = "horsenettle-dead"
	icon_harvest = "horsenettle-harvest"
	innate_genes = list(/datum/plant_gene/product_trait/plant_type/weed_hardy)
	reagents_per_potency = list( /datum/reagent/consumable/nutriment/vitamin = 0.04,  /datum/reagent/consumable/nutriment = 0.1)

/obj/item/food/grown/horsenettle
	name = "horsenettle berries"
	desc = "The tribes use these berries as a vegetable rennet."
	icon_state = "White Horsenettle"
	filling_color = "#FF00FF"
	bite_consumption_mod = 2
	foodtypes = FRUIT
	juice_results = list(/datum/reagent/consumable/enzyme = 1)
	tastes = list("searing pain" = 1)
	distill_reagent = /datum/reagent/consumable/enzyme
	plant_datum = /datum/plant/horsenettle


/obj/item/seeds/mesquite
	name = "pack of honey mesquite seeds"
	desc = "These seeds grows into a mesquite plant."
	icon_state = "mycelium-tower"
	plant_type = /datum/plant/mesquite

/datum/plant/mesquite
	species = "honey mesquite"
	product_path = /obj/item/food/grown/mesquite
	base_endurance = 50
	base_maturation = 6
	base_production = 5
	base_harvest_yield = 5
	base_potency = 50
	growthstages = 4
	growing_icon = 'modular_fallout/master_files/icons/obj/hydroponics/growing_vegetables.dmi'
	icon_grow = "mesquite-grow"
	icon_dead = "mesquite-dead"
	icon_harvest = "mesquite-harvest"
	reagents_per_potency = list(/datum/reagent/consumable/honey = 0.1, /datum/reagent/consumable/nutriment = 0.05)

/obj/item/food/grown/mesquite
	name = "honey mesquite pods"
	desc = "The honey mesquite pod grows on a short tree with willow-like branches. Trees with pickable pods will appear bushier in foliage and have strings of pods on them, resembling a fern pattern. Pods can be eaten or used in recipes"
	gender = PLURAL
	icon_state = "Mesquite Pod"
	filling_color = "#F0E68C"
	bite_consumption_mod = 2
	foodtypes = VEGETABLES
	juice_results = list(/datum/reagent/consumable/honey = 0.1)
	tastes = list("crunchy sweetness" = 1)
	distill_reagent = /datum/reagent/consumable/ethanol/wastemead
	plant_datum = /datum/plant/mesquite

/obj/item/seeds/pinyon
	name = "pack of pinyon pine seeds"
	desc = "The seeds of the pinyon pine, known as pine nuts or pi��ns, are an important food for settlers and tribes living in the mountains of the North American Southwest. All species of pine produce edible seeds, but in North America only the pinyon produces seeds large enough to be a major source of food."
	icon_state = "seed-pinyon"
	plant_type = /datum/plant/pinyon

/datum/plant/pinyon
	species = "pinyon pine"
	name = "Pinyon Pine"
	base_endurance = 50
	base_maturation = 9
	base_production = 6
	base_harvest_yield = 5
	base_potency = 50
	growthstages = 4
	growing_icon = 'modular_fallout/master_files/icons/obj/hydroponics/growing_vegetables.dmi'
	icon_grow = "pinyon-grow"
	icon_dead = "pinyon-dead"
	icon_harvest = "pinyon-harvest"
	reagents_per_potency = list( /datum/reagent/consumable/nutriment = 0.05)

/obj/item/food/grown/pinyon
	name = "pinyon nuts"
	desc = "The seeds of the pinyon pine, known as pine nuts or pi��ns, are an important food for settlers and tribes living in the mountains of the North American Southwest. All species of pine produce edible seeds, but in North America only the pinyon produces seeds large enough to be a major source of food."
	gender = PLURAL
	icon_state = "Pinyon Nuts"
	filling_color = "#F0E68C"
	bite_consumption_mod = 2
	foodtypes = GRAIN
	grind_results = list(/datum/reagent/consumable/flour = 0)
	tastes = list("pine nuts" = 1)
	plant_datum = /datum/plant/pinyon

/obj/item/seeds/pricklypear
	name = "pack of prickly pear seeds"
	desc = "These seeds grow into a prickly pear cactus."
	icon_state = "seed-prickly"
	plant_type = /datum/plant/pricklypear

/datum/plant/pricklypear
	growing_icon = 'modular_fallout/master_files/icons/obj/hydroponics/growing_vegetables.dmi'
	icon_grow = "prickly-grow"
	icon_dead = "prickly-dead"
	icon_harvest = "prickly-harvest"
	species = "prickly pear"
	product_path = /obj/item/food/grown/pricklypear
	reagents_per_potency = list(/datum/reagent/consumable/nutriment = 0.2, /datum/reagent/water = 0.1, /datum/reagent/consumable/nutriment/vitamin = 0.05)
	base_endurance = 20
	base_harvest_yield = 2
	growthstages = 4
	base_production = 4
	base_maturation = 5

/obj/item/food/grown/pricklypear
	name = "prickly pear fruit"
	desc = "Distinguished by having cylindrical, rather than flattened, stem segments with large barbed spines. The stem joints are very brittle on young stems, readily breaking off when the barbed spines stick to clothing or animal fur."
	icon_state = "Prickly Pear"
	filling_color = "#FF6347"
	foodtypes = FRUIT
	bite_consumption_mod = 2
	juice_results = list(/datum/reagent/consumable/tea/pricklytea = 0)
	tastes = list("sweet cactus" = 1)
	distill_reagent = /datum/reagent/consumable/ethanol/pinkpulque
	plant_datum = /datum/plant/pricklypear

/obj/item/grown/pricklypear/pickup(mob/living/user)
	..()
	if(!iscarbon(user))
		return FALSE
	var/mob/living/carbon/C = user
	if(C.gloves)
		return FALSE
	var/hit_zone = (C.held_index_to_dir(C.active_hand_index) == "l" ? "l_":"r_") + "arm"
	var/obj/item/bodypart/affecting = C.get_bodypart(hit_zone)
	if(affecting)
		if(affecting.receive_damage(0, force))
			C.update_damage_overlays()
	to_chat(C, "<span class='userdanger'>The thorns pierce your bare hand!</span>")
	return TRUE

/obj/item/seeds/datura
	name = "pack of datura seeds"
	desc = "These seeds grow into datura plants."
	icon_state = "seed-datura"
	plant_type = /datum/plant/datura

/datum/plant/datura
	species = "Datura"
	product_path = /obj/item/food/grown/datura
	base_maturation = 6
	base_production = 5
	base_harvest_yield = 4
	growthstages = 5
	growing_icon = 'modular_fallout/master_files/icons/obj/hydroponics/growing_vegetables.dmi'
	icon_grow = "datura-grow"
	icon_dead = "datura-dead"
	icon_harvest = "datura-harvest"
	reagents_per_potency = list(/datum/reagent/medicine/morphine = 0.2, /datum/reagent/drug/mushroomhallucinogen = 0.1, /datum/reagent/toxin = 0.05,  /datum/reagent/consumable/nutriment = 0.1)

/obj/item/food/grown/datura
	name = "Datura"
	desc = "The sacred datura root, useful as an anesthetic for surgery and in healing salves, as well as for rites of passage rituals and ceremonies"
	icon_state = "Datura"
	filling_color = "#FFA500"
	bite_consumption_mod = 2
	foodtypes = VEGETABLES
	juice_results = list(/datum/reagent/consumable/ethanol/daturatea = 0)
	distill_reagent = /datum/reagent/consumable/ethanol/daturatea
	plant_datum = /datum/plant/datura

/obj/item/seeds/punga
	name = "pack of punga seeds"
	desc = "These small black pits grow into a punga bush"
	icon_state = "seed-punga"
	plant_type = /datum/plant/punga

/datum/plant/punga
	species = "punga"
	product_path = /obj/item/food/grown/pungafruit
	base_endurance = 30
	base_maturation = 10
	base_production = 5
	base_harvest_yield = 3
	base_potency = 30
	growthstages = 4
	rarity = 20
	growing_icon = 'modular_fallout/master_files/icons/obj/hydroponics/growing_vegetables.dmi'
	icon_grow = "punga-grow"
	icon_dead = "punga-dead"
	icon_harvest = "punga-harvest"
	innate_genes = list(/datum/plant_gene/product_trait/plant_type/fungal_metabolism)
	reagents_per_potency = list(/datum/reagent/medicine/activated_charcoal = 0.1, /datum/reagent/consumable/nutriment = 0.1, /datum/reagent/medicine/radaway = 0.05)

/obj/item/food/grown/pungafruit
	name = "pungafruit"
	desc = "Punga fruit plants flower at a single point at the terminus of their stems, gradually developing into large, fleshy fruits with a yellow/brown, thick skin. They are common throughout Point Lookout, due to the unique conditions offered by the swamps, and scrub radiation when ingested."
	icon_state = "Punga Fruit"
	filling_color = "#FF6347"
	juice_results = list(/datum/reagent/consumable/ethanol/pungajuice = 0)
	plant_datum = /datum/plant/punga

/obj/item/seeds/yucca
	name = "pack of banana yucca seeds"
	desc = "These seeds grow into a yucca plant."
	icon = 'modular_fallout/master_files/icons/obj/hydroponics/seeds.dmi'
	plant_type = /datum/plant/yucca

/datum/plant/yucca
	growing_icon = "seed-yucca"
	species = "banna yucca"
	product_path = /obj/item/food/grown/yucca
	base_endurance = 30
	base_harvest_yield = 5
	growthstages = 4
	base_maturation = 5
	base_production = 4
	growing_icon = 'modular_fallout/master_files/icons/obj/hydroponics/growing_vegetables.dmi'
	icon_grow = "yucca-grow"
	icon_dead = "yucca-dead"
	icon_harvest = "yucca-harvest"
	reagents_per_potency = list( /datum/reagent/consumable/nutriment = 0.2, /datum/reagent/consumable/sugar = 0.1,  /datum/reagent/consumable/nutriment/vitamin = 0.2)

/obj/item/food/grown/yucca
	name = "banana yucca fruit"
	desc = "The fleshy banana like fruit, rougly 8 cm long and 6 cm across. It tastes similar to a sweet potato."
	icon_state = "Bannana Yucca"
	icon = 'modular_fallout/master_files/icons/obj/hydroponics/harvest.dmi'
	juice_results = list(/datum/reagent/consumable/yuccajuice = 0)
	distill_reagent = /datum/reagent/consumable/yuccajuice
	plant_datum = /datum/plant/yucca

/obj/item/seeds/tato
	name = "pack of tato seeds"
	desc = "a pack of tato seeds"
	icon_state = "seed-tato"
	plant_type = /datum/plant/tato

/datum/plant/tato
	species = "tato"
	product_path = /obj/item/food/grown/tato
	base_maturation = 7
	base_production = 3
	base_harvest_yield = 4
	growthstages = 4
	growing_icon = 'modular_fallout/master_files/icons/obj/hydroponics/growing_vegetables.dmi'
	icon_grow = "tato-grow"
	icon_dead = "tato-dead"
	icon_harvest = "tato-harvest"
	innate_genes = list(/datum/plant_gene/product_trait/battery)
	reagents_per_potency = list( /datum/reagent/consumable/nutriment/vitamin = 0.04,  /datum/reagent/consumable/nutriment = 0.1)

/obj/item/food/grown/tato
	name = "tato"
	desc = "The outside looks like a tomato, but the inside is brown. Tastes as absolutely disgusting as it looks, but will keep you from starving."
	icon_state = "Tato"
	filling_color = "#E9967A"
	foodtypes = VEGETABLES
	juice_results = list(/datum/reagent/consumable/tato_juice = 0)
	distill_reagent = /datum/reagent/consumable/ethanol/tatovodka
	plant_datum = /datum/plant/tato

/obj/item/food/grown/tato/wedges
	name = "tato wedges"
	desc = "Slices of neatly cut tato."
	icon_state = "potato_wedges"
	filling_color = "#E9967A"

/obj/item/food/grown/tato/attackby(obj/item/W, mob/user, params)
	if(W.get_sharpness())
		to_chat(user, "<span class='notice'>You cut the tato into wedges with [W].</span>")
		var/obj/item/food/grown/tato/wedges/Wedges = new /obj/item/food/grown/tato/wedges
		remove_item_from_storage(user)
		qdel(src)
		user.put_in_hands(Wedges)
	else
		return ..()


/obj/item/seeds/mutfruit
	name = "pack of mutfruit seeds"
	desc = "These seeds grow into a mutfruit sapling."
	icon_state = "seed-mutfruit"
	plant_type = /datum/plant/mutfruit

/datum/plant/mutfruit
	species = "mutfruit"
	growing_icon = 'modular_fallout/master_files/icons/obj/hydroponics/growing_fruits.dmi'
	icon_grow = "mutfruit-grow"
	icon_dead = "mutfruit-dead"
	product_path = /obj/item/food/grown/mutfruit
	base_endurance = 20
	base_harvest_yield = 3
	growthstages = 3
	base_production = 5
	base_maturation = 5
	reagents_per_potency = list(/datum/reagent/consumable/nutriment/vitamin = 0.05, /datum/reagent/consumable/nutriment = 0.1, /datum/reagent/uranium/radium = 0.15)

/obj/item/food/grown/mutfruit
	name = "mutfruit"
	desc = "Mutfruit provides both hydration and sustenance, but the mutated plant also carries small amounts of radiation."
	icon_state = "mutfruit"
	filling_color = "#FF6347"
	distill_reagent = /datum/reagent/consumable/ethanol/purplecider
	juice_results = list(/datum/reagent/consumable/mutjuice = 0)
	plant_datum = /datum/plant/mutfruit

//Fallout mushrooms

/obj/item/seeds/fungus
	name = "pack of cave fungus mycelium"
	desc = "This mycelium grows into cave fungi, an edible variety of mushroom with anti-toxic properties."
	icon_state = "seed-fungus"
	plant_type = /datum/plant/fungus

/datum/plant/fungus
	species = "cave fungus"
	product_path = /obj/item/food/grown/fungus
	growing_icon = 'modular_fallout/master_files/icons/obj/hydroponics/growing_mushrooms.dmi'
	icon_grow = "cave_fungus-grow"
	icon_dead = "cave_fungus-dead"
	icon_harvest = "cave_fungus-harvest"
	base_endurance = 10
	base_maturation = 8
	base_production = 3
	base_harvest_yield = 6
	base_potency = 20
	growthstages = 2
	reagents_per_potency = list(/datum/reagent/medicine/activated_charcoal = 0.05, /datum/reagent/medicine/ryetalyn = 0.05)
	innate_genes = list(/datum/plant_gene/product_trait/plant_type/fungal_metabolism)

/obj/item/food/grown/fungus
	name = "cave fungus"
	desc = "Cave fungus is an edible mushroom which has the ability to purge bodily toxins."
	icon_state = "fungus"
	filling_color = "#FF6347"
	plant_datum = /datum/plant/fungus

/obj/item/seeds/glow
	name = "pack of glowing fungus seeds"
	desc = "These seeds grow into glowing fungus."
	icon = 'modular_fallout/master_files/icons/obj/hydroponics/seeds.dmi'
	plant_type = /datum/plant/glow

/datum/plant/glow
	growing_icon = "mycelium-glow"
	species = "glow"
	product_path = /obj/item/food/grown/glow
	base_endurance = 10
	base_harvest_yield = 5
	growthstages = 3
	base_production = 20
	base_maturation = 20
	growing_icon = 'modular_fallout/master_files/icons/fallout/flora/flora.dmi'
	icon_grow = "glow-grow"
	icon_dead = "glow-dead"
	icon_harvest = "glow-harvest"
	innate_genes = list(/datum/plant_gene/product_trait/glow)
	reagents_per_potency = list(/datum/reagent/drug/space_drugs = 0.04, /datum/reagent/toxin/mindbreaker = 0.1, /datum/reagent/toxin/mutagen = 0.01, /datum/reagent/uranium/radium = 0.05)

/obj/item/food/grown/glow
	name = "shroom"
	desc = "An edible mushroom which has the ability to decrease radiation levels."
	icon_state = "shroom"
	icon = 'modular_fallout/master_files/icons/obj/hydroponics/harvest.dmi'
	filling_color = "#FF6347"
	plant_datum = /datum/plant/glow


/*MRP*/


/obj/item/seeds/agave
	name = "pack of agave seeds"
	desc = "These seeds grow into an agave plant."
	icon = 'modular_fallout/master_files/icons/obj/hydroponics/seeds.dmi'
	plant_type = /datum/plant/agave

/datum/plant/agave
	growing_icon = "seed-agave"
	species = "agave"
	product_path = /obj/item/food/grown/agave
	base_endurance = 10
	base_harvest_yield = 5
	growthstages = 3
	base_production = 7
	base_maturation = 7
	growing_icon = 'modular_fallout/master_files/icons/obj/hydroponics/growing_fruits.dmi'
	icon_grow = "agave-grow"
	icon_dead = "agave-dead"
	icon_harvest = "agave-harvest"
	reagents_per_potency = list(/datum/reagent/medicine/kelotane = 0.1, /datum/reagent/toxin/lipolicide = 0.1 )

/obj/item/food/grown/agave
	name = "agave leaf"
	desc = "A strange kind of fleshy grass often used as a primitive burn medication that rapidly depletes stored nutrients in the body."
	icon_state = "Agave Leaf"
	icon = 'modular_fallout/master_files/icons/obj/flora/wastelandflora.dmi'
	juice_results = list(/datum/reagent/consumable/tea/agavetea = 0)
	distill_reagent = /datum/reagent/consumable/ethanol/tequila
	plant_datum = /datum/plant/agave

/// MISC ///

/obj/item/food/snacks/sosjerky/healthy
	name = "homemade beef jerky"
	desc = "Homemade beef jerky made from the finest brahmin."
	list_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/consumable/nutriment/vitamin = 1)
	junkiness = 0

/obj/item/food/snacks/sosjerky/ration
	name = "brahmin jerky"
	desc = "Brahmin jerky strips in a sealed package."
	list_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/consumable/nutriment/vitamin = 1)
	junkiness = 0
	foodtypes = MEAT

