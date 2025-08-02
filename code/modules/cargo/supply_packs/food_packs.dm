//////////////////////////////////////////////////////////////////////////////
//////////////////////////// Organic /////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/food
	group = "Food & Livestock"
	crate_type = /obj/structure/closet/crate/freezer

/datum/supply_pack/food/chef
	name = "Exotic Meat Crate"
	desc = "The best cuts in the whole galaxy."
	cost = PAYCHECK_ASSISTANT * 5.8 + CARGO_CRATE_VALUE
	contains = list(
		/obj/item/food/meat/slab/human/mutant/slime,
		/obj/item/food/meat/slab/killertomato,
		/obj/item/food/meat/slab/bear,
		/obj/item/food/meat/slab/xeno,
		/obj/item/food/meat/slab/spider,
		/obj/item/food/meat/rawbacon,
		/obj/item/food/meat/slab/penguin,
		/obj/item/food/spiderleg,
		/obj/item/food/fishmeat/carp,
		/obj/item/food/meat/slab/human
	)
	crate_name = "meat crate"

	randomized = TRUE
	random_pick_amount = 15

/datum/supply_pack/food/exoticseeds
	name = "Exotic Seeds Crate"
	desc = "Any entrepreneuring botanist's dream. Contains fourteen different seeds, including two mystery seeds!"
	cost = PAYCHECK_ASSISTANT * 3.8 + CARGO_CRATE_VALUE
	contains = list(
		/obj/item/seeds/nettle,
		/obj/item/seeds/plump,
		/obj/item/seeds/liberty,
		/obj/item/seeds/amanita,
		/obj/item/seeds/reishi,
		/obj/item/seeds/bamboo,
		/obj/item/seeds/eggplant,
		/obj/item/seeds/rainbow_bunch,
		/obj/item/seeds/shrub,
		/obj/item/seeds/random,
		/obj/item/seeds/random
	)
	crate_name = "exotic seeds crate"
	crate_type = /obj/structure/closet/crate/hydroponics

/datum/supply_pack/food/food
	name = "Ingredient Crate"
	desc = "Get things cooking with this crate full of useful ingredients! Contains a dozen eggs, three bananas, and some flour, rice, milk, soymilk, salt, pepper, enzyme, sugar, and monkeymeat."
	cost = PAYCHECK_ASSISTANT * 4.5 + CARGO_CRATE_VALUE
	contains = list(
		/obj/item/reagent_containers/condiment/flour,
		/obj/item/reagent_containers/condiment/rice,
		/obj/item/reagent_containers/condiment/milk,
		/obj/item/reagent_containers/condiment/soymilk,
		/obj/item/reagent_containers/condiment/saltshaker,
		/obj/item/reagent_containers/condiment/peppermill,
		/obj/item/storage/fancy/egg_box,
		/obj/item/reagent_containers/condiment/enzyme,
		/obj/item/reagent_containers/condiment/sugar,
		/obj/item/food/meat/slab/monkey,
		/obj/item/food/grown/banana,
		/obj/item/food/grown/banana,
		/obj/item/food/grown/banana
	)
	crate_name = "ingredient crate"

/datum/supply_pack/food/chef/fruits
	name = "Fruit Crate"
	desc = "Rich of vitamins, may contain oranges."
	cost = PAYCHECK_ASSISTANT * 2.7 + CARGO_CRATE_VALUE
	contains = list(
		/obj/item/food/grown/citrus/lime,
		/obj/item/food/grown/citrus/orange,
		/obj/item/food/grown/watermelon,
		/obj/item/food/grown/apple,
		/obj/item/food/grown/berries,
		/obj/item/food/grown/citrus/lemon
	)
	crate_name = "fruit crate"

	randomized = TRUE
	random_pick_amount = 15

/datum/supply_pack/food/cream_piee
	name = "High-yield Clown-grade Cream Pie Crate"
	desc = "Designed by Aussec's Advanced Warfare Research Division, these high-yield, Clown-grade cream pies are powered by a synergy of performance and efficiency. Guaranteed to provide maximum results."
	cost = PAYCHECK_ASSISTANT * 4.9 + CARGO_CRATE_VALUE
	contains = list(/obj/item/storage/backpack/duffelbag/clown/cream_pie)
	crate_name = "party equipment crate"
	supply_flags = SUPPLY_PACK_CONTRABAND
	crate_type = /obj/structure/closet/crate/secure

