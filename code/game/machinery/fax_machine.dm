/// --- Fax Machines. ---
// Sprite ported from oldbases with fax machines (Paradise, baystaion, vgstation).

/// GLOB list of all fax machines.
GLOBAL_LIST_EMPTY(fax_machines)

/// Cooldown for fax time between faxes.
#define FAX_COOLDOWN_TIME 3 MINUTES

/// The time between alerts that the machine contains an unread message.
#define FAX_UNREAD_ALERT_TIME 3 MINUTES

/// The max amount of chars displayed in a fax message in the UI
#define MAX_DISPLAYED_PAPER_CHARS 475

// States of success or failure for paperwork.
#define PAPERWORK_SUCCESS 0
#define FAIL_NO_ANSWER 1
#define FAIL_NO_STAMP 2
#define FAIL_QUESTION_WRONG 3
#define FAIL_NOT_DENIED 4
#define FAIL_INCORRECTLY_DENIED 5

/// VV dropdowns for the fax machine
#define VV_SEND_FAX "send_fax"
#define VV_SEND_MARKED_FAX "send_marked_fax"

/// Fax machine design, for techwebs.
/datum/design/board/fax_machine
	name = "Machine Board (Fax Machine Board)"
	desc = "The circuit board for a Fax Machine."
	id = "fax_machine"
	build_path = /obj/item/circuitboard/machine/fax_machine
	category = list("Misc. Machinery")
	mapload_design_flags = DESIGN_FAB_SERVICE | DESIGN_FAB_SECURITY | DESIGN_FAB_SUPPLY

/// Fax machine circuit.
/obj/item/circuitboard/machine/fax_machine
	name = "Fax Machine (Machine Board)"
	greyscale_colors = CIRCUIT_COLOR_COMMAND
	build_path = /obj/machinery/fax_machine
	req_components = list(
		/obj/item/stack/sheet/mineral/silver = 1,
		/obj/item/stack/sheet/glass = 1,
		/obj/item/stock_parts/micro_laser = 1,
		)

/// Fax machine. Sends messages, receives messages, sends paperwork, receives paperwork.
/obj/machinery/fax_machine
	name = "fax machine"
	desc = "A machine made to send faxes and process paperwork. You unbelievably boring person."
	icon = 'icons/obj/machines/fax.dmi'
	base_icon_state = "fax"
	icon_state = "fax"
	idle_power_usage = 10
	active_power_usage = 100
	circuit = /obj/item/circuitboard/machine/fax_machine
	/// Whether this machine can send faxes
	var/sending_enabled = TRUE
	/// Whether this machine can receive faxes
	var/receiving_enabled = TRUE
	/// Whether this fax machine is locked.
	var/locked = TRUE
	/// Whether this fax machine can receive paperwork to process on SSeconomy ticks.
	var/can_receive_paperwork = TRUE
	/// Whether we have an unread message
	var/unread_message = FALSE
	/// The area string this fax machine is set to.
	var/room_tag
	/// The paper stored that we can send to admins. Reference to something in our contents.
	var/obj/item/paper/stored_paper
	/// The paper received that was sent FROM admins. Reference to something in our contents.
	var/obj/item/paper/received_paper
	/// List of all paperwork we have in this fax machine. List of references to things in our contents.
	var/list/obj/item/paper/processed/received_paperwork
	/// Max amount of paperwork we can hold. Any more and the UI gets less readable.
	var/max_paperwork = 8
	/// Cooldown between sending faxes
	COOLDOWN_DECLARE(fax_cooldown)

/obj/machinery/fax_machine/Initialize()
	. = ..()
	GLOB.fax_machines += src
	set_room_tag(TRUE)
	wires = new /datum/wires/fax(src)

/obj/machinery/fax_machine/Destroy()
	QDEL_NULL(stored_paper)
	QDEL_NULL(received_paper)
	QDEL_LAZYLIST(received_paperwork)

	GLOB.fax_machines -= src
	return ..()

