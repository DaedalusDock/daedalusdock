SUBSYSTEM_DEF(credits)
	name = "Credits"
	flags = SS_NO_FIRE|SS_NO_INIT

	var/scroll_speed = 1 //Lower is faster.
	var/splash_time = 2750 //Time in miliseconds that each head of staff/star/production staff etc splash screen gets before displaying the next one.

	var/control = "mapwindow.credits" //if updating this, update in credits.html as well
	var/file = 'code/modules/credits_roll/credits.html'

	var/director = "Daedalus Productions"
	var/list/producers = list()
	var/star = ""
	var/ss = ""
	var/list/disclaimers = list()
	var/list/datum/episode_name/episode_names = list()

	var/episode_name = ""
	var/episode_reason = ""
	var/producers_string = ""
	var/episode_string = ""
	var/cast_string = ""
	var/disclaimers_string = ""
	var/star_string = ""
	var/ss_string = ""

	//If any of the following five are modified, the episode is considered "not a rerun".
	var/customized_name = ""
	var/customized_star = ""
	var/customized_ss = ""
	var/rare_episode_name = FALSE
	var/theme = "NT"

	var/drafted = FALSE
	var/finalized = FALSE
	var/js_args = list()

/datum/controller/subsystem/credits/proc/compile_credits()
	set waitfor = FALSE
	finalize()
	send2clients()
	sleep(2 SECONDS) //send2clients() is slow and non-blocking, so we need to give it some breathing room to send the data to all clients.
	play2clients()

///Clear the existing credits data from clients
/datum/controller/subsystem/credits/proc/clear_credits_from_clients()
	for(var/client/C in GLOB.clients)
		C.clear_credits()

/*
 * draft():
 * Stage 1 of credit assembly. Called as soon as the rock cooks. Picks the episode names, staff, etc.
 * and allows the admins to edit those before the round ends proper and the credits roll.
 */
/datum/controller/subsystem/credits/proc/draft(force)
	if(drafted && !force)
		return
	draft_caststring() //roundend grief not included in the credits
	draft_producerstring() //so that we show admins who have logged out before the credits roll
	draft_star() //done early so admins have time to edit it
	draft_episode_names() //only selects the possibilities, doesn't pick one yet
	draft_disclaimers()
	drafted = TRUE
	message_admins("SScredits has finished drafting the credits, they can now be editted.")


/*
 * finalize():
 * Stage 2 of credit assembly. Called shortly before the server shuts down.
 * Takes all of our drafted, possibly admin-edited stuff, packages it up into JS arguments, and gets it ready to ship to clients.
*/
/datum/controller/subsystem/credits/proc/finalize(force)
	if(finalized && !force)
		return
	if(!drafted) //In case the world is rebooted without the round ending normally.
		CRASH("Credits attempted to finalize without a draft.")

	finalize_name()
	finalize_episodestring()
	finalize_starstring()
	finalize_ssstring()
	finalize_disclaimerstring() //finalize it after the admins have had time to edit them

	//No dude. Im not wrapping this in a proc and putting it on SScredits. Im not letting people tamper with this. That's weird, bro.
	var/fallen_string = "<br><br><div class='disclaimers'><h2>THIS EPISODE IS DEDICATED TO OUR FALLEN</h2><br>"
	for(var/name in global.immortals)
		fallen_string += "[name]<br>"
	fallen_string += "</div><br><br><br><br><br>"

	var/scrollytext = ss_string + episode_string + cast_string + disclaimers_string + fallen_string
	var/splashytext = producers_string + star_string

	js_args = list(scrollytext, splashytext, theme, scroll_speed, splash_time) //arguments for the makeCredits function back in the javascript
	finalized = TRUE

/*
 * send2clients():
 * Take our packaged JS arguments and ship them to clients, BUT DON'T PLAY YET.
*/
/datum/controller/subsystem/credits/proc/send2clients()
	if(!finalized)
		stack_trace("PANIC! CREDITS ATTEMPTED TO SEND TO CLIENTS WITHOUT BEING FINALIZED!")
	for(var/client/C in GLOB.clients)
		C.download_credits()

/*
 * play2clients:
 * Okay, roll'em!
*/
/datum/controller/subsystem/credits/proc/play2clients()
	if(!finalized)
		stack_trace("PANIC! CREDITS ATTEMPTED TO PLAY TO CLIENTS WITHOUT BEING FINALIZED!")
	for(var/client/C in GLOB.clients)
		C.play_downloaded_credits()

