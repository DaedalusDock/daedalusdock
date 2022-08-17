/datum/job/quartermaster
	title = JOB_QUARTERMASTER
	description = "Coordinate cargo technicians and shaft miners, assist with \
		economical purchasing."
	// department_head = list(JOB_HEAD_OF_PERSONNEL) //ORIGINAL
	department_head = list(JOB_CAPTAIN) //PARIAH EDIT
	faction = FACTION_STATION
	total_positions = 1
	spawn_positions = 1
	// supervisors = "the head of personnel" //ORIGINAL
	supervisors = "the captain" //PARIAH EDIT
	selection_color = "#d7b088"
	exp_requirements = 180 //PARIAH EDIT
	exp_required_type = EXP_TYPE_CREW //PARIAH EDIT
	exp_required_type_department = EXP_TYPE_SUPPLY
	exp_granted_type = EXP_TYPE_CREW

	outfits = list(
		"Default" = list(
			SPECIES_HUMAN = /datum/outfit/job/quartermaster,
			SPECIES_PLASMAMAN = /datum/outfit/job/quartermaster/plasmaman,
		),
	)

	// paycheck = PAYCHECK_MEDIUM //ORIGINAL
	paycheck = PAYCHECK_COMMAND //PARIAH EDIT
	paycheck_department = ACCOUNT_CAR

	// liver_traits = list(TRAIT_PRETENDER_ROYAL_METABOLISM) //ORIGINAL
	liver_traits = list(TRAIT_ROYAL_METABOLISM) //PARIAH EDIT

	display_order = JOB_DISPLAY_ORDER_QUARTERMASTER
	bounty_types = CIV_JOB_RANDOM
	departments_list = list(
		/datum/job_department/cargo,
		/datum/job_department/command, //PARIAH EDIT
		)
	family_heirlooms = list(/obj/item/stamp, /obj/item/stamp/denied)
	mail_goodies = list(
		/obj/item/circuitboard/machine/emitter = 3
	)
	rpg_title = "Steward"
	job_flags = JOB_ANNOUNCE_ARRIVAL | JOB_CREW_MANIFEST | JOB_EQUIP_RANK | JOB_CREW_MEMBER | JOB_NEW_PLAYER_JOINABLE | JOB_BOLD_SELECT_TEXT | JOB_REOPEN_ON_ROUNDSTART_LOSS | JOB_ASSIGN_QUIRKS | JOB_CAN_BE_INTERN


/datum/outfit/job/quartermaster
	name = "Quartermaster"
	jobtype = /datum/job/quartermaster

	id = /obj/item/card/id/advanced/silver //PARIAH EDIT ADDITION
	id_trim = /datum/id_trim/job/quartermaster
	uniform = /obj/item/clothing/under/rank/cargo/qm
	backpack_contents = list(
		/obj/item/melee/baton/telescopic = 1
	)
	// belt = /obj/item/modular_computer/tablet/pda/quartermaster //ORIGINAL
	belt = /obj/item/modular_computer/tablet/pda/heads/quartermaster //PARIAH EDIT
	// ears = /obj/item/radio/headset/headset_cargo //ORIGINAL
	ears = /obj/item/radio/headset/heads/qm //PARIAH EDIT
	glasses = /obj/item/clothing/glasses/sunglasses
	shoes = /obj/item/clothing/shoes/sneakers/brown
	l_hand = /obj/item/clipboard

	chameleon_extras = /obj/item/stamp/qm

/datum/outfit/job/quartermaster/plasmaman
	name = "Quartermaster (Plasmaman)"

	uniform = /obj/item/clothing/under/plasmaman/cargo
	gloves = /obj/item/clothing/gloves/color/plasmaman/cargo
	head = /obj/item/clothing/head/helmet/space/plasmaman/cargo
	mask = /obj/item/clothing/mask/breath
	r_hand= /obj/item/tank/internals/plasmaman/belt/full
