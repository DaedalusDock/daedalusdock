/* Backpacks
 * Contains:
 * Backpack
 * Backpack Types
 * Satchel Types
 */

/*
 * Backpack
 */

/obj/item/storage/backpack
	name = "backpack"
	desc = "You wear this on your back and put items into it."
	icon_state = "backpack"
	inhand_icon_state = "backpack"

	stamina_damage = 0
	stamina_cost = 0

	lefthand_file = 'icons/mob/inhands/equipment/backpack_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/backpack_righthand.dmi'
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK //ERROOOOO
	resistance_flags = NONE
	max_integrity = 300
	supports_variations_flags = CLOTHING_TESHARI_VARIATION | CLOTHING_VOX_VARIATION

	storage_type = /datum/storage/backpack

	equip_delay_self = EQUIP_DELAY_BACK
	equip_delay_other = EQUIP_DELAY_BACK * 1.5
	strip_delay = EQUIP_DELAY_BACK * 1.5

	var/zipper_open = FALSE

/obj/item/storage/backpack/Initialize()
	. = ..()
	atom_storage.max_slots = 21
	atom_storage.max_total_storage = 21

/obj/item/storage/backpack/examine(mob/user)
	. = ..()
	. += span_info("The zipper is [zipper_open ? "open" : "closed"].")

/obj/item/storage/backpack/get_controls_info()
	. = ..()
	. += "Control Click (while holding) - Toggle zipper."

/obj/item/storage/backpack/can_pickpocket(mob/living/user)
	var/mob/wearer = loc
	if(!ismob(wearer))
		return FALSE

	if(wearer.get_item_by_slot(ITEM_SLOT_BACK) != src)
		return FALSE

	if(!(REVERSE_DIR(wearer.dir) & get_dir(wearer, user)))
		return

	return wearer.IsReachableBy(user)

/obj/item/storage/backpack/CtrlClick(mob/user, list/params)
	. = ..()
	if(!.)
		return

	if(user != loc)
		return

	toggle_zipper(user)

/obj/item/storage/backpack/proc/toggle_zipper(mob/user)
	zipper_open = !zipper_open
	user?.changeNext_move(CLICK_CD_RAPID)
	user?.visible_message(span_notice("[user] [zipper_open ? "unzips" : "zips"] [user.p_their()] [name]."))

	if(zipper_open)
		ADD_TRAIT(src, TRAIT_INSTANT_PICKPOCKET, INNATE_TRAIT)
	else
		REMOVE_TRAIT(src, TRAIT_INSTANT_PICKPOCKET, INNATE_TRAIT)

/*
 * Backpack Types
 */

/obj/item/storage/backpack/old/Initialize()
	. = ..()
	atom_storage.max_total_storage = 12

/obj/item/bag_of_holding_inert
	name = "inert bag of holding"
	desc = "What is currently a just an unwieldly block of metal with a slot ready to accept a bluespace anomaly core."
	icon = 'icons/obj/storage.dmi'
	icon_state = "brokenpack"
	inhand_icon_state = "brokenpack"
	lefthand_file = 'icons/mob/inhands/equipment/backpack_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/backpack_righthand.dmi'
	w_class = WEIGHT_CLASS_BULKY
	resistance_flags = FIRE_PROOF
	item_flags = NO_MAT_REDEMPTION

TYPEINFO_DEF(/obj/item/storage/backpack/holding)
	default_armor = list(BLUNT = 0, PUNCTURE = 0, SLASH = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, FIRE = 60, ACID = 50)

/obj/item/storage/backpack/holding
	name = "bag of holding"
	desc = "A backpack that opens into a localized pocket of bluespace."
	icon_state = "holdingpack"
	inhand_icon_state = "holdingpack"
	resistance_flags = FIRE_PROOF
	item_flags = NO_MAT_REDEMPTION

