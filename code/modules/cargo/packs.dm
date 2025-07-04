/datum/supply_pack
	var/name = "Crate"
	var/group = ""

	// See cargo.dm
	var/supply_flags = NONE

	/// Cost of the crate. DO NOT GO ANY LOWER THAN X1.4 the "CARGO_CRATE_VALUE" value if using regular crates, or infinite profit will be possible!
	var/cost = CARGO_CRATE_VALUE * 1.4
	var/access = FALSE
	var/access_view = FALSE
	var/access_any = FALSE

	var/list/contains = null
	var/crate_name = "crate"
	var/id
	var/desc = ""//no desc by default
	var/crate_type = /obj/structure/closet/crate

	/// If TRUE, can spawn with missing contents due to MANIFEST_ERROR_ITEM occuring.
	var/can_be_missing_contents = TRUE
	var/dangerous = FALSE // Should we message admins?
	var/special = FALSE //Event/Station Goals/Admin enabled packs
	var/special_enabled = FALSE

	var/special_pod //If this pack comes shipped in a specific pod when launched from the express console
	var/admin_spawned = FALSE

	var/goody = FALSE //Goodies can only be purchased by private accounts and can have coupons apply to them. They also come in a lockbox instead of a full crate, so the 700 min doesn't apply

/datum/supply_pack/New()
	id = type

/datum/supply_pack/proc/generate(atom/A, datum/bank_account/paying_account)
	var/obj/structure/closet/crate/C
	if(paying_account)
		C = new /obj/structure/closet/crate/secure/owned(A, paying_account)
		C.name = "[crate_name] - Purchased by [paying_account.account_holder]"
	else
		C = new crate_type(A)
		C.name = crate_name
	if(access)
		C.req_access = list(access)
	if(access_any)
		C.req_one_access = access_any

	fill(C)
	return C

/datum/supply_pack/proc/get_cost()
	. = cost
	. *= SSeconomy.pack_price_modifier
	return floor(.)

/datum/supply_pack/proc/fill(obj/structure/closet/crate/C)
	if (admin_spawned)
		for(var/item in contains)
			var/atom/A = new item(C)
			A.flags_1 |= ADMIN_SPAWNED_1
	else
		for(var/item in contains)
			new item(C)

/// For generating supply packs at runtime. Returns a list of supply packs to use instead of this one.
/datum/supply_pack/proc/generate_supply_packs()
	return

// If you add something to this list, please group it by type and sort it alphabetically instead of just jamming it in like an animal

//////////////////////////////////////////////////////////////////////////////
//////////////////////////// Emergency ///////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/emergency
	group = "Emergency"

/datum/supply_pack/emergency/vehicle
	name = "Biker Gang Kit" //TUNNEL SNAKES OWN THIS TOWN
	desc = "TUNNEL SNAKES OWN THIS TOWN. Contains an unbranded All Terrain Vehicle, and a complete gang outfit -- consists of black gloves, a menacing skull bandanna, and a SWEET leather overcoat!"
	cost = CARGO_CRATE_VALUE * 4
	supply_flags = SUPPLY_PACK_CONTRABAND
	contains = list(/obj/vehicle/ridden/atv,
					/obj/item/key/atv,
					/obj/item/clothing/suit/jacket/leather/overcoat,
					/obj/item/clothing/gloves/color/black,
					/obj/item/clothing/head/soft,
					/obj/item/clothing/mask/bandana/skull/black)//so you can properly #cargoniabikergang
	crate_name = "biker kit"
	crate_type = /obj/structure/closet/crate/large

/datum/supply_pack/emergency/bio
	name = "Biological Emergency Crate"
	desc = "This crate holds 2 full bio suits which will protect you from viruses."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/clothing/head/bio_hood,
					/obj/item/clothing/head/bio_hood,
					/obj/item/clothing/suit/bio_suit,
					/obj/item/clothing/suit/bio_suit,
					/obj/item/storage/bag/bio,
					/obj/item/reagent_containers/syringe/antiviral,
					/obj/item/reagent_containers/syringe/antiviral,
					/obj/item/clothing/gloves/color/latex/nitrile,
					/obj/item/clothing/gloves/color/latex/nitrile)
	crate_name = "bio suit crate"

/datum/supply_pack/emergency/equipment
	name = "Emergency Bot/Internals Crate"
	desc = "Explosions got you down? These supplies are guaranteed to patch up holes, in stations and people alike! Comes with two floorbots, two medbots, five oxygen masks and five small oxygen tanks."
	cost = CARGO_CRATE_VALUE * 4
	contains = list(/mob/living/simple_animal/bot/floorbot,
					/mob/living/simple_animal/bot/floorbot,
					/mob/living/simple_animal/bot/medbot,
					/mob/living/simple_animal/bot/medbot,
					/obj/item/tank/internals/emergency_oxygen,
					/obj/item/tank/internals/emergency_oxygen,
					/obj/item/tank/internals/emergency_oxygen,
					/obj/item/tank/internals/emergency_oxygen,
					/obj/item/tank/internals/emergency_oxygen,
					/obj/item/clothing/mask/breath,
					/obj/item/clothing/mask/breath,
					/obj/item/clothing/mask/breath,
					/obj/item/clothing/mask/breath,
					/obj/item/clothing/mask/breath)
	crate_name = "emergency crate"
	crate_type = /obj/structure/closet/crate/internals

/datum/supply_pack/emergency/bomb
	name = "Explosive Emergency Crate"
	desc = "Science gone bonkers? Beeping behind the airlock? Buy now and be the hero the station des... I mean needs! (time not included)"
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/clothing/head/bomb_hood,
					/obj/item/clothing/suit/bomb_suit,
					/obj/item/clothing/mask/gas,
					/obj/item/screwdriver,
					/obj/item/wirecutters,
					/obj/item/multitool)
	crate_name = "bomb suit crate"

/datum/supply_pack/emergency/firefighting
	name = "Firefighting Crate"
	desc = "Only you can prevent station fires. Partner up with two firefighter suits, gas masks, flashlights, large oxygen tanks, extinguishers, and hardhats!"
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/clothing/suit/fire/firefighter,
					/obj/item/clothing/suit/fire/firefighter,
					/obj/item/extinguisher/mini,
					/obj/item/extinguisher/mini,
					/obj/item/clothing/mask/gas,
					/obj/item/clothing/mask/gas,
					/obj/item/flashlight,
					/obj/item/flashlight,
					/obj/item/tank/internals/oxygen/red,
					/obj/item/tank/internals/oxygen/red,
					/obj/item/extinguisher/advanced,
					/obj/item/extinguisher/advanced,
					/obj/item/clothing/head/hardhat/red,
					/obj/item/clothing/head/hardhat/red)
	crate_name = "firefighting crate"

/datum/supply_pack/emergency/atmostank
	name = "Firefighting Tank Backpack"
	desc = "Mow down fires with this high-capacity fire fighting tank backpack. Requires Atmospherics access to open."
	cost = CARGO_CRATE_VALUE * 1.8
	access = ACCESS_ATMOSPHERICS
	contains = list(/obj/item/watertank/atmos)
	crate_name = "firefighting backpack crate"
	crate_type = /obj/structure/closet/crate/secure

/datum/supply_pack/emergency/internals
	name = "Internals Crate"
	desc = "Master your life energy and control your breathing with three breath masks, three emergency oxygen tanks and three large air tanks."//IS THAT A
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/clothing/mask/gas,
					/obj/item/clothing/mask/gas,
					/obj/item/clothing/mask/gas,
					/obj/item/clothing/mask/breath,
					/obj/item/clothing/mask/breath,
					/obj/item/clothing/mask/breath,
					/obj/item/tank/internals/emergency_oxygen,
					/obj/item/tank/internals/emergency_oxygen,
					/obj/item/tank/internals/emergency_oxygen,
					/obj/item/tank/internals/oxygen,
					/obj/item/tank/internals/oxygen,
					/obj/item/tank/internals/oxygen)
	crate_name = "internals crate"
	crate_type = /obj/structure/closet/crate/internals

/datum/supply_pack/emergency/metalfoam
	name = "Metal Foam Grenade Crate"
	desc = "Seal up those pesky hull breaches with 7 Metal Foam Grenades."
	cost = CARGO_CRATE_VALUE * 2.4
	contains = list(/obj/item/storage/box/metalfoam)
	crate_name = "metal foam grenade crate"

/datum/supply_pack/emergency/radiation
	name = "Radiation Protection Crate"
	desc = "Survive the Nuclear Apocalypse and Supermatter Engine alike with two sets of Radiation suits. Each set contains a helmet, suit, and Geiger counter. We'll even throw in a bottle of vodka and some glasses too, considering the life-expectancy of people who order this."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/clothing/head/radiation,
					/obj/item/clothing/head/radiation,
					/obj/item/clothing/suit/radiation,
					/obj/item/clothing/suit/radiation,
					/obj/item/geiger_counter,
					/obj/item/geiger_counter,
					/obj/item/reagent_containers/cup/glass/bottle/vodka,
					/obj/item/reagent_containers/cup/glass/drinkingglass/shotglass,
					/obj/item/reagent_containers/cup/glass/drinkingglass/shotglass)
	crate_name = "radiation protection crate"
	crate_type = /obj/structure/closet/crate/radiation

/datum/supply_pack/emergency/spacesuit
	name = "Space Suit Crate"
	desc = "Contains one aging suit from Space-Goodwill and a jetpack. Requires EVA access to open."
	cost = CARGO_CRATE_VALUE * 3
	access = ACCESS_EVA
	contains = list(/obj/item/clothing/suit/space,
					/obj/item/clothing/head/helmet/space,
					/obj/item/clothing/mask/breath,
					/obj/item/tank/jetpack/carbondioxide)
	crate_name = "space suit crate"
	crate_type = /obj/structure/closet/crate/secure

/datum/supply_pack/emergency/specialops
	name = "Special Ops Supplies"
	desc = "(*!&@#SAD ABOUT THAT NULL_ENTRY, HUH OPERATIVE? WELL, THIS LITTLE ORDER CAN STILL HELP YOU OUT IN A PINCH. CONTAINS A BOX OF FIVE EMP GRENADES, THREE SMOKEBOMBS, AN INCENDIARY GRENADE, AND A \"SLEEPY PEN\" FULL OF NICE TOXINS!#@*$"
	supply_flags = parent_type::supply_flags | SUPPLY_PACK_EMAG
	cost = CARGO_CRATE_VALUE * 4
	contains = list(/obj/item/storage/box/emps,
					/obj/item/grenade/smokebomb,
					/obj/item/grenade/smokebomb,
					/obj/item/grenade/smokebomb,
					/obj/item/pen/sleepy,
					/obj/item/grenade/chem_grenade/incendiary)
	crate_name = "emergency crate"
	crate_type = /obj/structure/closet/crate/internals

/datum/supply_pack/emergency/weedcontrol
	name = "Weed Control Crate"
	desc = "Keep those invasive species OUT. Contains a scythe, gasmask, and two anti-weed chemical grenades. Warranty void if used on ambrosia. Requires Hydroponics access to open."
	cost = CARGO_CRATE_VALUE * 2.5
	access = ACCESS_HYDROPONICS
	contains = list(
		/obj/item/scythe,
		/obj/item/clothing/mask/gas,
		/obj/item/grenade/chem_grenade/antiweed,
		/obj/item/grenade/chem_grenade/antiweed
	)
	crate_name = "weed control crate"
	crate_type = /obj/structure/closet/crate/secure/hydroponics

/datum/supply_pack/emergency/mothic_rations
	name = "Surplus Mothic Rations Triple-Pak"
	desc = "Crew starving? Chef slacking off? Keep everyone fed on the barest minimum of what can be considered food with surplus ration packs, directly from the Mothic Fleet! Pack includes 3 packs of 3 bars each."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/storage/box/mothic_rations,
					/obj/item/storage/box/mothic_rations,
					/obj/item/storage/box/mothic_rations,)
	crate_name = "surplus rations box"
	crate_type = /obj/structure/closet/crate/cardboard/mothic

//////////////////////////////////////////////////////////////////////////////
//////////////////////////// Security ////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/security
	group = "Security"
	access = ACCESS_SECURITY
	crate_type = /obj/structure/closet/crate/secure/gear

/datum/supply_pack/security/ammo
	name = "Ammo Crate"
	desc = "Contains three boxes of beanbag shotgun shells, three boxes of rubbershot shotgun shells and one of each special .38 speedloarders. Requires Security access to open."
	cost = CARGO_CRATE_VALUE * 8
	access_view = ACCESS_ARMORY
	contains = list(/obj/item/storage/box/beanbag,
					/obj/item/storage/box/beanbag,
					/obj/item/storage/box/beanbag,
					/obj/item/storage/box/rubbershot,
					/obj/item/storage/box/rubbershot,
					/obj/item/storage/box/rubbershot,
					/obj/item/ammo_box/c38/trac,
					/obj/item/ammo_box/c38/hotshot,
					/obj/item/ammo_box/c38/iceblox)
	crate_name = "ammo crate"

/datum/supply_pack/security/armor
	name = "Armor Crate"
	desc = "Three vests of well-rounded, decently-protective armor. Requires Security access to open."
	cost = CARGO_CRATE_VALUE * 2
	access_view = ACCESS_SECURITY
	contains = list(/obj/item/clothing/suit/armor/vest,
					/obj/item/clothing/suit/armor/vest,
					/obj/item/clothing/suit/armor/vest)
	crate_name = "armor crate"

/datum/supply_pack/security/disabler
	name = "Disabler Crate"
	desc = "Three stamina-draining disabler weapons. Requires Security access to open."
	cost = CARGO_CRATE_VALUE * 3
	access_view = ACCESS_SECURITY
	contains = list(/obj/item/gun/energy/disabler,
					/obj/item/gun/energy/disabler,
					/obj/item/gun/energy/disabler)
	crate_name = "disabler crate"

/datum/supply_pack/security/forensics
	name = "Forensics Crate"
	desc = "Stay hot on the criminal's heels with Mars' Detective Essentials(tm). Contains a crime scene kit, six evidence bags, camera, tape recorder, white crayon, and of course, a fedora. Requires Security access to open."
	cost = CARGO_CRATE_VALUE * 2.5
	access_view = ACCESS_FORENSICS
	contains = list(/obj/item/storage/scene_cards,
					/obj/item/storage/box/evidence,
					/obj/item/camera,
					/obj/item/taperecorder,
					/obj/item/toy/crayon/white,
					/obj/item/clothing/head/fedora/det_hat,
					/obj/item/storage/briefcase/crimekit)
	crate_name = "forensics crate"

/datum/supply_pack/security/helmets
	name = "Helmets Crate"
	desc = "Contains three standard-issue brain buckets. Requires Security access to open."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/clothing/head/helmet/sec,
					/obj/item/clothing/head/helmet/sec,
					/obj/item/clothing/head/helmet/sec)
	crate_name = "helmet crate"

/datum/supply_pack/security/laser
	name = "Lasers Crate"
	desc = "Contains three lethal, high-energy laser guns. Requires Security access to open."
	cost = CARGO_CRATE_VALUE * 4
	access_view = ACCESS_ARMORY
	contains = list(/obj/item/gun/energy/laser,
					/obj/item/gun/energy/laser,
					/obj/item/gun/energy/laser)
	crate_name = "laser crate"

/datum/supply_pack/security/securitybarriers
	name = "Security Barrier Grenades"
	desc = "Stem the tide with four Security Barrier grenades. Requires Security access to open."
	access_view = ACCESS_SECURITY
	contains = list(/obj/item/grenade/barrier,
					/obj/item/grenade/barrier,
					/obj/item/grenade/barrier,
					/obj/item/grenade/barrier)
	cost = CARGO_CRATE_VALUE * 2
	crate_name = "security barriers crate"

/datum/supply_pack/security/securityclothes
	name = "Security Clothing Crate"
	desc = "Contains appropriate outfits for the station's private security force. Contains outfits for the Warden, Security Marshal, and two Security Officers. Each outfit comes with a rank-appropriate jumpsuit, suit, and beret. Requires Security access to open."
	cost = CARGO_CRATE_VALUE * 3
	access_view = ACCESS_SECURITY
	contains = list(/obj/item/clothing/under/rank/security/officer/formal,
					/obj/item/clothing/under/rank/security/officer/formal,
					/obj/item/clothing/suit/security/officer,
					/obj/item/clothing/suit/security/officer,
					/obj/item/clothing/head/beret/sec/navyofficer,
					/obj/item/clothing/head/beret/sec/navyofficer,
					/obj/item/clothing/under/rank/security/warden/formal,
					/obj/item/clothing/suit/security/warden,
					/obj/item/clothing/head/beret/sec/navywarden,
					/obj/item/clothing/under/rank/security/head_of_security/formal,
					/obj/item/clothing/suit/security/hos,
					/obj/item/clothing/head/hos/beret/navyhos)
	crate_name = "security clothing crate"

