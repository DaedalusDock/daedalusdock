DEFINE_INTERACTABLE(/obj/machinery/c4_embedded_controller)
/obj/machinery/c4_embedded_controller
	name = "pinpad"
	desc = "A small device with a numerical key pad on the front."

	icon = 'icons/obj/airlock_machines.dmi'
	icon_state = "embedded_base"

	has_disk_slot = TRUE

	/// Ref to our magic internal computer :)
	var/tmp/obj/machinery/computer4/embedded_controller/internal_computer

	var/default_operating_system = /datum/c4_file/terminal_program/operating_system/rtos
	var/radio_frequency

	/// Is our disk slot locked?
	var/panel_locked = TRUE

	var/display_icon = null

	var/display_indicators = NONE

	var/autolink_capable = FALSE

/obj/machinery/c4_embedded_controller/Initialize(mapload)
	. = ..()
	internal_computer = new(src)
	internal_computer.controller = src

	var/obj/item/peripheral/network_card/wireless/netcard = internal_computer.get_peripheral(PERIPHERAL_TYPE_WIRELESS_CARD)
	netcard.frequency = radio_frequency || netcard.frequency
	netcard.set_radio_connection(netcard.frequency)

	var/obj/item/disk/data/floppy/floppy = new(internal_disk)
	floppy.root.try_add_file(new default_operating_system)

	internal_computer.set_inserted_disk(floppy)
	var/datum/c4_file/record/conf_db = new
	conf_db.name = RTOS_CONFIG_FILE
	floppy.root.try_add_file(conf_db)

	if(!mapload)
		internal_computer.post_system()

/obj/machinery/c4_embedded_controller/LateInitialize()
	. = ..()
	var/obj/item/disk/data/floppy/floppy = internal_computer.inserted_disk
	var/datum/c4_file/record/conf_db = floppy.root.get_file(RTOS_CONFIG_FILE)
	setup_default_configuration(conf_db, floppy)
	internal_computer.reboot()

	if(!req_access_txt && !req_one_access_txt)
		return

	var/datum/c4_file/record/access_file = new()
	access_file.name = RTOS_ACCESS_FILE
	internal_computer.inserted_disk.root.try_add_file(access_file)

	if(req_access_txt)
		var/list/actual_fucking_access_please = text2access(req_access_txt)
		access_file.stored_record.fields[RTOS_ACCESS_LIST] = actual_fucking_access_please
		access_file.stored_record.fields[RTOS_ACCESS_MODE] = RTOS_ACCESS_CALC_MODE_ALL
	else //if you define both I'm going for your throat.
		var/list/actual_fucking_access_please = text2access(req_one_access_txt)
		access_file.stored_record.fields[RTOS_ACCESS_LIST] = actual_fucking_access_please
		access_file.stored_record.fields[RTOS_ACCESS_MODE] = RTOS_ACCESS_CALC_MODE_ANY

/obj/machinery/c4_embedded_controller/Destroy()
	QDEL_NULL(internal_computer)
	return ..()

/obj/machinery/embedded_controller/ShiftClick(mob/user)
	. = ..()
	if(!.)
		return

	ui_interact(src)

/obj/machinery/c4_embedded_controller/update_overlays(updates)
	. = ..()
	if(display_icon)
		. += display_icon
	if(display_indicators & RTOS_RED)
		. += "indicator_red"
	if(display_indicators & RTOS_YELLOW)
		. += "indicator_yellow"
	if(display_indicators & RTOS_GREEN)
		. += "indicator_green"

/obj/machinery/c4_embedded_controller/proc/reset_visuals()
	display_icon = null
	display_indicators = NONE
	update_appearance()

/obj/machinery/c4_embedded_controller/examine(mob/user)
	. = ..()
	if(panel_locked)
		. += span_info("The panel is locked.")
	else
		. += span_info("The panel is unlocked.")

/obj/machinery/c4_embedded_controller/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(user.combat_mode)
		return NONE

	if(istype(tool, /obj/item/card/id))
		return try_insert_card(user, tool)

	if(!istype(tool, /obj/item/key/embedded_controller))
		return NONE

	panel_locked = !panel_locked
	playsound(src, 'sound/machines/locktoggle.ogg', 50, TRUE)

	if(panel_locked)
		user.visible_message(span_notice("[user] locks [src]'s panel."), blind_message = span_hear("You hear a metal click."))
	else
		user.visible_message(span_notice("[user] unlocks [src]'s panel."), blind_message = span_hear("You hear a metal click."))

	return ITEM_INTERACT_SUCCESS

/obj/machinery/c4_embedded_controller/proc/try_insert_card(mob/living/user, obj/item/tool)
	var/obj/item/peripheral/card_reader/reader = internal_computer.get_peripheral(PERIPHERAL_TYPE_CARD_READER)
	if(!reader.try_insert_card(user, tool))
		return ITEM_INTERACT_BLOCKING

	playsound(loc, 'sound/machines/cardreader_insert.ogg', 50)
	user.visible_message(span_notice("[user] inserts [tool] into [src]."))
	return ITEM_INTERACT_SUCCESS

