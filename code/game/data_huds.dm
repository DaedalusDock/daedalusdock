/*
 * Data HUDs have been rewritten in a more generic way.
 * In short, they now use an observer-listener pattern.
 * See code/datum/hud.dm for the generic hud datum.
 * Update the HUD icons when needed with the appropriate hook. (see below)
 */

/* DATA HUD DATUMS */

/atom/proc/add_to_all_human_data_huds()
	for(var/datum/atom_hud/data/human/hud in GLOB.huds)
		hud.add_atom_to_hud(src)

/atom/proc/remove_from_all_data_huds()
	for(var/datum/atom_hud/data/hud in GLOB.huds)
		hud.remove_atom_from_hud(src)

/datum/atom_hud/data

/datum/atom_hud/data/human/medical
	hud_icons = list(STATUS_HUD, HEALTH_HUD)

/datum/atom_hud/data/human/medical/basic

/datum/atom_hud/data/human/medical/basic/proc/check_sensors(mob/living/carbon/human/H)
	if(!istype(H))
		return FALSE
	var/obj/item/clothing/under/U = H.w_uniform
	if(!istype(U))
		return FALSE
	if(U.sensor_mode <= SENSOR_LIVING)
		return FALSE
	return TRUE

/datum/atom_hud/data/human/medical/basic/add_atom_to_single_mob_hud(mob/M, mob/living/carbon/H)
	if(check_sensors(H))
		..()

/datum/atom_hud/data/human/medical/basic/proc/update_suit_sensors(mob/living/carbon/H)
	check_sensors(H) ? add_atom_to_hud(H) : remove_atom_from_hud(H)

/datum/atom_hud/data/human/medical/advanced

/datum/atom_hud/data/human/security

/datum/atom_hud/data/human/security/basic
	hud_icons = list(ID_HUD)

/datum/atom_hud/data/human/security/advanced
	hud_icons = list(ID_HUD, IMPTRACK_HUD, IMPLOYAL_HUD, IMPCHEM_HUD, WANTED_HUD)

/datum/atom_hud/data/diagnostic

/datum/atom_hud/data/diagnostic/basic
	hud_icons = list(DIAG_HUD, DIAG_STAT_HUD, DIAG_BATT_HUD, DIAG_MECH_HUD, DIAG_BOT_HUD, DIAG_CIRCUIT_HUD, DIAG_TRACK_HUD, DIAG_AIRLOCK_HUD, DIAG_LAUNCHPAD_HUD)

/datum/atom_hud/data/diagnostic/advanced
	hud_icons = list(DIAG_HUD, DIAG_STAT_HUD, DIAG_BATT_HUD, DIAG_MECH_HUD, DIAG_BOT_HUD, DIAG_CIRCUIT_HUD, DIAG_TRACK_HUD, DIAG_AIRLOCK_HUD, DIAG_LAUNCHPAD_HUD, DIAG_PATH_HUD)

/datum/atom_hud/data/bot_path
	uses_global_hud_category = FALSE
	hud_icons = list(DIAG_PATH_HUD)

/datum/atom_hud/abductor
	hud_icons = list(GLAND_HUD)

/datum/atom_hud/sentient_disease
	hud_icons = list(SENTIENT_PATHOGEN_HUD)

/datum/atom_hud/ai_detector
	hud_icons = list(AI_DETECT_HUD)

/datum/atom_hud/ai_detector/show_to(mob/M)
	..()
	if(!M || hud_users.len != 1)
		return

	for(var/mob/camera/ai_eye/eye as anything in GLOB.aiEyes)
		eye.update_ai_detect_hud()

/* MED/SEC/DIAG HUD HOOKS */

/*
 * THESE HOOKS SHOULD BE CALLED BY THE MOB SHOWING THE HUD
 */

/***********************************************
Medical HUD! Basic mode needs suit sensors on.
************************************************/

//HELPERS

//called when a carbon changes virus
/mob/living/carbon/proc/check_virus()
	var/threat
	var/severity
	if(HAS_TRAIT(src, TRAIT_DISEASELIKE_SEVERITY_MEDIUM))
		severity = PATHOGEN_SEVERITY_MEDIUM
		threat = get_disease_severity_value(severity)

	for(var/thing in diseases)
		var/datum/pathogen/D = thing
		if(!(D.visibility_flags & HIDDEN_SCANNER))
			if(!threat || get_disease_severity_value(D.severity) > threat) //a buffing virus gets an icon
				threat = get_disease_severity_value(D.severity)
				severity = D.severity
	return severity

