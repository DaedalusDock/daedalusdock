

///////////////////////////////////////////////Alchohol bottles! -Agouri //////////////////////////
//Functionally identical to regular drinks. The only difference is that the default bottle size is 100. - Darem
//Bottles now knockdown and break when smashed on people's heads. - Giacom

/obj/item/reagent_containers/food/drinks/bottle
	name = "glass bottle"
	desc = "This blank bottle is unyieldingly anonymous, offering no clues to its contents."
	icon_state = "glassbottle"
	worn_icon_state = "bottle"
	fill_icon_thresholds = list(0, 10, 20, 30, 40, 50, 60, 70, 80, 90)
	custom_price = PAYCHECK_ASSISTANT * 1.2
	amount_per_transfer_from_this = 10
	volume = 100
	force = 15 //Smashing bottles over someone's head hurts.
	throwforce = 15
	inhand_icon_state = "beer" //Generic held-item sprite until unique ones are made.
	lefthand_file = 'icons/mob/inhands/misc/food_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/food_righthand.dmi'
	isGlass = TRUE
	foodtype = ALCOHOL
	age_restricted = TRUE // wrryy can't set an init value to see if foodtype contains ALCOHOL so here we go

	///Directly relates to the 'knockdown' duration. Lowered by armor (i.e. helmets)
	var/bottle_knockdown_duration = 1.3 SECONDS

	var/alcoholism_key = ""
	var/alcoholism_message =""

/obj/item/reagent_containers/food/drinks/bottle/Initialize(mapload)
	. = ..()
	if(alcoholism_key && alcoholism_message)
		AddElement(/datum/element/alcoholism_magnet, alcoholism_key, alcoholism_message)

/obj/item/reagent_containers/food/drinks/bottle/small
	name = "small glass bottle"
	desc = "This blank bottle is unyieldingly anonymous, offering no clues to its contents."
	icon_state = "glassbottlesmall"
	volume = 50
	custom_price = PAYCHECK_ASSISTANT * 0.8

/obj/item/reagent_containers/food/drinks/bottle/smash(mob/living/target, mob/thrower, ranged = FALSE)
	if(bartender_check(target) && ranged)
		return
	SplashReagents(target, ranged, override_spillable = TRUE)
	var/obj/item/broken_bottle/B = new (loc)
	if(!ranged && thrower)
		thrower.put_in_hands(B)
	B.mimic_broken(src, target)

	qdel(src)
	target.BumpedBy(B)

/obj/item/reagent_containers/food/drinks/bottle/attack_secondary(atom/target, mob/living/user, params)

	if(!target)
		return ..()

	if(HAS_TRAIT(user, TRAIT_PACIFISM))
		to_chat(user, span_warning("You don't want to harm [target]!"))
		return SECONDARY_ATTACK_CONTINUE_CHAIN

	if(!isliving(target) || !isGlass)
		return SECONDARY_ATTACK_CONTINUE_CHAIN

	var/mob/living/living_target = target
	var/obj/item/bodypart/affecting = user.zone_selected //Find what the player is aiming at

	var/armor_block = 0 //Get the target's armor values for normal attack damage.
	var/armor_duration = 0 //The more force the bottle has, the longer the duration.

	//Calculating duration and calculating damage.
	if(ishuman(target))

		var/mob/living/carbon/human/H = target
		var/headarmor = 0 // Target's head armor
		armor_block = H.run_armor_check(affecting, BLUNT,"","", armor_penetration) // For normal attack damage

		//If they have a hat/helmet and the user is targeting their head.
		if(istype(H.head, /obj/item/clothing/head) && affecting == BODY_ZONE_HEAD)
			headarmor = H.head.returnArmor().getRating(BLUNT)
		else
			headarmor = 0

		//Calculate the knockdown duration for the target.
		armor_duration = (bottle_knockdown_duration - headarmor) + force

	else
		//Only humans can have armor, right?
		armor_block = living_target.run_armor_check(affecting, BLUNT)
		if(affecting == BODY_ZONE_HEAD)
			armor_duration = bottle_knockdown_duration + force

	//Apply the damage!
	armor_block = min(90,armor_block)
	living_target.apply_damage(force, BRUTE, affecting, armor_block)

	// You are going to knock someone down for longer if they are not wearing a helmet.
	var/head_attack_message = ""
	if(affecting == BODY_ZONE_HEAD && istype(target, /mob/living/carbon/))
		head_attack_message = " on the head"
		if(armor_duration)
			living_target.apply_effect(min(armor_duration, 200) , EFFECT_KNOCKDOWN)

	//Display an attack message.
	if(target != user)
		target.visible_message(span_danger("[user] hits [target][head_attack_message] with a bottle of [src.name]!"), \
				span_userdanger("[user] hits you [head_attack_message] with a bottle of [src.name]!"))
	else
		target.visible_message(span_danger("[target] hits [target.p_them()]self with a bottle of [src.name][head_attack_message]!"), \
				span_userdanger("You hit yourself with a bottle of [src.name][head_attack_message]!"))

	//Attack logs
	log_combat(user, target, "attacked", src)

	//Finally, smash the bottle. This kills (del) the bottle.
	smash(target, user)

	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