/obj/item/storage/backpack/holding/Initialize()
	. = ..()

	create_storage(max_specific_storage = WEIGHT_CLASS_GIGANTIC, max_total_storage = 35, max_slots = 30, type = /datum/storage/bag_of_holding)
	atom_storage.allow_big_nesting = TRUE

/obj/item/storage/backpack/holding/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] is jumping into [src]! It looks like [user.p_theyre()] trying to commit suicide."))
	user.dropItemToGround(src, TRUE)
	user.Stun(100, ignore_canstun = TRUE)
	sleep(20)
	playsound(src, SFX_RUSTLE, 50, TRUE, -5)
	qdel(user)

/obj/item/storage/backpack/santabag
	name = "Santa's Gift Bag"
	desc = "Space Santa uses this to deliver presents to all the nice children in space in Christmas! Wow, it's pretty big!"
	icon_state = "giftbag0"
	inhand_icon_state = "giftbag"
	w_class = WEIGHT_CLASS_BULKY
	supports_variations_flags = NONE

/obj/item/storage/backpack/santabag/Initialize(mapload)
	. = ..()
	regenerate_presents()

/obj/item/storage/backpack/santabag/Initialize()
	. = ..()
	atom_storage.max_specific_storage = WEIGHT_CLASS_NORMAL
	atom_storage.max_total_storage = 60

/obj/item/storage/backpack/santabag/suicide_act(mob/user)
	user.visible_message(span_suicide("[user] places [src] over [user.p_their()] head and pulls it tight! It looks like [user.p_they()] [user.p_are()]n't in the Christmas spirit..."))
	return (OXYLOSS)

/obj/item/storage/backpack/santabag/proc/regenerate_presents()
	addtimer(CALLBACK(src, PROC_REF(regenerate_presents)), 30 SECONDS)

	var/mob/user = get(loc, /mob)
	if(!istype(user))
		return
	if(user.mind && HAS_TRAIT(user.mind, TRAIT_CANNOT_OPEN_PRESENTS))
		var/turf/floor = get_turf(src)
		var/obj/item/thing = new /obj/item/a_gift/anything(floor)
		if(!atom_storage.attempt_insert(thing, user, override = TRUE))
			qdel(thing)


/obj/item/storage/backpack/cultpack
	name = "trophy rack"
	desc = "It's useful for both carrying extra gear and proudly declaring your insanity."
	icon_state = "cultpack"
	inhand_icon_state = "backpack"

/obj/item/storage/backpack/clown
	name = "Giggles von Honkerton"
	desc = "It's a backpack made by Honk! Co."
	icon_state = "clownpack"
	inhand_icon_state = "clownpack"
	supports_variations_flags = NONE

/obj/item/storage/backpack/explorer
	name = "explorer bag"
	desc = "A robust backpack for stashing your loot."
	icon_state = "explorerpack"
	inhand_icon_state = "explorerpack"

/obj/item/storage/backpack/mime
	name = "Parcel Parceaux"
	desc = "A silent backpack made for those silent workers. Silence Co."
	icon_state = "mimepack"
	inhand_icon_state = "mimepack"
	supports_variations_flags = NONE

/obj/item/storage/backpack/medic
	name = "medical backpack"
	desc = "It's a backpack especially designed for use in a sterile environment."
	icon_state = "medicalpack"
	inhand_icon_state = "medicalpack"

/obj/item/storage/backpack/security
	name = "security backpack"
	desc = "It's a very robust backpack."
	icon_state = "securitypack"
	inhand_icon_state = "securitypack"

/obj/item/storage/backpack/captain
	name = "captain's backpack"
	desc = "It's a special backpack made exclusively for Daedalus Industries officers."
	icon_state = "captainpack"
	inhand_icon_state = "captainpack"

/obj/item/storage/backpack/industrial
	name = "industrial backpack"
	desc = "It's a tough backpack for the daily grind of station life."
	icon_state = "engiepack"
	inhand_icon_state = "engiepack"
	resistance_flags = FIRE_PROOF

