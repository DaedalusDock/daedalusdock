/datum/admin_help
	var/handler
	var/list/_interactions_player

//Let the initiator know their ahelp is being handled
/datum/admin_help/proc/HandleIssue(key_name = key_name_admin(usr))
	if(state != AHELP_ACTIVE)
		return

	if(handler && handler == usr.ckey) // No need to handle it twice as the same person ;)
		return

	if(handler && handler != usr.ckey)
		var/response = tgui_alert(usr, "This ticket is already being handled by [handler]. Do you want to continue?", "Ticket already assigned", list("Yes", "No"))
		if(!response || response == "No")
			return

	var/msg = span_adminhelp("Your ticket is now being handled by [usr?.client?.holder?.fakekey ? usr?.client?.holder?.fakekey : "an administrator"]! Please wait while they type their response and/or gather relevant information.")

	if(initiator)
		to_chat(initiator, msg)

	SSblackbox.record_feedback("tally", "ahelp_stats", 1, "handling")
	msg = "Ticket [TicketHref("#[id]")] is being handled by [key_name]"
	message_admins(msg)
	log_admin_private(msg)
	AddInteraction("Being handled by [key_name]")
	AddInteractionPlayer("Being handled by [key_name_admin(usr, FALSE)]")

	handler = "[usr.ckey]"

/datum/admin_help/proc/PlayerTicketPanel()
	var/datum/browser/browser = new(usr, "ahelp[id]", "Ticket #[id]")
	var/list/dat = list()
	dat += "State: "
	switch(state)
		if(AHELP_ACTIVE)
			dat += "<font color='red'>OPEN</font></b>"
		if(AHELP_RESOLVED)
			dat += "<font color='green'>RESOLVED</font></b>"
		if(AHELP_CLOSED)
			dat += "CLOSED</b>"
		else
			dat += "UNKNOWN</b>"
	dat += "<br><br>Opened at: [gameTimestamp("hh:mm:ss", opened_at)] (Approx [DisplayTimeText(world.time - opened_at)] ago)"
	if(closed_at)
		dat += "<br>Closed at: [gameTimestamp("hh:mm:ss", closed_at)] (Approx [DisplayTimeText(world.time - closed_at)] ago)"
	dat += "<br><br>"
	dat += "<br><fieldset class='computerPaneSimple'><legend>Activity</legend>"
	for(var/I in _interactions_player)
		dat += "[I]<br>"
	dat += "</fieldset>"

	browser.add_head_content("<title>Player Ticket #[id]</title>")
	browser.set_content(dat.Join())
	browser.open()

/datum/admin_help/proc/AddInteractionPlayer(formatted_message)
	_interactions_player += "[time_stamp()]: [formatted_message]"
