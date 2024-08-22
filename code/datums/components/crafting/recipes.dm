///If the machine is used/deleted in the crafting process
#define CRAFTING_MACHINERY_CONSUME 1
///If the machine is only "used" i.e. it checks to see if it's nearby and allows crafting, but doesn't delete it
#define CRAFTING_MACHINERY_USE 0

/datum/crafting_recipe
	var/name = "" //in-game display name
	var/list/reqs = list() //type paths of items consumed associated with how many are needed
	var/list/blacklist = list() //type paths of items explicitly not allowed as an ingredient
	var/result //type path of item resulting from this craft
	/// String defines of items needed but not consumed. Lazy list.
	var/list/tool_behaviors
	/// Type paths of items needed but not consumed. Lazy list.
	var/list/tool_paths
	var/time = 30 //time in deciseconds
	var/list/parts = list() //type paths of items that will be placed in the result
	var/list/chem_catalysts = list() //like tool_behaviors but for reagents
	var/category = CAT_NONE //where it shows up in the crafting UI
	var/subcategory = CAT_NONE
	var/always_available = TRUE //Set to FALSE if it needs to be learned first.
	/// Additonal requirements text shown in UI
	var/additional_req_text
	///Required machines for the craft, set the assigned value of the typepath to CRAFTING_MACHINERY_CONSUME or CRAFTING_MACHINERY_USE. Lazy associative list: type_path key -> flag value.
	var/list/machinery
	///Should only one object exist on the same turf?
	var/one_per_turf = FALSE

/datum/crafting_recipe/New()
	if(!(result in reqs))
		blacklist += result
	if(tool_behaviors)
		tool_behaviors = string_list(tool_behaviors)
	if(tool_paths)
		tool_paths = string_list(tool_paths)

/**
 * Run custom pre-craft checks for this recipe, don't add feedback messages in this because it will spam the client
 *
 * user: The /mob that initiated the crafting
 * collected_requirements: A list of lists of /obj/item instances that satisfy reqs. Top level list is keyed by requirement path.
 */
/datum/crafting_recipe/proc/check_requirements(mob/user, list/collected_requirements)
	return TRUE

/datum/crafting_recipe/proc/on_craft_completion(mob/user, atom/result)
	return

///Check if the pipe used for atmospheric device crafting is the proper one
/datum/crafting_recipe/proc/atmos_pipe_check(mob/user, list/collected_requirements)
	var/obj/item/pipe/required_pipe = collected_requirements[/obj/item/pipe][1]
	if(ispath(required_pipe.pipe_type, /obj/machinery/atmospherics/pipe/smart))
		return TRUE
	return FALSE

// !!NOTICE!!
//All of this should *eventually* be moved to code/modules/slapcrafting or deleted entirely. Please don't add more recipes to this file.


/datum/crafting_recipe/strobeshield
	name = "Strobe Shield"
	result = /obj/item/shield/riot/flash
	reqs = list(/obj/item/wallframe/flasher = 1,
				/obj/item/assembly/flash/handheld = 1,
				/obj/item/shield/riot = 1)
	time = 40
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/strobeshield/New()
	..()
	blacklist |= subtypesof(/obj/item/shield/riot/)

/datum/crafting_recipe/gonbola
	name = "Gonbola"
	result = /obj/item/restraints/legcuffs/bola/gonbola
	reqs = list(/obj/item/restraints/handcuffs/cable = 1,
				/obj/item/stack/sheet/iron = 6,
				/obj/item/stack/sheet/animalhide/gondola = 1)
	time = 40
	category= CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/catwhip
	name = "Cat O' Nine Tails"
	result = /obj/item/melee/chainofcommand/kitty
	reqs = list(/obj/item/organ/tail/cat = 1,
				/obj/item/stack/cable_coil = 1)
	time = 40
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/ed209
	name = "ED209"
	result = /mob/living/simple_animal/bot/secbot/ed209
	reqs = list(/obj/item/robot_suit = 1,
				/obj/item/clothing/head/helmet = 1,
				/obj/item/clothing/suit/armor/vest = 1,
				/obj/item/bodypart/leg/left/robot = 1,
				/obj/item/bodypart/leg/right/robot = 1,
				/obj/item/stack/sheet/iron = 1,
				/obj/item/stack/cable_coil = 1,
				/obj/item/gun/energy/disabler = 1,
				/obj/item/assembly/prox_sensor = 1)
	tool_behaviors = list(TOOL_WELDER, TOOL_SCREWDRIVER)
	time = 60
	category = CAT_ROBOT

/datum/crafting_recipe/secbot
	name = "Secbot"
	result = /mob/living/simple_animal/bot/secbot
	reqs = list(/obj/item/assembly/signaler = 1,
				/obj/item/clothing/head/helmet/sec = 1,
				/obj/item/melee/baton/security/ = 1,
				/obj/item/assembly/prox_sensor = 1,
				/obj/item/bodypart/arm/right/robot = 1)
	tool_behaviors = list(TOOL_WELDER)
	time = 60
	category = CAT_ROBOT

/datum/crafting_recipe/cleanbot
	name = "Cleanbot"
	result = /mob/living/simple_animal/bot/cleanbot
	reqs = list(/obj/item/reagent_containers/glass/bucket = 1,
				/obj/item/assembly/prox_sensor = 1,
				/obj/item/bodypart/arm/right/robot = 1)
	time = 40
	category = CAT_ROBOT

/datum/crafting_recipe/floorbot
	name = "Floorbot"
	result = /mob/living/simple_animal/bot/floorbot
	reqs = list(/obj/item/storage/toolbox = 1,
				/obj/item/stack/tile/iron = 10,
				/obj/item/assembly/prox_sensor = 1,
				/obj/item/bodypart/arm/right/robot = 1)
	time = 40
	category = CAT_ROBOT

