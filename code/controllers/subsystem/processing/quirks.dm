#define EXP_ASSIGN_WAYFINDER 1200
#define RANDOM_QUIRK_BONUS 3
#define MINIMUM_RANDOM_QUIRKS 3
//Used to process and handle roundstart quirks
// - Quirk strings are used for faster checking in code
// - Quirk datums are stored and hold different effects, as well as being a vector for applying trait string
PROCESSING_SUBSYSTEM_DEF(quirks)
	name = "Quirks"
	init_order = INIT_ORDER_QUIRKS
	flags = SS_BACKGROUND | SS_HIBERNATE
	runlevels = RUNLEVEL_GAME
	wait = 1 SECONDS

	/// Associative list of "name" = /path/ of quirks
	var/list/quirks = list()
	/// Same as the above but sorted by the quirk cmp
	var/list/sorted_quirks

	/// A list of quirks that can not be used with each other.
	var/list/quirk_blacklist = list(
		list(/datum/quirk/item_quirk/blindness, /datum/quirk/item_quirk/nearsighted),
		list(/datum/quirk/no_taste, /datum/quirk/vegetarian, /datum/quirk/deviant_tastes),
		list(/datum/quirk/alcohol_tolerance, /datum/quirk/light_drinker),
	)

/datum/controller/subsystem/processing/quirks/Initialize(timeofday)
	get_quirks()
	return ..()

/// Returns the list of possible quirks
/datum/controller/subsystem/processing/quirks/proc/get_quirks()
	RETURN_TYPE(/list)
	if (!quirks.len)
		SetupQuirks()

	return quirks

/datum/controller/subsystem/processing/quirks/proc/SetupQuirks()
	for(var/datum/quirk/quirk_type as anything in subtypesof(/datum/quirk))
		if(isabstract(quirk_type))
			continue

		quirks[initial(quirk_type.name)] = quirk_type

	sortTim(quirks, GLOBAL_PROC_REF(cmp_text_asc))

	// Sort by Positive, Negative, Neutral; and then by name within those groups
	sorted_quirks = sort_list(quirks, GLOBAL_PROC_REF(cmp_quirk_asc))

/datum/controller/subsystem/processing/quirks/proc/AssignQuirks(mob/living/user, client/applied_client)
	var/badquirk = FALSE
	var/datum/preference/P = GLOB.preference_entries[/datum/preference/blob/quirks]
	var/list/client_quirks = applied_client.prefs.read_preference(P.type)
	for(var/quirk_name in client_quirks)
		var/datum/quirk/Q = quirks[quirk_name]
		if(Q)
			if(user.add_quirk(Q, applied_client))
				SSblackbox.record_feedback("nested tally", "quirks_taken", 1, list("[quirk_name]"))
		else
			stack_trace("Invalid quirk \"[quirk_name]\" in client [applied_client.ckey] preferences")
			applied_client.prefs.update_preference(P, client_quirks - P)
			badquirk = TRUE

	if(badquirk)
		applied_client.prefs.save_character()

/// Takes a list of quirk names and returns a new list of quirks that would
/// be valid.
/// If no changes need to be made, will return the same list.
/// Expects all quirk names to be unique, but makes no other expectations.
/datum/controller/subsystem/processing/quirks/proc/filter_invalid_quirks(list/quirks)
	var/list/new_quirks = list()
	var/list/all_quirks = get_quirks()

	for (var/quirk_name in quirks)
		var/datum/quirk/quirk = all_quirks[quirk_name]
		if (isnull(quirk))
			continue

		var/blacklisted = FALSE

		for (var/list/blacklist as anything in quirk_blacklist)
			if (!(quirk in blacklist))
				continue

			for (var/other_quirk in blacklist)
				if (other_quirk in new_quirks)
					blacklisted = TRUE
					break

			if (blacklisted)
				break

		if (blacklisted)
			continue

		new_quirks += quirk_name

	// It is guaranteed that if no quirks are invalid, you can simply check through `==`
	if (new_quirks.len == quirks.len)
		return quirks

	return new_quirks

#undef RANDOM_QUIRK_BONUS
#undef MINIMUM_RANDOM_QUIRKS
