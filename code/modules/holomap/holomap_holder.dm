/datum/holomap_holder
	VAR_PRIVATE/image/holomap
	/// A physical object this holomap is bound to. Optional.
	var/atom/movable/parent

	/// Used by children to properly position elements on the map.
	var/offset_x = 0
	/// Used by children to properly position elements on the map.
	var/offset_y = 0

	/// k:v list of mob:image
	var/list/viewer_map = list()

/datum/holomap_holder/New(parent, icon/holomap_icon)
	src.parent = parent

	holomap = image(holomap_icon)
	holomap.plane = FULLSCREEN_PLANE

	offset_x = SSmapping.config.holomap_offsets[1]
	offset_y = SSmapping.config.holomap_offsets[2]

/datum/holomap_holder/Destroy(force, ...)
	remove_all_viewers()
	parent = null
	return ..()

/// Remove all viewers
/datum/holomap_holder/proc/remove_all_viewers()
	for(var/mob/viewer as anything in viewer_map)
		remove_viewer(viewer, TRUE)

/// Removes a viewer.
/datum/holomap_holder/proc/remove_viewer(mob/viewer, immediately)
	if(!(viewer in viewer_map))
		return FALSE

	var/image/holomap_image = viewer_map[viewer]
	viewer_map -= viewer

	UnregisterSignal(viewer, list(COMSIG_MOVABLE_MOVED, COMSIG_MOB_LOGOUT))

	if(immediately)
		holomap_image.loc = null
		viewer.client?.images -= holomap_image
	else
		animate(holomap_image, alpha = 0, time = 5, easing = LINEAR_EASING)
		addtimer(CALLBACK(src, PROC_REF(remove_image_delayed), WEAKREF(viewer), holomap_image), 0.5 SECONDS)

	SEND_SIGNAL(src, COMSIG_HOLOMAP_VIEWER_REMOVED, viewer)
	return TRUE

/// Show the map to a mob and add them to the viewers list.
/datum/holomap_holder/proc/show_to(mob/user)
	if(!user.client)
		return FALSE

	var/image/holomap_image = get_image()
	holomap_image.alpha = 0
	holomap_image.loc = user.hud_used.holomap_container
	user.client.images += holomap_image

	viewer_map[user] = holomap_image

	animate(holomap_image, alpha = 255, time = 5, easing = LINEAR_EASING)
	RegisterSignal(user, COMSIG_MOB_LOGOUT, PROC_REF(viewer_logout))

	SEND_SIGNAL(src, COMSIG_HOLOMAP_VIEWER_GAINED, user)
	return holomap_image

/datum/holomap_holder/proc/viewer_logout(mob/source)
	SIGNAL_HANDLER
	remove_viewer(source, TRUE)

/datum/holomap_holder/proc/remove_image_delayed(datum/weakref/viewer_ref, image/holomap_image)
	holomap_image.loc = null

	var/mob/viewer = viewer_ref?.resolve()
	if(!viewer?.client)
		return

	viewer.client.images -= holomap_image

/// Returns the holomap image.
/datum/holomap_holder/proc/get_image() as /image
	var/image/out = image(holomap)
	out.appearance = holomap.appearance
	return out

/// Adds a "you are here" overlay to the given image based on the given location.
/datum/holomap_holder/proc/you_are_here(image/map, atom/loc)
	var/turf/T = get_turf(loc)
	var/image/I = image('icons/hud/holomap/holomap_markers.dmi', "you")
	I.pixel_x = T.x + offset_x - 6 // -6 is to account for the icon being off-center
	I.pixel_y = T.y + offset_y - 6

	map.overlays += I

/datum/holomap_holder/station

/datum/holomap_holder/station/New(parent, icon/holomap_icon)
	..()
	var/image/I = image('icons/hud/holomap/holomap_64x64.dmi', "legend")
	I.pixel_x = round(HOLOMAP_SIZE / 6)
	I.pixel_y = round(HOLOMAP_SIZE * 0.75)
	holomap.overlays += I

	I = image('icons/hud/holomap/holomap_64x64.dmi', "youarehere")
	I.pixel_x = round(HOLOMAP_SIZE / 6)
	I.pixel_y = round(HOLOMAP_SIZE * 0.75)
	holomap.overlays += I

/datum/holomap_holder/station/get_image()
	. = ..()
	you_are_here(., parent)

/datum/holomap_holder/invalid

/datum/holomap_holder/invalid/New(parent, icon/holomap_icon)
	holomap_icon = SSholomap.invalid_holomap_icon
	..()

/datum/holomap_holder/invalid/you_are_here(image/map, atom/loc)
	return
