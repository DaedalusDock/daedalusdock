

// Stub header, Procs defined in rest of directory.
/datum/player_panel_renderer
//This is probably unnecessary, but juuust in case.
GENERAL_PROTECT_DATUM(/datum/player_panel_renderer)

/datum/admins/proc/show_player_panel(mob/M in GLOB.mob_list)
	set category = "Admin.Game"
	set name = "Show Player Panel"
	set desc="Edit player (respawn, ban, heal, etc)"

	if(!check_rights())
		return

	if(!M)
		to_chat(usr, span_warning("You seem to be selecting a mob that doesn't exist anymore."), confidential = TRUE)
		return

	log_admin("[key_name(usr)] checked the individual player panel for [key_name(M)][isobserver(usr)?"":" while in game"].")

	var/datum/player_panel_renderer/renderer = new
	var/static/datum/asset/simple/namespaced/player_panel/asset = get_asset_datum(/datum/asset/simple/namespaced/player_panel)
	asset.send(usr)

	var/body = {"
	<html>
		<head>
			<meta http-equiv='Content-Type' content='text/html; charset=UTF-8'>
			<title>Options for [M.key]</title>
			<link rel='stylesheet' type='text/css' href='[asset.get_url_mappings()["player_panel.css"]]'>
		</head>
		<body>
	"}

	body += renderer.pp_header(M, usr)
	body += renderer.pp_info(M, usr)
	body += renderer.actions_admin(M, usr)
	body += renderer.actions_info(M, usr)

	body += "</body></html>"

	usr << browse(body, "window=adminplayeropts-[REF(M)];size=550x515")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Player Panel") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

	// body += "<body>Options panel for <b>[M]</b>"
	// if(M.client)
	// 	body += " played by <b>[M.client]</b> "
	// 	body += "\[<A href='?_src_=holder;[HrefToken()];editrights=[(GLOB.admin_datums[M.client.ckey] || GLOB.deadmins[M.client.ckey]) ? "rank" : "add"];key=[M.key]'>[M.client.holder ? M.client.holder.rank : "Player"]</A>\]"
	// 	if(CONFIG_GET(flag/use_exp_tracking))
	// 		body += "\[<A href='?_src_=holder;[HrefToken()];getplaytimewindow=[REF(M)]'>" + M.client.get_exp_living(FALSE) + "</a>\]"

	// if(isnewplayer(M))
	// 	body += " <B>Hasn't Entered Game</B> "
	// else
	// 	body += " \[<A href='?_src_=holder;[HrefToken()];revive=[REF(M)]'>Heal</A>\] "


	// if(M.client)
	// 	body += "<br>\[<b>First Seen:</b> [M.client.player_join_date]\]\[<b>Byond account registered on:</b> [M.client.account_join_date]\]"
	// 	body += "<br><br><b>CentCom Galactic Ban DB: </b> "
	// 	if(CONFIG_GET(string/centcom_ban_db))
	// 		body += "<a href='?_src_=holder;[HrefToken()];centcomlookup=[M.client.ckey]'>Search</a>"
	// 	else
	// 		body += "<i>Disabled</i>"
	// 	body += "<br><br><b>Show related accounts by:</b> "
	// 	body += "\[ <a href='?_src_=holder;[HrefToken()];showrelatedacc=cid;client=[REF(M.client)]'>CID</a> | "
	// 	body += "<a href='?_src_=holder;[HrefToken()];showrelatedacc=ip;client=[REF(M.client)]'>IP</a> \]"
	// 	var/full_version = "Unknown"
	// 	if(M.client.byond_version)
	// 		full_version = "[M.client.byond_version].[M.client.byond_build ? M.client.byond_build : "xxx"]"
	// 	body += "<br>\[<b>Byond version:</b> [full_version]\]<br>"
	// 	body += "<br><b>Input Mode:</b> [M.client.hotkeys ? "Using Hotkeys" : "Using Classic Input"]<br>"
	// 	if(isnull(M.client.linked_discord_account))
	// 		body += "<br><b>Linked Discord ID:</b> <code>MISSING RESPONSE DATUM, HAVE THEY JUST JOINED OR IS SQL DISABLED?</code><br>"
	// 	else
	// 		body += "<br><b>Linked Discord ID:</b> <code>[M.client.linked_discord_account.valid ? M.client.linked_discord_account.discord_id : "NONE"]</code><br>"


	// body += "<br><br>\[ "
	// body += "<a href='?_src_=vars;[HrefToken()];Vars=[REF(M)]'>VV</a> - "
	// if(M.mind)
	// 	body += "<a href='?_src_=holder;[HrefToken()];traitor=[REF(M)]'>TP</a> - "
	// 	body += "<a href='?_src_=holder;[HrefToken()];skill=[REF(M)]'>SKILLS</a> - "
	// else
	// 	body += "<a href='?_src_=holder;[HrefToken()];initmind=[REF(M)]'>Init Mind</a> - "
	// if (iscyborg(M))
	// 	body += "<a href='?_src_=holder;[HrefToken()];borgpanel=[REF(M)]'>BP</a> - "


	// if (ishuman(M) && M.mind)
	// 	body += "<a href='?_src_=holder;[HrefToken()];HeadsetMessage=[REF(M)]'>HM</a> - "
	// body += "<a href='?_src_=holder;[HrefToken()];adminplayerobservefollow=[REF(M)]'>FLW</a> - "
	// //Default to client logs if available
	// var/source = LOGSRC_MOB
	// if(M.ckey)
	// 	source = LOGSRC_CKEY
	// body += "<a href='?_src_=holder;[HrefToken()];individuallog=[REF(M)];log_src=[source]'>LOGS</a>\] <br>"

	// body += "<b>Mob type</b> = [M.type]<br><br>"

	// body += "<A href='?_src_=holder;[HrefToken()];boot2=[REF(M)]'>Kick</A> | "
	// if(M.client)
	// 	body += "<A href='?_src_=holder;[HrefToken()];newbankey=[M.key];newbanip=[M.client.address];newbancid=[M.client.computer_id]'>Ban</A> | "
	// else
	// 	body += "<A href='?_src_=holder;[HrefToken()];newbankey=[M.key]'>Ban</A> | "

	// body += "<A href='?_src_=holder;[HrefToken()];showmessageckey=[M.ckey]'>Notes | Messages | Watchlist</A> | "
	// if(M.client)
	// 	body += "| <A href='?_src_=holder;[HrefToken()];sendtoprison=[REF(M)]'>Prison</A> | "
	// 	body += "\ <A href='?_src_=holder;[HrefToken()];sendbacktolobby=[REF(M)]'>Send back to Lobby</A> | "
	// 	var/muted = M.client.prefs.muted
	// 	body += "<br><b>Mute: </b> "
	// 	body += "\[<A href='?_src_=holder;[HrefToken()];mute=[M.ckey];mute_type=[MUTE_IC]'><font color='[(muted & MUTE_IC)?"red":"blue"]'>IC</font></a> | "
	// 	body += "<A href='?_src_=holder;[HrefToken()];mute=[M.ckey];mute_type=[MUTE_OOC]'><font color='[(muted & MUTE_OOC)?"red":"blue"]'>OOC</font></a> | "
	// 	body += "<A href='?_src_=holder;[HrefToken()];mute=[M.ckey];mute_type=[MUTE_PRAY]'><font color='[(muted & MUTE_PRAY)?"red":"blue"]'>PRAY</font></a> | "
	// 	body += "<A href='?_src_=holder;[HrefToken()];mute=[M.ckey];mute_type=[MUTE_ADMINHELP]'><font color='[(muted & MUTE_ADMINHELP)?"red":"blue"]'>ADMINHELP</font></a> | "
	// 	body += "<A href='?_src_=holder;[HrefToken()];mute=[M.ckey];mute_type=[MUTE_DEADCHAT]'><font color='[(muted & MUTE_DEADCHAT)?"red":"blue"]'>DEADCHAT</font></a>\]"
	// 	body += "(<A href='?_src_=holder;[HrefToken()];mute=[M.ckey];mute_type=[MUTE_ALL]'><font color='[(muted & MUTE_ALL)?"red":"blue"]'>toggle all</font></a>)"

	// body += "<br><br>"
	// body += "<A href='?_src_=holder;[HrefToken()];jumpto=[REF(M)]'><b>Jump to</b></A> | "
	// body += "<A href='?_src_=holder;[HrefToken()];getmob=[REF(M)]'>Get</A> | "
	// body += "<A href='?_src_=holder;[HrefToken()];sendmob=[REF(M)]'>Send To</A>"

	// body += "<br><br>"
	// body += "<A href='?_src_=holder;[HrefToken()];traitor=[REF(M)]'>Traitor panel</A> | "
	// body += "<A href='?_src_=holder;[HrefToken()];narrateto=[REF(M)]'>Narrate to</A> | "
	// body += "<A href='?_src_=holder;[HrefToken()];subtlemessage=[REF(M)]'>Subtle message</A> | "
	// body += "<A href='?_src_=holder;[HrefToken()];playsoundto=[REF(M)]'>Play sound to</A> | "
	// body += "<A href='?_src_=holder;[HrefToken()];languagemenu=[REF(M)]'>Language Menu</A>"

	// if(M.client)
	// 	if(!isnewplayer(M))
	// 		body += "<br><br>"
	// 		body += "<b>Transformation:</b><br>"
	// 		if(isobserver(M))
	// 			body += "<b>Ghost</b> | "
	// 		else
	// 			body += "<A href='?_src_=holder;[HrefToken()];simplemake=observer;mob=[REF(M)]'>Make Ghost</A> | "

	// 		if(ishuman(M) && !ismonkey(M))
	// 			body += "<b>Human</b> | "
	// 		else
	// 			body += "<A href='?_src_=holder;[HrefToken()];simplemake=human;mob=[REF(M)]'>Make Human</A> | "

	// 		if(ismonkey(M))
	// 			body += "<b>Monkey</b> | "
	// 		else
	// 			body += "<A href='?_src_=holder;[HrefToken()];simplemake=monkey;mob=[REF(M)]'>Make Monkey</A> | "

	// 		if(iscyborg(M))
	// 			body += "<b>Cyborg</b> | "
	// 		else
	// 			body += "<A href='?_src_=holder;[HrefToken()];simplemake=robot;mob=[REF(M)]'>Make Cyborg</A> | "

	// 		if(isAI(M))
	// 			body += "<b>AI</b>"
	// 		else
	// 			body += "<A href='?_src_=holder;[HrefToken()];makeai=[REF(M)]'>Make AI</A>"

	// 	body += "<br><br>"
	// 	body += "<b>Other actions:</b>"
	// 	body += "<br>"
	// 	if(!isnewplayer(M))
	// 		body += "<A href='?_src_=holder;[HrefToken()];forcespeech=[REF(M)]'>Forcesay</A> | "
	// 		body += "<A href='?_src_=holder;[HrefToken()];tdome1=[REF(M)]'>Thunderdome 1</A> | "
	// 		body += "<A href='?_src_=holder;[HrefToken()];tdome2=[REF(M)]'>Thunderdome 2</A> | "
	// 		body += "<A href='?_src_=holder;[HrefToken()];tdomeadmin=[REF(M)]'>Thunderdome Admin</A> | "
	// 		body += "<A href='?_src_=holder;[HrefToken()];tdomeobserve=[REF(M)]'>Thunderdome Observer</A> | "
	// 	body += "<A href='?_src_=holder;[HrefToken()];admincommend=[REF(M)]'>Commend Behavior</A> | "

	// body += "<br>"