/obj/machinery/fax_machine/on_deconstruction()
	eject_stored_paper()
	eject_all_paperwork()
	eject_received_paper()

	return ..()

/obj/machinery/fax_machine/recieving_disabled
	can_receive_paperwork = FALSE

/obj/machinery/fax_machine/full/Initialize()
	. = ..()
	for(var/i in 1 to max_paperwork)
		if(LAZYLEN(received_paperwork) >= max_paperwork)
			continue
		LAZYADD(received_paperwork, generate_paperwork(src))

/obj/machinery/fax_machine/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "FaxMachine", name)
		ui.open()

/obj/machinery/fax_machine/ui_state(mob/user)
	if(!anchored)
		return UI_DISABLED
	return GLOB.physical_state

/obj/machinery/fax_machine/ui_data(mob/user)
	var/list/data = list()

	var/emagged = obj_flags & EMAGGED
	var/list/all_received_paperwork = list()
	for(var/I in 1 to length(received_paperwork))
		var/obj/item/paper/processed/paper = received_paperwork[I]
		var/list/found_paper_data = list()
		found_paper_data["title"] = paper.name
		found_paper_data["contents"] = text_preview(remove_all_tags(paper.info), MAX_DISPLAYED_PAPER_CHARS)
		found_paper_data["required_answer"] = paper.required_question
		found_paper_data["ref"] = REF(paper)
		found_paper_data["num"] = I
		all_received_paperwork += list(found_paper_data)
	data["received_paperwork"] = all_received_paperwork

	var/list/stored_paper_data = list()
	if(stored_paper)
		stored_paper_data["contents"] = text_preview(remove_all_tags(stored_paper.info), MAX_DISPLAYED_PAPER_CHARS)
		stored_paper_data["ref"] = REF(stored_paper_data)
	data["stored_paper"] = stored_paper_data

	var/list/received_paper_data = list()
	if(received_paper)
		received_paper_data["title"] = received_paper.name
		received_paper_data["contents"] = text_preview(remove_all_tags(received_paper.info), MAX_DISPLAYED_PAPER_CHARS)
		received_paper_data["source"] = received_paper.was_faxed_from
		received_paper_data["ref"] = REF(received_paper)
	data["received_paper"] = received_paper_data

	if(emagged)
		var/emagged_text = ""
		for(var/i in 1 to rand(4, 7))
			emagged_text += pick("!","@","#","$","%","^","&")
		data["display_name"] = emagged_text
	else if(ishuman(user))
		var/mob/living/carbon/human/human_user = user
		var/obj/item/card/id/our_id = human_user.wear_id?.GetID()
		data["display_name"] = our_id?.registered_name || "\[REDACTED\]"
	else if(issilicon(user))
		data["display_name"] = user.real_name
	else
		data["display_name"] = "\[REDACTED\]"

	data["can_send_cc_messages"] = (allowed(user) || emagged) && COOLDOWN_FINISHED(src, fax_cooldown)
	data["can_receive"] = can_receive_paperwork
	data["emagged"] = emagged
	data["unread_message"] = unread_message

	var/admin_destination = (emagged ? SYNDICATE_FAX_MACHINE : CENTCOM_FAX_MACHINE)
	var/list/possible_destinations = list()
	possible_destinations += admin_destination
	for(var/obj/machinery/fax_machine/machine as anything in GLOB.fax_machines)
		if(machine == src)
			continue
		if(!machine.room_tag)
			continue
		if(machine.room_tag in possible_destinations)
			continue
		possible_destinations += machine.room_tag
	data["destination_options"] = possible_destinations
	data["default_destination"] = admin_destination

	return data

