/atom/movable/screen/robot
	icon = 'icons/hud/screen_cyborg.dmi'

/atom/movable/screen/robot/module
	name = "cyborg module"
	icon_state = "nomod"
	screen_loc = ui_borg_module

/atom/movable/screen/robot/module/Click()
	if(..())
		return
	var/mob/living/silicon/robot/R = usr
	if(R.model.type != /obj/item/robot_model)
		R.hud_used.toggle_show_robot_modules()
		return 1
	R.pick_model()

/atom/movable/screen/robot/module1
	name = "module1"
	icon_state = "inv1"
	screen_loc = ui_inv1

/atom/movable/screen/robot/module1/Click()
	if(..())
		return
	var/mob/living/silicon/robot/R = usr
	R.toggle_module(1)

/atom/movable/screen/robot/module2
	name = "module2"
	icon_state = "inv2"
	screen_loc = ui_inv2

/atom/movable/screen/robot/module2/Click()
	if(..())
		return
	var/mob/living/silicon/robot/R = usr
	R.toggle_module(2)

/atom/movable/screen/robot/module3
	name = "module3"
	icon_state = "inv3"
	screen_loc = ui_inv3

/atom/movable/screen/robot/module3/Click()
	if(..())
		return
	var/mob/living/silicon/robot/R = usr
	R.toggle_module(3)

/atom/movable/screen/robot/radio
	name = "radio"
	icon_state = "radio"
	screen_loc = ui_borg_radio

/atom/movable/screen/robot/radio/Click()
	if(..())
		return
	var/mob/living/silicon/robot/R = usr
	R.radio.interact(R)

/atom/movable/screen/robot/store
	name = "store"
	icon_state = "store"
	screen_loc = ui_borg_store

/atom/movable/screen/robot/store/Click()
	if(..())
		return
	var/mob/living/silicon/robot/R = usr
	R.uneq_active()

/atom/movable/screen/robot/lamp
	name = "headlamp"
	icon_state = "lamp_off"
	base_icon_state = "lamp"
	screen_loc = ui_borg_lamp
	var/mob/living/silicon/robot/robot

/atom/movable/screen/robot/lamp/Click()
	. = ..()
	if(.)
		return
	robot?.toggle_headlamp()
	update_appearance()

/atom/movable/screen/robot/lamp/update_icon_state()
	icon_state = "[base_icon_state]_[robot?.lamp_enabled ? "on" : "off"]"
	return ..()

/atom/movable/screen/robot/lamp/Destroy()
	if(robot)
		robot.lampButton = null
		robot = null
	return ..()

/atom/movable/screen/robot/modpc
	name = "Modular Interface"
	icon_state = "template"
	screen_loc = ui_borg_tablet
	var/mob/living/silicon/robot/robot

/atom/movable/screen/robot/modpc/Click()
	. = ..()
	if(.)
		return
	robot.modularInterface?.interact(robot)

/atom/movable/screen/robot/modpc/Destroy()
	if(robot)
		robot.interfaceButton = null
		robot = null
	return ..()

/atom/movable/screen/robot/alerts
	name = "Alert Panel"
	icon = 'icons/hud/screen_ai.dmi'
	icon_state = "alerts"
	screen_loc = ui_borg_alerts

/atom/movable/screen/robot/alerts/Click()
	. = ..()
	if(.)
		return
	var/mob/living/silicon/robot/borgo = usr
	borgo.alert_control.ui_interact(borgo)