//Keeping this here for now, I'll ask if I should keep it here.
/obj/item/broken_bottle
	name = "broken bottle"
	desc = "A bottle with a sharp broken bottom."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "broken_bottle"
	force = 9
	throwforce = 5
	throw_range = 5
	w_class = WEIGHT_CLASS_TINY
	inhand_icon_state = "broken_beer"
	lefthand_file = 'icons/mob/inhands/misc/food_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/food_righthand.dmi'
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb_continuous = list("stabs", "slashes", "attacks")
	attack_verb_simple = list("stab", "slash", "attack")
	sharpness = SHARP_EDGED
	var/static/icon/broken_outline = icon('icons/obj/drinks.dmi', "broken")

/obj/item/broken_bottle/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/caltrop, min_damage = force, probability = 4, flags = CALTROP_IGNORE_WALKERS)
	AddComponent(/datum/component/butchering, 200, 55)

/// Mimics the appearance and properties of the passed in bottle.
/// Takes the broken bottle to mimic, and the thing the bottle was broken agaisnt as args
/obj/item/broken_bottle/proc/mimic_broken(obj/item/reagent_containers/food/drinks/to_mimic, atom/target)
	icon_state = to_mimic.icon_state
	var/icon/drink_icon = new('icons/obj/drinks.dmi', icon_state)
	drink_icon.Blend(broken_outline, ICON_OVERLAY, rand(5), 1)
	drink_icon.SwapColor(rgb(255, 0, 220, 255), rgb(0, 0, 0, 0))
	icon = drink_icon

	if(to_mimic.isGlass)
		if(prob(33))
			var/obj/item/shard/stab_with = new(to_mimic.drop_location())
			target.BumpedBy(stab_with)
		playsound(src, SFX_SHATTER, 70, TRUE)
	else
		force = 0
		throwforce = 0
		desc = "A carton with the bottom half burst open. Might give you a papercut."

	name = "broken [to_mimic.name]"
	to_mimic.transfer_fingerprints_to(src)

/obj/item/reagent_containers/food/drinks/bottle/beer
	name = "space beer"
	desc = "Beer. In space."
	icon_state = "beer"
	volume = 30
	list_reagents = list(/datum/reagent/consumable/ethanol/beer = 30)
	foodtype = GRAIN | ALCOHOL
	custom_price = PAYCHECK_ASSISTANT * 1.3

	alcoholism_key = "alcoholism_beer"
	alcoholism_message = "That bottle won't empty itself."

/obj/item/reagent_containers/food/drinks/bottle/beer/almost_empty
	list_reagents = list(/datum/reagent/consumable/ethanol/beer = 1)

/obj/item/reagent_containers/food/drinks/bottle/beer/light
	name = "Carp Lite"
	desc = "Brewed with \"Pure Ice Asteroid Spring Water\"."
	list_reagents = list(/datum/reagent/consumable/ethanol/beer/light = 30)

/obj/item/reagent_containers/food/drinks/bottle/rootbeer
	name = "Two-Time root beer"
	desc = "A popular, old-fashioned brand of root beer, known for its extremely sugary formula. Might make you want a nap afterwards."
	volume = 30
	list_reagents = list(/datum/reagent/consumable/rootbeer = 30)
	foodtype = SUGAR | JUNKFOOD
	custom_price = PAYCHECK_ASSISTANT * 0.7
	custom_premium_price = PAYCHECK_ASSISTANT * 1.3

	alcoholism_key = "alcoholism_rootbeer"
	alcoholism_message = "If only it was the real deal."

/obj/item/reagent_containers/food/drinks/bottle/ale
	name = "Magm-Ale"
	desc = "A true dorf's drink of choice."
	icon_state = "alebottle"
	volume = 30
	list_reagents = list(/datum/reagent/consumable/ethanol/ale = 30)
	foodtype = GRAIN | ALCOHOL
	custom_price = PAYCHECK_EASY

	alcoholism_key = "alcoholism_ale"
	alcoholism_message = "Amber and frothy. You know you want it."

