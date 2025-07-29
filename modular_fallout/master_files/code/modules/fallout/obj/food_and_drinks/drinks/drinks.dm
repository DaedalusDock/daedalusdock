

///////////////////////////////////////////////Alchohol bottles! -Agouri //////////////////////////
//Functionally identical to regular drinks. The only difference is that the default bottle size is 100. - Darem
//Bottles now knockdown and break when smashed on people's heads. - Giacom

/obj/item/reagent_containers/cup/glass/bottle/tequila/empty
	list_reagents = null

/obj/item/reagent_containers/cup/glass/bottle/f13nukacola
	name = "Nuka-Cola"
	desc = "The most popular flavored soft drink in the United States before the Great War."
	icon = 'modular_fallout/master_files/icons/obj/f13vending.dmi'
	icon_state = "nukacola"
	list_reagents = list(/datum/reagent/consumable/nuka_cola = 25, /datum/reagent/uranium/radium = 5)
	drink_type = SUGAR
	isGlass = TRUE

/obj/item/reagent_containers/cup/glass/bottle/f13nukacola/radioactive
	desc = "The most popular flavored soft drink in the United States before the Great War.<br>It was preserved in a fairly pristine state.<br>The bottle is slightly glowing."
	list_reagents = list(/datum/reagent/consumable/nuka_cola = 15, /datum/reagent/uranium/radium = 5)

/obj/item/reagent_containers/cup/glass/bottle/sunset
	name = "Sunset Sarsparilla"
	desc = "The most popular flavored root beer in the West!"
	icon = 'modular_fallout/master_files/icons/obj/f13vending.dmi'
	icon_state = "sunset"
	list_reagents = list(/datum/reagent/consumable/ethanol/whiskey = 1, /datum/reagent/consumable/sunset = 15, /datum/reagent/medicine/saline_glucose = 5)
	drink_type = SUGAR
	isGlass = TRUE

/obj/item/reagent_containers/cup/glass/bottle/wine/empty
	list_reagents = null

/obj/item/reagent_containers/cup/glass/bottle/absinthe/premium
	name = "Gwyn's premium absinthe"
	desc = "A potent alcoholic beverage, almost makes you forget the ash in your lungs."
	icon_state = "absinthepremium"

/obj/item/reagent_containers/cup/glass/bottle/absinthe/premium/redact()
	return

/obj/item/reagent_containers/cup/glass/bottle/hcider
	name = "Jian Hard Cider"
	desc = "Apple juice for adults."
	icon_state = "hcider"
	volume = 50
	list_reagents = list(/datum/reagent/consumable/ethanol/hcider = 50)

/obj/item/reagent_containers/cup/glass/bottle/hcider/empty
	list_reagents = null

/obj/item/reagent_containers/cup/glass/bottle/grappa
	name = "Phillipes well-aged Grappa"
	desc = "Bottle of Grappa."
	icon_state = "grappabottle"
	list_reagents = list(/datum/reagent/consumable/ethanol/grappa = 100)

/obj/item/reagent_containers/cup/glass/bottle/grappa/empty
	list_reagents = null

/obj/item/reagent_containers/cup/glass/bottle/sake
	name = "Ryo's traditional sake"
	desc = "Sweet as can be, and burns like fire going down."
	icon_state = "sakebottle"
	list_reagents = list(/datum/reagent/consumable/ethanol/sake = 100)

/obj/item/reagent_containers/cup/glass/bottle/sake/empty
	list_reagents = null

/obj/item/reagent_containers/cup/glass/bottle/sake/Initialize()
	. = ..()
	if(prob(10))
		name = "Fluffy Tail Sake"
		desc += " On the bottle is a picture of a kitsune with nine touchable tails."
		icon_state = "sakebottle_k"
	else if(prob(10))
		name = "Inubashiri's Home Brew"
		desc += " Awoo."
		icon_state = "sakebottle_i"

/obj/item/reagent_containers/cup/glass/bottle/applejack
	name = "Buckin' Bronco's Applejack"
	desc = "Kicks like a horse, tastes like an apple!"
	icon_state = "applejack_bottle"
	list_reagents = list(/datum/reagent/consumable/ethanol/applejack = 100)
	drink_type = FRUIT

/obj/item/reagent_containers/cup/glass/bottle/applejack/empty
	list_reagents = null

/obj/item/reagent_containers/cup/glass/bottle/champagne
	name = "Lead Champagne"
	desc = "Finely sourced from only the most pretentious Appalachian vineyards."
	icon_state = "champagne_bottle"
	list_reagents = list(/datum/reagent/consumable/ethanol/champagne = 100)