/obj/item/storage/backpack/botany
	name = "botany backpack"
	desc = "It's a backpack made of all-natural fibers."
	icon_state = "botpack"
	inhand_icon_state = "botpack"
	supports_variations_flags = NONE

/obj/item/storage/backpack/chemistry
	name = "chemistry backpack"
	desc = "A backpack specially designed to repel stains and hazardous liquids."
	icon_state = "chempack"
	inhand_icon_state = "chempack"

/obj/item/storage/backpack/genetics
	name = "genetics backpack"
	desc = "A bag designed to be super tough, just in case someone hulks out on you."
	icon_state = "genepack"
	inhand_icon_state = "genepack"
	supports_variations_flags = NONE

/obj/item/storage/backpack/science
	name = "science backpack"
	desc = "A specially designed backpack. It's fire resistant and smells vaguely of plasma."
	icon_state = "scipack"
	inhand_icon_state = "scipack"
	supports_variations_flags = NONE

/obj/item/storage/backpack/virology
	name = "virology backpack"
	desc = "A backpack made of hypo-allergenic fibers. It's designed to help prevent the spread of disease. Smells like monkey."
	icon_state = "viropack"
	inhand_icon_state = "viropack"
	supports_variations_flags = NONE

/obj/item/storage/backpack/ert
	name = "emergency response team commander backpack"
	desc = "A spacious backpack with lots of pockets, worn by the Commander of an Emergency Response Team."
	icon_state = "ert_commander"
	inhand_icon_state = "securitypack"
	resistance_flags = FIRE_PROOF
	supports_variations_flags = NONE

/obj/item/storage/backpack/ert/security
	name = "emergency response team security backpack"
	desc = "A spacious backpack with lots of pockets, worn by Security Officers of an Emergency Response Team."
	icon_state = "ert_security"
	supports_variations_flags = NONE

/obj/item/storage/backpack/ert/medical
	name = "emergency response team medical backpack"
	desc = "A spacious backpack with lots of pockets, worn by Medical Officers of an Emergency Response Team."
	icon_state = "ert_medical"
	supports_variations_flags = NONE

/obj/item/storage/backpack/ert/engineer
	name = "emergency response team engineer backpack"
	desc = "A spacious backpack with lots of pockets, worn by Engineers of an Emergency Response Team."
	icon_state = "ert_engineering"
	supports_variations_flags = NONE

/obj/item/storage/backpack/ert/janitor
	name = "emergency response team janitor backpack"
	desc = "A spacious backpack with lots of pockets, worn by Janitors of an Emergency Response Team."
	icon_state = "ert_janitor"
	supports_variations_flags = NONE

/obj/item/storage/backpack/ert/clown
	name = "emergency response team clown backpack"
	desc = "A spacious backpack with lots of pockets, worn by Clowns of an Emergency Response Team."
	icon_state = "ert_clown"
	supports_variations_flags = NONE
/*
 * Satchel Types
 */

/obj/item/storage/backpack/satchel
	name = "satchel"
	desc = "A trendy looking satchel."
	icon_state = "satchel-norm"
	inhand_icon_state = "satchel-norm"

/obj/item/storage/backpack/satchel/leather
	name = "leather satchel"
	desc = "It's a very fancy satchel made with fine leather."
	icon_state = "satchel"
	inhand_icon_state = "satchel"

/obj/item/storage/backpack/satchel/leather/withwallet/PopulateContents()
	new /obj/item/storage/wallet/random(src)

/obj/item/storage/backpack/satchel/fireproof
	resistance_flags = FIRE_PROOF

/obj/item/storage/backpack/satchel/eng
	name = "industrial satchel"
	desc = "A tough satchel with extra pockets."
	icon_state = "satchel-eng"
	inhand_icon_state = "satchel-eng"
	resistance_flags = FIRE_PROOF

/obj/item/storage/backpack/satchel/med
	name = "medical satchel"
	desc = "A sterile satchel used in medical departments."
	icon_state = "satchel-med"
	inhand_icon_state = "satchel-med"

