/// Creates a skill message, ie the skill speaking to you. Does not contain a roll component.
/client/proc/admin_custom_skill_message(mob/living/carbon/human/H in view())
	set name = "Fake Skill Message"
	set category = "Admin.Fun"

	if(!check_rights(R_FUN))
		return

	var/list/datum/skill/skills = list()

	for(var/datum/skill/skill as anything in UNLINT(H.stats.skills))
		skills[skill.name] = skill

	var/datum/skill/chosen_skill = tgui_input_list(usr, "Select a Skill", "Skill Message", skills)
	chosen_skill = skills[chosen_skill]
	if(!chosen_skill)
		return

	var/style = tgui_input_list(usr, "Message Style", "Skill Message", list("Good", "Bad"))
	if(!style)
		return

	var/message = tgui_input_text(usr, "Message...", "Skill Message", encode = FALSE)
	if(!message)
		return

	message = "[uppertext(chosen_skill.name)]<span style='color: #bbbbad;font-style: italic'>: </span>[message]"
	message = style == "Good" ? span_statsgood(message) : span_statsbad(message)

	//uggo but i dont care
	var/datum/roll_result/faux_result = new
	faux_result.skill_type_used = chosen_skill
	faux_result.do_skill_sound(H)

	to_chat(list(usr, H), message)
	log_admin("[key_name_admin(usr)] sent a skill message to [key_name_admin(H)]: \"[message]\"")

/// Creates a faux skill roll and result with a set message.
/client/proc/admin_skill_roll(mob/living/carbon/human/H in view())
	set name = "Fake Skill Roll"
	set category = "Admin.Fun"

	if(!check_rights(R_FUN))
		return

	var/list/datum/skill/skills = list()

	for(var/datum/skill/skill as anything in UNLINT(H.stats.skills))
		skills[skill.name] = skill

	var/datum/skill/chosen_skill = tgui_input_list(usr, "Select a Skill", "Skill Roll", skills)
	chosen_skill = skills[chosen_skill]
	if(!chosen_skill)
		return

	var/difficulties = list(
		"Trivial" = 100,
		"Easy" = 84,
		"Medium" = 72,
		"Hard" = 60,
		"Challenging" = 48,
		"Formidable" = 36,
		"Legendary" = 24,
		"Impossible" = 1
	)

	var/difficulty = tgui_input_list(usr, "Roll Difficulty", "Skill Roll", difficulties)
	difficulty = difficulties[difficulty]
	if(!difficulty)
		return

	var/list/outcomes = list("Crit. Success" = CRIT_SUCCESS, "Success" = SUCCESS, "Failure" = FAILURE, "Crit. Failure" = CRIT_FAILURE)
	var/outcome = tgui_input_list(usr, "Roll Outcome", "Skill Roll", outcomes)
	outcome = outcomes[outcome]
	if(!outcome)
		return

	var/message = tgui_input_text(usr, "Message...", "Skill Roll", encode = FALSE)
	if(!message)
		return

	var/roll = 16
	var/list/dice
	switch(outcome)
		if(CRIT_FAILURE)
			roll = 3
			dice = list(1, 1, 1)
		if(CRIT_SUCCESS)
			roll = 18
			dice = list(6, 6, 6)
		if(SUCCESS)
			roll = 16
			dice = list(6, 4, 6)
		if(FAILURE)
			roll = 7
			dice = list(2, 2, 3)

	var/datum/roll_result/faux_result = new
	faux_result.outcome = outcome
	faux_result.requirement = 16
	faux_result.roll = roll
	faux_result.dice_list = dice
	faux_result.skill_type_used = chosen_skill
	faux_result.calculate_probability()
	faux_result.do_skill_sound(H)

	to_chat(list(usr, H), faux_result.create_tooltip(message))
	log_admin("[key_name_admin(usr)] performed a skill roll to [key_name_admin(H)]: \"[message]\"")
