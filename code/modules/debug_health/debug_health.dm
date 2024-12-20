/*
	Datum container for the health debug menu
*/
/datum/health_debug_menu
	var/client/user
	var/mob/living/carbon/human/target

/datum/health_debug_menu/New(client/user, mob/living/carbon/human/target)
	. = ..()
	if(!istype(user) || !istype(target))
		return
	src.user = user
	src.target = target

	RegisterSignal(user, COMSIG_PARENT_QDELETING, PROC_REF(qdelme))
	RegisterSignal(target, COMSIG_PARENT_QDELETING, PROC_REF(qdelme))

	src.target.notransform = TRUE

/datum/health_debug_menu/Destroy(force, ...)
	if(!QDELETED(target))
		target.notransform = FALSE
	target = null
	user = null
	return ..()

/datum/health_debug_menu/ui_state(mob/user)
	return GLOB.admin_state

/datum/health_debug_menu/ui_close(mob/user)
	qdel(src)

/datum/health_debug_menu/proc/qdelme(datum/source)
	SIGNAL_HANDLER
	qdel(src)

/datum/health_debug_menu/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "DebugHealth")
		ui.open()

/client/proc/debug_health(mob/living/carbon/human/H in view())
	set name = "Debug Health"
	set category = "Debug"

	if(!istype(H))
		return

	var/datum/health_debug_menu/tgui = new(usr.client, H)//create the datum
	tgui.ui_interact(usr)//datum has a tgui component, here we open the window

