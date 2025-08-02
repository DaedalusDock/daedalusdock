/datum/supply_pack/apparel
	group = "Apparel"

/datum/supply_pack/apparel/random_hats
	name = "Collectable Hats Bundle"
	desc = "Flaunt your status with three unique, highly-collectable hats."
	cost = PAYCHECK_ASSISTANT * 2.5 + CARGO_CRATE_VALUE
	contains = list(
		/obj/item/clothing/head/collectable/chef,
		/obj/item/clothing/head/collectable/paper,
		/obj/item/clothing/head/collectable/tophat,
		/obj/item/clothing/head/collectable/captain,
		/obj/item/clothing/head/collectable/beret,
		/obj/item/clothing/head/collectable/welding,
		/obj/item/clothing/head/collectable/flatcap,
		/obj/item/clothing/head/collectable/pirate,
		/obj/item/clothing/head/collectable/kitty,
		/obj/item/clothing/head/collectable/rabbitears,
		/obj/item/clothing/head/collectable/wizard,
		/obj/item/clothing/head/collectable/hardhat,
		/obj/item/clothing/head/collectable/hos,
		/obj/item/clothing/head/collectable/hop,
		/obj/item/clothing/head/collectable/thunderdome,
		/obj/item/clothing/head/collectable/swat,
		/obj/item/clothing/head/collectable/slime,
		/obj/item/clothing/head/collectable/police,
		/obj/item/clothing/head/collectable/slime,
		/obj/item/clothing/head/collectable/xenom,
		/obj/item/clothing/head/collectable/petehat
	)

	crate_name = "collectable hats crate"
	crate_type = /obj/structure/closet/crate/wooden

	randomized = TRUE
	random_pick_amount = 3

/datum/supply_pack/apparel/formalwear
	name = "Formalwear Bundle"
	desc = "You're gonna like the way you look, I guaranteed it. Contains an asston of fancy clothing."
	cost = PAYCHECK_ASSISTANT * 11.1 + CARGO_CRATE_VALUE //Lots of very expensive items. You gotta pay up to look good!
	contains = list(
		/obj/item/clothing/under/dress/blacktango,
		/obj/item/clothing/under/misc/assistantformal,
		/obj/item/clothing/under/misc/assistantformal,
		/obj/item/clothing/under/rank/civilian/lawyer/bluesuit,
		/obj/item/clothing/suit/toggle/lawyer,
		/obj/item/clothing/under/rank/civilian/lawyer/purpsuit,
		/obj/item/clothing/suit/toggle/lawyer/purple,
		/obj/item/clothing/suit/toggle/lawyer/black,
		/obj/item/clothing/accessory/waistcoat,
		/obj/item/clothing/neck/tie/blue,
		/obj/item/clothing/neck/tie/red,
		/obj/item/clothing/neck/tie/black,
		/obj/item/clothing/head/bowler,
		/obj/item/clothing/head/fedora,
		/obj/item/clothing/head/flatcap,
		/obj/item/clothing/head/beret,
		/obj/item/clothing/head/that,
		/obj/item/clothing/shoes/laceup,
		/obj/item/clothing/under/suit/charcoal,
		/obj/item/clothing/under/suit/navy,
		/obj/item/clothing/under/suit/burgundy,
		/obj/item/clothing/under/suit/checkered,
		/obj/item/clothing/under/suit/tan,
		/obj/item/lipstick/random
	)
	crate_name = "formalwear crate"
	crate_type = /obj/structure/closet/crate/wooden

/datum/supply_pack/apparel/costume_original
	name = "Original Costume Bundle"
	desc = "Reenact Shakespearean plays with this assortment of outfits. Contains eight different costumes!"
	cost = PAYCHECK_ASSISTANT * 5.1 + CARGO_CRATE_VALUE
	contains = list(
		/obj/item/clothing/head/snowman,
		/obj/item/clothing/suit/snowman,
		/obj/item/clothing/head/chicken,
		/obj/item/clothing/suit/chickensuit,
		/obj/item/clothing/mask/gas/monkeymask,
		/obj/item/clothing/suit/monkeysuit,
		/obj/item/clothing/head/cardborg,
		/obj/item/clothing/suit/cardborg,
		/obj/item/clothing/head/xenos,
		/obj/item/clothing/suit/xenos,
		/obj/item/clothing/suit/hooded/ian_costume,
		/obj/item/clothing/suit/hooded/carp_costume,
		/obj/item/clothing/suit/hooded/bee_costume
	)
	crate_name = "original costume crate"
	crate_type = /obj/structure/closet/crate/wooden

/datum/supply_pack/costumes_toys/mafia
	name = "Cosa Nostra Starter Pack"
	desc = "This crate contains everything you need to set up your own ethnicity-based racketeering operation."
	cost = PAYCHECK_ASSISTANT * 3 + CARGO_CRATE_VALUE
	contains = list()
	supply_flags = SUPPLY_PACK_CONTRABAND

/datum/supply_pack/costumes_toys/mafia/fill(obj/structure/closet/crate/C)
	for(var/i in 1 to 4)
		new /obj/effect/spawner/random/clothing/mafia_outfit(C)
		new /obj/item/virgin_mary(C)
		if(prob(30)) //Not all mafioso have mustaches, some people also find this item annoying.
			new /obj/item/clothing/mask/fakemoustache/italian(C)
	if(prob(10)) //A little extra sugar every now and then to shake things up.
		new /obj/item/switchblade(C)

/datum/supply_pack/apparel/wedding
	name = "Wedding Bundle"
	desc = "Everything you need to host a wedding! Now you just need an officiant."
	cost = PAYCHECK_ASSISTANT * 3.2 + CARGO_CRATE_VALUE
	contains = list(
		/obj/item/clothing/under/dress/wedding_dress,
		/obj/item/clothing/under/suit/tuxedo,
		/obj/item/storage/belt/cummerbund,
		/obj/item/clothing/head/weddingveil,
		/obj/item/bouquet,
		/obj/item/bouquet/sunflower,
		/obj/item/bouquet/poppy,
		/obj/item/reagent_containers/cup/glass/bottle/champagne
	)
	crate_name = "wedding crate"

/datum/supply_pack/apparel/funeral
	name = "Funeral Bundle"
	desc = "At the end of the day, someone's gonna want someone dead. Give them a proper send-off with these funeral supplies! Contains a coffin with burial garmets and flowers."
	cost = PAYCHECK_ASSISTANT * 2 + CARGO_CRATE_VALUE
	contains = list(
		/obj/item/clothing/under/misc/burial,
		/obj/item/food/grown/harebell,
		/obj/item/food/grown/poppy/geranium
	)
	crate_name = "coffin"
	crate_type = /obj/structure/closet/crate/coffin