//helper for getting the appropriate health status
/proc/RoundHealth(mob/living/M)
	if(M.stat == DEAD || (HAS_TRAIT(M, TRAIT_FAKEDEATH)))
		return "health-100" //what's our health? it doesn't matter, we're dead, or faking
	var/maxi_health = M.maxHealth
	if(iscarbon(M) && M.health < 0)
		maxi_health = 100 //so crit shows up right for aliens and other high-health carbon mobs; noncarbons don't have crit.
	var/resulthealth = (M.health / maxi_health) * 100
	switch(resulthealth)
		if(100 to INFINITY)
			return "health100"
		if(90.625 to 100)
			return "health93.75"
		if(84.375 to 90.625)
			return "health87.5"
		if(78.125 to 84.375)
			return "health81.25"
		if(71.875 to 78.125)
			return "health75"
		if(65.625 to 71.875)
			return "health68.75"
		if(59.375 to 65.625)
			return "health62.5"
		if(53.125 to 59.375)
			return "health56.25"
		if(46.875 to 53.125)
			return "health50"
		if(40.625 to 46.875)
			return "health43.75"
		if(34.375 to 40.625)
			return "health37.5"
		if(28.125 to 34.375)
			return "health31.25"
		if(21.875 to 28.125)
			return "health25"
		if(15.625 to 21.875)
			return "health18.75"
		if(9.375 to 15.625)
			return "health12.5"
		if(1 to 9.375)
			return "health6.25"
		if(-50 to 1)
			return "health0"
		if(-85 to -50)
			return "health-50"
		if(-99 to -85)
			return "health-85"
		else
			return "health-100"

//HOOKS

//called when a human changes suit sensors
/mob/living/carbon/proc/update_suit_sensors()
	var/datum/atom_hud/data/human/medical/basic/B = GLOB.huds[DATA_HUD_MEDICAL_BASIC]
	B.update_suit_sensors(src)

/// Updates both the Health and Status huds. ATOM HUDS, NOT SCREEN HUDS.
/mob/living/proc/update_med_hud()
	med_hud_set_health()
	med_hud_set_status()

//called when a living mob changes health
/mob/living/proc/med_hud_set_health()
	set_hud_image_vars(HEALTH_HUD, "hud[RoundHealth(src)]")

/mob/living/carbon/med_hud_set_health()
	var/new_state = ""
	if(stat == DEAD || HAS_TRAIT(src, TRAIT_FAKEDEATH))
		new_state = "0"
	else if(undergoing_cardiac_arrest())
		new_state = "flatline"
	else
		new_state = "[pulse()]"

	set_hud_image_vars(HEALTH_HUD, new_state)

//called when a carbon changes stat, virus or XENO_HOST
/mob/living/proc/med_hud_set_status()
	var/new_state
	if(stat == DEAD || (HAS_TRAIT(src, TRAIT_FAKEDEATH)))
		new_state = "huddead"
	else
		new_state = "hudhealthy"

	set_hud_image_vars(STATUS_HUD, new_state)

/mob/living/carbon/med_hud_set_status()
	var/new_state
	var/virus_threat = check_virus()

	if(HAS_TRAIT(src, TRAIT_XENO_HOST))
		new_state = "hudxeno"
	else if(stat == DEAD || (HAS_TRAIT(src, TRAIT_FAKEDEATH)))
		new_state = "huddead"
	else
		switch(virus_threat)
			if(PATHOGEN_SEVERITY_BIOHAZARD)
				new_state = "hudill5"
			if(PATHOGEN_SEVERITY_DANGEROUS)
				new_state = "hudill4"
			if(PATHOGEN_SEVERITY_HARMFUL)
				new_state = "hudill3"
			if(PATHOGEN_SEVERITY_MEDIUM)
				new_state = "hudill2"
			if(PATHOGEN_SEVERITY_MINOR)
				new_state = "hudill1"
			if(PATHOGEN_SEVERITY_NONTHREAT)
				new_state = "hudill0"
			if(PATHOGEN_SEVERITY_POSITIVE)
				new_state = "hudbuff"
			if(null)
				new_state = "hudhealthy"

	set_hud_image_vars(STATUS_HUD, new_state)

