/datum/admins/proc/access_news_network() //MARKER
	set category = "Admin.Events"
	set name = "Access Newscaster Network"
	set desc = "Allows you to view, add and edit news feeds."

	if (!istype(src, /datum/admins))
		src = usr.client.holder
	if (!istype(src, /datum/admins))
		to_chat(usr, "Error: you are not an admin!", confidential = TRUE)
		return

	var/datum/newspanel/new_newspanel = new

	new_newspanel.ui_interact(usr)