/obj/item/reagent_containers/food/drinks/bottle/gin
	name = "Griffeater gin"
	desc = "A bottle of high quality gin, produced in the New London Space Station."
	icon_state = "ginbottle"
	list_reagents = list(/datum/reagent/consumable/ethanol/gin = 100)

	alcoholism_key = "alcoholism_gin"
	alcoholism_message = "An orchestra of citrus calls your name, why deprive yourself?"

/obj/item/reagent_containers/food/drinks/bottle/whiskey
	name = "Uncle Git's special reserve"
	desc = "A premium single-malt whiskey, gently matured inside the tunnels of a nuclear shelter. TUNNEL WHISKEY RULES."
	icon_state = "whiskeybottle"
	list_reagents = list(/datum/reagent/consumable/ethanol/whiskey = 100)

	alcoholism_key = "alcoholism_whiskey"
	alcoholism_message = "Whiskey. A beautiful golden nectar, waiting to meet your tongue with a smokey caramel kiss."

/obj/item/reagent_containers/food/drinks/bottle/kong
	name = "Kong"
	desc = "Makes You Go Ape!&#174;"
	list_reagents = list(/datum/reagent/consumable/ethanol/whiskey/kong = 100)

/obj/item/reagent_containers/food/drinks/bottle/candycornliquor
	name = "candy corn liquor"
	desc = "Like they drank in 2D speakeasies."
	list_reagents = list(/datum/reagent/consumable/ethanol/whiskey/candycorn = 100)

/obj/item/reagent_containers/food/drinks/bottle/vodka
	name = "Tunguska triple distilled"
	desc = "Aah, vodka. Prime choice of drink AND fuel by Russians worldwide."
	icon_state = "vodkabottle"
	list_reagents = list(/datum/reagent/consumable/ethanol/vodka = 100)

	alcoholism_key = "alcoholism_vodka"
	alcoholism_message = "The purest of spirits, a blank canvas with a bite. Crystal clear liquid courage, waiting to start a fire in your throat. One shot..."

/obj/item/reagent_containers/food/drinks/bottle/vodka/badminka
	name = "Badminka vodka"
	desc = "The label's written in Cyrillic. All you can make out is the name and a word that looks vaguely like 'Vodka'."
	icon_state = "badminka"
	list_reagents = list(/datum/reagent/consumable/ethanol/vodka = 100)

/obj/item/reagent_containers/food/drinks/bottle/tequila
	name = "Caccavo guaranteed quality tequila"
	desc = "Made from premium petroleum distillates, pure thalidomide and other fine quality ingredients!"
	icon_state = "tequilabottle"
	list_reagents = list(/datum/reagent/consumable/ethanol/tequila = 100)

	alcoholism_key = "alcoholism_tequila"
	alcoholism_message = "Let the agave's sweet fire ignite your senses. Perhaps a little sugar and lime, one shot cannot hurt. Nor will two."

/obj/item/reagent_containers/food/drinks/bottle/bottleofnothing
	name = "bottle of nothing"
	desc = "A bottle filled with nothing."
	icon_state = "bottleofnothing"
	list_reagents = list(/datum/reagent/consumable/nothing = 100)
	foodtype = NONE
	age_restricted = FALSE

/obj/item/reagent_containers/food/drinks/bottle/patron
	name = "Wrapp Artiste Patron"
	desc = "Silver laced tequila, served in space night clubs across the galaxy."
	icon_state = "patronbottle"
	list_reagents = list(/datum/reagent/consumable/ethanol/patron = 100)

/obj/item/reagent_containers/food/drinks/bottle/rum
	name = "Captain Pete's Cuban spiced rum"
	desc = "This isn't just rum, oh no. It's practically GRIFF in a bottle."
	icon_state = "rumbottle"
	list_reagents = list(/datum/reagent/consumable/ethanol/rum = 100)

	alcoholism_key = "alcoholism_rum"
	alcoholism_message = "Sail the Great Pool with me. A lively port of celebration and raised glasses awaits in our paradise."

/obj/item/reagent_containers/food/drinks/bottle/maltliquor
	name = "\improper Rabid Bear malt liquor"
	desc = "A 40 full of malt liquor. Kicks stronger than, well, a rabid bear."
	icon_state = "maltliquorbottle"
	list_reagents = list(/datum/reagent/consumable/ethanol/beer/maltliquor = 100)
	custom_price = PAYCHECK_EASY

/obj/item/reagent_containers/food/drinks/bottle/holywater
	name = "flask of holy water"
	desc = "A flask of the chaplain's holy water."
	icon_state = "holyflask"
	list_reagents = list(/datum/reagent/water/holywater = 100)
	foodtype = NONE

