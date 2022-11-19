///Salvage Operators

/datum/job/salvage_operator
	title = JOB_SALVAGE_OPERATOR
	description = "Explore derelicted space hulks, salvage the goods within, avoid the horrors within, and get out alive."
	department_head = list(JOB_QUARTERMASTER)
	faction = FACTION_STATION
	total_positions = 4
	spawn_positions = 4
	supervisors = "the corporation first, and to a degree the quartermaster"
	selection_color = "#395b36"
	exp_granted_type = EXP_TYPE_CREW

	outfit = /datum/outfit/job/salvage_operator
	plasmaman_outfit = /datum/outfit/plasmaman/mining //reminder: make a proper plasmaman sal-op outfit later.

	paycheck = PAYCHECK_MEDIUM //reminder: refactor later, salvage operators aren't part of NT and shouldn't get much of a paycheck.
	paycheck_department = ACCOUNT_CAR //ditto?

	display_order = JOB_DISPLAY_ORDER_SALVAGE_OPERATOR
	bounty_types = CIV_JOB_MINE
	departments_list = list(/datum/job_department/cargo,)

	family_heirlooms = list(/obj/item/pickaxe/mini, /obj/item/shovel) //refactor later: special tier 1.5 salvage beam, add a hardspace reference here.
	rpg_title = "Adventurer" //maybe change this?
	job_flags = JOB_ANNOUNCE_ARRIVAL | JOB_CREW_MANIFEST | JOB_EQUIP_RANK | JOB_CREW_MEMBER | JOB_NEW_PLAYER_JOINABLE | JOB_REOPEN_ON_ROUNDSTART_LOSS | JOB_ASSIGN_QUIRKS | JOB_CAN_BE_INTERN


/datum/outfit/job/salvage_operator
	name = "Salvage Operator"
	jobtype = /datum/job/salvage_operator

	id_trim = /datum/id_trim/job/shaft_miner //refactor: adjust this to its own unique trim closer to release, trim code is [nightmare]
	uniform = /obj/item/clothing/under/rank/cargo/salvage
	backpack_contents = list(/obj/item/storage/belt/salvage/tier1/full) //sal_ops should always have a T1 kit, always.
	belt = /obj/item/modular_computer/tablet/pda/shaftminer
	ears = /obj/item/radio/headset/headset_cargo/mining
	gloves = /obj/item/clothing/gloves/color/black
	shoes = /obj/item/clothing/shoes/jackboots
	l_pocket = /obj/item/storage/bag/salvage

	backpack = /obj/item/storage/backpack/salvage
	satchel = /obj/item/storage/backpack/satchel/salvage
	duffelbag = /obj/item/storage/backpack/duffelbag/salvage

/obj/item/storage/backpack/salvage //to-do: custom bag sprites
	name = "operator bag"
	desc = "A robust backpack for stashing your loot."
	icon_state = "explorerpack"
	inhand_icon_state = "explorerpack"

/obj/item/storage/backpack/satchel/salvage
	name = "operator satchel"
	desc = "A robust satchel for stashing your loot."
	icon_state = "satchel-explorer"
	inhand_icon_state = "satchel-explorer"

/obj/item/storage/backpack/duffelbag/salvage
	name = "operator's duffel bag"
	desc = "A large duffel bag for holding extra exotic treasures."
	icon_state = "duffel-explorer"
	inhand_icon_state = "duffel-explorer"
	supports_variations_flags = NONE

/obj/item/storage/bag/salvage //ditto
	name = "scrap satchel"
	desc = "A bag for storing salvage."
	icon = 'icons/obj/mining.dmi'
	icon_state = "satchel"
	worn_icon_state = "satchel"
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_POCKETS
	w_class = WEIGHT_CLASS_NORMAL
	component_type = /datum/component/storage/concrete
	var/spam_protection = FALSE //If this is TRUE, the holder won't receive any messages when they fail to pick up ore through crossing it
	var/mob/listeningTo

/obj/item/storage/bag/salvage/ComponentInitialize()
	. = ..()
	var/datum/component/storage/concrete/STR = GetComponent(/datum/component/storage/concrete)
	STR.max_items = 100
	STR.allow_quick_empty = TRUE
	STR.set_holdable(list(/obj/item/salvage))
	STR.max_w_class = WEIGHT_CLASS_HUGE
	STR.max_combined_w_class = 100

/obj/item/storage/bag/salvage/equipped(mob/user)
	. = ..()
	if(listeningTo == user)
		return
	if(listeningTo)
		UnregisterSignal(listeningTo, COMSIG_MOVABLE_MOVED)
	RegisterSignal(user, COMSIG_MOVABLE_MOVED, .proc/pickup_salvage)
	listeningTo = user

/obj/item/storage/bag/salvage/dropped()
	. = ..()
	if(listeningTo)
		UnregisterSignal(listeningTo, COMSIG_MOVABLE_MOVED)
		listeningTo = null

/obj/item/storage/bag/salvage/proc/pickup_salvage(mob/living/user)
	SIGNAL_HANDLER
	var/show_message = FALSE
	var/turf/tile = user.loc
	if (!isturf(tile))
		return
	var/datum/component/storage/concrete/STR = GetComponent(/datum/component/storage/concrete)
	if(STR)
		for(var/A in tile)
			if (!is_type_in_typecache(A, STR.can_hold))
				continue
			if(SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, A, user, TRUE))
				show_message = TRUE
			else
				if(!spam_protection)
					to_chat(user, span_warning("Your [name] is full and can't hold any more!"))
					spam_protection = TRUE
					continue
	if(show_message)
		playsound(user, SFX_RUSTLE, 50, TRUE)
		user.visible_message(span_notice("[user] scoops up the salvage beneath [user.p_them()]."), \
		span_notice("You scoop up the salvage beneath you with your [name]."))
	spam_protection = FALSE

/obj/item/storage/bag/salvage/holding //to-do: add appropriate technode, currently unobtain
	name = "scrap satchel of holding"
	desc = "A specialized satchel designed for holding seemingly infinite quantities of scrap."
	icon_state = "satchel_bspace"

/obj/item/storage/bag/salvage/holding/ComponentInitialize()
	. = ..()
	var/datum/component/storage/concrete/STR = GetComponent(/datum/component/storage/concrete)
	STR.max_items = INFINITY
	STR.max_combined_w_class = INFINITY