/obj/machinery/fax_machine/ui_act(action, list/params)
	. = ..()
	if(.)
		return

	switch(action)
		if("un_emag_machine")
			to_chat(usr, span_notice("You restore [src]'s routing information to [CENTCOM_FAX_MACHINE]."))
			obj_flags &= ~EMAGGED

		if("toggle_recieving")
			can_receive_paperwork = !can_receive_paperwork

		if("read_last_received")
			unread_message = FALSE

		if("send_stored_paper")
			send_stored_paper(usr, params["destination_machine"])

		if("print_received_paper")
			eject_received_paper(usr, FALSE)

		if("print_all_paperwork")
			eject_all_paperwork_with_delay(usr)

		if("print_select_paperwork")
			var/obj/item/paper/processed/paper = locate(params["ref"]) in received_paperwork
			eject_select_paperwork(usr, paper, FALSE)

		if("delete_select_paperwork")
			var/obj/item/paper/processed/paper = locate(params["ref"]) in received_paperwork
			delete_select_paperwork(paper)

		if("check_paper")
			var/obj/item/paper/processed/paper = locate(params["ref"]) in received_paperwork
			check_paperwork(paper, usr)

	return TRUE

/obj/machinery/fax_machine/default_deconstruction_screwdriver(mob/user, icon_state_open, icon_state_closed, obj/item/screwdriver)
	var/is_user_robot = issilicon(user)
	if(!panel_open && locked && !is_user_robot)
		balloon_alert(user, "panel locked!")
		return FALSE

	. = ..()
	if(. && panel_open && locked && is_user_robot)
		balloon_alert(user, "panel lock bypassed")

/obj/machinery/fax_machine/can_be_unfasten_wrench(mob/user, silent)
	if(!panel_open)
		if(!silent)
			to_chat(user, span_warning("You need to open the maintenance panel to access the bolts!"))
		return FAILED_UNFASTEN // "failed" instead of "cant", because failed stops afterattacks
	return ..()

/obj/machinery/fax_machine/default_unfasten_wrench(mob/user, obj/item/wrench, time = 20)
	. = ..()
	if(. == SUCCESSFUL_UNFASTEN)
		set_room_tag(anchored) // Sets the room tag to NULL if unanchored, or the area name if anchored

/obj/machinery/fax_machine/attackby(obj/item/weapon, mob/user, params)
	if(!isliving(user))
		return ..()

	if(weapon.tool_behaviour == TOOL_SCREWDRIVER)
		if(default_deconstruction_screwdriver(user, "[initial(icon_state)]_open", initial(icon_state), weapon))
			update_appearance()
		return TRUE

	if(default_deconstruction_crowbar(weapon))
		return TRUE

	if(default_unfasten_wrench(user, weapon, 3 SECONDS))
		return TRUE

	if(panel_open && is_wire_tool(weapon))
		wires.interact(user)
		return TRUE

	if(istype(weapon, /obj/item/paper/processed))
		insert_processed_paper(weapon, user)
		return TRUE

	else if(istype(weapon, /obj/item/paper))
		var/obj/item/paper/inserted_paper = weapon
		if(inserted_paper.was_faxed_from in GLOB.admin_fax_destinations)
			to_chat(user, span_warning("Papers from [inserted_paper.was_faxed_from] cannot be re-faxed."))
			return TRUE
		else
			insert_paper(inserted_paper, user)
			return TRUE
	var/obj/item/ID = weapon.GetID()
	if(check_access(ID) && !panel_open)
		locked = !locked
		playsound(src, 'sound/machines/terminal_eject.ogg', 30, TRUE)
		balloon_alert(user, "panel [locked ? "locked" : "unlocked"]")
		return TRUE

	return ..()

/obj/machinery/fax_machine/attack_hand(mob/user, list/modifiers)
	if(LAZYACCESS(modifiers, RIGHT_CLICK))
		eject_stored_paper(user, FALSE)
		return TRUE
	return ..()

/obj/machinery/fax_machine/examine(mob/user)
	. = ..()
	if(stored_paper)
		. += span_notice("Right click to remove the stored fax.")
	. += span_notice("The maintenance panel is [locked ? "locked" : "unlocked"]. Swipe your ID card to [locked ? "unlock" : "lock"] it.")