/datum/supply_pack/food/pizza
	name = "Pizza Crate"
	desc = "Why visit the kitchen when you can have five random pizzas in a fraction of the time? \
			Best prices this side of the galaxy! All deliveries are guaranteed to be 99% anomaly-free."
	cost = PAYCHECK_ASSISTANT * 6.3 + CARGO_CRATE_VALUE
	contains = list(
		/obj/item/pizzabox/margherita,
		/obj/item/pizzabox/mushroom,
		/obj/item/pizzabox/meat,
		/obj/item/pizzabox/vegetable,
		/obj/item/pizzabox/pineapple
		)
	crate_name = "pizza crate"
	///Whether we've provided an infinite pizza box already this shift or not.
	var/static/anomalous_box_provided = FALSE
	///The percentage chance (per pizza) of this supply pack to spawn an anomalous pizza box.
	var/anna_molly_box_chance = 1
	///Total tickets in our figurative lottery (per pizza) to decide if we create a bomb box, and if so what type. 1 to 3 create a bomb. The rest do nothing.
	var/boombox_tickets = 100
	///Whether we've provided a bomb pizza box already this shift or not.
	var/boombox_provided = FALSE

/datum/supply_pack/food/pizza/fill(obj/structure/closet/crate/C)
	. = ..()

	var/list/pizza_types = list(
		/obj/item/food/pizza/margherita = 10,
		/obj/item/food/pizza/meat = 10,
		/obj/item/food/pizza/mushroom = 10,
		/obj/item/food/pizza/vegetable = 10,
		/obj/item/food/pizza/donkpocket = 10,
		/obj/item/food/pizza/dank = 7,
		/obj/item/food/pizza/sassysage = 10,
		/obj/item/food/pizza/pineapple = 10,
		/obj/item/food/pizza/arnold = 3
	) //weighted by chance to disrupt eaters' rounds

	for(var/obj/item/pizzabox/P in C)
		if(!anomalous_box_provided)
			if(prob(anna_molly_box_chance)) //1% chance for each box, so 4% total chance per order
				var/obj/item/pizzabox/infinite/fourfiveeight = new(C)
				fourfiveeight.boxtag = P.boxtag
				fourfiveeight.boxtag_set = TRUE
				fourfiveeight.update_appearance()
				qdel(P)
				anomalous_box_provided = TRUE
				log_game("An anomalous pizza box was provided in a pizza crate at during cargo delivery")
				if(prob(50))
					addtimer(CALLBACK(src, PROC_REF(anomalous_pizza_report)), rand(300, 1800))
				else
					message_admins("An anomalous pizza box was silently created with no command report in a pizza crate delivery.")
				continue

		if(!boombox_provided)
			var/boombox_lottery = rand(1,boombox_tickets)
			var/boombox_type
			switch(boombox_lottery)
				if(1 to 2)
					boombox_type = /obj/item/pizzabox/bomb/armed //explodes after opening
				if(3)
					boombox_type = /obj/item/pizzabox/bomb //free bomb

			if(boombox_type)
				new boombox_type(C)
				qdel(P)
				boombox_provided = TRUE
				log_game("A bomb pizza box was created by a pizza crate delivery.")
				message_admins("A bomb pizza box has arrived in a pizza crate delivery.")
				continue

		//here we randomly replace our pizzas for a chance at the full range
		var/obj/item/food/pizza/replacement_type = pick_weight(pizza_types)
		pizza_types -= replacement_type
		if(replacement_type && !istype(P.pizza, replacement_type))
			QDEL_NULL(P.pizza)
			P.pizza = new replacement_type
			P.boxtag = P.pizza.boxtag
			P.boxtag_set = TRUE
			P.update_appearance()

/datum/supply_pack/food/pizza/proc/anomalous_pizza_report()
	print_command_report("[station_name()], our anomalous materials divison has reported a missing object that is highly likely to have been sent to your station during a routine cargo \
	delivery. Please search all crates and manifests provided with the delivery and return the object if is located. The object resembles a standard <b>\[DATA EXPUNGED\]</b> and is to be \
	considered <b>\[REDACTED\]</b> and returned at your leisure. Note that objects the anomaly produces are specifically attuned exactly to the individual opening the anomaly; regardless \
	of species, the individual will find the object edible and it will taste great according to their personal definitions, which vary significantly based on person and species.")