/datum/supply_pack/security/stingpack
	name = "Stingbang Grenade Pack"
	desc = "Contains five \"stingbang\" grenades, perfect for stopping riots and playing morally unthinkable pranks. Requires Security access to open."
	cost = CARGO_CRATE_VALUE * 5
	access_view = ACCESS_ARMORY
	contains = list(/obj/item/storage/box/stingbangs)
	crate_name = "stingbang grenade pack crate"

/datum/supply_pack/security/supplies
	name = "Security Supplies Crate"
	desc = "Contains seven flashbangs, seven teargas grenades, six flashes, seven handcuffs, and three pepper sprays. Requires Security access to open."
	cost = CARGO_CRATE_VALUE * 3.8
	access_view = ACCESS_ARMORY
	contains = list(/obj/item/storage/box/flashbangs,
					/obj/item/storage/box/teargas,
					/obj/item/storage/box/flashes,
					/obj/item/storage/box/handcuffs,
					/obj/item/reagent_containers/spray/pepper,
					/obj/item/reagent_containers/spray/pepper,
					/obj/item/reagent_containers/spray/pepper)
	crate_name = "security supply crate"

/datum/supply_pack/security/firingpins
	name = "Standard Firing Pins Crate"
	desc = "Upgrade your arsenal with 10 standard firing pins. Requires Security access to open."
	cost = CARGO_CRATE_VALUE * 4
	access_view = ACCESS_ARMORY
	contains = list(/obj/item/storage/box/firingpins,
					/obj/item/storage/box/firingpins)
	crate_name = "firing pins crate"

/datum/supply_pack/security/firingpins/paywall
	name = "Paywall Firing Pins Crate"
	desc = "Specialized firing pins with a built-in configurable paywall. Requires Security access to open."
	cost = CARGO_CRATE_VALUE * 2
	access_view = ACCESS_ARMORY
	contains = list(/obj/item/storage/box/firingpins/paywall,
					/obj/item/storage/box/firingpins/paywall)
	crate_name = "paywall firing pins crate"

/datum/supply_pack/security/justiceinbound
	name = "Standard Justice Enforcer Crate"
	desc = "This is it. The Bee's Knees. The Creme of the Crop. The Pick of the Litter. The best of the best of the best. The Crown Jewel of Marks. The Alpha and the Omega of security headwear. Guaranteed to strike fear into the hearts of each and every criminal aboard the station. Also comes with a security gasmask. Requires Security access to open."
	cost = CARGO_CRATE_VALUE * 6 //justice comes at a price. An expensive, noisy price.
	supply_flags = SUPPLY_PACK_CONTRABAND
	contains = list(/obj/item/clothing/head/helmet/justice,
					/obj/item/clothing/mask/gas/sechailer)
	crate_name = "security clothing crate"

/datum/supply_pack/security/baton
	name = "Stun Batons Crate"
	desc = "Arm the Civil Protection Forces with three stun batons. Batteries included. Requires Security access to open."
	cost = CARGO_CRATE_VALUE * 2
	access_view = ACCESS_SECURITY
	contains = list(/obj/item/melee/baton/security/loaded,
					/obj/item/melee/baton/security/loaded,
					/obj/item/melee/baton/security/loaded)
	crate_name = "stun baton crate"

/datum/supply_pack/security/wall_flash
	name = "Wall-Mounted Flash Crate"
	desc = "Contains four wall-mounted flashes. Requires Security access to open."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/storage/box/wall_flash,
					/obj/item/storage/box/wall_flash,
					/obj/item/storage/box/wall_flash,
					/obj/item/storage/box/wall_flash)
	crate_name = "wall-mounted flash crate"

/datum/supply_pack/security/constable
	name = "Traditional Equipment Crate"
	desc = "Spare equipment found in a warehouse."
	cost = CARGO_CRATE_VALUE * 2.2
	supply_flags = SUPPLY_PACK_CONTRABAND
	contains = list(/obj/item/clothing/under/rank/security/constable,
					/obj/item/clothing/head/helmet/constable,
					/obj/item/clothing/gloves/color/white,
					/obj/item/clothing/mask/whistle,
					/obj/item/conversion_kit)

//////////////////////////////////////////////////////////////////////////////
//////////////////////////// Armory //////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/security/armory
	group = "Armory"
	access = ACCESS_ARMORY
	access_view = ACCESS_ARMORY
	crate_type = /obj/structure/closet/crate/secure/weapon

/datum/supply_pack/security/armory/bulletarmor
	name = "Bulletproof Armor Crate"
	desc = "Contains three sets of bulletproof armor. Guaranteed to reduce a bullet's stopping power by over half. Requires Armory access to open."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/clothing/suit/armor/bulletproof,
					/obj/item/clothing/suit/armor/bulletproof,
					/obj/item/clothing/suit/armor/bulletproof)
	crate_name = "bulletproof armor crate"

/datum/supply_pack/security/armory/bullethelmets
	name = "Bulletproof Helmets Crate"
	desc = "Contains three bulletproof helmets. Requires Armory access to open."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/clothing/head/helmet/alt,
					/obj/item/clothing/head/helmet/alt,
					/obj/item/clothing/head/helmet/alt)
	crate_name = "bulletproof helmets crate"

/datum/supply_pack/security/armory/chemimp
	name = "Chemical Implants Crate"
	desc = "Contains five Remote Chemical implants. Requires Armory access to open."
	cost = CARGO_CRATE_VALUE * 3.5
	contains = list(/obj/item/storage/box/chemimp)
	crate_name = "chemical implant crate"

/datum/supply_pack/security/armory/ballistic
	name = "Combat Shotguns Crate"
	desc = "For when the enemy absolutely needs to be replaced with lead. Contains three Aussec-designed Combat Shotguns, and three Shotgun Bandoliers. Requires Armory access to open."
	cost = CARGO_CRATE_VALUE * 17.5
	contains = list(/obj/item/gun/ballistic/shotgun/automatic/combat,
					/obj/item/gun/ballistic/shotgun/automatic/combat,
					/obj/item/gun/ballistic/shotgun/automatic/combat,
					/obj/item/storage/belt/bandolier,
					/obj/item/storage/belt/bandolier,
					/obj/item/storage/belt/bandolier)
	crate_name = "combat shotguns crate"

/datum/supply_pack/security/armory/dragnet
	name = "DRAGnet Crate"
	desc = "Contains three \"Dynamic Rapid-Apprehension of the Guilty\" netting devices, a recent breakthrough in law enforcement prisoner management technology. Requires armory access to open."
	cost = CARGO_CRATE_VALUE * 5
	contains = list(/obj/item/gun/energy/e_gun/dragnet,
					/obj/item/gun/energy/e_gun/dragnet,
					/obj/item/gun/energy/e_gun/dragnet)
	crate_name = "\improper DRAGnet crate"

/datum/supply_pack/security/armory/energy
	name = "Energy Guns Crate"
	desc = "Contains two Energy Guns, capable of firing both nonlethal and lethal blasts of light. Requires Armory access to open."
	cost = CARGO_CRATE_VALUE * 18
	contains = list(/obj/item/gun/energy/e_gun,
					/obj/item/gun/energy/e_gun)
	crate_name = "energy gun crate"
	crate_type = /obj/structure/closet/crate/secure/plasma

/datum/supply_pack/security/armory/exileimp
	name = "Exile Implants Crate"
	desc = "Contains five Exile implants. Requires Armory access to open."
	cost = CARGO_CRATE_VALUE * 3.5
	contains = list(/obj/item/storage/box/exileimp)
	crate_name = "exile implant crate"

/datum/supply_pack/security/armory/fire
	name = "Incendiary Weapons Crate"
	desc = "Burn, baby burn. Contains three incendiary grenades, three plasma canisters, and a flamethrower. Requires Armory access to open."
	cost = CARGO_CRATE_VALUE * 7
	access = ACCESS_SECURITY
	contains = list(/obj/item/flamethrower/full,
					/obj/item/tank/internals/plasma,
					/obj/item/tank/internals/plasma,
					/obj/item/tank/internals/plasma,
					/obj/item/grenade/chem_grenade/incendiary,
					/obj/item/grenade/chem_grenade/incendiary,
					/obj/item/grenade/chem_grenade/incendiary)
	crate_name = "incendiary weapons crate"
	crate_type = /obj/structure/closet/crate/secure/plasma
	dangerous = TRUE

/datum/supply_pack/security/armory/ion_carbine
	name = "Ion Carbine Parts Kit"
	desc = "A suitcase containing the necessary gun parts to transform a standard laser gun into a ion carbine. Perfect against lockers you don't have access to."
	cost = CARGO_CRATE_VALUE * 9
	contains = list(/obj/item/weaponcrafting/gunkit/ion)
	crate_name = "gun parts crate"

/datum/supply_pack/security/armory/mindshield
	name = "Mindshield Implants Crate"
	desc = "Prevent against radical thoughts with three Mindshield implants. Requires Armory access to open."
	cost = CARGO_CRATE_VALUE * 6
	contains = list(/obj/item/storage/lockbox/loyalty)
	crate_name = "mindshield implant crate"

/datum/supply_pack/security/armory/trackingimp
	name = "Tracking Implants Crate"
	desc = "Contains four tracking implants and three tracking speedloaders of tracing .38 ammo. Requires Armory access to open."
	cost = CARGO_CRATE_VALUE * 4.5
	contains = list(/obj/item/storage/box/trackimp,
					/obj/item/ammo_box/c38/trac,
					/obj/item/ammo_box/c38/trac,
					/obj/item/ammo_box/c38/trac)
	crate_name = "tracking implant crate"

/datum/supply_pack/security/armory/laserarmor
	name = "Reflector Vest Crate"
	desc = "Contains two vests of highly reflective material. Each armor piece diffuses a laser's energy by over half, as well as offering a good chance to reflect the laser entirely. Requires Armory access to open."
	cost = CARGO_CRATE_VALUE * 5
	contains = list(/obj/item/clothing/suit/armor/laserproof,
					/obj/item/clothing/suit/armor/laserproof)
	crate_name = "reflector vest crate"
	crate_type = /obj/structure/closet/crate/secure/plasma

/datum/supply_pack/security/armory/riotarmor
	name = "Riot Armor Crate"
	desc = "Contains three sets of heavy body armor. Advanced padding protects against close-ranged weaponry, making melee attacks feel only half as potent to the user. Requires Armory access to open."
	cost = CARGO_CRATE_VALUE * 6
	contains = list(/obj/item/clothing/suit/armor/riot,
					/obj/item/clothing/suit/armor/riot,
					/obj/item/clothing/suit/armor/riot)
	crate_name = "riot armor crate"

/datum/supply_pack/security/armory/riothelmets
	name = "Riot Helmets Crate"
	desc = "Contains three riot helmets. Requires Armory access to open."
	cost = CARGO_CRATE_VALUE * 4
	contains = list(/obj/item/clothing/head/helmet/riot,
					/obj/item/clothing/head/helmet/riot,
					/obj/item/clothing/head/helmet/riot)
	crate_name = "riot helmets crate"

/datum/supply_pack/security/armory/riotshields
	name = "Riot Shields Crate"
	desc = "For when the greytide gets really uppity. Contains three riot shields. Requires Armory access to open."
	cost = CARGO_CRATE_VALUE * 5
	contains = list(/obj/item/shield/riot,
					/obj/item/shield/riot,
					/obj/item/shield/riot)
	crate_name = "riot shields crate"

/datum/supply_pack/security/armory/russian
	name = "Russian Surplus Crate"
	desc = "Hello Comrade, we have the most modern russian military equipment the black market can offer, for the right price of course. Sadly we couldnt remove the lock so it requires Armory access to open."
	cost = CARGO_CRATE_VALUE * 12
	supply_flags = SUPPLY_PACK_CONTRABAND
	contains = list(/obj/item/food/rationpack,
					/obj/item/ammo_box/a762,
					/obj/item/storage/toolbox/ammo,
					/obj/item/storage/toolbox/maint_kit,
					/obj/item/clothing/suit/armor/vest/russian,
					/obj/item/clothing/head/helmet/rus_helmet,
					/obj/item/clothing/shoes/russian,
					/obj/item/clothing/gloves/tackler/combat,
					/obj/item/clothing/under/syndicate/rus_army,
					/obj/item/clothing/under/costume/soviet,
					/obj/item/clothing/mask/russian_balaclava,
					/obj/item/clothing/head/helmet/rus_ushanka,
					/obj/item/clothing/suit/armor/vest/russian_coat,
					/obj/item/gun/ballistic/rifle/boltaction,
					/obj/item/gun/ballistic/rifle/boltaction)
	crate_name = "surplus military crate"

/datum/supply_pack/security/armory/russian/fill(obj/structure/closet/crate/C)
	for(var/i in 1 to 10)
		var/item = pick(contains)
		new item(C)

/datum/supply_pack/security/armory/swat
	name = "SWAT Crate"
	desc = "Contains two fullbody sets of tough, fireproof suits designed in a joint effort by IS-ERI and Mars Executive Solutions. Each set contains a suit, helmet, mask, combat belt, and combat gloves. Requires Armory access to open."
	cost = CARGO_CRATE_VALUE * 7
	contains = list(/obj/item/clothing/head/helmet/swat/nanotrasen,
					/obj/item/clothing/head/helmet/swat/nanotrasen,
					/obj/item/clothing/suit/armor/swat,
					/obj/item/clothing/suit/armor/swat,
					/obj/item/clothing/mask/gas/sechailer/swat,
					/obj/item/clothing/mask/gas/sechailer/swat,
					/obj/item/storage/belt/military/assault,
					/obj/item/storage/belt/military/assault,
					/obj/item/clothing/gloves/tackler/combat,
					/obj/item/clothing/gloves/tackler/combat)
	crate_name = "swat crate"

/datum/supply_pack/security/armory/thermal
	name = "Thermal Pistol Crate"
	desc = "Contains a pair of holsters each with two experimental thermal pistols, using nanites as the basis for their ammo. Requires Armory access to open."
	cost = CARGO_CRATE_VALUE * 7
	contains = list(/obj/item/storage/belt/holster/shoulder/thermal,
					/obj/item/storage/belt/holster/shoulder/thermal)
	crate_name = "thermal pistol crate"

//////////////////////////////////////////////////////////////////////////////
//////////////////////////// Engineering /////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/engineering
	group = "Engineering"
	crate_type = /obj/structure/closet/crate/engineering

/datum/supply_pack/engineering/shieldgen
	name = "Anti-breach Shield Projector Crate"
	desc = "Hull breaches again? Say no more with the Daedalus Industries Anti-Breach Shield Projector! Uses forcefield technology to keep the air in, and the space out. Contains two shield projectors."
	cost = CARGO_CRATE_VALUE * 3
	access_view = ACCESS_ENGINE_EQUIP
	contains = list(/obj/machinery/shieldgen,
					/obj/machinery/shieldgen)
	crate_name = "anti-breach shield projector crate"

/datum/supply_pack/engineering/ripley
	name = "APLU MK-I Crate"
	desc = "A do-it-yourself kit for building an ALPU MK-I \"Ripley\", designed for lifting and carrying heavy equipment, and other station tasks. Batteries not included."
	cost = CARGO_CRATE_VALUE * 10
	access_view = ACCESS_ROBOTICS
	contains = list(/obj/item/mecha_parts/chassis/ripley,
					/obj/item/mecha_parts/part/ripley_torso,
					/obj/item/mecha_parts/part/ripley_right_arm,
					/obj/item/mecha_parts/part/ripley_left_arm,
					/obj/item/mecha_parts/part/ripley_right_leg,
					/obj/item/mecha_parts/part/ripley_left_leg,
					/obj/item/stock_parts/capacitor,
					/obj/item/stock_parts/scanning_module,
					/obj/item/circuitboard/mecha/ripley/main,
					/obj/item/circuitboard/mecha/ripley/peripherals,
					/obj/item/mecha_parts/mecha_equipment/drill,
					/obj/item/mecha_parts/mecha_equipment/hydraulic_clamp)
	crate_name= "\improper APLU MK-I kit"

/datum/supply_pack/engineering/conveyor
	name = "Conveyor Assembly Crate"
	desc = "Keep production moving along with thirty conveyor belts. Conveyor switch included. If you have any questions, check out the enclosed instruction book."
	cost = CARGO_CRATE_VALUE * 3.5
	contains = list(/obj/item/stack/conveyor/thirty,
					/obj/item/conveyor_switch_construct,
					/obj/item/paper/guides/conveyor)
	crate_name = "conveyor assembly crate"

/datum/supply_pack/engineering/engiequipment
	name = "Engineering Gear Crate"
	desc = "Gear up with three toolbelts, high-visibility vests, welding helmets, hardhats, and two pairs of meson goggles!"
	cost = CARGO_CRATE_VALUE * 4
	access_view = ACCESS_ENGINEERING
	contains = list(/obj/item/storage/belt/utility,
					/obj/item/storage/belt/utility,
					/obj/item/storage/belt/utility,
					/obj/item/clothing/suit/hazardvest,
					/obj/item/clothing/suit/hazardvest,
					/obj/item/clothing/suit/hazardvest,
					/obj/item/clothing/head/welding,
					/obj/item/clothing/head/welding,
					/obj/item/clothing/head/welding,
					/obj/item/clothing/head/hardhat,
					/obj/item/clothing/head/hardhat,
					/obj/item/clothing/head/hardhat,
					/obj/item/clothing/glasses/meson/engine,
					/obj/item/clothing/glasses/meson/engine)
	crate_name = "engineering gear crate"

