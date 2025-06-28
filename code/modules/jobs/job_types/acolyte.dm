/datum/job/acolyte
	title = JOB_ACOLYTE
	department_head = list(JOB_AUGUR)
	faction = FACTION_STATION
	total_positions = 5
	spawn_positions = 3
	selection_color = "#013d3b"
	exp_granted_type = EXP_TYPE_CREW

	employers = list(
		/datum/employer/aether,
	)

	outfits = list(
		"Default" = list(
			SPECIES_HUMAN = /datum/outfit/job/doctor,
		),
	)

	paycheck = PAYCHECK_MEDIUM
	paycheck_department = ACCOUNT_MED

	mind_traits = list(TRAIT_AETHERITE)
	liver_traits = list(TRAIT_MEDICAL_METABOLISM)
	languages = list(/datum/language/aether)

	departments_list = list(
		/datum/job_department/medical,
		)

	family_heirlooms = list(/obj/item/storage/medkit/ancient/heirloom)

	mail_goodies = list(
		/obj/item/scalpel/advanced = 6,
		/obj/item/retractor/advanced = 6,
		/obj/item/cautery/advanced = 6,
		/obj/item/reagent_containers/cup/bottle/space_cleaner = 6,
		/obj/effect/spawner/random/medical/organs = 5,
		/obj/effect/spawner/random/medical/memeorgans = 1
	)
	rpg_title = "Cleric"
	job_flags = JOB_ANNOUNCE_ARRIVAL | JOB_CREW_MANIFEST | JOB_EQUIP_RANK | JOB_CREW_MEMBER | JOB_NEW_PLAYER_JOINABLE | JOB_REOPEN_ON_ROUNDSTART_LOSS | JOB_ASSIGN_QUIRKS | JOB_CAN_BE_INTERN

/datum/job/acolyte/New()
	. = ..()
	description = "A member of a strange religious organization, you aid your \
	<span style='color:[/datum/job/augur::selection_color]'>Augur</span> in maintaining the Sacred Cycle. \
	Aid those who are not yet ready to pass unto the Ephemeral Twilight, and condemn those who attempt to avoid it."

/datum/job/acolyte/after_spawn(mob/living/spawned, client/player_client)
	. = ..()
	if(!isvox(spawned))
		spawned.AddComponent(/datum/component/clothing_lover, list(/obj/item/clothing/mask/utopia), "aether_maskless", /datum/mood_event/aether_maskless, ITEM_SLOT_MASK)

/datum/outfit/job/doctor
	name = JOB_ACOLYTE
	jobtype = /datum/job/acolyte

	id_template = /datum/access_template/job/medical_doctor
	neck = /obj/item/clothing/neck/stethoscope
	uniform = /obj/item/clothing/under/aether_robes
	belt = /obj/item/pager/aether
	ears = /obj/item/radio/headset/headset_med
	shoes = /obj/item/clothing/shoes/sneakers/white
	l_hand = /obj/item/storage/medkit/surgery
	mask = /obj/item/clothing/mask/utopia

	back = /obj/item/storage/backpack/satchel/leather

	box = /obj/item/storage/box/survival/medical
	chameleon_extras = /obj/item/gun/syringe

	backpack_contents = list(
		/obj/item/diagnosis_book = 1,
	)

/datum/outfit/job/doctor/post_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	astype(H.w_uniform.GetComponent(/datum/component/hooded), /datum/component/hooded)?.try_equip_hood(H.w_uniform, H)

/datum/outfit/job/doctor/mod
	name = JOB_ACOLYTE + " (MODsuit)"

	suit_store = /obj/item/tank/internals/oxygen
	back = /obj/item/mod/control/pre_equipped/medical
	suit = null
	mask = /obj/item/clothing/mask/breath/medical
	r_pocket = /obj/item/flashlight/pen
	internals_slot = ITEM_SLOT_SUITSTORE
	backpack_contents = null
	box = null
