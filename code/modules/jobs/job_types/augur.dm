/datum/job/augur
	title = JOB_AUGUR

	auto_deadmin_role_flags = DEADMIN_POSITION_HEAD
	head_announce = list(RADIO_CHANNEL_MEDICAL)
	faction = FACTION_STATION
	total_positions = 1
	spawn_positions = 1
	selection_color = "#026865"
	req_admin_notify = 1
	minimal_player_age = 7
	exp_requirements = 180
	exp_required_type = EXP_TYPE_CREW
	exp_required_type_department = EXP_TYPE_MEDICAL
	exp_granted_type = EXP_TYPE_CREW

	employers = list(
		/datum/employer/aether,
	)

	outfits = list(
		"Default" = list(
			SPECIES_HUMAN = /datum/outfit/job/cmo,
		),
	)

	departments_list = list(
		/datum/job_department/medical,
		/datum/job_department/company_leader,
	)

	paycheck = PAYCHECK_COMMAND
	paycheck_department = ACCOUNT_MED

	mind_traits = list(TRAIT_AETHERITE)
	liver_traits = list(TRAIT_MEDICAL_METABOLISM, TRAIT_ROYAL_METABOLISM)
	languages = list(/datum/language/aether)

	mail_goodies = list(
		/obj/effect/spawner/random/medical/organs = 10,
		/obj/effect/spawner/random/medical/memeorgans = 8,
		/obj/effect/spawner/random/medical/surgery_tool_advanced = 4,
		/obj/effect/spawner/random/medical/surgery_tool_alien = 1
	)
	family_heirlooms = list(/obj/item/storage/medkit/ancient/heirloom)
	rpg_title = "High Cleric"
	job_flags = JOB_ANNOUNCE_ARRIVAL | JOB_CREW_MANIFEST | JOB_EQUIP_RANK | JOB_CREW_MEMBER | JOB_NEW_PLAYER_JOINABLE | JOB_REOPEN_ON_ROUNDSTART_LOSS | JOB_ASSIGN_QUIRKS | JOB_CAN_BE_INTERN

	voice_of_god_power = 1.4 //Command staff has authority

/datum/job/augur/New()
	. = ..()
	description = "You are high ranking member of the Aether Association, and a powerful Hematic. \
	Lead your <span style='color:[/datum/job/acolyte::selection_color]'>Acolytes</span> in ensuring the Sacred Cycle is upheld. \
	Save those whose time has not yet come, \
	and end those who violate the circle of life. \
	Protect the Biblion tou Hema with your life."

/datum/job/augur/get_captaincy_announcement(mob/living/captain)
	return "Due to staffing shortages, newly promoted Acting Captain [captain.real_name] on deck!"

/datum/outfit/job/cmo
	name = JOB_AUGUR
	jobtype = /datum/job/augur

	id = /obj/item/card/id/advanced/silver
	id_trim = /datum/id_trim/job/chief_medical_officer
	uniform = /obj/item/clothing/under/rank/medical/chief_medical_officer
	suit = /obj/item/clothing/suit/toggle/labcoat/cmo
	belt = /obj/item/pager/aether
	ears = /obj/item/radio/headset/heads/cmo
	shoes = /obj/item/clothing/shoes/sneakers/blue
	l_pocket = /obj/item/pinpointer/crew
	l_hand = /obj/item/aether_tome

	backpack = /obj/item/storage/backpack/medic
	satchel = /obj/item/storage/backpack/satchel/med
	duffelbag = /obj/item/storage/backpack/duffelbag/med

	box = /obj/item/storage/box/survival/medical

	backpack_contents = list(
		/obj/item/diagnosis_book = 1,
	)

	chameleon_extras = list(
		/obj/item/gun/syringe,
		/obj/item/stamp/cmo,
	)

/datum/outfit/job/cmo/mod
	name = JOB_AUGUR + " (MODsuit)"

	suit_store = /obj/item/tank/internals/oxygen
	back = /obj/item/mod/control/pre_equipped/rescue
	suit = null
	mask = /obj/item/clothing/mask/breath/medical
	internals_slot = ITEM_SLOT_SUITSTORE
	backpack_contents = null
	box = null
