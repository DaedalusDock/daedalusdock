/datum/job/curator
	title = JOB_CURATOR
	description = "Read and write books and hand them to people, stock \
		bookshelves, report on station news."
	department_head = list(JOB_HEAD_OF_PERSONNEL)
	faction = FACTION_STATION
	total_positions = 1
	spawn_positions = 1
	supervisors = "the head of personnel"
	exp_granted_type = EXP_TYPE_CREW

	employers = list(
		/datum/employer/contractor,
		/datum/employer/priapus
	)

	outfits = list(
		"Default" = list(
			SPECIES_HUMAN = /datum/outfit/job/curator,
			SPECIES_PLASMAMAN = /datum/outfit/job/curator/plasmaman,
		),
	)

	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_STATION_MASTER

	departments_list = list(
		/datum/job_department/service,
		)

	family_heirlooms = list(/obj/item/pen/fountain, /obj/item/storage/dice)

	job_flags = JOB_ANNOUNCE_ARRIVAL | JOB_CREW_MANIFEST | JOB_EQUIP_RANK | JOB_CREW_MEMBER | JOB_NEW_PLAYER_JOINABLE | JOB_REOPEN_ON_ROUNDSTART_LOSS | JOB_ASSIGN_QUIRKS | JOB_CAN_BE_INTERN

	voice_of_god_silence_power = 3
	rpg_title = "Veteran Adventurer"

/datum/outfit/job/curator
	name = "Curator"
	jobtype = /datum/job/curator

	id_trim = /datum/id_trim/job/curator
	uniform = /obj/item/clothing/under/rank/civilian/curator
	backpack_contents = list(
		/obj/item/barcodescanner = 1,
		/obj/item/choice_beacon/hero = 1,
	)
	belt = /obj/item/modular_computer/tablet/pda/curator
	ears = /obj/item/radio/headset/headset_srv
	shoes = /obj/item/clothing/shoes/laceup
	l_pocket = /obj/item/laser_pointer
	r_pocket = /obj/item/key/displaycase
	l_hand = /obj/item/storage/bag/books

	accessory = /obj/item/clothing/accessory/pocketprotector/full

/datum/outfit/job/curator/plasmaman
	name = "Curator (Plasmaman)"

	uniform = /obj/item/clothing/under/plasmaman/curator
	gloves = /obj/item/clothing/gloves/color/plasmaman/prototype
	head = /obj/item/clothing/head/helmet/space/plasmaman/curator
	mask = /obj/item/clothing/mask/breath
	r_hand = /obj/item/tank/internals/plasmaman/belt/full

/datum/outfit/job/curator/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()

	if(visualsOnly)
		return

	H.grant_all_languages(TRUE, TRUE, TRUE, LANGUAGE_CURATOR)
