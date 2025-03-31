

/obj/machinery/computer/med_data//TODO:SANITY
	name = "medical records console"
	desc = "This can be used to check medical records."
	icon_screen = "medcomp"
	icon_keyboard = "med_key"
	req_one_access = list(ACCESS_MEDICAL, ACCESS_FORENSICS)
	circuit = /obj/item/circuitboard/computer/med_data
	light_color = LIGHT_COLOR_BLUE
	var/rank = null
	var/screen = null
	var/datum/data/record/active1
	var/datum/data/record/active2
	var/temp = null
	var/printing = null
	//Sorting Variables
	var/sortBy = "name"
	var/order = 1 // -1 = Descending - 1 = Ascending


/obj/machinery/computer/med_data/syndie
	icon_keyboard = "syndie_key"
	req_one_access = list(ACCESS_SYNDICATE)

/obj/machinery/computer/med_data/ui_interact(mob/user)
	. = ..()
	if(isliving(user))
		playsound(src, 'sound/machines/terminal_prompt_confirm.ogg', 50, FALSE)
	var/dat
	if(temp)
		dat ="<TT>[temp]</TT><BR><BR><A href='?src=[REF(src)];temp=1'>Clear Screen</A>"
	else
		if(authenticated)
			switch(screen)
				if(1)
					dat += {"
<A href='?src=[REF(src)];search=1'>Search Records</A>
<BR><A href='?src=[REF(src)];screen=2'>List Records</A>
<BR>
<BR><A href='?src=[REF(src)];screen=5'>Virus Database</A>
<BR><A href='?src=[REF(src)];screen=6'>Medbot Tracking</A>
<BR>
<BR><A href='?src=[REF(src)];screen=3'>Record Maintenance</A>
<BR><A href='?src=[REF(src)];logout=1'>{Log Out}</A><BR>
"}
				if(2)
					dat += {"
</p>
<table style="text-align:center;" cellspacing="0" width="100%">
<tr>
<th>Records:</th>
</tr>
</table>
<table style="text-align:center;" border="1" cellspacing="0" width="100%">
<tr>
<th><A href='?src=[REF(src)];choice=Sorting;sort=name'>Name</A></th>
<th><A href='?src=[REF(src)];choice=Sorting;sort=id'>ID</A></th>
<th>Fingerprints (F) | DNA UE (D)</th>
<th><A href='?src=[REF(src)];choice=Sorting;sort=bloodtype'>Blood Type</A></th>
<th>Physical Status</th>
<th>Mental Status</th>
</tr>"}


					if(!isnull(SSdatacore.get_records(DATACORE_RECORDS_STATION)))
						for(var/datum/data/record/R in sort_record(SSdatacore.get_records(DATACORE_RECORDS_STATION), sortBy, order))
							var/blood_type = ""
							var/b_dna = ""
							for(var/datum/data/record/E in SSdatacore.get_records(DATACORE_RECORDS_MEDICAL))
								if((E.fields[DATACORE_NAME] == R.fields[DATACORE_NAME] && E.fields[DATACORE_ID] == R.fields[DATACORE_ID]))
									blood_type = E.fields[DATACORE_BLOOD_TYPE]
									b_dna = E.fields[DATACORE_BLOOD_DNA]
							var/background

							if(R.fields[DATACORE_MENTAL_HEALTH] == "*Insane*" || R.fields[DATACORE_PHYSICAL_HEALTH] == "*Deceased*")
								background = "'background-color:#990000;'"
							else if(R.fields[DATACORE_PHYSICAL_HEALTH] == "*Unconscious*" || R.fields[DATACORE_MENTAL_HEALTH] == "*Unstable*")
								background = "'background-color:#CD6500;'"
							else if(R.fields[DATACORE_PHYSICAL_HEALTH] == "Physically Unfit" || R.fields[DATACORE_MENTAL_HEALTH] == "*Watch*")
								background = "'background-color:#3BB9FF;'"
							else
								background = "'background-color:#4F7529;'"

							dat += "<tr style=[background]><td><A href='?src=[REF(src)];d_rec=[R.fields[DATACORE_ID]]'>[R.fields[DATACORE_NAME]]</a></td>"
							dat += "<td>[R.fields[DATACORE_ID]]</td>"
							dat += "<td><b>F:</b> [R.fields[DATACORE_FINGERPRINT]]<BR><b>D:</b> [b_dna]</td>"
							dat += "<td>[blood_type]</td>"
							dat += "<td>[R.fields[DATACORE_PHYSICAL_HEALTH]]</td>"
							dat += "<td>[R.fields[DATACORE_MENTAL_HEALTH]]</td></tr>"

					dat += "</table><hr width='75%' />"
					dat += "<HR><A href='?src=[REF(src)];screen=1'>Back</A>"
				if(3)
					dat += "<B>Records Maintenance</B><HR>\n<A href='?src=[REF(src)];back=1'>Backup To Disk</A><BR>\n<A href='?src=[REF(src)];u_load=1'>Upload From Disk</A><BR>\n<A href='?src=[REF(src)];del_all=1'>Delete All Records</A><BR>\n<BR>\n<A href='?src=[REF(src)];screen=1'>Back</A>"
				if(4)

					dat += "<table><tr><td><b><font size='4'>Medical Record</font></b></td></tr>"
					if(active1 in SSdatacore.get_records(DATACORE_RECORDS_STATION))
						var/front_photo = active1.get_front_photo()
						if(istype(front_photo, /obj/item/photo))
							var/obj/item/photo/photo_front = front_photo
							user << browse_rsc(photo_front.picture.picture_image, "photo_front")
						var/side_photo = active1.get_side_photo()
						if(istype(side_photo, /obj/item/photo))
							var/obj/item/photo/photo_side = side_photo
							user << browse_rsc(photo_side.picture.picture_image, "photo_side")
						dat += "<tr><td>Name:</td><td>[active1.fields[DATACORE_NAME]]</td>"
						dat += "<td><a href='?src=[REF(src)];field=show_photo_front'><img src=photo_front height=96 width=96 border=4 style=\"-ms-interpolation-mode:nearest-neighbor\"></a></td>"
						dat += "<td><a href='?src=[REF(src)];field=show_photo_side'><img src=photo_side height=96 width=96 border=4 style=\"-ms-interpolation-mode:nearest-neighbor\"></a></td></tr>"
						dat += "<tr><td>ID:</td><td>[active1.fields[DATACORE_ID]]</td></tr>"
						dat += "<tr><td>Gender:</td><td><A href='?src=[REF(src)];field=gender'>&nbsp;[active1.fields[DATACORE_GENDER]]&nbsp;</A></td></tr>"
						dat += "<tr><td>Age:</td><td><A href='?src=[REF(src)];field=age'>&nbsp;[active1.fields[DATACORE_AGE]]&nbsp;</A></td></tr>"
						dat += "<tr><td>Species:</td><td><A href='?src=[REF(src)];field=species'>&nbsp;[active1.fields[DATACORE_SPECIES]]&nbsp;</A></td></tr>"
						dat += "<tr><td>Fingerprint:</td><td><A href='?src=[REF(src)];field=fingerprint'>&nbsp;[active1.fields[DATACORE_FINGERPRINT]]&nbsp;</A></td></tr>"
						dat += "<tr><td>Physical Status:</td><td><A href='?src=[REF(src)];field=p_stat'>&nbsp;[active1.fields[DATACORE_PHYSICAL_HEALTH]]&nbsp;</A></td></tr>"
						dat += "<tr><td>Mental Status:</td><td><A href='?src=[REF(src)];field=m_stat'>&nbsp;[active1.fields[DATACORE_MENTAL_HEALTH]]&nbsp;</A></td></tr>"
					else
						dat += "<tr><td>General Record Lost!</td></tr>"

					dat += "<tr><td><br><b><font size='4'>Medical Data</font></b></td></tr>"
					if(active2 in SSdatacore.get_records(DATACORE_RECORDS_MEDICAL))
						dat += "<tr><td>Blood Type:</td><td><A href='?src=[REF(src)];field=blood_type'>&nbsp;[active2.fields[DATACORE_BLOOD_TYPE]]&nbsp;</A></td></tr>"
						dat += "<tr><td>DNA:</td><td><A href='?src=[REF(src)];field=b_dna'>&nbsp;[active2.fields[DATACORE_BLOOD_DNA]]&nbsp;</A></td></tr>"
						dat += "<tr><td><br>Disabilities:</td><td><br><A href='?src=[REF(src)];field=disabilities'>&nbsp;[active2.fields[DATACORE_DISABILITIES]]&nbsp;</A></td></tr>"
						dat += "<tr><td>Details:</td><td><A href='?src=[REF(src)];field=disabilities_details'>&nbsp;[active2.fields[DATACORE_DISABILITIES_DETAILS]]&nbsp;</A></td></tr>"
						dat += "<tr><td><br>Current Diseases:</td><td><br><A href='?src=[REF(src)];field=cdi'>&nbsp;[active2.fields[DATACORE_DISEASES]]&nbsp;</A></td></tr>" //(per disease info placed in log/comment section)
						dat += "<tr><td>Details:</td><td><A href='?src=[REF(src)];field=cdi_d'>&nbsp;[active2.fields[DATACORE_DISEASES_DETAILS]]&nbsp;</A></td></tr>"
						dat += "<tr><td><br>Important Notes:</td><td><br><A href='?src=[REF(src)];field=notes'>&nbsp;[active2.fields[DATACORE_NOTES]]&nbsp;</A></td></tr>"
						dat += "<tr><td><br>Notes Cont'd:</td><td><br><A href='?src=[REF(src)];field=notes'>&nbsp;[active2.fields[DATACORE_NOTES_DETAILS]]&nbsp;</A></td></tr>"

						dat += "<tr><td><br><b><font size='4'>Comments/Log</font></b></td></tr>"
						var/counter = 1
						while(active2.fields["com_[counter]"])
							dat += "<tr><td>[active2.fields["com_[counter]"]]</td></tr><tr><td><A href='?src=[REF(src)];del_c=[counter]'>Delete Entry</A></td></tr>"
							counter++
						dat += "<tr><td><A href='?src=[REF(src)];add_c=1'>Add Entry</A></td></tr>"

						dat += "<tr><td><br><A href='?src=[REF(src)];del_r=1'>Delete Record (Medical Only)</A></td></tr>"
					else
						dat += "<tr><td>Medical Record Lost!</tr>"
						dat += "<tr><td><br><A href='?src=[REF(src)];new=1'>New Record</A></td></tr>"
					dat += "<tr><td><A href='?src=[REF(src)];print_p=1'>Print Record</A></td></tr>"
					dat += "<tr><td><A href='?src=[REF(src)];screen=2'>Back</A></td></tr>"
					dat += "</table>"
				if(5)
					dat += "<CENTER><B>Virus Database</B></CENTER>"
					for(var/Dt in typesof(/datum/pathogen/))
						var/datum/pathogen/Dis = new Dt(0)
						if(istype(Dis, /datum/pathogen/advance))
							continue // TODO (tm): Add advance diseases to the virus database which no one uses.
						if(!Dis.desc)
							continue
						dat += "<br><a href='?src=[REF(src)];vir=[Dt]'>[Dis.name]</a>"
					dat += "<br><a href='?src=[REF(src)];screen=1'>Back</a>"
				if(6)
					dat += "<center><b>Medical Robot Monitor</b></center>"
					dat += "<a href='?src=[REF(src)];screen=1'>Back</a>"
					dat += "<br><b>Medical Robots:</b>"
					var/bdat = null
					for(var/mob/living/simple_animal/bot/medbot/M in GLOB.alive_mob_list)
						if(M.z != z)
							continue //only find medibots on the same z-level as the computer
						var/turf/bl = get_turf(M)
						if(bl) //if it can't find a turf for the medibot, then it probably shouldn't be showing up
							bdat += "[M.name] - <b>\[[bl.x],[bl.y]\]</b> - [M.bot_mode_flags & BOT_MODE_ON ? "Online" : "Offline"]<br>"
					if(!bdat)
						dat += "<br><center>None detected</center>"
					else
						dat += "<br>[bdat]"

				else
		else
			dat += "<A href='?src=[REF(src)];login=1'>{Log In}</A>"
	var/datum/browser/popup = new(user, "med_rec", "Medical Records Console", 600, 400)
	popup.set_content(dat)
	popup.open()

/obj/machinery/computer/med_data/Topic(href, href_list)
	. = ..()
	if(.)
		return .
	if(!(active1 in SSdatacore.get_records(DATACORE_RECORDS_STATION)))
		active1 = null
	if(!(active2 in SSdatacore.get_records(DATACORE_RECORDS_MEDICAL)))
		active2 = null

	if(usr.contents.Find(src) || (in_range(src, usr) && isturf(loc)) || issilicon(usr) || isAdminGhostAI(usr))
		usr.set_machine(src)
		if(href_list["temp"])
			temp = null
		else if(href_list["logout"])
			authenticated = null
			screen = null
			active1 = null
			active2 = null
			playsound(src, 'sound/machines/terminal_off.ogg', 50, FALSE)
		else if(href_list["choice"])
			// SORTING!
			if(href_list["choice"] == "Sorting")
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
		else if(href_list["login"])
			var/obj/item/card/id/I
			if(isliving(usr))
				var/mob/living/L = usr
				I = L.get_idcard(TRUE)
			if(issilicon(usr))
				active1 = null
				active2 = null
				authenticated = 1
				rank = "AI"
				screen = 1
			else if(isAdminGhostAI(usr))
				active1 = null
				active2 = null
				authenticated = 1
				rank = "Central Command"
				screen = 1
			else if(istype(I) && check_access(I))
				active1 = null
				active2 = null
				authenticated = I.registered_name
				rank = I.assignment
				screen = 1
			else
				to_chat(usr, span_danger("Unauthorized access."))
			playsound(src, 'sound/machines/terminal_on.ogg', 50, FALSE)
		if(authenticated)
			if(href_list["screen"])
				screen = text2num(href_list["screen"])
				if(screen < 1)
					screen = 1

				active1 = null
				active2 = null

			else if(href_list["vir"])
				var/type = text2path(href_list["vir"] || "")
				if(!ispath(type, /datum/pathogen))
					return

				var/datum/pathogen/disease = new type(0)
				var/applicable_mob_names = ""
				for(var/mob/viable_mob as anything in disease.viable_mobtypes)
					applicable_mob_names += " [initial(viable_mob.name)];"
				temp = {"<b>Name:</b> [disease.name]
<BR><b>Number of stages:</b> [disease.max_stages]
<BR><b>Spread:</b> [disease.spread_text] Transmission
<BR><b>Possible Cure:</b> [(disease.cure_text||"none")]
<BR><b>Affected Lifeforms:</b>[applicable_mob_names]
<BR>
<BR><b>Notes:</b> [disease.desc]
<BR>
<BR><b>Severity:</b> [disease.severity]"}

			else if(href_list["del_all"])
				temp = "Are you sure you wish to delete all records?<br>\n\t<A href='?src=[REF(src)];temp=1;del_all2=1'>Yes</A><br>\n\t<A href='?src=[REF(src)];temp=1'>No</A><br>"

			else if(href_list["del_all2"])
				investigate_log("[key_name(usr)] has deleted all medical records.", INVESTIGATE_RECORDS)
				SSdatacore.wipe_records(DATACORE_RECORDS_MEDICAL)
				temp = "All records deleted."

			else if(href_list["field"])
				var/a1 = active1
				var/a2 = active2
				switch(href_list["field"])
					if("fingerprint")
						if(active1)
							var/t1 = stripped_input("Please input fingerprint hash:", "Med. records", active1.fields[DATACORE_FINGERPRINT], null)
							if(!canUseMedicalRecordsConsole(usr, t1, a1))
								return
							active1.fields[DATACORE_FINGERPRINT] = t1
					if("gender")
						if(active1)
							if(active1.fields[DATACORE_GENDER] == "Male")
								active1.fields[DATACORE_GENDER] = "Female"
							else if(active1.fields[DATACORE_GENDER] == "Female")
								active1.fields[DATACORE_GENDER] = "Other"
							else
								active1.fields[DATACORE_GENDER] = "Male"
					if("age")
						if(active1)
							var/t1 = input("Please input age:", "Med. records", active1.fields[DATACORE_AGE], null)  as num
							if(!canUseMedicalRecordsConsole(usr, t1, a1))
								return
							active1.fields[DATACORE_AGE] = t1
					if("species")
						if(active1)
							var/t1 = stripped_input("Please input species name", "Med. records", active1.fields[DATACORE_SPECIES], null)
							if(!canUseMedicalRecordsConsole(usr, t1, a1))
								return
							active1.fields[DATACORE_SPECIES] = t1
					if(DATACORE_DISABILITIES)
						if(active2)
							var/t1 = stripped_input("Please input disabilities list:", "Med. records", active2.fields["disabilities"], null)
							if(!canUseMedicalRecordsConsole(usr, t1, null, a2))
								return
							active2.fields[DATACORE_DISABILITIES] = t1
					if(DATACORE_DISABILITIES_DETAILS)
						if(active2)
							var/t1 = stripped_input("Please summarize dis.:", "Med. records", active2.fields["disabilities_details"], null)
							if(!canUseMedicalRecordsConsole(usr, t1, null, a2))
								return
							active2.fields[DATACORE_DISABILITIES_DETAILS] = t1
					if("alg")
						if(active2)
							var/t1 = stripped_input("Please state allergies:", "Med. records", active2.fields["alg"], null)
							if(!canUseMedicalRecordsConsole(usr, t1, null, a2))
								return
							active2.fields["alg"] = t1
					if("alg_d")
						if(active2)
							var/t1 = stripped_input("Please summarize allergies:", "Med. records", active2.fields["alg_d"], null)
							if(!canUseMedicalRecordsConsole(usr, t1, null, a2))
								return
							active2.fields["alg_d"] = t1
					if("cdi")
						if(active2)
							var/t1 = stripped_input("Please state diseases:", "Med. records", active2.fields[DATACORE_DISEASES], null)
							if(!canUseMedicalRecordsConsole(usr, t1, null, a2))
								return
							active2.fields[DATACORE_DISEASES] = t1
					if("cdi_d")
						if(active2)
							var/t1 = stripped_input("Please summarize diseases:", "Med. records", active2.fields[DATACORE_DISEASES_DETAILS], null)
							if(!canUseMedicalRecordsConsole(usr, t1, null, a2))
								return
							active2.fields[DATACORE_DISEASES_DETAILS] = t1
					if("notes")
						if(active2)
							var/t1 = stripped_input("Please summarize notes:", "Med. records", active2.fields[DATACORE_NOTES], null)
							if(!canUseMedicalRecordsConsole(usr, t1, null, a2))
								return
							active2.fields[DATACORE_NOTES] = t1
					if("p_stat")
						if(active1)
							temp = "<B>Physical Condition:</B><BR>\n\t<A href='?src=[REF(src)];temp=1;p_stat=deceased'>*Deceased*</A><BR>\n\t<A href='?src=[REF(src)];temp=1;p_stat=unconscious'>*Unconscious*</A><BR>\n\t<A href='?src=[REF(src)];temp=1;p_stat=active'>Active</A><BR>\n\t<A href='?src=[REF(src)];temp=1;p_stat=unfit'>Physically Unfit</A><BR>"
					if("m_stat")
						if(active1)
							temp = "<B>Mental Condition:</B><BR>\n\t<A href='?src=[REF(src)];temp=1;m_stat=insane'>*Insane*</A><BR>\n\t<A href='?src=[REF(src)];temp=1;m_stat=unstable'>*Unstable*</A><BR>\n\t<A href='?src=[REF(src)];temp=1;m_stat=watch'>*Watch*</A><BR>\n\t<A href='?src=[REF(src)];temp=1;m_stat=stable'>Stable</A><BR>"
					if("blood_type")
						if(active2)
							temp = "<B>Blood Type:</B><BR>\n\t<A href='?src=[REF(src)];temp=1;blood_type=an'>A-</A> <A href='?src=[REF(src)];temp=1;blood_type=ap'>A+</A><BR>\n\t<A href='?src=[REF(src)];temp=1;blood_type=bn'>B-</A> <A href='?src=[REF(src)];temp=1;blood_type=bp'>B+</A><BR>\n\t<A href='?src=[REF(src)];temp=1;blood_type=abn'>AB-</A> <A href='?src=[REF(src)];temp=1;blood_type=abp'>AB+</A><BR>\n\t<A href='?src=[REF(src)];temp=1;blood_type=on'>O-</A> <A href='?src=[REF(src)];temp=1;blood_type=op'>O+</A><BR>"
					if("b_dna")
						if(active2)
							var/t1 = stripped_input("Please input DNA hash:", "Med. records", active2.fields[DATACORE_BLOOD_DNA], null)
							if(!canUseMedicalRecordsConsole(usr, t1, null, a2))
								return
							active2.fields[DATACORE_BLOOD_DNA] = t1
					if("show_photo_front")
						if(active1)
							var/front_photo = active1.get_front_photo()
							if(istype(front_photo, /obj/item/photo))
								var/obj/item/photo/photo = front_photo
								photo.show(usr)
					if("show_photo_side")
						if(active1)
							var/side_photo = active1.get_side_photo()
							if(istype(side_photo, /obj/item/photo))
								var/obj/item/photo/photo = side_photo
								photo.show(usr)
					else

			else if(href_list["p_stat"])
				if(active1)
					switch(href_list["p_stat"])
						if("deceased")
							active1.fields[DATACORE_PHYSICAL_HEALTH] = "*Deceased*"
						if("unconscious")
							active1.fields[DATACORE_PHYSICAL_HEALTH] = "*Unconscious*"
						if("active")
							active1.fields[DATACORE_PHYSICAL_HEALTH] = "Active"
						if("unfit")
							active1.fields[DATACORE_PHYSICAL_HEALTH] = "Physically Unfit"

			else if(href_list["m_stat"])
				if(active1)
					switch(href_list["m_stat"])
						if("insane")
							active1.fields[DATACORE_MENTAL_HEALTH] = "*Insane*"
						if("unstable")
							active1.fields[DATACORE_MENTAL_HEALTH] = "*Unstable*"
						if("watch")
							active1.fields[DATACORE_MENTAL_HEALTH] = "*Watch*"
						if("stable")
							active1.fields[DATACORE_MENTAL_HEALTH] = "Stable"


			else if(href_list["blood_type"])
				if(active2)
					switch(href_list["blood_type"])
						if("an")
							active2.fields[DATACORE_BLOOD_TYPE] = "A-"
						if("bn")
							active2.fields[DATACORE_BLOOD_TYPE] = "B-"
						if("abn")
							active2.fields[DATACORE_BLOOD_TYPE] = "AB-"
						if("on")
							active2.fields[DATACORE_BLOOD_TYPE] = "O-"
						if("ap")
							active2.fields[DATACORE_BLOOD_TYPE] = "A+"
						if("bp")
							active2.fields[DATACORE_BLOOD_TYPE] = "B+"
						if("abp")
							active2.fields[DATACORE_BLOOD_TYPE] = "AB+"
						if("op")
							active2.fields[DATACORE_BLOOD_TYPE] = "O+"


			else if(href_list["del_r"])
				if(active2)
					temp = "Are you sure you wish to delete the record (Medical Portion Only)?<br>\n\t<A href='?src=[REF(src)];temp=1;del_r2=1'>Yes</A><br>\n\t<A href='?src=[REF(src)];temp=1'>No</A><br>"

			else if(href_list["del_r2"])
				investigate_log("[key_name(usr)] has deleted the medical records for [active1.fields[DATACORE_NAME]].", INVESTIGATE_RECORDS)
				if(active2)
					qdel(active2)
					active2 = null

			else if(href_list["d_rec"])
				active1 = SSdatacore.find_record("id", href_list["d_rec"], DATACORE_RECORDS_STATION)
				if(active1)
					active2 = SSdatacore.find_record("id", href_list["d_rec"], DATACORE_RECORDS_MEDICAL)
				if(!active2)
					active1 = null
				screen = 4

			else if(href_list["new"])
				if((istype(active1, /datum/data/record) && !( istype(active2, /datum/data/record) )))
					var/datum/data/record/R = new /datum/data/record/medical()

					R.fields[DATACORE_ID] = active1.fields[DATACORE_ID]
					R.name = "Medical Record #[R.fields[DATACORE_ID]]"

					R.fields[DATACORE_NAME] = active1.fields[DATACORE_NAME]
					R.fields[DATACORE_BLOOD_TYPE] = "Unknown"
					R.fields[DATACORE_BLOOD_DNA] = "Unknown"
					R.fields[DATACORE_DISABILITIES] = "None"
					R.fields[DATACORE_DISABILITIES_DETAILS] = "No disabilities have been diagnosed."
					R.fields["alg"] = "None"
					R.fields["alg_d"] = "No allergies have been detected in this patient."
					R.fields[DATACORE_DISEASES] = "None"
					R.fields[DATACORE_DISEASES_DETAILS] = "No diseases have been diagnosed at the moment."
					R.fields[DATACORE_NOTES] = "No notes."
					active2 = R
					screen = 4

					SSdatacore.inject_record(R, DATACORE_RECORDS_MEDICAL)

			else if(href_list["add_c"])
				if(!(active2 in SSdatacore.get_records(DATACORE_RECORDS_MEDICAL)))
					return
				var/a2 = active2
				var/t1 = stripped_multiline_input("Add Comment:", "Med. records", null, null)
				if(!canUseMedicalRecordsConsole(usr, t1, null, a2))
					return
				var/counter = 1
				while(active2.fields["com_[counter]"])
					counter++
				active2.fields["com_[counter]"] = "Made by [authenticated] ([rank]) on [stationtime2text()] [time2text(world.realtime, "MMM DD")], [CURRENT_STATION_YEAR]<BR>[t1]"

			else if(href_list["del_c"])
				if((istype(active2, /datum/data/record) && active2.fields["com_[href_list["del_c"]]"]))
					active2.fields["com_[href_list["del_c"]]"] = "<B>Deleted</B>"

			else if(href_list["search"])
				var/t1 = stripped_input(usr, "Search String: (Name, DNA, or ID)", "Med. records")
				if(!canUseMedicalRecordsConsole(usr, t1))
					return
				active1 = null
				active2 = null
				t1 = lowertext(t1)
				for(var/datum/data/record/R in SSdatacore.get_records(DATACORE_RECORDS_MEDICAL))
					if((lowertext(R.fields[DATACORE_NAME]) == t1 || t1 == lowertext(R.fields[DATACORE_ID]) || t1 == lowertext(R.fields[DATACORE_BLOOD_DNA])))
						active2 = R
					else
						//Foreach continue //goto(3229)
				if(!( active2 ))
					temp = "Could not locate record [sanitize(t1)]."
				else
					for(var/datum/data/record/E in SSdatacore.get_records(DATACORE_RECORDS_STATION))
						if((E.fields[DATACORE_NAME] == active2.fields[DATACORE_NAME] || E.fields[DATACORE_ID] == active2.fields[DATACORE_ID]))
							active1 = E
						else
							//Foreach continue //goto(3334)
					screen = 4

			else if(href_list["print_p"])
				if(!( printing ))
					printing = 1
					SSdatacore.medicalPrintCount++
					playsound(loc, 'sound/items/poster_being_created.ogg', 100, TRUE)
					sleep(30)
					var/obj/item/paper/P = new /obj/item/paper( loc )
					P.info = "<CENTER><B>Medical Record - (MR-[SSdatacore.medicalPrintCount])</B></CENTER><BR>"
					if(active1 in SSdatacore.get_records(DATACORE_RECORDS_STATION))

						P.info +={"
Name: [active1.fields[DATACORE_NAME]]
ID: [active1.fields[DATACORE_ID]]<BR>
Gender: [active1.fields[DATACORE_GENDER]]<BR>
Age: [active1.fields[DATACORE_AGE]]<BR>
Species: [active1.fields[DATACORE_SPECIES]]<BR>
Fingerprint: [active1.fields[DATACORE_FINGERPRINT]]<BR>
Physical Status: [active1.fields[DATACORE_PHYSICAL_HEALTH]]<BR>
Mental Status: [active1.fields[DATACORE_MENTAL_HEALTH]]<BR>
"}

					else
						P.info += "<B>General Record Lost!</B><BR>"
					if(active2 in SSdatacore.get_records(DATACORE_RECORDS_MEDICAL))

						P.info += {"
<BR><CENTER><B>Medical Data</B></CENTER><BR>
Blood Type: [active2.fields[DATACORE_BLOOD_TYPE]]<BR>
DNA: [active2.fields[DATACORE_BLOOD_DNA]]<BR>
<BR>
Minor Disabilities: [active2.fields["disabilities"]]<BR>
Details: [active2.fields["disabilities_details"]]<BR><BR>
Allergies: [active2.fields["alg"]]<BR>
Details: [active2.fields["alg_d"]]<BR><BR>
Current Diseases: [active2.fields[DATACORE_DISEASES]] (per disease info placed in log/comment section)<BR>
Details: [active2.fields[DATACORE_DISEASES_DETAILS]]<BR><BR>
Important Notes:<BR>
\t[active2.fields[DATACORE_NOTES]]<BR><BR>
<CENTER><B>Comments/Log</B></CENTER><BR>"}

						var/counter = 1
						while(active2.fields["com_[counter]"])
							P.info += "[active2.fields["com_[counter]"]]<BR>"
							counter++
						P.name ="MR-[SSdatacore.medicalPrintCount] '[active1.fields[DATACORE_NAME]]'"
					else
						P.info += "<B>Medical Record Lost!</B><BR>"
						P.name = "MR-[SSdatacore.medicalPrintCount] 'Record Lost'"
					P.info += "</TT>"
					P.update_appearance()
					printing = null

	add_fingerprint(usr)
	updateUsrDialog()
	return

/obj/machinery/computer/med_data/emp_act(severity)
	. = ..()
	if(!(machine_stat & (BROKEN|NOPOWER)) && !(. & EMP_PROTECT_SELF))
		for(var/datum/data/record/R in SSdatacore.get_records(DATACORE_RECORDS_MEDICAL))
			if(prob(10/severity))
				switch(rand(1,6))
					if(1)
						if(prob(10))
							R.fields[DATACORE_NAME] = random_unique_lizard_name(R.fields[DATACORE_GENDER],1)
						else
							R.fields[DATACORE_NAME] = random_unique_name(R.fields[DATACORE_GENDER],1)
					if(2)
						R.fields[DATACORE_GENDER] = pick("Male", "Female", "Other")
					if(3)
						R.fields[DATACORE_AGE] = rand(AGE_MIN, AGE_MAX)
					if(4)
						R.fields[DATACORE_BLOOD_TYPE] = random_blood_type()
					if(5)
						R.fields[DATACORE_PHYSICAL_HEALTH] = pick("*Unconscious*", "Active", "Physically Unfit")
					if(6)
						R.fields[DATACORE_MENTAL_HEALTH] = pick("*Insane*", "*Unstable*", "*Watch*", "Stable")
				continue

			else if(prob(1))
				qdel(R)
				continue

/obj/machinery/computer/med_data/proc/canUseMedicalRecordsConsole(mob/user, message = 1, record1, record2)
	if(user && message && authenticated)
		if(user.canUseTopic(src, USE_CLOSE|USE_SILICON_REACH))
			if(!record1 || record1 == active1)
				if(!record2 || record2 == active2)
					return TRUE
	return FALSE

/obj/machinery/computer/med_data/laptop
	name = "medical laptop"
	desc = "A cheap Thinktronic medical laptop, it functions as a medical records computer. It's bolted to the table."
	icon_state = "laptop"
	icon_screen = "medlaptop"
	icon_keyboard = "laptop_key"
	pass_flags = PASSTABLE