/datum/supply_pack/engineering/powergamermitts
	name = "Insulated Gloves Crate"
	desc = "The backbone of modern society. Barely ever ordered for actual engineering. Contains three insulated gloves."
	cost = CARGO_CRATE_VALUE * 8 //Made of pure-grade bullshittinium
	access_view = ACCESS_ENGINE_EQUIP
	contains = list(/obj/item/clothing/gloves/color/yellow,
					/obj/item/clothing/gloves/color/yellow,
					/obj/item/clothing/gloves/color/yellow)
	crate_name = "insulated gloves crate"
	crate_type = /obj/structure/closet/crate/engineering/electrical

/datum/supply_pack/engineering/inducers
	name = "NT-75 Electromagnetic Power Inducers Crate"
	desc = "No rechargers? No problem, with the NT-75 EPI, you can recharge any standard cell-based equipment anytime, anywhere. Contains two Inducers."
	cost = CARGO_CRATE_VALUE * 4
	contains = list(/obj/item/inducer/sci {cell_type = /obj/item/stock_parts/cell/inducer_supply; opened = 0}, /obj/item/inducer/sci {cell_type = /obj/item/stock_parts/cell/inducer_supply; opened = 0}) //FALSE doesn't work in modified type paths apparently.
	crate_name = "inducer crate"
	crate_type = /obj/structure/closet/crate/engineering/electrical

/datum/supply_pack/engineering/pacman
	name = "P.A.C.M.A.N Generator Crate"
	desc = "Engineers can't set up the engine? Not an issue for you, once you get your hands on this P.A.C.M.A.N. Generator! Takes in plasma and spits out sweet sweet energy."
	cost = CARGO_CRATE_VALUE * 5
	access_view = ACCESS_ENGINEERING
	contains = list(/obj/machinery/power/port_gen/pacman)
	crate_name = "\improper PACMAN generator crate"
	crate_type = /obj/structure/closet/crate/engineering/electrical

/datum/supply_pack/engineering/power
	name = "Power Cell Crate"
	desc = "Looking for power overwhelming? Look no further. Contains three high-voltage power cells."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/stock_parts/cell/high,
					/obj/item/stock_parts/cell/high,
					/obj/item/stock_parts/cell/high)
	crate_name = "power cell crate"
	crate_type = /obj/structure/closet/crate/engineering/electrical

/datum/supply_pack/engineering/shuttle_engine
	name = "Shuttle Engine Crate"
	desc = "Through advanced bluespace-shenanigans, our engineers have managed to fit an entire shuttle engine into one tiny little crate. Requires CE access to open."
	cost = CARGO_CRATE_VALUE * 6
	access = ACCESS_CE
	access_view = ACCESS_CE
	contains = list(/obj/structure/shuttle/engine/propulsion/burst/cargo)
	crate_name = "shuttle engine crate"
	crate_type = /obj/structure/closet/crate/secure/engineering
	special = TRUE

/datum/supply_pack/engineering/tools
	name = "Toolbox Crate"
	desc = "Any robust spaceman is never far from their trusty toolbox. Contains three electrical toolboxes and three mechanical toolboxes."
	access_view = ACCESS_ENGINE_EQUIP
	contains = list(/obj/item/storage/toolbox/electrical,
					/obj/item/storage/toolbox/electrical,
					/obj/item/storage/toolbox/electrical,
					/obj/item/storage/toolbox/mechanical,
					/obj/item/storage/toolbox/mechanical,
					/obj/item/storage/toolbox/mechanical)
	cost = CARGO_CRATE_VALUE * 5
	crate_name = "toolbox crate"

/datum/supply_pack/engineering/portapump
	name = "Portable Air Pump Crate"
	desc = "Did someone let the air out of the shuttle again? We've got you covered. Contains two portable air pumps."
	cost = CARGO_CRATE_VALUE * 4.5
	access_view = ACCESS_ATMOSPHERICS
	contains = list(/obj/machinery/portable_atmospherics/pump,
					/obj/machinery/portable_atmospherics/pump)
	crate_name = "portable air pump crate"

/datum/supply_pack/engineering/portascrubber
	name = "Portable Scrubber Crate"
	desc = "Clean up that pesky plasma leak with your very own set of two portable scrubbers."
	cost = CARGO_CRATE_VALUE * 4.5
	access_view = ACCESS_ATMOSPHERICS
	contains = list(/obj/machinery/portable_atmospherics/scrubber,
					/obj/machinery/portable_atmospherics/scrubber)
	crate_name = "portable scrubber crate"

/datum/supply_pack/engineering/hugescrubber
	name = "Huge Portable Scrubber Crate"
	desc = "A huge portable scrubber for huge atmospherics mistakes."
	cost = CARGO_CRATE_VALUE * 7.5
	access_view = ACCESS_ATMOSPHERICS
	contains = list(/obj/machinery/portable_atmospherics/scrubber/huge/movable/cargo)
	crate_name = "huge portable scrubber crate"
	crate_type = /obj/structure/closet/crate/large

/datum/supply_pack/engineering/space_heater
	name = "Space Heater Crate"
	desc = "A dual purpose heater/cooler for when things are too chilly/toasty."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/machinery/space_heater)
	crate_name = "space heater crate"
	crate_type = /obj/structure/closet/crate/large

/datum/supply_pack/engineering/bsa
	name = "Bluespace Artillery Parts"
	desc = "The pride of Mars Executive Solutions command staff. The legendary Bluespace Artillery Cannon is a devastating feat of human engineering and testament to wartime determination. Highly advanced research is required for proper construction. "
	cost = CARGO_CRATE_VALUE * 30
	special = TRUE
	access_view = ACCESS_CAPTAIN
	contains = list(/obj/item/circuitboard/machine/bsa/front,
					/obj/item/circuitboard/machine/bsa/middle,
					/obj/item/circuitboard/machine/bsa/back,
					/obj/item/circuitboard/computer/bsa_control
					)
	crate_name= "bluespace artillery parts crate"

/datum/supply_pack/engineering/dna_vault
	name = "DNA Vault Parts"
	desc = "Secure the longevity of the current state of humanity within this massive library of scientific knowledge, capable of granting superhuman powers and abilities. Highly advanced research is required for proper construction. Also contains five DNA probes."
	cost = CARGO_CRATE_VALUE * 24
	special = TRUE
	access_view = ACCESS_CAPTAIN
	contains = list(
					/obj/item/circuitboard/machine/dna_vault,
					/obj/item/dna_probe,
					/obj/item/dna_probe,
					/obj/item/dna_probe,
					/obj/item/dna_probe,
					/obj/item/dna_probe
					)
	crate_name= "dna vault parts crate"

/datum/supply_pack/engineering/dna_probes
	name = "DNA Vault Samplers"
	desc = "Contains five DNA probes for use in the DNA vault."
	cost = CARGO_CRATE_VALUE * 6
	special = TRUE
	access_view = ACCESS_CAPTAIN
	contains = list(/obj/item/dna_probe,
					/obj/item/dna_probe,
					/obj/item/dna_probe,
					/obj/item/dna_probe,
					/obj/item/dna_probe
					)
	crate_name= "dna samplers crate"


/datum/supply_pack/engineering/shield_sat
	name = "Shield Generator Satellite"
	desc = "Protect the very existence of this station with these Anti-Meteor defenses. Contains three Shield Generator Satellites."
	cost = CARGO_CRATE_VALUE * 6
	special = TRUE
	access_view = ACCESS_CAPTAIN
	contains = list(
					/obj/machinery/satellite/meteor_shield,
					/obj/machinery/satellite/meteor_shield,
					/obj/machinery/satellite/meteor_shield
					)
	crate_name= "shield sat crate"


/datum/supply_pack/engineering/shield_sat_control
	name = "Shield System Control Board"
	desc = "A control system for the Shield Generator Satellite system."
	cost = CARGO_CRATE_VALUE * 10
	special = TRUE
	access_view = ACCESS_CAPTAIN
	contains = list(/obj/item/circuitboard/computer/sat_control)
	crate_name= "shield control board crate"


//////////////////////////////////////////////////////////////////////////////
//////////////////////// Engine Construction /////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/engine
	group = "Engine Construction"
	access_view = ACCESS_ENGINEERING
	crate_type = /obj/structure/closet/crate/engineering

/datum/supply_pack/engine/emitter
	name = "Emitter Crate"
	desc = "Useful for powering forcefield generators while destroying locked crates and intruders alike. Contains two high-powered energy emitters. Requires CE access to open."
	cost = CARGO_CRATE_VALUE * 7
	access = ACCESS_CE
	contains = list(/obj/machinery/power/emitter,
					/obj/machinery/power/emitter)
	crate_name = "emitter crate"
	crate_type = /obj/structure/closet/crate/secure/engineering
	dangerous = TRUE

/datum/supply_pack/engine/field_gen
	name = "Field Generator Crate"
	desc = "Typically the only thing standing between the station and a messy death. Powered by emitters. Contains two field generators."
	cost = CARGO_CRATE_VALUE * 7
	contains = list(/obj/machinery/field/generator,
					/obj/machinery/field/generator)
	crate_name = "field generator crate"

/datum/supply_pack/engine/grounding_rods
	name = "Grounding Rod Crate"
	desc = "Four grounding rods guaranteed to keep any uppity tesla coil's lightning under control."
	cost = CARGO_CRATE_VALUE * 8
	contains = list(/obj/machinery/power/energy_accumulator/grounding_rod,
					/obj/machinery/power/energy_accumulator/grounding_rod,
					/obj/machinery/power/energy_accumulator/grounding_rod,
					/obj/machinery/power/energy_accumulator/grounding_rod)
	crate_name = "grounding rod crate"
	crate_type = /obj/structure/closet/crate/engineering/electrical

/datum/supply_pack/engine/solar
	name = "Solar Panel Crate"
	desc = "Go green with this DIY advanced solar array. Contains twenty one solar assemblies, a solar-control circuit board, and tracker. If you have any questions, please check out the enclosed instruction book."
	cost = CARGO_CRATE_VALUE * 8
	contains = list(/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/circuitboard/computer/solar_control,
					/obj/item/electronics/tracker,
					/obj/item/paper/guides/jobs/engi/solars)
	crate_name = "solar panel crate"
	crate_type = /obj/structure/closet/crate/engineering/electrical

/datum/supply_pack/engine/supermatter_shard
	name = "Supermatter Shard Crate"
	desc = "The power of the heavens condensed into a single crystal. Requires CE access to open."
	cost = CARGO_CRATE_VALUE * 20
	access = ACCESS_CE
	//contains = list(/obj/machinery/power/supermatter/shard)
	crate_name = "supermatter shard crate"
	crate_type = /obj/structure/closet/crate/secure/engineering
	dangerous = TRUE

/datum/supply_pack/engine/tesla_coils
	name = "Tesla Coil Crate"
	desc = "Whether it's high-voltage executions, creating research points, or just plain old assistant electrofrying: This pack of four Tesla coils can do it all!"
	cost = CARGO_CRATE_VALUE * 10
	contains = list(/obj/machinery/power/energy_accumulator/tesla_coil,
					/obj/machinery/power/energy_accumulator/tesla_coil,
					/obj/machinery/power/energy_accumulator/tesla_coil,
					/obj/machinery/power/energy_accumulator/tesla_coil)
	crate_name = "tesla coil crate"
	crate_type = /obj/structure/closet/crate/engineering/electrical

/datum/supply_pack/engine/teg
	name = "Thermo-Electric Generator Crate"
	desc = "All the components for building your own Thermoelectric Generator! Contains a generator and two circulators."
	cost = CARGO_CRATE_VALUE * 15
	contains = list(/obj/machinery/power/generator/unwrenched,
					/obj/machinery/atmospherics/components/binary/circulator/unwrenched,
					/obj/machinery/atmospherics/components/binary/circulator/unwrenched)
	crate_name = "thermoelectric generator crate"
	crate_type = /obj/structure/closet/crate/large

/datum/supply_pack/engine/hypertorus_fusion_reactor
	name = "HFR Crate"
	desc = "The new and improved fusion reactor. Requires CE access to open."
	cost = CARGO_CRATE_VALUE * 23
	access = ACCESS_CE
	/*contains = list(/obj/item/hfr_box/corner,
					/obj/item/hfr_box/corner,
					/obj/item/hfr_box/corner,
					/obj/item/hfr_box/corner,
					/obj/item/hfr_box/body/fuel_input,
					/obj/item/hfr_box/body/moderator_input,
					/obj/item/hfr_box/body/waste_output,
					/obj/item/hfr_box/body/interface,
					/obj/item/hfr_box/core)*/
	crate_name = "HFR crate"
	crate_type = /obj/structure/closet/crate/secure/engineering
	dangerous = TRUE

//////////////////////////////////////////////////////////////////////////////
/////////////////////// Materials ////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/materials
	group = "Materials"

/datum/supply_pack/materials/cardboard50
	name = "50 Cardboard Sheets"
	desc = "Create a bunch of boxes."
	cost = CARGO_CRATE_VALUE + (/datum/material/cardboard::value_per_unit * MINERAL_MATERIAL_AMOUNT * 50)
	contains = list(/obj/item/stack/sheet/cardboard/fifty)
	crate_name = "cardboard sheets crate"

/datum/supply_pack/materials/license50
	name = "50 Empty License Plates"
	desc = "Create a bunch of boxes."
	cost = CARGO_CRATE_VALUE * 2  // 50 * 25 + 700 - 1000 = 950 credits profit
	access_view = ACCESS_SECURITY
	contains = list(/obj/item/stack/license_plates/empty/fifty)
	crate_name = "empty license plate crate"

/datum/supply_pack/materials/glass50
	name = "50 Glass Sheets"
	desc = "Let some nice light in with fifty glass sheets!"
	cost = CARGO_CRATE_VALUE + (/datum/material/glass::value_per_unit * MINERAL_MATERIAL_AMOUNT * 50)
	contains = list(/obj/item/stack/sheet/glass/fifty)
	crate_name = "glass sheets crate"

/datum/supply_pack/materials/iron50
	name = "50 Iron Sheets"
	desc = "Any construction project begins with a good stack of fifty iron sheets!"
	cost = CARGO_CRATE_VALUE + (/datum/material/iron::value_per_unit * MINERAL_MATERIAL_AMOUNT * 50)
	contains = list(/obj/item/stack/sheet/iron/fifty)
	crate_name = "iron sheets crate"

/datum/supply_pack/materials/plasteel20
	name = "20 Plasteel Sheets"
	desc = "Reinforce the station's integrity with twenty plasteel sheets!"
	cost = CARGO_CRATE_VALUE + (/datum/material/alloy/plasteel::value_per_unit * MINERAL_MATERIAL_AMOUNT * 20)
	contains = list(/obj/item/stack/sheet/plasteel/twenty)
	crate_name = "plasteel sheets crate"

/datum/supply_pack/materials/plastic50
	name = "50 Plastic Sheets"
	desc = "Build a limitless amount of toys with fifty plastic sheets!"
	cost = CARGO_CRATE_VALUE + (/datum/material/plastic::value_per_unit * MINERAL_MATERIAL_AMOUNT * 50)
	contains = list(/obj/item/stack/sheet/plastic/fifty)
	crate_name = "plastic sheets crate"

/datum/supply_pack/materials/wood50
	name = "50 Wood Planks"
	desc = "Turn cargo's boring metal groundwork into beautiful panelled flooring and much more with fifty wooden planks!"
	cost = CARGO_CRATE_VALUE + (/datum/material/wood::value_per_unit * MINERAL_MATERIAL_AMOUNT * 50)
	contains = list(/obj/item/stack/sheet/mineral/wood/fifty)
	crate_name = "wood planks crate"

/datum/supply_pack/materials/rcd_ammo
	name = "RCD Ammo"
	desc = "Contains four raw material cartridges that can be used to quickly recharge any RCD."
	cost = CARGO_CRATE_VALUE * 8.5
	contains = list(/obj/item/rcd_ammo,
					/obj/item/rcd_ammo,
					/obj/item/rcd_ammo/large,
					/obj/item/rcd_ammo/large,)
	crate_name = "rcd ammo crate"

/datum/supply_pack/materials/foamtank
	name = "Firefighting Foam Tank Crate"
	desc = "Contains a tank of firefighting foam."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/structure/reagent_dispensers/foamtank)
	crate_name = "foam tank crate"
	crate_type = /obj/structure/closet/crate/large

/datum/supply_pack/materials/fueltank
	name = "Fuel Tank Crate"
	desc = "Contains a welding fuel tank. Caution, highly flammable."
	cost = CARGO_CRATE_VALUE * 1.6
	contains = list(/obj/structure/reagent_dispensers/fueltank)
	crate_name = "fuel tank crate"
	crate_type = /obj/structure/closet/crate/large

