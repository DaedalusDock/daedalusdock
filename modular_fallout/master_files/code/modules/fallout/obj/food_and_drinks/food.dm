//Fallout 13 general food directory

//WASTELAND MEATS

/obj/item/food/meat/slab/gecko
	name = "gecko fillet"
	desc = "A tasty fillet of gecko meat.<br>If you cook it, it tastes like chicken!"
	icon_state = "fishfillet"
	food_reagents = list(/datum/reagent/consumable/nutriment = 6,  /datum/reagent/toxin  = 1, /datum/reagent/consumable/nutriment/vitamin = 2)
	bite_consumption = 2 //Smaller animal
	//filling_color = "#FA8072"
	tastes = list("meat" = 4, "scales" = 1)
	microwaved_type = /obj/item/food/meat/steak/gecko
	//slice_path = null
	foodtypes = RAW | MEAT

/obj/item/food/meat/slab/molerat
	name = "molerat meat"
	desc = "A slab of smelly molerat meat."
	icon_state = "bearmeat"
	food_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/toxin = 1)
	bite_consumption = 3
	//filling_color = "#FA8072"
	tastes = list("meat" = 4, "whiskers" = 1)
	microwaved_type = /obj/item/food/meat/steak/molerat
	//slice_path = null
	foodtypes = RAW | MEAT

/obj/item/food/meat/slab/wolf
	name = "dog meat"
	desc = "Some asians love this stuff.<br>It does not taste too bad actually."
	food_reagents = list(/datum/reagent/consumable/nutriment = 6, /datum/reagent/consumable/nutriment/vitamin = 2)
	bite_consumption = 4 //Average animal
	//filling_color = "#FA8072"
	tastes = list("meat" = 3)
	microwaved_type = /obj/item/food/meat/steak/wolf
	//slice_path = null
	foodtypes = RAW | MEAT

/obj/item/food/meat/slab/deathclaw
	name = "deathclaw meat"
	desc = "A slab of hard but delicious deathclaw meat."
	icon_state = "goliathmeat"
	food_reagents = list(/datum/reagent/consumable/nutriment = 9, /datum/reagent/consumable/nutriment/vitamin = 9, /datum/reagent/medicine/tricordrazine = 5)
	bite_consumption = 6 //Big slabs of meat from a massive creature
	//filling_color = "#FA8072"
	tastes = list("chewy meat" = 3, "scales" = 1)
	microwaved_type = /obj/item/food/meat/steak/deathclaw
	//slice_path = null
	foodtypes = RAW | MEAT

/obj/item/food/meat/slab/mirelurk
	name = "mirelurk meat"
	desc = "Meat from a mirelurk, still inside its shell.  Going to need pliers for this..."
	icon = 'modular_fallout/master_files/icons/fallout/objects/food&drinks/food.dmi'
	icon_state = "mirelurk_meat"
	bite_consumption = 4 //Big animal, small part of it
	//filling_color = "#406618" //Very dark green.
	food_reagents = list(/datum/reagent/consumable/nutriment = 7, /datum/reagent/consumable/nutriment/vitamin = 3)
	//bonus_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/consumable/nutriment/vitamin = 1)
	microwaved_type = /obj/item/food/meat/steak/mirelurk
	tastes = list("crab" = 1)
	//slice_path = null
	foodtypes = RAW | MEAT

/obj/item/food/meat/slab/squirrel
	name = "squirrel meat"
	desc = "Squirrel meat, the staple of many wasteland dishes when you can catch one."
	icon_state = "meat"
	food_reagents = list(/datum/reagent/consumable/nutriment = 6, /datum/reagent/consumable/nutriment/vitamin = 2)
	bite_consumption = 2
	tastes = list("rodent" = 3, "chicken" = 1)
	//filling_color = "#FA8072"
	microwaved_type = /obj/item/food/meat/steak/squirrel
	//slice_path = null
	foodtypes = RAW | MEAT

/obj/item/food/meat/slab/radroach_meat
	name = "radroach meat"
	desc = "A hunk of still quivering radroach meat, gross."
	icon_state = "mothmeat"
	food_reagents = list(/datum/reagent/consumable/nutriment = 2,  /datum/reagent/consumable/nutriment/vitamin = 1)
	//filling_color = "#e5b73b" //Meat brown associated to "mothmeat"
	bite_consumption = 2
	tastes = list("insect guts" = 3)
	microwaved_type = /obj/item/food/meat/steak/radroach_meat
	//slice_path = null
	foodtypes = RAW | MEAT

/obj/item/food/meat/slab/ant_meat
	name = "ant meat"
	desc = "A sizable portion of ant flesh taken from the abdomen, almost looks appetizing, almost."
	icon = 'modular_fallout/master_files/icons/fallout/objects/food&drinks/food.dmi'
	icon_state = "antmeat"
	food_reagents = list(/datum/reagent/consumable/nutriment = 2,  /datum/reagent/consumable/nutriment/vitamin = 3)
	//filling_color = "#e5b73b"
	bite_consumption = 3
	tastes = list("insect guts" = 1)
	microwaved_type = /obj/item/food/meat/steak/ant_meat
	//slice_path = null
	foodtypes = RAW | MEAT

/obj/item/food/meat/slab/fireant_meat
	name = "fireant meat"
	desc = "A sizable portion of fire-ant flesh taken from the abdomen, it smellls slightly spicy."
	icon = 'modular_fallout/master_files/icons/fallout/objects/food&drinks/food.dmi'
	icon_state = "fireant_meat"
	food_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/consumable/capsaicin = 0.5,  /datum/reagent/consumable/nutriment/vitamin = 3)
	bite_consumption = 3
	tastes = list("insect guts" = 2, "spicyness" = 1)
	microwaved_type = /obj/item/food/meat/steak/ant_meat
	//slice_path = null
	foodtypes = RAW | MEAT

