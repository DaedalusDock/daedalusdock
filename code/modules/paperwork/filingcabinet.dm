/* Filing cabinets!
 * Contains:
 * Filing Cabinets
 * Security Record Cabinets
 * Medical Record Cabinets
 * Employment Contract Cabinets
 */


/*
 * Filing Cabinets
 */
/obj/structure/filingcabinet
	name = "filing cabinet"
	desc = "A large cabinet with drawers."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "filingcabinet"
	density = TRUE
	anchored = TRUE

/obj/structure/filingcabinet/chestdrawer
	name = "chest drawer"
	icon_state = "chestdrawer"

/obj/structure/filingcabinet/chestdrawer/wheeled
	name = "rolling chest drawer"
	desc = "A small cabinet with drawers. This one has wheels!"
	anchored = FALSE

/obj/structure/filingcabinet/filingcabinet //not changing the path to avoid unnecessary map issues, but please don't name stuff like this in the future -Pete
	icon_state = "tallcabinet"

/obj/structure/filingcabinet/Initialize(mapload)
	. = ..()
	if(mapload)
		for(var/obj/item/I in loc)
			if(I.w_class < WEIGHT_CLASS_NORMAL) //there probably shouldn't be anything placed ontop of filing cabinets in a map that isn't meant to go in them
				I.forceMove(src)

/obj/structure/filingcabinet/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		new /obj/item/stack/sheet/iron(loc, 2)
		for(var/obj/item/I in src)
			I.forceMove(loc)
	qdel(src)

/obj/structure/filingcabinet/attackby(obj/item/P, mob/living/user, params)
	var/list/modifiers = params2list(params)
	if(P.tool_behaviour == TOOL_WRENCH && LAZYACCESS(modifiers, RIGHT_CLICK))
		to_chat(user, span_notice("You begin to [anchored ? "unwrench" : "wrench"] [src]."))
		if(P.use_tool(src, user, 20, volume=50))
			to_chat(user, span_notice("You successfully [anchored ? "unwrench" : "wrench"] [src]."))
			set_anchored(!anchored)
	else if(P.w_class < WEIGHT_CLASS_NORMAL)
		if(!user.transferItemToLoc(P, src))
			return
		to_chat(user, span_notice("You put [P] in [src]."))
		icon_state = "[initial(icon_state)]-open"
		sleep(5)
		icon_state = initial(icon_state)
	else if(!user.combat_mode)
		to_chat(user, span_warning("You can't put [P] in [src]!"))
	else
		return ..()

/obj/structure/filingcabinet/attack_hand(mob/living/carbon/user, list/modifiers)
	. = ..()
	ui_interact(user)

/obj/structure/filingcabinet/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "FilingCabinet")
		ui.open()

/obj/structure/filingcabinet/ui_data(mob/user)
	var/list/data = list()

	data["cabinet_name"] = "[name]"
	data["contents"] = list()
	data["contents_ref"] = list()
	for(var/obj/item/content in src)
		data["contents"] += "[content]"
		data["contents_ref"] += "[REF(content)]"

	return data

/obj/structure/filingcabinet/ui_act(action, params)
	. = ..()
	if(.)
		return

	switch(action)
		// Take the object out
		if("remove_object")
			var/obj/item/content = locate(params["ref"]) in src
			if(istype(content) && in_range(src, usr))
				usr.put_in_hands(content)
				icon_state = "[initial(icon_state)]-open"
				addtimer(VARSET_CALLBACK(src, icon_state, initial(icon_state)), 5)
				return TRUE

/obj/structure/filingcabinet/attack_tk(mob/user)
	if(anchored)
		return attack_self_tk(user)
	return ..()

/obj/structure/filingcabinet/attack_self_tk(mob/user)
	. = COMPONENT_CANCEL_ATTACK_CHAIN
	if(contents.len)
		if(prob(40 + contents.len * 5))
			var/obj/item/I = pick(contents)
			I.forceMove(loc)
			if(prob(25))
				step_rand(I)
			to_chat(user, span_notice("You pull \a [I] out of [src] at random."))
			return
	to_chat(user, span_notice("You find nothing in [src]."))

/*
 * Security Record Cabinets
 */
/obj/structure/filingcabinet/security
	name = "security records filing cabinet"
	desc = "A cabinet containing a paper copy of all of the station security records."

/obj/structure/filingcabinet/security/Initialize(mapload)
	. = ..()
	if(SSticker.IsRoundInProgress())
		INVOKE_ASYNC(src, PROC_REF(generate_all))
	RegisterSignal(SSdcs, COMSIG_GLOB_MANIFEST_INJECT, PROC_REF(on_manifest_add))

