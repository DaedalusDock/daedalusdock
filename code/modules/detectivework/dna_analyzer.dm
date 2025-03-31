/obj/machinery/dna_analyzer
	name = "dna analyzer"
	desc = "A machine designed to analyze substances and their potential DNA presence."
	icon = 'icons/obj/machines/forensics/dna_scanner.dmi'
	icon_state = "dna"

	var/obj/item/swab/sample
	var/working = FALSE

/obj/machinery/dna_analyzer/Destroy()
	QDEL_NULL(sample)
	return ..()

/obj/machinery/dna_analyzer/update_overlays()
	. = ..()
	if(machine_stat & NOPOWER)
		. += "dna_closed"
		return

	if(working)
		. += "dna_working"
		. += emissive_appearance(icon, "dna_screen_working", alpha = 90)
		. += "dna_screen_working"
	else
		. += "dna_closed"
		. += emissive_appearance(icon, "dna_screen")
		. += "dna_screen"

/obj/machinery/dna_analyzer/attackby(obj/item/weapon, mob/user, params)
	. = ..()
	if(.)
		return

	if(!istype(weapon, /obj/item/swab))
		to_chat(user, span_warning("[src] only accepts swabs."))
		return TRUE

	if(sample)
		to_chat(user, span_warning("There is already a sample inside."))
		return TRUE

	var/obj/item/swab/incoming = weapon
	if(!incoming.used)
		to_chat(user, span_warning("You can only insert used samples."))
		return TRUE

	if(!user.transferItemToLoc(weapon, src))
		return TRUE

	sample = weapon
	to_chat(user, span_notice("You insert [sample] into [src]."))
	updateUsrDialog()
	return TRUE

/obj/machinery/dna_analyzer/proc/analyze_sample()
	PRIVATE_PROC(TRUE)
	if(machine_stat & NOPOWER)
		return

	working = TRUE
	visible_message(span_notice("[src] whirs to life as it begins to analyze the sample"))
	update_appearance()
	addtimer(CALLBACK(src, PROC_REF(finish_sample)), 20 SECONDS)

/obj/machinery/dna_analyzer/proc/finish_sample()
	if(machine_stat & NOPOWER)
		working = FALSE
		updateUsrDialog()
		update_appearance()
		return

	visible_message(span_notice("[icon2html(src, viewers(get_turf(src)))] makes an insistent chime."), 2)

	var/list/blood_DNA = sample.swabbed_forensics.blood_DNA
	var/list/trace_DNA = sample.swabbed_forensics.trace_DNA

	var/obj/item/paper/report = new(src)
	report.name = "DNA analysis for [sample.name] ([stationtime2text()])"
	report.stamp(100, 320, 0, "stamp-law")

	report.info += "<b>Scanned item:</b><br>[sample.name]<br>"
	report.info += "<i>Taken at: [stationtime2text()]</i><br><br>"

	if(length(blood_DNA) || length(trace_DNA))
		report.info += "<i>Spectometric analysis on provided sample has determined the presence of DNA.</i><br><br>"
	else
		report.info += "<i>No DNA presence found.</i>"
		print_report(report)
		return

	report.info += "<b>Blood DNA analysis</b><br>"
	if(length(blood_DNA))
		for(var/dna in blood_DNA)
			report.info += "* [dna]<br>"
		report.info += "<br>"
	else
		report.info += "<i>None present.</i><br><br>"

	report.info += "<b>Trace DNA analysis</b><br>"
	if(length(trace_DNA))
		for(var/dna in trace_DNA)
			report.info += "* [dna]<br>"
		report.info += "<br>"
	else
		report.info += "<i>None present.</i><br><br>"

	print_report(report)


/obj/machinery/dna_analyzer/proc/print_report(obj/item/paper/report)
	if(machine_stat & NOPOWER)
		working = FALSE
		updateUsrDialog()
		update_appearance()
		return

	playsound(src, 'sound/machines/printer.ogg', 50)

	sleep(4 SECONDS)
	working = FALSE
	updateUsrDialog()
	update_appearance()
	if(machine_stat & NOPOWER)
		return

	report.update_appearance()
	report.forceMove(drop_location())

/obj/machinery/dna_analyzer/Topic(href, href_list)
	. = ..()
	if(.)
		return

	if(href_list["eject"])
		if(working)
			return TRUE
		sample = null
		if(!usr.put_in_hands(sample))
			sample.forceMove(drop_location())
		updateUsrDialog()
		return TRUE

	if(href_list["analyze"])
		if(!working)
			analyze_sample()
			updateUsrDialog()
		return TRUE

/obj/machinery/dna_analyzer/ui_interact(mob/user, datum/tgui/ui)
	var/datum/browser/popup = new(user, "dna_analyzer", name, 460, 270)
	popup.set_content(jointext(get_content(), ""))
	popup.open()

/obj/machinery/dna_analyzer/proc/get_content()
	PRIVATE_PROC(TRUE)
	. = list()
	. += "<div style='width:100%;height: 100%'>"
	. += "<fieldset class='computerPane' style='height: 100%'>"
	. += {"
		<legend class='computerLegend'>
			<b>DNA Analyzer</b>
		</legend>
	"}

	. += "<div class='computerLegend' style='margin: auto; width:70%; height: 70px'>"
	if(!sample)
		. += "No Sample"
	else
		if(working)
			. += "Analyzing[ellipsis()]"
		else
			. += "Loaded: [sample.name]"

	. += "</div>"
	if(sample && !working)
		. += "<div style = 'text-align: center'>[button_element(src, "Analyze Sample", "analyze=1")]</div>"
	else
		. += "<div style = 'text-align: center'><span class='linkOff'>Analyze</span></div>"
	. += "<div style = 'text-align: center'>[button_element(src, "Eject Sample", "eject=1")]</div>"
	. += "</fieldset>"
	. += "</div>"