/obj/item/reagent_containers/cup/glass/bottle/champagne/empty
	list_reagents = null

/obj/item/reagent_containers/cup/glass/bottle/blazaam
	name = "Ginbad's Blazaam"
	desc = "You feel like you should give the bottle a good rub before opening."
	icon_state = "blazaambottle"
	list_reagents = list(/datum/reagent/consumable/ethanol/blazaam = 100)

/obj/item/reagent_containers/cup/glass/bottle/blazaam/empty
	list_reagents = null

/obj/item/reagent_containers/cup/glass/bottle/trappist
	name = "Mont de Requin Trappistes Bleu"
	desc = "Brewed in Belgium. Fancy!"
	icon_state = "trappistbottle"
	volume = 50
	list_reagents = list(/datum/reagent/consumable/ethanol/trappist = 50)

/obj/item/reagent_containers/cup/glass/bottle/trappist/empty
	list_reagents = null

/obj/item/reagent_containers/cup/glass/bottle/rotgut
	name = "Rotgut"
	desc = "a bottle of noxious homebrewed alcohol, it has the name Rotgut etched on its side"
	icon = 'modular_fallout/master_files/icons/fallout/objects/food&drinks/drinks.dmi'
	icon_state = "rotgut"
	list_reagents = list(/datum/reagent/consumable/ethanol/rotgut = 100)

/obj/item/reagent_containers/cup/glass/bottle/tequila/empty
	list_reagents = null

//////////////////////////JUICES AND STUFF ///////////////////////

/obj/item/reagent_containers/cup/glass/bottle/orangejuice
	name = "orange juice"
	desc = "Full of vitamins and deliciousness!"
	icon_state = "orangejuice"
	inhand_icon_state = "carton"
	lefthand_file = 'icons/mob/inhands/equipment/kitchen_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/kitchen_righthand.dmi'
	isGlass = FALSE
	list_reagents = list(/datum/reagent/consumable/orangejuice = 100)
	drink_type = FRUIT| BREAKFAST

/obj/item/reagent_containers/cup/glass/bottle/bio_carton
	name = "small carton box"
	desc = "A small biodegradable carton box made from plant biomatter."
	icon_state = "eco_box"
	inhand_icon_state = "carton"
	lefthand_file = 'icons/mob/inhands/equipment/kitchen_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/kitchen_righthand.dmi'
	volume = 50
	isGlass = FALSE

/obj/item/reagent_containers/cup/glass/bottle/cream
	name = "milk cream"
	desc = "It's cream. Made from milk. What else did you think you'd find in there?"
	icon_state = "cream"
	inhand_icon_state = "carton"
	lefthand_file = 'icons/mob/inhands/equipment/kitchen_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/kitchen_righthand.dmi'
	isGlass = FALSE
	list_reagents = list(/datum/reagent/consumable/cream = 100)
	drink_type = DAIRY


/obj/item/reagent_containers/cup/glass/bottle/bawls
	name = "Balls Guarana"
	desc = "To give you that Bounce!"
	icon = 'modular_fallout/master_files/icons/obj/f13vending.dmi'
	icon_state = "bawls"
	list_reagents = list(/datum/reagent/consumable/coffee = 10, /datum/reagent/consumable/bawls = 15)
	drink_type = SUGAR
	isGlass = TRUE

/obj/item/reagent_containers/cup/glass/bottle/lemonjuice
	name = "Lemon Juice"
	desc = "Whew! Thats some sour pre-war lemon juice! You know what they say about..."
	icon_state = "lemonjuice"
	lefthand_file = 'icons/mob/inhands/equipment/kitchen_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/kitchen_righthand.dmi'
	isGlass = TRUE
	list_reagents = list(/datum/reagent/consumable/limejuice = 100)
	drink_type = FRUIT

/obj/item/reagent_containers/cup/glass/bottle/instatea
	name = "Silician Instatea"
	desc = "Pre-war powerdered canned tea powder."
	icon_state = "instatea"
	list_reagents = list(/datum/reagent/toxin/teapowder = 98, /datum/reagent/uranium/radium = 2)

/obj/item/reagent_containers/cup/glass/bottle/cream
	name = "canned cream"
	desc = "It's a can of cream. Made from milk. What else did you think you'd find in there?"
	icon_state = "cream"
	lefthand_file = 'icons/mob/inhands/equipment/kitchen_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/kitchen_righthand.dmi'
	list_reagents = list(/datum/reagent/consumable/cream = 100)
	drink_type = DAIRY