/obj/item/food/meat/slab/bloatfly_meat
	name = "bloatfly meat"
	desc = "A slab of black-brown flesh from the abdomen of a bloatfly, disgusting."
	icon = 'modular_fallout/master_files/icons/fallout/objects/food&drinks/food.dmi'
	icon_state = "bloatfly_meat"
	food_reagents = list(/datum/reagent/consumable/nutriment = 2,  /datum/reagent/consumable/nutriment/vitamin = 1)
	//filling_color = "#1c352d" // Medium jungle green
	bite_consumption = 2
	tastes = list("insect guts" = 1)
	microwaved_type = /obj/item/food/meat/steak/bloatfly_meat
	//slice_path = null
	foodtypes = RAW | MEAT

/obj/item/food/meat/slab/cazador_meat
	name = "cazador meat"
	desc = "Meat extracted from the lean hide of cazador wasp."
	icon_state = "mothmeat"
	food_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/consumable/nutriment/vitamin = 2, /datum/reagent/toxin/carpotoxin = 3)
	//filling_color = "#e5b73b"
	bite_consumption = 2
	tastes = list("insect guts" = 3, "sweet tangy liquid" = 1) //google says toxin is sweet anyway.
	microwaved_type = /obj/item/food/meat/steak/cazador_meat
	//slice_path = null
	foodtypes = RAW | MEAT | TOXIC

/obj/item/food/meat/slab/radscorpion_meat
	name = "radscorpion meat"
	desc = "Meat from a radscorpion, still inside its chitin.  Going to need pliers for this."
	icon = 'modular_fallout/master_files/icons/fallout/objects/food&drinks/food.dmi'
	icon_state = "radscorpion_meat"
	food_reagents = list(/datum/reagent/consumable/nutriment = 3,  /datum/reagent/toxin  = 5, /datum/reagent/consumable/nutriment/vitamin = 2)
	//filling_color = "#e5b73b"
	bite_consumption = 4
	tastes = list("insect guts" = 3, "sweet tangy liquid" = 2) //google says toxin is sweet anyway.
	microwaved_type = /obj/item/food/meat/steak/radscorpion_meat
	//slice_path = null
	foodtypes = RAW | MEAT | TOXIC

/obj/item/food/meat/slab/human/ghoul
	name = "ghoul meat"
	desc = "Nothing says tasty like necrotic, radioactive mutant flesh"
	icon_state = "flymeat"
	food_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/uranium/radium = 6)
	tastes = list("rotting flesh" = 3)
	//filling_color = "#7c1104" //Dark Red
	microwaved_type = /obj/item/food/meat/steak/ghoul
	//slice_path = null
	foodtypes = RAW | MEAT | GROSS

/obj/item/food/meat/slab/human/centaur
	name = "centaur meat"
	icon_state = "flymeat"
	desc = "Absolutely disgusting"
	food_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/uranium/radium = 10)
	tastes = list("abomination" = 2, "mutatated flesh" = 1)
	//filling_color = "#7c1104"
	microwaved_type = /obj/item/food/meat/steak/centaur
	//slice_path = null
	foodtypes = RAW | MEAT | GROSS

//WASTELAND STEAKS

/obj/item/food/meat/steak/gecko
	name = "gecko steak"
	desc = "A delicious steak made of finest gecko meat.<br>Tastes like chicken!"

/obj/item/food/meat/steak/molerat
	name = "molerat steak"
	desc = "A smelly molerat steak.<br>What did you expect from roasted mutant rodent meat?"

/obj/item/food/meat/steak/wolf
	name = "dog steak"
	desc = "A dog steak does not look attractive, but some people eat worse things when it comes to survival.<br>What did you expect from roasted dog?"

/obj/item/food/meat/steak/radroach_meat
	name = "radroach steak"
	desc = "A off-color radroach steak.<br>you could have sworn you saw it still twitch."
	icon = 'modular_fallout/master_files/icons/fallout/objects/food&drinks/food.dmi'
	icon_state = "moth_steak"
	food_reagents = list(/datum/reagent/consumable/nutriment = 3)
	//bonus_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/consumable/nutriment/vitamin = 1)
	//filling_color = "#967117" //Mode Beige
	tastes = list("bug protein" = 3)

/obj/item/food/meat/steak/bloatfly_meat
	name = "baked bloatfly"
	desc = "A thoroughly blitzed bloatfly steak, eat it with your eyes closed."
	icon = 'modular_fallout/master_files/icons/fallout/objects/food&drinks/food.dmi'
	icon_state = "baked_bloatfly"
	food_reagents = list(/datum/reagent/consumable/nutriment = 3)
	//bonus_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/consumable/nutriment/vitamin = 2)
	//filling_color = "#1c352d" // Medium jungle green
	tastes = list("baked insect" = 1)

/obj/item/food/meat/steak/ant_meat
	name = "fried ant"
	desc = "A chunk of fried ant flesh."
	icon = 'modular_fallout/master_files/icons/fallout/objects/food&drinks/food.dmi'
	icon_state = "cookedantmeat"
	//filling_color = "#967117"
	tastes = list("bug protein" = 1)
	trash_type = null

/obj/item/food/meat/steak/fireant_meat
	name = "fried fire-ant"
	desc = "A chunk of spicy fried fireant flesh."
	icon = 'modular_fallout/master_files/icons/fallout/objects/food&drinks/food.dmi'
	icon_state = "cooked_fireant_meat"
	//filling_color = "#967117"
	tastes = list("bug protein" = 1,"spicyness" = 1)
	trash_type = null

/obj/item/food/meat/steak/cazador_meat
	name = "cazador steak"
	desc = "A off-color cazador steak, braized in its own venomous juices."
	icon = 'modular_fallout/master_files/icons/fallout/objects/food&drinks/food.dmi'
	icon_state = "moth_steak"
	food_reagents = list(/datum/reagent/consumable/nutriment = 3)
	//bonus_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/consumable/nutriment/vitamin = 1, /datum/reagent/toxin  = 1)
	tastes = list("bug protein" = 3, "sweet tangy liquid" = 1)
	//filling_color = "#967117"

