SUBSYSTEM_DEF(credits)
	name = credits
	flags = SS_NO_FIRE|SS_NO_INIT

	var/credits_file
	var/audio_post_delay = 10 SECONDS //Audio will start playing this many seconds before server shutdown.
	var/scroll_speed = 20 //Lower is faster.
	var/splash_time = 2000 //Time in miliseconds that each head of staff/star/production staff etc splash screen gets before displaying the next one.

	var/control = "mapwindow.credits" //if updating this, update in credits.html as well
	var/file = 'code/modules/credits/credits.html'

	var/director = ""
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


/*
 * draft():
 * Stage 1 of credit assembly. Called as soon as the rock cooks. Picks the episode names, staff, etc.
 * and allows the admins to edit those before the round ends proper and the credits roll.
 * Called by on_round_end() (on normal roundend, otherwise on_world_reboot_start() will call finalize() which will call us)
 */
/datum/controller/subsystem/credits/proc/draft(var/force = FALSE)
	if(drafted && !force)
		return
	draft_caststring() //roundend grief not included in the credits
	draft_producerstring() //so that we show admins who have logged out before the credits roll
	draft_star() //done early so admins have time to edit it
	draft_episode_names() //only selects the possibilities, doesn't pick one yet
	draft_disclaimers()
	drafted = TRUE


/*
 * finalize():
 * Stage 2 of credit assembly. Called shortly before the server shuts down.
 * Takes all of our drafted, possibly admin-edited stuff, packages it up into JS arguments, and gets it ready to ship to clients.
 * Called by on_world_reboot_start()
*/
/datum/controller/subsystem/credits/proc/finalize(var/force = FALSE)
	if(finalized && !force)
		return
	if(!drafted) //In case the world is rebooted without the round ending normally.
		draft()

	finalize_name()
	finalize_episodestring()
	finalize_starstring()
	finalize_ssstring()
	finalize_disclaimerstring() //finalize it after the admins have had time to edit them

	var/scrollytext = ss_string + episode_string + cast_string + disclaimers_string
	var/splashytext = producers_string + star_string

	js_args = list(scrollytext, splashytext, theme, scroll_speed, splash_time) //arguments for the makeCredits function back in the javascript
	finalized = TRUE

/*
 * send2clients():
 * Take our packaged JS arguments and ship them to clients, BUT DON'T PLAY YET.
 * Called by on_world_reboot_start()
*/
/datum/controller/subsystem/credits/proc/send2clients()
	if(isnull(finalized))
		stack_trace("PANIC! CREDITS ATTEMPTED TO SEND TO CLIENTS WITHOUT BEING FINALIZED!")
	for(var/client/C in GLOB.clients)
		C.download_credits()

/*
 * play2clients:
 * Okay, roll'em!
 * Called by on_world_reboot_end()
*/
/datum/controller/subsystem/credits/proc/play2clients()
	if(isnull(finalized))
		stack_trace("PANIC! CREDITS ATTEMPTED TO PLAY TO CLIENTS WITHOUT BEING FINALIZED!")
	for(var/client/C in GLOB.clients)
		C.play_downloaded_credits()

/*
 * on_round_end:
 * Called by /gameticker/process() (on normal roundend)
 * |-ROUND ENDS--------------------------(60 sec)--------------------------REBOOT STARTS--------(audio_post_delay sec)--------REBOOT ENDS, SERVER SHUTDOWN-|
 *     ^^^^^ we are here
 */
/datum/controller/subsystem/credits/proc/on_round_end()
	draft()
	if(change_credits_song)
		determine_round_end_song()
	for(var/client/C in clients)
		C.clear_credits()

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
	episode_name = pickweight(drafted_names)
	episode_reason = name_reasons[episode_name]
	if(is_rare_assoc_list[episode_name] == TRUE)
		rare_episode_name = TRUE

/datum/controller/subsystem/credits/proc/finalize_episodestring()
	var/season = time2text(world.timeofday,"YY")
	var/episode_count_data = SSpersistence_misc.read_data(/datum/persistence_task/round_count)
	var/episodenum = episode_count_data[season]
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
	if(!admins.len)
		staff += "<h2>PRODUCER - Alan Smithee</h2><br>"
	for(var/client/C in admins)
		if(!C.holder)
			continue
		if(C.holder.rights & (R_DEBUG|R_ADMIN))
			var/observername = ""
			if(C.mob && istype(C.mob,/mob/dead/observer))
				var/mob/dead/observer/O = C.mob
				if(O.started_as_observer)
					observername = "[O.real_name] a.k.a. "
			staff += "<h2>[uppertext(pick(staffjobs))] - [observername]'[C.key]'</h2><br>"

	producers = list("<h1>Directed by</br>[uppertext(director)]</h1>","[jointext(staff,"")]")
	for(var/head in data_core.get_manifest_json()["heads"])
		producers += "<h1>[head["rank"]]<br>[uppertext(head["name"])]</h1><br>"

	producers_string = ""
	for(var/producer in producers)
		producers_string += "[producer]%<splashbreak>" //%<splashbreak> being an arbitrary "new splash card" char we use to split this string back in the javascript

