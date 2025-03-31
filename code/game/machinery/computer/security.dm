/obj/machinery/computer/secure_data//TODO:SANITY
	name = "security records console"
	desc = "Used to view and edit personnel's security records."
	icon_screen = "security"
	icon_keyboard = "security_key"
	req_one_access = list(ACCESS_SECURITY, ACCESS_FORENSICS, ACCESS_HOP)
	circuit = /obj/item/circuitboard/computer/secure_data
	light_color = COLOR_SOFT_RED
	var/rank = null
	var/screen = null
	var/datum/data/record/active1 = null
	var/datum/data/record/active2 = null
	var/temp = null
	var/printing = null
	var/can_change_id = 0
	var/list/Perp
	var/tempname = null
	//Sorting Variables
	var/sortBy = "name"
	var/order = 1 // -1 = Descending - 1 = Ascending

/obj/machinery/computer/secure_data/Initialize(mapload, obj/item/circuitboard/C)
	. = ..()
	AddComponent(/datum/component/usb_port, list(
		/obj/item/circuit_component/arrest_console_data,
		/obj/item/circuit_component/arrest_console_arrest,
	))

#define COMP_SECURITY_ARREST_AMOUNT_TO_FLAG 10

/obj/item/circuit_component/arrest_console_data
	display_name = "Security Records Data"
	desc = "Outputs the security records data, where it can then be filtered with a Select Query component"
	circuit_flags = CIRCUIT_FLAG_INPUT_SIGNAL|CIRCUIT_FLAG_OUTPUT_SIGNAL

	/// The records retrieved
	var/datum/port/output/records

	/// Sends a signal on failure
	var/datum/port/output/on_fail

	var/obj/machinery/computer/secure_data/attached_console

/obj/item/circuit_component/arrest_console_data/populate_ports()
	records = add_output_port("Security Records", PORT_TYPE_TABLE)
	on_fail = add_output_port("Failed", PORT_TYPE_SIGNAL)

/obj/item/circuit_component/arrest_console_data/register_usb_parent(atom/movable/shell)
	. = ..()
	if(istype(shell, /obj/machinery/computer/secure_data))
		attached_console = shell

/obj/item/circuit_component/arrest_console_data/unregister_usb_parent(atom/movable/shell)
	attached_console = null
	return ..()

/obj/item/circuit_component/arrest_console_data/get_ui_notices()
	. = ..()
	. += create_table_notices(list(
		"name",
		"id",
		"rank",
		"arrest_status",
		"gender",
		"age",
		"species",
		"fingerprint",
	))


/obj/item/circuit_component/arrest_console_data/input_received(datum/port/input/port)

	if(!attached_console || !attached_console.authenticated)
		on_fail.set_output(COMPONENT_SIGNAL)
		return

	if(isnull(SSdatacore.get_records(DATACORE_RECORDS_STATION)))
		on_fail.set_output(COMPONENT_SIGNAL)
		return

	var/list/new_table = list()
	for(var/datum/data/record/player_record as anything in SSdatacore.get_records(DATACORE_RECORDS_STATION))
		var/list/entry = list()
		var/datum/data/record/player_security_record = SSdatacore.find_record("id", player_record.fields[DATACORE_ID], DATACORE_RECORDS_SECURITY)
		if(player_security_record)
			entry["arrest_status"] = player_security_record.fields[DATACORE_CRIMINAL_STATUS]
			entry["security_record"] = player_security_record
		entry["name"] = player_record.fields[DATACORE_NAME]
		entry["id"] = player_record.fields[DATACORE_ID]
		entry["rank"] = player_record.fields[DATACORE_RANK]
		entry["gender"] = player_record.fields[DATACORE_GENDER]
		entry["age"] = player_record.fields[DATACORE_AGE]
		entry["species"] = player_record.fields[DATACORE_SPECIES]
		entry["fingerprint"] = player_record.fields[DATACORE_FINGERPRINT]

		new_table += list(entry)

	records.set_output(new_table)

/obj/item/circuit_component/arrest_console_arrest
	display_name = "Security Records Set Status"
	desc = "Receives a table to use to set people's arrest status. Table should be from the security records data component. If New Status port isn't set, the status will be decided by the options."
	circuit_flags = CIRCUIT_FLAG_INPUT_SIGNAL|CIRCUIT_FLAG_OUTPUT_SIGNAL

	/// The targets to set the status of.
	var/datum/port/input/targets

	/// Sets the new status of the targets.
	var/datum/port/input/option/new_status

	/// Returns the new status set once the setting is complete. Good for locating errors.
	var/datum/port/output/new_status_set

	/// Sends a signal on failure
	var/datum/port/output/on_fail

	var/obj/machinery/computer/secure_data/attached_console

/obj/item/circuit_component/arrest_console_arrest/register_usb_parent(atom/movable/shell)
	. = ..()
	if(istype(shell, /obj/machinery/computer/secure_data))
		attached_console = shell

/obj/item/circuit_component/arrest_console_arrest/unregister_usb_parent(atom/movable/shell)
	attached_console = null
	return ..()

/obj/item/circuit_component/arrest_console_arrest/populate_options()
	var/static/list/component_options = list(
		CRIMINAL_WANTED,
		CRIMINAL_INCARCERATED,
		CRIMINAL_SUSPECT,
		CRIMINAL_PAROLE,
		CRIMINAL_DISCHARGED,
		CRIMINAL_NONE,
	)
	new_status = add_option_port("Arrest Options", component_options)

/obj/item/circuit_component/arrest_console_arrest/populate_ports()
	targets = add_input_port("Targets", PORT_TYPE_TABLE)
	new_status_set = add_output_port("Set Status", PORT_TYPE_STRING)
	on_fail = add_output_port("Failed", PORT_TYPE_SIGNAL)

/obj/item/circuit_component/arrest_console_arrest/input_received(datum/port/input/port)

	if(!attached_console || !attached_console.authenticated)
		on_fail.set_output(COMPONENT_SIGNAL)
		return

	var/status_to_set = new_status.value

	new_status_set.set_output(status_to_set)
	var/list/target_table = targets.value
	if(!target_table)
		on_fail.set_output(COMPONENT_SIGNAL)
		return

	var/successful_set = 0
	var/list/names_of_entries = list()
	for(var/list/target in target_table)
		var/datum/data/record/security/sec_record = target["security_record"]
		if(!sec_record)
			continue

		if(sec_record.fields[DATACORE_CRIMINAL_STATUS] != status_to_set)
			successful_set++
			names_of_entries += target["name"]
		sec_record.set_criminal_status(status_to_set)


	if(successful_set > 0)
		investigate_log("[names_of_entries.Join(", ")] have been set to [status_to_set] by [parent.get_creator()].", INVESTIGATE_RECORDS)
		if(successful_set > COMP_SECURITY_ARREST_AMOUNT_TO_FLAG)
			message_admins("[successful_set] security entries have been set to [status_to_set] by [parent.get_creator_admin()]. [ADMIN_COORDJMP(src)]")
		for(var/mob/living/carbon/human/human as anything in GLOB.human_list)
			human.sec_hud_set_security_status()

#undef COMP_SECURITY_ARREST_AMOUNT_TO_FLAG

