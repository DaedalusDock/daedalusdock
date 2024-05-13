/datum/job/captain
	title = JOB_CAPTAIN
	description = "The middle-man between the big man at home and the station's inhabitants. Ensure that quotas are met and the population is \
	compliant."
	auto_deadmin_role_flags = DEADMIN_POSITION_HEAD|DEADMIN_POSITION_SECURITY
	faction = FACTION_STATION
	total_positions = 1
	spawn_positions = 1
	supervisors = "the government."
	selection_color = "#2f2f7f"
	req_admin_notify = 1
	minimal_player_age = 14
	exp_requirements = 180
	exp_required_type = EXP_TYPE_CREW
	exp_required_type_department = EXP_TYPE_COMMAND
	exp_granted_type = EXP_TYPE_CREW

	employers = list(
		/datum/employer/government
	)

	outfits = list(
		"Default" = list(
			SPECIES_HUMAN = /datum/outfit/job/captain,
			SPECIES_PLASMAMAN = /datum/outfit/job/captain/plasmaman,
		),
	)

	paycheck = PAYCHECK_COMMAND
	paycheck_department = ACCOUNT_STATION_MASTER

	liver_traits = list(TRAIT_ROYAL_METABOLISM)

	departments_list = list(
		/datum/job_department/command,
		/datum/job_department/company_leader
	)


	family_heirlooms = list(/obj/item/reagent_containers/food/drinks/flask/gold, /obj/item/toy/captainsaid/collector)

	mail_goodies = list(
		/obj/item/clothing/mask/cigarette/cigar/havana = 20,
		/obj/item/storage/fancy/cigarettes/cigars/havana = 15,
		/obj/item/reagent_containers/food/drinks/bottle/champagne = 10,
		/obj/item/toy/captainsaid/collector = 20
	)

	job_flags = JOB_ANNOUNCE_ARRIVAL | JOB_CREW_MANIFEST | JOB_EQUIP_RANK | JOB_CREW_MEMBER | JOB_NEW_PLAYER_JOINABLE | JOB_REOPEN_ON_ROUNDSTART_LOSS | JOB_ASSIGN_QUIRKS | JOB_CAN_BE_INTERN
	rpg_title = "Star Duke"

	voice_of_god_power = 1.4 //Command staff has authority


/datum/job/captain/get_captaincy_announcement(mob/living/captain)
	return "[title] [captain.real_name] will be overseeing operations today."

/datum/outfit/job/captain
	name = JOB_CAPTAIN
	jobtype = /datum/job/captain
	allow_jumpskirt = FALSE

	id = /obj/item/card/id/advanced/gold
	id_trim = /datum/id_trim/job/captain
	uniform = /obj/item/clothing/under/suit/charcoal
	backpack_contents = list(
		/obj/item/assembly/flash/handheld = 1
	)
	belt = /obj/item/modular_computer/tablet/pda/captain
	ears = /obj/item/radio/headset/heads/captain
	glasses = /obj/item/clothing/glasses/sunglasses
	gloves = /obj/item/clothing/gloves/color/white
	shoes = /obj/item/clothing/shoes/laceup

	backpack = /obj/item/storage/backpack
	satchel = /obj/item/storage/backpack/satchel/cap
	duffelbag = /obj/item/storage/backpack/duffelbag/captain

	chameleon_extras = list(
		/obj/item/gun/energy/e_gun,
		/obj/item/stamp/captain,
		)
	implants = list(/obj/item/implant/mindshield)
	skillchips = list(/obj/item/skillchip/disk_verifier)

	var/special_charter

/datum/outfit/job/captain/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	var/list/job_changes = SSmapping.config.job_changes
	if(!length(job_changes))
		return
	var/list/captain_changes = job_changes["captain"]
	if(!length(captain_changes))
		return
	special_charter = captain_changes["special_charter"]
	if(!special_charter)
		return
	backpack_contents.Remove(/obj/item/station_charter)
	l_hand = /obj/item/station_charter/banner

/datum/outfit/job/captain/post_equip(mob/living/carbon/human/equipped, visualsOnly)
	. = ..()
	var/obj/item/station_charter/banner/celestial_charter = equipped.held_items[LEFT_HANDS]
	if(!celestial_charter)
		return
	celestial_charter.name_type = special_charter

/datum/outfit/job/captain/plasmaman
	name = JOB_CAPTAIN + " (Plasmaman)"

	uniform = /obj/item/clothing/under/plasmaman/captain
	gloves = /obj/item/clothing/gloves/color/captain
	head = /obj/item/clothing/head/helmet/space/plasmaman/captain
	mask = /obj/item/clothing/mask/breath
	r_hand = /obj/item/tank/internals/plasmaman/belt/full

/datum/outfit/job/captain/mod
	name = "Captain (MODsuit)"

	suit_store = /obj/item/tank/internals/oxygen
	back = /obj/item/mod/control/pre_equipped/magnate
	suit = null
	head = null
	mask = /obj/item/clothing/mask/gas/atmos/captain
	internals_slot = ITEM_SLOT_SUITSTORE
	backpack_contents = null
	box = null

/datum/outfit/job/captain/mod/post_equip(mob/living/carbon/human/equipped, visualsOnly)
	. = ..()
	if(visualsOnly)
		return

	var/obj/item/mod/control/modsuit = equipped.back
	var/obj/item/mod/module/pathfinder/module = locate() in modsuit.modules
	module.implant.implant(equipped, silent = TRUE)
