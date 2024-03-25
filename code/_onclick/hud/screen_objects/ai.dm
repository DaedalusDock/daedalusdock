/atom/movable/screen/ai
	icon = 'icons/hud/screen_ai.dmi'

/atom/movable/screen/ai/Click()
	. = ..()
	if(.)
		return FALSE

	if(isobserver(usr) || usr.incapacitated())
		return TRUE

/atom/movable/screen/ai/aicore
	name = "AI core"
	icon_state = "ai_core"
	screen_loc = ui_ai_core

/atom/movable/screen/ai/aicore/Click()
	if(..())
		return
	var/mob/living/silicon/ai/AI = usr
	AI.view_core()

/atom/movable/screen/ai/camera_list
	name = "Show Camera List"
	icon_state = "camera"
	screen_loc = ui_ai_camera_list

/atom/movable/screen/ai/camera_list/Click()
	if(..())
		return
	var/mob/living/silicon/ai/AI = usr
	AI.show_camera_list()

/atom/movable/screen/ai/camera_track
	name = "Track With Camera"
	icon_state = "track"
	screen_loc = ui_ai_track_with_camera

/atom/movable/screen/ai/camera_track/Click()
	if(..())
		return
	var/mob/living/silicon/ai/AI = usr
	var/target_name = tgui_input_list(AI, "Select a target", "Tracking", AI.trackable_mobs())
	if(isnull(target_name))
		return
	AI.ai_camera_track(target_name)

/atom/movable/screen/ai/camera_light
	name = "Toggle Camera Light"
	icon_state = "camera_light"
	screen_loc = ui_ai_camera_light

/atom/movable/screen/ai/camera_light/Click()
	if(..())
		return
	var/mob/living/silicon/ai/AI = usr
	AI.toggle_camera_light()

/atom/movable/screen/ai/modpc
	name = "Messenger"
	icon_state = "pda_send"
	screen_loc = ui_ai_mod_int
	var/mob/living/silicon/ai/robot

/atom/movable/screen/ai/modpc/Click()
	. = ..()
	if(.)
		return
	robot.modularInterface?.interact(robot)

/atom/movable/screen/ai/crew_monitor
	name = "Crew Monitoring Console"
	icon_state = "crew_monitor"
	screen_loc = ui_ai_crew_monitor

/atom/movable/screen/ai/crew_monitor/Click()
	if(..())
		return
	var/mob/living/silicon/ai/AI = usr
	GLOB.crewmonitor.show(AI,AI)

/atom/movable/screen/ai/crew_manifest
	name = "Crew Manifest"
	icon_state = "manifest"
	screen_loc = ui_ai_crew_manifest

/atom/movable/screen/ai/crew_manifest/Click()
	if(..())
		return
	var/mob/living/silicon/ai/AI = usr
	AI.ai_roster()

/atom/movable/screen/ai/alerts
	name = "Show Alerts"
	icon_state = "alerts"
	screen_loc = ui_ai_alerts

/atom/movable/screen/ai/alerts/Click()
	if(..())
		return
	var/mob/living/silicon/ai/AI = usr
	AI.alert_control.ui_interact(AI)

/atom/movable/screen/ai/announcement
	name = "Make Vox Announcement"
	icon_state = "announcement"
	screen_loc = ui_ai_announcement

/atom/movable/screen/ai/announcement/Click()
	if(..())
		return
	var/mob/living/silicon/ai/AI = usr
	AI.announcement()

/atom/movable/screen/ai/call_shuttle
	name = "Call Emergency Shuttle"
	icon_state = "call_shuttle"
	screen_loc = ui_ai_shuttle

/atom/movable/screen/ai/call_shuttle/Click()
	if(..())
		return
	var/mob/living/silicon/ai/AI = usr
	AI.ai_call_shuttle()

/atom/movable/screen/ai/state_laws
	name = "State Laws"
	icon_state = "state_laws"
	screen_loc = ui_ai_state_laws

/atom/movable/screen/ai/state_laws/Click()
	if(..())
		return
	var/mob/living/silicon/ai/AI = usr
	AI.checklaws()

/atom/movable/screen/ai/image_take
	name = "Take Image"
	icon_state = "take_picture"
	screen_loc = ui_ai_take_picture

/atom/movable/screen/ai/image_take/Click()
	if(..())
		return
	if(isAI(usr))
		var/mob/living/silicon/ai/AI = usr
		AI.aicamera.toggle_camera_mode(usr)
	else if(iscyborg(usr))
		var/mob/living/silicon/robot/R = usr
		R.aicamera.toggle_camera_mode(usr)

/atom/movable/screen/ai/image_view
	name = "View Images"
	icon_state = "view_images"
	screen_loc = ui_ai_view_images

/atom/movable/screen/ai/image_view/Click()
	if(..())
		return
	if(isAI(usr))
		var/mob/living/silicon/ai/AI = usr
		AI.aicamera.viewpictures(usr)

/atom/movable/screen/ai/sensors
	name = "Sensor Augmentation"
	icon_state = "ai_sensor"
	screen_loc = ui_ai_sensor

/atom/movable/screen/ai/sensors/Click()
	if(..())
		return
	var/mob/living/silicon/S = usr
	S.toggle_sensors()

/atom/movable/screen/ai/multicam
	name = "Multicamera Mode"
	icon_state = "multicam"
	screen_loc = ui_ai_multicam

/atom/movable/screen/ai/multicam/Click()
	if(..())
		return
	var/mob/living/silicon/ai/AI = usr
	AI.toggle_multicam()

/atom/movable/screen/ai/add_multicam
	name = "New Camera"
	icon_state = "new_cam"
	screen_loc = ui_ai_add_multicam

/atom/movable/screen/ai/add_multicam/Click()
	if(..())
		return
	var/mob/living/silicon/ai/AI = usr
	AI.drop_new_multicam()