/obj/item/reagent_containers/food/drinks/bottle/vermouth
	name = "Goldeneye vermouth"
	desc = "Sweet, sweet dryness~"
	icon_state = "vermouthbottle"
	list_reagents = list(/datum/reagent/consumable/ethanol/vermouth = 100)

/obj/item/reagent_containers/food/drinks/bottle/kahlua
	name = "Robert Robust's coffee liqueur"
	desc = "A widely known, Mexican coffee-flavoured liqueur. In production since 1936, HONK."
	icon_state = "kahluabottle"
	list_reagents = list(/datum/reagent/consumable/ethanol/kahlua = 100)
	foodtype = VEGETABLES

/obj/item/reagent_containers/food/drinks/bottle/goldschlager
	name = "College Girl goldschlager"
	desc = "Because they are the only ones who will drink 100 proof cinnamon schnapps."
	icon_state = "goldschlagerbottle"
	list_reagents = list(/datum/reagent/consumable/ethanol/goldschlager = 100)

/obj/item/reagent_containers/food/drinks/bottle/cognac
	name = "Chateau de Baton premium cognac"
	desc = "A sweet and strongly alchoholic drink, made after numerous distillations and years of maturing. You might as well not scream 'SHITCURITY' this time."
	icon_state = "cognacbottle"
	list_reagents = list(/datum/reagent/consumable/ethanol/cognac = 100)

	alcoholism_key = "alcoholism_cognac"
	alcoholism_message = "We shall dine like the kings of old. Someone like yourself deserves such a dignified beverage. Pour a glass, let's savor excellence."

/obj/item/reagent_containers/food/drinks/bottle/wine
	name = "Doublebeard's bearded special wine"
	desc = "A faint aura of unease and asspainery surrounds the bottle."
	icon_state = "winebottle"
	list_reagents = list(/datum/reagent/consumable/ethanol/wine = 100)
	foodtype = FRUIT | ALCOHOL

	alcoholism_key = "alcoholism_wine"
	alcoholism_message = "Wine. Oh the nector of the gods, a symphony of crushed grapes, sunlit vineyards and ancient traditions. It is not just a drink—it's a masterpiece in a bottle. One you have earned."

/obj/item/reagent_containers/food/drinks/bottle/wine/add_initial_reagents()
	. = ..()
	var/wine_info = generate_vintage()
	var/datum/reagent/consumable/ethanol/wine/W = locate() in reagents.reagent_list
	if(W)
		LAZYSET(W.data,"vintage",wine_info)

/obj/item/reagent_containers/food/drinks/bottle/wine/proc/generate_vintage()
	return "[CURRENT_STATION_YEAR] Daedalus Light Red"

/obj/item/reagent_containers/food/drinks/bottle/wine/unlabeled
	name = "unlabeled wine bottle"
	desc = "There's no label on this wine bottle."

/obj/item/reagent_containers/food/drinks/bottle/wine/unlabeled/generate_vintage()
	var/current_year = CURRENT_STATION_YEAR
	var/year = rand(current_year-50,current_year)
	var/type = pick("Sparkling","Dry White","Sweet White","Rich White","Rose","Light Red","Medium Red","Bold Red","Dessert")
	var/origin = pick("Ananke", "Daedalus","Syndicate","Local")
	return "[year] [origin] [type]"

/obj/item/reagent_containers/food/drinks/bottle/absinthe
	name = "extra-strong absinthe"
	desc = "A strong alcoholic drink brewed and distributed by"
	icon_state = "absinthebottle"
	list_reagents = list(/datum/reagent/consumable/ethanol/absinthe = 100)

	alcoholism_key = "alcoholism_wine"
	alcoholism_message = "The forbidden fruit beckons. It is no mere drink—it's a portal to a world of verdant splendor. This isn't for the faint of heart. It's for the curious, the bold, the thrillseeker. And it has your name on it."

/obj/item/reagent_containers/food/drinks/bottle/absinthe/Initialize(mapload)
	. = ..()
	redact()

