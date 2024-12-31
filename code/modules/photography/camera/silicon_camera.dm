
/obj/item/camera/siliconcam
	name = "silicon photo camera"
	resistance_flags = INDESTRUCTIBLE
	var/list/datum/picture/stored = list()

/// Checks if we can take a picture at this moment. Returns TRUE if we can, FALSE if we can't.
/obj/item/camera/siliconcam/proc/can_take_picture(mob/living/silicon/clicker)
	if(clicker.stat != CONSCIOUS || clicker.incapacitated())
		return FALSE
	return TRUE

/obj/item/camera/siliconcam/proc/InterceptClickOn(mob/living/silicon/clicker, params, atom/clicked_on)
	if(!can_take_picture(clicker))
		return
	clicker.face_atom(clicked_on)
	captureimage(clicked_on, clicker)
	toggle_camera_mode(clicker, sound = FALSE)

/// Toggles the camera mode on or off.
/// If sound is TRUE, plays a sound effect and displays a message on successful toggle
/obj/item/camera/siliconcam/proc/toggle_camera_mode(mob/user, sound = TRUE)
	if(user.click_intercept == src)
		user.click_intercept = null

	else if(isnull(user.click_intercept))
		user.click_intercept = src

	else
		// Trying to turn on camera mode while you have another click intercept active, such as malf abilities
		if(sound)
			to_chat(user, span_warning("You cannot enable camera mode right now."))
			playsound(user, 'sound/machines/buzz-sigh.ogg', 25, TRUE)
		return


/obj/item/camera/siliconcam/proc/selectpicture(mob/user)
	var/list/nametemp = list()
	if(!stored.len)
		to_chat(usr, "<span class='infoplain'><font color=red><b>No images saved</b></font></span>")
		return

	var/list/temp = list()
	for(var/i in stored)
		var/datum/picture/p = i
		nametemp += p.picture_name
		temp[p.picture_name] = p

	var/find = tgui_input_list(user, "Select image", "Storage", nametemp)
	if(isnull(find) || isnull(temp[find]))
		return

	return temp[find]

/obj/item/camera/siliconcam/proc/viewpictures(mob/user)
	var/datum/picture/selection = selectpicture(user)
	if(istype(selection))
		show_picture(user, selection)


/obj/item/camera/siliconcam/ai_camera
	name = "AI photo camera"
	flash_enabled = FALSE

/obj/item/camera/siliconcam/ai_camera/can_take_picture(mob/living/silicon/ai/clicker)
	if(clicker.control_disabled)
		return FALSE
	return ..()

/obj/item/camera/siliconcam/ai_camera/after_picture(mob/user, datum/picture/picture)
	var/number = stored.len
	picture.picture_name = "Image [number] (taken by [loc.name])"
	stored[picture] = TRUE
	to_chat(usr, "<span class='infoplain'>[span_unconscious("Image recorded")]</span>")

/obj/item/camera/siliconcam/robot_camera
	name = "Cyborg photo camera"
	var/printcost = 2

/obj/item/camera/siliconcam/robot_camera/after_picture(mob/living/silicon/robot/user, datum/picture/picture)
	if(istype(user) && istype(user.connected_ai))
		var/number = user.connected_ai.aicamera.stored.len
		picture.picture_name = "Image [number] (taken by [loc.name])"
		user.connected_ai.aicamera.stored[picture] = TRUE
		to_chat(usr, "<span class='infoplain'>[span_unconscious("Image recorded and saved to remote database")]</span>")
	else
		var/number = stored.len
		picture.picture_name = "Image [number] (taken by [loc.name])"
		stored[picture] = TRUE
		to_chat(user, "<span class='infoplain'>[span_unconscious("Image recorded and saved to local storage. Upload will happen automatically if unit is lawsynced.")]</span>")

	user.playsound_local(get_turf(user), pick('sound/items/polaroid1.ogg', 'sound/items/polaroid2.ogg'), 50, TRUE, -3)

/obj/item/camera/siliconcam/robot_camera/selectpicture(mob/living/silicon/robot/user)
	if(istype(user) && user.connected_ai)
		user.picturesync()
		return user.connected_ai.aicamera.selectpicture(user)
	return ..()

/obj/item/camera/siliconcam/robot_camera/proc/borgprint(mob/living/silicon/robot/user)
	if(!istype(user) || user.toner < 20)
		to_chat(user, span_warning("Insufficent toner to print image."))
		return

	var/datum/picture/selection = selectpicture(user)
	if(!istype(selection))
		to_chat(user, span_warning("Invalid Image."))
		return

	var/obj/item/photo/printed = new(user.drop_location(), selection)
	printed.pixel_x = printed.base_pixel_x + rand(-10, 10)
	printed.pixel_y = printed.base_pixel_y + rand(-10, 10)
	user.toner -= printcost  //All fun allowed.
	user.visible_message(span_notice("[user.name] spits out a photograph from a narrow slot on its chassis."))
	playsound(src, 'sound/items/taperecorder/taperecorder_print.ogg', 50, TRUE, -3)

/obj/item/camera/siliconcam/proc/paiprint(mob/user)
	var/mob/living/silicon/pai/paimob = loc
	var/datum/picture/selection = selectpicture(user)
	if(!istype(selection))
		to_chat(user, span_warning("Invalid Image."))
		return
	printpicture(user,selection)
	user.visible_message(span_notice("A picture appears on top of the chassis of [paimob.name]."))