/obj/item/storage/backpack/satchel/vir
	name = "virologist satchel"
	desc = "A sterile satchel with virologist colours."
	icon_state = "satchel-vir"
	inhand_icon_state = "satchel-vir"
	supports_variations_flags = NONE

/obj/item/storage/backpack/satchel/chem
	name = "chemist satchel"
	desc = "A sterile satchel with chemist colours."
	icon_state = "satchel-chem"
	inhand_icon_state = "satchel-chem"
	supports_variations_flags = NONE

/obj/item/storage/backpack/satchel/gen
	name = "geneticist satchel"
	desc = "A sterile satchel with geneticist colours."
	icon_state = "satchel-gen"
	inhand_icon_state = "satchel-gen"
	supports_variations_flags = NONE

/obj/item/storage/backpack/satchel/science
	name = "scientist satchel"
	desc = "Useful for holding research materials."
	icon_state = "satchel-sci"
	inhand_icon_state = "satchel-sci"

/obj/item/storage/backpack/satchel/hyd
	name = "botanist satchel"
	desc = "A satchel made of all natural fibers."
	icon_state = "satchel-hyd"
	inhand_icon_state = "satchel-hyd"
	supports_variations_flags = NONE

/obj/item/storage/backpack/satchel/sec
	name = "security satchel"
	desc = "A robust satchel for security related needs."
	icon_state = "satchel-sec"
	inhand_icon_state = "satchel-sec"

/obj/item/storage/backpack/satchel/explorer
	name = "explorer satchel"
	desc = "A robust satchel for stashing your loot."
	icon_state = "satchel-explorer"
	inhand_icon_state = "satchel-explorer"

/obj/item/storage/backpack/satchel/cap
	name = "captain's satchel"
	desc = "An exclusive satchel for Daedalus Industries officers."
	icon_state = "satchel-cap"
	inhand_icon_state = "satchel-cap"

/obj/item/storage/backpack/satchel/flat
	name = "smuggler's satchel"
	desc = "A very slim satchel that can easily fit into tight spaces."
	icon_state = "satchel-flat"
	inhand_icon_state = "satchel-flat"
	w_class = WEIGHT_CLASS_NORMAL //Can fit in backpacks itself.
	supports_variations_flags = NONE

/obj/item/storage/backpack/satchel/flat/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/undertile, TRAIT_T_RAY_VISIBLE, INVISIBILITY_OBSERVER, use_anchor = TRUE)
	atom_storage.max_total_storage = 15
	atom_storage.set_holdable(cant_hold_list = list(/obj/item/storage/backpack/satchel/flat)) //muh recursive backpacks)

/obj/item/storage/backpack/satchel/flat/PopulateContents()
	var/datum/supply_pack/costumes_toys/randomised/contraband/C = new
	for(var/i in 1 to 2)
		var/ctype = pick(C.contains)
		new ctype(src)

	qdel(C)

/obj/item/storage/backpack/satchel/flat/with_tools/PopulateContents()
	new /obj/item/stack/tile/iron/base(src)
	new /obj/item/crowbar(src)

	..()

/obj/item/storage/backpack/satchel/flat/empty/PopulateContents()
	return

/obj/item/storage/backpack/duffelbag
	name = "duffel bag"
	desc = "A large duffel bag for holding extra things."
	icon_state = "duffel"
	inhand_icon_state = "duffel"
	slowdown = 1

/obj/item/storage/backpack/duffelbag/Initialize()
	. = ..()
	atom_storage.max_total_storage = 30

/obj/item/storage/backpack/duffelbag/cursed
	name = "living duffel bag"
	desc = "A cursed clown duffel bag that hungers for food of any kind.\n A warning label suggests that it eats food inside. If that food happens to be a horribly ruined, burned mess the chef scrapped out of the microwave, then it might have negative effects on the bag..."
	icon_state = "duffel-curse"
	inhand_icon_state = "duffel-curse"
	slowdown = 2
	item_flags = DROPDEL
	max_integrity = 100
	///counts time passed since it ate food
	var/hunger = 0
	supports_variations_flags = NONE

