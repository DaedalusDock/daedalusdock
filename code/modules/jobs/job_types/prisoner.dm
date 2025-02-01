/datum/job/prisoner
	title = JOB_PRISONER
	description = "Keep yourself occupied in permabrig."
	department_head = list("The Security Team")
	faction = FACTION_STATION
	total_positions = 0
	spawn_positions = 2
	selection_color = "#bd630a"
	exp_granted_type = EXP_TYPE_CREW
	paycheck = PAYCHECK_ZERO //This doesnt actually do anything since prisoners have no department

	outfits = list(
		"Default" = list(
			SPECIES_HUMAN = /datum/outfit/job/prisoner,
		),
	)

	department_for_prefs = /datum/job_department/security

	exclusive_mail_goodies = TRUE
	mail_goodies = list (
		/obj/effect/spawner/random/contraband/prison = 1
	)

	family_heirlooms = list(/obj/item/pen/blue)
	rpg_title = "Defeated Miniboss"
	default_security_status = CRIMINAL_INCARCERATED
	job_flags = JOB_ANNOUNCE_ARRIVAL | JOB_CREW_MANIFEST | JOB_EQUIP_RANK | JOB_CREW_MEMBER | JOB_ASSIGN_QUIRKS | JOB_CAN_BE_INTERN


/datum/outfit/job/prisoner
	name = "Prisoner"
	jobtype = /datum/job/prisoner

	id = /obj/item/card/id/advanced/prisoner
	id_trim = /datum/id_trim/job/prisoner
	uniform = /obj/item/clothing/under/rank/prisoner
	belt = null
	ears = null
	shoes = /obj/item/clothing/shoes/sneakers/orange

/datum/outfit/job/prisoner/pre_equip(mob/living/carbon/human/H)
	..()
	if(prob(1)) // D BOYYYYSSSSS
		head = /obj/item/clothing/head/beanie/black/dboy
