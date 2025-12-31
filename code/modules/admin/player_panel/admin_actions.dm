#define MUTE_TYPE(flag, label) ("<span><A href='?_src_=holder;[HrefToken()];mute=[target.ckey];mute_type=[flag]' [(muted & flag)?"style='color:red'":null]'>[label]</a></span>")

/datum/player_panel_renderer/proc/actions_admin(mob/target, mob/admin)
	ASSERT(target && admin)
	if(isnull(target.client))
		return null //No client, no admin actions.
	var/muted = target.client.prefs.muted
	. = {"
	<div class='container'>
		<div class='header admin_actions'>
			Admin
		</div>
		<div class='label'>
		Message
		</div>
		<div class='options'>
		<span><a href='?priv_msg=[target.ckey]'>PM</a></span>
		<span><a href='?_src_=holder;[HrefToken()];subtlemessage=[REF(target)]'>Subtle</a></span>
		<span><A href='?_src_=holder;[HrefToken()];narrateto=[REF(target)]'>Narrate</A></span>
		</div>

		<div class='label'>
		Encourage
		</div>
		<div class='options'>
		<span><A href='?_src_=holder;[HrefToken()];sendtoprison=[REF(target)]'>Prison</a></span>
		<span><A href='?_src_=holder;[HrefToken()];admincommend=[REF(target)]'>Commend Behavior</A></span>
		</div>

		<div class='label'>
		Mute
		</div>
		<div class='options'>
		[MUTE_TYPE(MUTE_IC, "IC")]
		[MUTE_TYPE(MUTE_OOC, "OOC")]
		[MUTE_TYPE(MUTE_PRAY, "PRAY")]
		[MUTE_TYPE(MUTE_ADMINHELP, "AHELP")]
		[MUTE_TYPE(MUTE_DEADCHAT, "DSAY")]
		[MUTE_TYPE(MUTE_ALL, "Toggle All")]
		</div>
	</div>
	"}