/*
 * Set this fax machine's [room_tag] to the current room or null.
 *
 * if to_curr_room is TRUE, sets the room_tag to the current area's name.
 * otherwise, sets it to null.
 */
/obj/machinery/fax_machine/proc/set_room_tag(to_curr_room = TRUE)
	if(to_curr_room)
		room_tag = get_area_name(src, TRUE) // no proper or improper tags on this
		name = "[get_area_name(src, FALSE)] [name]"
	else
		room_tag = null
		name = initial(name)

/*
 * Send [stored_paper] from [user] to [destinatoin].
 * if [destination] is an admin fax machine, send it to admins.
 * Otherwise, send it to the corresponding fax machine in the world, looking for (room_tag == [destination])
 *
 * returns TRUE if the fax was sent.
 */
/obj/machinery/fax_machine/proc/send_stored_paper(mob/living/user, destination)
	if((machine_stat & (NOPOWER|BROKEN)) && !(interaction_flags_machine & INTERACT_MACHINE_OFFLINE))
		return FALSE

	if(!sending_enabled)
		balloon_alert_to_viewers("[src] cannot send faxes")
		playsound(src, 'sound/machines/terminal_error.ogg', 50)
		return FALSE

	if(!stored_paper || !length(stored_paper.info) || !COOLDOWN_FINISHED(src, fax_cooldown))
		balloon_alert_to_viewers("fax failed to send")
		playsound(src, 'sound/machines/terminal_error.ogg', 50)
		return FALSE

	var/message = "INCOMING FAX: FROM \[[station_name()]\], AUTHOR \[[user]\]: "
	message += remove_all_tags(stored_paper.info)
	message += LAZYLEN(stored_paper.stamped) ? " --- The message is stamped." : ""
	if(destination in GLOB.admin_fax_destinations)
		message_admins("[ADMIN_LOOKUPFLW(user)] sent a fax to [destination].")
		send_fax_to_admins(user, message, ((obj_flags & EMAGGED) ? "crimson" : "orange"), destination)
	else
		var/found_a_machine = FALSE
		for(var/obj/machinery/fax_machine/machine as anything in GLOB.fax_machines)
			if(machine == src || machine.room_tag == room_tag)
				continue
			if(!machine.room_tag)
				continue
			if(machine.room_tag == destination && machine.receive_paper(stored_paper.fax_copy(), room_tag))
				message_admins("[ADMIN_LOOKUPFLW(user)] sent a fax to [ADMIN_VERBOSEJMP(machine)].")
				found_a_machine = TRUE
				break
		if(!found_a_machine)
			balloon_alert_to_viewers("destination not found")
			playsound(src, 'sound/machines/terminal_error.ogg', 50)
			return FALSE

	to_chat(user, span_notice("Fax sent. Dispensing paper for personal record keeping. Thank you for using the Nanotrasen Approved Faxing Device!"))
	eject_stored_paper()
	playsound(src, 'sound/machines/terminal_processing.ogg', 35)
	COOLDOWN_START(src, fax_cooldown, FAX_COOLDOWN_TIME)
	use_power(active_power_usage)

/*
 * Send the content of admin faxes to admins directly.
 * [sender] - the mob who sent the fax
 * [fax_contents] - the contents of the fax
 * [destination_color] - the color of the span that encompasses [destination_string]
 * [destination_string] - the string that says where this fax was sent (syndiate or centcom)
 */
/obj/machinery/fax_machine/proc/send_fax_to_admins(mob/sender, fax_contents, destination_color, destination_string)
	var/message = copytext_char(sanitize(fax_contents), 1, MAX_MESSAGE_LEN)
	deadchat_broadcast(" has sent a fax to: [destination_string], with the message: \"[message]\" at [span_name("[get_area_name(sender, TRUE)]")].", span_name("[sender.real_name]"), sender, message_type = DEADCHAT_ANNOUNCEMENT)
	to_chat(GLOB.admins, span_adminnotice("<b><font color=[destination_color]>FAX TO [destination_string]: </font>[ADMIN_FULLMONTY(sender)] [ADMIN_FAX_REPLY(src)]:</b> [message]"), confidential = TRUE)