/datum/crafting_recipe/medbot
	name = "Medbot"
	result = /mob/living/simple_animal/bot/medbot
	reqs = list(/obj/item/healthanalyzer = 1,
				/obj/item/storage/medkit = 1,
				/obj/item/assembly/prox_sensor = 1,
				/obj/item/bodypart/arm/right/robot = 1)
	parts = list(
		/obj/item/storage/medkit = 1,
		/obj/item/healthanalyzer = 1,
		)
	time = 40
	category = CAT_ROBOT

/datum/crafting_recipe/medbot/on_craft_completion(mob/user, atom/result)
	var/mob/living/simple_animal/bot/medbot/bot = result
	var/obj/item/storage/medkit/medkit = bot.contents[3]
	bot.medkit_type = medkit
	bot.healthanalyzer = bot.contents[4]

	if (istype(medkit, /obj/item/storage/medkit/fire))
		bot.skin = "ointment"
	else if (istype(medkit, /obj/item/storage/medkit/toxin))
		bot.skin = "tox"
	else if (istype(medkit, /obj/item/storage/medkit/o2))
		bot.skin = "o2"
	else if (istype(medkit, /obj/item/storage/medkit/brute))
		bot.skin = "brute"
	else if (istype(medkit, /obj/item/storage/medkit/advanced))
		bot.skin = "advanced"

	bot.damagetype_healer = initial(medkit.damagetype_healed) ? initial(medkit.damagetype_healed) : BRUTE
	bot.update_appearance()

/datum/crafting_recipe/honkbot
	name = "Honkbot"
	result = /mob/living/simple_animal/bot/secbot/honkbot
	reqs = list(/obj/item/storage/box/clown = 1,
				/obj/item/bodypart/arm/right/robot = 1,
				/obj/item/assembly/prox_sensor = 1,
				/obj/item/bikehorn/ = 1)
	time = 40
	category = CAT_ROBOT

/datum/crafting_recipe/firebot
	name = "Firebot"
	result = /mob/living/simple_animal/bot/firebot
	reqs = list(/obj/item/extinguisher = 1,
				/obj/item/bodypart/arm/right/robot = 1,
				/obj/item/assembly/prox_sensor = 1,
				/obj/item/clothing/head/hardhat/red = 1)
	time = 40
	category = CAT_ROBOT

/datum/crafting_recipe/vibebot
	name = "Vibebot"
	result = /mob/living/simple_animal/bot/vibebot
	reqs = list(/obj/item/light/bulb = 2,
				/obj/item/bodypart/head/robot = 1,
				/obj/item/assembly/prox_sensor = 1,
				/obj/item/toy/crayon = 1)
	time = 40
	category = CAT_ROBOT

/datum/crafting_recipe/hygienebot
	name = "Hygienebot"
	result = /mob/living/simple_animal/bot/hygienebot
	reqs = list(/obj/item/bot_assembly/hygienebot = 1,
				/obj/item/assembly/prox_sensor = 1)
	tool_behaviors = list(TOOL_WELDER)
	time = 40
	category = CAT_ROBOT

/datum/crafting_recipe/vim
	name = "Vim"
	result = /obj/vehicle/sealed/car/vim
	reqs = list(/obj/item/clothing/head/helmet/space/eva = 1,
				/obj/item/bodypart/leg/left/robot = 1,
				/obj/item/bodypart/leg/right/robot = 1,
				/obj/item/flashlight = 1,
				/obj/item/assembly/voice = 1)
	tool_behaviors = list(TOOL_SCREWDRIVER)
	time = 6 SECONDS //Has a four second do_after when building manually
	category = CAT_ROBOT

//Crafting guns and ammo is cool, but needs to be redone before it fits with the game.
/*
/datum/crafting_recipe/meteorslug
	name = "Meteorslug Shell"
	result = /obj/item/ammo_casing/shotgun/meteorslug
	reqs = list(/obj/item/ammo_casing/shotgun/techshell = 1,
				/obj/item/rcd_ammo = 1,
				/obj/item/stock_parts/manipulator = 2)
	tool_behaviors = list(TOOL_SCREWDRIVER)
	time = 5
	category = CAT_WEAPONRY
	subcategory = CAT_AMMO

/datum/crafting_recipe/pulseslug
	name = "Pulse Slug Shell"
	result = /obj/item/ammo_casing/shotgun/pulseslug
	reqs = list(/obj/item/ammo_casing/shotgun/techshell = 1,
				/obj/item/stock_parts/capacitor/adv = 2,
				/obj/item/stock_parts/micro_laser/ultra = 1)
	tool_behaviors = list(TOOL_SCREWDRIVER)
	time = 5
	category = CAT_WEAPONRY
	subcategory = CAT_AMMO

/datum/crafting_recipe/dragonsbreath
	name = "Dragonsbreath Shell"
	result = /obj/item/ammo_casing/shotgun/dragonsbreath
	reqs = list(/obj/item/ammo_casing/shotgun/techshell = 1, /datum/reagent/phosphorus = 5)
	tool_behaviors = list(TOOL_SCREWDRIVER)
	time = 5
	category = CAT_WEAPONRY
	subcategory = CAT_AMMO

/datum/crafting_recipe/frag12
	name = "FRAG-12 Shell"
	result = /obj/item/ammo_casing/shotgun/frag12
	reqs = list(/obj/item/ammo_casing/shotgun/techshell = 1,
				/datum/reagent/glycerol = 5,
				/datum/reagent/toxin/acid = 5,
				/datum/reagent/toxin/acid/fluacid = 5)
	tool_behaviors = list(TOOL_SCREWDRIVER)
	time = 5
	category = CAT_WEAPONRY
	subcategory = CAT_AMMO

/datum/crafting_recipe/ionslug
	name = "Ion Scatter Shell"
	result = /obj/item/ammo_casing/shotgun/ion
	reqs = list(/obj/item/ammo_casing/shotgun/techshell = 1,
				/obj/item/stock_parts/micro_laser/ultra = 1,
				/obj/item/stock_parts/subspace/crystal = 1)
	tool_behaviors = list(TOOL_SCREWDRIVER)
	time = 5
	category = CAT_WEAPONRY
	subcategory = CAT_AMMO

/datum/crafting_recipe/improvisedslug
	name = "Improvised Shotgun Shell"
	result = /obj/item/ammo_casing/shotgun/improvised
	reqs = list(/obj/item/stack/sheet/iron = 2,
				/obj/item/stack/cable_coil = 1,
				/datum/reagent/fuel = 10)
	tool_behaviors = list(TOOL_SCREWDRIVER)
	time = 12
	category = CAT_WEAPONRY
	subcategory = CAT_AMMO

/datum/crafting_recipe/laserslug
	name = "Scatter Laser Shell"
	result = /obj/item/ammo_casing/shotgun/laserslug
	reqs = list(/obj/item/ammo_casing/shotgun/techshell = 1,
				/obj/item/stock_parts/capacitor/adv = 1,
				/obj/item/stock_parts/micro_laser/high = 1)
	tool_behaviors = list(TOOL_SCREWDRIVER)
	time = 5
	category = CAT_WEAPONRY
	subcategory = CAT_AMMO

/datum/crafting_recipe/reciever
	name = "Modular Rifle Reciever"
	tool_behaviors = list(TOOL_WRENCH, TOOL_WELDER, TOOL_SAW)
	result = /obj/item/weaponcrafting/receiver
	reqs = list(/obj/item/stack/sheet/iron = 5,
				/obj/item/stack/sticky_tape = 1,
				/obj/item/screwdriver = 1,
				/obj/item/assembly/mousetrap = 1)
	time = 100
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/riflestock
	name = "Wooden Rifle Stock"
	tool_paths = list(/obj/item/hatchet)
	result = /obj/item/weaponcrafting/stock
	reqs = list(/obj/item/stack/sheet/mineral/wood = 8,
				/obj/item/stack/sticky_tape = 1)
	time = 50
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/pipegun
	name = "Pipegun"
	result = /obj/item/gun/ballistic/rifle/boltaction/pipegun
	reqs = list(/obj/item/weaponcrafting/receiver = 1,
				/obj/item/pipe = 1,
				/obj/item/weaponcrafting/stock = 1,
				/obj/item/stack/sticky_tape = 1)
	tool_behaviors = list(TOOL_SCREWDRIVER)
	time = 50
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON
*/

