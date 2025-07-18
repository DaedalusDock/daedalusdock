// /datum/job/security_consultant
// 	title = JOB_SECURITY_CONSULTANT
// 	description = "Handles relationships with Mars Executive Outcomes. Acts as a guard for Management."
// 	department_head = list(JOB_CAPTAIN)
// 	faction = FACTION_STATION
// 	total_positions = 1
// 	spawn_positions = 1
// 	supervisors = "the superintendent"
// 	selection_color = "#1d1d4f"
// 	req_admin_notify = 1
// 	minimal_player_age = 10
// 	exp_requirements = 180
// 	exp_required_type = EXP_TYPE_CREW
// 	exp_required_type_department = EXP_TYPE_SECURITY
// 	exp_granted_type = EXP_TYPE_CREW

// 	employers = list(
// 		/datum/employer/government
// 	)

// 	outfits = list(
// 		"Default" = list(
// 			SPECIES_HUMAN = /datum/outfit/job/security_consultant,
// 		),
// 	)

// 	departments_list = list(
// 		/datum/job_department/command,
// 	)

// 	paycheck = PAYCHECK_COMMAND
// 	paycheck_department = ACCOUNT_SEC

// 	liver_traits = list(TRAIT_ROYAL_METABOLISM)

// 	mail_goodies = list(
// 		/obj/item/card/id/advanced/silver = 10,
// 		/obj/item/stack/sheet/bone = 5
// 	)

// 	family_heirlooms = list(/obj/item/reagent_containers/cup/glass/trophy/silver_cup)
// 	rpg_title = "Knight"
// 	job_flags = JOB_ANNOUNCE_ARRIVAL | JOB_CREW_MANIFEST | JOB_EQUIP_RANK | JOB_CREW_MEMBER | JOB_NEW_PLAYER_JOINABLE | JOB_REOPEN_ON_ROUNDSTART_LOSS | JOB_ASSIGN_QUIRKS | JOB_CAN_BE_INTERN

// /datum/job/security_consultant/get_captaincy_announcement(mob/living/captain)
// 	return "Due to staffing shortages, newly promoted Acting Captain [captain.real_name] on deck!"

// /datum/outfit/job/security_consultant
// 	name = JOB_SECURITY_CONSULTANT
// 	jobtype = /datum/job/security_consultant
// 	allow_jumpskirt = FALSE

// 	id = /obj/item/card/id/advanced/silver
// 	id_template = /datum/access_template/job/head_of_personnel
// 	uniform = /obj/item/clothing/under/suit/burgundy
// 	suit = /obj/item/clothing/suit/armor/vest/ballistic
// 	belt = /obj/item/modular_computer/tablet/pda
// 	gloves = /obj/item/clothing/gloves/color/black
// 	ears = /obj/item/radio/headset/heads/captain
// 	glasses = /obj/item/clothing/glasses/sunglasses
// 	shoes = /obj/item/clothing/shoes/laceup