/datum/supply_pack/materials/hightank
	name = "Large Water Tank Crate"
	desc = "Contains a high-capacity water tank. Useful for botany or other service jobs."
	cost = CARGO_CRATE_VALUE * 2.4
	contains = list(/obj/structure/reagent_dispensers/watertank/high)
	crate_name = "high-capacity water tank crate"
	crate_type = /obj/structure/closet/crate/large

/datum/supply_pack/materials/hightankfuel
	name = "Large Fuel Tank Crate"
	desc = "Contains a high-capacity fuel tank. Keep contents away from open flame."
	cost = CARGO_CRATE_VALUE * 4
	access_view = ACCESS_ENGINEERING
	contains = list(/obj/structure/reagent_dispensers/fueltank/large)
	crate_name = "high-capacity fuel tank crate"
	crate_type = /obj/structure/closet/crate/large

/datum/supply_pack/materials/watertank
	name = "Water Tank Crate"
	desc = "Contains a tank of dihydrogen monoxide... sounds dangerous."
	cost = CARGO_CRATE_VALUE * 1.2
	contains = list(/obj/structure/reagent_dispensers/watertank)
	crate_name = "water tank crate"
	crate_type = /obj/structure/closet/crate/large

/datum/supply_pack/materials/gas_canisters
	cost = CARGO_CRATE_VALUE
	contains = list(/obj/machinery/portable_atmospherics/canister)
	crate_type = /obj/structure/closet/crate/large

/datum/supply_pack/materials/gas_canisters/generate_supply_packs()
	var/list/canister_packs = list()

	var/obj/machinery/portable_atmospherics/canister/fakeCanister = /obj/machinery/portable_atmospherics/canister
	// This is the amount of moles in a default canister
	var/moleCount = (initial(fakeCanister.maximum_pressure) * initial(fakeCanister.filled)) * initial(fakeCanister.volume) / (R_IDEAL_GAS_EQUATION * T20C)

	for(var/gasType in xgm_gas_data.gases)
		var/name = xgm_gas_data.name[gasType]
		if(!xgm_gas_data.purchaseable[gasType])
			continue
		var/datum/supply_pack/materials/pack = new
		pack.name = "Canister ([name])"
		pack.desc = "Contains a canister of [name]."
		if(xgm_gas_data.flags[gasType] & XGM_GAS_FUEL)
			pack.desc = "[pack.desc] Requires Atmospherics access to open."
			pack.access = ACCESS_ATMOSPHERICS
			pack.access_view = ACCESS_ATMOSPHERICS
		pack.crate_name = "[name] canister crate"
		pack.id = "[type]([name])"

		pack.cost = cost + (moleCount * xgm_gas_data.base_value[gasType])
		pack.cost = CEILING(pack.cost, 10)

		pack.contains = list(GLOB.gas_id_to_canister[gasType])

		pack.crate_type = crate_type

		canister_packs += pack

	////AIRMIX SPECIAL BABY
	var/datum/supply_pack/materials/airpack = new
	airpack.name = "Canister (Airmix)"
	airpack.desc = "Contains a canister of breathable air."
	airpack.crate_name = "airmix canister crate"
	airpack.id = "[type](airmix)"
	airpack.cost = 200
	airpack.contains = list(/obj/machinery/portable_atmospherics/canister/air)
	airpack.crate_type = crate_type
	canister_packs += airpack

	return canister_packs

//////////////////////////////////////////////////////////////////////////////
//////////////////////////// Medical /////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/medical
	group = "Medical"
	access_view = ACCESS_MEDICAL
	crate_type = /obj/structure/closet/crate/medical

/datum/supply_pack/medical/bloodpacks
	name = "Blood Pack Variety Crate"
	desc = "Contains ten different blood packs for reintroducing blood to patients."
	cost = CARGO_CRATE_VALUE * 7
	contains = list(/obj/item/reagent_containers/blood,
					/obj/item/reagent_containers/blood,
					/obj/item/reagent_containers/blood/a_plus,
					/obj/item/reagent_containers/blood/a_minus,
					/obj/item/reagent_containers/blood/b_plus,
					/obj/item/reagent_containers/blood/b_minus,
					/obj/item/reagent_containers/blood/o_plus,
					/obj/item/reagent_containers/blood/o_minus,
					/obj/item/reagent_containers/blood/lizard,
					/obj/item/reagent_containers/blood/ethereal
	)
	crate_name = "blood freezer"
	crate_type = /obj/structure/closet/crate/freezer

/datum/supply_pack/medical/medipen_variety
	name = "Medipen Variety-Pak"
	desc = "Contains eight different medipens in three different varieties, to assist in quickly treating seriously injured patients."
	cost = CARGO_CRATE_VALUE * 3.5
	contains = list(/obj/item/reagent_containers/hypospray/medipen/,
					/obj/item/reagent_containers/hypospray/medipen/,
					/obj/item/reagent_containers/hypospray/medipen/ekit,
					/obj/item/reagent_containers/hypospray/medipen/ekit,
					/obj/item/reagent_containers/hypospray/medipen/ekit,
					/obj/item/reagent_containers/hypospray/medipen/blood_loss,
					/obj/item/reagent_containers/hypospray/medipen/blood_loss,
					/obj/item/reagent_containers/hypospray/medipen/blood_loss
)
	crate_name = "medipen crate"

/datum/supply_pack/medical/chemical
	name = "Chemical Starter Kit Crate"
	desc = "Contains thirteen different chemicals, for all the fun experiments you can make."
	cost = CARGO_CRATE_VALUE * 2.6
	contains = list(/obj/item/reagent_containers/cup/bottle/hydrogen,
					/obj/item/reagent_containers/cup/bottle/carbon,
					/obj/item/reagent_containers/cup/bottle/nitrogen,
					/obj/item/reagent_containers/cup/bottle/oxygen,
					/obj/item/reagent_containers/cup/bottle/fluorine,
					/obj/item/reagent_containers/cup/bottle/phosphorus,
					/obj/item/reagent_containers/cup/bottle/silicon,
					/obj/item/reagent_containers/cup/bottle/chlorine,
					/obj/item/reagent_containers/cup/bottle/radium,
					/obj/item/reagent_containers/cup/bottle/sacid,
					/obj/item/reagent_containers/cup/bottle/ethanol,
					/obj/item/reagent_containers/cup/bottle/potassium,
					/obj/item/reagent_containers/cup/bottle/sugar,
					/obj/item/clothing/glasses/science,
					/obj/item/reagent_containers/dropper,
					/obj/item/storage/box/beakers)
	crate_name = "chemical crate"

//////////////////////////////////////////////////////////////////////////////
//////////////////////////// Reagent /////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
/datum/supply_pack/reagent
	group = "Reagents"
	crate_type = /obj/structure/closet/crate/medical

/datum/supply_pack/reagent/chemical_carts
	name = "Full Chemistry Cartridge Pack"
	desc = "Contains a full set of chem dispenser cartridges with every chemical you'll need for making pharmaceuticals."
	cost = CARGO_CRATE_VALUE * 35 //price may need balancing
	crate_name = "chemical cartridges crate"

/datum/supply_pack/reagent/chemical_carts/New()
	. = ..()
	set_cart_list()

//this is just here for subtypes
/datum/supply_pack/reagent/chemical_carts/proc/set_cart_list()
	//contains = GLOB.cartridge_list_chems.Copy()

/datum/supply_pack/reagent/chemical_carts/fill(obj/structure/closet/crate/crate)
	for(var/datum/reagent/chem as anything in contains)
		var/obj/item/reagent_containers/chem_cartridge/cartridge = contains[chem]
		cartridge = new cartridge(crate)
		if(admin_spawned)
			cartridge.flags_1 |= ADMIN_SPAWNED_1
		cartridge.setLabel(initial(chem.name))
		cartridge.reagents.add_reagent(chem, cartridge.volume)

/datum/supply_pack/reagent/chemical_carts_empty
	name = "Empty Chemical Cartridge Pack"
	desc = "A pack of empty cartridges for use in chem dispensers."
	cost = CARGO_CRATE_VALUE * 6
	contains = list(/obj/item/reagent_containers/chem_cartridge/large,
					/obj/item/reagent_containers/chem_cartridge/large,
					/obj/item/reagent_containers/chem_cartridge/medium,
					/obj/item/reagent_containers/chem_cartridge/medium,
					/obj/item/reagent_containers/chem_cartridge/medium,
					/obj/item/reagent_containers/chem_cartridge/small,
					/obj/item/reagent_containers/chem_cartridge/small,
					/obj/item/reagent_containers/chem_cartridge/small)
	crate_name = "empty chemical cartridges crate"

/datum/supply_pack/reagent/chemical_carts/soft_drinks_chem_cartridge //IGNORE THE TYPEPATH PLEASE
	name = "Soft Drinks Cartridge Luxury Pack (Full Dispenser)"
	desc = "Contains a full set of chem cartridges of the same size inside a soft drinks dispenser at shift start."
	cost = CARGO_CRATE_VALUE * 25

/datum/supply_pack/reagent/chemical_carts/soft_drinks_chem_cartridge/set_cart_list()
	contains = GLOB.cartridge_list_drinks.Copy()

/datum/supply_pack/reagent/chemical_carts/booze_chem_cartridge
	name = "Booze Cartridge Luxury Pack (Full Dispenser)"
	desc = "Contains a full set of chem cartridges of the same size inside a booze dispenser at shift start."
	cost = CARGO_CRATE_VALUE * 30

/datum/supply_pack/reagent/chemical_carts/booze_chem_cartridge/set_cart_list()
	contains = GLOB.cartridge_list_booze.Copy()

/datum/supply_pack/reagent/individual_chem_cart

/datum/supply_pack/reagent/individual_chem_cart/generate_supply_packs()
	if(contains) // Prevent infinite recursion
		return

	. = list()

	// The absolute minimum cost of a reagent crate is what the reagents come in.
	var/base_cost = /datum/export/chem_cartridge/medium::cost + CARGO_CRATE_VALUE
	var/volume = /obj/item/reagent_containers/chem_cartridge/medium::volume

	for(var/datum/reagent/reagent_path as anything in GLOB.cartridge_list_chems | GLOB.cartridge_list_botany | GLOB.cartridge_list_booze | GLOB.cartridge_list_drinks)
		var/datum/supply_pack/reagent/individual_chem_cart/pack = new
		var/name = initial(reagent_path.name)
		pack.name = "Crate of [name]"
		pack.desc = "Contains [volume]u of [name]."
		pack.crate_name = "reagent crate ([name])"
		pack.id = "[type]([name])"

		pack.cost = round(base_cost + (initial(reagent_path.value) * volume), 5)

		pack.contains = list(reagent_path)

		pack.crate_type = crate_type

		. += pack

/datum/supply_pack/reagent/individual_chem_cart/fill(obj/structure/closet/crate/crate)
	var/datum/reagent/reagent_path = contains[1]
	for(var/i in 1 to 3)
		var/obj/item/reagent_containers/chem_cartridge/medium/cartridge = new(crate)
		if(admin_spawned)
			cartridge.flags_1 |= ADMIN_SPAWNED_1

		cartridge.setLabel(initial(reagent_path.name))
		cartridge.reagents.add_reagent(reagent_path, cartridge.volume)

/datum/supply_pack/medical/defibs
	name = "Defibrillator Crate"
	desc = "Contains two defibrillators for bringing the recently deceased back to life."
	cost = CARGO_CRATE_VALUE * 5
	contains = list(/obj/item/defibrillator/loaded,
					/obj/item/defibrillator/loaded)
	crate_name = "defibrillator crate"

/datum/supply_pack/medical/iv_drip
	name = "IV Drip Crate"
	desc = "Contains a single IV drip for administering blood to patients."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/machinery/iv_drip)
	crate_name = "iv drip crate"

/datum/supply_pack/medical/supplies
	name = "Medical Supplies Crate"
	desc = "Contains several medical supplies. German doctor not included."
	cost = CARGO_CRATE_VALUE * 4
	contains = list(/obj/item/reagent_containers/cup/bottle/dylovene,
					/obj/item/reagent_containers/cup/bottle/epinephrine,
					/obj/item/reagent_containers/cup/bottle/morphine,
					/obj/item/reagent_containers/cup/bottle/toxin,
					/obj/item/reagent_containers/cup/beaker/large,
					/obj/item/reagent_containers/pill/insulin,
					/obj/item/stack/gauze,
					/obj/item/storage/box/beakers,
					/obj/item/storage/box/medigels,
					/obj/item/storage/box/syringes,
					/obj/item/storage/box/bodybags,
					/obj/item/storage/medkit/regular,
					/obj/item/storage/medkit/o2,
					/obj/item/storage/medkit/toxin,
					/obj/item/storage/medkit/brute,
					/obj/item/storage/medkit/fire,
					/obj/item/defibrillator/loaded,
					/obj/item/reagent_containers/blood/o_minus,
					/obj/item/storage/pill_bottle/mining,
					/obj/item/reagent_containers/pill/alkysine,
					/obj/item/stack/medical/bone_gel/twelve,
					/obj/item/stack/medical/bone_gel/twelve,
					/obj/item/vending_refill/medical,
					/obj/item/vending_refill/drugs)
	crate_name = "medical supplies crate"

/datum/supply_pack/medical/supplies/fill(obj/structure/closet/crate/C)
	for(var/i in 1 to 10)
		var/item = pick(contains)
		new item(C)

/datum/supply_pack/medical/surgery
	name = "Surgical Supplies Crate"
	desc = "Do you want to perform surgery, but don't have one of those fancy shmancy degrees? Just get started with this crate containing a medical duffelbag, Sterilizine spray and collapsible roller bed."
	cost = CARGO_CRATE_VALUE * 6
	contains = list(/obj/item/storage/backpack/duffelbag/med/surgery,
					/obj/item/roller)
	crate_name = "surgical supplies crate"

/datum/supply_pack/medical/salglucanister
	name = "Heavy-Duty Saline Canister"
	desc = "Contains a bulk supply of saline-glucose condensed into a single canister that should last several days, with a large pump to fill containers with. Direct injection of saline should be left to medical professionals as the pump is capable of overdosing patients. Requires medbay access to open."
	cost = CARGO_CRATE_VALUE * 6
	access = ACCESS_MEDICAL
	contains = list(/obj/machinery/iv_drip/saline)

/datum/supply_pack/medical/virus
	name = "Virus Crate"
	desc = "Contains twelve different bottles, containing several viral samples for virology research. Also includes seven beakers and syringes. Balled-up jeans not included. Requires CMO access to open."
	cost = CARGO_CRATE_VALUE * 5
	access = ACCESS_CMO
	access_view = ACCESS_MEDICAL
	contains = list(/obj/item/reagent_containers/cup/bottle/flu_virion,
					/obj/item/reagent_containers/cup/bottle/cold,
					/obj/item/reagent_containers/cup/bottle/random_virus,
					/obj/item/reagent_containers/cup/bottle/random_virus,
					/obj/item/reagent_containers/cup/bottle/random_virus,
					/obj/item/reagent_containers/cup/bottle/random_virus,
					/obj/item/reagent_containers/cup/bottle/fake_gbs,
					/obj/item/reagent_containers/cup/bottle/magnitis,
					/obj/item/reagent_containers/cup/bottle/pierrot_throat,
					/obj/item/reagent_containers/cup/bottle/brainrot,
					/obj/item/reagent_containers/cup/bottle/anxiety,
					/obj/item/reagent_containers/cup/bottle/beesease,
					/obj/item/storage/box/syringes,
					/obj/item/storage/box/beakers,
					/obj/item/reagent_containers/cup/bottle/mutagen)
	crate_name = "virus crate"
	crate_type = /obj/structure/closet/crate/secure/plasma
	dangerous = TRUE

/datum/supply_pack/medical/cmoturtlenecks
	name = "Medical Director Turtlenecks"
	desc = "Contains the CMO's turtleneck and turtleneck skirt. Requires CMO access to open."
	cost = CARGO_CRATE_VALUE * 2
	access = ACCESS_CMO
	contains = list(/obj/item/clothing/under/rank/medical/chief_medical_officer/turtleneck,
					/obj/item/clothing/under/rank/medical/chief_medical_officer/turtleneck/skirt)

/datum/supply_pack/medical/atk
	name = "Triage - Advanced trauma supplies"
	desc = "It's a bunch of bruise packs in a trenchcoat."
	cost = CARGO_CRATE_VALUE * 3
	crate_name = "advanced trauma crate"
	contains = list(
		/obj/item/stack/medical/bruise_pack,
		/obj/item/stack/medical/bruise_pack,
		/obj/item/stack/medical/bruise_pack,
		/obj/item/stack/medical/suture,
		/obj/item/stack/medical/suture,
		/obj/item/stack/medical/suture,
	)

/datum/supply_pack/medical/stasis_bags
	name = "Stasis Bags Crate"
	desc = "A shipment of stasis bags for medical triage."
	cost = CARGO_CRATE_VALUE * 8
	contains = list(
		/obj/item/bodybag/stasis,
		/obj/item/bodybag/stasis,
		/obj/item/bodybag/stasis,
	)

//////////////////////////////////////////////////////////////////////////////
//////////////////////////// Science /////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/science
	group = "Science"
	access_view = ACCESS_RESEARCH
	crate_type = /obj/structure/closet/crate/science

