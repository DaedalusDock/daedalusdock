/**
 * Non-processing subsystem that holds various procs and data structures to manage ID cards, templates and access.
 */
SUBSYSTEM_DEF(id_access)
	name = "IDs and Access"
	init_order = INIT_ORDER_IDACCESS
	flags = SS_NO_FIRE

	/// Dictionary of access groups. Keys are typepaths. Values are instances.
	var/list/access_groups = list()
	/// Dictionary of template singletons. Keys are paths. Values are their associated singletons.
	var/list/template_singletons_by_path = list()
	/// Specially formatted list for sending access levels to tgui interfaces.
	var/list/tgui_access_groups = list()
	/// Dictionary of access names. Keys are access levels. Values are their associated names.
	var/list/desc_by_access = list()
	/// List of accesses for the Heads of each sub-department alongside the regions they control and their job name.
	var/list/sub_department_managers_tgui = list()
	/// Helper list containing all template paths that can be used as job templates. Intended to be used alongside logic for ACCESS_CHANGE_IDS. Grab templates from sub_department_managers_tgui for Head of Staff restrictions.
	var/list/station_job_templates = list()
	/// Helper list containing all template paths that can be used as Centcom templates.
	var/list/centcom_job_templates = list()
	/// Helper list containing all PDA paths that can be painted by station machines. Intended to be used alongside logic for ACCESS_CHANGE_IDS. Grab templates from sub_department_managers_tgui for Head of Staff restrictions.
	var/list/station_pda_templates = list()
	/// Helper list containing all station groups.
	var/list/station_groups = list()

	/// Database of referenceable pincodes (Usually door codes.)
	var/list/static_pincodes = list()

/datum/controller/subsystem/id_access/Initialize(timeofday)
	setup_access_groups()
	// We use this because creating the template singletons requires the config to be loaded.
	setup_template_singletons()
	setup_access_descriptions()
	setup_tgui_lists()

	return ..()

/**
 * Called by [/datum/controller/subsystem/ticker/proc/setup]
 *
 * This runs through every /datum/access_template/job singleton and ensures that its access is setup according to
 * appropriate config entries.
 */
/datum/controller/subsystem/id_access/proc/refresh_job_template_singletons()
	for(var/template in typesof(/datum/access_template/job))
		var/datum/access_template/job/job_template = template_singletons_by_path[template]

		if(QDELETED(job_template))
			stack_trace("template \[[template]\] missing from template singleton list. Reinitialising this template.")
			template_singletons_by_path[template] = new template()
			continue

		job_template.refresh_template_access()

/// Initialize access groups.
/datum/controller/subsystem/id_access/proc/setup_access_groups()
	for(var/datum/access_group/path as anything in subtypesof(/datum/access_group))
		if(isabstract(path))
			continue

		access_groups[path] = new path

	station_groups = list(
		/datum/access_group/station/security,
		/datum/access_group/station/management,
		/datum/access_group/station/engineering,
		/datum/access_group/station/independent_areas,
		/datum/access_group/station/cargo,
		/datum/access_group/station/medical,
	)

/// Instantiate template singletons and add them to a list.
/datum/controller/subsystem/id_access/proc/setup_template_singletons()
	for(var/template in typesof(/datum/access_template))
		template_singletons_by_path[template] = new template()

