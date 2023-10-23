/datum/ore
	abstract_type = /datum/ore
	/// The typepath of the stack dropped when mined
	var/stack_path = null

	/// Icon state for the scan overlay
	var/scan_state

	/// Rarity
	var/rarity = -1

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






