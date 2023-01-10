///Contains all the code associated with the Salvage Operator job, outfits, and spawning related datums.

/datum/job/salvage_operator
	title = JOB_SALVAGE_OPERATOR
	description = "Cut apart decrepit ships and abandoned hulls for profit. Survive."
	department_head = list(JOB_SALVAGE_FOREMAN)
	faction = FACTION_STATION
	total_positions = 4 //4+1 for the foreman, 5 total at max capacity
	spawn_positions = 4
	supervisors = "the company and salvage foreman"
	selection_color = "#beb752"
	exp_granted_type = EXP_TYPE_CREW //return to this later - 1/9/23

	outfits = list(
		"Default" = list(
			SPECIES_HUMAN = /datum/outfit/job/salvage_operator,
			SPECIES_PLASMAMAN = /datum/outfit/job/salvage_operator/plasmaman,
		),
	)

	paycheck = PAYCHECK_ZERO
	paycheck_department = ACCOUNT_CAR

	display_order = JOB_DISPLAY_ORDER_SALVAGE_OPERATOR
	bounty_types = CIV_JOB_BASIC
	departments_list = list(
		/datum/job_department/cargo,
		)

	family_heirlooms = list(/obj/item/pickaxe)
	rpg_title = "Carver"
	job_flags = JOB_ANNOUNCE_ARRIVAL | JOB_CREW_MANIFEST | JOB_EQUIP_RANK | JOB_CREW_MEMBER | JOB_NEW_PLAYER_JOINABLE | JOB_REOPEN_ON_ROUNDSTART_LOSS | JOB_ASSIGN_QUIRKS | JOB_CAN_BE_INTERN

/datum/job/salvage_foreman
	title = JOB_SALVAGE_FOREMAN
	description = "Bark orders to other operators. Keep the team in line and alive."
	department_head = list(JOB_SALVAGE_FOREMAN)
	faction = FACTION_STATION
	total_positions = 1
	spawn_positions = 1
	supervisors = "the company and the quartermaster"
	selection_color = "#beb752"
	exp_granted_type = EXP_TYPE_CREW

	outfits = list(
		"Default" = list(
			SPECIES_HUMAN = /datum/outfit/job/salvage_operator/foreman,
			SPECIES_PLASMAMAN = /datum/outfit/job/salvage_operator/plasmaman,
		),
	)

	paycheck = PAYCHECK_ZERO //Like operators, foremans don't get paid by the station budgets.
	paycheck_department = ACCOUNT_CAR //Theres no empty/null budget so *shrug

	display_order = JOB_DISPLAY_ORDER_SALVAGE_OPERATOR
	bounty_types = CIV_JOB_BASIC
	departments_list = list(
		/datum/job_department/cargo,
		)

	family_heirlooms = list(/obj/item/pickaxe)
	rpg_title = "Chief Carver"
	job_flags = JOB_ANNOUNCE_ARRIVAL | JOB_CREW_MANIFEST | JOB_EQUIP_RANK | JOB_CREW_MEMBER | JOB_NEW_PLAYER_JOINABLE | JOB_REOPEN_ON_ROUNDSTART_LOSS | JOB_ASSIGN_QUIRKS | JOB_CAN_BE_INTERN

///Outfit Datums

/datum/outfit/job/salvage_operator
	name = "Salvage Operator"
	jobtype = /datum/job/salvage_operator

	id_trim = /datum/id_trim/job/shaft_miner
	uniform = /obj/item/clothing/under/rank/salvage/salvage_operator
	backpack_contents = list(
		/obj/item/flashlight/seclite = 1, //fill with actual contents later
		)
	belt = /obj/item/modular_computer/tablet/pda/shaftminer
	ears = /obj/item/radio/headset/headset_cargo/mining
	gloves = /obj/item/clothing/gloves/color/black
	shoes = /obj/item/clothing/shoes/jackboots
	l_pocket = /obj/item/clothing/gloves/color/black // replace with salvage satchel

/datum/outfit/job/salvage_operator/plasmaman //needs sprites
	name = "Salvage Operator (Plasmaman)"

	uniform = /obj/item/clothing/under/plasmaman/salvage
	gloves = /obj/item/clothing/gloves/color/plasmaman/salvage
	head = /obj/item/clothing/head/helmet/space/plasmaman/salvage
	mask = /obj/item/clothing/mask/breath
	r_hand = /obj/item/tank/internals/plasmaman/belt/full

/datum/outfit/job/salvage_operator/foreman
	name = "Salvage Foreman"
	jobtype = /datum/job/salvage_foreman

	id_trim = /datum/id_trim/job/shaft_miner
	uniform = /obj/item/clothing/under/rank/salvage/foreman
	backpack_contents = list(
		/obj/item/flashlight/seclite = 1, //fill with actual contents later
		)
	belt = /obj/item/modular_computer/tablet/pda/shaftminer
	ears = /obj/item/radio/headset/headset_cargo/mining
	gloves = /obj/item/clothing/gloves/color/black
	shoes = /obj/item/clothing/shoes/jackboots
	l_pocket = /obj/item/clothing/gloves/color/black // replace with salvage satchel

///ID Datums
// Both of these are copies of the QM and Shaft Miner respectively for now until the access keys for the salvage platform are made and
// I have trims for the cards made up. -Gone

/datum/id_trim/job/salvage_foreman
	assignment = "Salvage Foreman"
	trim_state = "trim_quartermaster" //needs replaced
	sechud_icon_state = SECHUD_QUARTERMASTER //needs replaced
	extra_access = list()
	minimal_access = list(ACCESS_AUX_BASE, ACCESS_BRIG_ENTRANCE, ACCESS_CARGO, ACCESS_HEADS, ACCESS_KEYCARD_AUTH, ACCESS_MAILSORTING, ACCESS_MAINT_TUNNELS, ACCESS_MECH_MINING, ACCESS_MINING_STATION,
					ACCESS_MINERAL_STOREROOM, ACCESS_MINING, ACCESS_QM, ACCESS_RC_ANNOUNCE, ACCESS_VAULT)
	config_job = "salvage_foreman"
	template_access = list(ACCESS_CAPTAIN, ACCESS_HOP, ACCESS_CHANGE_IDS)
	job = /datum/job/salvage_foreman

/datum/id_trim/job/salvage_operator
	assignment = "Salvage Operator"
	trim_state = "trim_shaftminer" //needs replaced
	sechud_icon_state = SECHUD_SHAFT_MINER //needs replaced
	extra_access = list(ACCESS_CARGO, ACCESS_MAINT_TUNNELS, ACCESS_QM)
	minimal_access = list(ACCESS_AUX_BASE, ACCESS_MAILSORTING, ACCESS_MECH_MINING, ACCESS_MINERAL_STOREROOM, ACCESS_MINING,
					ACCESS_MINING_STATION)
	config_job = "salvage_operator"
	template_access = list(ACCESS_CAPTAIN, ACCESS_HOP, ACCESS_CHANGE_IDS)
	job = /datum/job/salvage_operator

///Department Datum
/datum/job_department/salvage
	department_name = DEPARTMENT_SALVAGE
	department_bitflags = DEPARTMENT_BITFLAG_SALVAGE
	department_head = /datum/job/salvage_foreman
	department_experience_type = EXP_TYPE_SUPPLY
	display_order = 7
	label_class = "salvage"
	latejoin_color = "#ffff4a"
	nation_prefixes = list("Salvage")
