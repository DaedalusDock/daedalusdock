/datum/supply_pack/misc
	group = "Miscellaneous Supplies"

/datum/supply_pack/misc/artsupply
	name = "Art Supply Bundle"
	desc = "Make some happy little accidents with a rapid pipe cleaner layer, three spraycans, and lots of crayons!"
	cost = PAYCHECK_ASSISTANT * 2 + CARGO_CRATE_VALUE
	contains = list(
		/obj/item/storage/toolbox/artistic,
		/obj/item/toy/crayon/spraycan,
		/obj/item/toy/crayon/spraycan,
		/obj/item/toy/crayon/spraycan,
		/obj/item/storage/crayons,
		/obj/item/toy/crayon/white,
		/obj/item/toy/crayon/rainbow
	)
	crate_name = "art supply crate"
	crate_type = /obj/structure/closet/crate/wooden

/datum/supply_pack/misc
	group = "Miscellaneous Supplies"

/datum/supply_pack/misc/bicycle
	name = "Bicycle"
	desc = "Daedalus Industries reminds all employees to never toy with powers outside their control."
	cost = 1000000 //Special case, we don't want to make this in terms of crates because having bikes be a million credits is the whole meme.
	contains = list(/obj/vehicle/ridden/bicycle)
	crate_name = "bicycle crate"
	crate_type = /obj/structure/closet/crate/large

/datum/supply_pack/misc/bigband
	name = "Big Band Instrument Collection"
	desc = "Get your sad station movin' and groovin' with this fine collection! Contains nine different instruments!"
	cost = PAYCHECK_ASSISTANT * 13.2 + CARGO_CRATE_VALUE
	crate_name = "Big band musical instruments collection"
	contains = list(/obj/item/instrument/violin,
					/obj/item/instrument/guitar,
					/obj/item/instrument/glockenspiel,
					/obj/item/instrument/accordion,
					/obj/item/instrument/saxophone,
					/obj/item/instrument/trombone,
					/obj/item/instrument/recorder,
					/obj/item/instrument/harmonica,
					/obj/structure/musician/piano/unanchored)
	crate_type = /obj/structure/closet/crate/wooden

/datum/supply_pack/misc/book_crate
	name = "Book Bundle"
	desc = "Surplus from the Core Worlds Archives, these seven books are sure to be good reads."
	cost = PAYCHECK_ASSISTANT * 1.8 + CARGO_CRATE_VALUE
	contains = list(
		/obj/item/book/codex_gigas,
		/obj/item/book/manual/random,
		/obj/item/book/manual/random,
		/obj/item/book/manual/random,
		/obj/item/book/random,
		/obj/item/book/random,
		/obj/item/book/random
		)
	crate_type = /obj/structure/closet/crate/wooden

/datum/supply_pack/misc/paper
	name = "Bureaucracy Bundle"
	desc = "High stacks of papers on your desk Are a big problem - make it Pea-sized with these bureaucratic supplies! Contains six pens, some camera film, hand labeler supplies, a paper bin, a carbon paper bin, three folders, a laser pointer, two clipboards and two stamps."//that was too forced
	cost = PAYCHECK_ASSISTANT * 2 + CARGO_CRATE_VALUE
	contains = list(
		/obj/structure/filingcabinet/chestdrawer/wheeled,
		/obj/item/camera_film,
		/obj/item/hand_labeler,
		/obj/item/hand_labeler_refill,
		/obj/item/paper_bin,
		/obj/item/pen/fourcolor,
		/obj/item/pen/fourcolor,
		/obj/item/pen,
		/obj/item/pen/fountain,
		/obj/item/pen/blue,
		/obj/item/pen/red,
		/obj/item/folder/blue,
		/obj/item/folder/red,
		/obj/item/folder/yellow,
		/obj/item/clipboard,
		/obj/item/stamp,
		/obj/item/stamp/denied,
		/obj/item/laser_pointer/purple
	)
	crate_name = "bureaucracy crate"