/obj/item/food/meat/steak/radscorpion_meat
	name = "radscoropion roast"
	desc = "Meat from a radscorpion's chitin, cracked open and carefully roasted to perfection in its own posion."
	icon = 'modular_fallout/master_files/icons/fallout/objects/food&drinks/food.dmi'
	icon_state = "mirelurk_roast"
	food_reagents = list(/datum/reagent/consumable/nutriment = 5)
	//bonus_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/consumable/nutriment/vitamin = 4, /datum/reagent/toxin  = 2)
	tastes = list("bug protein" = 3, "sweet tangy liquid" = 1)

/obj/item/food/meat/steak/deathclaw
	name = "deathclaw steak"
	desc = "A piece of hot spicy meat, eaten by only the most worthy hunters - or the most rich clients."
	food_reagents = list(/datum/reagent/consumable/nutriment = 10)
	//bonus_reagents = list(/datum/reagent/consumable/nutriment = 5, /datum/reagent/consumable/nutriment/vitamin = 10, /datum/reagent/medicine/tricordrazine = 8)

/obj/item/food/meat/steak/squirrel
	name = "squirrel steak"
	desc = "A steak made from a small slab of squirrel meat. It is, unsurprisingly, small."
	icon = 'modular_fallout/master_files/icons/fallout/objects/food&drinks/food.dmi'
	icon_state = "squirrel_steak"
	food_reagents = list(/datum/reagent/consumable/nutriment = 3)
	//bonus_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/consumable/nutriment/vitamin = 1)

/obj/item/food/meat/steak/mirelurk
	name = "mirelurk roast"
	desc = "Meat from a mirelurks shell, cracked open and roasted to perfection."
	icon = 'modular_fallout/master_files/icons/fallout/objects/food&drinks/food.dmi'
	icon_state = "mirelurk_roast"
	food_reagents = list(/datum/reagent/consumable/nutriment = 5)
	//bonus_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/consumable/nutriment/vitamin = 4)
	tastes = list("meat" = 2, "crab" = 1)

/obj/item/food/meat/steak/ghoul
	name = "ghoul steak"
	desc = "Twice burnt ghoul meat steak. <br>Why would you even cook this?."
	icon = 'modular_fallout/master_files/icons/fallout/objects/food&drinks/food.dmi'
	icon_state = "ghoul_steak"
	food_reagents = list(/datum/reagent/consumable/nutriment = 3)
	//bonus_reagents = list(/datum/reagent/uranium/radium = 3, /datum/reagent/consumable/nutriment/vitamin = 0.5)
	tastes = list("atomtic baked meat" = 3)
	//filling_color = "#465945" //Gray Asparagus
	foodtypes = MEAT | GROSS

/obj/item/food/meat/steak/centaur
	name = "centaur steak"
	icon = 'modular_fallout/master_files/icons/fallout/objects/food&drinks/food.dmi'
	icon_state = "ghoul_steak"
	desc = "No matter how much you cook, it doesn't seem safe to eat."
	food_reagents = list(/datum/reagent/consumable/nutriment = 4)
	//bonus_reagents = list(/datum/reagent/uranium/radium = 5, /datum/reagent/consumable/nutriment/vitamin = 1)
	tastes = list("atomtic baked meat" = 3, "abominable writhing" = 1)
	//filling_color = "#465945"
	foodtypes = MEAT | GROSS

//WASTELAND JUNK FOOD

/obj/item/food/f13
	name = "ERROR"
	desc = "Badmins spawn shit!"
	icon = 'modular_fallout/master_files/icons/fallout/objects/food&drinks/food.dmi'

/obj/item/food/f13/bubblegum
	name = "Bubblegum"
	desc = "A Big Pops branded bubblegum."
	icon_state = "bubblegum"
	//bonus_reagents = list(/datum/reagent/uranium/radium = 2, /datum/reagent/consumable/nutriment/vitamin = 1)
	food_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/consumable/sugar = 2)
	//filling_color = "#B22222"
	trash_type = /obj/item/trash/f13/bubblegum
	foodtypes = JUNKFOOD | SUGAR

/obj/item/food/f13/bubblegum/large
	name = "big Bubblegum"
	desc = "A large \"Extra\" Big Pops branded bubblegum."
	icon_state = "bubblegum_large"
	//bonus_reagents = list(/datum/reagent/uranium/radium = 4, /datum/reagent/consumable/nutriment/vitamin = 2)
	food_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/consumable/sugar = 4)
	//filling_color = "#B22222"
	trash_type = /obj/item/trash/f13/bubblegum_large
	foodtypes = JUNKFOOD | SUGAR

/obj/item/food/f13/cram
	name = "Cram"
	desc = "A blue labeled tin of processed meat, primarily used as rations for soldiers during the pre-War times."
	icon_state = "cram"
	//bonus_reagents = list(/datum/reagent/uranium/radium = 2, /datum/reagent/consumable/nutriment/vitamin = 5)
	food_reagents = list(/datum/reagent/consumable/nutriment = 20)
	//filling_color = "#B22222"
	trash_type = /obj/item/trash/f13/cram
	foodtypes = MEAT

/obj/item/food/f13/cram/large
	name = "big Cram"
	desc = "A large blue labeled tin of processed meat, primarily used as rations for soldiers during the pre-War times."
	icon_state = "cram_large"
	//bonus_reagents = list(/datum/reagent/uranium/radium = 2, /datum/reagent/consumable/nutriment/vitamin = 10)
	food_reagents = list(/datum/reagent/consumable/nutriment = 40)
	//filling_color = "#B22222"
	trash_type = /obj/item/trash/f13/cram_large
	foodtypes = MEAT