/obj/structure/filingcabinet/security/proc/add_entry(datum/data/record/general, datum/data/record/security)
	var/obj/item/paper/P = new /obj/item/paper(src)
	P.name = "paper - '[general.fields[DATACORE_NAME]]'"

	P.info = {"<TT>
		<CENTER><B>Security Record</B></CENTER><BR>
		Name: [general.fields[DATACORE_NAME]]<br>
		ID: [general.fields[DATACORE_ID]]<BR>
		Gender: [general.fields[DATACORE_GENDER]]<BR>
		Age: [general.fields[DATACORE_AGE]]<BR>
		Fingerprint: [general.fields[DATACORE_FINGERPRINT]]<BR>
		Physical Status: [general.fields[DATACORE_PHYSICAL_HEALTH]]<BR>
		Mental Status: [general.fields[DATACORE_MENTAL_HEALTH]]<BR>
		<BR>
		<CENTER><B>Security Data</B></CENTER><BR>
		Criminal Status: [security.fields[DATACORE_CRIMINAL_STATUS]]<BR>
		<BR>
		Crimes:<br>
	"}
	// Crimes
	if(length(security.fields[DATACORE_CRIMES]))
		for(var/datum/data/crime/C in security.fields[DATACORE_CRIMES])
			P.info += "[FOURSPACES][C.crimeName] - [C.crimeDetails]<br>"
	else
		P.info += "[FOURSPACES]None<br>"

	P.info += {"
		<BR>
		Important Notes:<BR>
		[FOURSPACES][security.fields[DATACORE_NOTES]]<BR>
		<BR>
		<CENTER><B>Comments/Log</B></CENTER><BR>
	"}
	// Notes
	var/counter = 1
	while(security.fields["com_[counter]"])
		P.info += "[security.fields["com_[counter]"]]<BR>"
		counter++
	P.info += "</TT>"

/obj/structure/filingcabinet/security/proc/on_manifest_add(datum/source, datum/data/record/general, datum/data/record/medical, datum/data/record/security)
	SIGNAL_HANDLER
	add_entry(general, security)

/obj/structure/filingcabinet/security/proc/generate_all()
	for(var/datum/data/record/G in SSdatacore.get_records(DATACORE_RECORDS_STATION))
		var/datum/data/record/S = SSdatacore.get_record_by_name(G.fields[DATACORE_NAME], DATACORE_RECORDS_SECURITY)
		if(!S)
			continue
		add_entry(G, S)
		CHECK_TICK
/*
 * Medical Record Cabinets
 */
/obj/structure/filingcabinet/medical
	///This var is so that its filled on crew interaction to be as accurate (including latejoins) as possible, true until first interact
	var/virgin = TRUE

/obj/structure/filingcabinet/medical/proc/populate()
	if(virgin)
		for(var/datum/data/record/G in SSdatacore.get_records(DATACORE_RECORDS_STATION))
			var/datum/data/record/M = SSdatacore.get_record_by_name(G.fields[DATACORE_NAME], DATACORE_RECORDS_MEDICAL)
			if(!M)
				continue
			var/obj/item/paper/P = new /obj/item/paper(src)
			P.info = "<CENTER><B>Medical Record</B></CENTER><BR>"
			P.info += "Name: [G.fields[DATACORE_NAME]] ID: [G.fields[DATACORE_ID]]<BR>\nGender: [G.fields[DATACORE_GENDER]]<BR>\nAge: [G.fields[DATACORE_AGE]]<BR>\nFingerprint: [G.fields[DATACORE_FINGERPRINT]]<BR>\nPhysical Status: [G.fields[DATACORE_PHYSICAL_HEALTH]]<BR>\nMental Status: [G.fields[DATACORE_MENTAL_HEALTH]]<BR>"
			P.info += "<BR>\n<CENTER><B>Medical Data</B></CENTER><BR>\nBlood Type: [M.fields[DATACORE_BLOOD_TYPE]]<BR>\nDNA: [M.fields[DATACORE_BLOOD_DNA]]<BR>\n<BR>\n\nDisabilities: [M.fields[DATACORE_DISABILITIES]]<BR>\nDetails: [M.fields[DATACORE_DISABILITIES_DETAILS]]<BR>\n<BR>\nAllergies: [M.fields["alg"]]<BR>\nDetails: [M.fields["alg_d"]]<BR>\n<BR>\nCurrent Diseases: [M.fields[DATACORE_DISEASES]] (per disease info placed in log/comment section)<BR>\nDetails: [M.fields[DATACORE_DISEASES_DETAILS]]<BR>\n<BR>\nImportant Notes:<BR>\n\t[M.fields[DATACORE_NOTES]]<BR>\n<BR>\n<CENTER><B>Comments/Log</B></CENTER><BR>"
			var/counter = 1
			while(M.fields["com_[counter]"])
				P.info += "[M.fields["com_[counter]"]]<BR>"
				counter++
			P.info += "</TT>"
			P.name = "paper - '[G.fields[DATACORE_NAME]]'"
			virgin = FALSE //tabbing here is correct- it's possible for people to try and use it
						//before the records have been generated, so we do this inside the loop.

//ATTACK HAND IGNORING PARENT RETURN VALUE
/obj/structure/filingcabinet/medical/attack_hand(mob/user, list/modifiers)
	populate()
	return ..()

/obj/structure/filingcabinet/medical/attack_tk()
	populate()
	return ..()

/*
 * Employment contract Cabinets
 */

GLOBAL_LIST_EMPTY(employmentCabinets)

/obj/structure/filingcabinet/employment
	icon_state = "employmentcabinet"
	///This var is so that its filled on crew interaction to be as accurate (including latejoins) as possible, true until first interact
	var/virgin = TRUE

/obj/structure/filingcabinet/employment/Initialize(mapload)
	. = ..()
	GLOB.employmentCabinets += src

/obj/structure/filingcabinet/employment/Destroy()
	GLOB.employmentCabinets -= src
	return ..()

/obj/structure/filingcabinet/employment/proc/fillCurrent()
	//This proc fills the cabinet with the current crew.
	for(var/datum/data/record/G in SSdatacore.get_records(DATACORE_RECORDS_LOCKED))
		var/datum/mind/M = G.fields[DATACORE_MINDREF]
		if(M && ishuman(M.current))
			addFile(M.current)


/obj/structure/filingcabinet/employment/proc/addFile(mob/living/carbon/human/employee)
	new /obj/item/paper/employment_contract(src, employee.mind.name)

/obj/structure/filingcabinet/employment/interact(mob/user)
	if(virgin)
		fillCurrent()
		virgin = FALSE
	return ..()