/// Creates various data structures that primarily get fed to tgui interfaces, although these lists are used in other places.
/datum/controller/subsystem/id_access/proc/setup_tgui_lists()
	for(var/path in access_groups)
		var/datum/access_group/access_group = access_groups[path]

		var/list/group_access = access_group.access

		var/parsed_accesses = list()

		for(var/access in group_access)
			var/access_desc = get_access_desc(access)
			if(!access_desc)
				continue

			parsed_accesses += list(list(
				"desc" = replacetext(access_desc, "&nbsp", " "),
				"ref" = access,
			))

		tgui_access_groups[path] = list(list(
			"name" = access_group.name,
			"accesses" = parsed_accesses,
			"path" = path,
		))

	sub_department_managers_tgui = list(
		"[ACCESS_CAPTAIN]" = new /datum/access_group_manager/captain,
		"[ACCESS_DELEGATE]" = new /datum/access_group_manager/hop,
		"[ACCESS_HOS]" = new /datum/access_group_manager/security,
		"[ACCESS_CMO]" = new /datum/access_group_manager/medical,
		"[ACCESS_CE]" = new /datum/access_group_manager/engineering,
		"[ACCESS_QM]" = new /datum/access_group_manager/cargo,
	)

	var/list/station_job_templates = subtypesof(/datum/access_template/job)
	for(var/template_path in station_job_templates)
		var/datum/access_template/job/template = template_singletons_by_path[template_path]
		if(!length(template.template_access))
			continue

		station_job_templates[template_path] = template.assignment
		for(var/access in template.template_access)
			var/datum/access_group_manager/manager = sub_department_managers_tgui["[access]"]
			if(!manager)
				if(access != ACCESS_CHANGE_IDS)
					WARNING("Invalid template access access \[[access]\] registered with [template_path]. Template added to global list anyway.")
				continue

			var/list/templates = manager.templates
			templates[template_path] = template.assignment

	sortTim(station_job_templates, GLOBAL_PROC_REF(cmp_text_asc), associative = TRUE)

	var/list/centcom_job_templates = typesof(/datum/access_template/centcom) - typesof(/datum/access_template/centcom/corpse)
	for(var/template_path in centcom_job_templates)
		var/datum/access_template/template = template_singletons_by_path[template_path]
		centcom_job_templates[template_path] = template.assignment

	sortTim(centcom_job_templates, GLOBAL_PROC_REF(cmp_text_asc), associative = TRUE)

	var/list/all_pda_paths = typesof(/obj/item/modular_computer/tablet/pda)
	var/list/pda_regions = PDA_PAINTING_REGIONS
	for(var/pda_path in all_pda_paths)
		if(!(pda_path in pda_regions))
			continue

		var/list/region_whitelist = pda_regions[pda_path]
		for(var/access_txt in sub_department_managers_tgui)
			var/datum/access_group_manager/manager = sub_department_managers_tgui[access_txt]
			var/list/manager_regions = manager.access_groups
			for(var/whitelisted_region in region_whitelist)
				if(!(whitelisted_region in manager_regions))
					continue

				var/list/manager_pdas = manager.pdas
				var/obj/item/modular_computer/tablet/pda/fake_pda = pda_path
				manager_pdas[pda_path] = initial(fake_pda.name)
				station_pda_templates[pda_path] = initial(fake_pda.name)