/obj/item/food/f13/yumyum
	name = "YumYum"
	desc = "YumYum was a pre-War company in the United States, producing packaged foods.<br>YumYum Deviled Eggs was their major product."
	icon_state = "yumyum"
	//bonus_reagents = list(/datum/reagent/uranium/radium = 2, /datum/reagent/consumable/nutriment/vitamin = 2)
	food_reagents = list(/datum/reagent/consumable/nutriment = 10)
	//filling_color = "#B22222"
	trash_type = /obj/item/trash/f13/yumyum
	foodtypes = MEAT

/obj/item/food/f13/fancylads
	name = "Fancy Lads"
	desc = "The presence of snack cakes is a nod to the urban myth that Twinkies and other similar foods would survive a nuclear war.<br>The slogan is \"A big delight in every bite\"."
	icon_state = "fancylads"
	//bonus_reagents = list(/datum/reagent/uranium/radium = 2, /datum/reagent/consumable/nutriment/vitamin = 1)
	food_reagents = list(/datum/reagent/consumable/nutriment = 20)
	//filling_color = "#B22222"
	trash_type = /obj/item/trash/f13/fancylads
	foodtypes = JUNKFOOD | SUGAR | GRAIN

/obj/item/food/f13/sugarbombs
	name = "Sugar Bombs"
	desc = "Sugar Bombs is a pre-War breakfast cereal that can be found all around the wasteland, packaged in white and blue boxes with a red ovoid logo at the top, fully labeled as \"Sugar Bombs breakfast cereal\"."
	icon_state = "sugarbombs"
	//bonus_reagents = list(/datum/reagent/uranium/radium = 2, /datum/reagent/consumable/nutriment/vitamin = 2)
	food_reagents = list(/datum/reagent/consumable/nutriment = 10, /datum/reagent/consumable/sugar = 10)
	//filling_color = "#B22222"
	trash_type = /obj/item/trash/f13/sugarbombs
	foodtypes = JUNKFOOD | SUGAR

/obj/item/food/f13/crisps
	name = "Crisps"
	desc = "Potato Crisps are packaged in a small red and green box, with a yellow bubble encouraging the purchaser to \"See Moon Map Offer on Back!\"."
	icon_state = "crisps"
	//bonus_reagents = list(/datum/reagent/uranium/radium = 2, /datum/reagent/consumable/nutriment/vitamin = 1)
	food_reagents = list(/datum/reagent/consumable/nutriment = 5)
	//filling_color = "#B22222"
	trash_type = /obj/item/trash/f13/crisps
	foodtypes = JUNKFOOD

/obj/item/food/f13/steak
	name = "Salisbury Steak"
	desc = "A worn, red box displaying a picture of steak with the words \"Salisbury Steak\" at the top and \"now with Gravy!\" at the bottom."
	icon_state = "steak"
	//bonus_reagents = list(/datum/reagent/uranium/radium = 2, /datum/reagent/consumable/nutriment/vitamin = 5)
	food_reagents = list(/datum/reagent/consumable/nutriment = 50)
	//filling_color = "#B22222"
	trash_type = /obj/item/trash/f13/steak
	foodtypes = MEAT

/obj/item/food/f13/specialapples
	name = "Dandy Apples Special"
	desc = "Dandy Apples Special are a product from the pre-War company Dandy Boy. On the sides of the box there is some sort of apple mascot with a bowler hat, monocle and mustache."
	icon_state = "specialapples"
	//bonus_reagents = list(/datum/reagent/uranium/radium = 2, /datum/reagent/consumable/nutriment/vitamin = 2)
	food_reagents = list(/datum/reagent/consumable/nutriment = 10, /datum/reagent/medicine/tricordrazine = 10)
	//filling_color = "#B22222"
	trash_type = /obj/item/trash/f13/specialapples
	foodtypes = DAIRY | SUGAR

/obj/item/food/f13/dandyapples
	name = "Dandy Boy Apples"
	desc = "Dandy Boy Apples are a product from the pre-War company Dandy Boy, consisting of candied apples packaged in a red cardboard box."
	icon_state = "dandyapples"
	//bonus_reagents = list(/datum/reagent/uranium/radium = 2, /datum/reagent/consumable/nutriment/vitamin = 2)
	food_reagents = list(/datum/reagent/consumable/nutriment = 10, /datum/reagent/consumable/sugar = 10)
	//filling_color = "#B22222"
	trash_type = /obj/item/trash/f13/dandyapples
	foodtypes = DAIRY | SUGAR

/obj/item/food/f13/blamco
	name = "BlamCo"
	desc = "BlamCo was a pre-War company in the United States, producing packaged foods.<br>BlamCo Mac & Cheese was their major product.<br>Unlike other foods, like apples or eggs, wheat cannot be freeze-dried. How the macaroni remains edible is unclear."
	icon_state = "blamco"
	//bonus_reagents = list(/datum/reagent/uranium/radium = 2, /datum/reagent/consumable/nutriment/vitamin = 2)
	food_reagents = list(/datum/reagent/consumable/nutriment = 15)
	//filling_color = "#B22222"
	trash_type = /obj/item/trash/f13/blamco
	foodtypes = DAIRY

/obj/item/food/f13/blamco/large
	name = "big BlamCo"
	desc = "BlamCo was a pre-War company in the United States, producing packaged foods.<br>BlamCo Mac & Cheese was their major product.<br>Unlike other foods, like apples or eggs, wheat cannot be freeze-dried. How the macaroni remains edible is unclear."
	icon_state = "blamco_large"
	//bonus_reagents = list(/datum/reagent/uranium/radium = 4, /datum/reagent/consumable/nutriment/vitamin = 4)
	food_reagents = list(/datum/reagent/consumable/nutriment = 30)
	//filling_color = "#B22222"
	trash_type = /obj/item/trash/f13/blamco_large
	foodtypes = DAIRY