/datum/supply_pack/science/plasma
	name = "Plasma Assembly Crate"
	desc = "Everything you need to burn something to the ground, this contains three plasma assembly sets. Each set contains a plasma tank, igniter, proximity sensor, and timer! Warranty void if exposed to high temperatures. Requires Ordnance access to open."
	cost = CARGO_CRATE_VALUE * 2
	access = ACCESS_ORDNANCE
	access_view = ACCESS_ORDNANCE
	contains = list(/obj/item/tank/internals/plasma,
					/obj/item/tank/internals/plasma,
					/obj/item/tank/internals/plasma,
					/obj/item/assembly/igniter,
					/obj/item/assembly/igniter,
					/obj/item/assembly/igniter,
					/obj/item/assembly/prox_sensor,
					/obj/item/assembly/prox_sensor,
					/obj/item/assembly/prox_sensor,
					/obj/item/assembly/timer,
					/obj/item/assembly/timer,
					/obj/item/assembly/timer)
	crate_name = "plasma assembly crate"
	crate_type = /obj/structure/closet/crate/secure/plasma

/datum/supply_pack/science/raw_flux_anomaly
	name = "Raw Flux Anomaly"
	desc = "The raw core of a flux anomaly, ready to be implosion-compressed into a powerful artifact."
	cost = CARGO_CRATE_VALUE * 10
	access = ACCESS_ORDNANCE
	access_view = ACCESS_ORDNANCE
	contains = list(/obj/item/raw_anomaly_core/flux)
	crate_name = "raw flux anomaly"
	crate_type = /obj/structure/closet/crate/secure/science

/datum/supply_pack/science/raw_grav_anomaly
	name = "Raw Gravitational Anomaly"
	desc = "The raw core of a gravitational anomaly, ready to be implosion-compressed into a powerful artifact."
	cost = CARGO_CRATE_VALUE * 10
	access = ACCESS_ORDNANCE
	access_view = ACCESS_ORDNANCE
	contains = list(/obj/item/raw_anomaly_core/grav)
	crate_name = "raw gravitational anomaly"
	crate_type = /obj/structure/closet/crate/secure/science

/datum/supply_pack/science/raw_vortex_anomaly
	name = "Raw Vortex Anomaly"
	desc = "The raw core of a vortex anomaly, ready to be implosion-compressed into a powerful artifact."
	cost = CARGO_CRATE_VALUE * 10
	access = ACCESS_ORDNANCE
	access_view = ACCESS_ORDNANCE
	contains = list(/obj/item/raw_anomaly_core/vortex)
	crate_name = "raw vortex anomaly"
	crate_type = /obj/structure/closet/crate/secure/science

/datum/supply_pack/science/raw_bluespace_anomaly
	name = "Raw Bluespace Anomaly"
	desc = "The raw core of a bluespace anomaly, ready to be implosion-compressed into a powerful artifact."
	cost = CARGO_CRATE_VALUE * 10
	access = ACCESS_ORDNANCE
	access_view = ACCESS_ORDNANCE
	contains = list(/obj/item/raw_anomaly_core/bluespace)
	crate_name = "raw bluespace anomaly"
	crate_type = /obj/structure/closet/crate/secure/science

/datum/supply_pack/science/raw_pyro_anomaly
	name = "Raw Pyro Anomaly"
	desc = "The raw core of a pyro anomaly, ready to be implosion-compressed into a powerful artifact."
	cost = CARGO_CRATE_VALUE * 10
	access = ACCESS_ORDNANCE
	access_view = ACCESS_ORDNANCE
	contains = list(/obj/item/raw_anomaly_core/pyro)
	crate_name = "raw pyro anomaly"
	crate_type = /obj/structure/closet/crate/secure/science

/datum/supply_pack/science/robotics
	name = "Robotics Assembly Crate"
	desc = "The tools you need to replace those finicky humans with a loyal robot army! Contains four proximity sensors, two empty first aid kits, two health analyzers, two red hardhats, two mechanical toolboxes, and two cleanbot assemblies! Requires Robotics access to open."
	cost = CARGO_CRATE_VALUE * 3
	access = ACCESS_ROBOTICS
	access_view = ACCESS_ROBOTICS
	contains = list(/obj/item/assembly/prox_sensor,
					/obj/item/assembly/prox_sensor,
					/obj/item/assembly/prox_sensor,
					/obj/item/assembly/prox_sensor,
					/obj/item/storage/medkit,
					/obj/item/storage/medkit,
					/obj/item/healthanalyzer,
					/obj/item/healthanalyzer,
					/obj/item/clothing/head/hardhat/red,
					/obj/item/clothing/head/hardhat/red,
					/obj/item/storage/toolbox/mechanical,
					/obj/item/storage/toolbox/mechanical,
					/obj/item/bot_assembly/cleanbot,
					/obj/item/bot_assembly/cleanbot)
	crate_name = "robotics assembly crate"
	crate_type = /obj/structure/closet/crate/secure/science

/datum/supply_pack/science/rped
	name = "RPED crate"
	desc = "Need to rebuild the ORM but science got annihialted after a bomb test? Buy this for the most advanced parts NT can give you."
	cost = CARGO_CRATE_VALUE * 3
	access_view = FALSE
	contains = list(/obj/item/storage/part_replacer/cargo)
	crate_name = "\improper RPED crate"

/datum/supply_pack/science/shieldwalls
	name = "Shield Generator Crate"
	desc = "These high powered Shield Wall Generators are guaranteed to keep any unwanted lifeforms on the outside, where they belong! Contains four shield wall generators. Requires Teleporter access to open."
	cost = CARGO_CRATE_VALUE * 4
	access = ACCESS_TELEPORTER
	access_view = ACCESS_TELEPORTER
	contains = list(/obj/machinery/power/shieldwallgen,
					/obj/machinery/power/shieldwallgen,
					/obj/machinery/power/shieldwallgen,
					/obj/machinery/power/shieldwallgen)
	crate_name = "shield generators crate"
	crate_type = /obj/structure/closet/crate/secure/science

/datum/supply_pack/science/transfer_valves
	name = "Tank Transfer Valves Crate"
	desc = "The key ingredient for making a lot of people very angry very fast. Contains two tank transfer valves. Requires RD access to open."
	cost = CARGO_CRATE_VALUE * 12
	access = ACCESS_RD
	contains = list(/obj/item/transfer_valve,
					/obj/item/transfer_valve)
	crate_name = "tank transfer valves crate"
	crate_type = /obj/structure/closet/crate/secure/science
	dangerous = TRUE

/datum/supply_pack/science/monkey_helmets
	name = "Monkey Mind Magnification Helmet crate"
	desc = "Some research is best done with monkeys, yet sometimes they're just too dumb to complete more complicated tasks. These helmets should help."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/clothing/head/helmet/monkey_sentience,
					/obj/item/clothing/head/helmet/monkey_sentience)
	crate_name = "monkey mind magnification crate"

/datum/supply_pack/science/mod_core
	name = "MOD core Crate"
	desc = "Three cores, perfect for any MODsuit construction! Naturally harvested™, of course."
	cost = CARGO_CRATE_VALUE * 3
	access = ACCESS_ROBOTICS
	access_view = ACCESS_ROBOTICS
	contains = list(/obj/item/mod/core/standard,
		/obj/item/mod/core/standard,
		/obj/item/mod/core/standard)
	crate_name = "\improper MOD core crate"
	crate_type = /obj/structure/closet/crate/secure/science

//////////////////////////////////////////////////////////////////////////////
/////////////////////////////// Service //////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/service
	group = "Service"

/datum/supply_pack/service/cargo_supples
	name = "Cargo Supplies Crate"
	desc = "Sold everything that wasn't bolted down? You can get right back to work with this crate containing stamps, an export scanner, destination tagger, hand labeler and some package wrapping."
	cost = CARGO_CRATE_VALUE * 1.75
	contains = list(/obj/item/stamp,
					/obj/item/stamp/denied,
					/obj/item/export_scanner,
					/obj/item/dest_tagger,
					/obj/item/hand_labeler,
					/obj/item/stack/package_wrap)
	crate_name = "cargo supplies crate"

/datum/supply_pack/service/noslipfloor
	name = "High-traction Floor Tiles"
	desc = "Make slipping a thing of the past with thirty industrial-grade anti-slip floor tiles!"
	cost = CARGO_CRATE_VALUE * 4
	access_view = ACCESS_JANITOR
	contains = list(/obj/item/stack/tile/noslip/thirty)
	crate_name = "high-traction floor tiles crate"

/datum/supply_pack/service/janitor
	name = "Janitorial Supplies Crate"
	desc = "Fight back against dirt and grime with Priapus' Janitorial Essentials(tm)! Contains three buckets, caution signs, and cleaner grenades. Also has two bear traps, a single mop, broom, spray cleaner, rag, and trash bag."
	cost = CARGO_CRATE_VALUE * 2
	access_view = ACCESS_JANITOR
	contains = list(/obj/item/reagent_containers/cup/bucket,
					/obj/item/reagent_containers/cup/bucket,
					/obj/item/reagent_containers/cup/bucket,
					/obj/item/mop,
					/obj/item/pushbroom,
					/obj/item/clothing/suit/caution,
					/obj/item/clothing/suit/caution,
					/obj/item/clothing/suit/caution,
					/obj/item/storage/bag/trash,
					/obj/item/reagent_containers/spray/cleaner,
					/obj/item/reagent_containers/cup/rag,
					/obj/item/grenade/chem_grenade/cleaner,
					/obj/item/grenade/chem_grenade/cleaner,
					/obj/item/grenade/chem_grenade/cleaner,
					/obj/item/restraints/legcuffs/beartrap,
					/obj/item/restraints/legcuffs/beartrap)
	crate_name = "janitorial supplies crate"

/datum/supply_pack/service/janitor/janicart
	name = "Janitorial Cart and Galoshes Crate"
	desc = "The keystone to any successful janitor. As long as you have feet, this pair of galoshes will keep them firmly planted on the ground. Also contains a janitorial cart."
	cost = CARGO_CRATE_VALUE * 4
	contains = list(/obj/structure/janitorialcart,
					/obj/item/clothing/shoes/galoshes)
	crate_name = "janitorial cart crate"
	crate_type = /obj/structure/closet/crate/large

/datum/supply_pack/service/janitor/janitank
	name = "Janitor Backpack Crate"
	desc = "Call forth divine judgement upon dirt and grime with this high capacity janitor backpack. Contains 500 units of station-cleansing cleaner. Requires janitor access to open."
	cost = CARGO_CRATE_VALUE * 2
	access = ACCESS_JANITOR
	contains = list(/obj/item/watertank/janitor)
	crate_name = "janitor backpack crate"
	crate_type = /obj/structure/closet/crate/secure

/datum/supply_pack/service/mule
	name = "MULEbot Crate"
	desc = "Pink-haired Quartermaster not doing her job? Replace her with this tireless worker, today!"
	cost = CARGO_CRATE_VALUE * 4
	contains = list(/mob/living/simple_animal/bot/mulebot)
	crate_name = "\improper MULEbot Crate"
	crate_type = /obj/structure/closet/crate/large

/datum/supply_pack/service/party
	name = "Party Equipment"
	desc = "Celebrate both life and death on the station with Priapus' Party Essentials(tm)! Contains seven colored glowsticks, six beers, six sodas, two ales, and a bottle of patron, goldschlager, and shaker!"
	cost = CARGO_CRATE_VALUE * 5
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

/datum/supply_pack/service/carpet
	name = "Premium Carpet Crate"
	desc = "Iron floor tiles getting on your nerves? These stacks of extra soft carpet will tie any room together."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/stack/tile/carpet/fifty,
					/obj/item/stack/tile/carpet/fifty,
					/obj/item/stack/tile/carpet/black/fifty,
					/obj/item/stack/tile/carpet/black/fifty)
	crate_name = "premium carpet crate"

/datum/supply_pack/service/carpet_exotic
	name = "Exotic Carpet Crate"
	desc = "Exotic carpets straight from Space Russia, for all your decorating needs. Contains 100 tiles each of 8 different flooring patterns."
	cost = CARGO_CRATE_VALUE * 8
	contains = list(/obj/item/stack/tile/carpet/blue/fifty,
					/obj/item/stack/tile/carpet/blue/fifty,
					/obj/item/stack/tile/carpet/cyan/fifty,
					/obj/item/stack/tile/carpet/cyan/fifty,
					/obj/item/stack/tile/carpet/green/fifty,
					/obj/item/stack/tile/carpet/green/fifty,
					/obj/item/stack/tile/carpet/orange/fifty,
					/obj/item/stack/tile/carpet/orange/fifty,
					/obj/item/stack/tile/carpet/purple/fifty,
					/obj/item/stack/tile/carpet/purple/fifty,
					/obj/item/stack/tile/carpet/red/fifty,
					/obj/item/stack/tile/carpet/red/fifty,
					/obj/item/stack/tile/carpet/royalblue/fifty,
					/obj/item/stack/tile/carpet/royalblue/fifty,
					/obj/item/stack/tile/carpet/royalblack/fifty,
					/obj/item/stack/tile/carpet/royalblack/fifty)
	crate_name = "exotic carpet crate"

/datum/supply_pack/service/carpet_neon
	name = "Simple Neon Carpet Crate"
	desc = "Simple rubbery mats with phosphorescent lining. Contains 120 tiles each of 13 color variants. Limited edition release."
	cost = CARGO_CRATE_VALUE * 15
	contains = list(
		/obj/item/stack/tile/carpet/neon/simple/white/sixty,
		/obj/item/stack/tile/carpet/neon/simple/white/sixty,
		/obj/item/stack/tile/carpet/neon/simple/black/sixty,
		/obj/item/stack/tile/carpet/neon/simple/black/sixty,
		/obj/item/stack/tile/carpet/neon/simple/red/sixty,
		/obj/item/stack/tile/carpet/neon/simple/red/sixty,
		/obj/item/stack/tile/carpet/neon/simple/orange/sixty,
		/obj/item/stack/tile/carpet/neon/simple/orange/sixty,
		/obj/item/stack/tile/carpet/neon/simple/yellow/sixty,
		/obj/item/stack/tile/carpet/neon/simple/yellow/sixty,
		/obj/item/stack/tile/carpet/neon/simple/lime/sixty,
		/obj/item/stack/tile/carpet/neon/simple/lime/sixty,
		/obj/item/stack/tile/carpet/neon/simple/green/sixty,
		/obj/item/stack/tile/carpet/neon/simple/green/sixty,
		/obj/item/stack/tile/carpet/neon/simple/teal/sixty,
		/obj/item/stack/tile/carpet/neon/simple/teal/sixty,
		/obj/item/stack/tile/carpet/neon/simple/cyan/sixty,
		/obj/item/stack/tile/carpet/neon/simple/cyan/sixty,
		/obj/item/stack/tile/carpet/neon/simple/blue/sixty,
		/obj/item/stack/tile/carpet/neon/simple/blue/sixty,
		/obj/item/stack/tile/carpet/neon/simple/purple/sixty,
		/obj/item/stack/tile/carpet/neon/simple/purple/sixty,
		/obj/item/stack/tile/carpet/neon/simple/violet/sixty,
		/obj/item/stack/tile/carpet/neon/simple/violet/sixty,
		/obj/item/stack/tile/carpet/neon/simple/pink/sixty,
		/obj/item/stack/tile/carpet/neon/simple/pink/sixty,
	)
	crate_name = "neon carpet crate"

/datum/supply_pack/service/lightbulbs
	name = "Replacement Lights"
	desc = "May the light of Aether shine upon this station! Or at least, the light of forty two light tubes and twenty one light bulbs."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/storage/box/lights/mixed,
					/obj/item/storage/box/lights/mixed,
					/obj/item/storage/box/lights/mixed)
	crate_name = "replacement lights"

/datum/supply_pack/service/minerkit
	name = "Shaft Miner Starter Kit"
	desc = "All the miners died too fast? Assistant wants to get a taste of life off-station? Either way, this kit is the best way to turn a regular crewman into an ore-producing, monster-slaying machine. Contains meson goggles, a pickaxe, advanced mining scanner, cargo headset, ore bag, gasmask, an explorer suit and a miner ID upgrade. Requires QM access to open."
	cost = CARGO_CRATE_VALUE * 4
	access = ACCESS_QM
	access_view = ACCESS_CARGO
	contains = list(/obj/item/storage/backpack/duffelbag/mining_conscript)
	crate_name = "shaft miner starter kit"
	crate_type = /obj/structure/closet/crate/secure

/datum/supply_pack/service/survivalknives
	name = "Survival Knives Crate"
	desc = "Contains three sharpened survival knives. Each knife guaranteed to fit snugly inside any standard boot."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/knife/combat/survival,
					/obj/item/knife/combat/survival,
					/obj/item/knife/combat/survival)
	crate_name = "survival knife crate"

