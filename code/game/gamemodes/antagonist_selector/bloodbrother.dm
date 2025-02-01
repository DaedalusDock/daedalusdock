/datum/antagonist_selector/bloodbrother
	restricted_jobs = list(JOB_CYBORG, JOB_AI)
	protected_jobs = list(
		JOB_SECURITY_OFFICER,
		JOB_WARDEN,
		JOB_HEAD_OF_PERSONNEL,
		JOB_SECURITY_MARSHAL,
		JOB_CAPTAIN,
		JOB_CHIEF_ENGINEER,
		JOB_MEDICAL_DIRECTOR
	)

	antag_datum = /datum/antagonist/brother
	antag_flag = ROLE_BROTHER

	/// The smallest teams can be.
	var/minimum_team_size = 2

	var/list/datum/team/brother_team/pre_brother_teams = list()

/datum/antagonist_selector/bloodbrother/Destroy()
	pre_brother_teams = null
	return ..()

/datum/antagonist_selector/bloodbrother/decide_antagonists(num_antagonists)
	var/num_teams = max(1, round(num_antagonists / minimum_team_size))

	for(var/j in 1 to num_teams)
		if(length(candidates) < minimum_team_size) //This shouldn't ever happen but, just in case
			break

		var/datum/team/brother_team/team = new
		// 10% chance to add 1 more member
		var/team_size = prob(10) ? min(minimum_team_size + 1, candidates) : minimum_team_size

		for(var/k in 1 to team_size)
			var/mob/bro = pick_n_take(candidates)
			team.add_member(bro.mind)
			select_antagonist(bro)

		pre_brother_teams += team

/datum/antagonist_selector/bloodbrother/give_antag_datums()
	for(var/datum/team/brother_team/team in pre_brother_teams)
		for(var/datum/mind/M in team.members)
			M.add_antag_datum(/datum/antagonist/brother, team)
