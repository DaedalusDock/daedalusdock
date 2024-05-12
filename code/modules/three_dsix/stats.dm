/datum/gurps_stats
	var/mob/living/owner

	// Higher is better with stats. 10 is the baseline.
	VAR_PRIVATE/strength = 10
	VAR_PRIVATE/dexterity = 10
	VAR_PRIVATE/intelligence = 10
	VAR_PRIVATE/endurance = 10

	/// A lazylist
	VAR_PRIVATE/list/modifiers = list(
		STRENGTH = list(),
		DEXTERITY = list(),
		INTELLIGENCE = list(),
		ENDURANCE = list()
	)

	// Higher is better with skills. 0 is the baseline.
	VAR_PRIVATE/list/skills = list(
	)

/datum/gurps_stats/New(owner)
	. = ..()
	src.owner = owner

/datum/gurps_stats/Destroy()
	owner = null
	return ..()

/datum/gurps_stats/proc/strength()
	. = strength
	for(var/source in modifiers[STRENGTH])
		. += modifiers[STRENGTH][source]

/datum/gurps_stats/proc/dexterity()
	. = dexterity
	for(var/source in modifiers[DEXTERITY])
		. += modifiers[DEXTERITY][source]

/datum/gurps_stats/proc/intelligence()
	. = intelligence
	for(var/source in modifiers[INTELLIGENCE])
		. += modifiers[INTELLIGENCE][source]

/datum/gurps_stats/proc/endurance()
	. = endurance
	for(var/source in modifiers[ENDURANCE])
		. += modifiers[ENDURANCE][source]

/// Return a given stat.
/datum/gurps_stats/proc/get_stat(stat)
	switch(stat)
		if(STRENGTH)
			return strength()
		if(DEXTERITY)
			return dexterity()
		if(INTELLIGENCE)
			return intelligence()
		if(ENDURANCE)
			return endurance()
		else
			CRASH("Bad stat requested: [stat || "NULL"]")

/// Pass in a list such as list(DEXTERITY = 1) as well as a source.
/datum/gurps_stats/proc/add_modifiers(list/stats, source)
	if(!source)
		CRASH("No source passed into add_modifier()")

	for(var/stat in stats)
		modifiers[stat][source] = stats[stat]

/// Pass in a list such as list(DEXTERITY = 1) as well as a source.
/datum/gurps_stats/proc/remove_modifiers(source)
	if(!source)
		CRASH("No source passed into remove_modifier()")

	for(var/stat in modifiers)
		modifiers[stat] -= source

/datum/gurps_stats/proc/add_skill(amount, skill, source)
	if(!source)
		CRASH("No source passed into add_skill()")

	if(isnull(skills[skill]))
		skills[skill] = list()

	skills[skill][source] = amount

/datum/gurps_stats/proc/remove_skill(skill, source)
	if(!source)
		CRASH("No source passed into remove_skill()")

	skills[skill] -= source
	if(!length(skills[skill]))
		skills -= skill

/datum/gurps_stats/proc/get_skill(skill)
	. = 0
	for(var/source in skills[skill])
		. += skills[skill][source]

	. += owner.__get_skill(skill)
