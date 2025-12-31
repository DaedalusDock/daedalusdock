/datum/player_panel_renderer/proc/pp_info(mob/target, mob/admin)
	ASSERT(target && admin)

	#warn do client lookup stuff here


/datum/player_panel_renderer/proc/actions_info(mob/target, mob/admin)
	ASSERT(target && admin)
	#warn verify target client
	. = {"
	<div class='container'>
		<div class='header player_info'>
			Player Info
		</div>
		<div class='label'>
		Related Accounts
		</div>
		<div class='options'>
		<span><a href='?_src_=holder;[HrefToken()];showrelatedacc=cid;client=[REF(target.client)]'>CID</a></span>
		<span><a href='?_src_=holder;[HrefToken()];showrelatedacc=ip;client=[REF(target.client)]'>IP</a></span>
		</div>
	</div>
	"}