/// Setup dictionary that converts access levels to text descriptions.
/datum/controller/subsystem/id_access/proc/setup_access_descriptions()
	desc_by_access["[ACCESS_CARGO]"] = "Cargo Bay"
	desc_by_access["[ACCESS_SECURITY]"] = "Security"
	desc_by_access["[ACCESS_COURT]"] = "Courtroom"
	desc_by_access["[ACCESS_FORENSICS]"] = "P.I's Office"
	desc_by_access["[ACCESS_MEDICAL]"] = "Medical"
	desc_by_access["[ACCESS_PHARMACY]"] = "Secure Pharmacy"
	desc_by_access["[ACCESS_ROBOTICS]"] = "Robotics"
	desc_by_access["[ACCESS_RND]"] = "R&D Lab"
	desc_by_access["[ACCESS_ORDNANCE]"] = "Ordnance Lab"
	desc_by_access["[ACCESS_ORDNANCE_STORAGE]"] = "Ordnance Storage"
	desc_by_access["[ACCESS_RD]"] = "RD Office"
	desc_by_access["[ACCESS_BAR]"] = "Bar"
	desc_by_access["[ACCESS_JANITOR]"] = "Custodial Closet"
	desc_by_access["[ACCESS_ENGINEERING]"] = "Engineering"
	desc_by_access["[ACCESS_ENGINE_EQUIP]"] = "Power and Engineering Equipment"
	desc_by_access["[ACCESS_MAINT_TUNNELS]"] = "Maintenance"
	desc_by_access["[ACCESS_EXTERNAL_AIRLOCKS]"] = "External Airlocks"
	desc_by_access["[ACCESS_CHANGE_IDS]"] = "ID Console"
	desc_by_access["[ACCESS_AI_UPLOAD]"] = "AI Chambers"
	desc_by_access["[ACCESS_TELEPORTER]"] = "Teleporter"
	desc_by_access["[ACCESS_EVA]"] = "EVA"
	desc_by_access["[ACCESS_FACTION_LEADER]"] = "Faction Leader"
	desc_by_access["[ACCESS_MANAGEMENT]"] = "Management"
	desc_by_access["[ACCESS_CAPTAIN]"] = "Captain"
	desc_by_access["[ACCESS_ALL_PERSONAL_LOCKERS]"] = "Personal Lockers"
	desc_by_access["[ACCESS_CHAPEL_OFFICE]"] = "Chapel Office"
	desc_by_access["[ACCESS_SECURE_ENGINEERING]"] = "Secure Engineering"
	desc_by_access["[ACCESS_ATMOSPHERICS]"] = "Atmospherics"
	desc_by_access["[ACCESS_ARMORY]"] = "Armory"
	desc_by_access["[ACCESS_KITCHEN]"] = "Kitchen"
	desc_by_access["[ACCESS_HYDROPONICS]"] = "Hydroponics"
	desc_by_access["[ACCESS_LIBRARY]"] = "Library"
	desc_by_access["[ACCESS_LAWYER]"] = "Law Office"
	desc_by_access["[ACCESS_CMO]"] = "Augur Office"
	desc_by_access["[ACCESS_QM]"] = "Quartermaster's Office"
	desc_by_access["[ACCESS_THEATRE]"] = "Theatre"
	desc_by_access["[ACCESS_RESEARCH]"] = "Science"
	desc_by_access["[ACCESS_VAULT]"] = "Main Vault"
	desc_by_access["[ACCESS_DELEGATE]"] = "Delegate Office"
	desc_by_access["[ACCESS_HOS]"] = "S.Marshal Office"
	desc_by_access["[ACCESS_CE]"] = "C.Engineer Office"
	desc_by_access["[ACCESS_RC_ANNOUNCE]"] = "RC Announcements"
	desc_by_access["[ACCESS_KEYCARD_AUTH]"] = "Keycode Auth."
	desc_by_access["[ACCESS_MINERAL_STOREROOM]"] = "Mineral Storage"
	desc_by_access["[ACCESS_WEAPONS]"] = "Weapon Permit"
	desc_by_access["[ACCESS_NETWORK]"] = "Network Access"
	desc_by_access["[ACCESS_MECH_MINING]"] = "Mining Mech Access"
	desc_by_access["[ACCESS_MECH_MEDICAL]"] = "Medical Mech Access"
	desc_by_access["[ACCESS_MECH_SECURITY]"] = "Security Mech Access"
	desc_by_access["[ACCESS_MECH_SCIENCE]"] = "Science Mech Access"
	desc_by_access["[ACCESS_MECH_ENGINE]"] = "Engineering Mech Access"
	desc_by_access["[ACCESS_AUX_BASE]"] = "Auxiliary Base"
	desc_by_access["[ACCESS_SERVICE]"] = "Service Hallway"
	desc_by_access["[ACCESS_CENT_GENERAL]"] = "Code Grey"
	desc_by_access["[ACCESS_CENT_THUNDER]"] = "Code Yellow"
	desc_by_access["[ACCESS_CENT_STORAGE]"] = "Code Orange"
	desc_by_access["[ACCESS_CENT_LIVING]"] = "Code Green"
	desc_by_access["[ACCESS_CENT_MEDICAL]"] = "Code White"
	desc_by_access["[ACCESS_CENT_TELEPORTER]"] = "Code Blue"
	desc_by_access["[ACCESS_CENT_SPECOPS]"] = "Code Black"
	desc_by_access["[ACCESS_CENT_CAPTAIN]"] = "Code Gold"
	desc_by_access["[ACCESS_CENT_BAR]"] = "Code Scotch"

/**
 * Returns the access description associated with any given access level.
 *
 * In proc form due to accesses being stored in the list as text instead of numbers.
 * Arguments:
 * * access - Access as either pure number or as a string representation of the number.
 */
/datum/controller/subsystem/id_access/proc/get_access_desc(access)
	return desc_by_access["[access]"]

/**
 * Returns the list of all accesses associated with any given access group.
 *
 * Arguments:
 * * group_paths - The group type to retrieve access for. Or a list of them
 */
/datum/controller/subsystem/id_access/proc/get_access_for_group(group_paths)
	if(!islist(group_paths))
		var/datum/access_group/retrieved_group = access_groups[group_paths]
		return retrieved_group?.access.Copy() || list()

	. = list()

	for(var/iter_path in group_paths)
		var/datum/access_group/retrieved_group = access_groups[iter_path]
		. |= retrieved_group.access


