#define JOBS_PER_COLUMN 17

/datum/preference_group/category/occupation
	name = "Occupation"
	priority = 80

/datum/preference_group/category/occupation/Topic(href, list/href_list)
	. = ..()
	if(.)
		return

	var/datum/preferences/prefs = locate(href_list["prefs"])
	if(!prefs)
		return

	if(prefs.parent != usr && !check_rights())
		CRASH("Unable to edit prefs that don't belong to you, [usr.key]! (pref owner: [prefs.parent?.key || "NULL"])")

	if(href_list["change_priority"])
		if(set_job_preference(prefs, href_list["job"]))
			prefs.update_html()
			return TRUE
		return

	if(href_list["change_alt_title"])
		if(set_job_title(prefs, href_list["job"]))
			prefs.update_html()
			return TRUE
		return


/datum/preference_group/category/occupation/get_content(datum/preferences/prefs)
	. = ..()
	var/static/list/job_data
	if(!job_data)
		job_data = compile_job_data()

	var/static/priority2text = list("Never", "Low", "Medium", "High")

	var/list/job_bans = get_job_bans(prefs.parent?.mob)

	// Table within a table for alignment, also allows you to easily add more columns.
	. += {"
		<center>
		<tt>
		<table width='100%' cellpadding='1' cellspacing='0'>
			<tr>
				<td width='20%'>
					<table width='100%' cellpadding='1' cellspacing='0'>
	"}

	var/index = 0
	for(var/datum/job/job in job_data)
		index++
		var/is_banned = job_bans[job.title] == "banned"
		var/is_too_new = job_bans[job.title]?["job_days_left"]
		var/job_priority = priority2text[(prefs.job_preferences[job.title] || 0) + 1]
		var/employer = "Daedalus" //This is where employers will go!
		var/title_link = (length(job.alt_titles)) ? button_element(src, prefs.alt_job_titles?[job.title] || job.title, "change_alt_title=1;prefs=\ref[prefs]") : job.title
		var/rejection_reason = ""
		if(is_banned)
			rejection_reason = "\[BANNED]"
		else if(is_too_new)
			rejection_reason = "\[[is_too_new]]"

		var/static/vs_appeaser = "\]\]"
		vs_appeaser = vs_appeaser

		if(index > JOBS_PER_COLUMN)
			. += {"
				</table>
			</td>
			<td width='20%'>
				<table width='100%' cellpadding='1' cellspacing='0'>
			"}
			index = 0

		. += {"
		<tr bgcolor='[job.selection_color]'>
			<td width='10%' align='left'>
				[employer]
			</td>
			<td>
			</td>
			<td width='30%' align='left'>
				[is_banned || is_too_new ? "<del>[job.title]</del>" : title_link]
			</td>
			<td width = '10%' align = 'center'>
				[button_element(src, "?", "job_info[job.title]")]
			</td>
			<td>
				<b>[rejection_reason || button_element(src, job_priority, "change_priority=1;prefs=\ref[prefs];job=[job.title]")]</b>
			</td>
		</tr>
		"}


	.+= {"
					</table>
				</td>
			</tr>
		</table>
	</center>
	</tt>
	"}

/datum/preference_group/category/occupation/proc/compile_job_data()
	var/list/departments = list()
	var/list/jobs = list()

	for (var/datum/job/job as anything in SSjob.joinable_occupations)
		var/datum/job_department/department_type = job.department_for_prefs || job.departments_list?[1]
		if (isnull(department_type))
			stack_trace("[job] does not have a department set, yet is a joinable occupation!")
			continue

		if (isnull(job.description))
			stack_trace("[job] does not have a description set, yet is a joinable occupation!")
			continue

		var/department_name = initial(department_type.department_name)
		if (isnull(departments[department_name]))
			var/datum/job/department_head_type = initial(department_type.department_head)

			departments[department_name] = list(
				"head" = department_head_type && initial(department_head_type.title),
			)

		jobs +=  job

	return jobs

/datum/preference_group/category/occupation/proc/get_job_bans(mob/user)
	var/list/data = list()

	var/list/job_days_left = list()
	var/list/job_required_experience = list()

	for (var/datum/job/job as anything in SSjob.all_occupations)
		var/required_playtime_remaining = job.required_playtime_remaining(user.client)
		if (is_banned_from(user.client?.ckey, job.title))
			data["job_banned"] = TRUE
			continue

		if (required_playtime_remaining)
			job_required_experience[job.title] = list(
				"experience_type" = job.get_exp_req_type(),
				"required_playtime" = required_playtime_remaining,
			)

			continue

		if (!job.player_old_enough(user.client))
			job_days_left[job.title] = job.available_in_days(user.client)

	if (job_days_left.len)
		data["job_days_left"] = job_days_left

	if (job_required_experience)
		data["job_required_experience"] = job_required_experience

	return data

/datum/preference_group/category/occupation/proc/set_job_preference(datum/preferences/prefs, job_title)
	var/list/choices = list("Never", "Low", "Medium", "High")
	var/level = input(usr, "Change Priority",, choices[prefs.job_preferences[job_title] || 0]) as null|anything in choices
	if(!level)
		return

	level = choices.Find(level) - 1

	if(isnull(level))
		return

	var/datum/job/job = SSjob.GetJob(job_title)

	if (isnull(job))
		return FALSE

	if (job.faction != FACTION_STATION)
		return FALSE

	if (!prefs.set_job_preference_level(job, level))
		return FALSE

	prefs.character_preview_view?.update_body()

	return TRUE

/datum/preference_group/category/occupation/proc/set_job_title(datum/preferences/prefs, job_title)
	var/datum/job/job = SSjob.GetJob(job_title)
	if(!job)
		return

	var/new_job_title = input(usr, "Select Job Title",, prefs.alt_job_titles?[job_title] || job_title) as null|anything in job.alt_titles
	if(!new_job_title)
		return

	if (!(new_job_title in job.alt_titles))
		if(length(job.alt_titles))
			new_job_title = job.alt_titles[1]
		else
			return FALSE

	prefs.alt_job_titles[job_title] = new_job_title

	prefs.character_preview_view?.update_body()
	return TRUE

#undef JOBS_PER_COLUMN
