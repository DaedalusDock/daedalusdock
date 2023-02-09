/datum/job/paramedic
	title = JOB_PARAMEDIC
	description = "Run around the station looking for patients, respond to \
		emergencies, give patients a roller bed ride to medbay."
	department_head = list(JOB_CHIEF_MEDICAL_OFFICER)
	faction = FACTION_STATION
	total_positions = 2
	spawn_positions = 2
	supervisors = "the medical director"
	selection_color = "#ffeef0"
	exp_granted_type = EXP_TYPE_CREW

	outfits = list(
		"Default" = list(
			SPECIES_HUMAN = /datum/outfit/job/paramedic,
			SPECIES_PLASMAMAN = /datum/outfit/job/paramedic/plasmaman,
		),
	)

	paycheck = PAYCHECK_MEDIUM
	paycheck_department = ACCOUNT_STATION_MASTER

	liver_traits = list(TRAIT_MEDICAL_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_PARAMEDIC
	bounty_types = CIV_JOB_MED
	departments_list = list(
		/datum/job_department/medical,
		)

	family_heirlooms = list(/obj/item/storage/medkit/ancient/heirloom)

	mail_goodies = list(
		/obj/item/reagent_containers/hypospray/medipen = 20,
		/obj/item/reagent_containers/hypospray/medipen/oxandrolone = 10,
		/obj/item/reagent_containers/hypospray/medipen/salacid = 10,
		/obj/item/reagent_containers/hypospray/medipen/salbutamol = 10,
		/obj/item/reagent_containers/hypospray/medipen/penacid = 10,
		/obj/item/reagent_containers/hypospray/medipen/survival/luxury = 5
	)
	rpg_title = "Corpse Runner"
	job_flags = JOB_ANNOUNCE_ARRIVAL | JOB_CREW_MANIFEST | JOB_EQUIP_RANK | JOB_CREW_MEMBER | JOB_NEW_PLAYER_JOINABLE | JOB_REOPEN_ON_ROUNDSTART_LOSS | JOB_ASSIGN_QUIRKS | JOB_CAN_BE_INTERN


/datum/outfit/job/paramedic
	name = "Paramedic"
	jobtype = /datum/job/paramedic

	id = /obj/item/card/id/advanced
	id_trim = /datum/id_trim/job/paramedic
	uniform = /obj/item/clothing/under/rank/medical/paramedic
	suit = /obj/item/clothing/suit/toggle/labcoat/paramedic
	suit_store = /obj/item/flashlight/pen/paramedic
	backpack_contents = list(
		/obj/item/roller = 1,
		)
	belt = /obj/item/storage/belt/medical/paramedic
	ears = /obj/item/radio/headset/headset_med
	head = /obj/item/clothing/head/soft/paramedic
	gloves = /obj/item/clothing/gloves/color/latex/nitrile
	shoes = /obj/item/clothing/shoes/sneakers/blue
	l_pocket = /obj/item/modular_computer/tablet/pda/medical

	backpack = /obj/item/storage/backpack/medic
	satchel = /obj/item/storage/backpack/satchel/med
	duffelbag = /obj/item/storage/backpack/duffelbag/med

	box = /obj/item/storage/box/survival/medical
	chameleon_extras = /obj/item/gun/syringe
	pda_slot = ITEM_SLOT_LPOCKET

/datum/outfit/job/paramedic/plasmaman
	name = "Paramedic (Plasmaman)"

	uniform = /obj/item/clothing/under/plasmaman/paramedic
	gloves = /obj/item/clothing/gloves/color/plasmaman/plasmanitrile
	head = /obj/item/clothing/head/helmet/space/plasmaman/paramedic
	mask = /obj/item/clothing/mask/breath
	r_hand = /obj/item/tank/internals/plasmaman/belt/full