/datum/supply_pack/food/seeds
	name = "Seed Crate"
	desc = "Big things have small beginnings. Contains fifteen different seeds."
	cost = PAYCHECK_ASSISTANT * 1.7 + CARGO_CRATE_VALUE
	contains = list(
		/obj/item/seeds/chili,
		/obj/item/seeds/cotton,
		/obj/item/seeds/berry,
		/obj/item/seeds/corn,
		/obj/item/seeds/eggplant,
		/obj/item/seeds/tomato,
		/obj/item/seeds/soya,
		/obj/item/seeds/wheat,
		/obj/item/seeds/wheat/rice,
		/obj/item/seeds/carrot,
		/obj/item/seeds/sunflower,
		/obj/item/seeds/rose,
		/obj/item/seeds/chanter,
		/obj/item/seeds/potato,
		/obj/item/seeds/sugarcane
	)
	crate_name = "seed crate"
	crate_type = /obj/structure/closet/crate/hydroponics

/datum/supply_pack/food/chef/vegetables
	name = "Vegetables Crate"
	desc = "Grown in vats."
	cost = PAYCHECK_ASSISTANT * 1.8 + CARGO_CRATE_VALUE
	contains = list(
		/obj/item/food/grown/chili,
		/obj/item/food/grown/corn,
		/obj/item/food/grown/tomato,
		/obj/item/food/grown/potato,
		/obj/item/food/grown/carrot,
		/obj/item/food/grown/mushroom/chanterelle,
		/obj/item/food/grown/onion,
		/obj/item/food/grown/pumpkin
	)
	crate_name = "food crate"

	randomized = TRUE
	random_pick_amount = 15

/datum/supply_pack/food/ready_donk
	name = "Ready-Donk Variety Crate"
	desc = "Featuring a line up of Donk Co.'s most popular pastry!"
	cost = PAYCHECK_ASSISTANT * 1.2 + CARGO_CRATE_VALUE
	contains = list(
		/obj/item/food/ready_donk,
		/obj/item/food/ready_donk/mac_n_cheese,
		/obj/item/food/ready_donk/donkhiladas
	)
	crate_name = "\improper Ready-Donk crate"

	randomized = TRUE
	random_pick_amount = 3

/datum/supply_pack/food/donkpockets
	name = "Donk Pocket Variety Crate"
	desc = "Featuring a line up of Donk Co.'s most popular pastry!"
	cost = PAYCHECK_ASSISTANT * 3.6 + CARGO_CRATE_VALUE
	contains = list(
		/obj/item/storage/box/donkpockets/donkpocketspicy,
		/obj/item/storage/box/donkpockets/donkpocketteriyaki,
		/obj/item/storage/box/donkpockets/donkpocketpizza,
		/obj/item/storage/box/donkpockets/donkpocketberry,
		/obj/item/storage/box/donkpockets/donkpockethonk
	)
	crate_name = "donk pocket crate"

	randomized = TRUE
	random_pick_amount = 3

//////////////////////////////////////////////////////////////////////////////
////////////////////////////// Livestock /////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/critter
	group = /datum/supply_pack/food::group
	crate_type = /obj/structure/closet/crate/critter

/datum/supply_pack/critter/parrot
	name = "Livestock (Parrots)"
	desc = "Contains five expert telecommunication birds."
	cost = PAYCHECK_ASSISTANT * 8 + CARGO_CRATE_VALUE
	contains = list(/mob/living/simple_animal/parrot)
	crate_name = "parrot crate"

/datum/supply_pack/critter/parrot/generate()
	. = ..()
	for(var/i in 1 to 4)
		new /mob/living/simple_animal/parrot(.)

/datum/supply_pack/critter/cat
	name = "Livestock (Cat)"
	desc = "The cat goes meow! Comes with a collar and a nice cat toy! Cheeseburger not included."//i can't believe im making this reference
	cost = PAYCHECK_ASSISTANT * 10 + CARGO_CRATE_VALUE
	contains = list(/mob/living/simple_animal/pet/cat,
					/obj/item/clothing/neck/petcollar,
					/obj/item/toy/cattoy)
	crate_name = "cat crate"

