/*
Destructive Analyzer

It is used to destroy hand-held objects and advance technological research. Controls are in the linked R&D console.

Note: Must be placed within 3 tiles of the R&D Console
*/
/obj/machinery/rnd/destructive_analyzer
	name = "destructive analyzer"
	desc = "Learn science by destroying things!"
	icon_state = "d_analyzer"
	base_icon_state = "d_analyzer"
	circuit = /obj/item/circuitboard/machine/destructive_analyzer
	var/decon_mod = 0
	#warn This needs to interface with design disks.

/obj/machinery/rnd/destructive_analyzer/RefreshParts()
	. = ..()
	var/T = 0
	for(var/obj/item/stock_parts/S in component_parts)
		T += S.rating
	decon_mod = T

/obj/machinery/rnd/destructive_analyzer/proc/ConvertReqString2List(list/source_list)
	var/list/temp_list = params2list(source_list)
	for(var/O in temp_list)
		temp_list[O] = text2num(temp_list[O])
	return temp_list

/obj/machinery/rnd/destructive_analyzer/Insert_Item(obj/item/O, mob/living/user)
	if(!user.combat_mode)
		. = 1
		if(!is_insertion_ready(user))
			return
		if(!user.transferItemToLoc(O, src))
			to_chat(user, span_warning("\The [O] is stuck to your hand, you cannot put it in the [src.name]!"))
			return
		busy = TRUE
		loaded_item = O
		to_chat(user, span_notice("You add the [O.name] to the [src.name]!"))
		flick("d_analyzer_la", src)
		addtimer(CALLBACK(src, PROC_REF(finish_loading)), 10)
		updateUsrDialog()

/obj/machinery/rnd/destructive_analyzer/proc/finish_loading()
	update_appearance()
	reset_busy()

/obj/machinery/rnd/destructive_analyzer/update_icon_state()
	icon_state = "[base_icon_state][loaded_item ? "_l" : null]"
	return ..()

/obj/machinery/rnd/destructive_analyzer/proc/destroy_item(obj/item/thing, innermode = FALSE)
	if(QDELETED(thing) || QDELETED(src))
		return FALSE
	if(!innermode)
		flick("d_analyzer_process", src)
		busy = TRUE
		addtimer(CALLBACK(src, PROC_REF(reset_busy)), 24)
		use_power(250)
		if(thing == loaded_item)
			loaded_item = null
		var/list/food = thing.GetDeconstructableContents()
		for(var/obj/item/innerthing in food)
			destroy_item(innerthing, TRUE)
	for(var/mob/living/victim in thing)
		victim.death()

	qdel(thing)
	loaded_item = null
	if (!innermode)
		update_appearance()
	return TRUE

/obj/machinery/rnd/destructive_analyzer/proc/user_try_decon(mob/user)
	if(!istype(loaded_item))
		return FALSE
	var/user_mode_string = ""
	if(length(point_value))
		user_mode_string = " for [json_encode(point_value)] points"
	var/choice = tgui_alert(usr, "Are you sure you want to destroy [loaded_item][user_mode_string]?",, list("Proceed", "Cancel"))
	if(choice == "Cancel")
		return FALSE
	if(QDELETED(loaded_item) || QDELETED(src))
		return FALSE
	destroy_item(loaded_item)

	return TRUE

/obj/machinery/rnd/destructive_analyzer/proc/unload_item()
	if(!loaded_item)
		return FALSE
	loaded_item.forceMove(get_turf(src))
	loaded_item = null
	update_appearance()
	return TRUE

/obj/machinery/rnd/destructive_analyzer/ui_interact(mob/user)
	. = ..()
	var/datum/browser/popup = new(user, "destructive_analyzer", name, 900, 600)
	popup.set_content(ui_deconstruct())
	popup.open()

/obj/machinery/rnd/destructive_analyzer/proc/ui_deconstruct() //Legacy code
	var/list/l = list()
	if(!loaded_item)
		l += "<div class='statusDisplay'>No item loaded. Standing-by...</div>"
	else
		l += "<div class='statusDisplay'>[RDSCREEN_NOBREAK]"
		l += "<table><tr><td>[icon2html(loaded_item, usr)]</td><td><b>[loaded_item.name]</b> <A href='?src=[REF(src)];eject_item=1'>Eject</A></td></tr></table>[RDSCREEN_NOBREAK]"

		var/datum/design/D = SStech.designs_by_product[loaded_item.type]
		if(D)
			l += "<div class='statusDisplay'>[RDSCREEN_NOBREAK]"
				l += "<A href='?src=[REF(src)];deconstruct=[RESEARCH_MATERIAL_DESTROY_ID]'>Analysis</A>"
				l += "This item can be blueprinted!"
			l += "</div>[RDSCREEN_NOBREAK]"

		if(!(loaded_item.resistance_flags & INDESTRUCTIBLE))
			l += "<div class='statusDisplay'><A href='?src=[REF(src)];deconstruct=[RESEARCH_MATERIAL_DESTROY_ID]'>Destroy Item</A>"
			l += "</div>[RDSCREEN_NOBREAK]"
			anything = TRUE

		l += "</div>"

	for(var/i in 1 to length(l))
		if(!findtextEx(l[i], RDSCREEN_NOBREAK))
			l[i] += "<br>"

	. = l.Join("")
	return replacetextEx(., RDSCREEN_NOBREAK, "")

/obj/machinery/rnd/destructive_analyzer/Topic(raw, ls)
	. = ..()
	if(.)
		return

	add_fingerprint(usr)
	usr.set_machine(src)

	if(ls["eject_item"]) //Eject the item inside the destructive analyzer.
		if(busy)
			to_chat(usr, span_danger("The destructive analyzer is busy at the moment."))
			return
		if(loaded_item)
			unload_item()
	if(ls["deconstruct"])
		if(!user_try_decon_id(ls["deconstruct"], usr))
			say("Destructive analysis failed!")

	updateUsrDialog()

/obj/machinery/rnd/destructive_analyzer/screwdriver_act(mob/living/user, obj/item/tool)
	return FALSE
