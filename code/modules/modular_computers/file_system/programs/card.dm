/datum/computer_file/program/card_mod
	filename = "plexagonidwriter"
	filedesc = "ThinkDOS Access Management"
	category = PROGRAM_CATEGORY_CREW
	program_icon_state = "id"
	extended_desc = "Program for programming employee ID cards to access parts of the station."
	transfer_access = list(ACCESS_FACTION_LEADER)
	requires_ntnet = 0
	size = 8
	tgui_id = "NtosCard"
	program_icon = "id-card"

	/// If TRUE, this program only modifies Centcom accesses.
	var/is_centcom = FALSE
	/// If TRUE, this program is authenticated with limited departmental access.
	var/minor = FALSE
	/// The name/assignment combo of the ID card used to authenticate.
	var/authenticated_card
	/// The access of the card used to authenticate.
	var/authenticated_card_access
	/// The template belonging to the authenticated card.
	var/datum/access_template/authenticated_card_template
	/// The name of the registered user, related to `authenticated_card`.
	var/authenticated_user
	/// The regions this program has access to based on the authenticated ID.
	var/list/region_access = list()
	/// The list of accesses this program is verified to change based on the authenticated ID. Used for state checking against player input.
	var/list/valid_access = list()
	/// List of job templates that can be applied to ID cards from this program.
	var/list/job_templates = list()
	/// Which departments this program has access to. See region defines.
	var/target_dept

/**
 * Authenticates the program based on the specific ID card.
 *
 * If the card has ACCESS_CHANGE_IDs, it authenticates with all options.
 * Otherwise, it authenticates depending on SSid_access.sub_department_managers_tgui
 * compared to the access on the supplied ID card.
 * Arguments:
 * * user - Program's user.
 * * id_card - The ID card to attempt to authenticate under.
 */
/datum/computer_file/program/card_mod/proc/authenticate(mob/user, obj/item/card/id/id_card)
	if(!id_card)
		return

	region_access.Cut()
	valid_access.Cut()
	job_templates.Cut()

	// If the program isn't locked to a specific department or is_centcom and we have ACCESS_CHANGE_IDS in our auth card, we're not minor.
	if((!target_dept || is_centcom) && (ACCESS_CHANGE_IDS in id_card.GetAccess()))
		minor = FALSE
		authenticated_card = "[id_card.name]"
		authenticated_card_access = id_card.GetAccess()
		authenticated_card_template = id_card.trim
		authenticated_user = id_card.registered_name ? id_card.registered_name : "Unknown"
		job_templates = is_centcom ? SSid_access.centcom_job_templates.Copy() : SSid_access.station_job_templates.Copy()
		valid_access = is_centcom ? SSid_access.get_access_for_group(list(/datum/access_group/centcom)) : SSid_access.get_access_for_group(list(/datum/access_group/station/all))
		update_static_data(user)
		return TRUE

	// Otherwise, we're minor and now we have to build a list of restricted departments we can change access for.
	var/list/managers = SSid_access.sub_department_managers_tgui
	for(var/access_as_text in managers)
		var/datum/access_group_manager/manager = managers[access_as_text]
		var/access = text2num(access_as_text)
		if((access in id_card.access) && ((target_dept in manager.access_groups) || !target_dept))
			region_access |= manager.access_groups
			job_templates |= manager.templates

	if(length(region_access))
		minor = TRUE
		valid_access |= SSid_access.get_access_for_group(region_access)
		authenticated_card = "[id_card.name] \[LIMITED ACCESS\]"
		authenticated_card_access = id_card.GetAccess()
		authenticated_card_template = id_card.trim
		update_static_data(user)
		return TRUE

	return FALSE