/obj/machinery/computer/secure_data/syndie
	icon_keyboard = "syndie_key"
	req_one_access = list(ACCESS_SYNDICATE)

/obj/machinery/computer/secure_data/laptop
	name = "security laptop"
	desc = "A cheap Thinktronic security laptop, it functions as a security records console. It's bolted to the table."
	icon_state = "laptop"
	icon_screen = "seclaptop"
	icon_keyboard = "laptop_key"
	pass_flags = PASSTABLE

/obj/machinery/computer/secure_data/laptop/syndie
	desc = "A cheap, jailbroken security laptop. It functions as a security records console. It's bolted to the table."
	req_one_access = list(ACCESS_SYNDICATE)

//Someone needs to break down the dat += into chunks instead of long ass lines.
/obj/machinery/computer/secure_data/ui_interact(mob/user)
	. = ..()
	if(isliving(user))
		playsound(src, 'sound/machines/terminal_prompt_confirm.ogg', 50, FALSE)
	if(src.z > 6)
		to_chat(user, "[span_boldannounce("Unable to establish a connection")]: \black You're too far away from the station!")
		return
	var/dat

	if(temp)
		dat = "<TT>[temp]</TT><BR><BR><A href='?src=[REF(src)];choice=Clear Screen'>Clear Screen</A>"
	else
		dat = ""
		if(authenticated)
			switch(screen)
				if(1)

					//body tag start + onload and onkeypress (onkeyup) javascript event calls
					dat += "<body onload='selectTextField(); updateSearch();' onkeyup='updateSearch();'>"
					//search bar javascript
					dat += {"

		<head>
			<script src="[SSassets.transport.get_asset_url("jquery.min.js")]"></script>
			<script type='text/javascript'>

				function updateSearch(){
					var filter_text = document.getElementById('filter');
					var filter = filter_text.value.toLowerCase();

					if(complete_list != null && complete_list != ""){
						var mtbl = document.getElementById("maintable_data_archive");
						mtbl.innerHTML = complete_list;
					}

					if(filter.value == ""){
						return;
					}else{
						$("#maintable_data").children("tbody").children("tr").children("td").children("input").filter(function(index)
						{
							return $(this)\[0\].value.toLowerCase().indexOf(filter) == -1
						}).parent("td").parent("tr").hide()
					}
				}

				function selectTextField(){
					var filter_text = document.getElementById('filter');
					filter_text.focus();
					filter_text.select();
				}

			</script>
		</head>


	"}
					dat += {"
<p style='text-align:center;'>"}
					dat += "<A href='?src=[REF(src)];choice=New Record (General)'>New Record</A><BR>"
					//search bar
					dat += {"
						<table width='560' align='center' cellspacing='0' cellpadding='5' id='maintable'>
							<tr id='search_tr'>
								<td align='center'>
									<b>Search:</b> <input type='text' id='filter' value='' style='width:300px;'>
								</td>
							</tr>
						</table>
					"}
					dat += {"
</p>
<table style="text-align:center;" cellspacing="0" width="100%">
<tr>
<th>Records:</th>
</tr>
</table>

<span id='maintable_data_archive'>
<table id='maintable_data' style="text-align:center;" border="1" cellspacing="0" width="100%">
<tr>
<th><A href='?src=[REF(src)];choice=Sorting;sort=name'>Name</A></th>
<th><A href='?src=[REF(src)];choice=Sorting;sort=id'>ID</A></th>
<th><A href='?src=[REF(src)];choice=Sorting;sort=rank'>Rank</A></th>
<th><A href='?src=[REF(src)];choice=Sorting;sort=fingerprint'>Fingerprints</A></th>
<th>Criminal Status</th>
</tr>"}
					if(!isnull(SSdatacore.get_records(DATACORE_RECORDS_STATION)))
						for(var/datum/data/record/R in sort_record(SSdatacore.get_records(DATACORE_RECORDS_STATION), sortBy, order))
							var/crimstat = ""
							for(var/datum/data/record/E in SSdatacore.get_records(DATACORE_RECORDS_SECURITY))
								if((E.fields[DATACORE_NAME] == R.fields[DATACORE_NAME]) && (E.fields[DATACORE_ID] == R.fields[DATACORE_ID]))
									crimstat = E.fields[DATACORE_CRIMINAL_STATUS]
							var/background
							switch(crimstat)
								if(CRIMINAL_WANTED)
									background = "'background-color:#990000;'"
								if(CRIMINAL_INCARCERATED)
									background = "'background-color:#CD6500;'"
								if(CRIMINAL_SUSPECT)
									background = "'background-color:#CD6500;'"
								if(CRIMINAL_PAROLE)
									background = "'background-color:#CD6500;'"
								if(CRIMINAL_DISCHARGED)
									background = "'background-color:#006699;'"
								if(CRIMINAL_NONE)
									background = "'background-color:#4F7529;'"
								if("")
									background = "''" //"'background-color:#FFFFFF;'"
									crimstat = "No Record."
							dat += "<tr style=[background]>"
							dat += "<td><input type='hidden' value='[R.fields[DATACORE_NAME]] [R.fields[DATACORE_ID]] [R.fields[DATACORE_RANK]] [R.fields[DATACORE_FINGERPRINT]]'></input><A href='?src=[REF(src)];choice=Browse Record;d_rec=[REF(R)]'>[R.fields[DATACORE_NAME]]</a></td>"
							dat += "<td>[R.fields[DATACORE_ID]]</td>"
							dat += "<td>[R.fields[DATACORE_RANK]]</td>"
							dat += "<td>[R.fields[DATACORE_FINGERPRINT]]</td>"
							dat += "<td>[crimstat]</td></tr>"
						dat += {"
						</table></span>
						<script type='text/javascript'>
							var maintable = document.getElementById("maintable_data_archive");
							var complete_list = maintable.innerHTML;
						</script>
						<hr width='75%' />"}
					dat += "<A href='?src=[REF(src)];choice=Record Maintenance'>Record Maintenance</A><br><br>"
					dat += "<A href='?src=[REF(src)];choice=Log Out'>{Log Out}</A>"
				if(2)
					dat += "<B>Records Maintenance</B><HR>"
					dat += "<BR><A href='?src=[REF(src)];choice=Delete All Records'>Delete All Records</A><BR><BR><A href='?src=[REF(src)];choice=Return'>Back</A>"
				if(3)
					dat += "<font size='4'><b>Security Record</b></font><br>"
					if(istype(active1, /datum/data/record) && SSdatacore.get_records(DATACORE_RECORDS_STATION).Find(active1))
						var/front_photo = active1.get_front_photo()
						if(istype(front_photo, /obj/item/photo))
							var/obj/item/photo/photo_front = front_photo
							user << browse_rsc(photo_front.picture.picture_image, "photo_front")
						var/side_photo = active1.get_side_photo()
						if(istype(side_photo, /obj/item/photo))
							var/obj/item/photo/photo_side = side_photo
							user << browse_rsc(photo_side.picture.picture_image, "photo_side")
						dat += {"<table><tr><td><table>
						<tr><td>Name:</td><td><A href='?src=[REF(src)];choice=Edit Field;field=name'>&nbsp;[active1.fields[DATACORE_NAME]]&nbsp;</A></td></tr>
						<tr><td>ID:</td><td><A href='?src=[REF(src)];choice=Edit Field;field=id'>&nbsp;[active1.fields[DATACORE_ID]]&nbsp;</A></td></tr>
						<tr><td>Gender:</td><td><A href='?src=[REF(src)];choice=Edit Field;field=gender'>&nbsp;[active1.fields[DATACORE_GENDER]]&nbsp;</A></td></tr>
						<tr><td>Age:</td><td><A href='?src=[REF(src)];choice=Edit Field;field=age'>&nbsp;[active1.fields[DATACORE_AGE]]&nbsp;</A></td></tr>"}
						dat += "<tr><td>Species:</td><td><A href ='?src=[REF(src)];choice=Edit Field;field=species'>&nbsp;[active1.fields[DATACORE_SPECIES]]&nbsp;</A></td></tr>"
						dat += {"<tr><td>Rank:</td><td><A href='?src=[REF(src)];choice=Edit Field;field=rank'>&nbsp;[active1.fields[DATACORE_RANK]]&nbsp;</A></td></tr>
						<tr><td>Initial Rank:</td><td>[active1.fields[DATACORE_INITIAL_RANK]]</td>
						<tr><td>Fingerprint:</td><td><A href='?src=[REF(src)];choice=Edit Field;field=fingerprint'>&nbsp;[active1.fields[DATACORE_FINGERPRINT]]&nbsp;</A></td></tr>
						<tr><td>Physical Status:</td><td>&nbsp;[active1.fields[DATACORE_PHYSICAL_HEALTH]]&nbsp;</td></tr>
						<tr><td>Mental Status:</td><td>&nbsp;[active1.fields[DATACORE_MENTAL_HEALTH]]&nbsp;</td></tr>
						</table></td>
						<td><table><td align = center><a href='?src=[REF(src)];choice=Edit Field;field=show_photo_front'><img src=photo_front height=96 width=96 border=4 style="-ms-interpolation-mode:nearest-neighbor"></a><br>
						<a href='?src=[REF(src)];choice=Edit Field;field=print_photo_front'>Print photo</a><br>
						<a href='?src=[REF(src)];choice=Edit Field;field=upd_photo_front'>Update front photo</a></td>
						<td align = center><a href='?src=[REF(src)];choice=Edit Field;field=show_photo_side'><img src=photo_side height=96 width=96 border=4 style="-ms-interpolation-mode:nearest-neighbor"></a><br>
						<a href='?src=[REF(src)];choice=Edit Field;field=print_photo_side'>Print photo</a><br>
						<a href='?src=[REF(src)];choice=Edit Field;field=upd_photo_side'>Update side photo</a></td></table>
						</td></tr></table></td></tr></table>"}
					else
						dat += "<br>General Record Lost!<br>"
					if((istype(active2, /datum/data/record) && SSdatacore.get_records(DATACORE_RECORDS_SECURITY).Find(active2)))
						dat += "<font size='4'><b>Security Data</b></font>"
						dat += "<br>Criminal Status: <A href='?src=[REF(src)];choice=Edit Field;field=criminal'>[active2.fields[DATACORE_CRIMINAL_STATUS]]</A>"
						if(active2.fields[DATACORE_CRIMINAL_STATUS] == CRIMINAL_WANTED)
							dat += " [button_element(src, "BROADCAST", "choice=broadcast_criminal;criminal=[REF(active2)]")]"
						dat += "<br><br>Citations: <A href='?src=[REF(src)];choice=Edit Field;field=citation_add'>Add New</A>"

						dat +={"<table style="text-align:center;" border="1" cellspacing="0" width="100%">
						<tr>
						<th>Crime</th>
						<th>Fine</th>
						<th>Author</th>
						<th>Time Added</th>
						<th>Amount Due</th>
						<th>Del</th>
						</tr>"}
						for(var/datum/data/crime/c in active2.fields[DATACORE_CITATIONS])
							var/owed = c.fine - c.paid
							dat += {"<tr><td>[c.crimeName]</td>
							<td>[c.fine] cr</td><td>[c.author]</td>
							<td>[c.time]</td>"}
							if(owed > 0)
								dat += "<td>[owed] cr <A href='?src=[REF(src)];choice=Pay;field=citation_pay;cdataid=[c.dataId]'>\[Pay\]</A></td></td>"
							else
								dat += "<td>All Paid Off</td>"
							dat += {"<td>
							<A href='?src=[REF(src)];choice=Edit  Field;field=citation_delete;cdataid=[c.dataId]'>\[X\]</A>
							</td>
							</tr>"}
						dat += "</table>"

						dat += "<br><br>Crimes: <A href='?src=[REF(src)];choice=Edit Field;field=crim_add'>Add New</A>"


						dat +={"<table style="text-align:center;" border="1" cellspacing="0" width="100%">
						<tr>
						<th>Crime</th>
						<th>Details</th>
						<th>Author</th>
						<th>Time Added</th>
						<th>Del</th>
						</tr>"}
						for(var/datum/data/crime/c in active2.fields[DATACORE_CRIMES])
							dat += "<tr><td>[c.crimeName]</td>"
							if(!c.crimeDetails)
								dat += "<td><A href='?src=[REF(src)];choice=Edit Field;field=add_details;cdataid=[c.dataId]'>\[+\]</A></td>"
							else
								dat += "<td>[c.crimeDetails]</td>"
							dat += "<td>[c.author]</td>"
							dat += "<td>[c.time]</td>"
							dat += "<td><A href='?src=[REF(src)];choice=Edit Field;field=crim_delete;cdataid=[c.dataId]'>\[X\]</A></td>"
							dat += "</tr>"
						dat += "</table>"

						dat += "<br>\nImportant Notes:<br>\n\t<A href='?src=[REF(src)];choice=Edit Field;field=notes'>&nbsp;[active2.fields[DATACORE_NOTES]]&nbsp;</A>"
						dat += "<br><br><font size='4'><b>Comments/Log</b></font><br>"
						var/counter = 1
						while(active2.fields["com_[counter]"])
							dat += (active2.fields["com_[counter]"] + "<BR>")
							if(active2.fields["com_[counter]"] != "<B>Deleted</B>")
								dat += "<A href='?src=[REF(src)];choice=Delete Entry;del_c=[counter]'>Delete Entry</A><BR><BR>"
							counter++
						dat += "<A href='?src=[REF(src)];choice=Add Entry'>Add Entry</A><br><br>"
						dat += "<A href='?src=[REF(src)];choice=Delete Record (Security)'>Delete Record (Security Only)</A><br>"
					else
						dat += "Security Record Lost!<br>"
						dat += "<A href='?src=[REF(src)];choice=New Record (Security)'>New Security Record</A><br><br>"
					dat += "<A href='?src=[REF(src)];choice=Delete Record (ALL)'>Delete Record (ALL)</A><br><A href='?src=[REF(src)];choice=Print Record'>Print Record</A><BR><A href='?src=[REF(src)];choice=Print Poster'>Print Wanted Poster</A><BR><A href='?src=[REF(src)];choice=Print Missing'>Print Missing Persons Poster</A><BR><A href='?src=[REF(src)];choice=Return'>Back</A><BR><BR>"
					dat += "<A href='?src=[REF(src)];choice=Log Out'>{Log Out}</A>"
				else
		else
			dat += "<A href='?src=[REF(src)];choice=Log In'>{Log In}</A>"
	var/datum/browser/popup = new(user, "secure_rec", "Security Records Console", 600, 400)
	popup.set_content(dat)
	popup.open()
	return

/*Revised /N
I can't be bothered to look more of the actual code outside of switch but that probably needs revising too.
What a mess.*/
/obj/machinery/computer/secure_data/Topic(href, href_list)
	. = ..()
	if(.)
		return .
	if(!( SSdatacore.get_records(DATACORE_RECORDS_STATION).Find(active1) ))
		active1 = null
	if(!( SSdatacore.get_records(DATACORE_RECORDS_SECURITY).Find(active2) ))
		active2 = null
	if(!authenticated && href_list["choice"] != "Log In") // logging in is the only action you can do if not logged in
		return
	if(usr.contents.Find(src) || (in_range(src, usr) && isturf(loc)) || issilicon(usr) || isAdminGhostAI(usr))
		usr.set_machine(src)
		switch(href_list["choice"])
// SORTING!
			if("Sorting")
				// Reverse the order if clicked twice
				if(sortBy == href_list["sort"])
					if(order == 1)
						order = -1
					else
						order = 1
				else
				// New sorting order!
					sortBy = href_list["sort"]
					order = initial(order)
//BASIC FUNCTIONS
			if("Clear Screen")
				temp = null

			if("Return")
				screen = 1
				active1 = null
				active2 = null

			if("Log Out")
				authenticated = null
				screen = null
				active1 = null
				active2 = null
				playsound(src, 'sound/machines/terminal_off.ogg', 50, FALSE)

			if("Log In")
				var/obj/item/card/id/I
				if(isliving(usr))
					var/mob/living/L = usr
					I = L.get_idcard(TRUE)
				if(issilicon(usr))
					active1 = null
					active2 = null
					authenticated = usr.name
					rank = "AI"
					screen = 1
				else if(isAdminGhostAI(usr))
					active1 = null
					active2 = null
					authenticated = usr.client.holder.admin_signature
					rank = "Central Command"
					screen = 1
				else if(I && check_access(I))
					active1 = null
					active2 = null
					authenticated = I.registered_name
					rank = I.assignment
					screen = 1
				else
					to_chat(usr, span_danger("Unauthorized Access."))
				playsound(src, 'sound/machines/terminal_on.ogg', 50, FALSE)

			if("broadcast_criminal")
				var/datum/data/record/R = locate(href_list["criminal"]) in SSdatacore.get_records(DATACORE_RECORDS_SECURITY)
				if(!R)
					return
				if(!(R.fields[DATACORE_CRIMINAL_STATUS] == CRIMINAL_WANTED))
					return
				investigate_log("[key_name(usr)] send a security status broadcast for [R.fields[DATACORE_NAME]].", INVESTIGATE_RECORDS)

				SEND_GLOBAL_SIGNAL(COMSIG_GLOB_WANTED_CRIMINAL, R)

//RECORD FUNCTIONS
			if("Record Maintenance")
				screen = 2
				active1 = null
				active2 = null

			if("Browse Record")
				var/datum/data/record/R = locate(href_list["d_rec"]) in SSdatacore.get_records(DATACORE_RECORDS_STATION)
				if(!R)
					temp = "Record Not Found!"
				else
					active1 = active2 = R
					for(var/datum/data/record/E in SSdatacore.get_records(DATACORE_RECORDS_SECURITY))
						if((E.fields[DATACORE_NAME] == R.fields[DATACORE_NAME] || E.fields[DATACORE_ID] == R.fields[DATACORE_ID]))
							active2 = E
					screen = 3

			if("Pay")
				for(var/datum/data/crime/p in active2.fields[DATACORE_CITATIONS])
					if(p.dataId == text2num(href_list["cdataid"]))
						var/obj/item/stack/spacecash/S = usr.is_holding_item_of_type(/obj/item/stack/spacecash)
						if(!istype(S))
							return TRUE

						var/pay = S.get_item_credit_value()
						if(!pay)
							to_chat(usr, span_warning("[S] doesn't seem to be worth anything!"))
						else
							var/diff = p.fine - p.paid
							var/datum/data/record/security/security_record = active2
							security_record.pay_citation(text2num(href_list["cdataid"]), pay)

							to_chat(usr, span_notice("You have paid [pay] credit\s towards your fine."))
							if (pay == diff || pay > diff || pay >= diff)
								investigate_log("Citation Paid off: <strong>[p.crimeName]</strong> Fine: [p.fine] | Paid off by [key_name(usr)]", INVESTIGATE_RECORDS)
								to_chat(usr, span_notice("The fine has been paid in full."))

								var/overflow = pay - diff
								if(overflow)
									SSeconomy.spawn_ones_for_amount(overflow, drop_location())

							SSblackbox.ReportCitation(text2num(href_list["cdataid"]),"","","","", 0, pay)
							qdel(S)
							playsound(src, SFX_TERMINAL_TYPE, 25, FALSE)
					else
						to_chat(usr, span_warning("Fines can only be paid with holochips!"))

			if("Print Record")
				if(!( printing ))
					printing = 1
					SSdatacore.securityPrintCount++
					playsound(loc, 'sound/items/poster_being_created.ogg', 100, TRUE)
					sleep(30)
					var/obj/item/paper/P = new /obj/item/paper( loc )
					P.info = "<CENTER><B>Security Record - (SR-[SSdatacore.securityPrintCount])</B></CENTER><BR>"
					if((istype(active1, /datum/data/record) && SSdatacore.get_records(DATACORE_RECORDS_STATION).Find(active1)))

						P.info += {"
Name: [active1.fields[DATACORE_NAME]] ID: [active1.fields[DATACORE_ID]]<BR>
Gender: [active1.fields[DATACORE_GENDER]]<BR>
Age: [active1.fields[DATACORE_AGE]]<BR>"}

						P.info += "\nSpecies: [active1.fields[DATACORE_SPECIES]]<BR>"
						P.info += "\nFingerprint: [active1.fields[DATACORE_FINGERPRINT]]<BR>\nPhysical Status: [active1.fields[DATACORE_PHYSICAL_HEALTH]]<BR>\nMental Status: [active1.fields[DATACORE_MENTAL_HEALTH]]<BR>"
					else
						P.info += "<B>General Record Lost!</B><BR>"
					if((istype(active2, /datum/data/record) && SSdatacore.get_records(DATACORE_RECORDS_SECURITY).Find(active2)))
						P.info += "<BR>\n<CENTER><B>Security Data</B></CENTER><BR>\nCriminal Status: [active2.fields[DATACORE_CRIMINAL_STATUS]]"

						P.info += "<BR>\n<BR>\nCrimes:<BR>\n"
						P.info +={"<table style="text-align:center;" border="1" cellspacing="0" width="100%">
<tr>
<th>Crime</th>
<th>Details</th>
<th>Author</th>
<th>Time Added</th>
</tr>"}
						for(var/datum/data/crime/c in active2.fields[DATACORE_CRIMES])
							P.info += "<tr><td>[c.crimeName]</td>"
							P.info += "<td>[c.crimeDetails]</td>"
							P.info += "<td>[c.author]</td>"
							P.info += "<td>[c.time]</td>"
							P.info += "</tr>"
						P.info += "</table>"

						P.info += "<BR>\nImportant Notes:<BR>\n\t[active2.fields[DATACORE_NOTES]]<BR>\n<BR>\n<CENTER><B>Comments/Log</B></CENTER><BR>"
						var/counter = 1
						while(active2.fields["com_[counter]"])
							P.info += "[active2.fields["com_[counter]"]]<BR>"
							counter++
						P.name = "SR-[SSdatacore.securityPrintCount] '[active1.fields[DATACORE_NAME]]'"
					else
						P.info += "<B>Security Record Lost!</B><BR>"
						P.name = "SR-[SSdatacore.securityPrintCount] 'Record Lost'"
					P.info += "</TT>"
					P.update_appearance()
					printing = null
			if("Print Poster")
				if(!( printing ))
					var/wanted_name = tgui_input_text(usr, "Enter an alias for the criminal", "Print Wanted Poster", active1.fields[DATACORE_NAME])
					if(wanted_name)
						var/default_description = "A poster declaring [wanted_name] to be a dangerous individual, wanted by security. Report any sightings to security immediately."
						var/list/crimes = active2.fields[DATACORE_CRIMES]
						if(length(crimes))
							default_description += "\n[wanted_name] is wanted for the following crimes:\n"
							for(var/datum/data/crime/c in active2.fields[DATACORE_CRIMES])
								default_description += "\n[c.crimeName]\n"
								default_description += "[c.crimeDetails]\n"

						var/headerText = tgui_input_text(usr, "Enter a poster heading", "Print Wanted Poster", "WANTED", 7)

						var/info = tgui_input_text(usr, "Input a description for the poster", "Print Wanted Poster", default_description)
						if(info)
							playsound(loc, 'sound/items/poster_being_created.ogg', 100, TRUE)
							printing = 1
							sleep(30)
							if((istype(active1, /datum/data/record) && SSdatacore.get_records(DATACORE_RECORDS_STATION).Find(active1)))//make sure the record still exists.
								var/obj/item/photo/photo = active1.get_front_photo()
								new /obj/item/poster/wanted(loc, photo.picture.picture_image, wanted_name, info, headerText)
							printing = 0
			if("Print Missing")
				if(!( printing ))
					var/missing_name = tgui_input_text(usr, "Enter an alias for the missing person", "Print Missing Persons Poster", active1.fields[DATACORE_NAME])
					if(missing_name)
						var/default_description = "A poster declaring [missing_name] to be a missing individual, missed by Nanotrasen. Report any sightings to security immediately."

						var/headerText = tgui_input_text(usr, "Enter a poster heading", "Print Missing Persons Poster", "MISSING", 7)

						var/info = tgui_input_text(usr, "Input a description for the poster", "Print Missing Persons Poster", default_description)
						if(info)
							playsound(loc, 'sound/items/poster_being_created.ogg', 100, TRUE)
							printing = 1
							sleep(30)
							if((istype(active1, /datum/data/record) && SSdatacore.get_records(DATACORE_RECORDS_STATION).Find(active1)))//make sure the record still exists.
								var/obj/item/photo/photo = active1.get_front_photo()
								new /obj/item/poster/wanted/missing(loc, photo.picture.picture_image, missing_name, info, headerText)
							printing = 0

//RECORD DELETE
			if("Delete All Records")
				temp = ""
				temp += "Are you sure you wish to delete all Security records?<br>"
				temp += "<a href='?src=[REF(src)];choice=Purge All Records'>Yes</a><br>"
				temp += "<a href='?src=[REF(src)];choice=Clear Screen'>No</a>"

			if("Purge All Records")
				investigate_log("[key_name(usr)] has purged all the security records.", INVESTIGATE_RECORDS)
				SSdatacore.wipe_records(DATACORE_RECORDS_SECURITY)
				temp = "All Security records deleted."

			if("Add Entry")
				if(!( istype(active2, /datum/data/record) ))
					return
				var/a2 = active2
				var/t1 = tgui_input_text(usr, "Add a comment", "Security Records")
				if(!canUseSecurityRecordsConsole(usr, t1, null, a2))
					return
				var/counter = 1
				while(active2.fields["com_[counter]"])
					counter++
				active2.fields["com_[counter]"] = "Made by [src.authenticated] ([src.rank]) on [stationtime2text()] [stationdate2text()]<BR>[t1]"

				investigate_log("[key_name(usr)] created a new comment for [active2.fields[DATACORE_NAME]]: [html_encode(t1)].", INVESTIGATE_RECORDS)

			if("Delete Record (ALL)")
				if(active1)
					temp = "<h5>Are you sure you wish to delete the record (ALL)?</h5>"
					temp += "<a href='?src=[REF(src)];choice=Delete Record (ALL) Execute'>Yes</a><br>"
					temp += "<a href='?src=[REF(src)];choice=Clear Screen'>No</a>"

			if("Delete Record (Security)")
				if(active2)
					temp = "<h5>Are you sure you wish to delete the record (Security Portion Only)?</h5>"
					temp += "<a href='?src=[REF(src)];choice=Delete Record (Security) Execute'>Yes</a><br>"
					temp += "<a href='?src=[REF(src)];choice=Clear Screen'>No</a>"

			if("Delete Entry")
				if((istype(active2, /datum/data/record) && active2.fields["com_[href_list["del_c"]]"]))
					active2.fields["com_[href_list["del_c"]]"] = "<B>Deleted</B>"
					investigate_log("[key_name(usr)] deleted a record entry: [active2.fields[DATACORE_NAME]].", INVESTIGATE_RECORDS)
//RECORD CREATE
			if("New Record (Security)")
				if((istype(active1, /datum/data/record) && !(istype(active2, /datum/data/record))))
					var/datum/data/record/security/R = new /datum/data/record/security()
					R.fields[DATACORE_NAME] = active1.fields[DATACORE_NAME]
					R.fields[DATACORE_ID] = active1.fields[DATACORE_ID]
					R.name = "Security Record #[R.fields[DATACORE_ID]]"
					R.set_criminal_status(CRIMINAL_NONE)
					R.fields[DATACORE_CRIMES] = list()
					R.fields[DATACORE_NOTES] = "No notes."
					SSdatacore.inject_record(R, DATACORE_RECORDS_SECURITY)
					active2 = R
					screen = 3
					investigate_log("[key_name(usr)] created a new security record.", INVESTIGATE_RECORDS)

			if("New Record (General)")
				//General Record
				var/datum/data/record/general/G = new /datum/data/record/general()
				G.fields[DATACORE_NAME] = "New Record"
				G.fields[DATACORE_ID] = "[num2hex(rand(1, 1.6777215E7), 6)]"
				G.fields[DATACORE_RANK] = "Unassigned"
				G.fields[DATACORE_TRIM] = "Unassigned"
				G.fields[DATACORE_INITIAL_RANK] = "Unassigned"
				G.fields[DATACORE_GENDER] = "Male"
				G.fields[DATACORE_AGE] = "Unknown"
				G.fields[DATACORE_SPECIES] = "Human"
				G.fields["photo_front"] = new /icon()
				G.fields["photo_side"] = new /icon()
				G.fields[DATACORE_FINGERPRINT] = "?????"
				G.fields[DATACORE_PHYSICAL_HEALTH] = "Active"
				G.fields[DATACORE_MENTAL_HEALTH] = "Stable"
				SSdatacore.inject_record(G, DATACORE_RECORDS_STATION)
				active1 = G

				//Security Record
				var/datum/data/record/security/R = new /datum/data/record/security()
				R.fields[DATACORE_NAME] = active1.fields[DATACORE_NAME]
				R.fields[DATACORE_ID] = active1.fields[DATACORE_ID]
				R.name = "Security Record #[R.fields[DATACORE_ID]]"
				R.fields[DATACORE_CRIMINAL_STATUS] = CRIMINAL_NONE
				R.fields[DATACORE_CRIMES] = list()
				R.fields[DATACORE_NOTES] = "No notes."
				SSdatacore.inject_record(R, DATACORE_RECORDS_SECURITY)
				active2 = R

				//Medical Record
				var/datum/data/record/medical/M = new /datum/data/record/medical()
				M.fields[DATACORE_ID] = active1.fields[DATACORE_ID]
				M.fields[DATACORE_NAME] = active1.fields[DATACORE_NAME]
				M.fields[DATACORE_BLOOD_TYPE] = "?"
				M.fields[DATACORE_BLOOD_DNA] = "?????"
				M.fields[DATACORE_DISABILITIES] = "None"
				M.fields[DATACORE_DISABILITIES_DETAILS] = "No disabilities have been declared."
				M.fields["alg"] = "None"
				M.fields["alg_d"] = "No allergies have been detected in this patient."
				M.fields[DATACORE_DISEASES] = "None"
				M.fields[DATACORE_DISEASES_DETAILS] = "No diseases have been diagnosed at the moment."
				M.fields[DATACORE_NOTES] = "No notes."
				SSdatacore.inject_record(M, DATACORE_RECORDS_MEDICAL)

				investigate_log("[key_name(usr)] created a new record of each type.", INVESTIGATE_RECORDS)



//FIELD FUNCTIONS
			if("Edit Field")
				var/a1 = active1
				var/a2 = active2

				switch(href_list["field"])
					if("name")
						if(istype(active1, /datum/data/record) || istype(active2, /datum/data/record))
							var/t1 = tgui_input_text(usr, "Input a name", "Security Records", active1.fields[DATACORE_NAME])
							if(!canUseSecurityRecordsConsole(usr, t1, a1))
								return
							if(istype(active1, /datum/data/record))
								investigate_log("[key_name(usr)] updated [active1.fields[DATACORE_NAME]]'s record: Var: name | Old value:[active1.fields[DATACORE_NAME]] | New value: [t1].", INVESTIGATE_RECORDS)
								active1.fields[DATACORE_NAME] = t1

							if(istype(active2, /datum/data/record))
								investigate_log("[key_name(usr)] updated [active2.fields[DATACORE_NAME]]'s record: Var: name | Old value:[active2.fields[DATACORE_NAME]] | New value: [t1].", INVESTIGATE_RECORDS)
								active2.fields[DATACORE_NAME] = t1

					if("id")
						if(istype(active2, /datum/data/record) || istype(active1, /datum/data/record))
							var/t1 = tgui_input_text(usr, "Input an id", "Security Records", active1.fields[DATACORE_ID])
							if(!canUseSecurityRecordsConsole(usr, t1, a1))
								return
							if(istype(active1, /datum/data/record))
								investigate_log("[key_name(usr)] updated [active1.fields[DATACORE_NAME]]'s record: Var: id | Old value:[active1.fields[DATACORE_ID]] | New value: [t1].", INVESTIGATE_RECORDS)
								active1.fields[DATACORE_ID] = t1

							if(istype(active2, /datum/data/record))
								investigate_log("[key_name(usr)] updated [active2.fields[DATACORE_NAME]]'s record: Var: id | Old value:[active2.fields[DATACORE_ID]] | New value: [t1].", INVESTIGATE_RECORDS)
								active2.fields[DATACORE_ID] = t1

					if("fingerprint")
						if(istype(active1, /datum/data/record))
							var/t1 = tgui_input_text(usr, "Input a fingerprint hash", "Security Records", active1.fields[DATACORE_FINGERPRINT])
							if(!canUseSecurityRecordsConsole(usr, t1, a1))
								return

							investigate_log("[key_name(usr)] updated [active1.fields[DATACORE_NAME]]'s record: Var: fingerprint | Old value:[active1.fields[DATACORE_FINGERPRINT]] | New value: [t1].", INVESTIGATE_RECORDS)
							active1.fields[DATACORE_FINGERPRINT] = t1


					if("gender")
						if(istype(active1, /datum/data/record))
							var/new_gender
							if(active1.fields[DATACORE_GENDER] == "Male")
								new_gender = "Female"
							else if(active1.fields[DATACORE_GENDER] == "Female")
								new_gender = "Other"
							else
								new_gender = "Male"

							investigate_log("[key_name(usr)] updated [active1.fields[DATACORE_NAME]]'s record: Var: gender | Old value:[active1.fields[DATACORE_GENDER]] | New value: [new_gender].", INVESTIGATE_RECORDS)
							active1.fields[DATACORE_GENDER] = new_gender

					if("age")
						if(istype(active1, /datum/data/record))
							var/t1 = tgui_input_number(usr, "Input age", "Security records", active1.fields[DATACORE_AGE], AGE_MAX, AGE_MIN)
							if (!t1)
								return
							if(!canUseSecurityRecordsConsole(usr, "age", a1))
								return

							investigate_log("[key_name(usr)] updated [active1.fields[DATACORE_NAME]]'s record: Var: age | Old value:[active1.fields[DATACORE_AGE]] | New value: [t1].", INVESTIGATE_RECORDS)
							active1.fields[DATACORE_AGE] = t1

					if("species")
						if(istype(active1, /datum/data/record))
							var/t1 = tgui_input_list(usr, "Select a species", "Species Selection", get_selectable_species())
							if(isnull(t1))
								return
							if(!canUseSecurityRecordsConsole(usr, t1, a1))
								return
							investigate_log("[key_name(usr)] updated [active1.fields[DATACORE_NAME]]'s record: Var: species | Old value:[active1.fields[DATACORE_SPECIES]] | New value: [t1].", INVESTIGATE_RECORDS)
							active1.fields[DATACORE_SPECIES] = t1

					if("show_photo_front")
						if(active1)
							var/front_photo = active1.get_front_photo()
							if(istype(front_photo, /obj/item/photo))
								var/obj/item/photo/photo = front_photo
								photo.show(usr)

					if("upd_photo_front")
						var/obj/item/photo/photo = get_photo(usr)
						if(photo)
							qdel(active1.fields["photo_front"])
							//Lets center it to a 32x32.
							var/icon/I = photo.picture.picture_image
							var/w = I.Width()
							var/h = I.Height()
							var/dw = w - 32
							var/dh = w - 32
							I.Crop(dw/2, dh/2, w - dw/2, h - dh/2)
							active1.fields["photo_front"] = photo
							investigate_log("[key_name(usr)] updated [active1.fields[DATACORE_NAME]]'s front photo.", INVESTIGATE_RECORDS)

					if("print_photo_front")
						if(active1)
							var/front_photo = active1.get_front_photo()
							if(istype(front_photo, /obj/item/photo))
								var/obj/item/photo/photo_front = front_photo
								print_photo(photo_front.picture.picture_image, active1.fields[DATACORE_NAME])

					if("show_photo_side")
						if(active1)
							var/side_photo = active1.get_side_photo()
							if(istype(side_photo, /obj/item/photo))
								var/obj/item/photo/photo = side_photo
								photo.show(usr)

					if("upd_photo_side")
						var/obj/item/photo/photo = get_photo(usr)
						if(photo)
							qdel(active1.fields["photo_side"])
							//Lets center it to a 32x32.
							var/icon/I = photo.picture.picture_image
							var/w = I.Width()
							var/h = I.Height()
							var/dw = w - 32
							var/dh = w - 32
							I.Crop(dw/2, dh/2, w - dw/2, h - dh/2)
							active1.fields["photo_side"] = photo
							investigate_log("[key_name(usr)] updated [active1.fields[DATACORE_NAME]]'s front photo.", INVESTIGATE_RECORDS)

					if("print_photo_side")
						if(active1)
							var/side_photo = active1.get_side_photo()
							if(istype(side_photo, /obj/item/photo))
								var/obj/item/photo/photo_side = side_photo
								print_photo(photo_side.picture.picture_image, active1.fields[DATACORE_NAME])

					if("crim_add")
						if(!istype(active1, /datum/data/record/security))
							return

						var/t1 = tgui_input_text(usr, "Input crime names", "Security Records")
						var/t2 = tgui_input_text(usr, "Input crime details", "Security Records")
						if(!canUseSecurityRecordsConsole(usr, t1, null, a2))
							return

						var/datum/data/record/security/security_record = active1
						var/crime = SSdatacore.new_crime_entry(t1, t2, authenticated, stationtime2text())
						security_record.add_crime(crime)

						investigate_log("New Crime: <strong>[t1]</strong>: [t2] | Added to [active1.fields[DATACORE_NAME]] by [key_name(usr)]", INVESTIGATE_RECORDS)

					if("crim_delete")
						if(!istype(active1, /datum/data/record/security) || !href_list["cdataid"])
							return

						if(!canUseSecurityRecordsConsole(usr, "delete", null, a2))
							return

						var/crime_name
						var/crime_details
						var/datum/data/record/security/security_record = active1
						var/list/crimes = security_record.fields[DATACORE_CRIMES]
						for(var/datum/data/crime/crime in crimes)
							if(crime.dataId == text2num(href_list["cdataid"]))
								crime_name = crime.crimeName
								crime_details = crime.crimeDetails
								break

						investigate_log("[key_name(usr)] deleted a crime from [active1.fields[DATACORE_NAME]]: ([crime_name]) | Details: [crime_details]", INVESTIGATE_RECORDS)
						security_record.remove_crime(href_list["cdataid"])

					if("add_details")
						if(!istype(active1, /datum/data/record/security) || !href_list["cdataid"])
							return


						var/t1 = tgui_input_text(usr, "Input crime details", "Security Records")
						if(!canUseSecurityRecordsConsole(usr, t1, null, a2))
							return

						var/datum/data/record/security/security_record = active1
						security_record.add_crime_details(href_list["cdataid"], t1)

						investigate_log("New Crime details: [t1] | Added to [active1.fields[DATACORE_NAME]] by [key_name(usr)]", INVESTIGATE_RECORDS)

					if("citation_add")
						if(!istype(active1, /datum/data/record/security))
							return

						var/t1 = tgui_input_text(usr, "Input citation crime", "Security Records")
						if(!t1)
							return

						var/maxFine = CONFIG_GET(number/maxfine)
						var/fine = tgui_input_number(usr, "Input citation fine", "Security Records", 50, maxFine)
						if (!fine || QDELETED(usr) || QDELETED(src) || !canUseSecurityRecordsConsole(usr, t1, null, a2))
							return

						var/datum/data/crime/crime = SSdatacore.new_crime_entry(t1, "", authenticated, stationtime2text(), fine)
						var/obj/machinery/announcement_system/announcer = pick(GLOB.announcement_systems)
						if(announcer)
							announcer.notify_citation(active1.fields[DATACORE_NAME], t1, fine)

						var/datum/data/record/security/security_record = active1
						security_record.add_citation(crime)

						investigate_log("New Citation: <strong>[t1]</strong> Fine: [fine] | Added to [active1.fields[DATACORE_NAME]] by [key_name(usr)]", INVESTIGATE_RECORDS)
						SSblackbox.ReportCitation(crime.dataId, usr.ckey, usr.real_name, active1.fields[DATACORE_NAME], t1, fine)

					if("citation_delete")
						if(!istype(active1, /datum/data/record/security) || !href_list["cdataid"])
							return

						if(!canUseSecurityRecordsConsole(usr, "delete", null, a2))
							return

						var/crime_name = ""
						var/crime_details = ""
						var/list/crimes = active1.fields[DATACORE_CITATIONS]
						for(var/datum/data/crime/crime in crimes)
							if(crime.dataId == text2num(href_list["cdataid"]))
								crime_name = crime.crimeName
								crime_details = crime.crimeDetails
								break

						investigate_log("[key_name(usr)] deleted a citation from [active1.fields[DATACORE_NAME]]: ([crime_name]) | Details: [crime_details]", INVESTIGATE_RECORDS)
						var/datum/data/record/security/security_record = active1
						security_record.remove_citation(href_list["cdataid"])

					if("notes")
						if(istype(active2, /datum/data/record))
							var/t1 = tgui_input_text(usr, "Please summarize notes", "Security Records", active2.fields[DATACORE_NOTES])
							if(!canUseSecurityRecordsConsole(usr, t1, null, a2))
								return

							active2.fields[DATACORE_NOTES] = t1
							investigate_log("[key_name(usr)] updated [active2.fields[DATACORE_NAME]]'s notes to: [t1]", INVESTIGATE_RECORDS)

					if("criminal")
						if(istype(active2, /datum/data/record))
							temp = "<h5>Criminal Status:</h5>"
							temp += "<ul>"
							temp += "<li><a href='?src=[REF(src)];choice=Change Criminal Status;criminal2=none'>None</a></li>"
							temp += "<li><a href='?src=[REF(src)];choice=Change Criminal Status;criminal2=arrest'>*Arrest*</a></li>"
							temp += "<li><a href='?src=[REF(src)];choice=Change Criminal Status;criminal2=incarcerated'>Incarcerated</a></li>"
							temp += "<li><a href='?src=[REF(src)];choice=Change Criminal Status;criminal2=suspected'>Suspected</a></li>"
							temp += "<li><a href='?src=[REF(src)];choice=Change Criminal Status;criminal2=paroled'>Paroled</a></li>"
							temp += "<li><a href='?src=[REF(src)];choice=Change Criminal Status;criminal2=released'>Discharged</a></li>"
							temp += "</ul>"
					if("rank")
						var/list/L = list(
							JOB_CAPTAIN,
							JOB_HEAD_OF_PERSONNEL,
							JOB_AI,
							JOB_CENTCOM,
						)
						//This was so silly before the change. Now it actually works without beating your head against the keyboard. /N
						if((istype(active1, /datum/data/record) && L.Find(rank)))
							temp = "<h5>Rank:</h5>"
							temp += "<ul>"
							var/list/station_job_templates = SSid_access.station_job_templates
							for(var/path in station_job_templates)
								var/rank = station_job_templates[path]
								temp += "<li><a href='?src=[REF(src)];choice=Change Rank;rank=[path]'>[rank]</a></li>"
							temp += "</ul>"
						else
							tgui_alert(usr, "You do not have the required rank to do this!")
//TEMPORARY MENU FUNCTIONS
			else//To properly clear as per clear screen.
				temp=null
				switch(href_list["choice"])
					if("Change Rank")
						if(active1)
							var/text = strip_html(href_list["rank"])
							var/path = text2path(text)
							if(ispath(path))
								var/rank = SSid_access.station_job_templates[path]
								if(rank)
									active1.fields[DATACORE_RANK] = rank
									active1.fields[DATACORE_TRIM] = active1.fields[DATACORE_RANK]
									investigate_log("[key_name(usr)] updated [active1.fields[DATACORE_NAME]]'s record: Var: rank | Old value:[active1.fields[DATACORE_RANK]] | New value: [rank].", INVESTIGATE_RECORDS)
								else
									message_admins("Warning: possible href exploit by [key_name(usr)] - attempted to set change a crew member rank to an invalid path: [path]")
									log_game("Warning: possible href exploit by [key_name(usr)] - attempted to set change a crew member rank to an invalid path: [path]")
							else if(!isnull(text))
								message_admins("Warning: possible href exploit by [key_name(usr)] - attempted to set change a crew member rank to an invalid value: [text]")
								log_game("Warning: possible href exploit by [key_name(usr)] - attempted to set change a crew member rank to an invalid value: [text]")

					if("Change Criminal Status")
						if(active2)
							var/datum/data/record/security/security_record = active2
							var/old_field = security_record.fields[DATACORE_CRIMINAL_STATUS]
							switch(href_list["criminal2"])
								if("none")
									security_record.set_criminal_status(CRIMINAL_NONE)
								if("arrest")
									security_record.set_criminal_status(CRIMINAL_WANTED)
								if("incarcerated")
									security_record.set_criminal_status(CRIMINAL_INCARCERATED)
								if("suspected")
									security_record.set_criminal_status( CRIMINAL_SUSPECT)
								if("paroled")
									security_record.set_criminal_status(CRIMINAL_PAROLE)
								if("released")
									security_record.set_criminal_status(CRIMINAL_DISCHARGED)

							investigate_log("[active1.fields[DATACORE_NAME]] has been set from [old_field] to [security_record.fields[DATACORE_CRIMINAL_STATUS]] by [key_name(usr)].", INVESTIGATE_RECORDS)
							for(var/mob/living/carbon/human/H as anything in GLOB.human_list)
								H.sec_hud_set_security_status()

					if("Delete Record (Security) Execute")
						investigate_log("[key_name(usr)] has deleted the security records for [active1.fields[DATACORE_NAME]].", INVESTIGATE_RECORDS)
						if(active2)
							qdel(active2)
							active2 = null

					if("Delete Record (ALL) Execute")
						if(active1)
							investigate_log("[key_name(usr)] has deleted all records for [active1.fields[DATACORE_NAME]].", INVESTIGATE_RECORDS)
							for(var/datum/data/record/R in SSdatacore.get_records(DATACORE_RECORDS_MEDICAL))
								if((R.fields[DATACORE_NAME] == active1.fields[DATACORE_NAME] || R.fields[DATACORE_ID] == active1.fields[DATACORE_ID]))
									qdel(R)
									break
							qdel(active1)
							active1 = null

						if(active2)
							qdel(active2)
							active2 = null
					else
						temp = "This function does not appear to be working at the moment. Our apologies."

	add_fingerprint(usr)
	updateUsrDialog()
	return

/obj/machinery/computer/secure_data/proc/get_photo(mob/user)
	var/obj/item/photo/P = null
	if(issilicon(user))
		var/mob/living/silicon/tempAI = user
		var/datum/picture/selection = tempAI.GetPhoto(user)
		if(selection)
			P = new(null, selection)
	else if(istype(user.get_active_held_item(), /obj/item/photo))
		P = user.get_active_held_item()
	return P

/obj/machinery/computer/secure_data/proc/print_photo(icon/temp, person_name)
	if (printing)
		return
	printing = TRUE
	sleep(20)
	var/obj/item/photo/P = new/obj/item/photo(drop_location())
	var/datum/picture/toEmbed = new(name = person_name, desc = "The photo on file for [person_name].", image = temp)
	P.set_picture(toEmbed, TRUE, TRUE)
	P.pixel_x = rand(-10, 10)
	P.pixel_y = rand(-10, 10)
	printing = FALSE

/obj/machinery/computer/secure_data/emp_act(severity)
	. = ..()

	if(machine_stat & (BROKEN|NOPOWER) || . & EMP_PROTECT_SELF)
		return

	for(var/datum/data/record/security/R in SSdatacore.get_records(DATACORE_RECORDS_SECURITY))
		if(prob(10/severity))
			switch(rand(1,8))
				if(1)
					if(prob(10))
						R.fields[DATACORE_NAME] = "[pick(lizard_name(MALE),lizard_name(FEMALE))]"
					else
						R.fields[DATACORE_NAME] = "[pick(pick(GLOB.first_names_male), pick(GLOB.first_names_female))] [pick(GLOB.last_names)]"
				if(2)
					R.fields[DATACORE_GENDER] = pick("Male", "Female", "Other")
				if(3)
					R.fields[DATACORE_AGE] = rand(5, 85)
				if(4)
					R.set_criminal_status(pick(CRIMINAL_NONE, CRIMINAL_WANTED, CRIMINAL_INCARCERATED, CRIMINAL_SUSPECT, CRIMINAL_PAROLE, CRIMINAL_DISCHARGED))
				if(5)
					R.fields[DATACORE_PHYSICAL_HEALTH] = pick("*Unconscious*", "Active", "Physically Unfit")
				if(6)
					R.fields[DATACORE_MENTAL_HEALTH] = pick("*Insane*", "*Unstable*", "*Watch*", "Stable")
				if(7)
					R.fields[DATACORE_SPECIES] = pick(get_selectable_species())
				if(8)
					var/datum/data/record/G = pick(SSdatacore.get_records(DATACORE_RECORDS_STATION))
					R.fields["photo_front"] = G.fields["photo_front"]
					R.fields["photo_side"] = G.fields["photo_side"]
			continue

		else if(prob(1))
			qdel(R)
			continue

/obj/machinery/computer/secure_data/proc/canUseSecurityRecordsConsole(mob/user, message1 = 0, record1, record2)
	if(user && authenticated)
		if(user.canUseTopic(src, USE_CLOSE|USE_SILICON_REACH))
			if(!trim(message1))
				return FALSE
			if(!record1 || record1 == active1)
				if(!record2 || record2 == active2)
					return TRUE
	return FALSE