/**
 * Applies a template singleton to a card.
 *
 * Arguments:
 * * id_card - ID card to apply the template_path to.
 * * template_path - A template path to apply to the card. Grabs the template's associated singleton and applies it.
 * * copy_access - Boolean value. If true, the template's access is also copied to the card.
 */
/datum/controller/subsystem/id_access/proc/apply_template_to_card(obj/item/card/id/id_card, template_path, copy_access = TRUE)
	var/datum/access_template/template = template_singletons_by_path[template_path]

	id_card.template = template

	if(copy_access)
		apply_template_access_to_card(id_card, template_path)

	if(template.assignment)
		id_card.assignment = template.assignment

	id_card.update_label()
	id_card.update_icon()

	return TRUE

/**
 * Removes a template from an ID card. Also removes all accesses from it too.
 *
 * Arguments:
 * * id_card - The ID card to remove the template from.
 */
/datum/controller/subsystem/id_access/proc/remove_template_from_card(obj/item/card/id/id_card)
	id_card.template = null
	id_card.clear_access()
	id_card.update_label()
	id_card.update_icon()

/**
 * Applies a template to a chameleon card. This is purely visual, utilising the card's override vars.
 *
 * Arguments:
 * * id_card - The chameleon card to apply the template visuals to.
* * template_path - A template path to apply to the card. Grabs the template's associated singleton and applies it.
 * * check_forged - Boolean value. If TRUE, will not overwrite the card's assignment if the card has been forged.
 */
/datum/controller/subsystem/id_access/proc/apply_template_to_chameleon_card(obj/item/card/id/advanced/chameleon/id_card, template_path, check_forged = TRUE)
	var/datum/access_template/template = template_singletons_by_path[template_path]
	id_card.template_icon_override = template.template_icon
	id_card.template_state_override = template.template_state
	id_card.template_assignment_override = template.assignment
	id_card.sechud_icon_state_override = template.sechud_icon_state

	if(!check_forged || !id_card.forged)
		id_card.assignment = template.assignment

	// We'll let the chameleon action update the card's label as necessary instead of doing it here.

/**
 * Removes a template from a chameleon ID card.
 *
 * Arguments:
 * * id_card - The ID card to remove the template from.
 */
/datum/controller/subsystem/id_access/proc/remove_template_from_chameleon_card(obj/item/card/id/advanced/chameleon/id_card)
	id_card.template_icon_override = null
	id_card.template_state_override = null
	id_card.template_assignment_override = null
	id_card.sechud_icon_state_override = null

/**
 * Adds the accesses associated with a template to an ID card.
 *
 * Clears the card's existing access levels first.
 * Primarily intended for applying template templates to cards.
 *
 * Arguments:
 * * id_card - The ID card to remove the template from.
 * * template_path - Typepath of the template to use.
 */
/datum/controller/subsystem/id_access/proc/apply_template_access_to_card(obj/item/card/id/id_card, template_path)
	var/datum/access_template/template = template_singletons_by_path[template_path]

	id_card.clear_access()

	id_card.template = template

	if(template.assignment)
		id_card.assignment = template.assignment

	id_card.add_access(template.access)
	id_card.update_label()
	id_card.update_icon()

/**
 * Tallies up all accesses the card has that have flags greater than or equal to the access_flag supplied.
 *
 * Returns the number of accesses that are in the given access group.
 * Arguments:
 * * id_card - The ID card to tally up access for.
 * * access_group - A typepath to check access for.
 */
/datum/controller/subsystem/id_access/proc/tally_access(obj/item/card/id/id_card, access_group)
	var/tally = 0
	var/datum/access_group/group = access_groups[access_group]
	for(var/access in id_card.access)
		if(access in group.access)
			tally++

	return tally

/// Get a global pin code, generates it if it doesn't already exist.
/// Uses the passed length only if generating.
/datum/controller/subsystem/id_access/proc/get_static_pincode(pincode_id, code_len = 5)
	if(!pincode_id)
		CRASH("Tried to retrieve static pincode with no pin ID")

	var/code = static_pincodes[pincode_id]
	if(!code)
		while(length(code) < code_len)
			code += "[rand(0,9)]"
		static_pincodes[pincode_id] = code
	return code