/datum/supply_pack/service/wedding
	name = "Wedding Crate"
	desc = "Everything you need to host a wedding! Now you just need an officiant."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/clothing/under/dress/wedding_dress,
					/obj/item/clothing/under/suit/tuxedo,
					/obj/item/storage/belt/cummerbund,
					/obj/item/clothing/head/weddingveil,
					/obj/item/bouquet,
					/obj/item/bouquet/sunflower,
					/obj/item/bouquet/poppy,
					/obj/item/reagent_containers/cup/glass/bottle/champagne)
	crate_name = "wedding crate"

/// Box of 7 grey IDs.
/datum/supply_pack/service/greyidbox
	name = "Grey ID Card Multipack Cate"
	desc = "A convenient crate containing a box of cheap ID cards in a handy wallet-sized form factor. Cards come in every colour you can imagne, as long as it's grey."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/storage/box/ids)
	crate_name = "basic id card crate"

/// Single silver ID.
/datum/supply_pack/service/silverid
	name = "Silver ID Card Crate"
	desc = "Did we forget to hire any Heads of Staff? Recruit your own with this high value ID card capable of holding advanced levels of access in a handy wallet-sized form factor"
	cost = CARGO_CRATE_VALUE * 7
	contains = list(/obj/item/card/id/advanced/silver)
	crate_name = "silver id card crate"

/datum/supply_pack/service/emptycrate
	name = "Empty Crate"
	desc = "It's an empty crate, for all your storage needs."
	cost = CARGO_CRATE_VALUE * 1.4 //Net Zero Profit.
	contains = list()
	crate_name = "crate"

/datum/supply_pack/service/randomized/donkpockets
	name = "Donk Pocket Variety Crate"
	desc = "Featuring a line up of Donk Co.'s most popular pastry!"
	cost = CARGO_CRATE_VALUE * 4
	contains = list(/obj/item/storage/box/donkpockets/donkpocketspicy,
	/obj/item/storage/box/donkpockets/donkpocketteriyaki,
	/obj/item/storage/box/donkpockets/donkpocketpizza,
	/obj/item/storage/box/donkpockets/donkpocketberry,
	/obj/item/storage/box/donkpockets/donkpockethonk)
	crate_name = "donk pocket crate"

/datum/supply_pack/service/randomized/donkpockets/fill(obj/structure/closet/crate/C)
	for(var/i in 1 to 3)
		var/item = pick(contains)
		new item(C)

/datum/supply_pack/service/randomized/ready_donk
	name = "Ready-Donk Variety Crate"
	desc = "Featuring a line up of Donk Co.'s most popular pastry!"
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/food/ready_donk,
	/obj/item/food/ready_donk/mac_n_cheese,
	/obj/item/food/ready_donk/donkhiladas)
	crate_name = "\improper Ready-Donk crate"

/datum/supply_pack/service/randomized/ready_donk/fill(obj/structure/closet/crate/C)
	for(var/i in 1 to 3)
		var/item = pick(contains)
		new item(C)

/datum/supply_pack/service/trolley
	name = "Trolley Crate"
	desc = "A crate containing a single trolley for transporting upto three crates at once."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/vehicle/ridden/trolley)
	crate_name = "trolley crate"

//////////////////////////////////////////////////////////////////////////////
//////////////////////////// Organic /////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/organic
	group = "Food & Hydroponics"
	crate_type = /obj/structure/closet/crate/freezer

/datum/supply_pack/organic/hydroponics
	access_view = ACCESS_HYDROPONICS

/datum/supply_pack/organic/hydroponics/beekeeping_suits
	name = "Beekeeper Suit Crate"
	desc = "Bee business booming? Better be benevolent and boost botany by bestowing bi-Beekeeper-suits! Contains two beekeeper suits and matching headwear."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/clothing/head/beekeeper_head,
					/obj/item/clothing/suit/beekeeper_suit,
					/obj/item/clothing/head/beekeeper_head,
					/obj/item/clothing/suit/beekeeper_suit)
	crate_name = "beekeeper suits"
	crate_type = /obj/structure/closet/crate/hydroponics

/datum/supply_pack/organic/hydroponics/beekeeping_fullkit
	name = "Beekeeping Starter Crate"
	desc = "BEES BEES BEES. Contains three honey frames, a beekeeper suit and helmet, flyswatter, bee house, and, of course, a pure-bred Priapus-Standardized Queen Bee!"
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/structure/beebox/unwrenched,
					/obj/item/honey_frame,
					/obj/item/honey_frame,
					/obj/item/honey_frame,
					/obj/item/queen_bee/bought,
					/obj/item/clothing/head/beekeeper_head,
					/obj/item/clothing/suit/beekeeper_suit,
					/obj/item/melee/flyswatter)
	crate_name = "beekeeping starter crate"
	crate_type = /obj/structure/closet/crate/hydroponics

/datum/supply_pack/organic/randomized/chef
	name = "Excellent Meat Crate"
	desc = "The best cuts in the whole galaxy."
	cost = CARGO_CRATE_VALUE * 4
	contains = list(/obj/item/food/meat/slab/human/mutant/slime,
					/obj/item/food/meat/slab/killertomato,
					/obj/item/food/meat/slab/bear,
					/obj/item/food/meat/slab/xeno,
					/obj/item/food/meat/slab/spider,
					/obj/item/food/meat/rawbacon,
					/obj/item/food/meat/slab/penguin,
					/obj/item/food/spiderleg,
					/obj/item/food/fishmeat/carp,
					/obj/item/food/meat/slab/human)
	crate_name = "food crate"

/datum/supply_pack/organic/randomized/chef/fill(obj/structure/closet/crate/C)
	for(var/i in 1 to 15)
		var/item = pick(contains)
		new item(C)

/datum/supply_pack/organic/exoticseeds
	name = "Exotic Seeds Crate"
	desc = "Any entrepreneuring botanist's dream. Contains fourteen different seeds, including one replica-pod seed and two mystery seeds!"
	cost = CARGO_CRATE_VALUE * 3
	access_view = ACCESS_HYDROPONICS
	contains = list(/obj/item/seeds/nettle,
					/obj/item/seeds/plump,
					/obj/item/seeds/liberty,
					/obj/item/seeds/amanita,
					/obj/item/seeds/reishi,
					/obj/item/seeds/bamboo,
					/obj/item/seeds/eggplant,
					/obj/item/seeds/rainbow_bunch,
					/obj/item/seeds/shrub,
					/obj/item/seeds/random,
					/obj/item/seeds/random)
	crate_name = "exotic seeds crate"
	crate_type = /obj/structure/closet/crate/hydroponics

/datum/supply_pack/organic/food
	name = "Food Crate"
	desc = "Get things cooking with this crate full of useful ingredients! Contains a dozen eggs, three bananas, and some flour, rice, milk, soymilk, salt, pepper, enzyme, sugar, and monkeymeat."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/reagent_containers/condiment/flour,
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
					/obj/item/food/grown/banana)
	crate_name = "food crate"

/datum/supply_pack/organic/randomized/chef/fruits
	name = "Fruit Crate"
	desc = "Rich of vitamins, may contain oranges."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/food/grown/citrus/lime,
					/obj/item/food/grown/citrus/orange,
					/obj/item/food/grown/watermelon,
					/obj/item/food/grown/apple,
					/obj/item/food/grown/berries,
					/obj/item/food/grown/citrus/lemon)
	crate_name = "food crate"

/datum/supply_pack/organic/cream_piee
	name = "High-yield Clown-grade Cream Pie Crate"
	desc = "Designed by Aussec's Advanced Warfare Research Division, these high-yield, Clown-grade cream pies are powered by a synergy of performance and efficiency. Guaranteed to provide maximum results."
	cost = CARGO_CRATE_VALUE * 12
	contains = list(/obj/item/storage/backpack/duffelbag/clown/cream_pie)
	crate_name = "party equipment crate"
	supply_flags = SUPPLY_PACK_CONTRABAND
	access = ACCESS_THEATRE
	access_view = ACCESS_THEATRE
	crate_type = /obj/structure/closet/crate/secure

/datum/supply_pack/organic/hydroponics
	name = "Hydroponics Crate"
	desc = "Supplies for growing a great garden! Contains two bottles of ammonia, two Plant-B-Gone spray bottles, a hatchet, cultivator, plant analyzer, as well as a pair of leather gloves and a botanist's apron."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/reagent_containers/spray/plantbgone,
					/obj/item/reagent_containers/spray/plantbgone,
					/obj/item/reagent_containers/cup/bottle/ammonia,
					/obj/item/reagent_containers/cup/bottle/ammonia,
					/obj/item/hatchet,
					/obj/item/plant_analyzer,
					/obj/item/clothing/gloves/botanic_leather,
					/obj/item/clothing/suit/apron)
	crate_name = "hydroponics crate"
	crate_type = /obj/structure/closet/crate/hydroponics

/datum/supply_pack/organic/hydroponics/hydrotank
	name = "Hydroponics Backpack Crate"
	desc = "Bring on the flood with this high-capacity backpack crate. Contains 500 units of life-giving H2O. Requires hydroponics access to open."
	cost = CARGO_CRATE_VALUE * 2
	access = ACCESS_HYDROPONICS
	contains = list(/obj/item/watertank)
	crate_name = "hydroponics backpack crate"
	crate_type = /obj/structure/closet/crate/secure

/datum/supply_pack/organic/pizza
	name = "Pizza Crate"
	desc = "Why visit the kitchen when you can have five random pizzas in a fraction of the time? \
			Best prices this side of the galaxy! All deliveries are guaranteed to be 99% anomaly-free."
	cost = CARGO_CRATE_VALUE * 10 // Best prices this side of the galaxy.
	contains = list(/obj/item/pizzabox/margherita,
					/obj/item/pizzabox/mushroom,
					/obj/item/pizzabox/meat,
					/obj/item/pizzabox/vegetable,
					/obj/item/pizzabox/pineapple)
	crate_name = "pizza crate"
	///Whether we've provided an infinite pizza box already this shift or not.
	var/static/anomalous_box_provided = FALSE
	///The percentage chance (per pizza) of this supply pack to spawn an anomalous pizza box.
	var/anna_molly_box_chance = 1
	///Total tickets in our figurative lottery (per pizza) to decide if we create a bomb box, and if so what type. 1 to 3 create a bomb. The rest do nothing.
	var/boombox_tickets = 100
	///Whether we've provided a bomb pizza box already this shift or not.
	var/boombox_provided = FALSE

/datum/supply_pack/organic/pizza/fill(obj/structure/closet/crate/C)
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

/datum/supply_pack/organic/pizza/proc/anomalous_pizza_report()
	print_command_report("[station_name()], our anomalous materials divison has reported a missing object that is highly likely to have been sent to your station during a routine cargo \
	delivery. Please search all crates and manifests provided with the delivery and return the object if is located. The object resembles a standard <b>\[DATA EXPUNGED\]</b> and is to be \
	considered <b>\[REDACTED\]</b> and returned at your leisure. Note that objects the anomaly produces are specifically attuned exactly to the individual opening the anomaly; regardless \
	of species, the individual will find the object edible and it will taste great according to their personal definitions, which vary significantly based on person and species.")

/datum/supply_pack/organic/potted_plants
	name = "Potted Plants Crate"
	desc = "Spruce up the station with these lovely plants! Contains a random assortment of five potted plants from Ananke's potted plant research division. Warranty void if thrown."
	cost = CARGO_CRATE_VALUE * 1.5
	contains = list(/obj/item/kirbyplants/random,
					/obj/item/kirbyplants/random,
					/obj/item/kirbyplants/random,
					/obj/item/kirbyplants/random,
					/obj/item/kirbyplants/random)
	crate_name = "potted plants crate"
	crate_type = /obj/structure/closet/crate/wooden

/datum/supply_pack/organic/seeds
	name = "Seeds Crate"
	desc = "Big things have small beginnings. Contains fifteen different seeds."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/seeds/chili,
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
					/obj/item/seeds/sugarcane)
	crate_name = "seeds crate"
	crate_type = /obj/structure/closet/crate/hydroponics

/datum/supply_pack/organic/randomized/chef/vegetables
	name = "Vegetables Crate"
	desc = "Grown in vats."
	cost = CARGO_CRATE_VALUE * 1.8
	contains = list(/obj/item/food/grown/chili,
					/obj/item/food/grown/corn,
					/obj/item/food/grown/tomato,
					/obj/item/food/grown/potato,
					/obj/item/food/grown/carrot,
					/obj/item/food/grown/mushroom/chanterelle,
					/obj/item/food/grown/onion,
					/obj/item/food/grown/pumpkin)
	crate_name = "food crate"

/datum/supply_pack/organic/grill
	name = "Grilling Starter Kit"
	desc = "Hey dad I'm Hungry. Hi Hungry I'm THE NEW GRILLING STARTER KIT ONLY 5000 BUX GET NOW! Contains a grill and fuel."
	cost = CARGO_CRATE_VALUE * 8
	crate_type = /obj/structure/closet/crate
	contains = list(/obj/item/stack/sheet/mineral/coal/five,
					/obj/machinery/grill/unwrenched,
					/obj/item/reagent_containers/cup/soda_cans/monkey_energy
					)
	crate_name = "grilling starter kit crate"

/datum/supply_pack/organic/grillfuel
	name = "Grilling Fuel Kit"
	desc = "Contains propane and propane accessories. (Note: doesn't contain any actual propane.)"
	cost = CARGO_CRATE_VALUE * 4
	crate_type = /obj/structure/closet/crate
	contains = list(/obj/item/stack/sheet/mineral/coal/ten,
					/obj/item/reagent_containers/cup/soda_cans/monkey_energy
					)
	crate_name = "grilling fuel kit crate"

//////////////////////////////////////////////////////////////////////////////
////////////////////////////// Livestock /////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/critter
	group = "Livestock"
	crate_type = /obj/structure/closet/crate/critter

/datum/supply_pack/critter/parrot
	name = "Bird Crate"
	desc = "Contains five expert telecommunication birds."
	cost = CARGO_CRATE_VALUE * 8
	access_view = ACCESS_CE
	contains = list(/mob/living/simple_animal/parrot)
	crate_name = "parrot crate"

/datum/supply_pack/critter/parrot/generate()
	. = ..()
	for(var/i in 1 to 4)
		new /mob/living/simple_animal/parrot(.)

/datum/supply_pack/critter/butterfly
	name = "Butterflies Crate"
	desc = "Not a very dangerous insect, but they do give off a better image than, say, flies or cockroaches."//is that a motherfucking worm reference
	supply_flags = SUPPLY_PACK_CONTRABAND
	cost = CARGO_CRATE_VALUE * 5
	access_view = ACCESS_THEATRE
	contains = list(/mob/living/simple_animal/butterfly)
	crate_name = "entomology samples crate"

/datum/supply_pack/critter/butterfly/generate()
	. = ..()
	for(var/i in 1 to 49)
		new /mob/living/simple_animal/butterfly(.)

/datum/supply_pack/critter/cat
	name = "Cat Crate"
	desc = "The cat goes meow! Comes with a collar and a nice cat toy! Cheeseburger not included."//i can't believe im making this reference
	cost = CARGO_CRATE_VALUE * 10 //Cats are worth as much as corgis.
	access_view = ACCESS_MEDICAL
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
	name = "Chicken Crate"
	desc = "The chicken goes bwaak!"
	cost = CARGO_CRATE_VALUE * 4
	access_view = ACCESS_KITCHEN
	contains = list( /mob/living/simple_animal/chick)
	crate_name = "chicken crate"

/datum/supply_pack/critter/corgi
	name = "Corgi Crate"
	desc = "Considered the optimal dog breed by thousands of research scientists, this Corgi is but one dog from the millions of Ian's noble bloodline. Comes with a cute collar!"
	cost = CARGO_CRATE_VALUE * 10
	access_view = ACCESS_DELEGATE
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
	name = "Cow Crate"
	desc = "The cow goes moo!"
	cost = CARGO_CRATE_VALUE * 6
	access_view = ACCESS_HYDROPONICS
	contains = list(/mob/living/basic/cow)
	crate_name = "cow crate"

/datum/supply_pack/critter/crab
	name = "Crab Rocket"
	desc = "CRAAAAAAB ROCKET. CRAB ROCKET. CRAB ROCKET. CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB ROCKET. CRAFT. ROCKET. BUY. CRAFT ROCKET. CRAB ROOOCKET. CRAB ROOOOCKET. CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB ROOOOOOOOOOOOOOOOOOOOOOCK EEEEEEEEEEEEEEEEEEEEEEEEE EEEETTTTTTTTTTTTAAAAAAAAA AAAHHHHHHHHHHHHH. CRAB ROCKET. CRAAAB ROCKEEEEEEEEEGGGGHHHHTT CRAB CRAB CRAABROCKET CRAB ROCKEEEET."//fun fact: i actually spent like 10 minutes and transcribed the entire video.
	cost = CARGO_CRATE_VALUE * 8
	access_view = ACCESS_HOS
	contains = list(/mob/living/simple_animal/crab)
	crate_name = "look sir free crabs"
	supply_flags = SUPPLY_PACK_DROPPOD_ONLY

/datum/supply_pack/critter/crab/generate()
	. = ..()
	for(var/i in 1 to 49)
		new /mob/living/simple_animal/crab(.)

