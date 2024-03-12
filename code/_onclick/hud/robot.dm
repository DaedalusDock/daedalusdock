/datum/hud/robot
	ui_style = 'icons/hud/screen_cyborg.dmi'

/datum/hud/robot/initialize_screens()

	add_screen_object(/atom/movable/screen/language_menu{screen_loc = ui_borg_language_menu}, HUDKEY_MOB_LANGUAGE_MENU, HUDGROUP_STATIC_INVENTORY)
	add_screen_object(/atom/movable/screen/navigate{screen_loc = ui_borg_navigate_menu}, HUDKEY_MOB_NAVIGATE_MENU, HUDGROUP_STATIC_INVENTORY)

	//Radio
	add_screen_object(/atom/movable/screen/robot/radio, HUDKEY_CYBORG_RADIO, HUDGROUP_STATIC_INVENTORY)

	//Module select
	// i, Robit
	var/mob/living/silicon/robot/robit = mymob
	if(!robit.inv1)
		robit.inv1 = add_screen_object(/atom/movable/screen/robot/module1, HUDKEY_CYBORG_MODULE_1, HUDGROUP_STATIC_INVENTORY)
	if(!robit.inv1)
		robit.inv2 = add_screen_object(/atom/movable/screen/robot/module2, HUDKEY_CYBORG_MODULE_2, HUDGROUP_STATIC_INVENTORY)
	if(!robit.inv3)
		robit.inv3 = add_screen_object(/atom/movable/screen/robot/module3, HUDKEY_CYBORG_MODULE_3, HUDGROUP_STATIC_INVENTORY)

	var/atom/movable/screen/robot/lamp/lampscreen = add_screen_object(__IMPLIED_TYPE__, HUDKEY_CYBORG_LAMP, HUDGROUP_STATIC_INVENTORY)
	robit.lampButton = lampscreen
	lampscreen.robot = robit

	//Photography stuff
	add_screen_object(/atom/movable/screen/ai/image_take{screen_loc = ui_borg_camera}, HUDKEY_SILICON_TAKE_IMAGE, HUDGROUP_STATIC_INVENTORY)

	//Borg Integrated Tablet
	var/atom/movable/screen/robot/modpc/tablet = add_screen_object(/atom/movable/screen/robot/modpc, HUDKEY_CYBORG_TABLET, HUDGROUP_STATIC_INVENTORY)
	tablet.robot = robit
	robit.interfaceButton = tablet
	if(robit.modularInterface)
		tablet.vis_contents += robit.modularInterface

	//Alerts
	add_screen_object(/atom/movable/screen/robot/alerts, HUDKEY_CYBORG_ALERTS, HUDGROUP_STATIC_INVENTORY)

	//Combat Mode
	var/atom/movable/screen/combattoggle/robot/action_intent = add_screen_object(__IMPLIED_TYPE__, HUDKEY_CYBORG_ALERTS, HUDGROUP_STATIC_INVENTORY)
	action_intent.icon = ui_style

	//Health
	add_screen_object(/atom/movable/screen/healths/robot, HUDKEY_MOB_HEALTH, HUDGROUP_INFO_DISPLAY)

	//Installed Module
	robit.hands = add_screen_object(/atom/movable/screen/robot/module, HUDKEY_CYBORG_HANDS, HUDGROUP_STATIC_INVENTORY)


	//Store
	add_screen_object(/atom/movable/screen/robot/store, HUDKEY_CYBORG_STORE)

	add_screen_object(/atom/movable/screen/pull/robot, HUDKEY_MOB_PULL, HUDGROUP_HOTKEY_BUTTONS)
	add_screen_object(/atom/movable/screen/zone_sel/robot, HUDKEY_MOB_ZONE_SELECTOR, HUDGROUP_STATIC_INVENTORY)

/datum/hud/proc/toggle_show_robot_modules()
	if(!iscyborg(mymob))
		return

	var/mob/living/silicon/robot/R = mymob

	R.shown_robot_modules = !R.shown_robot_modules
	update_robot_modules_display()

/datum/hud/proc/update_robot_modules_display(mob/viewer)
	if(!iscyborg(mymob))
		return

	var/mob/living/silicon/robot/R = mymob

	var/mob/screenmob = viewer || R

	if(!R.model)
		return

	if(!R.client)
		return

	if(R.shown_robot_modules && screenmob.hud_used.hud_shown)
		//Modules display is shown
		screenmob.client.screen += screen_objects[HUDKEY_CYBORG_STORE] //"store" icon

		if(!R.model.modules)
			to_chat(usr, span_warning("Selected model has no modules to select!"))
			return

		if(!R.robot_modules_background)
			return

		var/display_rows = max(CEILING(length(R.model.get_inactive_modules()) / 8, 1),1)
		R.robot_modules_background.screen_loc = "CENTER-4:16,SOUTH+1:7 to CENTER+3:16,SOUTH+[display_rows]:7"
		screenmob.client.screen += R.robot_modules_background

		var/x = -4 //Start at CENTER-4,SOUTH+1
		var/y = 1

		for(var/atom/movable/A in R.model.get_inactive_modules())
			//Module is not currently active
			screenmob.client.screen += A
			if(x < 0)
				A.screen_loc = "CENTER[x]:16,SOUTH+[y]:7"
			else
				A.screen_loc = "CENTER+[x]:16,SOUTH+[y]:7"
			A.plane = ABOVE_HUD_PLANE

			x++
			if(x == 4)
				x = -4
				y++

	else
		//Modules display is hidden
		screenmob.client.screen -= screen_objects[HUDKEY_CYBORG_STORE] //"store" icon

		for(var/atom/A in R.model.get_inactive_modules())
			//Module is not currently active
			screenmob.client.screen -= A
		R.shown_robot_modules = 0
		screenmob.client.screen -= R.robot_modules_background

/datum/hud/robot/persistent_inventory_update(mob/viewer)
	if(!mymob)
		return
	var/mob/living/silicon/robot/R = mymob

	var/mob/screenmob = viewer || R

	if(screenmob.hud_used)
		if(screenmob.hud_used.hud_shown)
			for(var/i in 1 to R.held_items.len)
				var/obj/item/I = R.held_items[i]
				if(I)
					switch(i)
						if(BORG_CHOOSE_MODULE_ONE)
							I.screen_loc = ui_inv1
						if(BORG_CHOOSE_MODULE_TWO)
							I.screen_loc = ui_inv2
						if(BORG_CHOOSE_MODULE_THREE)
							I.screen_loc = ui_inv3
						else
							return
					screenmob.client.screen += I
		else
			for(var/obj/item/I in R.held_items)
				screenmob.client.screen -= I
