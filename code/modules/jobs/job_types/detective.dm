/datum/job/detective
	title = JOB_DETECTIVE
	description = "Investigate crimes. Solve crimes. Cover up crimes."
	faction = FACTION_STATION
	total_positions = 1
	spawn_positions = 1
	supervisors = "nobody"
	minimal_player_age = 7
	exp_requirements = 300
	exp_required_type = EXP_TYPE_CREW
	exp_granted_type = EXP_TYPE_CREW

	employers = list(
		/datum/employer/none
	)

	outfits = list(
		"Default" = list(
			SPECIES_HUMAN = /datum/outfit/job/detective,
			SPECIES_TESHARI = /datum/outfit/job/detective,
			SPECIES_VOX = /datum/outfit/job/detective,
		),
	)

	departments_list = list(
		/datum/job_department/service,
	)

	paycheck = PAYCHECK_MEDIUM

	liver_traits = list(TRAIT_LAW_ENFORCEMENT_METABOLISM)

	mail_goodies = list(
		/obj/item/storage/fancy/cigarettes = 25,
		/obj/item/ammo_box/c38 = 25,
		/obj/item/ammo_box/c38/dumdum = 5,
		/obj/item/ammo_box/c38/hotshot = 5,
		/obj/item/ammo_box/c38/iceblox = 5,
		/obj/item/ammo_box/c38/match = 5,
		/obj/item/ammo_box/c38/trac = 5,
	)

	family_heirlooms = list(/obj/item/reagent_containers/food/drinks/bottle/whiskey)
	rpg_title = "Thiefcatcher"
	job_flags = JOB_ANNOUNCE_ARRIVAL | JOB_CREW_MANIFEST | JOB_EQUIP_RANK | JOB_CREW_MEMBER | JOB_NEW_PLAYER_JOINABLE | JOB_REOPEN_ON_ROUNDSTART_LOSS | JOB_ASSIGN_QUIRKS | JOB_CAN_BE_INTERN


/datum/job/detective/before_roundstart_possess(mob/living/spawning)
	. = ..()
	spawning.Sleeping(10 SECONDS)

/datum/outfit/job/detective
	name = JOB_DETECTIVE
	jobtype = /datum/job/detective

	id_trim = /datum/id_trim/job/detective
	uniform = /obj/item/clothing/under/rank/security/detective
	suit = /obj/item/clothing/suit/det_suit
	belt = /obj/item/modular_computer/tablet/pda/detective
	gloves = /obj/item/clothing/gloves/forensic
	head = /obj/item/clothing/head/fedora/det_hat
	neck = /obj/item/clothing/neck/tie/detective
	shoes = /obj/item/clothing/shoes/laceup
	l_pocket = /obj/item/toy/crayon/white
	r_pocket = /obj/item/storage/fancy/cigarettes/dromedaryco

	l_hand = /obj/item/storage/briefcase/crimekit

	chameleon_extras = list(
		/obj/item/clothing/glasses/sunglasses,
		/obj/item/gun/ballistic/revolver/detective,
		)

/datum/outfit/job/detective/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()
	var/obj/item/clothing/mask/cigarette/cig = H.wear_mask
	if(istype(cig)) //Some species specfic changes can mess this up (plasmamen)
		cig.light("")

	if(visualsOnly)
		return

/datum/outfit/job/detective/forensic
	name = "Forensic Technician"

	uniform = /obj/item/clothing/under/rank/security/detective/noir
	suit = /obj/item/clothing/suit/toggle/labcoat/forensic
	gloves = /obj/item/clothing/gloves/color/latex
	head = /obj/item/clothing/head/flatcap
	shoes = /obj/item/clothing/shoes/laceup
