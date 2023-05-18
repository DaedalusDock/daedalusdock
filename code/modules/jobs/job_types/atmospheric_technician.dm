/datum/job/atmospheric_technician
	title = JOB_ATMOSPHERIC_TECHNICIAN
	description = "Ensure the air is breathable on the station, fill oxygen tanks, fight fires, purify the air."
	department_head = list(JOB_CHIEF_ENGINEER)
	faction = FACTION_STATION
	total_positions = 3
	spawn_positions = 2
	supervisors = "the chief engineer"
	selection_color = "#5b4d20"
	exp_requirements = 60
	exp_required_type = EXP_TYPE_CREW
	exp_granted_type = EXP_TYPE_CREW

	outfit = /datum/outfit/job/atmos
	plasmaman_outfit = /datum/outfit/plasmaman/atmospherics

	outfits = list(
		"Default" = list(
			SPECIES_HUMAN = /datum/outfit/job/atmos,
			SPECIES_PLASMAMAN = /datum/outfit/job/atmos/plasmaman,
		),
	)

	paycheck = PAYCHECK_MEDIUM
	paycheck_department = ACCOUNT_STATION_MASTER

	liver_traits = list(TRAIT_ENGINEER_METABOLISM)

	bounty_types = CIV_JOB_ENG
	departments_list = list(
		/datum/job_department/engineering,
		)

	employers = list(
		/datum/employer/daedalus,
		/datum/employer/contractor
	)

	family_heirlooms = list(/obj/item/lighter, /obj/item/lighter/greyscale, /obj/item/storage/box/matches)

	mail_goodies = list(
		/obj/item/rpd_upgrade/unwrench = 30,
		/obj/item/grenade/gas_crystal/crystal_foam = 10,
		/obj/item/grenade/gas_crystal/proto_nitrate_crystal = 10,
		/obj/item/grenade/gas_crystal/healium_crystal = 10,
		/obj/item/grenade/gas_crystal/nitrous_oxide_crystal = 5,
	)

	job_flags = JOB_ANNOUNCE_ARRIVAL | JOB_CREW_MANIFEST | JOB_EQUIP_RANK | JOB_CREW_MEMBER | JOB_NEW_PLAYER_JOINABLE | JOB_REOPEN_ON_ROUNDSTART_LOSS | JOB_ASSIGN_QUIRKS | JOB_CAN_BE_INTERN
	rpg_title = "Aeromancer"

/datum/outfit/job/atmos
	name = "Atmospheric Technician"
	jobtype = /datum/job/atmospheric_technician

	id_trim = /datum/id_trim/job/atmospheric_technician
	uniform = /obj/item/clothing/under/rank/engineering/atmospheric_technician
	belt = /obj/item/storage/belt/utility/atmostech
	ears = /obj/item/radio/headset/headset_eng
	l_pocket = /obj/item/modular_computer/tablet/pda/atmos
	r_pocket = /obj/item/analyzer

	backpack = /obj/item/storage/backpack/industrial
	satchel = /obj/item/storage/backpack/satchel/eng
	duffelbag = /obj/item/storage/backpack/duffelbag/engineering

	box = /obj/item/storage/box/survival/engineer
	pda_slot = ITEM_SLOT_LPOCKET

/datum/outfit/job/atmos/plasmaman
	name = "Atmospheric Technician (Plasmaman)"

	uniform = /obj/item/clothing/under/plasmaman/atmospherics
	gloves = /obj/item/clothing/gloves/color/plasmaman/atmos
	head = /obj/item/clothing/head/helmet/space/plasmaman/atmospherics
	mask = /obj/item/clothing/mask/breath
	r_hand = /obj/item/tank/internals/plasmaman/belt/full

/datum/outfit/job/atmos/mod
	name = "Atmospheric Technician (MODsuit)"

	suit_store = /obj/item/tank/internals/oxygen
	back = /obj/item/mod/control/pre_equipped/atmospheric
	mask = /obj/item/clothing/mask/gas/atmos
	internals_slot = ITEM_SLOT_SUITSTORE