/datum/controller/subsystem/credits/proc/finalize_name()
	if(customized_name)
		episode_name = customized_name
		return
	var/list/drafted_names = list()
	var/list/name_reasons = list()
	var/list/is_rare_assoc_list = list()
	for(var/datum/episode_name/N as anything in episode_names)
		drafted_names["[N.thename]"] = N.weight
		name_reasons["[N.thename]"] = N.reason
		is_rare_assoc_list["[N.thename]"] = N.rare
	episode_name = pick_weight(drafted_names)
	episode_reason = name_reasons[episode_name]
	if(is_rare_assoc_list[episode_name] == TRUE)
		rare_episode_name = TRUE

/datum/controller/subsystem/credits/proc/finalize_episodestring()
	var/season = time2text(world.timeofday,"YY")
	var/episodenum = GLOB.round_id || 1
	episode_string = "<h1><span id='episodenumber'>SEASON [season] EPISODE [episodenum]</span><br><span id='episodename' title='[episode_reason]'>[episode_name]</span></h1><br><div style='padding-bottom: 75px;'></div>"
	log_game("So ends [is_rerun() ? "another rerun of " : ""]SEASON [season] EPISODE [episodenum] - [episode_name] ... [customized_ss]")

/datum/controller/subsystem/credits/proc/finalize_disclaimerstring()
	disclaimers_string = "<div class='disclaimers'>"
	for(var/disclaimer in disclaimers)
		disclaimers_string += "[disclaimer]"
	disclaimers_string += "</div>"

/datum/controller/subsystem/credits/proc/draft_producerstring()
	var/list/staff = list("<h1>PRODUCTION STAFF</h1><br>")
	var/list/staffjobs = list("Coffee Fetcher", "Cameraman", "Angry Yeller", "Chair Operator", "Choreographer", "Historical Consultant", "Costume Designer", "Chief Editor", "Executive Assistant", "Key Grip")
	for(var/client/C in GLOB.clients)
		if(!C.holder)
			continue
		if(check_rights_for(C, R_DEBUG|R_ADMIN))
			var/observername = ""
			if(C.mob && istype(C.mob,/mob/dead/observer))
				var/mob/dead/observer/O = C.mob
				if(O.started_as_observer)
					observername = "[O.real_name] a.k.a. "
			staff += "<h2>[uppertext(pick(staffjobs))] - [observername]'[uppertext(C.ckey)]'</h2><br>"
	if(staff.len == 1)
		staff += "<h2>PRODUCER - Alan Smithee</h2><br>"

	producers = list("<h1>Directed by</br>[uppertext(director)]</h1>","[jointext(staff,"")]")

	var/list/heads_of_staff = list()
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(H.stat == DEAD)
			continue
		if(H.mind.assigned_role?.departments_bitflags & DEPARTMENT_BITFLAG_COMMAND)
			heads_of_staff += H

	for(var/mob/living/carbon/human/H as anything in heads_of_staff)
		var/job2show = H.client?.prefs.alt_job_titles[H.mind.assigned_role.title] || H.mind.assigned_role.title
		producers += "<h1>[job2show]<br>[uppertext(H.real_name)]</h1><br>"

	producers_string = ""
	for(var/producer in producers)
		producers_string += "[producer]%<splashbreak>" //%<splashbreak> being an arbitrary "new splash card" char we use to split this string back in the javascript

/datum/controller/subsystem/credits/proc/draft_star()
	var/mob/living/carbon/human/most_talked
	for(var/datum/mind/M as anything in SSticker.minds)
		if(!M.key || (!M.current || M.current.stat == DEAD || !ishuman(M.current)))
			continue
		var/mob/living/carbon/human/H = M.current
		if(!most_talked || H.talkcount > most_talked.talkcount)
			most_talked = H
	star = thebigstar(most_talked)

/datum/controller/subsystem/credits/proc/finalize_starstring()
	if(customized_star == "" && star == "")
		return
	star_string = "<h1>Starring<br>[customized_star != "" ? customized_star : (star ? star : "Nobody!")]</h1><br>%<splashbreak>" //%<splashbreak> being an arbitrary "new splash card" char we use to split this string back in the javascript

/datum/controller/subsystem/credits/proc/finalize_ssstring()
	if(customized_ss == "" && ss == "")
		return
	ss_string = "<div align='center'><div style='max-height:600px;overflow:hidden;max-width:600px;padding-bottom:20px;'><img src='[customized_ss]' style='max-height:600px;max-width:600px;'></div></div>"