/obj/item/food/f13/mechanic
	name = "MechaMash"
	desc = "MechaMash is packaged in a white box with blue highlights, and a wrench logo printed on the front.<br>It appears to be a form of instant potatoes that smells like WD-40..."
	icon_state = "mechanist"
	//bonus_reagents = list(/datum/reagent/uranium/radium = 2, /datum/reagent/consumable/nutriment/vitamin = 3)
	food_reagents = list(/datum/reagent/consumable/nutriment = 15)
	//filling_color = "#B22222"
	trash_type = /obj/item/trash/f13/mechanist
	foodtypes = VEGETABLES

/obj/item/food/f13/instamash
	name = "InstaMash"
	desc = "InstaMash is packaged in a white box with blue highlights.<br>It appears to be a form of instant potatoes."
	icon_state = "instamash"
	//bonus_reagents = list(/datum/reagent/uranium/radium = 2, /datum/reagent/consumable/nutriment/vitamin = 2)
	food_reagents = list(/datum/reagent/consumable/nutriment = 15)
	//filling_color = "#B22222"
	trash_type = /obj/item/trash/f13/instamash
	foodtypes = VEGETABLES

/obj/item/food/f13/mre
	name = "MRE"
	desc = "The Meal, Ready-to-Eat : commonly known as the MRE - is a self-contained, individual field ration in lightweight packaging.<br>It's commonly used by military groups for service members to use in combat or other field conditions where organized food facilities are not available."
	icon_state = "mre"
	//bonus_reagents = list(/datum/reagent/medicine/silver_sulfadiazine = 10, /datum/reagent/medicine/tricordrazine = 10, /datum/reagent/consumable/nutriment/vitamin = 2)
	food_reagents = list(/datum/reagent/consumable/nutriment = 30)
	//filling_color = "#B22222"
	trash_type = /obj/item/trash/f13/mre

/obj/item/food/f13/galette
	name = "dehydrated pea soup"
	desc = "A piece of military food ration.<br>Faded label on the front says: \"Dehydrated peas. Chew well, take with water. 60g.\""
	icon_state = "galette"
	//bonus_reagents = list(/datum/reagent/consumable/sodiumchloride = 2, /datum/reagent/consumable/sugar = 2, /datum/reagent/medicine/tricordrazine = 2)
	food_reagents = list(/datum/reagent/consumable/nutriment = 10)
	//filling_color = "#B22222"
	foodtypes = VEGETABLES

//WASTELAND EGGS

/obj/item/food/f13/deathclawegg
	name = "deathclaw egg"
	desc = "A deathclaw egg. It has a brownish-red shell. Look at this thing, it's as big as your torso!"
	icon_state = "deathclawegg"
	//bonus_reagents = list(/datum/reagent/toxin = 30)
	food_reagents = list(/datum/reagent/consumable/eggyolk = 40)
	//filling_color = "#F0E68C"
	foodtypes = MEAT

/obj/item/food/f13/giantantegg
	name = "giant ant egg"
	desc = "A giant ant egg.<br>You'd thought it be bigger but its white and squishy to the touch."
	icon = 'modular_fallout/master_files/icons/fallout/objects/food&drinks/food.dmi'
	icon_state = "antegg"
	//bonus_reagents = list(/datum/reagent/toxin = 10)
	food_reagents = list(/datum/reagent/consumable/eggyolk = 15)
	//filling_color = "#F0E68C"
	foodtypes = MEAT

//WASTELAND PREPARED MEALS

/obj/item/food/meatsalted
	name = "salted meat"
	desc = "Slab of meat preserved in salt. Makes you thirsty."
	icon_state = "meatsalted"
	bite_consumption = 5
	//filling_color = "#800000"
	food_reagents = list(/datum/reagent/consumable/nutriment = 5)
	//bonus_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/consumable/nutriment/vitamin = 1)
	tastes = list("meat" = 2, "salt" = 1)
	foodtypes = MEAT

/obj/item/food/meatsmoked
	name = "smoked meat"
	desc = "Slab of meat dried by smoking. Leathery consistency."
	icon_state = "meatsmoked"
	bite_consumption = 5
	//filling_color = "#800000"
	food_reagents = list(/datum/reagent/consumable/nutriment = 5)
	//bonus_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/consumable/nutriment/vitamin = 2)
	tastes = list("meat" = 2, "smoke" = 1)
	foodtypes = MEAT

/obj/item/food/breadhard
	name = "hard bread"
	desc = "Flat dried bread, stores well."
	icon = 'modular_fallout/master_files/icons/fallout/objects/food&drinks/food.dmi'
	icon_state = "breadhard"
	//bonus_reagents = list(/datum/reagent/consumable/nutriment = 7)
	food_reagents = list(/datum/reagent/consumable/nutriment = 10)
	bite_consumption = 5
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("bread" = 1, "smoke" = 1)
	foodtypes = GRAIN

/obj/item/food/f13/molejerky
	name = "molerat wondermeat"
	desc = "Molerat meat cured with wonderglue. Has a nutty aftertaste."
	icon = 'modular_fallout/master_files/icons/fallout/objects/food&drinks/food.dmi'
	icon_state = "wondermeat"
	//bonus_reagents = list(/datum/reagent/consumable/nutriment/vitamin = 5)
	food_reagents = list(/datum/reagent/consumable/nutriment = 12)
	//filling_color = "#B22222"
	foodtypes = MEAT

/obj/item/food/f13/caravanlunch
	name = "caravan lunch"
	desc = "A collection of food conveniently assembled into a lunchbox with the radiation removed. Simple, fast and filling. Often eaten by merchants."
	icon = 'modular_fallout/master_files/icons/fallout/objects/food&drinks/food.dmi'
	icon_state = "caravanlunch"
	//bonus_reagents = list(/datum/reagent/consumable/nutriment/vitamin = 5)
	food_reagents = list(/datum/reagent/consumable/nutriment = 50)
	//filling_color = "B#22222"
	trash_type = /obj/item/crafting/lunchbox
	foodtypes = MEAT | VEGETABLES

