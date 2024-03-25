#define PAI_MISSING_SOFTWARE_MESSAGE span_warning("You must download the required software to use this.")

/atom/movable/screen/pai
	icon = 'icons/hud/screen_pai.dmi'
	var/required_software

/atom/movable/screen/pai/Click()
	. = ..()
	if(.)
		return FALSE
	if(usr.incapacitated())
		return FALSE

	var/mob/living/silicon/pai/pAI = usr
	if(required_software && !pAI.software.Find(required_software))
		to_chat(pAI, PAI_MISSING_SOFTWARE_MESSAGE)
		return FALSE
	return TRUE

/atom/movable/screen/pai/software
	name = "Software Interface"
	icon_state = "pai"
	screen_loc = ui_pai_software

/atom/movable/screen/pai/software/Click()
	if(!..())
		return
	var/mob/living/silicon/pai/pAI = usr
	pAI.ui_interact(pAI)

/atom/movable/screen/pai/shell
	name = "Toggle Holoform"
	icon_state = "pai_holoform"
	screen_loc = ui_pai_shell

/atom/movable/screen/pai/shell/Click()
	if(!..())
		return
	var/mob/living/silicon/pai/pAI = usr
	if(pAI.holoform)
		pAI.fold_in(0)
	else
		pAI.fold_out()

/atom/movable/screen/pai/chassis
	name = "Holochassis Appearance Composite"
	icon_state = "pai_chassis"
	screen_loc = ui_pai_chassis

/atom/movable/screen/pai/chassis/Click()
	if(!..())
		return
	var/mob/living/silicon/pai/pAI = usr
	pAI.choose_chassis()

/atom/movable/screen/pai/rest
	name = "Rest"
	icon_state = "pai_rest"
	screen_loc = ui_pai_rest

/atom/movable/screen/pai/rest/Click()
	if(!..())
		return
	var/mob/living/silicon/pai/pAI = usr
	pAI.toggle_resting()

/atom/movable/screen/pai/light
	name = "Toggle Integrated Lights"
	icon_state = "light"
	screen_loc = ui_pai_light

/atom/movable/screen/pai/light/Click()
	if(!..())
		return
	var/mob/living/silicon/pai/pAI = usr
	pAI.toggle_integrated_light()

/atom/movable/screen/pai/newscaster
	name = "pAI Newscaster"
	icon_state = "newscaster"
	required_software = "newscaster"
	screen_loc = ui_pai_newscaster

/atom/movable/screen/pai/newscaster/Click()
	if(!..())
		return
	var/mob/living/silicon/pai/pAI = usr
	pAI.newscaster.ui_interact(usr)

/atom/movable/screen/pai/host_monitor
	name = "Host Health Scan"
	icon_state = "host_monitor"
	required_software = "host scan"
	screen_loc = ui_pai_host_monitor

/atom/movable/screen/pai/host_monitor/Click(location, control, params)
	. = ..()
	if(!.)
		return
	var/mob/living/silicon/pai/pAI = usr
	var/list/modifiers = params2list(params)
	var/mob/living/carbon/holder = get(pAI.card.loc, /mob/living/carbon)
	if(holder)
		if (LAZYACCESS(modifiers, CTRL_CLICK)) //This is a UI element so I don't care about the interaction overlap.
			pAI.hostscan.attack_self(pAI)
		else
			pAI.hostscan.attack(holder, pAI)
	else
		to_chat(usr, span_warning("You are not being carried by anyone!"))
		return FALSE

/atom/movable/screen/pai/crew_manifest
	name = "Crew Manifest"
	icon_state = "manifest"
	required_software = "crew manifest"
	screen_loc = ui_pai_crew_manifest

/atom/movable/screen/pai/crew_manifest/Click()
	if(!..())
		return
	var/mob/living/silicon/pai/pAI = usr
	pAI.ai_roster()

/atom/movable/screen/pai/state_laws
	name = "State Laws"
	icon_state = "state_laws"
	screen_loc = ui_pai_state_laws

/atom/movable/screen/pai/state_laws/Click()
	if(!..())
		return
	var/mob/living/silicon/pai/pAI = usr
	pAI.checklaws()

/atom/movable/screen/pai/modpc
	name = "Messenger"
	icon_state = "pda_send"
	screen_loc = ui_pai_mod_int
	var/mob/living/silicon/pai/pAI

/atom/movable/screen/pai/modpc/Click()
	. = ..()
	if(!.) // this works for some reason.
		return
	pAI.modularInterface?.interact(pAI)

/atom/movable/screen/pai/internal_gps
	name = "Internal GPS"
	icon_state = "internal_gps"
	required_software = "internal gps"
	screen_loc = ui_pai_internal_gps

/atom/movable/screen/pai/internal_gps/Click()
	. = ..()
	if(!.)
		return
	var/mob/living/silicon/pai/pAI = usr
	if(!pAI.internal_gps)
		pAI.internal_gps = new(pAI)
	pAI.internal_gps.attack_self(pAI)

/atom/movable/screen/pai/image_take
	name = "Take Image"
	icon_state = "take_picture"
	required_software = "photography module"
	screen_loc = ui_pai_take_picture

/atom/movable/screen/pai/image_take/Click()
	if(!..())
		return
	var/mob/living/silicon/pai/pAI = usr
	pAI.aicamera.toggle_camera_mode(usr)

/atom/movable/screen/pai/image_view
	name = "View Images"
	icon_state = "view_images"
	required_software = "photography module"
	screen_loc = ui_pai_view_images

/atom/movable/screen/pai/image_view/Click()
	if(!..())
		return
	var/mob/living/silicon/pai/pAI = usr
	pAI.aicamera.viewpictures(usr)

/atom/movable/screen/pai/radio
	name = "radio"
	icon = 'icons/hud/screen_cyborg.dmi'
	icon_state = "radio"
	screen_loc = ui_pai_radio

/atom/movable/screen/pai/radio/Click()
	if(!..())
		return
	var/mob/living/silicon/pai/pAI = usr
	pAI.radio.interact(usr)

#undef PAI_MISSING_SOFTWARE_MESSAGE