/datum/supply_pack/critter/corgis/exotic
	name = "Exotic Corgi Crate"
	desc = "Corgis fit for a king, these corgis come in a unique color to signify their superiority. Comes with a cute collar!"
	cost = CARGO_CRATE_VALUE * 11
	contains = list(/mob/living/simple_animal/pet/dog/corgi/exoticcorgi,
					/obj/item/clothing/neck/petcollar)
	crate_name = "exotic corgi crate"

/datum/supply_pack/critter/fox
	name = "Fox Crate"
	desc = "The fox goes...? Comes with a collar!"//what does the fox say
	cost = CARGO_CRATE_VALUE * 10
	access_view = ACCESS_CAPTAIN
	contains = list(/mob/living/simple_animal/pet/fox,
					/obj/item/clothing/neck/petcollar)
	crate_name = "fox crate"

/datum/supply_pack/critter/goat
	name = "Goat Crate"
	desc = "The goat goes baa! Warranty void if used as a replacement for Pete."
	cost = CARGO_CRATE_VALUE * 5
	access_view = ACCESS_KITCHEN
	contains = list(/mob/living/simple_animal/hostile/retaliate/goat)
	crate_name = "goat crate"

/datum/supply_pack/critter/monkey
	name = "Monkey Cube Crate"
	desc = "Stop monkeying around! Contains seven monkey cubes. Just add water!"
	cost = CARGO_CRATE_VALUE * 4
	contains = list (/obj/item/storage/box/monkeycubes)
	crate_type = /obj/structure/closet/crate
	crate_name = "monkey cube crate"

/datum/supply_pack/critter/pug
	name = "Pug Crate"
	desc = "Like a normal dog, but... squished. Comes with a nice collar!"
	cost = CARGO_CRATE_VALUE * 10
	contains = list(/mob/living/simple_animal/pet/dog/pug,
					/obj/item/clothing/neck/petcollar)
	crate_name = "pug crate"

/datum/supply_pack/critter/bullterrier
	name = "Bull Terrier Crate"
	desc = "Like a normal dog, but with a head the shape of an egg. Comes with a nice collar!"
	cost = CARGO_CRATE_VALUE * 10
	contains = list(/mob/living/simple_animal/pet/dog/bullterrier,
					/obj/item/clothing/neck/petcollar)
	crate_name = "bull terrier crate"

/datum/supply_pack/critter/snake
	name = "Snake Crate"
	desc = "Tired of these MOTHER FUCKING snakes on this MOTHER FUCKING space station? Then this isn't the crate for you. Contains three poisonous snakes."
	cost = CARGO_CRATE_VALUE * 6
	access_view = ACCESS_SECURITY
	contains = list(/mob/living/simple_animal/hostile/retaliate/snake,
					/mob/living/simple_animal/hostile/retaliate/snake,
					/mob/living/simple_animal/hostile/retaliate/snake)
	crate_name = "snake crate"

//////////////////////////////////////////////////////////////////////////////
//////////////////////////// Costumes & Toys /////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/costumes_toys
	group = "Costumes & Toys"

/datum/supply_pack/costumes_toys/randomised
	name = "Collectable Hats Crate"
	desc = "Flaunt your status with three unique, highly-collectable hats!"
	cost = CARGO_CRATE_VALUE * 40
	var/num_contained = 3 //number of items picked to be contained in a randomised crate
	contains = list(/obj/item/clothing/head/collectable/chef,
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
					/obj/item/clothing/head/collectable/petehat)
	crate_name = "collectable hats crate"
	crate_type = /obj/structure/closet/crate/wooden

/datum/supply_pack/costumes_toys/randomised/contraband
	name = "Contraband Crate"
	desc = "Psst.. bud... want some contraband? I can get you a poster, some nice cigs, dank, even some sponsored items...you know, the good stuff. Just keep it away from the cops, kay?"
	supply_flags = SUPPLY_PACK_CONTRABAND
	cost = CARGO_CRATE_VALUE * 6
	num_contained = 7
	contains = list(/obj/item/poster/random_contraband,
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
					/obj/item/vending_refill/donksoft)
	crate_name = "crate"

/datum/supply_pack/costumes_toys/foamforce
	name = "Foam Force Crate"
	desc = "Break out the big guns with eight Foam Force shotguns!"
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/gun/ballistic/shotgun/toy,
					/obj/item/gun/ballistic/shotgun/toy,
					/obj/item/gun/ballistic/shotgun/toy,
					/obj/item/gun/ballistic/shotgun/toy,
					/obj/item/gun/ballistic/shotgun/toy,
					/obj/item/gun/ballistic/shotgun/toy,
					/obj/item/gun/ballistic/shotgun/toy,
					/obj/item/gun/ballistic/shotgun/toy)
	crate_name = "foam force crate"

/datum/supply_pack/costumes_toys/foamforce/bonus
	name = "Foam Force Pistols Crate"
	desc = "Psst.. hey bud... remember those old foam force pistols that got discontinued for being too cool? Well I got two of those right here with your name on em. I'll even throw in a spare mag for each, waddya say?"
	supply_flags = SUPPLY_PACK_CONTRABAND
	cost = CARGO_CRATE_VALUE * 8
	contains = list(/obj/item/gun/ballistic/automatic/pistol/toy,
					/obj/item/gun/ballistic/automatic/pistol/toy,
					/obj/item/ammo_box/magazine/toy/pistol,
					/obj/item/ammo_box/magazine/toy/pistol)
	crate_name = "foam force crate"

/datum/supply_pack/costumes_toys/formalwear
	name = "Formalwear Crate"
	desc = "You're gonna like the way you look, I guaranteed it. Contains an asston of fancy clothing."
	cost = CARGO_CRATE_VALUE * 4 //Lots of very expensive items. You gotta pay up to look good!
	contains = list(/obj/item/clothing/under/dress/blacktango,
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
					/obj/item/clothing/shoes/laceup,
					/obj/item/clothing/shoes/laceup,
					/obj/item/clothing/under/suit/charcoal,
					/obj/item/clothing/under/suit/navy,
					/obj/item/clothing/under/suit/burgundy,
					/obj/item/clothing/under/suit/checkered,
					/obj/item/clothing/under/suit/tan,
					/obj/item/lipstick/random)
	crate_name = "formalwear crate"
	crate_type = /obj/structure/closet/crate/wooden

/datum/supply_pack/costumes_toys/lasertag
	name = "Laser Tag Crate"
	desc = "Foam Force is for boys. Laser Tag is for men. Contains three sets of red suits, blue suits, matching helmets, and matching laser tag guns."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/gun/energy/laser/redtag,
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
					/obj/item/clothing/head/helmet/bluetaghelm)
	crate_name = "laser tag crate"

/datum/supply_pack/costumes_toys/lasertag/pins
	name = "Laser Tag Firing Pins Crate"
	desc = "Three laser tag firing pins used in laser-tag units to ensure users are wearing their vests."
	cost = CARGO_CRATE_VALUE * 3.5
	supply_flags = SUPPLY_PACK_CONTRABAND
	contains = list(/obj/item/storage/box/lasertagpins)
	crate_name = "laser tag crate"

/datum/supply_pack/costumes_toys/mech_suits
	name = "Mech Pilot's Suit Crate"
	desc = "Suits for piloting big robots. Contains four of those!"
	cost = CARGO_CRATE_VALUE * 3 //state-of-the-art technology doesn't come cheap
	contains = list(/obj/item/clothing/under/costume/mech_suit,
					/obj/item/clothing/under/costume/mech_suit,
					/obj/item/clothing/under/costume/mech_suit,
					/obj/item/clothing/under/costume/mech_suit)
	crate_name = "mech pilot's suit crate"
	crate_type = /obj/structure/closet/crate/wooden

/datum/supply_pack/costumes_toys/costume_original
	name = "Original Costume Crate"
	desc = "Reenact Shakespearean plays with this assortment of outfits. Contains eight different costumes!"
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/clothing/head/snowman,
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
					/obj/item/clothing/suit/hooded/bee_costume)
	crate_name = "original costume crate"
	crate_type = /obj/structure/closet/crate/wooden

/datum/supply_pack/costumes_toys/costume
	name = "Standard Costume Crate"
	desc = "Supply the station's entertainers with the equipment of their trade with these Priapus special-madecostumes! Contains a full clown and mime outfit, along with a bike horn and a bottle of nothing."
	cost = CARGO_CRATE_VALUE * 2
	access = ACCESS_THEATRE
	contains = list(/obj/item/storage/backpack/clown,
					/obj/item/clothing/shoes/clown_shoes,
					/obj/item/clothing/mask/gas/clown_hat,
					/obj/item/clothing/under/rank/civilian/clown,
					/obj/item/bikehorn,
					/obj/item/clothing/under/rank/civilian/mime,
					/obj/item/clothing/shoes/sneakers/black,
					/obj/item/clothing/gloves/color/white,
					/obj/item/clothing/mask/gas/mime,
					/obj/item/clothing/head/frenchberet,
					/obj/item/clothing/suit/toggle/suspenders,
					/obj/item/reagent_containers/cup/glass/bottle/bottleofnothing,
					/obj/item/storage/backpack/mime)
	crate_name = "standard costume crate"
	crate_type = /obj/structure/closet/crate/wooden

/datum/supply_pack/costumes_toys/randomised/toys
	name = "Toy Crate"
	desc = "Who cares about pride and accomplishment? Skip the gaming and get straight to the sweet rewards with this product! Contains five random toys. Warranty void if used to prank research directors."
	cost = CARGO_CRATE_VALUE * 8 // or play the arcade machines ya lazy bum
	num_contained = 5
	contains = list()
	crate_name = "toy crate"
	crate_type = /obj/structure/closet/crate/wooden

/datum/supply_pack/costumes_toys/randomised/toys/fill(obj/structure/closet/crate/C)
	var/the_toy
	for(var/i in 1 to num_contained)
		if(prob(50))
			the_toy = pick_weight(GLOB.arcade_prize_pool)
		else
			the_toy = pick(subtypesof(/obj/item/toy/plush))
		new the_toy(C)

/datum/supply_pack/costumes_toys/wizard
	name = "Wizard Costume Crate"
	desc = "Pretend to join the Wizard Federation with this full wizard outfit! Daedalus Industries would like to remind its employees that actually joining the Wizard Federation is subject to termination of job and life."
	cost = CARGO_CRATE_VALUE * 4
	contains = list(/obj/item/staff,
					/obj/item/clothing/suit/wizrobe/fake,
					/obj/item/clothing/shoes/sandal,
					/obj/item/clothing/head/wizard/fake)
	crate_name = "wizard costume crate"
	crate_type = /obj/structure/closet/crate/wooden

/datum/supply_pack/costumes_toys/randomised/fill(obj/structure/closet/crate/C)
	var/list/L = contains.Copy()
	for(var/i in 1 to num_contained)
		var/item = pick_n_take(L)
		new item(C)

/datum/supply_pack/costumes_toys/mafia
	name = "Cosa Nostra Starter Pack"
	desc = "This crate contains everything you need to set up your own ethnicity-based racketeering operation."
	cost = CARGO_CRATE_VALUE * 4
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

/datum/supply_pack/costumes_toys/randomised/tcg
	name = "Big-Ass Booster Pack Pack"
	desc = "A bumper load of NT TCG Booster Packs of varying series. Collect them all!"
	cost = 1000
	contains = list()
	crate_name = "booster pack pack"

/datum/supply_pack/costumes_toys/randomised/tcg/fill(obj/structure/closet/crate/C)
	var/cardpacktype
	for(var/i in 1 to 10)
		cardpacktype = pick(subtypesof(/obj/item/cardpack))
		new cardpacktype(C)

//////////////////////////////////////////////////////////////////////////////
//////////////////////////// Miscellaneous ///////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/misc
	group = "Miscellaneous Supplies"

/datum/supply_pack/misc/artsupply
	name = "Art Supplies"
	desc = "Make some happy little accidents with a rapid pipe cleaner layer, three spraycans, and lots of crayons!"
	cost = CARGO_CRATE_VALUE * 1.8
	contains = list(/obj/item/storage/toolbox/artistic,
					/obj/item/toy/crayon/spraycan,
					/obj/item/toy/crayon/spraycan,
					/obj/item/toy/crayon/spraycan,
					/obj/item/storage/crayons,
					/obj/item/toy/crayon/white,
					/obj/item/toy/crayon/rainbow)
	crate_name = "art supply crate"
	crate_type = /obj/structure/closet/crate/wooden

/datum/supply_pack/misc
	group = "Miscellaneous Supplies"

/datum/supply_pack/misc/aquarium_kit
	name = "Aquarium Kit"
	desc = "Everything you need to start your own aquarium. Contains aquarium construction kit, fish catalog, feed can and three freshwater fish from our collection."
	cost = CARGO_CRATE_VALUE * 5
	contains = list(/obj/item/book/fish_catalog,
					/obj/item/storage/fish_case/random/freshwater,
					/obj/item/storage/fish_case/random/freshwater,
					/obj/item/storage/fish_case/random/freshwater,
					/obj/item/fish_feed,
					/obj/item/storage/box/aquarium_props,
					/obj/item/aquarium_kit)
	crate_name = "aquarium kit crate"
	crate_type = /obj/structure/closet/crate/wooden

/datum/supply_pack/misc/aquarium_fish
	name = "Aquarium Fish Case"
	desc = "An aquarium fish bundle handpicked by monkeys from our collection."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/storage/fish_case/random,
					/obj/item/storage/fish_case/random,
					/obj/item/storage/fish_case/random)
	crate_name = "aquarium fish crate"

/datum/supply_pack/misc/freshwater_fish
	name = "Freshwater Fish Case"
	desc = "Aquarium fish that have had most of their mud cleaned off."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/storage/fish_case/random/freshwater,
					/obj/item/storage/fish_case/random/freshwater)
	crate_name = "freshwater fish crate"

/datum/supply_pack/misc/saltwater_fish
	name = "Saltwater Fish Case"
	desc = "Aquarium fish that fill the room with the smell of salt."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/storage/fish_case/random/saltwater,
					/obj/item/storage/fish_case/random/saltwater)
	crate_name = "saltwater fish crate"

/datum/supply_pack/misc/tiziran_fish
	name = "Jitarai Fish Case"
	desc = "Jitarai saltwater fish imported from the Zagos Sea."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/storage/fish_case/tiziran,
					/obj/item/storage/fish_case/tiziran)
	crate_name = "tiziran fish crate"

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
	cost = CARGO_CRATE_VALUE * 10
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
	name = "Book Crate"
	desc = "Surplus from the Core Worlds Archives, these seven books are sure to be good reads."
	cost = CARGO_CRATE_VALUE * 3
	access_view = ACCESS_LIBRARY
	contains = list(/obj/item/book/codex_gigas,
					/obj/item/book/manual/random/,
					/obj/item/book/manual/random/,
					/obj/item/book/manual/random/,
					/obj/item/book/random,
					/obj/item/book/random,
					/obj/item/book/random)
	crate_type = /obj/structure/closet/crate/wooden

/datum/supply_pack/misc/commandkeys
	name = "Management Encryption Key Crate"
	desc = "A pack of encryption keys that give access to the command radio network. Daedalus Industries reminds unauthorized employees not to eavesdrop in on secure communications channels, or at least to keep heckling of the command staff to a minimum."
	access_view = ACCESS_MANAGEMENT
	access = ACCESS_MANAGEMENT
	cost = CARGO_CRATE_VALUE * 4
	contains = list(/obj/item/encryptionkey/headset_com,
					/obj/item/encryptionkey/headset_com,
					/obj/item/encryptionkey/headset_com)
	crate_type = /obj/structure/closet/crate/secure
	crate_name = "command encryption key crate"

/datum/supply_pack/misc/exploration_drone
	name = "Exploration Drone"
	desc = "A replacement long-range exploration drone."
	cost = CARGO_CRATE_VALUE * 5
	contains = list(/obj/item/exodrone)
	crate_name = "exodrone crate"

/datum/supply_pack/misc/exploration_fuel
	name = "Drone Fuel Pellet"
	desc = "A fresh tank of exploration drone fuel."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/fuel_pellet)
	crate_name = "exodrone fuel crate"

/datum/supply_pack/misc/paper
	name = "Bureaucracy Crate"
	desc = "High stacks of papers on your desk Are a big problem - make it Pea-sized with these bureaucratic supplies! Contains six pens, some camera film, hand labeler supplies, a paper bin, a carbon paper bin, three folders, a laser pointer, two clipboards and two stamps."//that was too forced
	cost = CARGO_CRATE_VALUE * 3.2
	contains = list(/obj/structure/filingcabinet/chestdrawer/wheeled,
					/obj/item/camera_film,
					/obj/item/hand_labeler,
					/obj/item/hand_labeler_refill,
					/obj/item/hand_labeler_refill,
					/obj/item/paper_bin,
					/obj/item/paper_bin/carbon,
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
					/obj/item/clipboard,
					/obj/item/stamp,
					/obj/item/stamp/denied,
					/obj/item/laser_pointer/purple)
	crate_name = "bureaucracy crate"