/obj/item/reagent_containers/food/drinks/bottle/absinthe/proc/redact()
	// There was a large fight in the coderbus about a player reference
	// in absinthe. Ergo, this is why the name generation is now so
	// complicated. Judge us kindly.
	var/shortname = pick_weight(
		list("T&T" = 1, "A&A" = 1, "Generic" = 1))
	var/fullname
	switch(shortname)
		if("T&T")
			fullname = "Teal and Tealer"
		if("A&A")
			fullname = "Ash and Asher"
		if("Generic")
			fullname = "Ananke Cheap Imitations"
	var/removals = list("\[REDACTED\]", "\[EXPLETIVE DELETED\]",
		"\[EXPUNGED\]", "\[INFORMATION ABOVE YOUR SECURITY CLEARANCE\]",
		"\[MOVE ALONG CITIZEN\]", "\[NOTHING TO SEE HERE\]")
	var/chance = 50

	if(prob(chance))
		shortname = pick_n_take(removals)

	var/list/final_fullname = list()
	for(var/word in splittext(fullname, " "))
		if(prob(chance))
			word = pick_n_take(removals)
		final_fullname += word

	fullname = jointext(final_fullname, " ")

	// Actually finally setting the new name and desc
	name = "[shortname] [name]"
	desc = "[desc] [fullname] Inc."


/obj/item/reagent_containers/food/drinks/bottle/absinthe/premium
	name = "Gwyn's premium absinthe"
	desc = "A potent alcoholic beverage, almost makes you forget the ash in your lungs."
	icon_state = "absinthepremium"

/obj/item/reagent_containers/food/drinks/bottle/absinthe/premium/redact()
	return

/obj/item/reagent_containers/food/drinks/bottle/hcider
	name = "Jian Hard Cider"
	desc = "Apple juice for adults."
	icon_state = "hcider"
	volume = 50
	list_reagents = list(/datum/reagent/consumable/ethanol/hcider = 50)

/obj/item/reagent_containers/food/drinks/bottle/amaretto
	name = "Luini Amaretto"
	desc = "A gentle and syrup like drink, tastes of almonds and apricots"
	icon_state = "disaronno"
	list_reagents = list(/datum/reagent/consumable/ethanol/amaretto = 100)

/obj/item/reagent_containers/food/drinks/bottle/grappa
	name = "Phillipes well-aged Grappa"
	desc = "Bottle of Grappa."
	icon_state = "grappabottle"
	list_reagents = list(/datum/reagent/consumable/ethanol/grappa = 100)

/obj/item/reagent_containers/food/drinks/bottle/sake
	name = "Ryo's traditional sake"
	desc = "Sweet as can be, and burns like fire going down."
	icon_state = "sakebottle"
	list_reagents = list(/datum/reagent/consumable/ethanol/sake = 100)

/obj/item/reagent_containers/food/drinks/bottle/sake/Initialize(mapload)
	. = ..()
	if(prob(10))
		name = "Fluffy Tail Sake"
		desc += " On the bottle is a picture of a kitsune with nine touchable tails."
		icon_state = "sakebottle_k"
	else if(prob(10))
		name = "Inubashiri's Home Brew"
		desc += " Awoo."
		icon_state = "sakebottle_i"

/obj/item/reagent_containers/food/drinks/bottle/fernet
	name = "Fernet Bronca"
	desc = "A bottle of pure Fernet Bronca, produced in Cordoba Space Station"
	icon_state = "fernetbottle"
	list_reagents = list(/datum/reagent/consumable/ethanol/fernet = 100)

/obj/item/reagent_containers/food/drinks/bottle/bitters
	name = "Andromeda Bitters"
	desc = "An aromatic addition to any drink. Made in New Trinidad, now and forever."
	icon_state = "bitters_bottle"
	volume = 30
	list_reagents = list(/datum/reagent/consumable/ethanol/bitters = 30)

/obj/item/reagent_containers/food/drinks/bottle/curacao
	name = "Beekhof Blauw Curaçao"
	desc = "Still produced on the island of Curaçao, after all these years."
	icon_state = "curacao_bottle"
	list_reagents = list(/datum/reagent/consumable/ethanol/curacao = 100)

/obj/item/reagent_containers/food/drinks/bottle/navy_rum
	name = "Pride of the Union Navy-Strength Rum"
	desc = "Ironically named, given it's made in Bermuda."
	icon_state = "navy_rum_bottle"
	list_reagents = list(/datum/reagent/consumable/ethanol/navy_rum = 100)

//////////////////////////JUICES AND STUFF ///////////////////////

/obj/item/reagent_containers/food/drinks/bottle/orangejuice
	name = "orange juice"
	desc = "Full of vitamins and deliciousness!"
	custom_price = PAYCHECK_ASSISTANT * 0.6
	icon_state = "orangejuice"
	inhand_icon_state = "carton"
	lefthand_file = 'icons/mob/inhands/equipment/kitchen_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/kitchen_righthand.dmi'
	isGlass = FALSE
	list_reagents = list(/datum/reagent/consumable/orangejuice = 100)
	foodtype = FRUIT | BREAKFAST
	age_restricted = FALSE

