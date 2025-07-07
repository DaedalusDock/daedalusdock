/*****************************Money bag********************************/

/obj/item/storage/bag/money
	name = "money bag"
	icon_state = "moneybag"
	force = 10
	throwforce = 0
	resistance_flags = FLAMMABLE
	max_integrity = 100
	w_class = WEIGHT_CLASS_BULKY
	storage_type = /datum/storage/money_bag

/datum/storage/money_bag
	max_specific_storage = WEIGHT_CLASS_NORMAL
	max_slots = 40
	max_total_storage = 40
	can_hold = typecacheof(list(/obj/item/coin, /obj/item/stack/spacecash))

/obj/item/storage/bag/money/vault/PopulateContents()
	new /obj/item/coin/silver(src)
	new /obj/item/coin/silver(src)
	new /obj/item/coin/silver(src)
	new /obj/item/coin/silver(src)
	new /obj/item/coin/gold(src)
	new /obj/item/coin/gold(src)

/obj/item/storage/bag/money/c5000/PopulateContents()
	for(var/i = 0, i < 5, i++)
		new /obj/item/stack/spacecash/c1000(src)

/obj/item/storage/bag/money/small
	name = "money stash"
	icon_state = "moneypouch"
	force = 10
	throwforce = 0
	resistance_flags = FLAMMABLE
	max_integrity = 100
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_ID
	storage_type = /datum/storage/money_bag/small

/obj/item/storage/bag/money/small
	. = ..()
	max_specific_storage = WEIGHT_CLASS_NORMAL
	max_slots = 20
	can_hold = typecacheof(list(/obj/item/coin, /obj/item/stack/spacecash, /obj/item/stack/f13Cash))

// Legion reserves. Spawns with the Centurion.
/obj/item/storage/bag/money/small/legion/PopulateContents()
	// ~450ish worth of legion money
	new /obj/item/stack/f13Cash/random/denarius/high(src)
	new /obj/item/stack/f13Cash/random/denarius/med(src)
	new /obj/item/stack/f13Cash/random/aureus/high(src)

// Legion enlisted. Spawns with the Legionnaires. Average 12 caps.
/obj/item/storage/bag/money/small/legenlisted/PopulateContents()
	new /obj/item/stack/f13Cash/random/denarius/low(src)

// Legion officers. Spawns with the Decanii. Average 175 caps.
/obj/item/storage/bag/money/small/legofficers/PopulateContents()
	new /obj/item/stack/f13Cash/random/denarius/med(src)
	new /obj/item/stack/f13Cash/random/aureus/low(src)

// NCR reserves. Spawns with the Captain.
/obj/item/storage/bag/money/small/ncr/PopulateContents()
	// ~450 worth of ncr money
	new /obj/item/stack/f13Cash/random/ncr/high(src)
	new /obj/item/stack/f13Cash/random/ncr/med(src)
	new /obj/item/stack/f13Cash/random/ncr/med(src)

// NCR enlisted. Spawns with the non officers.
/obj/item/storage/bag/money/small/ncrenlisted/PopulateContents()
	// ~12 worth of ncr money
	new /obj/item/stack/f13Cash/random/ncr/low(src)

// NCR officers. Spawns with the officers and Rangers.
/obj/item/storage/bag/money/small/ncrofficers/PopulateContents()
	// ~75 worth of ncr money
	new /obj/item/stack/f13Cash/random/ncr/med(src)

// Den reserves. Spawns with the Sheriff.
/obj/item/storage/bag/money/small/den/PopulateContents()
	// ~225 worth of assorted money
	new /obj/item/stack/f13Cash/random/med(src)
	new /obj/item/stack/f13Cash/random/denarius/med(src)
	new /obj/item/stack/f13Cash/random/ncr/med(src)

// Oasis reserves. Spawns with the Mayor.
/obj/item/storage/bag/money/small/oasis/PopulateContents()
	// ~445 worth of assorted money
	new /obj/item/stack/f13Cash/random/high(src)
	new /obj/item/stack/f13Cash/random/denarius/med(src)
	new /obj/item/stack/f13Cash/random/ncr/med(src)

// Standard Wastelander money bag. They have more but are liable to get robbed for it.
/obj/item/storage/bag/money/small/wastelander/PopulateContents()
	// ~48 worth of assorted money
	new /obj/item/stack/f13Cash/random/low(src)
	new /obj/item/stack/f13Cash/random/low(src)
	new /obj/item/stack/f13Cash/random/denarius/low(src)
	new /obj/item/stack/f13Cash/random/ncr/low(src)

// Standard Great Khan money bag. They have a little more caps than common raiders. Average 75.
/obj/item/storage/bag/money/small/khan/PopulateContents()
	new /obj/item/stack/f13Cash/random/med(src)

// Standard Settler money bag. They are pretty wealthy, with NCR bucks and caps, no Legion money.
/obj/item/storage/bag/money/small/settler/PopulateContents()
	// ~162 worth of non legion money
	new /obj/item/stack/f13Cash/random/med(src)
	new /obj/item/stack/f13Cash/random/med(src)
	new /obj/item/stack/f13Cash/random/ncr/low(src)

// Standard Banker money bag. They are insanely wealthy, Caps only and only for RP purposes.
/obj/item/storage/bag/money/small/banker/PopulateContents()
	// ~162 worth of non legion money
	new /obj/item/stack/f13Cash/random/banker(src)

// Standard Raider money bag. They blew it all on chems and armor mods.
/obj/item/storage/bag/money/small/raider/PopulateContents()
	// ~12 worth of caps
	new /obj/item/stack/f13Cash/random/low(src)

/obj/item/storage/bag/money/small/raider/mobboss/PopulateContents()
	new /obj/item/stack/f13Cash/random/high(src)
	//mob boss, reasonably wealthy
