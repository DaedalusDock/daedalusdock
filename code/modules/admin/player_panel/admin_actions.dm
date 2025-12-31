#define CHECK_PERM(check_right, inner_link, disabled_text) (check_rights_for(admin.client, check_right) ? inner_link : "<span><span class='disabled' title='Insufficient Privilege'>[disabled_text]</span></span>")
	#define PP_R_ADMIN(inner_link, disabled_text) (CHECK_PERM(R_ADMIN, inner_link, disabled_text))
	#define PP_R_FUN(inner_link, disabled_text) (CHECK_PERM(R_FUN, inner_link, disabled_text))
	#define PP_R_SPAWN(inner_link, disabled_text) (CHECK_PERM(R_SPAWN, inner_link, disabled_text))
	#define PP_R_SOUND(inner_link, disabled_text) (CHECK_PERM(R_SOUND, inner_link, disabled_text))

#define __MUTE_TYPE(flag, label) ("<span><A href='?_src_=holder;[HrefToken()];mute=[target.ckey];mute_type=[flag];pp_mute_refresh_target=[REF(target)]' [(muted & flag)?"style='color:red'":null]'>[label]</a></span>")
#define _MUTE_TYPE(flag, label) (target.client ? __MUTE_TYPE(flag, label) : "<span><span class='disabled' title='No client to target'>[label]</span></span>")
#define MUTE_TYPE(flag, label) (PP_R_ADMIN(_MUTE_TYPE(flag, label), label))
#define REQUIRE_CKEY(href_content, link_text) (target_key ? "<span><a href='[href_content]'>[link_text]</a></span>" : "<span><span class='disabled' title='No ckey to target'>[link_text]</span></span>")
#define REQUIRE_CLIENT(href_content, link_text) (target.client ? "<span><a href='[href_content]'>[link_text]</a></span>" : "<span><span class='disabled' title='No client to target'>[link_text]</span></span>")
#define REQUIRE_MIND(href_content, link_text) (target.mind ? "<span><a href='[href_content]'>[link_text]</a></span>" : "<span><span class='disabled' title='Target has no mind'>[link_text]</span></span>")