/obj/item/storage/backpack/duffelbag/cursed/Initialize(mapload)
	. = ..()
	var/add_dropdel = TRUE //clarified boolean
	AddComponent(/datum/component/curse_of_hunger, add_dropdel)

/obj/item/storage/backpack/duffelbag/captain
	name = "captain's duffel bag"
	desc = "A large duffel bag for holding extra captainly goods."
	icon_state = "duffel-captain"
	inhand_icon_state = "duffel-captain"
	supports_variations_flags = NONE

/obj/item/storage/backpack/duffelbag/med
	name = "medical duffel bag"
	desc = "A large duffel bag for holding extra medical supplies."
	icon_state = "duffel-med"
	inhand_icon_state = "duffel-med"
	supports_variations_flags = NONE

/obj/item/storage/backpack/duffelbag/med/surgery
	name = "surgical duffel bag"
	desc = "A large duffel bag for holding extra medical supplies - this one seems to be designed for holding surgical tools."

/obj/item/storage/backpack/duffelbag/explorer
	name = "explorator's duffel bag"
	desc = "A large duffel bag for holding extra exotic treasures."
	icon_state = "duffel-explorer"
	inhand_icon_state = "duffel-explorer"
	supports_variations_flags = NONE

/obj/item/storage/backpack/duffelbag/hydroponics
	name = "hydroponic's duffel bag"
	desc = "A large duffel bag for holding extra gardening tools."
	icon_state = "duffel-hydroponics"
	inhand_icon_state = "duffel-hydroponics"
	supports_variations_flags = NONE

/obj/item/storage/backpack/duffelbag/chemistry
	name = "chemistry duffel bag"
	desc = "A large duffel bag for holding extra chemical substances."
	icon_state = "duffel-chemistry"
	inhand_icon_state = "duffel-chemistry"
	supports_variations_flags = NONE

/obj/item/storage/backpack/duffelbag/genetics
	name = "geneticist's duffel bag"
	desc = "A large duffel bag for holding extra genetic mutations."
	icon_state = "duffel-genetics"
	inhand_icon_state = "duffel-genetics"
	supports_variations_flags = NONE

/obj/item/storage/backpack/duffelbag/science
	name = "scientist's duffel bag"
	desc = "A large duffel bag for holding extra scientific components."
	icon_state = "duffel-sci"
	inhand_icon_state = "duffel-sci"
	supports_variations_flags = NONE

/obj/item/storage/backpack/duffelbag/virology
	name = "virologist's duffel bag"
	desc = "A large duffel bag for holding extra viral bottles."
	icon_state = "duffel-virology"
	inhand_icon_state = "duffel-virology"
	supports_variations_flags = NONE



/obj/item/storage/backpack/duffelbag/med/surgery/PopulateContents()
	new /obj/item/scalpel(src)
	new /obj/item/hemostat(src)
	new /obj/item/retractor(src)
	new /obj/item/circular_saw(src)
	new /obj/item/surgicaldrill(src)
	new /obj/item/cautery(src)
	new /obj/item/bonesetter(src)
	new /obj/item/clothing/mask/surgical(src)
	new /obj/item/razor(src)
	new /obj/item/blood_filter(src)
	new /obj/item/fixovein(src)

/obj/item/storage/backpack/duffelbag/sec
	name = "security duffel bag"
	desc = "A large duffel bag for holding extra security supplies and ammunition."
	icon_state = "duffel-sec"
	inhand_icon_state = "duffel-sec"
	supports_variations_flags = NONE

/obj/item/storage/backpack/duffelbag/sec/surgery
	name = "surgical duffel bag"
	desc = "A large duffel bag for holding extra supplies - this one has a material inlay with space for various sharp-looking tools."