/obj/item/food/f13/wastelandwellington
	name = "wasteland wellington"
	desc = "Meat from wasteland critters wrapped in puffy pastry. Delicious, rich and certainly high class."
	icon = 'modular_fallout/master_files/icons/fallout/objects/food&drinks/food.dmi'
	icon_state = "wasteland_wellington"
	//bonus_reagents = list(/datum/reagent/consumable/nutriment/vitamin = 5, /datum/reagent/medicine/tricordrazine = 5)
	food_reagents = list(/datum/reagent/consumable/nutriment = 30)
	//filling_color = "B#22222"
	foodtypes = MEAT | GRAIN

/obj/item/food/f13/deathclawomelette
	name = "deathclaw omelette"
	desc = "A delicious omelette made from one big deathclaw egg. Hope you're not allergic."
	icon = 'modular_fallout/master_files/icons/fallout/objects/food&drinks/food.dmi'
	icon_state = "deathclawomlette"
	//bonus_reagents = list (/datum/reagent/consumable/nutriment/vitamin = 5, /datum/reagent/medicine/omnizine = 40, /datum/reagent/medicine/dexalin = 10)
	food_reagents = list(/datum/reagent/consumable/nutriment = 60)
	//filling_color = "B#22222"
	foodtypes = MEAT

/obj/item/food/f13/crispysquirrel
	name = "crispy squirrel bits"
	desc = "Bits of squirrel meat roasted on a skewer. Tasty."
	icon = 'modular_fallout/master_files/icons/fallout/objects/food&drinks/food.dmi'
	icon_state = "squrrielbits"
	food_reagents = list(/datum/reagent/consumable/nutriment = 12)
	//filling_color = "B#22222"
	foodtypes = MEAT

/obj/item/food/f13/squirrelstick
	name = "squirrel on a stick"
	desc = "It's a whole squirrel roasted on a stick. Tastes of home on the wastes."
	icon = 'modular_fallout/master_files/icons/fallout/objects/food&drinks/food.dmi'
	icon_state = "squrrielstick"
	food_reagents = list(/datum/reagent/consumable/nutriment = 24)
	//filling_color = "B#22222"
	foodtypes = MEAT

/obj/item/food/f13/mirelurkcake
	name = "mirelurk cake"
	desc = "A savory cake made from the meat of a Mirelurk.  A popular dish from the coastlines."
	bite_consumption = 5
	icon = 'modular_fallout/master_files/icons/fallout/objects/food&drinks/food.dmi'
	icon_state = "Mirelurk_cake"
	food_reagents = list(/datum/reagent/consumable/nutriment = 20, /datum/reagent/consumable/nutriment/vitamin = 9)
	tastes = list("cake" = 1, "crab" = 5)
	//filling_color = "#406618"
	foodtypes = MEAT

//WASTELAND SOUPS

/obj/item/food/soup/moleratstew
	name = "molerat stew"
	desc = "A nice and warm stew. Healthy and strong."
	icon = 'modular_fallout/master_files/icons/fallout/objects/food&drinks/soupsalad.dmi'
	icon_state = "molerat_stew"
	max_volume = 35
	food_reagents = list( /datum/reagent/consumable/nutriment/vitamin = 10, /datum/reagent/medicine/imidazoline = 5, /datum/reagent/consumable/nutriment/vitamin = 5)
	//bonus_reagents = list( /datum/reagent/consumable/nutriment/vitamin = 1, /datum/reagent/consumable/nutriment/vitamin = 5)
	tastes = list("gamey meat" = 1, "filling stew" = 1)
	foodtypes = VEGETABLES | MEAT

/obj/item/food/soup/buffalogourd
	name = "buffalo gourd soup"
	desc = "A tasty soup made with roasted gourd."
	icon = 'modular_fallout/master_files/icons/fallout/objects/food&drinks/soupsalad.dmi'
	icon_state = "buffalo_soup"
	max_volume = 40
	//bonus_reagents = list( /datum/reagent/consumable/nutriment = 4,  /datum/reagent/consumable/nutriment/vitamin = 6)
	tastes = list("buttery flesh" = 1, "creamy soup" = 1)
	foodtypes = VEGETABLES

/obj/item/food/soup/squirrelstew
	name = "squirrel stew"
	desc = "Stewed squirrel meat with veggies. There's more vegetable than meat."
	icon = 'modular_fallout/master_files/icons/fallout/objects/food&drinks/soupsalad.dmi'
	icon_state = "squrrielsoup"
	bite_consumption = 4
	max_volume = 25
	//bonus_reagents = list(/datum/reagent/consumable/nutriment/vitamin = 6)
	food_reagents = list(/datum/reagent/consumable/nutriment = 32)
	//filling_color = "B#22222"
	trash_type = /obj/item/reagent_containers/cup/bowl
	foodtypes = MEAT | VEGETABLES

/obj/item/food/soup/longpork_stew
	name = "longpork stew"
	desc = "A thick, oily stew that tastes and smells weird. Has small pieces of raw, chewy meat."
	icon = 'modular_fallout/master_files/icons/fallout/objects/food&drinks/soupsalad.dmi'
	icon_state = "molerat_stew"
	bite_consumption = 4
	max_volume = 30
	food_reagents = list(/datum/reagent/medicine/longpork_stew = 30)
	//bonus_reagents = list(/datum/reagent/consumable/nutriment/vitamin = 3, /datum/reagent/medicine/longpork_stew = 5)
	//filling_color = "#a7510b"
	tastes = list("oily broth" = 5, "chewy meat" = 1)
	trash_type = /obj/item/reagent_containers/cup/bowl
	foodtypes = MEAT