/obj/machinery/c4_embedded_controller/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "EmbeddedController")
		ui.open()

/obj/machinery/c4_embedded_controller/ui_act(action, list/params)
	SHOULD_CALL_PARENT(FALSE) // Relaying already
	if(action == "ec_eject_id")
		var/obj/item/peripheral/card_reader/reader = internal_computer.get_peripheral(PERIPHERAL_TYPE_CARD_READER)
		. = reader.try_eject_card(usr)

	return internal_computer.ui_act(arglist(args)) || .

/obj/machinery/c4_embedded_controller/ui_data(mob/user)
	return internal_computer.ui_data(user)

/obj/machinery/c4_embedded_controller/ui_static_data(mob/user)
	return internal_computer.ui_static_data(user)

/obj/machinery/c4_embedded_controller/proc/setup_default_configuration(datum/c4_file/record/conf_db, obj/item/disk/data/floppy)
	return

/obj/machinery/c4_embedded_controller/insert_disk(mob/user, obj/item/disk/data/disk)
	if(panel_locked)
		to_chat(user, span_warning("[src]'s panel is locked."))
		return FALSE
	return internal_computer.insert_disk(user, disk)


/obj/machinery/c4_embedded_controller/screwdriver_act(mob/living/user, obj/item/tool)
	if(panel_locked)
		return FALSE

	var/obj/item/disk/data/floppy/froppy = internal_computer.eject_disk(null) //We aren't legally adjacent.
	if(froppy)
		user.visible_message(
			span_notice("[user] [pick("stuffs", "crams", "stabs")] [tool]'s tip into [src], ejecting [froppy]."),
			blind_message = span_hear("You hear a metallic click, and scraping plastic.")
			)
		if(!user.pickup_item(froppy, user.get_empty_held_index()))
			//Nice job, butterfingers.
			playsound(src, froppy.drop_sound, DROP_SOUND_VOLUME, ignore_walls = FALSE)
		return TRUE

/obj/machinery/c4_embedded_controller/multitool_act(mob/living/user, obj/item/tool)
	if(panel_locked)
		return
	user.visible_message(span_notice("[user] [pick("pulses", "bonks", "frobulates")] [src]'s motherboard with [tool]"))
	internal_computer.reboot()
	playsound(src, SFX_SPARKS, 30)
	user.animate_interact(src, INTERACT_GENERIC, tool)
	return TRUE

/obj/machinery/c4_embedded_controller/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return

	var/obj/item/peripheral/card_reader/reader = internal_computer.get_peripheral(PERIPHERAL_TYPE_CARD_READER)
	if(reader.try_eject_card(usr))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/machinery/computer4/embedded_controller
	default_operating_system = null
	default_programs = null
	default_peripherals = list(
		/obj/item/peripheral/network_card/wireless,
		/obj/item/peripheral/card_reader,
	)

	screen_bg_color = "#69755A"
	screen_font_color = "#000000"
	typing_sfx = SFX_TERMINAL_TYPE //Single button click vs keyboard.

	/// The parent.
	var/obj/machinery/c4_embedded_controller/controller

/obj/machinery/computer4/embedded_controller/Destroy()
	controller = null
	return ..()

/obj/machinery/computer4/embedded_controller/reboot()
	. = ..()
	controller?.reset_visuals()

// da keeeeyyyy

/obj/item/key/embedded_controller
	name = "bell-crested key"
	desc = " There's a small Daedalus logo on the bow."
	icon_state = "ec_key"

/obj/item/key/embedded_controller/examine(mob/user)
	. = ..()
	if(user.mind?.assigned_role?.title == JOB_CHIEF_ENGINEER)
		. += span_alert("Even in space, everything is CH751...")
	else
		var/datum/roll_result/result = user.get_examine_result("embed_control_key_examine")
		if(result?.outcome >= SUCCESS)
			result.do_skill_sound(user)
			. += result.create_tooltip("Debossed on the bow of the key rests \"CH751\", a universal key code. Millions of similar keys float around the pool, with millions more locks to match.", body_only = TRUE)

/obj/item/key/embedded_controller/disco_flavor(mob/living/carbon/human/user, nearby, is_station_level)
	. = ..()
	var/datum/roll_result/result = user.get_examine_result("embed_control_key_disco", only_once = TRUE)
	if(result?.outcome >= SUCCESS)
		result.do_skill_sound(user)
		to_chat(user, result.create_tooltip("A young woman lies still on the couch, her clammy skin reflecting the moonlight piercing the window. On the other side of the door, a man turns a key inside the doorknob."))