/datum/crafting_recipe/trash_cannon
	name = "Trash Cannon"
	always_available = FALSE
	tool_behaviors = list(TOOL_WELDER, TOOL_SCREWDRIVER)
	result = /obj/structure/cannon/trash
	reqs = list(
		/obj/item/melee/skateboard/improvised = 1,
		/obj/item/tank/internals/oxygen = 1,
		/datum/reagent/drug/maint/tar = 15,
		/obj/item/restraints/handcuffs/cable = 1,
		/obj/item/storage/toolbox = 1,
	)
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/trashball
	name = "Trashball"
	always_available = FALSE
	result = /obj/item/stack/cannonball/trashball
	reqs = list(
		/obj/item/stack/sheet = 5,
		/datum/reagent/consumable/space_cola = 10,
	)
	category = CAT_WEAPONRY
	subcategory = CAT_AMMO

/datum/crafting_recipe/chainsaw
	name = "Chainsaw"
	result = /obj/item/chainsaw
	reqs = list(/obj/item/circular_saw = 1,
				/obj/item/stack/cable_coil = 3,
				/obj/item/stack/sheet/plasteel = 5)
	tool_behaviors = list(TOOL_WELDER)
	time = 50
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/radiogloves/New()
	..()
	blacklist |= typesof(/obj/item/radio/headset)
	blacklist |= typesof(/obj/item/radio/intercom)

/datum/crafting_recipe/mixedbouquet
	name = "Mixed bouquet"
	result = /obj/item/bouquet
	reqs = list(/obj/item/food/grown/poppy/lily =2,
				/obj/item/food/grown/sunflower = 2,
				/obj/item/food/grown/poppy/geranium = 2)
	category = CAT_MISC

/datum/crafting_recipe/sunbouquet
	name = "Sunflower bouquet"
	result = /obj/item/bouquet/sunflower
	reqs = list(/obj/item/food/grown/sunflower = 6)
	category = CAT_MISC

/datum/crafting_recipe/poppybouquet
	name = "Poppy bouquet"
	result = /obj/item/bouquet/poppy
	reqs = list (/obj/item/food/grown/poppy = 6)
	category = CAT_MISC

/datum/crafting_recipe/rosebouquet
	name = "Rose bouquet"
	result = /obj/item/bouquet/rose
	reqs = list(/obj/item/food/grown/rose = 6)
	category = CAT_MISC

/datum/crafting_recipe/spooky_camera
	name = "Camera Obscura"
	result = /obj/item/camera/spooky
	time = 15
	reqs = list(/obj/item/camera = 1,
				/datum/reagent/water/holywater = 10)
	parts = list(/obj/item/camera = 1)
	category = CAT_MISC


/datum/crafting_recipe/skateboard
	name = "Skateboard"
	result = /obj/vehicle/ridden/scooter/skateboard/improvised
	time = 60
	reqs = list(/obj/item/stack/sheet/iron = 5,
				/obj/item/stack/rods = 10)
	category = CAT_MISC

/datum/crafting_recipe/scooter
	name = "Scooter"
	result = /obj/vehicle/ridden/scooter
	time = 65
	reqs = list(/obj/item/stack/sheet/iron = 5,
				/obj/item/stack/rods = 12)
	category = CAT_MISC

/datum/crafting_recipe/wheelchair
	name = "Wheelchair"
	result = /obj/vehicle/ridden/wheelchair
	reqs = list(/obj/item/stack/sheet/iron = 4,
				/obj/item/stack/rods = 6)
	time = 100
	category = CAT_MISC

/datum/crafting_recipe/motorized_wheelchair
	name = "Motorized Wheelchair"
	result = /obj/vehicle/ridden/wheelchair/motorized
	reqs = list(/obj/item/stack/sheet/iron = 10,
		/obj/item/stack/rods = 8,
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stock_parts/capacitor = 1)
	parts = list(/obj/item/stock_parts/manipulator = 2,
		/obj/item/stock_parts/capacitor = 1)
	tool_behaviors = list(TOOL_WELDER, TOOL_SCREWDRIVER, TOOL_WRENCH)
	time = 200
	category = CAT_MISC