/obj/item/food/soup/mirelurkstew
	name = "mirelurk stew"
	desc = "A hearty stew made from de-shelled mirelurk meat, onions, butter, and other such delights."
	icon = 'modular_fallout/master_files/icons/fallout/objects/food&drinks/soupsalad.dmi'
	icon_state = "mirelurk_stew"
	bite_consumption = 6
	max_volume = 50
	food_reagents = list(/datum/reagent/consumable/nutriment = 20)
	//bonus_reagents = list(/datum/reagent/consumable/nutriment/vitamin = 6, /datum/reagent/medicine/tricordrazine = 5)
	tastes = list("crab" = 5, "onions" = 1)
	//filling_color = "#406618"
	trash_type = /obj/item/reagent_containers/cup/bowl
	foodtypes = MEAT | VEGETABLES

/obj/item/food/soup/rubycasserole
	name = "ruby's radscorpion casserole"
	desc = "A flavorsome casserole made from from radscorpion meat, chillipeppers, molerat meat, and love."
	icon = 'modular_fallout/master_files/icons/fallout/objects/food&drinks/soupsalad.dmi'
	icon_state = "radscorpion_casserole"
	bite_consumption = 6
	max_volume = 50
	food_reagents = list(/datum/reagent/consumable/nutriment = 20)
	//bonus_reagents = list(/datum/reagent/consumable/nutriment/vitamin = 6, /datum/reagent/medicine/tricordrazine = 5, /datum/reagent/consumable/capsaicin = 2.5)
	tastes = list("casserole" = 5, "meat" = 2, "peppers" = 2)
	//filling_color = "#406618"
	trash_type = /obj/item/reagent_containers/cup/bowl
	foodtypes = MEAT | VEGETABLES

// Canned Items

/obj/item/food/f13/canned
	name = "canned food item"
	desc = "If you see this, call an admin."
	var/is_open = FALSE

/obj/item/food/f13/canned/update_icon_state()
	if(!is_open)
		icon_state = "[icon_state]"
	else
		icon_state = "[icon_state]-op"

/obj/item/food/f13/canned/attack_self(mob/user)
	if(!is_open)
		is_open = TRUE
		to_chat(user, "<span class='notice'>You open the lid of the can.</span>")
		update_icon()
		return
	. = ..()

/obj/item/food/f13/canned/attack(mob/living/M, mob/living/user)
	if(!is_open)
		to_chat(user, "<span class='warning'>You need to open [src] first.</span>")
		return
	. = ..()

/obj/item/food/f13/canned/porknbeans
	name = "can of pork n' beans"
	desc = "Pork n' Beans come in a small brown and orange tin, with a label that reads \"Greasy Prospector Improved Pork And Beans\".<br>Toward the bottom of the label is printed that the beans come \"With Hickory Smoked Pig Fat Chunks\"."
	icon_state = "porknbeans"
	//bonus_reagents = list(/datum/reagent/uranium/radium = 1, /datum/reagent/consumable/nutriment/vitamin = 2)
	food_reagents = list(/datum/reagent/consumable/nutriment = 35)
	//filling_color = "#B22222"
	tastes = list("doughy beans" = 5, "pork flavoring" = 1)
	trash_type = /obj/item/trash/f13/porknbeans
	foodtypes = MEAT | VEGETABLES

/obj/item/food/f13/canned/borscht
	name = "canned borscht"
	desc = "A faded label says something in Cyrillic, but you can't understand a thing.<br>\"KOHCEPBA BKYCHOTA TOMAT CMETAHA MOCKBA\"<br>\"cynep cyn!\"<br>An image of a plate with some red soup explains a lot."
	icon_state = "borscht"
	//bonus_reagents = list(/datum/reagent/uranium/radium = 1, /datum/reagent/consumable/nutriment/vitamin = 3)
	food_reagents = list(/datum/reagent/consumable/nutriment = 35)
	//filling_color = "#B22222"
	tastes = list("old beets" = 4, "vegetables" = 2, "meat broth" = 2)
	trash_type = /obj/item/trash/f13/borscht
	foodtypes = VEGETABLES

/obj/item/food/f13/canned/dog //Max Rockatansky favorite
	name = "dog food"
	desc = "A can of greasy meat with a faded cartoon dog on the label.<br>Smells bad, tastes worse, but filling.<br>Not good enough to get bitten over, though." //Mad Max: Road Warrior 1981 dog food scene reference
	icon_state = "dog"
	//bonus_reagents = list(/datum/reagent/uranium/radium = 1, /datum/reagent/consumable/nutriment/vitamin = 3)
	food_reagents = list(/datum/reagent/consumable/nutriment = 35)
	//filling_color = "#B22222"
	tastes = list("mushy kibble" = 4, "musty meat" = 2)
	trash_type = /obj/item/trash/f13/dog
	foodtypes = MEAT

/obj/item/food/f13/canned/ncr
	name = "canned military ration"
	desc = "If you see this, call an admin."
	//filling_color = "#B22222"
	food_reagents = list(/datum/reagent/consumable/nutriment = 35, /datum/reagent/consumable/nutriment/vitamin = 3)
	icon_state = "c_ration_1"
	trash_type = /obj/item/trash/f13/c_ration_1

/obj/item/food/f13/canned/ncr/brahmin_chili
	name = "c-ration entree - 'Brahmin Meatchunks in Fava Bean Chili'"
	desc = "A canned food product containing the entree portion of a military combat ration."
	tastes = list("brahmin" = 4, "beans" = 2, "spicy chili" = 2)
	foodtypes = MEAT | VEGETABLES
	//filling_color = "#38170d"

/obj/item/food/f13/canned/ncr/bighorner_sausage
	name = "c-ration entree - 'Bighorner Franks in Tato Sauce'"
	desc = "A canned food product containing the entree portion of a military combat ration."
	tastes = list("bighorner sausage" = 4, "tato sauce" = 2)
	foodtypes = MEAT | VEGETABLES
	//filling_color = "#38170d"