/datum/supply_pack/critter/cat/generate()
	. = ..()
	if(prob(50))
		var/mob/living/simple_animal/pet/cat/C = locate() in .
		qdel(C)
		new /mob/living/simple_animal/pet/cat/_proc(.)

/datum/supply_pack/critter/chick
	name = "Livestock (Chicken)"
	desc = "The chicken goes bwaak!"
	cost = PAYCHECK_ASSISTANT * 4 + CARGO_CRATE_VALUE
	contains = list( /mob/living/simple_animal/chick)
	crate_name = "chicken crate"

/datum/supply_pack/critter/corgi
	name = "Livestock (Corgi)"
	desc = "Considered the optimal dog breed by thousands of research scientists, this Corgi is but one dog from the millions of Ian's noble bloodline. Comes with a cute collar!"
	cost = PAYCHECK_ASSISTANT * 10 + CARGO_CRATE_VALUE
	contains = list(/mob/living/simple_animal/pet/dog/corgi,
					/obj/item/clothing/neck/petcollar)
	crate_name = "corgi crate"

/datum/supply_pack/critter/corgi/generate()
	. = ..()
	if(prob(50))
		var/mob/living/simple_animal/pet/dog/corgi/D = locate() in .
		if(D.gender == FEMALE)
			qdel(D)
			new /mob/living/simple_animal/pet/dog/corgi/lisa(.)

/datum/supply_pack/critter/cow
	name = "Livestock (Cow)"
	desc = "The cow goes moo!"
	cost = PAYCHECK_ASSISTANT * 6.5 + CARGO_CRATE_VALUE
	contains = list(/mob/living/basic/cow)
	crate_name = "cow crate"

/datum/supply_pack/critter/corgis/exotic
	name = "Livestock (Exotic Corgi)"
	desc = "Corgis fit for a king, these corgis come in a unique color to signify their superiority. Comes with a cute collar!"
	cost = PAYCHECK_ASSISTANT * 15 + CARGO_CRATE_VALUE
	contains = list(/mob/living/simple_animal/pet/dog/corgi/exoticcorgi,
					/obj/item/clothing/neck/petcollar)
	crate_name = "exotic corgi crate"

/datum/supply_pack/critter/goat
	name = "Livestock (Goat)"
	desc = "The goat goes baa! Warranty void if used as a replacement for Pete."
	cost = PAYCHECK_ASSISTANT * 7 + CARGO_CRATE_VALUE
	contains = list(/mob/living/simple_animal/hostile/retaliate/goat)
	crate_name = "goat crate"

/datum/supply_pack/critter/monkey
	name = "Monkey Cube Crate"
	desc = "Stop monkeying around! Contains seven monkey cubes. Just add water!"
	cost = PAYCHECK_ASSISTANT * 8 + CARGO_CRATE_VALUE
	contains = list (/obj/item/storage/box/monkeycubes)
	crate_type = /obj/structure/closet/crate
	crate_name = "monkey cube crate"

/datum/supply_pack/critter/pug
	name = "Livestock (Pug)"
	desc = "Like a normal dog, but... squished. Comes with a nice collar!"
	cost = PAYCHECK_ASSISTANT * 10 + CARGO_CRATE_VALUE
	contains = list(/mob/living/simple_animal/pet/dog/pug,
					/obj/item/clothing/neck/petcollar)
	crate_name = "pug crate"

/datum/supply_pack/critter/bullterrier
	name = "Livestock (Bull Terrier)"
	desc = "Like a normal dog, but with a head the shape of an egg. Comes with a nice collar!"
	cost = PAYCHECK_ASSISTANT * 10 + CARGO_CRATE_VALUE
	contains = list(/mob/living/simple_animal/pet/dog/bullterrier,
					/obj/item/clothing/neck/petcollar)
	crate_name = "bull terrier crate"

/datum/supply_pack/critter/snake
	name = "Livestock (Snakes)"
	desc = "Tired of these MOTHER FUCKING snakes on this MOTHER FUCKING space station? Then this isn't the crate for you. Contains three poisonous snakes."
	cost = PAYCHECK_ASSISTANT * 4.2 + CARGO_CRATE_VALUE
	contains = list(
		/mob/living/simple_animal/hostile/retaliate/snake,
		/mob/living/simple_animal/hostile/retaliate/snake,
		/mob/living/simple_animal/hostile/retaliate/snake
	)
	crate_name = "snake crate"