/obj/item/reagent_containers/food/drinks/bottle/cream
	name = "milk cream"
	desc = "It's cream. Made from milk. What else did you think you'd find in there?"
	custom_price = PAYCHECK_ASSISTANT * 0.6
	icon_state = "cream"
	inhand_icon_state = "carton"
	lefthand_file = 'icons/mob/inhands/equipment/kitchen_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/kitchen_righthand.dmi'
	isGlass = FALSE
	list_reagents = list(/datum/reagent/consumable/cream = 100)
	foodtype = DAIRY
	age_restricted = FALSE

/obj/item/reagent_containers/food/drinks/bottle/tomatojuice
	name = "tomato juice"
	desc = "Well, at least it LOOKS like tomato juice. You can't tell with all that redness."
	custom_price = PAYCHECK_ASSISTANT * 0.6
	icon_state = "tomatojuice"
	inhand_icon_state = "carton"
	lefthand_file = 'icons/mob/inhands/equipment/kitchen_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/kitchen_righthand.dmi'
	isGlass = FALSE
	list_reagents = list(/datum/reagent/consumable/tomatojuice = 100)
	foodtype = VEGETABLES
	age_restricted = FALSE

/obj/item/reagent_containers/food/drinks/bottle/limejuice
	name = "lime juice"
	desc = "Sweet-sour goodness."
	custom_price = PAYCHECK_ASSISTANT * 0.6
	icon_state = "limejuice"
	inhand_icon_state = "carton"
	lefthand_file = 'icons/mob/inhands/equipment/kitchen_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/kitchen_righthand.dmi'
	isGlass = FALSE
	list_reagents = list(/datum/reagent/consumable/limejuice = 100)
	foodtype = FRUIT
	age_restricted = FALSE

/obj/item/reagent_containers/food/drinks/bottle/pineapplejuice
	name = "pineapple juice"
	desc = "Extremely tart, yellow juice."
	custom_price = PAYCHECK_ASSISTANT * 0.6
	icon_state = "pineapplejuice"
	inhand_icon_state = "carton"
	lefthand_file = 'icons/mob/inhands/equipment/kitchen_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/kitchen_righthand.dmi'
	isGlass = FALSE
	list_reagents = list(/datum/reagent/consumable/pineapplejuice = 100)
	foodtype = FRUIT | PINEAPPLE
	age_restricted = FALSE

/obj/item/reagent_containers/food/drinks/bottle/menthol
	name = "menthol"
	desc = "Tastes naturally minty, and imparts a very mild numbing sensation."
	custom_price = PAYCHECK_ASSISTANT * 0.6
	icon_state = "mentholbox"
	inhand_icon_state = "carton"
	lefthand_file = 'icons/mob/inhands/equipment/kitchen_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/kitchen_righthand.dmi'
	isGlass = FALSE
	list_reagents = list(/datum/reagent/consumable/menthol = 100)

/obj/item/reagent_containers/food/drinks/bottle/grenadine
	name = "Jester Grenadine"
	desc = "Contains 0% real cherries!"
	custom_price = PAYCHECK_ASSISTANT * 0.6
	icon_state = "grenadine"
	isGlass = TRUE
	list_reagents = list(/datum/reagent/consumable/grenadine = 100)
	foodtype = FRUIT
	age_restricted = FALSE

/obj/item/reagent_containers/food/drinks/bottle/applejack
	name = "Buckin' Bronco's Applejack"
	desc = "Kicks like a horse, tastes like an apple!"
	custom_price = PAYCHECK_ASSISTANT * 1.6
	icon_state = "applejack_bottle"
	isGlass = TRUE
	list_reagents = list(/datum/reagent/consumable/ethanol/applejack = 100)
	foodtype = FRUIT

/obj/item/reagent_containers/food/drinks/bottle/champagne
	name = "Eau d' Dandy Brut Champagne"
	desc = "Finely sourced from only the most pretentious French vineyards."
	icon_state = "champagne_bottle"
	base_icon_state = "champagne_bottle"
	reagent_flags = TRANSPARENT
	spillable = FALSE
	isGlass = TRUE
	list_reagents = list(/datum/reagent/consumable/ethanol/champagne = 100)


/obj/item/reagent_containers/food/drinks/bottle/champagne/attack_self(mob/user)
	if(spillable)
		return ..()
	balloon_alert(user, "fiddling with cork...")
	if(do_after(user, src, 1 SECONDS))
		return pop_cork(user)

/obj/item/reagent_containers/food/drinks/bottle/champagne/update_icon_state()
	. = ..()
	if(spillable)
		icon_state = "[base_icon_state]_popped"
	else
		icon_state = base_icon_state