/obj/item/storage/backpack/duffelbag/sec/surgery/PopulateContents()
	new /obj/item/scalpel(src)
	new /obj/item/hemostat(src)
	new /obj/item/retractor(src)
	new /obj/item/circular_saw(src)
	new /obj/item/bonesetter(src)
	new /obj/item/surgicaldrill(src)
	new /obj/item/cautery(src)
	new /obj/item/clothing/mask/surgical(src)
	new /obj/item/blood_filter(src)
	new /obj/item/fixovein(src)

/obj/item/storage/backpack/duffelbag/engineering
	name = "industrial duffel bag"
	desc = "A large duffel bag for holding extra tools and supplies."
	icon_state = "duffel-eng"
	inhand_icon_state = "duffel-eng"
	resistance_flags = FIRE_PROOF
	supports_variations_flags = NONE

/obj/item/storage/backpack/duffelbag/drone
	name = "drone duffel bag"
	desc = "A large duffel bag for holding tools and hats."
	icon_state = "duffel-drone"
	inhand_icon_state = "duffel-drone"
	resistance_flags = FIRE_PROOF
	supports_variations_flags = NONE

/obj/item/storage/backpack/duffelbag/drone/PopulateContents()
	new /obj/item/screwdriver(src)
	new /obj/item/wrench(src)
	new /obj/item/weldingtool(src)
	new /obj/item/crowbar(src)
	new /obj/item/stack/cable_coil(src)
	new /obj/item/wirecutters(src)
	new /obj/item/multitool(src)

/obj/item/storage/backpack/duffelbag/clown
	name = "clown's duffel bag"
	desc = "A large duffel bag for holding lots of funny gags!"
	icon_state = "duffel-clown"
	inhand_icon_state = "duffel-clown"
	supports_variations_flags = NONE

/obj/item/storage/backpack/duffelbag/clown/cream_pie/PopulateContents()
	for(var/i in 1 to 10)
		new /obj/item/food/pie/cream(src)

/obj/item/storage/backpack/fireproof
	resistance_flags = FIRE_PROOF

/obj/item/storage/backpack/duffelbag/syndie
	name = "suspicious looking duffel bag"
	desc = "A large duffel bag for holding extra tactical supplies."
	icon_state = "duffel-syndie"
	inhand_icon_state = "duffel-syndieammo"
	slowdown = 0
	resistance_flags = FIRE_PROOF
	supports_variations_flags = NONE

/obj/item/storage/backpack/duffelbag/syndie/Initialize()
	. = ..()
	atom_storage.silent = TRUE

/obj/item/storage/backpack/duffelbag/syndie/hitman
	desc = "A large duffel bag for holding extra things. There is a Nanotrasen logo on the back."
	icon_state = "duffel-syndieammo"
	inhand_icon_state = "duffel-syndieammo"

/obj/item/storage/backpack/duffelbag/syndie/hitman/PopulateContents()
	new /obj/item/clothing/under/suit/black(src)
	new /obj/item/clothing/accessory/waistcoat(src)
	new /obj/item/clothing/suit/toggle/lawyer/black(src)
	new /obj/item/clothing/shoes/laceup(src)
	new /obj/item/clothing/gloves/color/black(src)
	new /obj/item/clothing/glasses/sunglasses(src)
	new /obj/item/clothing/head/fedora(src)

/obj/item/storage/backpack/duffelbag/syndie/med
	name = "medical duffel bag"
	desc = "A large duffel bag for holding extra tactical medical supplies."
	icon_state = "duffel-syndiemed"
	inhand_icon_state = "duffel-syndiemed"

/obj/item/storage/backpack/duffelbag/syndie/surgery
	name = "surgery duffel bag"
	desc = "A suspicious looking duffel bag for holding surgery tools."
	icon_state = "duffel-syndiemed"
	inhand_icon_state = "duffel-syndiemed"