/obj/machinery/fax_machine/vv_get_dropdown()
	. = ..()
	VV_DROPDOWN_OPTION(VV_SEND_FAX, "Send new fax")
	VV_DROPDOWN_OPTION(VV_SEND_MARKED_FAX, "Send marked paper as fax")

/obj/machinery/fax_machine/vv_do_topic(list/href_list)
	. = ..()
	if(href_list[VV_SEND_FAX])
		admin_create_fax(usr)
	if(href_list[VV_SEND_MARKED_FAX])
		var/obj/item/paper/marked_paper = usr.client?.holder?.marked_datum
		if(isnull(marked_paper))
			to_chat(usr, span_warning("You have no marked datum, or something went wrong."))
			return
		if(!istype(marked_paper))
			to_chat(usr, span_warning("You don't have a paper marked."))
			return
		if(tgui_alert(usr, "Do you want to send '[marked_paper]' to [src]?", "Send Fax", list("Yes", "Cancel")) == "Cancel")
			return
		var/source = input(usr, "Who's sending this fax? Leave blank for default name", "Send Fax") as null | text
		if(receive_paper(marked_paper, source, TRUE))
			to_chat(usr, span_notice("Fax successfully sent."))
		else
			to_chat(usr, span_danger("Fax failed to send."))

/*
 * Admin proc to create a fax (a message) and send it to this machine.
 * [user] is the admin.
 */
/obj/machinery/fax_machine/proc/admin_create_fax(mob/user)
	if(!check_rights_for(user.client, R_ADMIN))
		return

	var/obj/item/paper/sent_paper = new()
	var/fax = stripped_multiline_input(user, "Write your fax to send here.", "Send Fax", max_length = MAX_MESSAGE_LEN)
	if(length(fax))
		sent_paper.info = fax
	else
		to_chat(user, span_warning("No contents inputted."))
		qdel(sent_paper)
		return

	var/title = input(user, "Write the paper's title here. Leave blank for default title (\"paper\")", "Send Fax") as null | text
	if(title)
		sent_paper.name = fax

	var/source = input(user, "Who's sending this fax? Leave blank for default name (\"Central Command\", or \"the Syndicate\" if emagged)", "Send Fax") as null | text
	sent_paper.update_appearance()
	if(receive_paper(sent_paper, source, TRUE))
		to_chat(user, span_notice("Fax successfully sent."))
	else
		to_chat(user, span_danger("Fax failed to send."))
		qdel(sent_paper)

/*
 * receive [new_paper] as a fax from [source].
 * Ejects any [received_paper] we may have, and sets [received_paper] to [new_paper].
 * If [source] is null or empty, we go with a preset name.
 *
 * [new_paper] is a reference to an instantiated, written paper.
 * [source] is a string of the location or company sending the fax.
 * [forced] will always send the fax if TRUE even if the machine is broken, unpowered, or disabled.
 *
 * returns TRUE if the fax was received.
 */
/obj/machinery/fax_machine/proc/receive_paper(obj/item/paper/new_paper, source, forced = FALSE)
	if(!new_paper)
		return FALSE

	if(!forced)
		if((machine_stat & (NOPOWER|BROKEN)) && !(interaction_flags_machine & INTERACT_MACHINE_OFFLINE))
			return FALSE

		if(!receiving_enabled)
			return FALSE

	if(isnull(source) || !length(source))
		source = (obj_flags & EMAGGED ? "employer" : CENTCOM_FAX_MACHINE)
	if(received_paper)
		eject_received_paper()

	new_paper.name = "fax - [new_paper.name]"
	new_paper.was_faxed_from = source
	received_paper = new_paper
	received_paper.forceMove(src)
	unread_message = TRUE
	alert_received_paper(source)

	return TRUE

/*
 * Display an alert that [src] received a message from [source].
 * [source] is a string of a location or company.
 */