/datum/controller/subsystem/credits/proc/draft_caststring()
	cast_string = "<h1>CAST:</h1><br><h2>(in order of appearance)</h2><br>"
	cast_string += "<table class='crewtable'>"
	var/list/dead_names = list()
	var/cast_count
	for(var/datum/mind/M as anything in SSticker.minds)
		if(M.key && M.name)
			if(!M.current || (M.current.stat == DEAD)) //Their body was destroyed or they are simply dead
				dead_names += M.name
				continue
		else
			continue //The mob was never player controlled/didn't have a name (wtf how)

		cast_string += "[M.current.get_credits_entry()]"
		cast_count++

	if(!cast_count)
		cast_string += "<tr><td class='actorsegue'> Nobody! </td></tr>"

	cast_string += "</table><br>"
	cast_string += "<div class='disclaimers'>"

	if(length(dead_names))
		var/true_story_bro = "<br>[pick("BASED ON","INSPIRED BY","A RE-ENACTMENT OF")] [pick("A TRUE STORY","REAL EVENTS","THE EVENTS ABOARD [uppertext(station_name())]")]"
		cast_string += "<h3>[true_story_bro]</h3><br>In memory of those that did not make it.<br>"
		for(var/name in dead_names)
			cast_string += "[name]<br>"
	cast_string += "</div><br>"

/mob/living/proc/get_credits_entry()
	var/datum/preferences/prefs = GLOB.preferences_datums[ckey(mind.key)]
	/// initial(name) is used over this now.
	/*var/gender_text
	switch(gender)
		if("male")
			gender_text = "Himself"
		if("female")
			gender_text = "Herself"
		if("neuter")
			gender_text = "Themself"
		if("plural")
			gender_text = "Themselves"
		else
			gender_text = "Itself"*/

	if(prefs.read_preference(/datum/preference/toggle/credits_uses_ckey))
		return "<tr><td class='actorname'>[uppertext(ckey(mind.key))]</td><td class='actorsegue'> as </td><td class='actorrole'>[name]</td></tr>"
	else
		return "<tr><td class='actorname'>[uppertext(name)]</td><td class='actorsegue'> as </td><td class='actorrole'>[initial(name)]</td></tr>"

/mob/living/carbon/human/get_credits_entry()
	var/datum/preferences/prefs = GLOB.preferences_datums[ckey(mind.key)]
	var/assignment = get_assignment(if_no_id = "", if_no_job = "")
	if(prefs.read_preference(/datum/preference/toggle/credits_uses_ckey))
		return "<tr><td class='actorname'>[uppertext(ckey(mind.key))]</td><td class='actorsegue'> as </td><td class='actorrole'>[real_name][assignment == "" ? "" : ", [assignment]"]</td></tr>"
	else
		//return "<tr><td class='actorname'>[uppertext(real_name)]</td><td class='actorsegue'> as </td><td class='actorrole'>[p_them(TRUE) == "Them" ? "Themself" : "[p_them(TRUE)]self"]</td></tr>" OLD
		return "<tr><td class='actorname'>[uppertext(real_name)]</td><td class='actorsegue'> as </td><td class='actorrole'>[assignment || "Background Actor"]</td></tr>"

/mob/living/silicon/get_credits_entry()
	var/datum/preferences/prefs = GLOB.preferences_datums[ckey(mind.key)]
	if(prefs.read_preference(/datum/preference/toggle/credits_uses_ckey))
		return "<tr><td class='actorname'>[uppertext(ckey(mind.key))]</td><td class='actorsegue'> as </td><td class='actorrole'>[name]</td></tr>"
	else
		return "<tr><td class='actorname'>[uppertext(name)]</td><td class='actorsegue'> as </td><td class='actorrole'>Itself</td></tr>"

/datum/controller/subsystem/credits/proc/thebigstar(star)
	if(istext(star))
		return star
	if(ismob(star))
		var/mob/M = star
		var/datum/preferences/prefs = GLOB.preferences_datums[ckey(M.mind.key)]
		if(prefs.read_preference(/datum/preference/toggle/credits_uses_ckey))
			return "[uppertext(ckey(M.mind.key))] as [M.real_name]"
		else
			return "[uppertext(M.real_name)] as [M.p_them(TRUE) == "Them" ? "Themselves" : "[M.p_them(TRUE)]self"]"

/datum/controller/subsystem/credits/proc/is_rerun()
	if(customized_name != "" || customized_star != "" || customized_ss !="" || rare_episode_name == TRUE || theme != initial(theme))
		return FALSE
	else
		return TRUE
