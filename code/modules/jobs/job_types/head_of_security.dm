/datum/job/head_of_security
	title = JOB_SECURITY_MARSHAL
	description = "Coordinate security personnel, ensure Management's needs are met."
	auto_deadmin_role_flags = DEADMIN_POSITION_HEAD|DEADMIN_POSITION_SECURITY
	department_head = list(JOB_CAPTAIN)
	head_announce = list(RADIO_CHANNEL_SECURITY)
	faction = FACTION_STATION
	total_positions = 1
	spawn_positions = 1
	selection_color = "#8e3d29"
	req_admin_notify = 1
	minimal_player_age = 14
	exp_requirements = 300
	exp_required_type = EXP_TYPE_CREW
	exp_required_type_department = EXP_TYPE_SECURITY
	exp_granted_type = EXP_TYPE_CREW

	employers = list(
		/datum/employer/mars_exec
	)

	outfits = list(
		"Default" = list(
			SPECIES_HUMAN = /datum/outfit/job/hos,
			SPECIES_PLASMAMAN = /datum/outfit/job/hos/plasmaman,
		),
	)

	departments_list = list(
		/datum/job_department/security,
		/datum/job_department/company_leader,
	)

	mind_traits = list(TRAIT_DONUT_LOVER)
	liver_traits = list(TRAIT_LAW_ENFORCEMENT_METABOLISM, TRAIT_ROYAL_METABOLISM)

	paycheck = PAYCHECK_COMMAND
	paycheck_department = ACCOUNT_SEC

	family_heirlooms = list(/obj/item/book/manual/wiki/security_space_law)
	rpg_title = "Guard Leader"
	job_flags = JOB_ANNOUNCE_ARRIVAL | JOB_CREW_MANIFEST | JOB_EQUIP_RANK | JOB_CREW_MEMBER | JOB_NEW_PLAYER_JOINABLE | JOB_REOPEN_ON_ROUNDSTART_LOSS | JOB_ASSIGN_QUIRKS | JOB_CAN_BE_INTERN

	voice_of_god_power = 1.4 //Command staff has authority


/datum/job/head_of_security/get_captaincy_announcement(mob/living/captain)
	return "Due to staffing shortages, newly promoted Acting Captain [captain.real_name] on deck!"

/datum/job/head_of_security/on_join_popup(client/C, job_title_pref)
	var/content = {"
		<div style='width:100%; text-align:center; font-size: 20px'>
		You are the <b>[title]</b>
		</div>
		<br>
		<div style='padding: 0px 30px; text-align: center; font-size: 14px;'>
		You are loudly and proudly a member of the Federation Galaxia, and you push your corps to carry out Management's will.
		Ensure the Superintendent is pleased, and your team follows your orders. Insubordination is not tolerated.
		</div>
	"}
	var/datum/browser/popup = new(C.mob, "jobinfo", "Role Information", 480, 360)
	popup.set_window_options("can_close=1;can_resize=0")
	popup.set_content(content)
	popup.open(FALSE)

/datum/outfit/job/hos
	name = JOB_SECURITY_MARSHAL
	jobtype = /datum/job/head_of_security

	id = /obj/item/card/id/advanced/silver
	id_trim = /datum/id_trim/job/head_of_security
	uniform = /obj/item/clothing/under/rank/security/marshal
	suit = /obj/item/clothing/suit/armor/vest/ballistic
	suit_store = /obj/item/gun/energy/e_gun
	backpack_contents = list(
		/obj/item/storage/evidencebag = 1,
		)
	belt = /obj/item/modular_computer/tablet/pda/heads/hos
	ears = /obj/item/radio/headset/heads/hos/alt
	glasses = /obj/item/clothing/glasses/hud/security/sunglasses
	gloves = /obj/item/clothing/gloves/color/black
	head = /obj/item/clothing/head/marshal_hat
	shoes = /obj/item/clothing/shoes/jackboots
	l_pocket = /obj/item/restraints/handcuffs
	r_pocket = /obj/item/assembly/flash/handheld

	backpack = /obj/item/storage/backpack/security
	satchel = /obj/item/storage/backpack/satchel/sec
	duffelbag = /obj/item/storage/backpack/duffelbag/sec

	box = /obj/item/storage/box/survival/security
	chameleon_extras = list(
		/obj/item/gun/energy/e_gun/hos,
		/obj/item/stamp/hos,
		)
	implants = list(/obj/item/implant/mindshield)

/datum/outfit/job/hos/plasmaman
	name = "Security Marshal (Plasmaman)"

	uniform = /obj/item/clothing/under/plasmaman/security/head_of_security
	gloves = /obj/item/clothing/gloves/color/plasmaman/black
	head = /obj/item/clothing/head/helmet/space/plasmaman/security/head_of_security
	mask = /obj/item/clothing/mask/breath
	r_hand = /obj/item/tank/internals/plasmaman/belt/full

/datum/outfit/job/hos/mod
	name = "Security Marshal (MODsuit)"

	suit_store = /obj/item/tank/internals/oxygen
	back = /obj/item/mod/control/pre_equipped/safeguard
	suit = null
	head = null
	mask = /obj/item/clothing/mask/gas/sechailer
	internals_slot = ITEM_SLOT_SUITSTORE
	backpack_contents = null
	box = null