/***********************************************
Security HUDs! Basic mode shows only the job.
************************************************/

//HOOKS

/mob/living/carbon/human/proc/sec_hud_set_ID()
	var/sechud_icon_state = wear_id?.get_sechud_job_icon_state()
	if(!sechud_icon_state)
		sechud_icon_state = "hudno_id"

	sec_hud_set_security_status()
	set_hud_image_vars(ID_HUD, sechud_icon_state)

/mob/living/proc/sec_hud_set_implants()
	for(var/i in list(IMPTRACK_HUD, IMPLOYAL_HUD, IMPCHEM_HUD))
		set_hud_image_vars(i, null)
		set_hud_image_inactive(i)

	var/hud_pixel_y = get_hud_pixel_y()
	for(var/obj/item/implant/I in implants)
		if(istype(I, /obj/item/implant/tracking))
			set_hud_image_vars(IMPTRACK_HUD, "hud_imp_tracking", hud_pixel_y)
			set_hud_image_active(IMPTRACK_HUD)

		else if(istype(I, /obj/item/implant/chem))
			set_hud_image_vars(IMPCHEM_HUD, "hud_imp_chem", hud_pixel_y)
			set_hud_image_active(IMPCHEM_HUD)

	if(HAS_TRAIT(src, TRAIT_MINDSHIELD))
		set_hud_image_vars(IMPLOYAL_HUD, "hud_imp_loyal", hud_pixel_y)
		set_hud_image_active(IMPLOYAL_HUD)

/mob/living/carbon/human/proc/sec_hud_set_security_status()
	var/perpname = get_face_name(get_id_name(""))
	if(perpname && SSdatacore)
		var/datum/data/record/security/R = SSdatacore.get_record_by_name(name, DATACORE_RECORDS_SECURITY)
		if(R)
			var/new_state
			var/has_criminal_entry = TRUE
			switch(R.fields[DATACORE_CRIMINAL_STATUS])
				if(CRIMINAL_WANTED)
					new_state = "hudwanted"
				if(CRIMINAL_INCARCERATED)
					new_state = "hudincarcerated"
				if(CRIMINAL_SUSPECT)
					new_state = "hudsuspected"
				if(CRIMINAL_PAROLE)
					new_state = "hudparolled"
				if(CRIMINAL_DISCHARGED)
					new_state = "huddischarged"
				else
					has_criminal_entry = FALSE

			if(has_criminal_entry)
				set_hud_image_vars(WANTED_HUD, new_state)
				set_hud_image_active(WANTED_HUD)
				return

	set_hud_image_vars(WANTED_HUD, null)
	set_hud_image_inactive(WANTED_HUD)

/***********************************************
Diagnostic HUDs!
************************************************/

//For Diag health and cell bars!
/proc/RoundDiagBar(value)
	switch(value * 100)
		if(95 to INFINITY)
			return "max"
		if(80 to 100)
			return "good"
		if(60 to 80)
			return "high"
		if(40 to 60)
			return "med"
		if(20 to 40)
			return "low"
		if(1 to 20)
			return "crit"
		else
			return "dead"

/// Returns the icon's height in pixels.
/atom/proc/get_icon_height()
	SHOULD_NOT_OVERRIDE(TRUE)
	var/static/icon_height_cache = list()
	if(isnull(icon))
		return 0

	. = icon_height_cache[icon]

	if(!isnull(.)) // 0 is valid
		return .

	var/icon/I
	I = icon(icon, icon_state, dir)
	. = I.Height()

	if(isfile(icon) && length("[icon]")) // Do NOT cache icon instances, only filepaths
		icon_height_cache[icon] = .

/// Returns the icon's width in pixels.
/atom/proc/get_icon_width()
	SHOULD_NOT_OVERRIDE(TRUE)
	var/static/icon_width_cache = list()
	if(isnull(icon))
		return 0

	. = icon_width_cache[icon]

	if(!isnull(.)) // 0 is valid
		return .

	var/icon/I
	I = icon(icon, icon_state, dir)
	. = I.Width()

	if(isfile(icon) && length("[icon]")) // Do NOT cache icon instances, only filepaths
		icon_width_cache[icon] = .