/obj/machinery/fax_machine/proc/alert_received_paper(source)
	if((machine_stat & (NOPOWER|BROKEN)) && !(interaction_flags_machine & INTERACT_MACHINE_OFFLINE))
		return FALSE

	if(!unread_message)
		return FALSE

	say("Fax received from [source]!")
	playsound(src, 'sound/machines/terminal_processing.ogg', 50)
	addtimer(CALLBACK(src, PROC_REF(alert_received_paper), source), FAX_UNREAD_ALERT_TIME)

/*
 * Check if [checked_paper] has had its paperwork fulfilled successfully.
 * [checked_paper] is an instantiated paper.
 * [user] is the mob who triggered the check.
 *
 * returns TRUE if the paperwork was correct, FALSE otherwise.
 */
/obj/machinery/fax_machine/proc/check_paperwork(obj/item/paper/processed/checked_paper, mob/living/user)
	var/paper_check = checked_paper.check_requirements()
	var/message = ""
	switch(paper_check)
		if(FAIL_NO_STAMP)
			message = "Protocal violated. Paperwork not stamped by official."
		if(FAIL_NOT_DENIED)
			message = "Protocal violated. Discrepancies detected in submitted paperwork."
		if(FAIL_INCORRECTLY_DENIED)
			message = "Protocal violated. No discrepancies detected in submitted paperwork, yet paperwork was denied."
		if(FAIL_NO_ANSWER)
			message = "Protocal violated. Paperwork unprocessed."
		if(FAIL_QUESTION_WRONG)
			message = "Protocal violated. Paperwork not processed correctly."
		else
			message = "Paperwork successfuly processed. Dispensing payment."

	say(message)
	if(paper_check)
		playsound(src, 'sound/machines/buzz-sigh.ogg', 50)
		. = FALSE
	else
		if(prob(50))
			new /obj/item/stack/spacecash/c10(drop_location())
		else
			new /obj/item/stack/spacecash/c20(drop_location())

		playsound(src, 'sound/machines/ping.ogg', 60)
		. = TRUE

	LAZYREMOVE(received_paperwork, checked_paper)
	qdel(checked_paper)
	use_power(active_power_usage)

/*
 * Insert [inserted_paper] into the fax machine, adding it to the list of [received_paperwork] if possible.
 * [inserted_paper] is an instantiated paper.
 * [user] is the mob placing the paper into the machine.
 */
/obj/machinery/fax_machine/proc/insert_processed_paper(obj/item/paper/processed/inserted_paper, mob/living/user)
	if(LAZYLEN(received_paperwork) >= max_paperwork)
		to_chat(user, span_danger("You cannot place [inserted_paper] into [src], it's full."))
		return

	inserted_paper.forceMove(src)
	LAZYADD(received_paperwork, inserted_paper)
	z_flick("fax_send", src)
	to_chat(user, span_notice("You insert [inserted_paper] into [src], readying it for processing."))

/*
 * Insert [inserted_paper] into the fax machine, setting [stored_paper] to [inserted_paper].
 * [inserted_paper] is an instantiated paper.
 * [user] is the mob placing the paper into the machine.
 */
/obj/machinery/fax_machine/proc/insert_paper(obj/item/paper/inserted_paper, mob/living/user)
	inserted_paper.forceMove(src)
	if(stored_paper)
		to_chat(user, span_notice("You take out [stored_paper] from [src] and insert [inserted_paper]."))
		eject_stored_paper(user)
	else
		to_chat(user, span_notice("You insert [inserted_paper] into [src]."))

	z_flick("fax_send", src)
	stored_paper = inserted_paper

/*
 * Call [proc/eject_select_paperwork] on all papers in [received_paperwork].
 * if [user] is specified, pass it into [proc/eject_select_paperwork],
 * dispensing as much paper into their hands as possible.
 *
 * Then, null the list after all is done.
 */
