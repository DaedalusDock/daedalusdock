/datum/job/geneticist
	title = JOB_GENETICIST
	description = "Alter genomes, turn monkeys into humans (and vice-versa), and make DNA backups."
	department_head = list(JOB_RESEARCH_DIRECTOR)
	faction = FACTION_STATION
	total_positions = 2
	spawn_positions = 2
	supervisors = "the research director"
	selection_color = "#3d273d"
	exp_requirements = 60
	exp_required_type = EXP_TYPE_CREW
	exp_granted_type = EXP_TYPE_CREW

	employers = list(
		/datum/employer/contractor,
		/datum/employer/ananke,
		/datum/employer/aether
	)

	outfits = list(
		"Default" = list(
			SPECIES_HUMAN = /datum/outfit/job/geneticist,
			SPECIES_PLASMAMAN = /datum/outfit/job/geneticist/plasmaman,
		),
	)

	departments_list = list(
		/datum/job_department/science,
		)

	paycheck = PAYCHECK_MEDIUM
	paycheck_department = ACCOUNT_STATION_MASTER

	bounty_types = CIV_JOB_SCI

	mail_goodies = list(
		/obj/item/storage/box/monkeycubes = 10
	)

	family_heirlooms = list(/obj/item/clothing/under/shorts/purple)
	rpg_title = "Genemancer"
	job_flags = JOB_ANNOUNCE_ARRIVAL | JOB_CREW_MANIFEST | JOB_EQUIP_RANK | JOB_CREW_MEMBER | JOB_NEW_PLAYER_JOINABLE | JOB_REOPEN_ON_ROUNDSTART_LOSS | JOB_ASSIGN_QUIRKS | JOB_CAN_BE_INTERN


/datum/outfit/job/geneticist
	name = "Geneticist"
	jobtype = /datum/job/geneticist

	id_trim = /datum/id_trim/job/geneticist
	uniform = /obj/item/clothing/under/rank/rnd/geneticist
	suit = /obj/item/clothing/suit/toggle/labcoat/genetics
	suit_store = /obj/item/flashlight/pen
	belt = /obj/item/modular_computer/tablet/pda/geneticist
	ears = /obj/item/radio/headset/headset_sci
	shoes = /obj/item/clothing/shoes/sneakers/white
	l_pocket = /obj/item/sequence_scanner

	backpack = /obj/item/storage/backpack/genetics
	satchel = /obj/item/storage/backpack/satchel/gen
	duffelbag = /obj/item/storage/backpack/duffelbag/genetics

/datum/outfit/job/geneticist/plasmaman
	name = "Geneticist (Plasmaman)"

	uniform = /obj/item/clothing/under/plasmaman/genetics
	gloves = /obj/item/clothing/gloves/color/plasmaman/white
	head = /obj/item/clothing/head/helmet/space/plasmaman/genetics
	mask = /obj/item/clothing/mask/breath
	r_hand = /obj/item/tank/internals/plasmaman/belt/full