/datum/crafting_recipe/naturalpaper
	name = "Hand-Pressed Paper"
	time = 30
	reqs = list(/datum/reagent/water = 50, /obj/item/stack/sheet/mineral/wood = 1)
	tool_paths = list(/obj/item/hatchet)
	result = /obj/item/paper_bin/bundlenatural
	category = CAT_MISC

/datum/crafting_recipe/toysword
	name = "Toy Sword"
	reqs = list(/obj/item/light/bulb = 1, /obj/item/stack/cable_coil = 1, /obj/item/stack/sheet/plastic = 4)
	result = /obj/item/toy/sword
	category = CAT_MISC

/datum/crafting_recipe/blackcarpet
	name = "Black Carpet"
	reqs = list(/obj/item/stack/tile/carpet = 50, /obj/item/toy/crayon/black = 1)
	result = /obj/item/stack/tile/carpet/black/fifty
	category = CAT_MISC

/datum/crafting_recipe/curtain
	name = "Curtains"
	reqs = list(/obj/item/stack/sheet/cloth = 4, /obj/item/stack/rods = 1)
	result = /obj/structure/curtain/cloth
	category = CAT_MISC

/datum/crafting_recipe/showercurtain
	name = "Shower Curtains"
	reqs = list(/obj/item/stack/sheet/cloth = 2, /obj/item/stack/sheet/plastic = 2, /obj/item/stack/rods = 1)
	result = /obj/structure/curtain
	category = CAT_MISC

/datum/crafting_recipe/extendohand_r
	name = "Extendo-Hand (Right Arm)"
	reqs = list(/obj/item/bodypart/arm/right/robot = 1, /obj/item/clothing/gloves/boxing = 1)
	result = /obj/item/extendohand
	category = CAT_MISC

/datum/crafting_recipe/extendohand_l
	name = "Extendo-Hand (Left Arm)"
	reqs = list(/obj/item/bodypart/arm/left/robot = 1, /obj/item/clothing/gloves/boxing = 1)
	result = /obj/item/extendohand
	category = CAT_MISC

/datum/crafting_recipe/chemical_payload
	name = "Chemical Payload (C4)"
	result = /obj/item/bombcore/chemical
	reqs = list(
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/grenade/c4 = 1,
		/obj/item/grenade/chem_grenade = 2
	)
	parts = list(/obj/item/stock_parts/matter_bin = 1, /obj/item/grenade/chem_grenade = 2)
	time = 30
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/chemical_payload2
	name = "Chemical Payload (Gibtonite)"
	result = /obj/item/bombcore/chemical
	reqs = list(
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/gibtonite = 1,
		/obj/item/grenade/chem_grenade = 2
	)
	parts = list(/obj/item/stock_parts/matter_bin = 1, /obj/item/grenade/chem_grenade = 2)
	time = 50
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/gold_horn
	name = "Golden Bike Horn"
	result = /obj/item/bikehorn/golden
	time = 20
	reqs = list(/obj/item/stack/sheet/mineral/bananium = 5,
				/obj/item/bikehorn = 1)
	category = CAT_MISC

/* These are all already craftable with wooden sheets!!!
/datum/crafting_recipe/bonfire
	name = "Bonfire"
	time = 60
	reqs = list(/obj/item/grown/log = 5)
	parts = list(/obj/item/grown/log = 5)
	blacklist = list(/obj/item/grown/log/steel)
	result = /obj/structure/bonfire
	category = CAT_PRIMAL

/datum/crafting_recipe/rake //Category resorting incoming - but you never resorted, did you?
	name = "Rake"
	time = 30
	reqs = list(/obj/item/stack/sheet/mineral/wood = 5)
	result = /obj/item/cultivator/rake
	category = CAT_PRIMAL

/datum/crafting_recipe/woodbucket
	name = "Wooden Bucket"
	time = 30
	reqs = list(/obj/item/stack/sheet/mineral/wood = 3)
	result = /obj/item/reagent_containers/glass/bucket/wooden
	category = CAT_PRIMAL
*/

/datum/crafting_recipe/headpike
	name = "Spike Head (Glass Spear)"
	time = 65
	reqs = list(/obj/item/spear = 1,
				/obj/item/bodypart/head = 1)
	parts = list(/obj/item/bodypart/head = 1,
			/obj/item/spear = 1)
	blacklist = list(/obj/item/spear/explosive, /obj/item/spear/bonespear, /obj/item/spear/bamboospear)
	result = /obj/structure/headpike
	category = CAT_PRIMAL

/datum/crafting_recipe/headpikebone
	name = "Spike Head (Bone Spear)"
	time = 65
	reqs = list(/obj/item/spear/bonespear = 1,
				/obj/item/bodypart/head = 1)
	parts = list(/obj/item/bodypart/head = 1,
			/obj/item/spear/bonespear = 1)
	result = /obj/structure/headpike/bone
	category = CAT_PRIMAL

/datum/crafting_recipe/headpikebamboo
	name = "Spike Head (Bamboo Spear)"
	time = 65
	reqs = list(/obj/item/spear/bamboospear = 1,
				/obj/item/bodypart/head = 1)
	parts = list(/obj/item/bodypart/head = 1,
			/obj/item/spear/bamboospear = 1)
	result = /obj/structure/headpike/bamboo
	category = CAT_PRIMAL

/datum/crafting_recipe/pressureplate
	name = "Pressure Plate"
	result = /obj/item/pressure_plate
	time = 5
	reqs = list(/obj/item/stack/sheet/iron = 1,
				/obj/item/stack/tile/iron = 1,
				/obj/item/stack/cable_coil = 2,
				/obj/item/assembly/igniter = 1)
	category = CAT_MISC

