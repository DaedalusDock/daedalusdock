
/datum/player_panel_renderer/proc/pp_info(mob/target, mob/admin)
	ASSERT(target && admin)
	if(!target.client)
		return null //Skip if no client.
	var/full_version = "Unknown"
	if(target.client.byond_version)
		full_version = "[target.client.byond_version].[target.client.byond_build ? target.client.byond_build : "????"]"
	var/discord_id = "ERROR"
	if(!isnull(target.client.linked_discord_account))
		discord_id = "[target.client.linked_discord_account.valid ? target.client.linked_discord_account.discord_id : "NONE"]"
	var/mind_section
	if(isnewplayer(target))
		var/mob/dead/new_player/np_target = target
		mind_section = {"
		<b>Ready?:</b> [np_target.ready ? "Yes" : "No"]
		"}
	else if(target.mind)
		mind_section = {"
		<b>Assigned Role:</b> [target.mind.assigned_role.title] / <b>Special Role:</b> [target.mind.special_role ? target.mind.special_role : "None"]<br>
		<b>Joined:</b> [target.mind.late_joiner ? "Late" : "Roundstart"]
		"}
	else
		mind_section = "<b>Mind:</b> [check_rights_for(admin.client, R_ADMIN) ? "<span><a href='?_src_=holder;[HrefToken()];initmind=[REF(target)]'>Init Mind</a></span>" : "<span><span class='disabled' title='Insufficient Privilege'>Init Mind</span></span>"]"

	. = {"
	<div>
		<b>First Seen:</b> [target.client.player_join_date] / <b>Account registered on:</b> [target.client.account_join_date]<br>
		<b>BYOND Build:</b> [full_version] / <b>Discord ID:</b> <code>[discord_id]</code><br>
		<b>Input Mode:</b> [target.client.hotkeys ? "Hotkey" : "Classic"]<br>
		<br>
		<b>Mob Type:</b> [target.type]<br>
		[mind_section]
	</div>
	"}


