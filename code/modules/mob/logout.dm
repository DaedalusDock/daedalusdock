/mob/Logout()
	SEND_SIGNAL(src, COMSIG_MOB_LOGOUT)
	log_message("[key_name(src)] is no longer owning mob [src]([src.type])", LOG_OWNERSHIP)
	SStgui.on_logout(src)
	unset_machine()
	remove_from_player_list()

	//Reload info huds
	for(var/obj/effect/abstract/info_tag/tag as anything in seeing_info_tags)
		tag.hide_from(client)

	..()

	if(loc)
		loc.on_log(FALSE)

	become_uncliented()

	return TRUE