/datum/supply_pack/misc/fountainpens
	name = "Calligraphy Bundle"
	desc = "Sign death warrants in style with these seven executive fountain pens."
	cost = PAYCHECK_ASSISTANT * 1 + CARGO_CRATE_VALUE
	contains = list(/obj/item/storage/box/fountainpens)
	crate_type = /obj/structure/closet/crate/wooden
	crate_name = "calligraphy crate"

/datum/supply_pack/misc/wrapping_paper
	name = "Festive Wrapping Paper Crate"
	desc = "Want to mail your loved ones gift-wrapped chocolates, stuffed animals, the Clown's severed head? You can do all that, with this crate full of wrapping paper."
	cost = PAYCHECK_ASSISTANT * 1.6 + CARGO_CRATE_VALUE
	contains = list(/obj/item/stack/wrapping_paper)
	crate_type = /obj/structure/closet/crate/wooden
	crate_name = "festive wrapping paper crate"

/datum/supply_pack/misc/religious_supplies
	name = "Religious Supplies Bundle"
	desc = "Keep your local chaplain happy and well-supplied, lest they call down judgement upon your cargo bay. Contains two bottles of holywater, bibles, chaplain robes, and burial garmets."
	cost = PAYCHECK_ASSISTANT * 5.8 + CARGO_CRATE_VALUE // it costs so much because the Space Church needs funding to build a cathedral
	contains = list(
		/obj/item/reagent_containers/cup/glass/bottle/holywater,
		/obj/item/storage/book/bible/booze,
		/obj/item/clothing/suit/hooded/chaplain_hoodie,
		/obj/item/clothing/under/misc/burial,
	)
	crate_name = "religious supplies crate"

/datum/supply_pack/misc/toner
	name = "Toner Crate"
	desc = "Spent too much ink printing butt pictures? Fret not, with these six toner refills, you'll be printing butts 'till the cows come home!'"
	cost = PAYCHECK_ASSISTANT * 2 + CARGO_CRATE_VALUE
	contains = list(/obj/item/toner,
					/obj/item/toner,
					/obj/item/toner,
					/obj/item/toner,
					/obj/item/toner,
					/obj/item/toner
		)
	crate_name = "toner crate"

///Special supply crate that generates random syndicate gear up to a determined TC value
/datum/supply_pack/misc/syndicate
	name = "Assorted Syndicate Gear"
	desc = "Contains a random assortment of syndicate gear."
	special = TRUE ///Cannot be ordered via cargo
	contains = list()
	crate_name = "syndicate gear crate"
	crate_type = /obj/structure/closet/crate
	var/crate_value = 30 ///Total TC worth of contained uplink items
	var/uplink_flag = UPLINK_TRAITORS

///Generate assorted uplink items, taking into account the same surplus modifiers used for surplus crates
/datum/supply_pack/misc/syndicate/fill(obj/structure/closet/crate/C)
	var/list/uplink_items = list()
	for(var/datum/uplink_item/item_path as anything in SStraitor.uplink_items_by_type)
		var/datum/uplink_item/item = SStraitor.uplink_items_by_type[item_path]
		if(item.purchasable_from & UPLINK_TRAITORS && item.item)
			uplink_items += item

	while(crate_value)
		var/datum/uplink_item/uplink_item = pick(uplink_items)
		if(!uplink_item.surplus || prob(100 - uplink_item.surplus))
			continue
		if(crate_value < uplink_item.cost)
			continue
		crate_value -= uplink_item.cost
		new uplink_item.item(C)

