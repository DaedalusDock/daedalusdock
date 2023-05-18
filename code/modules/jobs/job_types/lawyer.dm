/datum/job/lawyer
	title = JOB_LAWYER
	description = "Advocate for prisoners, create law-binding contracts, \
		ensure Security is following protocol and Space Law."
	department_head = list(JOB_HEAD_OF_PERSONNEL)
	faction = FACTION_STATION
	total_positions = 2
	spawn_positions = 2
	supervisors = "the head of personnel"
	exp_granted_type = EXP_TYPE_CREW

	employers = list(
		/datum/employer/contractor,
	)

	outfits = list(
		"Default" = list(
			SPECIES_HUMAN = /datum/outfit/job/lawyer,
			SPECIES_PLASMAMAN = /datum/outfit/job/lawyer/plasmaman,
		),
		"Defence Attorney" = list(
			SPECIES_HUMAN = /datum/outfit/job/lawyer/defence,
			SPECIES_VOX = /datum/outfit/job/lawyer/defence,
		),
		"Prosecutor" = list(
			SPECIES_HUMAN = /datum/outfit/job/lawyer/prosecutor,
			SPECIES_VOX = /datum/outfit/job/lawyer/prosecutor,
		),
	)

	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_STATION_MASTER

	mind_traits = list(TRAIT_DONUT_LOVER)
	liver_traits = list(TRAIT_LAW_ENFORCEMENT_METABOLISM)

	departments_list = list(
		/datum/job_department/service,
		)
	rpg_title = "Magistrate"
	family_heirlooms = list(/obj/item/gavelhammer, /obj/item/book/manual/wiki/security_space_law)

	job_flags = JOB_ANNOUNCE_ARRIVAL | JOB_CREW_MANIFEST | JOB_EQUIP_RANK | JOB_CREW_MEMBER | JOB_NEW_PLAYER_JOINABLE | JOB_REOPEN_ON_ROUNDSTART_LOSS | JOB_ASSIGN_QUIRKS | JOB_CAN_BE_INTERN


/datum/outfit/job/lawyer
	name = "Lawyer"
	jobtype = /datum/job/lawyer

	id_trim = /datum/id_trim/job/lawyer
	uniform = /obj/item/clothing/under/rank/civilian/lawyer/black
	belt = /obj/item/modular_computer/tablet/pda/lawyer
	ears = /obj/item/radio/headset/headset_srvsec
	shoes = /obj/item/clothing/shoes/laceup
	l_pocket = /obj/item/laser_pointer
	r_pocket = /obj/item/clothing/accessory/lawyers_badge
	l_hand = /obj/item/storage/briefcase/lawyer

	chameleon_extras = /obj/item/stamp/law

/datum/outfit/job/lawyer/plasmaman
	name = "Lawyer (Plasmaman)"

	uniform = /obj/item/clothing/under/plasmaman/enviroslacks
	gloves = /obj/item/clothing/gloves/color/plasmaman/white
	head = /obj/item/clothing/head/helmet/space/plasmaman/white
	mask = /obj/item/clothing/mask/breath
	r_hand = /obj/item/tank/internals/plasmaman/belt/full

/* Commenting this out for now, since it overrides alternate job title outfits
/datum/outfit/job/lawyer/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(visualsOnly)
		return ..()

	var/static/use_purple_suit = FALSE //If there is one lawyer, they get the default blue suit. If another lawyer joins the round, they start with a purple suit.
	if(use_purple_suit)
		uniform = /obj/item/clothing/under/rank/civilian/lawyer/purpsuit
		suit = /obj/item/clothing/suit/toggle/lawyer/purple
	else
		use_purple_suit = TRUE
	..()

/datum/outfit/job/lawyer/get_types_to_preload()
	. = ..()
	. += /obj/item/clothing/under/rank/civilian/lawyer/purpsuit
	. += /obj/item/clothing/suit/toggle/lawyer/purple*/

/datum/outfit/job/lawyer/defence
	name = "Defence Attorney"
	uniform = /obj/item/clothing/under/rank/civilian/lawyer/blue

/datum/outfit/job/lawyer/prosecutor
	name = "Prosecutor"
	uniform = /obj/item/clothing/under/rank/civilian/lawyer/red