/obj/item/reagent_containers/cup/glass/bottle/instacocoa
	name = "Silician Instacocoa"
	desc = "Pre-war powerdered canned dried chocolate mix."
	icon_state = "instachoc"
	list_reagents = list(/datum/reagent/consumable/coco = 98, /datum/reagent/uranium/radium = 2)

/obj/item/reagent_containers/cup/glass/bottle/instacoffee
	name = "Silician Instacoffee"
	desc = "Pre-war powerdered canned coffee."
	icon_state = "instacoffee"
	list_reagents = list(/datum/reagent/toxin/coffeepowder = 98, /datum/reagent/uranium/radium = 2)

/obj/item/reagent_containers/cup/glass/bottle/vim
	name = "Vim"
	desc = "You've got Vim!"
	icon = 'modular_fallout/master_files/icons/obj/f13vending.dmi'
	icon_state = "vim"
	list_reagents = list(/datum/reagent/consumable/sugar = 5, /datum/reagent/consumable/vim = 15)
	drink_type = SUGAR
	isGlass = TRUE

/obj/item/reagent_containers/cup/glass/bottle/tomatojuice
	name = "tomato juice"
	desc = "Well, at least it LOOKS like tomato juice. You can't tell with all that redness."
	icon_state = "tomatojuice"
	inhand_icon_state = "carton"
	lefthand_file = 'icons/mob/inhands/equipment/kitchen_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/kitchen_righthand.dmi'
	isGlass = FALSE
	list_reagents = list(/datum/reagent/consumable/tomatojuice = 100)
	drink_type = VEGETABLES

/obj/item/reagent_containers/cup/glass/bottle/limejuice
	name = "lime juice"
	desc = "Sweet-sour goodness."
	icon_state = "limejuice"
	inhand_icon_state = "carton"
	lefthand_file = 'icons/mob/inhands/equipment/kitchen_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/kitchen_righthand.dmi'
	isGlass = FALSE
	list_reagents = list(/datum/reagent/consumable/limejuice = 100)
	drink_type = FRUIT

/obj/item/reagent_containers/cup/glass/bottle/pineapplejuice
	name = "pineapple juice"
	desc = "Extremely tart, yellow juice."
	icon_state = "pineapplejuice"
	inhand_icon_state = "carton"
	lefthand_file = 'icons/mob/inhands/equipment/kitchen_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/kitchen_righthand.dmi'
	isGlass = FALSE
	list_reagents = list(/datum/reagent/consumable/pineapplejuice = 100)
	drink_type = FRUIT | PINEAPPLE

/obj/item/reagent_containers/cup/glass/bottle/strawberryjuice
	name = "strawberry juice"
	desc = "Slushy, reddish juice."
	icon_state = "strawberryjuice"
	inhand_icon_state = "carton"
	lefthand_file = 'icons/mob/inhands/equipment/kitchen_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/kitchen_righthand.dmi'
	isGlass = FALSE
	list_reagents = list(/datum/reagent/consumable/strawberryjuice = 100)
	drink_type = FRUIT

/obj/item/reagent_containers/cup/glass/bottle/menthol
	name = "menthol"
	desc = "Tastes naturally minty, and imparts a very mild numbing sensation."
	icon_state = "mentholbox"
	inhand_icon_state = "carton"
	lefthand_file = 'icons/mob/inhands/equipment/kitchen_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/kitchen_righthand.dmi'
	isGlass = FALSE
	list_reagents = list(/datum/reagent/consumable/menthol = 100)

/obj/item/reagent_containers/cup/glass/bottle/grenadine
	name = "Jester Grenadine"
	desc = "Contains 0% real cherries!"
	icon_state = "grenadine"
	isGlass = TRUE
	list_reagents = list(/datum/reagent/consumable/grenadine = 100)
	drink_type = FRUIT

/obj/item/reagent_containers/cup/glass/bottle/grenadine/empty
	list_reagents = null

/obj/item/export/bottle
	name = "Report this please"
	desc = "A sealed bottle of alcohol, ready to be exported"
	icon = 'icons/obj/drinks.dmi'
	force = 0
	throwforce = 0
	throw_speed = 0
	throw_range = 0
	w_class = WEIGHT_CLASS_TINY
	inhand_icon_state = "beer"
	attack_verb = list("boop", "thunked", "shown")

/obj/item/export/bottle/gin
	icon_state = "ginbottle"
	name = "Sealed Gin"

/obj/item/export/bottle/wine
	icon_state = "winebottle"
	name = "Sealed Wine"

/obj/item/export/bottle/whiskey
	icon_state = "whiskeybottle"
	name = "Sealed Whiskey"

/obj/item/export/bottle/vodka
	icon_state = "vodkabottle"
	name = "Sealed Vodka"

