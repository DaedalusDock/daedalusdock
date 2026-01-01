

// Stub header, Procs defined in rest of directory.
/datum/player_panel_renderer
//This is probably unnecessary, but juuust in case.
GENERAL_PROTECT_DATUM(/datum/player_panel_renderer)

/client/proc/show_player_panel(mob/M in GLOB.mob_list)
	set category = "Admin.Game"
	set name = "Show Player Panel"
	set desc="Edit player (respawn, ban, heal, etc)"

	if(!check_rights())
		return

	if(!M)
		to_chat(src, span_warning("You seem to be selecting a mob that doesn't exist anymore."), confidential = TRUE)
		return

	log_admin("[key_name(src)] checked the individual player panel for [key_name(M)][isobserver(mob)?"":" while in game"].")

	var/datum/player_panel_renderer/renderer = new
	var/datum/asset/simple/namespaced/player_panel/asset = get_asset_datum(/datum/asset/simple/namespaced/player_panel)
	asset.send(src)

	var/body = {"
	<html>
		<head>
			<meta http-equiv='Content-Type' content='text/html; charset=UTF-8'>
			<title>Options for [M.key]</title>
			<link rel='stylesheet' type='text/css' href='[asset.get_url_mappings()["player_panel.css"]]'>
		</head>
		<body>
	"}

	body += renderer.pp_header(M, mob)
	body += renderer.pp_info(M, mob)
	body += renderer.actions_admin(M, mob)
	body += renderer.actions_info(M, mob)
	body += renderer.actions_general(M, mob)
	body += renderer.actions_movement(M, mob)
	body += renderer.actions_transformation(M, mob)

	body += "</body></html>"

	src << browse(body, "window=adminplayeropts-[REF(M)];size=550x650")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Player Panel") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