/datum/computer_file/program/card_mod/ui_act(action, params)
	. = ..()
	if(.)
		return

	var/obj/item/computer_hardware/card_slot/card_slot
	var/obj/item/computer_hardware/card_slot/card_slot2
	var/obj/item/computer_hardware/printer/printer
	if(computer)
		card_slot = computer.all_components[MC_CARD]
		card_slot2 = computer.all_components[MC_CARD2]
		printer = computer.all_components[MC_PRINT]
		if(!card_slot || !card_slot2)
			return

	var/mob/user = usr
	var/obj/item/card/id/user_id_card = card_slot.stored_card
	var/obj/item/card/id/target_id_card = card_slot2.stored_card

	switch(action)
		// Log in.
		if("PRG_authenticate")
			if(!computer || !user_id_card)
				playsound(computer, 'sound/machines/terminal_prompt_deny.ogg', 50, FALSE)
				return TRUE
			if(authenticate(user, user_id_card))
				playsound(computer, 'sound/machines/terminal_on.ogg', 50, FALSE)
				return TRUE
		// Log out.
		if("PRG_logout")
			authenticated_card = null
			authenticated_user = null
			authenticated_card_template = null
			authenticated_card_access = null
			playsound(computer, 'sound/machines/terminal_off.ogg', 50, FALSE)
			return TRUE
		// Print a report.
		if("PRG_print")
			if(!computer || !printer)
				return TRUE
			if(!authenticated_card)
				return TRUE
			var/contents = {"<h4>Access Report</h4>
						<u>Prepared By:</u> [authenticated_user]<br>
						<u>For:</u> [target_id_card.registered_name ? target_id_card.registered_name : "Unregistered"]<br>
						<hr>
						<u>Assignment:</u> [target_id_card.assignment]<br>
						<u>Access:</u><br>
						"}

			var/list/known_access_rights = SSid_access.get_access_for_group(list(/datum/access_group/station/all))
			for(var/A in target_id_card.access)
				if(A in known_access_rights)
					contents += "  [SSid_access.get_access_desc(A)]"

			if(!printer.print_text(contents,"access report - [target_id_card.registered_name ? target_id_card.registered_name : "Unregistered"]"))
				to_chat(usr, span_notice("Hardware error: Printer was unable to print the file. It may be out of paper."))
				return TRUE
			else
				playsound(computer, 'sound/machines/terminal_on.ogg', 50, FALSE)
				computer.visible_message(span_notice("\The [computer] prints out a paper."))
			return TRUE
		// Eject the ID used to log on to the ID app.
		if("PRG_ejectauthid")
			if(!computer || !card_slot)
				return TRUE
			if(user_id_card)
				return card_slot.try_eject(user)
			else
				var/obj/item/I = user.get_active_held_item()
				if(istype(I, /obj/item/card/id))
					return card_slot.try_insert(I, user)
		// Eject the ID being modified.
		if("PRG_ejectmodid")
			if(!computer || !card_slot2)
				return TRUE
			if(target_id_card)
				SSdatacore.manifest_modify(target_id_card.registered_name, target_id_card.assignment, target_id_card.get_trim_assignment())
				return card_slot2.try_eject(user)
			else
				var/obj/item/I = user.get_active_held_item()
				if(istype(I, /obj/item/card/id))
					return card_slot2.try_insert(I, user)
			return TRUE

		// Used to fire someone. Wipes all access from their card and modifies their assignment.
		if("PRG_terminate")
			if(!computer || !authenticated_card)
				return TRUE
			if(minor)
				if(!(target_id_card.trim?.type in job_templates))
					to_chat(usr, span_notice("Software error: You do not have the necessary permissions to demote this card."))
					return TRUE

			// Set the new assignment then remove the trim.
			target_id_card.assignment = is_centcom ? "Fired" : "Demoted"
			SSid_access.remove_template_from_card(target_id_card)

			playsound(computer, 'sound/machines/terminal_prompt_deny.ogg', 50, FALSE)
			return TRUE

		// Change ID card assigned name.
		if("PRG_edit")
			if(!computer || !authenticated_card || !target_id_card)
				return TRUE

			var/old_name = target_id_card.registered_name

			// Sanitize the name first. We're not using the full sanitize_name proc as ID cards can have a wider variety of things on them that
			// would not pass as a formal character name, but would still be valid on an ID card created by a player.
			var/new_name = sanitize(params["name"])

			if(!new_name)
				target_id_card.registered_name = null
				playsound(computer, SFX_TERMINAL_TYPE, 50, FALSE)
				target_id_card.update_label()
				// We had a name before and now we have no name, so this will unassign the card and we update the icon.
				if(old_name)
					target_id_card.update_icon()
				return TRUE

			// However, we are going to reject bad names overall including names with invalid characters in them, while allowing numbers.
			new_name = reject_bad_name(new_name, allow_numbers = TRUE)

			if(!new_name)
				to_chat(usr, span_notice("Software error: The ID card rejected the new name as it contains prohibited characters."))
				return TRUE

			target_id_card.registered_name = new_name
			playsound(computer, SFX_TERMINAL_TYPE, 50, FALSE)
			target_id_card.update_label()
			// Card wasn't assigned before and now it is, so update the icon accordingly.
			if(!old_name)
				target_id_card.update_icon()
			return TRUE

		// Change age
		if("PRG_age")
			if(!computer || !authenticated_card || !target_id_card)
				return TRUE

			var/new_age = params["id_age"]
			if(!isnum(new_age))
				stack_trace("[key_name(usr)] ([usr]) attempted to set invalid age \[[new_age]\] to [target_id_card]")
				return TRUE

			target_id_card.registered_age = new_age
			playsound(computer, SFX_TERMINAL_TYPE, 50, FALSE)
			update_records()
			return TRUE

		// Change assignment
		if("PRG_assign")
			if(!computer || !authenticated_card || !target_id_card)
				return TRUE

			var/new_asignment = sanitize(params["assignment"])
			target_id_card.assignment = new_asignment

			playsound(computer, SFX_TERMINAL_TYPE, 50, FALSE)

			target_id_card.update_label()
			update_records()
			return TRUE

		// Add/remove access.
		if("PRG_access")
			if(!computer || !authenticated_card || !target_id_card)
				return TRUE

			playsound(computer, SFX_TERMINAL_TYPE, 50, FALSE)
			var/access_type = params["access_target"]
			if(!(access_type in valid_access))
				stack_trace("[key_name(usr)] ([usr]) attempted to add invalid access \[[access_type]\] to [target_id_card]")
				return TRUE

			if(access_type in target_id_card.access)
				target_id_card.remove_access(list(access_type))
				LOG_ID_ACCESS_CHANGE(user, target_id_card, "removed [SSid_access.get_access_desc(access_type)]")
				return TRUE

			if(!target_id_card.add_access(list(access_type)))
				to_chat(usr, span_notice("ID error: ID card rejected your attempted access modification."))
				LOG_ID_ACCESS_CHANGE(user, target_id_card, "failed to add [SSid_access.get_access_desc(access_type)]")
				return TRUE

			if(access_type in ACCESS_ALERT_ADMINS)
				message_admins("[ADMIN_LOOKUPFLW(user)] just added [SSid_access.get_access_desc(access_type)] to an ID card [ADMIN_VV(target_id_card)] [(target_id_card.registered_name) ? "belonging to [target_id_card.registered_name]." : "with no registered name."]")
			LOG_ID_ACCESS_CHANGE(user, target_id_card, "added [SSid_access.get_access_desc(access_type)]")
			return TRUE

		// Apply template to ID card.
		if("PRG_template")
			if(!computer || !authenticated_card || !target_id_card)
				return TRUE

			playsound(computer, SFX_TERMINAL_TYPE, 50, FALSE)
			var/template_name = params["name"]

			if(!template_name)
				return TRUE

			for(var/trim_path in job_templates)
				var/datum/access_template/trim = SSid_access.trim_singletons_by_path[trim_path]
				if(trim.assignment != template_name)
					continue

				SSid_access.apply_template_access_to_card(target_id_card, trim_path)
				update_records()
				return TRUE

			stack_trace("[key_name(usr)] ([usr]) attempted to apply invalid template \[[template_name]\] to [target_id_card]")
			return TRUE

/datum/computer_file/program/card_mod/ui_static_data(mob/user)
	var/list/data = list()
	data["station_name"] = station_name()
	data["centcom_access"] = is_centcom
	data["minor"] = target_dept || minor ? TRUE : FALSE

	var/list/groups = list()
	var/list/access_group_data = SSid_access.tgui_access_groups
	if(is_centcom)
		groups += access_group_data[/datum/access_group/centcom]
	else
		for(var/datum/access_group/group_path as anything in SSid_access.station_groups)
			if((minor || target_dept) && !(group_path in region_access))
				continue
			groups += access_group_data[group_path]

	data["accessGroups"] = groups
	data["showBasic"] = TRUE
	data["templates"] = job_templates

	return data

/datum/computer_file/program/card_mod/ui_data(mob/user)
	var/list/data = get_header_data()

	data["station_name"] = station_name()

	var/obj/item/computer_hardware/card_slot/card_slot
	var/obj/item/computer_hardware/card_slot/card_slot2
	var/obj/item/computer_hardware/printer/printer

	if(computer)
		card_slot = computer.all_components[MC_CARD]
		card_slot2 = computer.all_components[MC_CARD2]
		printer = computer.all_components[MC_PRINT]
		data["have_auth_card"] = !!(card_slot)
		data["have_id_slot"] = !!(card_slot2)
		data["have_printer"] = !!(printer)
	else
		data["have_id_slot"] = FALSE
		data["have_printer"] = FALSE

	if(!card_slot2)
		return data //We're just gonna error out on the js side at this point anyway

	var/obj/item/card/id/auth_card = card_slot.stored_card
	data["authIDName"] = auth_card ? auth_card.name : "-----"

	data["authenticatedUser"] = authenticated_card

	var/obj/item/card/id/id_card = card_slot2.stored_card
	data["has_id"] = !!id_card
	data["id_name"] = id_card ? id_card.name : "-----"
	if(id_card)
		data["id_rank"] = id_card.assignment ? id_card.assignment : "Unassigned"
		data["id_owner"] = id_card.registered_name ? id_card.registered_name : "-----"
		data["access_on_card"] = id_card.access
		data["id_age"] = id_card.registered_age

		if(id_card.trim)
			var/datum/access_template/card_trim = id_card.trim
			data["hasTrim"] = TRUE
			data["trimAssignment"] = card_trim.assignment ? card_trim.assignment : ""
			data["trimAccess"] = card_trim.access ? card_trim.access : list()
		else
			data["hasTrim"] = FALSE
			data["trimAssignment"] = ""
			data["trimAccess"] = list()

	return data

/// Update the datacore entry for the given ID.
/datum/computer_file/program/card_mod/proc/update_records()
	if(!computer || !authenticated_card_template?.datacore_record_key)
		return FALSE

	var/obj/item/computer_hardware/card_slot/card_slot2

	card_slot2 = computer.all_components[MC_CARD2]
	if(!card_slot2)
		return FALSE

	var/obj/item/card/id/target_id_card = card_slot2.stored_card
	if(!target_id_card)
		return FALSE

	if(!SSdatacore.can_modify_records(authenticated_card_template.datacore_record_key, authenticated_card_access))
		return FALSE

	var/datum/data/record/record = SSdatacore.get_record_by_name(target_id_card.registered_name, authenticated_card_template.datacore_record_key)
	if(!record)
		return FALSE

	record.fields[DATACORE_RANK] = target_id_card.assignment
	record.fields[DATACORE_TEMPLATE_RANK] = target_id_card.trim?.assignment
	record.fields[DATACORE_AGE] = target_id_card.registered_age
	return TRUE