/obj/item/reagent_containers/food/drinks/bottle/champagne/proc/pop_cork(mob/user)
	user.visible_message(span_danger("[user] loosens the cork of [src] causing it to pop out of the bottle with great force."), \
		span_nicegreen("You elegantly loosen the cork of [src] causing it to pop out of the bottle with great force."))
	reagents.flags |= OPENCONTAINER
	playsound(src, 'sound/items/champagne_pop.ogg', 70, TRUE)
	spillable = TRUE
	update_appearance()
	var/obj/projectile/bullet/reusable/champagne_cork/popped_cork = new (get_turf(src))
	popped_cork.firer =  user
	popped_cork.fired_from = src
	popped_cork.fire(dir2angle(user.dir) + rand(-30, 30))

/obj/projectile/bullet/reusable/champagne_cork
	name = "champagne cork"
	icon = 'icons/obj/drinks.dmi'
	icon_state = "champagne_cork"
	hitsound = 'sound/weapons/genhit.ogg'
	damage = 10
	sharpness = NONE
	impact_effect_type = null
	ricochets_max = 3
	ricochet_chance = 70
	ricochet_decay_damage = 1
	ricochet_incidence_leeway = 0
	range = 7
	knockdown = 2 SECONDS
	ammo_type = /obj/item/trash/champagne_cork

/obj/item/trash/champagne_cork
	name = "champagne cork"
	icon = 'icons/obj/drinks.dmi'
	icon_state = "champagne_cork"

/obj/item/reagent_containers/food/drinks/bottle/blazaam
	name = "Ginbad's Blazaam"
	desc = "You feel like you should give the bottle a good rub before opening."
	icon_state = "blazaambottle"
	list_reagents = list(/datum/reagent/consumable/ethanol/blazaam = 100)

/obj/item/reagent_containers/food/drinks/bottle/trappist
	name = "Mont de Requin Trappistes Bleu"
	desc = "Brewed in space-Belgium. Fancy!"
	icon_state = "trappistbottle"
	volume = 50
	list_reagents = list(/datum/reagent/consumable/ethanol/trappist = 50)

/obj/item/reagent_containers/food/drinks/bottle/hooch
	name = "hooch bottle"
	desc = "A bottle of rotgut. Its owner has applied some street wisdom to cleverly disguise it as a brown paper bag."
	icon_state = "hoochbottle"
	list_reagents = list(/datum/reagent/consumable/ethanol/hooch = 100)

/obj/item/reagent_containers/food/drinks/bottle/moonshine
	name = "moonshine jug"
	desc = "It is said that the ancient Applalacians used these stoneware jugs to capture lightning in a bottle."
	icon_state = "moonshinebottle"
	list_reagents = list(/datum/reagent/consumable/ethanol/moonshine = 100)

/obj/item/reagent_containers/food/drinks/bottle/mushi_kombucha
	name = "Solzara Brewing Company Mushi Kombucha"
	desc = "Best drunk over ice to savour the mushroomy flavour."
	icon_state = "shroomy_bottle"
	volume = 30
	list_reagents = list(/datum/reagent/consumable/ethanol/mushi_kombucha = 30)
	isGlass = FALSE

////////////////////////// MOLOTOV ///////////////////////
/obj/item/reagent_containers/food/drinks/bottle/molotov
	name = "molotov cocktail"
	desc = "A throwing weapon used to ignite things, typically filled with an accelerant. Recommended highly by rioters and revolutionaries. Light and toss."
	icon_state = "vodkabottle"
	list_reagents = list()
	var/list/accelerants = list( /datum/reagent/consumable/ethanol, /datum/reagent/fuel, /datum/reagent/clf3, /datum/reagent/phlogiston,
							/datum/reagent/napalm, /datum/reagent/toxin/plasma, /datum/reagent/toxin/spore_burning)
	var/active = FALSE

/obj/item/reagent_containers/food/drinks/bottle/molotov/CheckParts(list/parts_list)
	..()
	var/obj/item/reagent_containers/food/drinks/bottle/B = locate() in contents
	if(B)
		icon_state = B.icon_state
		B.reagents.copy_to(src,100)
		if(!B.isGlass)
			desc += " You're not sure if making this out of a carton was the brightest idea."
			isGlass = FALSE
	return

/obj/item/reagent_containers/food/drinks/bottle/molotov/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	var/firestarter = 0
	for(var/datum/reagent/R in reagents.reagent_list)
		for(var/A in accelerants)
			if(istype(R,A))
				firestarter = 1
				break
	if(firestarter && active)
		hit_atom.fire_act()
		//new /obj/effect/hotspot(get_turf(hit_atom))
		var/turf/T = get_turf(hit_atom)
		T.create_fire(1, 10)
	..()

