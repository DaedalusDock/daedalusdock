/mob/dead/new_player/Login()
	if(!client)
		return

	if(CONFIG_GET(flag/use_exp_tracking))
		client?.set_exp_from_db()
		client?.set_db_player_flags()
		if(!client)
			// client disconnected during one of the db queries
			return FALSE

	if(!mind)
		mind = new /datum/mind(key)
		mind.active = TRUE
		mind.set_current(src)

	var/boot_this_guy
	if(CONFIG_GET(flag/panic_bunker) && client.check_panic_bunker())
		boot_this_guy = TRUE

	. = ..()
	if(!. || !client)
		return FALSE

	if(boot_this_guy)
		qdel(client)
		return FALSE

	var/motd = global.config.motd
	if(motd)
		to_chat(src, "<div class=\"motd\">[motd]</div>", handle_whitespace=FALSE)

	if(GLOB.admin_notice)
		to_chat(src, span_notice("<b>Admin Notice:</b>\n \t [GLOB.admin_notice]"))

	var/spc = CONFIG_GET(number/soft_popcap)
	if(spc && living_player_count() >= spc)
		to_chat(src, span_notice("<b>Server Notice:</b>\n \t [CONFIG_GET(string/soft_popcap_message)]"))

	sight |= SEE_TURFS

	client.playtitlemusic()
	var/datum/asset/asset_datum = get_asset_datum(/datum/asset/simple/lobby)
	asset_datum.send(client)
	if(!client) // client disconnected during asset transit
		return FALSE

	// The parent call for Login() may do a bunch of stuff, like add verbs.
	// Delaying the register_for_interview until the very end makes sure it can clean everything up
	// and set the player's client up for interview.
	if(client.restricted_mode)
		client.strip_verbs()

		if(CONFIG_GET(flag/panic_bunker_interview))
			register_for_interview()
		else
			add_verb(client, /client/verb/ooc, bypass_restricted = TRUE)
			npp.restricted_client_panel()
		return

	npp.open()

	if(SSticker.current_state < GAME_STATE_SETTING_UP)
		var/tl = SSticker.GetTimeLeft()
		to_chat(src, "Please set up your character and select \"Ready\". The game will start [tl > 0 ? "in about [DisplayTimeText(tl)]" : "soon"].")