/datum/crafting_recipe/mummy
	name = "Mummification Bandages (Mask)"
	result = /obj/item/clothing/mask/mummy
	time = 10
	tool_paths = list(/obj/item/nullrod/egyptian)
	reqs = list(/obj/item/stack/sheet/cloth = 2)
	category = CAT_CLOTHING

/datum/crafting_recipe/mummy/body
	name = "Mummification Bandages (Body)"
	result = /obj/item/clothing/under/costume/mummy
	reqs = list(/obj/item/stack/sheet/cloth = 5)

/datum/crafting_recipe/chaplain_hood
	name = "Follower Hoodie"
	result = /obj/item/clothing/suit/hooded/chaplain_hoodie
	time = 10
	tool_paths = list(/obj/item/clothing/suit/hooded/chaplain_hoodie, /obj/item/storage/book/bible)
	reqs = list(/obj/item/stack/sheet/cloth = 4)
	category = CAT_CLOTHING

/datum/crafting_recipe/guillotine
	name = "Guillotine"
	result = /obj/structure/guillotine
	time = 150 // Building a functioning guillotine takes time
	reqs = list(/obj/item/stack/sheet/plasteel = 3,
				/obj/item/stack/sheet/mineral/wood = 20,
				/obj/item/stack/cable_coil = 10)
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WRENCH, TOOL_WELDER)
	category = CAT_MISC

/datum/crafting_recipe/aitater
	name = "intelliTater"
	result = /obj/item/aicard/aitater
	time = 30
	tool_behaviors = list(TOOL_WIRECUTTER)
	reqs = list(/obj/item/aicard = 1,
					/obj/item/food/grown/potato = 1,
					/obj/item/stack/cable_coil = 5)
	category = CAT_MISC

/datum/crafting_recipe/aitater/check_requirements(mob/user, list/collected_requirements)
	var/obj/item/aicard/aicard = collected_requirements[/obj/item/aicard][1]
	if(!aicard.AI)
		return TRUE

	to_chat(user, span_boldwarning("You can't craft an intelliTater with an AI in the card!"))
	return FALSE

/datum/crafting_recipe/aispook
	name = "intelliLantern"
	result = /obj/item/aicard/aispook
	time = 30
	tool_behaviors = list(TOOL_WIRECUTTER)
	reqs = list(/obj/item/aicard = 1,
					/obj/item/food/grown/pumpkin = 1,
					/obj/item/stack/cable_coil = 5)
	category = CAT_MISC

/datum/crafting_recipe/ghettojetpack
	name = "Improvised Jetpack"
	result = /obj/item/tank/jetpack/improvised
	time = 30
	reqs = list(/obj/item/tank/internals/oxygen = 2, /obj/item/extinguisher = 1, /obj/item/pipe = 3, /obj/item/stack/cable_coil = MAXCOIL)
	category = CAT_MISC
	tool_behaviors = list(TOOL_WRENCH, TOOL_WELDER, TOOL_WIRECUTTER)

/*
/datum/crafting_recipe/boh
	name = "Bag of Holding"
	reqs = list(
		/obj/item/bag_of_holding_inert = 1,
		/obj/item/assembly/signaler/anomaly/bluespace = 1,
	)
	result = /obj/item/storage/backpack/holding
	category = CAT_CLOTHING
*/

/datum/crafting_recipe/underwater_basket
	name = "Underwater Basket (Bamboo)"
	reqs = list(
		/obj/item/stack/sheet/mineral/bamboo = 20
	)
	result = /obj/item/storage/basket
	category = CAT_MISC
	additional_req_text = " being underwater, underwater basketweaving mastery"

/datum/crafting_recipe/underwater_basket/check_requirements(mob/user, list/collected_requirements)
	. = ..()
	if(!HAS_TRAIT(user,TRAIT_UNDERWATER_BASKETWEAVING_KNOWLEDGE))
		return FALSE
	var/turf/T = get_turf(user)
	if(istype(T, /turf/open/water))
		return TRUE
	var/obj/machinery/shower/S = locate() in T
	if(S?.on)
		return TRUE

//Same but with wheat
/datum/crafting_recipe/underwater_basket/wheat
	name = "Underwater Basket (Wheat)"
	reqs = list(
		/obj/item/food/grown/wheat = 50
	)


/datum/crafting_recipe/elder_atmosian_statue
	name = "Elder Atmosian Statue"
	result = /obj/structure/statue/elder_atmosian
	time = 6 SECONDS
	reqs = list(/obj/item/stack/sheet/mineral/metal_hydrogen = 20,
				/obj/item/stack/sheet/mineral/zaukerite = 15,
				/obj/item/stack/sheet/iron = 30,
				)
	category = CAT_MISC

//We'll fix you if we're forced to. Nobody will miss you.
// /datum/crafting_recipe/bluespace_vendor_mount
// 	name = "Bluespace Vendor Wall Mount"
// 	result = /obj/item/wallframe/bluespace_vendor_mount
// 	time = 6 SECONDS
// 	reqs = list(/obj/item/stack/sheet/iron = 15,
// 				/obj/item/stack/sheet/glass = 10,
// 				/obj/item/stack/cable_coil = 10,
// 				)
// 	category = CAT_MISC

/datum/crafting_recipe/shutters
	name = "Shutters"
	reqs = list(/obj/item/stack/sheet/plasteel = 5,
				/obj/item/stack/cable_coil = 5,
				/obj/item/electronics/airlock = 1
				)
	result = /obj/machinery/door/poddoor/shutters/preopen
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_MULTITOOL, TOOL_WIRECUTTER, TOOL_WELDER)
	time = 10 SECONDS
	category = CAT_MISC
	one_per_turf = TRUE

/datum/crafting_recipe/blast_doors
	name = "Blast Door"
	reqs = list(/obj/item/stack/sheet/plasteel = 15,
				/obj/item/stack/cable_coil = 15,
				/obj/item/electronics/airlock = 1
				)
	result = /obj/machinery/door/poddoor/preopen
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_MULTITOOL, TOOL_WIRECUTTER, TOOL_WELDER)
	time = 30 SECONDS
	category = CAT_MISC
	one_per_turf = TRUE