/datum/player_panel_renderer/proc/actions_admin(mob/target, mob/admin)
	ASSERT(target && admin)

	var/target_key = target.ckey

	var/muted
	var/ban_href
	if(target.client)
		muted = target.client.prefs.muted
		ban_href = "?_src_=holder;[HrefToken()];newbankey=[target.key];newbanip=[target.client.address];newbancid=[target.client.computer_id]"
	else
		ban_href = "?_src_=holder;[HrefToken()];newbankey=[target.key]"


	. = {"
	<div class='container'>
		<div class='header admin_actions'>
			Admin
		</div>

		<div class='label'>
		Message
		</div>
		<div class='options'>
		[REQUIRE_CKEY("?priv_msg=[target.ckey]", "PM")]
		[REQUIRE_CLIENT("?_src_=holder;[HrefToken()];subtlemessage=[REF(target)]", "Subtle")]
		[REQUIRE_CLIENT("?_src_=holder;[HrefToken()];narrateto=[REF(target)]", "Narrate")]
		</div>

		<div class='label'>
		Encourage
		</div>
		<div class='options'>
		[PP_R_ADMIN("<span><A href='?_src_=holder;[HrefToken()];sendtoprison=[REF(target)]'>Prison</a></span>", "Prison")]
		[REQUIRE_CKEY("?_src_=holder;[HrefToken()];admincommend=[REF(target)]", "Commend Behavior")]
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
		<div class='label'>
		Judgement
		</div>
		<div class='options'>
		[PP_R_ADMIN(REQUIRE_CLIENT("?_src_=holder;[HrefToken()];boot2=[REF(target)]", "Kick"), "Kick")]
		[PP_R_ADMIN("<span><a href='[ban_href]'>Ban</a></span>","Ban")]

		</div>
	</div>
	"}

#undef MUTE_TYPE
#undef _MUTE_TYPE
#undef __MUTE_TYPE

/datum/player_panel_renderer/proc/actions_info(mob/target, mob/admin)
	ASSERT(target && admin)

	var/pt_info
	if(CONFIG_GET(flag/use_exp_tracking))
		pt_info = PP_R_ADMIN(REQUIRE_CLIENT("?_src_=holder;[HrefToken()];getplaytimewindow=[REF(target)]", "Job XP"), "Job XP")
	else
		pt_info = "<span><span class='disabled' title='XP System Disabled'>Job XP</span></span>"
	. = {"
	<div class='container'>
		<div class='header player_info'>
			Information
		</div>

		<div class='label'>
		Player
		</div>
		<div class='options'>
		[PP_R_ADMIN(REQUIRE_CLIENT("?_src_=holder;[HrefToken()];showrelatedacc=cid;client=[REF(target.client)]", "Alts (CID)"),"Alts (CID)")]
		[PP_R_ADMIN(REQUIRE_CLIENT("?_src_=holder;[HrefToken()];showrelatedacc=ip;client=[REF(target.client)]", "Alts (IP)"),"Alts (IP)")]
		[pt_info]
		</div>

		<div class='label'>
		Character
		</div>
		<div class='options'>
		[PP_R_ADMIN("<span><A href='?_src_=holder;[HrefToken()];languagemenu=[REF(target)]'>Languages</A></span>", "Languages")]
		[PP_R_ADMIN(REQUIRE_MIND("?_src_=holder;[HrefToken()];traitor=[REF(target)]", "Traitor Panel"), "Traitor Panel")]
		</div>
	</div>
	"}

/datum/player_panel_renderer/proc/actions_general(mob/target, mob/admin)
	ASSERT(target && admin)
//
	var/return_to_lobby
	if(!check_rights_for(admin.client, R_ADMIN))
		return_to_lobby = "<span><span class='disabled' title='Insufficient Privileges.'>Return To Lobby</span></span>"
	else if(isnewplayer(target))
		return_to_lobby = "<span><b title='Player already in lobby.'>Return To Lobby</b></span>"
	else if(!isobserver(target))
		return_to_lobby = "<span><span class='disabled' title='Target must be a ghost.'>Return To Lobby</span></span>"
	else if(!target.client)
		return_to_lobby = "<span><span class='disabled' title='No client to target.'>Return To Lobby</span></span>"
	else
		return_to_lobby = "<span><A href='?_src_=holder;[HrefToken()];sendbacktolobby=[REF(target)]'>Send back to Lobby</A></span>"

	var/borg_panel
	if(!check_rights_for(admin.client, R_ADMIN))
		borg_panel = "<span><span class='disabled' title='Insufficient Privileges.'>Borg Panel</span></span>"
	else if(!iscyborg(target))
		borg_panel = "<span><span class='disabled' title='Target must be a cyborg.'>Borg Panel</span></span>"
	else
		borg_panel = "<span><a href='?_src_=holder;[HrefToken()];borgpanel=[REF(target)]'>Borg Panel</a></span>"

	var/forcesay
	if(!check_rights_for(admin.client, R_FUN))
		forcesay = "<span><span class='disabled' title='Insufficient Privileges.'>Force Say</span></span>"
	else if(isnewplayer(target))
		forcesay = "<span><span class='disabled' title='Players in lobby cannot speak.'>Force Say</span></span>"
	else
		forcesay = "<span><A href='?_src_=holder;[HrefToken()];forcespeech=[REF(target)]'>Force Say</A></span>"

	. = {"
	<div class='container'>
		<div class='header general_actions'>
			General
		</div>
		<div class='label'>
		Health
		</div>
		<div class='options'>
		[PP_R_ADMIN("<span><A href='?_src_=holder;[HrefToken()];revive=[REF(target)]'>Heal</A></span>","Heal")]
		</div>
		<div class='label'>
		Respawn
		</div>
		<div class='options'>
		[return_to_lobby]
		</div>
		<div class='label'>
		Misc
		</div>
		<div class='options'>
		[borg_panel]
		[forcesay]
		[PP_R_SOUND(REQUIRE_CLIENT("?_src_=holder;[HrefToken()];playsoundto=[REF(target)]", "Play Sound To"), "Play Sound To")]
		</div>
	</div>
	"}

/datum/player_panel_renderer/proc/actions_movement(mob/target, mob/admin)
	ASSERT(target && admin)

	. = {"
	<div class='container'>
		<div class='header movement_actions'>
			Movement
		</div>
		<div class='label'>
		Follow
		</div>
		<div class='options'>
		[PP_R_ADMIN("<span><A href='?_src_=holder;[HrefToken()];jumpto=[REF(target)]'>Jump to</A></span>","Jump to")]
		[PP_R_ADMIN("<span><a href='?_src_=holder;[HrefToken()];adminplayerobservefollow=[REF(target)]'>Follow</a></span>","Follow")]
		</div>
		<div class='label'>
		Location
		</div>
		<div class='options'>
		Area: [get_area_name(target, TRUE)]<br>
		Pos: [isturf(target.loc) ? "([target.x],[target.y],[target.z])" : "Inside [target.loc] at ([target.x],[target.y],[target.z])"]
		</div>
		<div class='label'>
		Teleport
		</div>
		<div class='options'>
		[PP_R_ADMIN("<span><A href='?_src_=holder;[HrefToken()];getmob=[REF(target)]'>Get</A></span>","Get")]
		[PP_R_ADMIN("<span><A href='?_src_=holder;[HrefToken()];sendmob=[REF(target)]'>Send</A></span>","Send")]
		[PP_R_FUN("<span><A href='?_src_=holder;[HrefToken()];tdome1=[REF(target)]'>Thunderdome 1</A></span>","Thunderdome 1")]
		[PP_R_FUN("<span><A href='?_src_=holder;[HrefToken()];tdome2=[REF(target)]'>Thunderdome 2</A></span>","Thunderdome 2")]
		[PP_R_FUN("<span><A href='?_src_=holder;[HrefToken()];tdomeadmin=[REF(target)]'>Thunderdome Admin</A></span>","Thunderdome Admin")]
		[PP_R_FUN("<span><A href='?_src_=holder;[HrefToken()];tdomeobserve=[REF(target)]'>Thunderdome Observer</A></span>","Thunderdome Observer")]
		</div>
	</div>
	"}

/datum/player_panel_renderer/proc/actions_transformation(mob/target, mob/admin)
	ASSERT(target && admin)
	var/buttonblob

	if(isobserver(target))
		buttonblob += "<span><b>Ghost</b></span>"
	else
		buttonblob += PP_R_SPAWN("<span><A href='?_src_=holder;[HrefToken()];simplemake=observer;mob=[REF(target)]'>Ghost</A></span> ", "Ghost")

	if(ishuman(target) && !ismonkey(target))
		buttonblob += "<span><b>Human</b></span>"
	else
		buttonblob += PP_R_SPAWN("<span><A href='?_src_=holder;[HrefToken()];simplemake=human;mob=[REF(target)]'>Human</A></span> ", "Human")

	if(ismonkey(target))
		buttonblob += "<span><b>Monkey</b></span>"
	else
		buttonblob += PP_R_SPAWN("<span><A href='?_src_=holder;[HrefToken()];simplemake=monkey;mob=[REF(target)]'>Monkey</A></span> ", "Monkey")

	if(iscyborg(target))
		buttonblob += "<span><b>Cyborg</b></span>"
	else
		buttonblob += PP_R_SPAWN("<span><A href='?_src_=holder;[HrefToken()];simplemake=robot;mob=[REF(target)]'>Cyborg</A></span> ", "Cyborg")

	if(isAI(target))
		buttonblob += "<span><b>AI</b></span>"
	else
		buttonblob += PP_R_SPAWN("<span><A href='?_src_=holder;[HrefToken()];makeai=[REF(target)]'>AI</A></span>", "AI")

	. = {"
	<div class='container'>
		<div class='header transformation_actions'>
			Transformation
		</div>
		<div class='label'>
			Transform Into
		</div>
		<div class='options'>
		[buttonblob]
		</div>
	</div>
	"}

#undef REQUIRE_CKEY
#undef REQUIRE_CLIENT
#undef REQUIRE_MIND
#undef PP_R_ADMIN
#undef PP_R_FUN
#undef PP_R_SPAWN
#undef PP_R_SOUND
#undef CHECK_PERM