/// Gets the atom's visual width in pixels, accounting for transformations.
/atom/proc/get_visual_width()
	var/width = get_icon_width()
	var/height = get_icon_height()
	var/matrix/transform_cache = transform
	var/scale_list = list(
		width * transform_cache.a + height * transform_cache.b + transform_cache.c,
		width * transform_cache.a + transform_cache.c,
		height * transform_cache.b + transform_cache.c,
		transform_cache.c
	)
	return max(scale_list) - min(scale_list)


/// Gets the atom's visual height in pixels, accounting for transformations.
/atom/proc/get_visual_height()
	var/width = get_icon_width()
	var/height = get_icon_height()
	var/matrix/transform_cache = transform
	var/scale_list = list(
		width * transform_cache.d + height * transform_cache.e + transform_cache.f,
		width * transform_cache.d + transform_cache.f,
		height * transform_cache.e + transform_cache.f,
		transform_cache.f
	)
	return max(scale_list) - min(scale_list)

/// Gets the pixel_y value to be used on atom hud images.
/atom/proc/get_hud_pixel_y()
	return get_visual_height() - world.icon_size

/mob/living/carbon/human/get_hud_pixel_y()
	. = ..()
	if(body_position == LYING_DOWN)
		. -= PIXEL_Y_OFFSET_LYING

//Sillycone hooks
/mob/living/silicon/proc/diag_hud_set_health()
	var/new_state
	if(stat == DEAD)
		new_state = "huddiagdead"
	else
		new_state = "huddiag[RoundDiagBar(health/maxHealth)]"

	set_hud_image_vars(DIAG_HUD, new_state)

/mob/living/silicon/proc/diag_hud_set_status()
	var/new_state
	switch(stat)
		if(CONSCIOUS)
			new_state = "hudstat"
		if(UNCONSCIOUS)
			new_state = "hudoffline"
		else
			new_state = "huddead2"

	set_hud_image_vars(DIAG_STAT_HUD, new_state)

//Borgie battery tracking!
/mob/living/silicon/robot/proc/diag_hud_set_borgcell()
	var/new_state
	if(cell)
		var/chargelvl = (cell.charge/cell.maxcharge)
		new_state = "hudbatt[RoundDiagBar(chargelvl)]"
	else
		new_state = "hudnobatt"

	set_hud_image_vars(DIAG_BATT_HUD, new_state)

//borg-AI shell tracking
/mob/living/silicon/robot/proc/diag_hud_set_aishell() //Shows tracking beacons on the mech
	if(!shell) //Not an AI shell
		set_hud_image_vars(DIAG_TRACK_HUD, null)
		set_hud_image_inactive(DIAG_TRACK_HUD)
		return

	var/new_state
	if(deployed) //AI shell in use by an AI
		new_state = "hudtrackingai"
	else //Empty AI shell
		new_state = "hudtracking"

	set_hud_image_active(DIAG_TRACK_HUD)
	set_hud_image_vars(DIAG_TRACK_HUD, new_state)

//AI side tracking of AI shell control
/mob/living/silicon/ai/proc/diag_hud_set_deployed() //Shows tracking beacons on the mech
	if(!deployed_shell)
		set_hud_image_vars(DIAG_TRACK_HUD, null)
		set_hud_image_inactive(DIAG_TRACK_HUD)

	else //AI is currently controlling a shell
		set_hud_image_vars(DIAG_TRACK_HUD, "hudtrackingai")
		set_hud_image_active(DIAG_TRACK_HUD)

/*~~~~~~~~~~~~~~~~~~~~
	BIG STOMPY MECHS
~~~~~~~~~~~~~~~~~~~~~*/
/obj/vehicle/sealed/mecha/proc/diag_hud_set_mechhealth()
	set_hud_image_vars(DIAG_MECH_HUD, "huddiag[RoundDiagBar(atom_integrity/max_integrity)]")