/obj/machinery/fax_machine/proc/eject_all_paperwork(mob/living/user)
	for(var/obj/item/paper/processed/paper as anything in received_paperwork)
		eject_select_paperwork(user, paper)
	LAZYNULL(received_paperwork)

/*
 * Recursively call [proc/eject_select_paperwork] on the first index
 * of [received_paperwork], applying a delay in between each call.
 *
 * If [user] is specified, pass [user] into the [proc/eject_select_paperwork] call,
 * dispensing as much paper into their hands as possible.
 */
/obj/machinery/fax_machine/proc/eject_all_paperwork_with_delay(mob/living/user)
	if(!LAZYLEN(received_paperwork))
		SStgui.update_uis(src)
		return

	if(received_paperwork[1])
		eject_select_paperwork(user, received_paperwork[1], FALSE)
		addtimer(CALLBACK(src, PROC_REF(eject_all_paperwork_with_delay), user), 2 SECONDS)

/*
 * Remove [paper] from the list of [received_paperwork] and
 * dispense it into [user]'s hands, if user is supplied.
 *
 * [paper] must be an instantiated paper already in [list/received_paperwork].
 * if [silent] is FALSE, give feedback and play a sound.
 */
/obj/machinery/fax_machine/proc/eject_select_paperwork(mob/living/user, obj/item/paper/processed/paper, silent = TRUE)
	if(!paper)
		return

	if(user && user.CanReach(src))
		user.put_in_hands(paper)
	else
		paper.forceMove(drop_location())
	LAZYREMOVE(received_paperwork, paper)
	if(!silent)
		z_flick("fax_receive", src)
		playsound(src, 'sound/machines/ding.ogg', 50)
		use_power(active_power_usage)

/*
 * Remove [paper] from the list of [received_paperwork] and delete it.
 * [paper] must be an instantiated paper in [list/received_paperwork].
 */
/obj/machinery/fax_machine/proc/delete_select_paperwork(obj/item/paper/processed/paper)
	LAZYREMOVE(received_paperwork, paper)
	qdel(paper)
	use_power(active_power_usage)

/*
 * Eject the instance [stored_paper].
 * if [user] is supplied, attempt to put it in their hands. Otherwise, drop it to the floor.
 *
 * if [silent] is FALSE, give feedback to people nearbly that a paper was removed.
 */
/obj/machinery/fax_machine/proc/eject_stored_paper(mob/living/user, silent = TRUE)
	if(!stored_paper)
		return

	if(!silent)
		z_flick("fax_receive", src)
		balloon_alert_to_viewers("removed [stored_paper]")
	if(user && user.CanReach(src))
		user.put_in_hands(stored_paper)
	else
		stored_paper.forceMove(drop_location())
	stored_paper = null
	SStgui.update_uis(src)

/*
 * Eject the instance [received_paper].
 * if [user] is supplied, attempt to put it in their hands. Otherwise, drop it to the floor.
 *
 * if [silent] is FALSE, give feedback to people nearbly that a paper was removed.
 */
/obj/machinery/fax_machine/proc/eject_received_paper(mob/living/user, silent = TRUE)
	if(!received_paper)
		return

	if(!silent)
		z_flick("fax_receive", src)
		balloon_alert_to_viewers("removed [received_paper]")
	if(user && user.CanReach(src))
		user.put_in_hands(received_paper)
	else
		received_paper.forceMove(drop_location())
	received_paper = null
	SStgui.update_uis(src)

/// Sends messages to the syndicate when emagged.
/obj/machinery/fax_machine/emag_act(mob/user)
	if(obj_flags & EMAGGED)
		return

	balloon_alert(user, "routing address overridden")
	playsound(src, 'sound/machines/terminal_alert.ogg', 25)
	obj_flags |= EMAGGED

// ----- Paper definitions and subtypes for interactions with the fax machine. -----
/*
 * Make a new instance of [/obj/item/paper] with most of the same vars as [src].
 * Works better / copies more things than the pre-existing [proc/copy] for paper.
 * [paper_to_copy] - an instance of paper.
 *
 * returns a new instance of [/obj/item/paper].
 */
