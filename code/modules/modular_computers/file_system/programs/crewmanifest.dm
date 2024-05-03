/datum/computer_file/program/crew_manifest
	filename = "plexagoncrew"
	filedesc = "Staff List"
	category = PROGRAM_CATEGORY_CREW
	program_icon_state = "id"
	extended_desc = "Program for viewing and printing the current staff manifest"
	transfer_access = list(ACCESS_HEADS)
	requires_ntnet = TRUE
	size = 4
	tgui_id = "NtosCrewManifest"
	program_icon = "clipboard-list"

	var/manifest_key = DATACORE_RECORDS_STATION

/datum/computer_file/program/crew_manifest/ui_static_data(mob/user)
	var/list/data = list()
	data["manifest"] = SSdatacore.get_manifest(manifest_key)
	return data

/datum/computer_file/program/crew_manifest/ui_data(mob/user)
	var/list/data = get_header_data()

	var/obj/item/computer_hardware/printer/printer
	if(computer)
		printer = computer.all_components[MC_PRINT]

	if(computer)
		data["have_printer"] = !!printer
	else
		data["have_printer"] = FALSE

	data["manifest_key"] = manifest_key || FALSE
	return data

/datum/computer_file/program/crew_manifest/ui_act(action, params, datum/tgui/ui)
	. = ..()
	if(.)
		return

	var/obj/item/computer_hardware/printer/printer
	if(computer)
		printer = computer.all_components[MC_PRINT]

	switch(action)
		if("PRG_print")
			if(computer && printer) //This option should never be called if there is no printer
				var/contents = {"<h4>Staff Manifest</h4>
								<br>
								[SSdatacore.get_manifest_html(manifest_key)]
								"}
				if(!printer.print_text(contents, "staff manifest ([stationtime2text()])"))
					to_chat(usr, span_notice("Hardware error: Printer was unable to print the file. It may be out of paper."))
					return
				else
					computer.visible_message(span_notice("\The [computer] prints out a paper."))

/datum/computer_file/program/crew_manifest/event_id_removed(background, device_type)
	. = ..()
	if(background)
		return

	update_manifest_key()

/datum/computer_file/program/crew_manifest/event_id_inserted(background, device_type)
	. = ..()
	if(background)
		return

	update_manifest_key()

/datum/computer_file/program/crew_manifest/run_program(mob/living/user)
	. = ..()
	if(.)
		update_manifest_key()

/datum/computer_file/program/crew_manifest/proc/update_manifest_key()
	. = manifest_key

	var/obj/item/modular_computer/parent = holder?.holder
	if(!parent)
		manifest_key = null
		if(. != manifest_key)
			update_static_data_for_all()
		return

	if(istype(parent, /obj/item/modular_computer/tablet/integrated))
		manifest_key = DATACORE_RECORDS_STATION
		if(. != manifest_key)
			update_static_data_for_all()
		return

	var/obj/item/computer_hardware/card_slot/card_slot = parent.all_components[MC_CARD] || parent.all_components[MC_CARD2]
	var/list/access = card_slot?.GetAccess()
	if(!length(access))
		manifest_key = null
		if(. != manifest_key)
			update_static_data_for_all()
		return

	if(ACCESS_HEADS in access)
		manifest_key = DATACORE_RECORDS_STATION

	else if(ACCESS_MEDICAL in access)
		manifest_key = DATACORE_RECORDS_AETHER

	else if(ACCESS_ENGINE in access)
		manifest_key = DATACORE_RECORDS_DAEDALUS

	else if(ACCESS_CARGO in access)
		manifest_key = DATACORE_RECORDS_HERMES

	else if(ACCESS_SECURITY in access)
		manifest_key = DATACORE_RECORDS_MARS

	else
		manifest_key = null

	if(. != manifest_key)
		update_static_data_for_all()