/datum/supply_pack/misc/contraband
	name = "Contraband Crate"
	desc = "Psst.. bud... want some contraband? I can get you a poster, some nice cigs, dank, even some sponsored items...you know, the good stuff. Just keep it away from the cops, kay?"
	supply_flags = SUPPLY_PACK_CONTRABAND
	cost = PAYCHECK_ASSISTANT * 15 + CARGO_CRATE_VALUE
	contains = list(
		/obj/item/poster/random_contraband,
		/obj/item/poster/random_contraband,
		/obj/item/food/grown/cannabis,
		/obj/item/food/grown/cannabis/rainbow,
		/obj/item/food/grown/cannabis/white,
		/obj/item/storage/box/fireworks/dangerous,
		/obj/item/storage/pill_bottle/zoom,
		/obj/item/storage/pill_bottle/happy,
		/obj/item/storage/pill_bottle/lsd,
		/obj/item/storage/pill_bottle/aranesp,
		/obj/item/storage/pill_bottle/stimulant,
		/obj/item/toy/cards/deck/syndicate,
		/obj/item/reagent_containers/cup/glass/bottle/absinthe,
		/obj/item/clothing/under/syndicate/tacticool,
		/obj/item/storage/fancy/cigarettes/cigpack_syndicate,
		/obj/item/storage/fancy/cigarettes/cigpack_shadyjims,
		/obj/item/clothing/mask/gas/syndicate,
		/obj/item/clothing/neck/necklace/dope,
		/obj/item/vending_refill/donksoft
	)
	crate_name = "crate"

	randomized = TRUE
	random_pick_amount = 7

/datum/supply_pack/misc/lasertag
	name = "Laser Tag Crate"
	desc = "Foam Force is for boys. Laser Tag is for men. Contains three sets of red suits, blue suits, matching helmets, and matching laser tag guns."
	cost = PAYCHECK_ASSISTANT * 6.9 + CARGO_CRATE_VALUE
	contains = list(
		/obj/item/gun/energy/laser/redtag,
		/obj/item/gun/energy/laser/redtag,
		/obj/item/gun/energy/laser/redtag,
		/obj/item/gun/energy/laser/bluetag,
		/obj/item/gun/energy/laser/bluetag,
		/obj/item/gun/energy/laser/bluetag,
		/obj/item/clothing/suit/redtag,
		/obj/item/clothing/suit/redtag,
		/obj/item/clothing/suit/redtag,
		/obj/item/clothing/suit/bluetag,
		/obj/item/clothing/suit/bluetag,
		/obj/item/clothing/suit/bluetag,
		/obj/item/clothing/head/helmet/redtaghelm,
		/obj/item/clothing/head/helmet/redtaghelm,
		/obj/item/clothing/head/helmet/redtaghelm,
		/obj/item/clothing/head/helmet/bluetaghelm,
		/obj/item/clothing/head/helmet/bluetaghelm,
		/obj/item/clothing/head/helmet/bluetaghelm
	)
	crate_name = "laser tag crate"

/datum/supply_pack/misc/party
	name = "Party Equipment"
	desc = "Celebrate both life and death on the station with Priapus' Party Essentials(tm)! Contains seven colored glowsticks, six beers, six sodas, two ales, and a bottle of patron, goldschlager, and shaker!"
	cost = PAYCHECK_ASSISTANT * 4.8 + CARGO_CRATE_VALUE
	contains = list(/obj/item/storage/box/drinkingglasses,
					/obj/item/reagent_containers/cup/glass/shaker,
					/obj/item/reagent_containers/cup/glass/bottle/patron,
					/obj/item/reagent_containers/cup/glass/bottle/goldschlager,
					/obj/item/reagent_containers/cup/glass/bottle/ale,
					/obj/item/reagent_containers/cup/glass/bottle/ale,
					/obj/item/storage/cans/sixbeer,
					/obj/item/storage/cans/sixsoda,
					/obj/item/flashlight/glowstick,
					/obj/item/flashlight/glowstick/red,
					/obj/item/flashlight/glowstick/blue,
					/obj/item/flashlight/glowstick/cyan,
					/obj/item/flashlight/glowstick/orange,
					/obj/item/flashlight/glowstick/yellow,
					/obj/item/flashlight/glowstick/pink)
	crate_name = "party equipment crate"