/obj/vehicle/sealed/mecha/proc/diag_hud_set_mechcell()
	var/new_state
	if(cell)
		var/chargelvl = cell.charge/cell.maxcharge
		new_state = "hudbatt[RoundDiagBar(chargelvl)]"
	else
		new_state = "hudnobatt"

	set_hud_image_vars(DIAG_BATT_HUD, new_state)

/obj/vehicle/sealed/mecha/proc/diag_hud_set_mechstat()
	if(internal_damage)
		set_hud_image_vars(DIAG_STAT_HUD, "hudwarn")
		set_hud_image_active(DIAG_STAT_HUD)
		return

	set_hud_image_vars(DIAG_STAT_HUD, null)
	set_hud_image_inactive(DIAG_STAT_HUD)

///Shows tracking beacons on the mech
/obj/vehicle/sealed/mecha/proc/diag_hud_set_mechtracking()
	var/new_icon_state //This var exists so that the holder's icon state is set only once in the event of multiple mech beacons.
	for(var/obj/item/mecha_parts/mecha_tracking/T in trackers)
		if(T.ai_beacon) //Beacon with AI uplink
			new_icon_state = "hudtrackingai"
			break //Immediately terminate upon finding an AI beacon to ensure it is always shown over the normal one, as mechs can have several trackers.
		else
			new_icon_state = "hudtracking"

	set_hud_image_vars(DIAG_TRACK_HUD, new_icon_state)

/*~~~~~~~~~
	Bots!
~~~~~~~~~~*/
/mob/living/simple_animal/bot/proc/diag_hud_set_bothealth()
	set_hud_image_vars(DIAG_HUD, "huddiag[RoundDiagBar(health/maxHealth)]")

/mob/living/simple_animal/bot/proc/diag_hud_set_botstat() //On (With wireless on or off), Off, EMP'ed
	var/new_state
	if(bot_mode_flags & BOT_MODE_ON)
		new_state = "hudstat"
	else if(stat) //Generally EMP causes this
		new_state = "hudoffline"
	else //Bot is off
		new_state = "huddead2"

	set_hud_image_vars(DIAG_STAT_HUD, new_state)

/mob/living/simple_animal/bot/proc/diag_hud_set_botmode() //Shows a bot's current operation
	if(client) //If the bot is player controlled, it will not be following mode logic!
		set_hud_image_vars(DIAG_BOT_HUD, "hudsentient")
		return

	var/new_state
	switch(mode)
		if(BOT_SUMMON, BOT_RESPONDING) //Responding to PDA or AI summons
			new_state = "hudcalled"
		if(BOT_CLEANING, BOT_REPAIRING, BOT_HEALING) //Cleanbot cleaning, Floorbot fixing, or Medibot Healing
			new_state = "hudworking"
		if(BOT_PATROL, BOT_START_PATROL) //Patrol mode
			new_state = "hudpatrol"
		if(BOT_PREP_ARREST, BOT_ARREST, BOT_HUNT) //STOP RIGHT THERE, CRIMINAL SCUM!
			new_state = "hudalert"
		if(BOT_MOVING, BOT_PATHING, BOT_DELIVER, BOT_GO_HOME, BOT_NAV) //Moving to target for normal bots, moving to deliver or go home for MULES.
			new_state = "hudmove"
		else
			new_state = ""

	set_hud_image_vars(DIAG_BOT_HUD, new_state)

/mob/living/simple_animal/bot/mulebot/proc/diag_hud_set_mulebotcell()
	var/new_state
	if(cell)
		var/chargelvl = (cell.charge/cell.maxcharge)
		new_state = "hudbatt[RoundDiagBar(chargelvl)]"
	else
		new_state = "hudnobatt"

	set_hud_image_vars(DIAG_BATT_HUD, new_state)

/*~~~~~~~~~~~~
	Airlocks!
~~~~~~~~~~~~~*/
/obj/machinery/door/airlock/proc/diag_hud_set_electrified()
	if(secondsElectrified == MACHINE_NOT_ELECTRIFIED)
		set_hud_image_inactive(DIAG_AIRLOCK_HUD)
		return

	set_hud_image_vars(DIAG_AIRLOCK_HUD, "electrified")
	set_hud_image_active(DIAG_AIRLOCK_HUD)