/obj/item/storage/backpack/duffelbag/syndie/surgery/PopulateContents()
	new /obj/item/scalpel(src)
	new /obj/item/hemostat(src)
	new /obj/item/retractor(src)
	new /obj/item/circular_saw(src)
	new /obj/item/bonesetter(src)
	new /obj/item/surgicaldrill(src)
	new /obj/item/cautery(src)
	new /obj/item/clothing/suit/straight_jacket(src)
	new /obj/item/clothing/mask/muzzle(src)
	new /obj/item/mmi/syndie(src)
	new /obj/item/blood_filter(src)
	new /obj/item/stack/medical/bone_gel(src)
	new /obj/item/healthanalyzer/advanced(src)
	new /obj/item/fixovein(src)

/obj/item/storage/backpack/duffelbag/syndie/ammo
	name = "ammunition duffel bag"
	desc = "A large duffel bag for holding extra weapons ammunition and supplies."
	icon_state = "duffel-syndieammo"
	inhand_icon_state = "duffel-syndieammo"

/obj/item/storage/backpack/duffelbag/syndie/ammo/shotgun
	desc = "A large duffel bag, packed to the brim with Bulldog shotgun magazines."

/obj/item/storage/backpack/duffelbag/syndie/ammo/shotgun/PopulateContents()
	for(var/i in 1 to 6)
		new /obj/item/ammo_box/magazine/m12g(src)
	new /obj/item/ammo_box/magazine/m12g/slug(src)
	new /obj/item/ammo_box/magazine/m12g/slug(src)
	new /obj/item/ammo_box/magazine/m12g/dragon(src)

/obj/item/storage/backpack/duffelbag/syndie/ammo/smg
	desc = "A large duffel bag, packed to the brim with C-20r magazines."

/obj/item/storage/backpack/duffelbag/syndie/ammo/smg/PopulateContents()
	for(var/i in 1 to 9)
		new /obj/item/ammo_box/magazine/smgm45(src)

/obj/item/storage/backpack/duffelbag/syndie/ammo/mech
	desc = "A large duffel bag, packed to the brim with various exosuit ammo."

/obj/item/storage/backpack/duffelbag/syndie/ammo/mech/PopulateContents()
	new /obj/item/mecha_ammo/scattershot(src)
	new /obj/item/mecha_ammo/scattershot(src)
	new /obj/item/mecha_ammo/scattershot(src)
	new /obj/item/mecha_ammo/scattershot(src)
	new /obj/item/storage/belt/utility/syndicate(src)

/obj/item/storage/backpack/duffelbag/syndie/ammo/mauler
	desc = "A large duffel bag, packed to the brim with various exosuit ammo."

/obj/item/storage/backpack/duffelbag/syndie/ammo/mauler/PopulateContents()
	new /obj/item/mecha_ammo/lmg(src)
	new /obj/item/mecha_ammo/lmg(src)
	new /obj/item/mecha_ammo/lmg(src)
	new /obj/item/mecha_ammo/scattershot(src)
	new /obj/item/mecha_ammo/scattershot(src)
	new /obj/item/mecha_ammo/scattershot(src)
	new /obj/item/mecha_ammo/missiles_he(src)
	new /obj/item/mecha_ammo/missiles_he(src)
	new /obj/item/mecha_ammo/missiles_he(src)

/obj/item/storage/backpack/duffelbag/syndie/c20rbundle
	desc = "A large duffel bag containing a C-20r, some magazines, and a cheap looking suppressor."

/obj/item/storage/backpack/duffelbag/syndie/c20rbundle/PopulateContents()
	new /obj/item/ammo_box/magazine/smgm45(src)
	new /obj/item/ammo_box/magazine/smgm45(src)
	new /obj/item/gun/ballistic/automatic/c20r(src)
	new /obj/item/suppressor/specialoffer(src)

/obj/item/storage/backpack/duffelbag/syndie/bulldogbundle
	desc = "A large duffel bag containing a Bulldog, some drums, and a pair of thermal imaging glasses."

