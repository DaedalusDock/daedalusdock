/datum/round_end_report
	/// Combines the law, antag, achievement, and economy reports.
	var/common_report_html
	var/survivor_report_html

	var/law_report_html
	var/antag_report_html
	var/economy_report_html

/// Compiles all of the html into full_html, to be sent out.
/datum/round_end_report/proc/compile(list/popcount)
	var/list/common_parts = list(
		compile_law_report(popcount),
		compile_antag_report(popcount),
		compile_economy_report(popcount),
	)

	list_clear_nulls(common_parts)
	common_report_html = jointext(common_parts, "")
	compile_survivor_report(popcount)

/// Generates a personalized report for a client, or a generic one if no client is provided.
/datum/round_end_report/proc/generate_for_client(client/C)
	. = {"
		[compile_personal_report(C)]
		[common_report_html]
	"}


/**
 * Log the round-end report as an HTML file
 *
 * Composits the roundend report, and saves it in two locations.
 * The report is first saved along with the round's logs
 * Then, the report is copied to a fixed directory specifically for
 * housing the server's last roundend report. In this location,
 * the file will be overwritten at the end of each shift.
 */
/datum/round_end_report/proc/write_log()
	var/roundend_file = file("[GLOB.log_directory]/round_end_data.html")

	var/content = generate_for_client(null)

	//Log the rendered HTML in the round log directory
	fdel(roundend_file)
	WRITE_FILE(roundend_file, content)
	//Place a copy in the root folder, to be overwritten each round.
	roundend_file = file("data/server_last_roundend_report.html")
	fdel(roundend_file)
	WRITE_FILE(roundend_file, content)

/datum/round_end_report/proc/compile_personal_report(client/C)
	/// Classes to attach to the containing div
	var/container_classes = "stationborder"
	var/header_text = ""

	if(C)
		var/mob/M = C.mob

		if(M.mind && !isnewplayer(M))
			if(M.stat != DEAD && !isbrain(M))
				if(!EMERGENCY_ESCAPED_OR_ENDGAMED || (M.onCentCom() || M.onSyndieBase())) // Shuttle never came, or they're on centcom/syndie
					header_text = "<span class='good'>[M.real_name] survived the cycle</span>"
				else
					header_text = "<span class='marooned'>[M.real_name] was marooned on [station_name()]...</span>"

			else // Player is dead or a brain.
				container_classes = "redborder"
				header_text = "<span class='bad'>[M.real_name] perished on [station_name()]</span>"

		if(header_text)
			header_text = "<div class='personal_header'>[header_text]</div>"

	return {"
		<div class='panel [container_classes]'>
			[header_text]
			[survivor_report_html]
		</div>
	"}

/datum/round_end_report/proc/compile_survivor_report(list/popcount)
	var/list/parts = list()

	#define wrap_info(header, text) {"
		<div class='flex_container vertical align_center' style='flex: 1'>
			<div>[header]</div>
			<div>[text]</div>
		</div>
	"}

	if(GLOB.round_id)
		var/statspage = CONFIG_GET(string/roundstatsurl)
		var/info = statspage ? "<a href='?action=openLink&link=[url_encode(statspage)][GLOB.round_id]'>[GLOB.round_id]</a>" : GLOB.round_id
		parts += wrap_info("Round ID", "<b>[info]</b>")

	parts += wrap_info("Round Duration", "<B>[DisplayTimeText(world.time - SSticker.round_start_time)]</B>")
	parts += wrap_info("Station Integrity", "<B>[GLOB.station_was_nuked ? span_redtext("Destroyed") : "[popcount["station_integrity"]]%"]</B>")

	var/total_players = GLOB.joined_player_list.len
	if(total_players)
		parts += wrap_info("Total Population", "<B>[total_players]</B>")
		parts += wrap_info("Survival Rate", "<B>[popcount[POPCOUNT_SURVIVORS]] ([PERCENT(popcount[POPCOUNT_SURVIVORS]/total_players)]%)</B>")

	parts += wrap_info("Gamemode", "<b>[SSticker.mode.name]</b>")

	var/fatality_message = span_good("There were no fatalities on this day.")
	if(SSblackbox.first_death)
		var/list/ded = SSblackbox.first_death
		if(ded.len)
			fatality_message = {"
				<div class='bad' style='font-size: 1.4em;margin-bottom: 0.5em'>
					<b>First Blood!</b>
				</div>
				<div>
					<b>[ded["name"]], [ded["role"]], at [ded["area"]]</b>
				</div>
				<div>
					<b>[ded["damage"]]</b>
				</div>
				[ded["last_words"] ? "<div>Their last words were \"[default_encode_emphasis(ded["last_words"])]\"</div>" : ""]
			"}

	survivor_report_html = {"
		<div class='flex_container horizontal' style='gap: 0.5em;justify-content: space-evenly;text-align: center'>
			[jointext(parts, "")]
		</div>
		<div style='text-align: center;margin-top: 1em;font-size: 1em'>
			[fatality_message]
		</div>
	"}
	return survivor_report_html

	#undef wrap_info

/datum/round_end_report/proc/compile_law_report()
	var/list/parts = list()
	var/borg_spacer = FALSE //inserts an extra linebreak to separate AIs from independent borgs, and then multiple independent borgs.
	//Silicon laws report
	for (var/i in GLOB.ai_list)
		var/mob/living/silicon/ai/aiPlayer = i
		var/datum/mind/aiMind = aiPlayer.deployed_shell?.mind || aiPlayer.mind
		if(aiMind)
			parts += "<b>[aiPlayer.name]</b> (Played by: <b>[aiMind.key]</b>)'s laws [aiPlayer.stat != DEAD ? "at the end of the round" : "when it was [span_redtext("deactivated")]"] were:"
			parts += aiPlayer.laws.get_law_list(include_zeroth=TRUE)

		parts += "<b>Total law changes: [aiPlayer.law_change_counter]</b>"

		if (aiPlayer.connected_robots.len)
			var/borg_num = aiPlayer.connected_robots.len
			parts += "<br><b>[aiPlayer.real_name]</b>'s minions were:"
			for(var/mob/living/silicon/robot/robo in aiPlayer.connected_robots)
				borg_num--
				if(robo.mind)
					parts += "<b>[robo.name]</b> (Played by: <b>[robo.mind.key]</b>)[robo.stat == DEAD ? " [span_redtext("(Deactivated)")]" : ""][borg_num ?", ":""]"
		if(!borg_spacer)
			borg_spacer = TRUE

	for (var/mob/living/silicon/robot/robo in GLOB.silicon_mobs)
		if (!robo.connected_ai && robo.mind)
			parts += "[borg_spacer?"<br>":""]<b>[robo.name]</b> (Played by: <b>[robo.mind.key]</b>) [(robo.stat != DEAD)? "[span_greentext("survived")] as an AI-less borg!" : "was [span_redtext("unable to survive")] the rigors of being a cyborg without an AI."] Its laws were:"

			if(robo) //How the hell do we lose robo between here and the world messages directly above this?
				parts += robo.laws.get_law_list(include_zeroth=TRUE)

			if(!borg_spacer)
				borg_spacer = TRUE

	if(length(parts))
		law_report_html = "<div class='panel stationborder'>[parts.Join("<br>")]</div>"

	return law_report_html

/datum/round_end_report/proc/compile_antag_report()
	var/list/result = list()
	var/list/all_teams = list()
	var/list/all_antagonists = list()

	for(var/datum/team/A in GLOB.antagonist_teams)
		all_teams |= A

	for(var/datum/antagonist/A in GLOB.antagonists)
		if(!A.owner)
			continue
		all_antagonists |= A

	for(var/datum/team/T in all_teams)
		result += T.roundend_report()
		for(var/datum/antagonist/X in all_antagonists)
			if(X.get_team() == T)
				all_antagonists -= X
		result += " "//newline between teams
		CHECK_TICK

	var/currrent_category
	var/datum/antagonist/previous_category

	sortTim(all_antagonists, GLOBAL_PROC_REF(cmp_antag_category))

	for(var/datum/antagonist/A in all_antagonists)
		if(!A.show_in_roundend)
			continue
		if(A.roundend_category != currrent_category)
			if(previous_category)
				result += previous_category.roundend_report_footer()
				result += "</div>"
			result += "<div class='panel redborder'>"
			result += A.roundend_report_header()
			currrent_category = A.roundend_category
			previous_category = A
		result += A.roundend_report()
		result += "<br><br>"
		CHECK_TICK

	if(all_antagonists.len)
		var/datum/antagonist/last = all_antagonists[all_antagonists.len]
		result += last.roundend_report_footer()
		result += "</div>"

	antag_report_html = jointext(result, "")
	return antag_report_html

///Generate a report for how much money is on station, as well as the richest crewmember on the station.
/datum/round_end_report/proc/compile_economy_report()
	var/list/parts = list()

	///This is the richest account on station at roundend.
	var/datum/bank_account/mr_moneybags
	var/most_marks

	///This is the station's total wealth at the end of the round.
	var/station_vault = 0
	///How many players joined the round.
	var/total_players = GLOB.joined_player_list.len
	var/static/list/typecache_bank = typecacheof(list(/datum/bank_account/department, /datum/bank_account/remote))
	for(var/i in SSeconomy.bank_accounts_by_id)
		var/datum/bank_account/current_acc = SSeconomy.bank_accounts_by_id[i]
		if(typecache_bank[current_acc.type])
			continue

		var/mark_sum = current_acc.account_balance
		var/datum/data/record/account_holder_record = SSdatacore.get_record_by_name(current_acc.account_holder, DATACORE_RECORDS_LOCKED)
		if(account_holder_record)
			var/datum/mind/account_holder_mind = account_holder_record.fields[DATACORE_MINDREF]
			if(account_holder_mind)
				var/mob/living/carbon/human/account_holder_mob = account_holder_mind.current
				if(istype(account_holder_mob))
					for(var/obj/item/stack/spacecash/mark_stack in account_holder_mob.get_all_contents())
						mark_sum += mark_stack.get_item_credit_value()

		station_vault += mark_sum

		if(!mr_moneybags || mark_sum > most_marks)
			mr_moneybags = current_acc
			most_marks = mark_sum


	parts += "<div class='panel stationborder'><span class='header'>Colony Economic Summary:</span><br>"
	parts += "<b>General Statistics:</b><br>"
	parts += "There were [station_vault] marks collected by citizens this round.<br>"

	if(total_players > 0)
		parts += "An average of [station_vault/total_players] marks were collected per citizen.<br>"
		log_econ("Roundend credit total: [station_vault] marks. Average marks: [station_vault/total_players]")

	if(mr_moneybags)
		parts += "The richest motherfucker at round end was <b>[mr_moneybags.account_holder] with [most_marks]</b> fm.</div>"

	economy_report_html = jointext(parts, "")
	return economy_report_html