/obj/item/export/bottle/tequila
	icon_state = "tequilabottle"
	name = "Sealed Tequila"

/obj/item/export/bottle/patron
	icon_state = "patronbottle"
	name = "Sealed Patron"

/obj/item/export/bottle/rum
	icon_state = "rumbottle"
	name = "Sealed Rum"

/obj/item/export/bottle/vermouth
	icon_state = "vermouthbottle"
	name = "Sealed Vermouth"

/obj/item/export/bottle/kahlua
	icon_state = "kahluabottle"
	name = "Sealed Kahlua"

/obj/item/export/bottle/goldschlager
	icon_state = "goldschlagerbottle"
	name = "Sealed Goldschlager"

/obj/item/export/bottle/hcider
	icon_state = "hcider"
	name = "Sealed Cider"

/obj/item/export/bottle/cognac
	icon_state = "cognacbottle"
	name = "Sealed Cognac"

/obj/item/export/bottle/absinthe
	icon_state = "absinthebottle"
	name = "Sealed Unmarked Absinthe"

/obj/item/export/bottle/grappa
	icon_state = "grappabottle"
	name = "Sealed Grappa"

/obj/item/export/bottle/sake
	icon_state = "sakebottle"
	name = "Sealed Sake"

/obj/item/export/bottle/fernet
	icon_state = "fernetbottle"
	name = "Sealed Fernet"

/obj/item/export/bottle/applejack
	icon_state = "applejack_bottle"
	name = "Sealed Applejack"

/obj/item/export/bottle/champagne
	icon_state = "champagne_bottle"
	name = "Sealed Champagne"

/obj/item/export/bottle/blazaam
	icon_state = "blazaambottle"
	name = "Sealed Blazaam"

/obj/item/export/bottle/trappist
	icon_state = "trappistbottle"
	name = "Sealed Trappist"

/obj/item/export/bottle/grenadine
	icon_state = "grenadine"
	name = "Sealed Grenadine"

/obj/item/export/bottle/minikeg
	name = "Mini-Beer Keg"
	icon_state = "keggy"
	desc = "A small wooden barrle with metal rings, untapped beer inside."

/obj/item/export/bottle/blooddrop
	icon_state = "champagne_selling_bottle"
	name = "Blood Drop"
	desc = "Large red bottle filled with a mix of wine and other named brands."

/obj/item/export/bottle/slim_gold
	name = "Slim Gold "
	icon_state = "selling_bottle_alt"
	desc = "A gold looking yellow bottle that has a mix of different named brands."

/obj/item/export/bottle/white_bloodmoon
	name = "White Bloodmoon"
	icon_state = "selling_bottle_basic"
	desc = "Rather simple bottle for this kind of drink."

/obj/item/export/bottle/greenroad
	name = "Green Road"
	icon_state = "selling_bottle"
	desc = "Ironic name as the fruit used is from ashy plants."

/obj/item/reagent_containers/cup/glass/bottle/nukashine
	name = "Nukashine"
	desc = "You've really hit rock bottom now... yet theres nothing like homebrew nukashine in times like these!"
	icon_state = "nukashine"
	list_reagents = list(/datum/reagent/consumable/ethanol/nukashine = 100)


// Empty bottles
/obj/item/reagent_containers/cup/glass/bottle/brown/white
	name = "white bottle"
	desc = "A homemade and hand-crafted white glass bottle."
	icon_state = "whitebottle"

/obj/item/reagent_containers/cup/glass/bottle/brown/green
	name = "green bottle"
	desc = "A homemade and hand-crafted green glass bottle."
	icon_state = "greenbottle"

/obj/item/reagent_containers/cup/glass/bottle/brown/beer
	name = "beer bottle"
	desc = "A homemade and hand-crafted authentic beer bottle."
	icon_state = "beerbottle"

/obj/item/reagent_containers/cup/glass/bottle/brown/darkbrown
	name = "dark brown bottle"
	desc = "A homemade and hand-crafted dark brown glass bottle."
	icon_state = "darkbrownbottle"

/obj/item/reagent_containers/cup/glass/bottle/brown/lightbrown
	name = "light brown bottle"
	desc = "A homemade and hand-crafted light brown glass bottle."
	icon_state = "lightbrownbottle"

/obj/item/reagent_containers/cup/glass/bottle/brown/wine
	name = "wine bottle"
	desc = "A homemade and hand-crafted wine glass bottle."
	icon_state = "winebottle"

/obj/item/reagent_containers/cup/glass/bottle/brown/greenwine
	name = "wine bottle"
	desc = "A homemade and hand-crafted green wine glass bottle."
	icon_state = "greenwinebottle"