/datum/health_debug_menu/ui_data()
	var/list/ui_data = list()

	ui_data["body"] = list(
		"stat" = "",
		"brain" = target.getBrainLoss(),
		"brute" = target.getBruteLoss(),
		"burn" = target.getFireLoss(),
		"organ" = target.getToxLoss(),
		"oxygen" = target.getOxyLoss(),
		"pain" = target.getPain(),
		"shock" = target.shock_stage,
		"losebreath" = target.losebreath,
		"asystole" = BOOLEAN(target.undergoing_cardiac_arrest()),
		"blood volume" = target.blood_volume,
		"blood circulation" = target.get_blood_circulation(),
		"blood oxygenation" = target.get_blood_oxygenation(),
		"temperature" = round(target.bodytemperature, 0.1),
		"misc" = list(),
	)

	switch(target.stat)
		if(CONSCIOUS)
			ui_data["body"]["stat"] = "Conscious"
		if(UNCONSCIOUS)
			if(target.IsSleeping())
				ui_data["body"]["stat"] = "Unconscious (Asleep)"
			else
				ui_data["body"]["stat"] = "Unconscious"
		if(DEAD)
			ui_data["body"]["stat"] = "Dead"

	var/list/bp_names = list(
		BODY_ZONE_HEAD = "Head",
		BODY_ZONE_CHEST = "Chest",
		BODY_ZONE_R_ARM = "Right Arm",
		BODY_ZONE_L_ARM = "Left Arm",
		BODY_ZONE_R_LEG = "Right Leg",
		BODY_ZONE_L_LEG = "Left Leg"
	)

	var/list/open_levels = list("Open", "Retracted", "To Bone")

	var/list/bodyparts = list()

	for(var/zone in list(BODY_ZONE_HEAD, BODY_ZONE_CHEST, BODY_ZONE_R_ARM, BODY_ZONE_L_ARM, BODY_ZONE_R_LEG, BODY_ZONE_L_LEG))
		var/obj/item/bodypart/BP = target.get_bodypart(zone, TRUE)
		if(!BP)
			bodyparts[bp_names[zone]] = list(
				"wounds" = list(),
				"damage" = "N/A",
				"max damage" = "N/A",
				"pain" = null,
				"bleed rate" = 0,
				"germ level" = 0,
				"how open" = null,
				"status" = list("MISSING"),
				"cavity objects" = list(),
			)
			continue

		var/list/flags = list()
		for (var/i in GLOB.bitfields[NAMEOF(BP, bodypart_flags)])
			if (BP.bodypart_flags & GLOB.bitfields[NAMEOF(BP, bodypart_flags)][i])
				flags += i

		var/how_open = BP.how_open()
		if(how_open)
			how_open = open_levels[how_open]
		else
			how_open = "Closed"

		var/list/cavity_objects = list()
		for(var/obj/item/I in BP.cavity_items)
			cavity_objects += I.name

		bodyparts[bp_names[zone]] = list(
			"wounds" = BP.debug_wounds(),
			"damage" = BP.get_damage(),
			"max damage" = BP.max_damage,
			"pain" = BP.getPain(),
			"bleed rate" = "[BP.cached_bleed_rate]u (modified: [BP.get_modified_bleed_rate()]u)",
			"germ level" = BP.germ_level,
			"how open" = how_open,
			"status" = flags,
			"cavity objects" = cavity_objects,
		)

	ui_data["bodyparts"] = bodyparts


	var/list/organs = list()
	ui_data["organs"] = organs
	for(var/obj/item/organ/O as anything in target.organs)
		if(O.cosmetic_only)
			continue

		var/list/flags = list()
		for (var/i in GLOB.bitfields[NAMEOF(O, organ_flags)])
			if (O.organ_flags & GLOB.bitfields[NAMEOF(O, organ_flags)][i])
				flags += i

		organs[O.name] = list(
			"type" = O.type,
			"damage" = O.damage,
			"max damage" = O.maxHealth,
			"initial max damage" = initial(O.maxHealth),
			"status" = flags,
			"additional" = O.get_debug_info(),
		)

	var/list/reagents = list(
		"ingest" = list(),
		"blood" = list(),
		"touch" = list(),
	)

	ui_data["reagents"] = reagents

	var/obj/item/organ/stomach/stomach = target.getorganslot(ORGAN_SLOT_STOMACH)

	if(stomach?.reagents)
		for(var/datum/reagent/R in stomach.reagents.reagent_list)
			var/list/reagent = list()
			reagent["name"] = R.name
			reagent["quantity"] = round(R.volume, 1)
			reagent["visible"] = BOOLEAN(!(R.chemical_flags & (REAGENT_INVISIBLE)))
			reagent["overdosed"] = BOOLEAN(R.overdosed)
			reagents["ingest"] += list(reagent)

	for(var/datum/reagent/R in target.bloodstream.reagent_list)
		var/list/reagent = list()
		reagent["name"] = R.name
		reagent["quantity"] = round(R.volume, 1)
		reagent["visible"] = BOOLEAN(!(R.chemical_flags & (REAGENT_INVISIBLE)))
		reagent["overdosed"] = BOOLEAN(R.overdosed)
		reagents["blood"] += list(reagent)

	for(var/datum/reagent/R in target.touching.reagent_list)
		var/list/reagent = list()
		reagent["name"] = R.name
		reagent["quantity"] = round(R.volume, 1)
		reagent["visible"] = BOOLEAN(!(R.chemical_flags & (REAGENT_INVISIBLE)))
		reagent["overdosed"] = BOOLEAN(R.overdosed)
		reagents["touch"] += list(reagent)

	return ui_data

/obj/item/bodypart/proc/debug_wounds()
	var/list/wound_data = list()

	for(var/datum/wound/wound as anything in wounds)
		wound_data += list(list(
			"NAME" = capitalize(wound.wound_type),
			"STAGE" = wound.current_stage,
			"MAX_STAGE" = length(wound.stages),
			"AMOUNT" = wound.amount,
			"DAMAGE" = wound.damage,
			"HEALING" = BOOLEAN(wound.can_autoheal()),
			"BLEEDING" = wound.bleeding() ? "[WOUND_BLEED_RATE(wound)]u" : "NONE",
			"CLAMPED" = BOOLEAN(wound.clamped),
			"TREATED" = BOOLEAN(wound.is_treated()),
			"SURGICAL" = BOOLEAN(wound.is_surgical()),
		))

	return wound_data
