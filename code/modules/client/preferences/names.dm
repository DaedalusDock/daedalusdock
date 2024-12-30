/// A preference for a name. Used not just for normal names, but also for clown names, etc.
/datum/preference/name
	category = "names"
	priority = PREFERENCE_PRIORITY_NAMES
	savefile_identifier = PREFERENCE_CHARACTER
	abstract_type = /datum/preference/name

	/// These will be grouped together on the preferences menu
	var/group

	/// Whether or not to allow numbers in the person's name
	var/allow_numbers = TRUE

	/// If the highest priority job matches this, will prioritize this name in the UI
	var/relevant_job

/datum/preference/name/apply_to_human(mob/living/carbon/human/target, value)
	// Only real_name applies directly, everything else is applied by something else
	return

/datum/preference/name/deserialize(input, datum/preferences/preferences)
	return reject_bad_name("[input]", allow_numbers)

/datum/preference/name/serialize(input)
	// `is_valid` should always be run before `serialize`, so it should not
	// be possible for this to return `null`.
	return reject_bad_name(input, allow_numbers)

/datum/preference/name/is_valid(value)
	return istext(value) && !isnull(reject_bad_name(value, allow_numbers))

/datum/preference/name/user_edit(mob/user, datum/preferences/prefs)
	var/input = tgui_input_text(user, "Change [explanation]",, serialize(prefs.read_preference(type)))
	if(!input)
		return
	. = prefs.update_preference(src, input)

	if(istype(user, /mob/dead/new_player))
		var/mob/dead/new_player/player = user
		if(player.npp.active_tab == "game")
			player.npp.change_tab("game") // Reload name
	return .

/datum/preference/name/get_button(datum/preferences/prefs)
	return button_element(prefs, capitalize(serialize(prefs.read_preference(type))), "pref_act=[type]")

/// A character's real name
/datum/preference/name/real_name
	explanation = "Name"
	// The `_` makes it first in ABC order.
	group = "_real_name"
	savefile_key = "real_name"

/datum/preference/name/real_name/apply_to_human(mob/living/carbon/human/target, value)
	target.set_real_name(value)

/datum/preference/name/real_name/create_informed_default_value(datum/preferences/preferences)
	var/species_type = preferences.read_preference(/datum/preference/choiced/species)
	var/gender = preferences.read_preference(/datum/preference/choiced/gender)

	var/datum/species/species = new species_type

	return species.random_name(gender, unique = TRUE)

/datum/preference/name/real_name/deserialize(input, datum/preferences/preferences)
	input = ..(input)
	if (!input)
		return input

	if (CONFIG_GET(flag/humans_need_surnames) && preferences.read_preference(/datum/preference/choiced/species) == /datum/species/human)
		var/first_space = findtext(input, " ")
		if(!first_space) //we need a surname
			input += " [pick(GLOB.last_names)]"
		else if(first_space == length(input))
			input += "[pick(GLOB.last_names)]"

	return reject_bad_name(input, allow_numbers)

/// The name for a backup human, when nonhumans are made into head of staff
/datum/preference/name/backup_human
	explanation = "Backup Human Name"
	group = "backup_human"
	savefile_key = "human_name"

/datum/preference/name/backup_human/create_informed_default_value(datum/preferences/preferences)
	var/gender = preferences.read_preference(/datum/preference/choiced/gender)

	return random_unique_name(gender)

/datum/preference/name/clown
	savefile_key = "clown_name"

	explanation = "Entertainer Name"
	group = "fun"
	relevant_job = /datum/job/clown

/datum/preference/name/clown/create_default_value()
	return pick(GLOB.clown_names)

/datum/preference/name/cyborg
	savefile_key = "cyborg_name"

	allow_numbers = TRUE
	can_randomize = FALSE

	explanation = "Cyborg Name"
	group = "silicons"
	relevant_job = /datum/job/cyborg

/datum/preference/name/cyborg/create_default_value()
	return DEFAULT_CYBORG_NAME

/datum/preference/name/ai
	savefile_key = "ai_name"

	allow_numbers = TRUE
	explanation = "AI Name"
	group = "silicons"
	relevant_job = /datum/job/ai

/datum/preference/name/ai/create_default_value()
	return pick(GLOB.ai_names)

/datum/preference/name/religion
	savefile_key = "religion_name"

	allow_numbers = TRUE

	explanation = "Religion Name"
	group = "religion"

/datum/preference/name/religion/create_default_value()
	return pick(GLOB.religion_names)

/datum/preference/name/deity
	savefile_key = "deity_name"

	allow_numbers = TRUE
	can_randomize = FALSE

	explanation = "(Chaplain) Deity Name"
	group = "religion"

/datum/preference/name/deity/create_default_value()
	return DEFAULT_DEITY

/datum/preference/name/bible
	savefile_key = "bible_name"

	allow_numbers = TRUE
	can_randomize = FALSE

	explanation = "(Chaplain) Book Name"
	group = "religion"

/datum/preference/name/bible/create_default_value()
	return DEFAULT_BIBLE
