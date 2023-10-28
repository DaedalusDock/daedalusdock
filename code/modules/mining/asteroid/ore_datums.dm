/datum/ore
	abstract_type = /datum/ore
	/// The typepath of the stack dropped when mined
	var/stack_path = null

	/// Icon state for the scan overlay
	var/scan_state

	/// Rarity
	var/rarity = MINING_NO_RANDOM_SPAWN

	// How many turfs per spawn trigger should this ore occupy
	var/turfs_per_vein_min = 0
	var/turfs_per_vein_max = 0

	// How many sheets are dropped per turf
	var/amount_per_turf_min = 0
	var/amount_per_turf_max = 0

	/// How much mining health to give to the turfs.
	var/mining_health = 0
	/// The chance to spread during spread_vein()
	var/spread_chance = 0


// -=~* COMMON ORES *~=-
/datum/ore/iron
	stack_path = /obj/item/stack/ore/iron
	scan_state = "rock_Iron"

	rarity = MINING_COMMON

	turfs_per_vein_min = 6
	turfs_per_vein_max = 16

	amount_per_turf_min = 3
	amount_per_turf_max = 6

	mining_health = 60
	spread_chance = 60

/datum/ore/silver
	stack_path = /obj/item/stack/ore/silver
	scan_state = "rock_Silver"

	rarity = MINING_COMMON

	turfs_per_vein_min = 4
	turfs_per_vein_max = 8

	amount_per_turf_min = 4
	amount_per_turf_max = 12

	mining_health = 80
	spread_chance = 20

/datum/ore/gold
	stack_path = /obj/item/stack/ore/gold
	scan_state = "rock_Gold"

	rarity = MINING_COMMON

	turfs_per_vein_min = 4
	turfs_per_vein_max = 8

	amount_per_turf_min = 4
	amount_per_turf_max = 8

	mining_health = 100
	spread_chance = 5

/datum/ore/diamond
	stack_path = /obj/item/stack/ore/diamond
	scan_state = "rock_Diamond"

	rarity = MINING_UNCOMMON

	turfs_per_vein_min = 4
	turfs_per_vein_max = 8

	amount_per_turf_min = 4
	amount_per_turf_max = 8

	mining_health = 100
	spread_chance = 5

/datum/ore/uranium
	stack_path = /obj/item/stack/ore/uranium
	scan_state = "rock_Uranium"

	rarity = MINING_RARE

	turfs_per_vein_min = 1
	turfs_per_vein_max = 2

	amount_per_turf_min = 8
	amount_per_turf_max = 16

	mining_health = 100
	spread_chance = 0

/datum/ore/plasma
	stack_path = /obj/item/stack/ore/plasma
	scan_state = "rock_Plasma"

	rarity = MINING_RARE

	turfs_per_vein_min = 2
	turfs_per_vein_max = 4

	amount_per_turf_min = 4
	amount_per_turf_max = 8

	mining_health = 100
	spread_chance = 0

/datum/ore/titanium
	stack_path = /obj/item/stack/ore/bananium
	scan_state = "rock_Titanium"

	rarity = MINING_RARE

	turfs_per_vein_min = 2
	turfs_per_vein_max = 4

	amount_per_turf_min = 8
	amount_per_turf_max = 16

	mining_health = 100
	spread_chance = 0

/datum/ore/bananium
	stack_path = /obj/item/stack/ore/bananium
	scan_state = "rock_Bananium"

	rarity = MINING_NO_RANDOM_SPAWN

	amount_per_turf_min = 8
	amount_per_turf_max = 16

	mining_health = 100

/datum/ore/bluespace_crystal
	stack_path = /obj/item/stack/ore/bluespace_crystal
	scan_state = "rock_Bluespace"
	rarity = MINING_NO_RANDOM_SPAWN

	amount_per_turf_min = 8
	amount_per_turf_max = 16

	mining_health = 100