/obj/item/reagent_containers/food/drinks/bottle/molotov/attackby(obj/item/I, mob/user, params)
	if(I.get_temperature() && !active)
		active = TRUE
		log_bomber(user, "has primed a", src, "for detonation")

		to_chat(user, span_info("You light [src] on fire."))
		add_overlay(custom_fire_overlay ? custom_fire_overlay : GLOB.fire_overlay)
		if(!isGlass)
			addtimer(CALLBACK(src, PROC_REF(explode)), 5 SECONDS)

/obj/item/reagent_containers/food/drinks/bottle/molotov/proc/explode()
	if(!active)
		return
	if(get_turf(src))
		var/atom/target = loc
		for(var/i in 1 to 2)
			if(istype(target, /obj/item/storage))
				target = target.loc
		SplashReagents(target, override_spillable = TRUE)
		target.fire_act()
	qdel(src)

/obj/item/reagent_containers/food/drinks/bottle/molotov/attack_self(mob/user)
	if(active)
		if(!isGlass)
			to_chat(user, span_danger("The flame's spread too far on it!"))
			return
		to_chat(user, span_info("You snuff out the flame on [src]."))
		cut_overlay(custom_fire_overlay ? custom_fire_overlay : GLOB.fire_overlay)
		active = FALSE
		return
	return ..()

/obj/item/reagent_containers/food/drinks/bottle/pruno
	name = "pruno mix"
	desc = "A trash bag filled with fruit, sugar, yeast, and water, pulped together into a pungent slurry to be fermented in an enclosed space, traditionally the toilet. Security would love to confiscate this, one of the many things wrong with them."
	icon = 'icons/obj/janitor.dmi'
	icon_state = "trashbag"
	list_reagents = list(/datum/reagent/consumable/prunomix = 50)
	var/fermentation_time = 30 SECONDS /// time it takes to ferment
	var/fermentation_time_remaining /// for partial fermentation
	var/fermentation_timer /// store the timer id of fermentation

/obj/item/reagent_containers/food/drinks/bottle/pruno/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_MOVABLE_MOVED, PROC_REF(check_fermentation))

/obj/item/reagent_containers/food/drinks/bottle/pruno/Destroy()
	UnregisterSignal(src, COMSIG_MOVABLE_MOVED)
	return ..()

// Checks to see if the pruno can ferment, i.e. is it inside a structure (e.g. toilet), or a machine (e.g. washer)?
// TODO: make it so the washer spills reagents if a reagent container is in there, for now, you can wash pruno

/obj/item/reagent_containers/food/drinks/bottle/pruno/proc/check_fermentation()
	SIGNAL_HANDLER
	if (!(istype(loc, /obj/machinery) || istype(loc, /obj/structure)))
		if(fermentation_timer)
			fermentation_time_remaining = timeleft(fermentation_timer)
			deltimer(fermentation_timer)
			fermentation_timer = null
		return
	if(fermentation_timer)
		return
	if(!fermentation_time_remaining)
		fermentation_time_remaining = fermentation_time
	fermentation_timer = addtimer(CALLBACK(src, PROC_REF(do_fermentation)), fermentation_time_remaining, TIMER_UNIQUE|TIMER_STOPPABLE)
	fermentation_time_remaining = null

// actually ferment

/obj/item/reagent_containers/food/drinks/bottle/pruno/proc/do_fermentation()
	fermentation_time_remaining = null
	fermentation_timer = null
	reagents.remove_reagent(/datum/reagent/consumable/prunomix, 50)
	if(prob(10))
		reagents.add_reagent(/datum/reagent/toxin/bad_food, 15) // closest thing we have to botulism
		reagents.add_reagent(/datum/reagent/consumable/ethanol/pruno, 35)
	else
		reagents.add_reagent(/datum/reagent/consumable/ethanol/pruno, 50)
	name = "bag of pruno"
	desc = "Fermented prison wine made from fruit, sugar, and despair. You probably shouldn't drink this around Security."
	icon_state = "trashbag1" // pruno releases air as it ferments, we don't want to simulate this in atmos, but we can make it look like it did
	for (var/mob/living/M in view(2, get_turf(src))) // letting people and/or narcs know when the pruno is done
		to_chat(M, span_info("A pungent smell emanates from [src], like fruit puking out its guts."))
		playsound(get_turf(src), 'sound/effects/bubbles2.ogg', 25, TRUE)