/obj/item/food/f13/canned/ncr/igauna_bits
	name = "c-ration entree - 'Iguana Bite Tacos'"
	desc = "A canned food product containing the entree portion of a military combat ration."
	tastes = list("crispy iguana" = 4, "corn tortilla" = 2)
	foodtypes = MEAT | VEGETABLES
	//filling_color = "#38230d"

/obj/item/food/f13/canned/ncr/grilled_radstag
	name = "c-ration entree - 'Grilled Radstag with Potato Puree and Gravy'"
	desc = "A canned food product containing the entree portion of a military combat ration."
	tastes = list("grilled radstag" = 4, "potatoes and gravy" = 2)
	foodtypes = MEAT | VEGETABLES
	//filling_color = "#38230d"

/obj/item/food/f13/canned/ncr/molerat_stew
	name = "c-ration entree - 'Molerat Stew'"
	desc = "A canned food product containing the entree portion of a military combat ration."
	tastes = list("molerat" = 4, "stewed vegetables" = 2)
	foodtypes = MEAT | VEGETABLES
	//filling_color = "#38230d"
	microwaved_type = /obj/item/food/soup/moleratstew

/obj/item/food/f13/canned/ncr/ham_and_eggs
	name = "c-ration entree - 'Brahmin Ham and Mirelurk Eggs'"
	desc = "A canned food product containing the entree portion of a military combat ration."
	tastes = list("ham" = 4, "EXTREMELY fishy eggs" = 4)
	foodtypes = MEAT | VEGETABLES | GROSS

/obj/item/food/f13/canned/ncr/brahmin_burger
	name = "c-ration entree - 'Brahmin Burger'"
	desc = "A canned food product containing the entree portion of a military combat ration."
	tastes = list("a pretty damn good burger" = 4)
	foodtypes = MEAT | GRAIN
	microwaved_type = /obj/item/food/burger/bigbite

/obj/item/food/f13/canned/ncr/vegetable_soup
	name = "c-ration entree - 'Vegetable Soup'"
	desc = "A canned food product containing the entree portion of a military combat ration."
	tastes = list("crunchy vegetables" = 4, "stewed vegetables" = 2)
	foodtypes = VEGETABLES
	microwaved_type = /obj/item/food/soup/vegetable

/obj/item/food/f13/canned/ncr/mirelurk_filets
	name = "c-ration entree - 'Smoked Mirelurk Filets'"
	desc = "A canned food product containing the entree portion of a military combat ration."
	tastes = list("smoked fish" = 3)
	foodtypes = MEAT

/obj/item/food/f13/canned/ncr/yaoguai_meatballs
	name = "c-ration entree - 'Yao Guai Meatballs in Tato Sauce'"
	desc = "A canned food product containing the entree portion of a military combat ration."
	tastes = list("gamey meat" = 3, "tato sauce" = 3)
	foodtypes = MEAT | VEGETABLES

/obj/item/food/f13/canned/ncr/brahmin_dogs
	name = "c-ration entree - 'Brahmin Dogs'"
	desc = "A canned food product containing the entree portion of a military combat ration."
	tastes = list("a pretty damn good hotdog" = 4)
	foodtypes = MEAT | VEGETABLES
	microwaved_type = /obj/item/food/hotdog

/obj/item/food/f13/canned/ncr/crackers
	name = "c-ration crackers"
	desc = "A canned food product containing crackers as part of a military combat ration."// Use a knife to get the crackers out."
	tastes = list("cracker" = 4)
	foodtypes = GRAIN
	//slice_path = /obj/item/food/cracker/c_ration
	trash_type = /obj/item/trash/f13/c_ration_2
	slices_num = 4

/obj/item/food/f13/canned/ncr/candied_mutfruit
	name = "c-ration dessert - 'Candied Mutfruit'"
	desc = "A canned food product containing the dessert portion of a military combat ration."
	icon_state = "c_ration_3"
	tastes = list("mutfruit" = 3, "sugar" = 3)
	trash_type = /obj/item/trash/f13/c_ration_3
	foodtypes = SUGAR | FRUIT

/obj/item/food/f13/canned/ncr/cranberry_cobbler
	name = "c-ration dessert - 'Cranberry Cobbler'"
	desc = "A canned food product containing the dessert portion of a military combat ration."
	icon_state = "c_ration_3"
	tastes = list("perfectly replicated GMO cranberries" = 3, "buttery flakey crust" = 2)
	trash_type = /obj/item/trash/f13/c_ration_3
	foodtypes = SUGAR | FRUIT | GRAIN

/obj/item/food/f13/canned/ncr/breakfast
	name = "k-ration entree - 'Brahmin Chorizo Con Huevos'"
	desc = "A canned food product containing the entree portion of a military combat ration."
	icon_state = "k_ration_can"
	tastes = list("rich beef" = 3, "peppers" = 3, "eggs" = 2)
	trash_type = /obj/item/trash/f13/k_ration
	foodtypes = MEAT | VEGETABLES | BREAKFAST

/obj/item/food/f13/canned/ncr/lunch
	name = "k-ration entree - 'Baja Enchiladas'"
	desc = "A canned food product containing the entree portion of a military combat ration, a star with the initials 'A.F' is stamped on the can."
	icon_state = "k_ration_can"
	tastes = list("corn tortilla" = 2, "stewed brahmin" = 3, "picante salsa" = 3)
	trash_type = /obj/item/trash/f13/k_ration
	foodtypes = MEAT | GRAIN

/obj/item/food/f13/canned/ncr/dinner
	name = "k-ration entree - 'Spiced Dinner Luncheon'"
	desc = "A canned food product containing the entree portion of a military combat ration. Better than Cram."
	icon_state = "k_ration_can"
	tastes = list("beef luncheon loaf" = 3, "jalapeno peppers and spices" = 2)
	trash_type = /obj/item/trash/f13/k_ration
	foodtypes = MEAT
