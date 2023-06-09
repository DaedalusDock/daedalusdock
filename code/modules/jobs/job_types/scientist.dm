/datum/job/scientist
	title = JOB_SCIENTIST
	description = "Do experiments, perform research, feed the slimes, make bombs."
	department_head = list(JOB_RESEARCH_DIRECTOR)
	faction = FACTION_STATION
	total_positions = 5
	spawn_positions = 3
	supervisors = "the research director"
	selection_color = "#3d273d"
	exp_requirements = 60
	exp_required_type = EXP_TYPE_CREW
	exp_granted_type = EXP_TYPE_CREW

	employers = list(
		/datum/employer/ananke,
		/datum/employer/contractor
	)

	outfits = list(
		"Default" = list(
			SPECIES_HUMAN = /datum/outfit/job/scientist,
			SPECIES_TESHARI = /datum/outfit/job/scientist,
			SPECIES_VOX = /datum/outfit/job/scientist,
			SPECIES_PLASMAMAN = /datum/outfit/job/scientist/plasmaman,
		),
		"Xenobiologist" = list(
			SPECIES_HUMAN = /datum/outfit/job/scientist/xenobiologist,
			SPECIES_TESHARI = /datum/outfit/job/scientist/xenobiologist,
			SPECIES_PLASMAMAN = /datum/outfit/job/scientist/xenobiologist/plasmaman,
		),
	)

	paycheck = PAYCHECK_MEDIUM
	paycheck_department = ACCOUNT_STATION_MASTER

	liver_traits = list(TRAIT_BALLMER_SCIENTIST)

	bounty_types = CIV_JOB_SCI
	departments_list = list(
		/datum/job_department/science,
		)

	family_heirlooms = list(/obj/item/toy/plush/slimeplushie)

	mail_goodies = list(
		/obj/item/raw_anomaly_core/random = 10,
		/obj/item/camera_bug = 1
	)
	rpg_title = "Thaumaturgist"
	job_flags = JOB_ANNOUNCE_ARRIVAL | JOB_CREW_MANIFEST | JOB_EQUIP_RANK | JOB_CREW_MEMBER | JOB_NEW_PLAYER_JOINABLE | JOB_REOPEN_ON_ROUNDSTART_LOSS | JOB_ASSIGN_QUIRKS | JOB_CAN_BE_INTERN


/datum/outfit/job/scientist
	name = "Scientist"
	jobtype = /datum/job/scientist

	id_trim = /datum/id_trim/job/scientist
	uniform = /obj/item/clothing/under/rank/rnd/scientist
	suit = /obj/item/clothing/suit/toggle/labcoat/science
	belt = /obj/item/modular_computer/tablet/pda/science
	ears = /obj/item/radio/headset/headset_sci
	shoes = /obj/item/clothing/shoes/sneakers/white

	backpack = /obj/item/storage/backpack/science
	satchel = /obj/item/storage/backpack/satchel/science
	duffelbag = /obj/item/storage/backpack/duffelbag/science

/datum/outfit/job/scientist/plasmaman
	name = "Scientist (Plasmaman)"

	uniform = /obj/item/clothing/under/plasmaman/science
	gloves = /obj/item/clothing/gloves/color/plasmaman/white
	head = /obj/item/clothing/head/helmet/space/plasmaman/science
	mask = /obj/item/clothing/mask/breath
	r_hand = /obj/item/tank/internals/plasmaman/belt/full

/datum/outfit/job/scientist/xenobiologist
	name = "Xenobiologist"
	suit = /obj/item/clothing/suit/overalls_sci

/datum/outfit/job/scientist/xenobiologist/plasmaman
	name = "Xenobiologist (Plasmaman)"

	uniform = /obj/item/clothing/under/plasmaman/science
	gloves = /obj/item/clothing/gloves/color/plasmaman/white
	head = /obj/item/clothing/head/helmet/space/plasmaman/science
	suit = /obj/item/clothing/suit/overalls_sci

/datum/outfit/job/scientist/pre_equip(mob/living/carbon/human/H)
	..()
	try_giving_horrible_tie()

/datum/outfit/job/scientist/proc/try_giving_horrible_tie()
	if (prob(0.4))
		neck = /obj/item/clothing/neck/tie/horrible

/datum/outfit/job/scientist/get_types_to_preload()
	. = ..()
	. += /obj/item/clothing/neck/tie/horrible

/// A version of the scientist outfit that is guaranteed to be the same every time
/datum/outfit/job/scientist/consistent
	name = "Scientist - Consistent"

/datum/outfit/job/scientist/consistent/try_giving_horrible_tie()
	return