/obj/item/storage/backpack/duffelbag/syndie/bulldogbundle/PopulateContents()
	new /obj/item/gun/ballistic/shotgun/bulldog(src)
	new /obj/item/ammo_box/magazine/m12g(src)
	new /obj/item/ammo_box/magazine/m12g(src)
	new /obj/item/clothing/glasses/thermal/syndi(src)

/obj/item/storage/backpack/duffelbag/syndie/med/medicalbundle
	desc = "A large duffel bag containing a medical equipment, and a knock-off pair of magboots."

/obj/item/storage/backpack/duffelbag/syndie/med/medicalbundle/PopulateContents()
	new /obj/item/clothing/shoes/magboots/syndie(src)
	new /obj/item/storage/medkit/tactical(src)

/obj/item/storage/backpack/duffelbag/syndie/med/bioterrorbundle
	desc = "A large duffel bag containing deadly chemicals, a handheld chem sprayer, Bioterror foam grenade, and a box of syringes."

/obj/item/storage/backpack/duffelbag/syndie/med/bioterrorbundle/PopulateContents()
	new /obj/item/reagent_containers/spray/chemsprayer/bioterror(src)
	new /obj/item/storage/box/syndie_kit/chemical(src)
	new /obj/item/gun/syringe/syndicate(src)
	new /obj/item/storage/box/syringes(src)
	new /obj/item/grenade/chem_grenade/bioterrorfoam(src)
	if(prob(5))
		new /obj/item/food/pizza/pineapple(src)

/obj/item/storage/backpack/duffelbag/syndie/c4/PopulateContents()
	for(var/i in 1 to 4)
		new /obj/item/grenade/c4(src)

/obj/item/storage/backpack/duffelbag/syndie/x4/PopulateContents()
	for(var/i in 1 to 3)
		new /obj/item/grenade/c4/x4(src)

/obj/item/storage/backpack/duffelbag/syndie/firestarter
	desc = "A large duffel bag containing a New Russian pyro backpack sprayer, Elite MODsuit, a Stechkin APS pistol, minibomb, ammo, and other equipment."

/obj/item/storage/backpack/duffelbag/syndie/firestarter/PopulateContents()
	new /obj/item/clothing/under/syndicate/soviet(src)
	new /obj/item/mod/control/pre_equipped/elite/flamethrower(src)
	new /obj/item/gun/ballistic/automatic/pistol/aps(src)
	new /obj/item/ammo_box/magazine/m9mm_aps/fire(src)
	new /obj/item/ammo_box/magazine/m9mm_aps/fire(src)
	new /obj/item/reagent_containers/cup/glass/bottle/vodka/badminka(src)
	new /obj/item/reagent_containers/hypospray/medipen/stimulants(src)
	new /obj/item/grenade/syndieminibomb(src)

// For ClownOps.
/obj/item/storage/backpack/duffelbag/clown/syndie/Initialize()
	. = ..()
	slowdown = 0
	atom_storage.silent = TRUE

/obj/item/storage/backpack/duffelbag/clown/syndie/PopulateContents()
	new /obj/item/modular_computer/tablet/pda/clown(src)
	new /obj/item/clothing/under/rank/civilian/clown(src)
	new /obj/item/clothing/shoes/clown_shoes(src)
	new /obj/item/clothing/mask/gas/clown_hat(src)
	new /obj/item/bikehorn(src)
	new /obj/item/implanter/sad_trombone(src)

/obj/item/storage/backpack/henchmen
	name = "wings"
	desc = "Granted to the henchmen who deserve it. This probably doesn't include you."
	icon_state = "henchmen"
	inhand_icon_state = "henchmen"
	supports_variations_flags = NONE

/obj/item/storage/backpack/duffelbag/cops
	name = "police bag"
	desc = "A large duffel bag for holding extra police gear."
	slowdown = 0
	supports_variations_flags = NONE

