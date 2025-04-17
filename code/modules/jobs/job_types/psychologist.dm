/datum/job/psychologist
	title = JOB_PSYCHOLOGIST
	description = "Advocate sanity, self-esteem, and teamwork in a station \
		staffed with headcases."
	department_head = list(JOB_HEAD_OF_PERSONNEL)
	faction = FACTION_STATION
	total_positions = 1
	spawn_positions = 1
	supervisors = "the medical director"
	selection_color = "#013d3b"
	exp_granted_type = EXP_TYPE_CREW

	employers = list(
		/datum/employer/aether,
		/datum/employer/none
	)

	outfits = list(
		"Default" = list(
			SPECIES_HUMAN = /datum/outfit/job/psychologist,
		),
	)

	paycheck = PAYCHECK_MEDIUM
	paycheck_department = ACCOUNT_MED

	liver_traits = list(TRAIT_MEDICAL_METABOLISM)

	departments_list = list(
		/datum/job_department/service,
		)

	family_heirlooms = list(/obj/item/storage/pill_bottle)

	mail_goodies = list(
		/obj/item/storage/pill_bottle/alkysine = 30,
		/obj/item/storage/pill_bottle/happy = 5,
		/obj/item/gun/syringe = 1
	)
	rpg_title = "Snake Oil Salesman"
	job_flags = JOB_ANNOUNCE_ARRIVAL | JOB_CREW_MANIFEST | JOB_EQUIP_RANK | JOB_CREW_MEMBER | JOB_NEW_PLAYER_JOINABLE | JOB_REOPEN_ON_ROUNDSTART_LOSS | JOB_ASSIGN_QUIRKS | JOB_CAN_BE_INTERN


/datum/outfit/job/psychologist
	name = "Psychologist"
	jobtype = /datum/job/psychologist

	id = /obj/item/card/id/advanced
	id_trim = /datum/access_template/job/psychologist
	uniform = /obj/item/clothing/under/suit/black
	backpack_contents = list(
		/obj/item/storage/pill_bottle/lsdpsych,
		/obj/item/storage/pill_bottle/alkysine,
		/obj/item/storage/pill_bottle/paxpsych,
		/obj/item/storage/pill_bottle/haloperidol,
		)
	belt = /obj/item/modular_computer/tablet/pda/medical
	ears = /obj/item/radio/headset/headset_med
	shoes = /obj/item/clothing/shoes/laceup
	l_hand = /obj/item/clipboard

	backpack = /obj/item/storage/backpack/medic
	satchel = /obj/item/storage/backpack/satchel/med
	duffelbag = /obj/item/storage/backpack/duffelbag/med

	pda_slot = ITEM_SLOT_BELT
	skillchips = list(/obj/item/skillchip/job/psychology)