/datum/crafting_recipe/aquarium
	name = "Aquarium"
	result = /obj/structure/aquarium
	time = 10 SECONDS
	reqs = list(/obj/item/stack/sheet/iron = 15,
				/obj/item/stack/sheet/glass = 10,
				/obj/item/aquarium_kit = 1
				)
	category = CAT_MISC

/datum/crafting_recipe/mod_core_standard
	name = "MOD core (Standard)"
	result = /obj/item/mod/core/standard
	tool_behaviors = list(TOOL_SCREWDRIVER)
	time = 10 SECONDS
	reqs = list(/obj/item/stack/cable_coil = 5,
				/obj/item/stack/rods = 2,
				/obj/item/stack/sheet/glass = 1,
				/obj/item/organ/heart/ethereal = 1,
				)
	category = CAT_MISC

/datum/crafting_recipe/mod_core_ethereal
	name = "MOD core (Ethereal)"
	result = /obj/item/mod/core/ethereal
	tool_behaviors = list(TOOL_SCREWDRIVER)
	time = 10 SECONDS
	reqs = list(/datum/reagent/consumable/liquidelectricity = 5,
				/obj/item/stack/cable_coil = 5,
				/obj/item/stack/rods = 2,
				/obj/item/stack/sheet/glass = 1,
				/obj/item/reagent_containers/syringe = 1,
				)
	category = CAT_MISC

/datum/crafting_recipe/dropper //Maybe make a glass pipette icon?
	name = "Dropper"
	result = /obj/item/reagent_containers/dropper
	tool_behaviors = list(TOOL_WELDER)
	time = 5 SECONDS
	reqs = list(
		/obj/item/stack/sheet/glass = 1,
	)
	category = CAT_CHEMISTRY

/datum/crafting_recipe/improvised_chem_heater
	name = "Improvised chem heater"
	result = /obj/machinery/space_heater/improvised_chem_heater
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_MULTITOOL, TOOL_WIRECUTTER)
	time = 15 SECONDS
	reqs = list(
				/obj/item/stack/cable_coil = 2,
				/obj/item/stack/sheet/glass = 2,
				/obj/item/stack/sheet/iron = 2,
				/datum/reagent/water = 50,
				)
	machinery = list(/obj/machinery/space_heater = CRAFTING_MACHINERY_CONSUME)
	category = CAT_CHEMISTRY

/datum/crafting_recipe/improvised_chem_heater/on_craft_completion(mob/user, atom/result)
	var/obj/item/stock_parts/cell/cell = locate(/obj/item/stock_parts/cell) in range(1)
	if(!cell)
		return
	var/obj/machinery/space_heater/improvised_chem_heater/heater = result
	var/turf/turf = get_turf(cell)
	heater.forceMove(turf)
	heater.attackby(cell, user) //puts it into the heater

/datum/crafting_recipe/improvised_coolant
	name = "Improvised cooling spray"
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	result = /obj/item/extinguisher/crafted
	time = 10 SECONDS
	reqs = list(
			/obj/item/toy/crayon/spraycan = 1,
			/datum/reagent/water = 20,
			/datum/reagent/consumable/ice = 10
			)
	category = CAT_CHEMISTRY

/**
 * Recipe used for upgrading fake N-spect scanners to bananium HONK-spect scanners
 */
/datum/crafting_recipe/clown_scanner_upgrade
	name = "Bananium HONK-spect scanner"
	result = /obj/item/inspector/clown/bananium
	reqs = list(/obj/item/inspector/clown = 1, /obj/item/stack/sticky_tape = 3, /obj/item/stack/sheet/mineral/bananium = 5) //the chainsaw of prank tools
	tool_paths = list(/obj/item/bikehorn)
	time = 40 SECONDS
	category = CAT_MISC

/datum/crafting_recipe/layer_adapter
	name = "Layer manifold fitting"
	tool_behaviors = list(TOOL_WRENCH, TOOL_WELDER)
	result = /obj/item/pipe/binary
	reqs = list(
		/obj/item/pipe = 1,
		/obj/item/stack/sheet/iron = 1)
	time = 1 SECONDS
	category = CAT_ATMOSPHERIC
	additional_req_text = " smart pipe fitting"

/datum/crafting_recipe/layer_adapter/check_requirements(mob/user, list/collected_requirements)
	return atmos_pipe_check(user, collected_requirements)

/datum/crafting_recipe/layer_adapter/on_craft_completion(mob/user, atom/result)
	var/obj/item/pipe/crafted_pipe = result
	crafted_pipe.pipe_type = /obj/machinery/atmospherics/pipe/layer_manifold
	crafted_pipe.pipe_color = COLOR_VERY_LIGHT_GRAY
	crafted_pipe.setDir(user.dir)
	crafted_pipe.update()

/datum/crafting_recipe/color_adapter
	name = "Color adapter fitting"
	tool_behaviors = list(TOOL_WRENCH, TOOL_WELDER)
	result = /obj/item/pipe/binary
	reqs = list(
		/obj/item/pipe = 1,
		/obj/item/stack/sheet/iron = 1)
	time = 1 SECONDS
	category = CAT_ATMOSPHERIC
	additional_req_text = " smart pipe fitting"

/datum/crafting_recipe/color_adapter/check_requirements(mob/user, list/collected_requirements)
	return atmos_pipe_check(user, collected_requirements)

/datum/crafting_recipe/color_adapter/on_craft_completion(mob/user, atom/result)
	var/obj/item/pipe/crafted_pipe = result
	crafted_pipe.pipe_type = /obj/machinery/atmospherics/pipe/color_adapter
	crafted_pipe.pipe_color = COLOR_VERY_LIGHT_GRAY
	crafted_pipe.setDir(user.dir)
	crafted_pipe.update()

/datum/crafting_recipe/he_pipe
	name = "H/E pipe fitting"
	tool_behaviors = list(TOOL_WRENCH, TOOL_WELDER)
	result = /obj/item/pipe/quaternary
	reqs = list(
		/obj/item/pipe = 1,
		/obj/item/stack/sheet/iron = 1)
	time = 1 SECONDS
	category = CAT_ATMOSPHERIC
	additional_req_text = " smart pipe fitting"