/obj/item/paper/proc/fax_copy()
	var/obj/item/paper/new_paper = new()

	new_paper.name = name
	new_paper.desc = desc
	new_paper.info = info
	new_paper.color = color
	new_paper.stamps = LAZYLISTDUPLICATE(stamps)
	new_paper.stamped = LAZYLISTDUPLICATE(stamped)
	new_paper.form_fields = form_fields.Copy()
	new_paper.field_counter = field_counter
	new_paper.update_icon_state()
	copy_overlays(new_paper, TRUE)

	return new_paper

/obj/item/paper/processed
	name = "\proper classified paperwork"
	desc = "Some classified paperwork sent by the big men themselves."
	/// Assoc list of data related to our paper.
	var/list/paper_data
	/// Question required to be answered for this paper to be marked as correct.
	var/required_question
	/// Answer requires for this paper to be marked as correct.
	var/needed_answer
	/// The last answer supplied by a user.
	var/last_answer

/obj/item/paper/processed/attackby(obj/item/weapon, mob/living/user, params)
	if(istype(weapon, /obj/item/pen) || istype(weapon, /obj/item/toy/crayon))
		INVOKE_ASYNC(src, PROC_REF(answer_question), user)
		return TRUE

	return ..()

/*
 * Called async - Opens up an input for the user to answer the required question.
 */
/obj/item/paper/processed/proc/answer_question(mob/living/user)
	if(!required_question)
		return

	last_answer = tgui_input_text(user, required_question, "Paperwork", last_answer)

/*
 * Generate a random question based on our paper's data.
 * This question must be answered by a user for the paper to be marked as correct.
 */
/obj/item/paper/processed/proc/generate_requirements()
	var/list/shuffled_data = shuffle(paper_data)
	for(var/data in shuffled_data)
		if(!shuffled_data[data])
			continue

		needed_answer = shuffled_data[data]
		switch(data)
			if("subject_one")
				required_question = "Which corporation was the first mentioned in the document?"
			if("subject_two")
				required_question = "Which corporation was the second mentioned in the document?"
			if("station")
				required_question = "Which space station was mentioned in the document?"
			if("time_period")
				required_question = "What date was this document created?"
			if("occasion")
				required_question = "What type of document is this paperwork for?"
			if("victim")
				required_question = "What was the name of the victim in the document?"
			if("victim_species")
				required_question = "What was the species of the victim in the document?"
			if("errors_present", "redacts_present")
				continue
			else
				required_question = "This paperwork is incompletable. Who made this garbage?"

		if(required_question)
			return

/*
 * Check if our paper's been  processed correctly.
 *
 * Returns a failure state if it was not (a truthy value, 1+) or a success state if it was (falsy, 0)
 */
/obj/item/paper/processed/proc/check_requirements()
	if(isnull(last_answer))
		return FAIL_NO_ANSWER
	if(!LAZYLEN(stamped))
		return FAIL_NO_STAMP
	if(paper_data["redacts_present"])
		return PAPERWORK_SUCCESS

	if(paper_data["errors_present"])
		if(!("stamp-deny" in stamped))
			return FAIL_NOT_DENIED
	else
		if("stamp-deny" in stamped)
			return FAIL_INCORRECTLY_DENIED
		if(!findtext(last_answer, needed_answer))
			return FAIL_QUESTION_WRONG

	return PAPERWORK_SUCCESS

#undef FAX_COOLDOWN_TIME
#undef FAX_UNREAD_ALERT_TIME
#undef MAX_DISPLAYED_PAPER_CHARS

#undef PAPERWORK_SUCCESS
#undef FAIL_NO_ANSWER
#undef FAIL_NO_STAMP
#undef FAIL_QUESTION_WRONG
#undef FAIL_NOT_DENIED
#undef FAIL_INCORRECTLY_DENIED

#undef VV_SEND_FAX
#undef VV_SEND_MARKED_FAX
