

/obj/item/clothing/glasses/examine(mob/user)
	. = ..()
	if(can_switch_eye)
		if(current_eye == "_L")
			. += "Ctrl-click on [src] to wear it over your right eye."
		else
			. += "Ctrl-click on [src] to wear it over your left eye."

/obj/item/clothing/glasses/verb/eyepatch_switcheye()
	set name = "Switch Eyepatch Side"
	set category = null
	set src in usr
	switcheye()

/obj/item/clothing/glasses/proc/switcheye()
	if(!can_use(usr))
		return
	if(!can_switch_eye)
		to_chat(usr, span_warning("You cannot wear this any differently!"))
		return
	eyepatch_do_switch()
	if(current_eye == "_L")
		to_chat(usr, span_notice("You adjust the eyepatch to wear it over your left eye."))
	else if(current_eye == "_R")
		to_chat(usr, span_notice("You adjust the eyepatch to wear it over your right eye."))
	usr.update_worn_glasses()
	usr.update_overlays()

/obj/item/clothing/glasses/proc/eyepatch_do_switch()
	if(current_eye == "_L")
		current_eye = "_R"
	else if(current_eye == "_R")
		current_eye = "_L"
	src.icon_state = "[initial(icon_state)]"+ current_eye

/* ---------- Items Below ----------*/