/datum/crafting_recipe/he_pipe/check_requirements(mob/user, list/collected_requirements)
	return atmos_pipe_check(user, collected_requirements)

/datum/crafting_recipe/he_pipe/on_craft_completion(mob/user, atom/result)
	var/obj/item/pipe/crafted_pipe = result
	crafted_pipe.pipe_type = /obj/machinery/atmospherics/pipe/heat_exchanging/manifold4w
	crafted_pipe.pipe_color = COLOR_VERY_LIGHT_GRAY
	crafted_pipe.setDir(user.dir)
	crafted_pipe.update()

/datum/crafting_recipe/he_junction
	name = "H/E junction fitting"
	tool_behaviors = list(TOOL_WRENCH, TOOL_WELDER)
	result = /obj/item/pipe/directional
	reqs = list(
		/obj/item/pipe = 1,
		/obj/item/stack/sheet/iron = 1)
	time = 1 SECONDS
	category = CAT_ATMOSPHERIC
	additional_req_text = " smart pipe fitting"

/datum/crafting_recipe/he_junction/check_requirements(mob/user, list/collected_requirements)
	return atmos_pipe_check(user, collected_requirements)

/datum/crafting_recipe/he_junction/on_craft_completion(mob/user, atom/result)
	var/obj/item/pipe/crafted_pipe = result
	crafted_pipe.pipe_type = /obj/machinery/atmospherics/pipe/heat_exchanging/junction
	crafted_pipe.pipe_color = COLOR_VERY_LIGHT_GRAY
	crafted_pipe.setDir(user.dir)
	crafted_pipe.update()

/datum/crafting_recipe/pressure_pump
	name = "Pressure pump fitting"
	tool_behaviors = list(TOOL_WRENCH, TOOL_WELDER)
	result = /obj/item/pipe/binary
	reqs = list(
		/obj/item/pipe = 1,
		/obj/item/stack/sheet/iron = 5,
		/obj/item/stack/cable_coil = 5)
	time = 2 SECONDS
	category = CAT_ATMOSPHERIC
	additional_req_text = " smart pipe fitting"

/datum/crafting_recipe/pressure_pump/check_requirements(mob/user, list/collected_requirements)
	return atmos_pipe_check(user, collected_requirements)

/datum/crafting_recipe/pressure_pump/on_craft_completion(mob/user, atom/result)
	var/obj/item/pipe/crafted_pipe = result
	crafted_pipe.pipe_type = /obj/machinery/atmospherics/components/binary/pump
	crafted_pipe.pipe_color = COLOR_VERY_LIGHT_GRAY
	crafted_pipe.setDir(user.dir)
	crafted_pipe.update()

/datum/crafting_recipe/manual_valve
	name = "Manual valve fitting"
	tool_behaviors = list(TOOL_WRENCH, TOOL_WELDER)
	result = /obj/item/pipe/binary
	reqs = list(
		/obj/item/pipe = 1,
		/obj/item/stack/sheet/iron = 1)
	time = 2 SECONDS
	category = CAT_ATMOSPHERIC
	additional_req_text = " smart pipe fitting"

/datum/crafting_recipe/manual_valve/check_requirements(mob/user, list/collected_requirements)
	return atmos_pipe_check(user, collected_requirements)

/datum/crafting_recipe/manual_valve/on_craft_completion(mob/user, atom/result)
	var/obj/item/pipe/crafted_pipe = result
	crafted_pipe.pipe_type = /obj/machinery/atmospherics/components/binary/valve
	crafted_pipe.pipe_color = COLOR_VERY_LIGHT_GRAY
	crafted_pipe.setDir(user.dir)
	crafted_pipe.update()

/datum/crafting_recipe/vent
	name = "Vent pump fitting"
	tool_behaviors = list(TOOL_WRENCH, TOOL_WELDER)
	result = /obj/item/pipe/directional
	reqs = list(
		/obj/item/pipe = 1,
		/obj/item/stack/sheet/iron = 5,
		/obj/item/stack/cable_coil = 5)
	time = 2 SECONDS
	category = CAT_ATMOSPHERIC
	additional_req_text = " smart pipe fitting"

/datum/crafting_recipe/vent/check_requirements(mob/user, list/collected_requirements)
	return atmos_pipe_check(user, collected_requirements)

/datum/crafting_recipe/vent/on_craft_completion(mob/user, atom/result)
	var/obj/item/pipe/crafted_pipe = result
	crafted_pipe.pipe_type = /obj/machinery/atmospherics/components/unary/vent_pump
	crafted_pipe.pipe_color = COLOR_VERY_LIGHT_GRAY
	crafted_pipe.setDir(user.dir)
	crafted_pipe.update()

/datum/crafting_recipe/scrubber
	name = "Scrubber fitting"
	tool_behaviors = list(TOOL_WRENCH, TOOL_WELDER)
	result = /obj/item/pipe/directional
	reqs = list(
		/obj/item/pipe = 1,
		/obj/item/stack/sheet/iron = 5,
		/obj/item/stack/cable_coil = 5)
	time = 2 SECONDS
	category = CAT_ATMOSPHERIC
	additional_req_text = " smart pipe fitting"

/datum/crafting_recipe/scrubber/check_requirements(mob/user, list/collected_requirements)
	return atmos_pipe_check(user, collected_requirements)

/datum/crafting_recipe/scrubber/on_craft_completion(mob/user, atom/result)
	var/obj/item/pipe/crafted_pipe = result
	crafted_pipe.pipe_type = /obj/machinery/atmospherics/components/unary/vent_scrubber
	crafted_pipe.pipe_color = COLOR_VERY_LIGHT_GRAY
	crafted_pipe.setDir(user.dir)
	crafted_pipe.update()