/datum/supply_pack/misc/fountainpens
	name = "Calligraphy Crate"
	desc = "Sign death warrants in style with these seven executive fountain pens."
	cost = CARGO_CRATE_VALUE * 1.45
	contains = list(/obj/item/storage/box/fountainpens)
	crate_type = /obj/structure/closet/crate/wooden
	crate_name = "calligraphy crate"

/datum/supply_pack/misc/wrapping_paper
	name = "Festive Wrapping Paper Crate"
	desc = "Want to mail your loved ones gift-wrapped chocolates, stuffed animals, the Clown's severed head? You can do all that, with this crate full of wrapping paper."
	cost = CARGO_CRATE_VALUE * 1.8
	contains = list(/obj/item/stack/wrapping_paper)
	crate_type = /obj/structure/closet/crate/wooden
	crate_name = "festive wrapping paper crate"


/datum/supply_pack/misc/funeral
	name = "Funeral Supply crate"
	desc = "At the end of the day, someone's gonna want someone dead. Give them a proper send-off with these funeral supplies! Contains a coffin with burial garmets and flowers."
	cost = CARGO_CRATE_VALUE * 1.6
	access_view = ACCESS_CHAPEL_OFFICE
	contains = list(/obj/item/clothing/under/misc/burial,
					/obj/item/food/grown/harebell,
					/obj/item/food/grown/poppy/geranium)
	crate_name = "coffin"
	crate_type = /obj/structure/closet/crate/coffin

/datum/supply_pack/misc/empty
	name = "Empty Supplypod"
	desc = "Presenting the New Nanotrasen-Brand Bluespace Supplypod! Transport cargo with grace and ease! Call today and we'll shoot over a demo unit for just 300 credits!"
	cost = CARGO_CRATE_VALUE * 0.6 //Empty pod, so no crate refund
	contains = list()
	supply_flags = SUPPLY_PACK_DROPPOD_ONLY
	crate_type = null
	special_pod = /obj/structure/closet/supplypod/bluespacepod

/datum/supply_pack/misc/religious_supplies
	name = "Religious Supplies Crate"
	desc = "Keep your local chaplain happy and well-supplied, lest they call down judgement upon your cargo bay. Contains two bottles of holywater, bibles, chaplain robes, and burial garmets."
	cost = CARGO_CRATE_VALUE * 6 // it costs so much because the Space Church needs funding to build a cathedral
	access_view = ACCESS_CHAPEL_OFFICE
	contains = list(/obj/item/reagent_containers/cup/glass/bottle/holywater,
					/obj/item/reagent_containers/cup/glass/bottle/holywater,
					/obj/item/storage/book/bible/booze,
					/obj/item/storage/book/bible/booze,
					/obj/item/clothing/suit/hooded/chaplain_hoodie,
					/obj/item/clothing/suit/hooded/chaplain_hoodie,
					/obj/item/clothing/under/misc/burial,
					/obj/item/clothing/under/misc/burial,
				)
	crate_name = "religious supplies crate"

/datum/supply_pack/misc/toner
	name = "Toner Crate"
	desc = "Spent too much ink printing butt pictures? Fret not, with these six toner refills, you'll be printing butts 'till the cows come home!'"
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/toner,
					/obj/item/toner,
					/obj/item/toner,
					/obj/item/toner,
					/obj/item/toner,
					/obj/item/toner)
	crate_name = "toner crate"

/datum/supply_pack/misc/toner_large
	name = "Toner Crate (Large)"
	desc = "Tired of changing toner cartridges? These six extra heavy duty refills contain roughly five times as much toner as the base model!"
	cost = CARGO_CRATE_VALUE * 6
	contains = list(/obj/item/toner/large,
					/obj/item/toner/large,
					/obj/item/toner/large,
					/obj/item/toner/large,
					/obj/item/toner/large,
					/obj/item/toner/large)
	crate_name = "large toner crate"

/datum/supply_pack/misc/training_toolbox
	name = "Training Toolbox Crate"
	desc = "Hone your combat abiltities with two AURUMILL-Brand Training Toolboxes! Guarenteed to count hits made against living beings!"
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/training_toolbox,
					/obj/item/training_toolbox
					)
	crate_name = "training toolbox crate"

/datum/supply_pack/misc/blackmarket_telepad
	name = "Black Market LTSRBT"
	desc = "Need a faster and better way of transporting your illegal goods from and to the station? Fear not, the Long-To-Short-Range-Bluespace-Transceiver (LTSRBT for short) is here to help. Contains a LTSRBT circuit, two bluespace crystals, and one ansible."
	cost = CARGO_CRATE_VALUE * 20
	supply_flags = SUPPLY_PACK_CONTRABAND
	contains = list(
		/obj/item/circuitboard/machine/ltsrbt,
		/obj/item/stack/ore/bluespace_crystal/artificial,
		/obj/item/stack/ore/bluespace_crystal/artificial,
		/obj/item/stock_parts/subspace/ansible
	)
	crate_name = "crate"

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

//////////////////////////////////////////////////////////////////////////////
/////////////////////// General Vending Restocks /////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/vending
	group = "Vending Restocks"

/datum/supply_pack/vending/bartending
	name = "Booze-o-mat and Coffee Supply Crate"
	desc = "Bring on the booze and coffee vending machine refills."
	cost = CARGO_CRATE_VALUE * 4
	contains = list(/obj/item/vending_refill/boozeomat,
					/obj/item/vending_refill/coffee)
	crate_name = "bartending supply crate"

/datum/supply_pack/vending/cigarette
	name = "Cigarette Supply Crate"
	desc = "Don't believe the reports - smoke today! Contains a cigarette vending machine refill."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/vending_refill/cigarette)
	crate_name = "cigarette supply crate"
	crate_type = /obj/structure/closet/crate

/datum/supply_pack/vending/dinnerware
	name = "Dinnerware Supply Crate"
	desc = "More knives for the chef."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/vending_refill/dinnerware)
	crate_name = "dinnerware supply crate"

/datum/supply_pack/vending/science/modularpc
	name = "Deluxe Silicate Selections Restock"
	desc = "What's a computer? Contains a Deluxe Silicate Selections restocking unit."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/vending_refill/modularpc)
	crate_name = "computer supply crate"

/datum/supply_pack/vending/engivend
	name = "EngiVend Supply Crate"
	desc = "The engineers are out of metal foam grenades? This should help."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/vending_refill/engivend)
	crate_name = "engineering supply crate"

/datum/supply_pack/vending/games
	name = "Games Supply Crate"
	desc = "Get your game on with this game vending machine refill."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/vending_refill/games)
	crate_name = "games supply crate"
	crate_type = /obj/structure/closet/crate

/datum/supply_pack/vending/hydro_refills
	name = "Hydroponics Vending Machines Refills"
	desc = "When the clown takes all the banana seeds. Contains a NutriMax refill and a MegaSeed Servitor refill."
	cost = CARGO_CRATE_VALUE * 4
	crate_type = /obj/structure/closet/crate
	contains = list(/obj/item/vending_refill/hydroseeds,
					/obj/item/vending_refill/hydronutrients)
	crate_name = "hydroponics supply crate"

/datum/supply_pack/vending/imported
	name = "Imported Vending Machines"
	desc = "Vending machines famous in other parts of the galaxy."
	cost = CARGO_CRATE_VALUE * 8
	contains = list(/obj/item/vending_refill/sustenance,
					/obj/item/vending_refill/robotics,
					/obj/item/vending_refill/sovietsoda,
					/obj/item/vending_refill/engineering)
	crate_name = "unlabeled supply crate"

/datum/supply_pack/vending/medical
	name = "Medical Vending Crate"
	desc = "Contains one NanoMed Plus refill, one NanoDrug Plus refill, and one wall-mounted NanoMed refill."
	cost = CARGO_CRATE_VALUE * 5
	contains = list(/obj/item/vending_refill/medical,
					/obj/item/vending_refill/drugs,
					/obj/item/vending_refill/wallmed)
	crate_name = "medical vending crate"

/datum/supply_pack/vending/ptech
	name = "PTech Supply Crate"
	desc = "Not enough cartridges after half the crew lost their PDA to explosions? This may fix it."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/vending_refill/cart)
	crate_name = "\improper PTech supply crate"

/datum/supply_pack/vending/sectech
	name = "SecTech Supply Crate"
	desc = "Officer Paul bought all the donuts? Then refill the security vendor with ths crate."
	cost = CARGO_CRATE_VALUE * 3
	access = ACCESS_SECURITY
	contains = list(/obj/item/vending_refill/security)
	crate_name = "\improper SecTech supply crate"
	crate_type = /obj/structure/closet/crate/secure/gear

/datum/supply_pack/vending/snack
	name = "Snack Supply Crate"
	desc = "One vending machine refill of cavity-bringin' goodness! The number one dentist recommended order!"
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/vending_refill/snack)
	crate_name = "snacks supply crate"

/datum/supply_pack/vending/cola
	name = "Softdrinks Supply Crate"
	desc = "Got whacked by a toolbox, but you still have those pesky teeth? Get rid of those pearly whites with this soda machine refill, today!"
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/vending_refill/cola)
	crate_name = "soft drinks supply crate"

/datum/supply_pack/vending/vendomat
	name = "Part-Mart & YouTool Supply Crate"
	desc = "More tools for your IED testing facility."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/vending_refill/assist,
					/obj/item/vending_refill/youtool)
	crate_name = "\improper Part-Mart & YouTool supply crate"

/datum/supply_pack/vending/clothesmate
	name = "ClothesMate Supply Crate"
	desc = "Out of cowboy boots? Buy this crate."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/vending_refill/clothing)
	crate_name = "\improper ClothesMate supply crate"

//////////////////////////////////////////////////////////////////////////////
/////////////////////// Clothing Vending Restocks ////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/vending/wardrobes/autodrobe
	name = "Autodrobe Supply Crate"
	desc = "Autodrobe missing your favorite dress? Solve that issue today with this autodrobe refill."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/vending_refill/autodrobe)
	crate_name = "autodrobe supply crate"

/datum/supply_pack/vending/wardrobes/cargo
	name = "Cargo Wardrobe Supply Crate"
	desc = "This crate contains a refill for the CargoDrobe."
	cost = CARGO_CRATE_VALUE * 1.5
	contains = list(/obj/item/vending_refill/wardrobe/cargo_wardrobe)
	crate_name = "cargo department supply crate"

/datum/supply_pack/vending/wardrobes/engineering
	name = "Engineering Wardrobe Supply Crate"
	desc = "This crate contains refills for the EngiDrobe and AtmosDrobe."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/vending_refill/wardrobe/engi_wardrobe,
					/obj/item/vending_refill/wardrobe/atmos_wardrobe)
	crate_name = "engineering department wardrobe supply crate"

/datum/supply_pack/vending/wardrobes/general
	name = "General Wardrobes Supply Crate"
	desc = "This crate contains refills for the CuraDrobe, BarDrobe, ChefDrobe, JaniDrobe, ChapDrobe."
	cost = CARGO_CRATE_VALUE * 7.5
	contains = list(/obj/item/vending_refill/wardrobe/curator_wardrobe,
					/obj/item/vending_refill/wardrobe/bar_wardrobe,
					/obj/item/vending_refill/wardrobe/chef_wardrobe,
					/obj/item/vending_refill/wardrobe/jani_wardrobe,
					/obj/item/vending_refill/wardrobe/chap_wardrobe)
	crate_name = "general wardrobes vendor refills"

/datum/supply_pack/vending/wardrobes/hydroponics
	name = "Hydrobe Supply Crate"
	desc = "This crate contains a refill for the Hydrobe."
	cost = CARGO_CRATE_VALUE * 1.5
	contains = list(/obj/item/vending_refill/wardrobe/hydro_wardrobe)
	crate_name = "hydrobe supply crate"

/datum/supply_pack/vending/wardrobes/medical
	name = "Medical Wardrobe Supply Crate"
	desc = "This crate contains refills for the MediDrobe, ChemDrobe, and ViroDrobe."
	cost = CARGO_CRATE_VALUE * 6
	contains = list(/obj/item/vending_refill/wardrobe/medi_wardrobe,
					/obj/item/vending_refill/wardrobe/chem_wardrobe,
					/obj/item/vending_refill/wardrobe/viro_wardrobe)
	crate_name = "medical department wardrobe supply crate"

/datum/supply_pack/vending/wardrobes/science
	name = "Science Wardrobe Supply Crate"
	desc = "This crate contains refills for the SciDrobe, GeneDrobe, and RoboDrobe."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/vending_refill/wardrobe/robo_wardrobe,
					/obj/item/vending_refill/wardrobe/gene_wardrobe,
					/obj/item/vending_refill/wardrobe/science_wardrobe)
	crate_name = "science department wardrobe supply crate"

/datum/supply_pack/vending/wardrobes/security
	name = "Security Wardrobe Supply Crate"
	desc = "This crate contains refills for the SecDrobe, DetDrobe and LawDrobe."
	cost = CARGO_CRATE_VALUE * 4
	contains = list(/obj/item/vending_refill/wardrobe/sec_wardrobe,
					/obj/item/vending_refill/wardrobe/det_wardrobe,
					/obj/item/vending_refill/wardrobe/law_wardrobe)
	crate_name = "security department supply crate"

/// Exploration drone unlockables ///

/datum/supply_pack/exploration
	special = TRUE
	group = "Outsourced"

/datum/supply_pack/exploration/scrapyard
	name = "Scrapyard Crate"
	desc = "Outsourced crate containing various junk."
	cost = CARGO_CRATE_VALUE * 5
	contains = list(
		/obj/item/broken_bottle,
		/obj/item/pickaxe/rusted
	)
	crate_name = "scrapyard crate"

/datum/supply_pack/exploration/catering
	name = "Catering Crate"
	desc = "No cook? No problem! Food quality may vary depending on provider."
	cost = CARGO_CRATE_VALUE * 5
	contains = list(/obj/item/food/sandwich,
					/obj/item/food/sandwich,
					/obj/item/food/sandwich,
					/obj/item/food/sandwich,
					/obj/item/food/sandwich)
	crate_name = "outsourced food crate"

/datum/supply_pack/exploration/catering/fill(obj/structure/closet/crate/C)
	. = ..()
	if(prob(30))
		for(var/obj/item/food/F in C)
			F.name = "spoiled [F.name]"
			F.foodtypes |= GROSS
			F.MakeEdible()

/datum/supply_pack/exploration/shrubbery
	name = "Shrubbery Crate"
	desc = "Crate full of hedge shrubs."
	cost = CARGO_CRATE_VALUE * 5
	crate_name = "shrubbery crate"
	var/shrub_amount = 8

/datum/supply_pack/exploration/shrubbery/fill(obj/structure/closet/crate/C)
	for(var/i in 1 to shrub_amount)
		new /obj/item/grown/shrub(C)

/datum/supply_pack/data_disk
	group = "Data Disks"

/datum/supply_pack/data_disk/preloaded
	name = "Hard Disk Drive (Omnifab)"
	desc = "Contains an extremely expensive data disk for use in fabricators."
	cost = CARGO_CRATE_VALUE * 5
	access = ACCESS_RESEARCH
	contains = list(/obj/item/disk/data/fabricator/omni)
	crate_name = "omnifab disk crate"

/datum/supply_pack/data_disk/preloaded/robotics
	name = "Hard Disk Drive (Robofab)"
	access = ACCESS_MECH_SCIENCE
	contains = list(/obj/item/disk/data/fabricator/robotics)
	crate_name = "robofab disk crate"

/datum/supply_pack/data_disk/preloaded/civ
	name = "Hard Disk Drive (Civfab)"
	contains = list(/obj/item/disk/data/fabricator/civ)
	crate_name = "civfab disk crate"

/datum/supply_pack/data_disk/preloaded/engineering
	name = "Hard Disk Drive (Engifab)"
	access = ACCESS_ENGINEERING
	contains = list(/obj/item/disk/data/fabricator/engineering)
	crate_name = "engifab disk crate"

/datum/supply_pack/data_disk/preloaded/medical
	name = "Hard Disk Drive (Medifab)"
	access = ACCESS_MEDICAL
	contains = list(/obj/item/disk/data/fabricator/medical)
	crate_name = "medifab disk crate"

/datum/supply_pack/data_disk/preloaded/supply
	name = "Hard Disk Drive (Supplyfab)"
	access = ACCESS_CARGO
	contains = list(/obj/item/disk/data/fabricator/supply)
	crate_name = "supplyfab disk crate"

/datum/supply_pack/data_disk/preloaded/security
	name = "Hard Disk Drive (Secfab)"
	access = ACCESS_SECURITY
	contains = list(/obj/item/disk/data/fabricator/security)
	crate_name = "secfab disk crate"

/datum/supply_pack/data_disk/preloaded/service
	name = "Hard Disk Drive (Servicefab)"
	access = ACCESS_SERVICE
	contains = list(/obj/item/disk/data/fabricator/service)
	crate_name = "servicefab disk crate"

/datum/supply_pack/data_disk/preloaded/imprinter
	name = "Hard Disk Drive (Imprinter)"
	access = ACCESS_ENGINEERING
	contains = list(/obj/item/disk/data/fabricator/imprinter)
	crate_name = "imprinter disk crate"