/datum/controller/subsystem/credits/proc/draft_star()
	var/mob/living/carbon/human/most_talked
	for(var/mob/living/carbon/human/H in mob_list)
		if(!H.key || H.iscorpse)
			continue
		if(!most_talked || H.talkcount > most_talked.talkcount)
			most_talked = H
	star = thebigstar(most_talked)

/datum/controller/subsystem/credits/proc/finalize_starstring()
	if(customized_star == "" && star == "")
		return
	star_string = "<h1>Starring<br>[customized_star != "" ? customized_star : star]</h1><br>%<splashbreak>" //%<splashbreak> being an arbitrary "new splash card" char we use to split this string back in the javascript

/datum/controller/subsystem/credits/proc/finalize_ssstring()
	if(customized_ss == "" && ss == "")
		return
	ss_string = "<div align='center'><div style='max-height:600px;overflow:hidden;max-width:600px;padding-bottom:20px;'><img src='[customized_ss]' style='max-height:600px;max-width:600px;'></div></div>"

/datum/controller/subsystem/credits/proc/draft_caststring()
	cast_string = "<h1>CAST:</h1><br><h2>(in order of appearance)</h2><br>"
	cast_string += "<table class='crewtable'>"

	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(!H.key)
			continue
		cast_string += "[gender_credits(H)]"

	for(var/mob/living/silicon/S in GLOB.silicon_mobs)
		if(!S.key)
			continue
		cast_string += "[silicon_credits(S)]"

	cast_string += "</table><br>"
	cast_string += "<div class='disclaimers'>"
	var/list/corpses = list()
	for(var/mob/living/carbon/human/H in GLOB.dead_player_list)
		if(!H.key)
			continue
		if(H.real_name)
			corpses += H.real_name
	if(corpses.len)
		var/true_story_bro = "<br>[pick("BASED ON","INSPIRED BY","A RE-ENACTMENT OF")] [pick("A TRUE STORY","REAL EVENTS","THE EVENTS ABOARD [uppertext(station_name())]")]"
		cast_string += "<h3>[true_story_bro]</h3><br>In memory of those that did not make it.<br>[english_list(corpses)].<br>"
	cast_string += "</div><br>"

/mob/living/carbon/human/proc/gender_credits(var/mob/living/carbon/human/H)
	if(H.mind && H.mind.key)
		var/assignment = H.get_assignment(if_no_id = "", if_no_job = "")
		return "<tr><td class='actorname'>[uppertext(H.mind.key)]</td><td class='actorsegue'> as </td><td class='actorrole'>[H.real_name][assignment == "" ? "" : ", [assignment]"]</td></tr>"
	else
		return "<tr><td class='actorname'>[uppertext(H.real_name)]</td><td class='actorsegue'> as </td><td class='actorrole'>[p_them(TRUE) == "Them" ? "Themselves" : "[p_them(TRUE)]self"]</td></tr>"

/mob/living/silicon/proc/silicon_credits()
	if(S.mind && S.mind.key)
		return "<tr><td class='actorname'>[uppertext(S.mind.key)]</td><td class='actorsegue'> as </td><td class='actorrole'>[S.name]</td></tr>"
	else
		return "<tr><td class='actorname'>[uppertext(S.name)]</td><td class='actorsegue'> as </td><td class='actorrole'>Itself</td></tr>"

/mob/proc/thebigstar(var/star)
	if(istext(star))
		return star
	if(ismob(star))
		var/mob/M = star
		if(M.mind && M.mind.key)
			return "[uppertext(M.mind.key)] as [M.real_name]"
		else
			return "[uppertext(M.real_name)] as [p_them(TRUE) == "Them" ? "Themselves" : "[p_them(TRUE)]self"]"

/datum/controller/subsystem/proc/is_rerun()
	if(customized_name != "" || customized_star != "" || customized_ss !="" || rare_episode_name == TRUE || theme != initial(theme))
		return FALSE
	else
		return TRUE