/datum/crafting_recipe/filter
	name = "Filter fitting"
	tool_behaviors = list(TOOL_WRENCH, TOOL_WELDER)
	result = /obj/item/pipe/trinary/flippable
	reqs = list(
		/obj/item/pipe = 1,
		/obj/item/stack/sheet/iron = 5,
		/obj/item/stack/cable_coil = 5)
	time = 2 SECONDS
	category = CAT_ATMOSPHERIC
	additional_req_text = " smart pipe fitting"

/datum/crafting_recipe/filter/check_requirements(mob/user, list/collected_requirements)
	return atmos_pipe_check(user, collected_requirements)

/datum/crafting_recipe/filter/on_craft_completion(mob/user, atom/result)
	var/obj/item/pipe/crafted_pipe = result
	crafted_pipe.pipe_type = /obj/machinery/atmospherics/components/trinary/filter
	crafted_pipe.pipe_color = COLOR_VERY_LIGHT_GRAY
	crafted_pipe.setDir(user.dir)
	crafted_pipe.update()

/datum/crafting_recipe/mixer
	name = "Mixer fitting"
	tool_behaviors = list(TOOL_WRENCH, TOOL_WELDER)
	result = /obj/item/pipe/trinary/flippable
	reqs = list(
		/obj/item/pipe = 1,
		/obj/item/stack/sheet/iron = 5,
		/obj/item/stack/cable_coil = 5)
	time = 2 SECONDS
	category = CAT_ATMOSPHERIC
	additional_req_text = " smart pipe fitting"

/datum/crafting_recipe/mixer/check_requirements(mob/user, list/collected_requirements)
	return atmos_pipe_check(user, collected_requirements)

/datum/crafting_recipe/mixer/on_craft_completion(mob/user, atom/result)
	var/obj/item/pipe/crafted_pipe = result
	crafted_pipe.pipe_type = /obj/machinery/atmospherics/components/trinary/mixer
	crafted_pipe.pipe_color = COLOR_VERY_LIGHT_GRAY
	crafted_pipe.setDir(user.dir)
	crafted_pipe.update()

/datum/crafting_recipe/connector
	name = "Portable connector fitting"
	tool_behaviors = list(TOOL_WRENCH, TOOL_WELDER)
	result = /obj/item/pipe/directional
	reqs = list(
		/obj/item/pipe = 1,
		/obj/item/stack/sheet/iron = 1)
	time = 2 SECONDS
	category = CAT_ATMOSPHERIC
	additional_req_text = " smart pipe fitting"

/datum/crafting_recipe/connector/check_requirements(mob/user, list/collected_requirements)
	return atmos_pipe_check(user, collected_requirements)

/datum/crafting_recipe/connector/on_craft_completion(mob/user, atom/result)
	var/obj/item/pipe/crafted_pipe = result
	crafted_pipe.pipe_type = /obj/machinery/atmospherics/components/unary/portables_connector
	crafted_pipe.pipe_color = COLOR_VERY_LIGHT_GRAY
	crafted_pipe.setDir(user.dir)
	crafted_pipe.update()

/datum/crafting_recipe/passive_vent
	name = "Passive vent fitting"
	tool_behaviors = list(TOOL_WRENCH, TOOL_WELDER)
	result = /obj/item/pipe/directional
	reqs = list(
		/obj/item/pipe = 1,
		/obj/item/stack/sheet/iron = 1)
	time = 2 SECONDS
	category = CAT_ATMOSPHERIC
	additional_req_text = " smart pipe fitting"

/datum/crafting_recipe/passive_vent/check_requirements(mob/user, list/collected_requirements)
	return atmos_pipe_check(user, collected_requirements)

/datum/crafting_recipe/passive_vent/on_craft_completion(mob/user, atom/result)
	var/obj/item/pipe/crafted_pipe = result
	crafted_pipe.pipe_type = /obj/machinery/atmospherics/components/unary/passive_vent
	crafted_pipe.pipe_color = COLOR_VERY_LIGHT_GRAY
	crafted_pipe.setDir(user.dir)
	crafted_pipe.update()

/datum/crafting_recipe/injector
	name = "Outlet injector fitting"
	tool_behaviors = list(TOOL_WRENCH, TOOL_WELDER)
	result = /obj/item/pipe/directional
	reqs = list(
		/obj/item/pipe = 1,
		/obj/item/stack/sheet/iron = 1,
		/obj/item/stack/cable_coil = 5)
	time = 2 SECONDS
	category = CAT_ATMOSPHERIC
	additional_req_text = " smart pipe fitting"

/datum/crafting_recipe/injector/check_requirements(mob/user, list/collected_requirements)
	return atmos_pipe_check(user, collected_requirements)

/datum/crafting_recipe/injector/on_craft_completion(mob/user, atom/result)
	var/obj/item/pipe/crafted_pipe = result
	crafted_pipe.pipe_type = /obj/machinery/atmospherics/components/unary/outlet_injector
	crafted_pipe.pipe_color = COLOR_VERY_LIGHT_GRAY
	crafted_pipe.setDir(user.dir)
	crafted_pipe.update()

/datum/crafting_recipe/he_exchanger
	name = "Heat exchanger fitting"
	tool_behaviors = list(TOOL_WRENCH, TOOL_WELDER)
	result = /obj/item/pipe/directional
	reqs = list(
		/obj/item/pipe = 1,
		/obj/item/stack/sheet/plasteel = 1)
	time = 2 SECONDS
	category = CAT_ATMOSPHERIC
	additional_req_text = " smart pipe fitting"

/datum/crafting_recipe/he_exchanger/check_requirements(mob/user, list/collected_requirements)
	return atmos_pipe_check(user, collected_requirements)

/datum/crafting_recipe/he_exchanger/on_craft_completion(mob/user, atom/result)
	var/obj/item/pipe/crafted_pipe = result
	crafted_pipe.pipe_type = /obj/machinery/atmospherics/components/unary/heat_exchanger
	crafted_pipe.pipe_color = COLOR_VERY_LIGHT_GRAY
	crafted_pipe.setDir(user.dir)
	crafted_pipe.update()

#undef CRAFTING_MACHINERY_CONSUME
#undef CRAFTING_MACHINERY_USE
