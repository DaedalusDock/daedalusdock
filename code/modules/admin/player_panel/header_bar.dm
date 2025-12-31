#define QA_REQUIRE_CKEY(href_content, link_text) (qa_target_key ? "<span><a href='[href_content]'>[link_text]</a></span>" : "<span><span class='disabled' title='No ckey to target'>[link_text]</span></span>")

/datum/player_panel_renderer/proc/pp_header(mob/target, mob/admin)
	ASSERT(target && admin)


	var/name_part
	var/player_part
	var/rank_part
	var/xp_part
	/// ckey to target for quick actions. If null, some quick actions will be disabled.
	var/qa_target_key
	if(isnewplayer(target))
		name_part = "<span class='new_player' title='In lobby'>[target.name]</span>"
	else
		name_part = "[(target.name != target.real_name) ? "<span class='name_mismatch' title='[target.name]'>[target.real_name]</span>" : target.real_name]"

	if(target.client)
		qa_target_key = target.client.ckey
		player_part = "<span class='ckey-normal'>([target.client])</span>"
		if(target.client.holder)
			rank_part = "<span class='rank-admin'>\[[target.client.holder.rank]\]</span>"
		else if(GLOB.deadmins[target.ckey])
			rank_part = "<span class='rank-deadmin'>\[De-adminned\]</span>"
		else
			rank_part = "<span class='rank-player'>\[Player\]</span>"
	else
		if(target.ckey)
			qa_target_key = target.ckey
			player_part = "<span class='ckey-noclient'><a href='?_src_=holder;[HrefToken()];ppbyckey=[target.ckey];ppbyckeyorigmob=[REF(target)]' title='Find new mob'>([target.ckey])</a></span>"
		else
			player_part = "<span class='ckey-null'>(No Key)</span>"

	if(CONFIG_GET(flag/use_exp_tracking))
		if(target.client)
			xp_part = "<span>\[[target.client.get_exp_living(FALSE)]\]</span>"
		else
			xp_part = "<span title='Missing Client'>\[??h\]</span>"
	. = {"
	<div class='major_info'>
		<span>
			[name_part]
			[player_part]
			[xp_part]
			[rank_part]
		</span>
		<div class='quick-actions'>
		<span><a href='?_src_=holder;[HrefToken()];adminplayerobservefollow=[REF(target)]'>FLW</a></span>
		[QA_REQUIRE_CKEY("?_src_=holder;[HrefToken()];showmessageckey=[qa_target_key]","Records")]
		<span><a href='?_src_=holder;[HrefToken()];individuallog=[REF(target)];log_src=[qa_target_key ? LOGSRC_CKEY : LOGSRC_MOB]'>Logs</a></span>
		[CONFIG_GET(string/centcom_ban_db) ? QA_REQUIRE_CKEY("?_src_=holder;[HrefToken()];centcomlookup=[target.client?.ckey]", "CC") : "<span><span class='disabled' title='Centcom Disabled'>CC</span></span>"]
		<span><a href='?_src_=vars;[HrefToken()];Vars=[REF(target)]'>VV</a></span>
		</div>
	</div>
	<!--Space-filler for the top bar-->
	<div style='margin-top: 3em'></div>
	"}

#undef QA_REQUIRE_CKEY
