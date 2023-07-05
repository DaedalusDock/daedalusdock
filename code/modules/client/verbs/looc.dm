#define LOOC_RANGE 7

/client/verb/looc(msg as text)
	set name = "LOOC"
	set desc = "Local OOC, seen only by those in view."
	set category = "OOC"

	looc_message(msg)

/proc/get_top_level_mob(mob/S)
	if(ismob(S.loc) && (S.loc != S))
		return get_top_level_mob(S.loc)
	return S

/client/proc/looc_message(msg)
	if(GLOB.say_disabled)
		to_chat(src, span_danger("Speech is currently admin-disabled."))
		return

	if(!mob)
		return

	msg = copytext_char(sanitize(msg), 1, MAX_MESSAGE_LEN)
	if(!msg)
		return

	if(!holder)
		if(!GLOB.looc_allowed)
			to_chat(src, span_danger("LOOC is globally muted."))
			return
		if(handle_spam_prevention(msg, MUTE_LOOC))
			return
		if(findtext(msg, "byond://"))
			to_chat(src, span_boldannounce("<B>Advertising other servers is not allowed.</B>"))
			log_admin("[key_name(src)] has attempted to advertise in LOOC: [msg]")
			return
		if(prefs.muted & MUTE_LOOC)
			to_chat(src, span_danger("You cannot use LOOC (muted)."))
			return
		if(mob.stat >= UNCONSCIOUS)
			to_chat(src, span_danger("You cannot use LOOC while unconscious or dead."))
			return
		if(isdead(mob))
			to_chat(src, span_danger("You cannot use LOOC while ghosting."))
			return

	msg = emoji_parse(msg)

	mob.log_talk(msg, LOG_OOC, tag = "LOOC")

	var/list/heard

	//so the ai can post looc text
	if(isAI(mob))
		var/mob/living/silicon/ai/ai = mob
		heard = get_hearers_in_view(7, ai.eyeobj)
	else
		heard = get_hearers_in_view(7, get_top_level_mob(mob))

	//so the ai can see looc text
	for(var/mob/living/silicon/ai/ai as anything in GLOB.ai_list)
		if(ai.client && !(ai in heard) && (ai.eyeobj in heard))
			heard += ai

	var/list/admin_seen = list()
	for(var/mob/hearing in heard)
		if(!hearing.client)
			continue
		var/client/hearing_client = hearing.client
		if (hearing_client.holder)
			admin_seen[hearing_client] = TRUE
			continue //they are handled after that

		to_chat(hearing_client, span_looc(span_prefix("LOOC:</span> <EM>[src.mob.name]:</EM> <span class='message'>[msg]")))

	for(var/cli in GLOB.admins)
		var/client/cli_client = cli
		if (admin_seen[cli_client])
			to_chat(cli_client, span_looc("[ADMIN_FLW(usr)] <span class='prefix'>LOOC:</span> <EM>[src.key]/[src.mob.name]:</EM> <span class='message'>[msg]</span>"))

#undef LOOC_RANGE
