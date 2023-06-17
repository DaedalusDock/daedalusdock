// Priorities must be in order!
/// The default priority level
#define PREFERENCE_PRIORITY_DEFAULT 1
/// The priority level for quirk-based prefs
#define PREFERENCE_PRIORITY_QUIRKS 2
/// The priority at which species runs, needed for external organs to apply properly.
#define PREFERENCE_PRIORITY_SPECIES 3
/// The priority at which gender is determined, needed for proper randomization.
#define PREFERENCE_PRIORITY_GENDER 4
/// The priority at which body type is decided, applied after gender so we can
/// support the "use gender" option.
#define PREFERENCE_PRIORITY_BODY_TYPE 5
/// The priority hair is applied. We apply human hair first, and moth hair after, only if they are a moth. Sorry.
#define PREFERENCE_PRIORITY_HUMAN_HAIR 6
/// The priority non-human hair is applied (used to apply moth hair after normal hair)
#define PREFERENCE_PRIORITY_NONHUMAN_HAIR 7
/// The priority at which names are decided, needed for proper randomization.
#define PREFERENCE_PRIORITY_NAMES 8
/// Preferences that aren't names, but change the name changes set by PREFERENCE_PRIORITY_NAMES.
#define PREFERENCE_PRIORITY_NAME_MODIFICATIONS 9
#define PREFERENCE_PRIORITY_APPEARANCE_MODS 10

/// The maximum preference priority, keep this updated, but don't use it for `priority`.
#define MAX_PREFERENCE_PRIORITY PREFERENCE_PRIORITY_APPEARANCE_MODS

/// For choiced preferences, this key will be used to set display names in constant data.
#define CHOICED_PREFERENCE_DISPLAY_NAMES "display_names"

/// An assoc list list of types to instantiated `/datum/preference` instances
GLOBAL_LIST_INIT(preference_entries, init_preference_entries())

/// An assoc list of preference entries by their `savefile_key`
GLOBAL_LIST_INIT(preference_entries_by_key, init_preference_entries_by_key())

/// A list of preference modules.
GLOBAL_LIST_INIT(all_pref_groups, init_all_pref_groups())

/proc/init_preference_entries()
	var/list/output = list()
	for (var/datum/preference/preference_type as anything in subtypesof(/datum/preference))
		if (initial(preference_type.abstract_type) == preference_type)
			continue
		output[preference_type] = new preference_type
	return output

/proc/init_preference_entries_by_key()
	var/list/output = list()
	for (var/datum/preference/preference_type as anything in subtypesof(/datum/preference))
		if (initial(preference_type.abstract_type) == preference_type)
			continue
		output[initial(preference_type.savefile_key)] = GLOB.preference_entries[preference_type]
	return output

/proc/init_all_pref_groups()
	. = list()
	for(var/datum/preference_group/module as anything in typesof(/datum/preference_group))
		if(initial(module.abstract_type) == module)
			continue

		. += new module()

	spawn(0)
		_setup_cats()

	sortTim(., GLOBAL_PROC_REF(cmp_pref_modules))

/proc/_setup_cats()
	for(var/datum/preference_group/category/P in GLOB.all_pref_groups)
		for(var/i in 1 to length(P.modules))
			P.modules[i] = locate(P.modules[i]) in GLOB.all_pref_groups

/// Returns a flat list of preferences in order of their priority
/proc/get_preferences_in_priority_order()
	var/list/preferences[MAX_PREFERENCE_PRIORITY]

	for (var/preference_type in GLOB.preference_entries)
		var/datum/preference/preference = GLOB.preference_entries[preference_type]
		LAZYADD(preferences[preference.priority], preference)

	var/list/flattened = list()
	for (var/index in 1 to MAX_PREFERENCE_PRIORITY)
		flattened += preferences[index]
	return flattened

/// Represents an individual preference.
/datum/preference
	/// The display default name when inserted into the chargen
	var/explanation = "ERROR"

	/// The key inside the savefile to use.
	/// This is also sent to the UI.
	/// Once you pick this, don't change it.
	var/savefile_key

	/// The category of preference, for use by the PreferencesMenu.
	/// This isn't used for anything other than as a key for UI data.
	/// It is up to the PreferencesMenu UI itself to interpret it.
	var/category = "misc"

	/// Do not instantiate if type matches this.
	var/abstract_type = /datum/preference

	/// What savefile should this preference be read from?
	/// Valid values are PREFERENCE_CHARACTER and PREFERENCE_PLAYER.
	/// See the documentation in [code/__DEFINES/preferences.dm].
	var/savefile_identifier

	/// The priority of when to apply this preference.
	/// Used for when you need to rely on another preference.
	var/priority = PREFERENCE_PRIORITY_DEFAULT

	/// If set, will be available to randomize, but only if the preference
	/// is for PREFERENCE_CHARACTER.
	var/can_randomize = TRUE

	/// If the selected species has this in its /datum/species/mutant_bodyparts,
	/// will show the feature as selectable.
	var/relevant_mutant_bodypart = null

	/// If the selected species has this in its /datum/species/species_traits,
	/// will show the feature as selectable.
	var/relevant_species_trait = null

	/// If the selected species has this in its /datum/species/var/cosmetic_organs,
	/// will show the feature as selectable.
	var/relevant_external_organ = null

	/// Any species that has any of the listed species traits will not have the option to pick this pref
	var/exclude_species_traits = list()

	/// If this preference is not accessible, do not attempt to apply it to mobs.
	var/requires_accessible = FALSE

	/// A typepath for a sub preference. Ex: Hair Style's sub_preference is /datum/preference/color/hair_color
	var/sub_preference

	/// Is this type a sub preference?
	var/is_sub_preference = FALSE

/// Called on the saved input when retrieving.
/// Also called by the value sent from the user through UI. Do not trust it.
/// Input is the value inside the savefile, output is to tell other code
/// what the value is.
/// This is useful either for more optimal data saving or for migrating
/// older data.
/// Must be overridden by subtypes.
/// Can return null if no value was found.
/datum/preference/proc/deserialize(input, datum/preferences/preferences)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(FALSE)
	CRASH("`deserialize()` was not implemented on [type]!")

/// Called on the input while saving.
/// Input is the current value, output is what to save in the savefile.
/datum/preference/proc/serialize(input)
	SHOULD_NOT_SLEEP(TRUE)
	return input

/// Produce a default, potentially random value for when no value for this
/// preference is found in the savefile.
/// Either this or create_informed_default_value must be overriden by subtypes.
/datum/preference/proc/create_default_value()
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(FALSE)
	CRASH("`create_default_value()` was not implemented on [type]!")

/// Produce a default, potentially random value for when no value for this
/// preference is found in the savefile.
/// Unlike create_default_value(), will provide the preferences object if you
/// need to use it.
/// If not overriden, will call create_default_value() instead.
/datum/preference/proc/create_informed_default_value(datum/preferences/preferences)
	return create_default_value()

/// Produce a random value for the purposes of character randomization.
/// Will just create a default value by default.
/datum/preference/proc/create_random_value(datum/preferences/preferences)
	return create_informed_default_value(preferences)

/// Returns whether or not a preference can be randomized.
/datum/preference/proc/is_randomizable()
	SHOULD_NOT_OVERRIDE(TRUE)
	return savefile_identifier == PREFERENCE_CHARACTER && can_randomize

/// Given a savefile, return either the saved data or an acceptable default.
/// This will write to the savefile if a value was not found with the new value.
/datum/preference/proc/read(savefile/savefile, datum/preferences/preferences)
	SHOULD_NOT_OVERRIDE(TRUE)

	var/value

	if (!isnull(savefile))
		READ_FILE(savefile[savefile_key], value)

	if (isnull(value))
		return null
	else
		return deserialize(value, preferences)

/// Given a savefile, writes the inputted value.
/// Returns TRUE for a successful application.
/// Return FALSE if it is invalid.
/datum/preference/proc/write(savefile/savefile, value)
	SHOULD_NOT_OVERRIDE(TRUE)

	if (!is_valid(value))
		return FALSE

	if (!isnull(savefile))
		WRITE_FILE(savefile[savefile_key], serialize(value))

	return TRUE

/// Apply this preference onto the given client.
/// Called when the savefile_identifier == PREFERENCE_PLAYER.
/datum/preference/proc/apply_to_client(client/client, value)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(FALSE)
	return

/// Fired when the preference is updated.
/// Calls apply_to_client by default, but can be overridden.
/datum/preference/proc/apply_to_client_updated(client/client, value)
	SHOULD_NOT_SLEEP(TRUE)
	apply_to_client(client, value)

/// Apply this preference onto the given human.
/// Must be overriden by subtypes.
/// Called when the savefile_identifier == PREFERENCE_CHARACTER.
/datum/preference/proc/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences) //PARIAH EDIT
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(FALSE)
	CRASH("`apply_to_human()` was not implemented for [type]!")

/// Returns which savefile to use for a given savefile identifier
/datum/preferences/proc/get_savefile_for_savefile_identifier(savefile_identifier)
	RETURN_TYPE(/savefile)

	if (!parent)
		return null

	// Both of these will cache savefiles, but only for a tick.
	// This is because storing a savefile will lock it, causing later issues down the line.
	// Do not change them to addtimer, since the timer SS might not be running at this time.

	switch (savefile_identifier)
		if (PREFERENCE_CHARACTER)
			if (!character_savefile)
				character_savefile = new /savefile(path)
				character_savefile.cd = "/character[default_slot]"
				spawn (1)
					character_savefile = null
			return character_savefile
		if (PREFERENCE_PLAYER)
			if (!game_savefile)
				game_savefile = new /savefile(path)
				game_savefile.cd = "/"
				spawn (1)
					game_savefile = null
			return game_savefile
		else
			CRASH("Unknown savefile identifier [savefile_identifier]")

/// Read a /datum/preference type and return its value.
/// This will write to the savefile if a value was not found with the new value.
/datum/preferences/proc/read_preference(preference_type)
	var/datum/preference/preference_entry = GLOB.preference_entries[preference_type]
	if (isnull(preference_entry))
		var/extra_info = ""

		// Current initializing subsystem is important to know because it might be a problem with
		// things running pre-assets-initialization.
		if (!isnull(Master.current_initializing_subsystem))
			extra_info = "Info was attempted to be retrieved while [Master.current_initializing_subsystem] was initializing."
		else if (!MC_RUNNING())
			extra_info = "Info was attempted to be retrieved before the MC started, but not while it was actively initializing a subsystem"

		CRASH("Preference type `[preference_type]` is invalid! [extra_info]")

	if (preference_type in value_cache)
		. = value_cache[preference_type]
		if(islist(.))
			return (.):Copy()
		return

	var/value = preference_entry.read(get_savefile_for_savefile_identifier(preference_entry.savefile_identifier), src)
	if (isnull(value))
		value = preference_entry.create_informed_default_value(src)
		if (write_preference(preference_entry, value))
			return value
		else
			CRASH("Couldn't write the default value for [preference_type] (received [value])")

	value_cache[preference_type] = value
	if(islist(value))
		return value:Copy()
	return value

/// Set a /datum/preference entry.
/// Returns TRUE for a successful preference application.
/// Returns FALSE if it is invalid.
/datum/preferences/proc/write_preference(datum/preference/preference, preference_value)
	var/savefile = get_savefile_for_savefile_identifier(preference.savefile_identifier)
	var/new_value = preference.deserialize(preference_value, src)
	var/success = preference.write(savefile, new_value)
	if (success)
		value_cache[preference.type] = new_value
	return success

/// Will perform an update on the preference, but not write to the savefile.
/// This will, for instance, update the character preference view.
/// Performs sanity checks.
/datum/preferences/proc/update_preference(datum/preference/preference, preference_value)
	if (!preference.is_accessible(src))
		return FALSE

	var/old_value = read_preference(preference.type)
	var/new_value = preference.deserialize(preference_value, src)
	var/success = preference.write(null, new_value)

	if (!success)
		return FALSE

	if(old_value != new_value)
		preference.value_changed(src, new_value, old_value)

	recently_updated_keys |= preference.type
	value_cache[preference.type] = new_value

	if (preference.savefile_identifier == PREFERENCE_PLAYER)
		preference.apply_to_client_updated(parent, read_preference(preference.type))
	else
		spawn(-1)
			character_preview_view?.update_body()

	return TRUE

/// Called when a user updates the value of this preference.
/datum/preference/proc/value_changed(datum/preferences/prefs, new_value, old_value)
	return

/// Checks that a given value is valid.
/// Must be overriden by subtypes.
/// Any type can be passed through.
/datum/preference/proc/is_valid(value)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(FALSE)
	CRASH("`is_valid()` was not implemented for [type]!")

/// Returns data to be sent to users in the menu
/datum/preference/proc/compile_ui_data(mob/user, value)
	SHOULD_NOT_SLEEP(TRUE)

	return serialize(value)

/// Returns data compiled into the preferences JSON asset
/datum/preference/proc/compile_constant_data()
	SHOULD_NOT_SLEEP(TRUE)

	return null

/// Returns whether or not this preference is accessible.
/// If FALSE, will not show in the UI and will not be editable (by update_preference).
/datum/preference/proc/is_accessible(datum/preferences/preferences)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

	if (!isnull(relevant_mutant_bodypart) || !isnull(relevant_species_trait) || !isnull(relevant_external_organ))
		var/species_type = preferences.read_preference(/datum/preference/choiced/species)

		var/datum/species/species = new species_type
		if (!(savefile_key in species.get_features()))
			return FALSE

	return TRUE

/datum/preference/proc/button_act(mob/user, datum/preferences/prefs, list/params)
	if(user_edit(user, prefs, params))
		return TRUE
	return FALSE

/datum/preference/proc/user_edit(mob/user, datum/preferences/prefs, list/params)
	CRASH("Unimplimented preference edit!")

/datum/preference/proc/get_button(datum/preferences/prefs)
	CRASH("Unimplimented button!")

/// A preference that is a choice of one option among a fixed set.
/// Used for preferences such as clothing.
/datum/preference/choiced
	/// If this is TRUE, icons will be generated.
	/// This is necessary for if your `init_possible_values()` override
	/// returns an assoc list of names to atoms/icons.
	var/should_generate_icons = FALSE

	var/list/cached_values

	var/list/cached_serialized_values

	abstract_type = /datum/preference/choiced

	///Defines whether get_button() should include cycle arrows
	var/cyclable = TRUE

/// Returns a list of every possible value.
/// The first time this is called, will run `init_values()`.
/// Return value can be in the form of:
/// - A flat list of raw values, such as list(MALE, FEMALE, PLURAL).
/// - An assoc list of raw values to atoms/icons.
/datum/preference/choiced/proc/get_choices()
	// Override `init_values()` instead.
	SHOULD_NOT_OVERRIDE(TRUE)

	if (isnull(cached_values))
		cached_values = init_possible_values()
		ASSERT(cached_values.len)

	return cached_values

/// Returns a list of every possible value, serialized.
/// Return value can be in the form of:
/// - A flat list of serialized values, such as list(MALE, FEMALE, PLURAL).
/// - An assoc list of serialized values to atoms/icons.
/datum/preference/choiced/proc/get_choices_serialized()
	// Override `init_values()` instead.
	SHOULD_NOT_OVERRIDE(TRUE)
	if(isnull(cached_serialized_values))
		cached_serialized_values = list()
		var/choices = get_choices()

		if (should_generate_icons)
			for (var/choice in choices)
				cached_serialized_values[serialize(choice)] = choices[choice]
		else
			for (var/choice in choices)
				cached_serialized_values += serialize(choice)

	return cached_serialized_values

/// Returns a list of every possible value.
/// This must be overriden by `/datum/preference/choiced` subtypes.
/// Return value can be in the form of:
/// - A flat list of raw values, such as list(MALE, FEMALE, PLURAL).
/// - An assoc list of raw values to atoms/icons, in which case
/// icons will be generated.
/datum/preference/choiced/proc/init_possible_values()
	CRASH("`init_possible_values()` was not implemented for [type]!")

/datum/preference/choiced/is_valid(value)
	return value in get_choices()

/datum/preference/choiced/deserialize(input, datum/preferences/preferences)
	return sanitize_inlist(input, get_choices(), create_default_value())

/datum/preference/choiced/create_default_value()
	return pick(get_choices())

/datum/preference/choiced/compile_constant_data()
	var/list/data = list()

	var/list/choices = list()

	for (var/choice in get_choices())
		choices += choice

	data["choices"] = choices

	if (should_generate_icons)
		var/list/icons = list()

		for (var/choice in choices)
			icons[choice] = get_spritesheet_key(choice)

		data["icons"] = icons

	return data

/datum/preference/choiced/button_act(mob/user, datum/preferences/prefs, list/params)
	if(params["cycle"])
		var/list/choices = get_choices()
		var/new_index = choices.Find(prefs.read_preference(type)) + (params["cycle"] == "down" ? (-1) : 1)
		if(new_index == 0)
			new_index = length(choices)
		else if(new_index > length(choices))
			new_index = 1

		return prefs.update_preference(src, serialize(choices[new_index]))
	return ..()

/datum/preference/choiced/user_edit(mob/user, datum/preferences/prefs)
	var/input = tgui_input_list(user, "Change [explanation]",, get_choices_serialized(), serialize(prefs.read_preference(type)))
	if(!input)
		return
	return prefs.update_preference(src, input)

/datum/preference/choiced/get_button(datum/preferences/prefs)
	if(!cyclable)
		return button_element(prefs, capitalize(serialize(prefs.read_preference(type))), "pref_act=[type]")
	else
		return {"
			[button_element(prefs, "<", "pref_act=[type];cycle=down")]
			[button_element(prefs, capitalize(serialize(prefs.read_preference(type))), "pref_act=[type]")]
			[button_element(prefs, ">", "pref_act=[type];cycle=up")]
		"}

/// A preference that represents an RGB color of something.
/// Will give the value as 6 hex digits, without a hash.
/datum/preference/color
	abstract_type = /datum/preference/color

/datum/preference/color/deserialize(input, datum/preferences/preferences)
	return sanitize_hexcolor(input)

/datum/preference/color/create_default_value()
	return random_color()

/datum/preference/color/serialize(input)
	return sanitize_hexcolor(input)

/datum/preference/color/is_valid(value)
	return findtext(value, GLOB.is_color)

/datum/preference/color/user_edit(mob/user, datum/preferences/prefs, list/params)
	var/input = input(user, "Change [explanation]",, prefs.read_preference(type)) as null|color
	if(!input)
		return
	return prefs.update_preference(src, input)

/datum/preference/color/get_button(datum/preferences/prefs)
	return color_button_element(prefs, prefs.read_preference(type), "pref_act=[type]")

/// A numeric preference with a minimum and maximum value
/datum/preference/numeric
	/// The minimum value
	var/minimum

	/// The maximum value
	var/maximum

	/// The step of the number, such as 1 for integers or 0.5 for half-steps.
	var/step = 1

	abstract_type = /datum/preference/numeric

/datum/preference/numeric/deserialize(input, datum/preferences/preferences)
	if(istext(input)) // Sometimes TGUI will return a string instead of a number, so we take that into account.
		input = text2num(input) // Worst case, it's null, it'll just use create_default_value()
	return sanitize_float(input, minimum, maximum, step, create_default_value())

/datum/preference/numeric/serialize(input)
	return sanitize_float(input, minimum, maximum, step, create_default_value())

/datum/preference/numeric/create_default_value()
	return rand(minimum, maximum)

/datum/preference/numeric/is_valid(value)
	return isnum(value) && value >= round(minimum, step) && value <= round(maximum, step)

/datum/preference/numeric/compile_constant_data()
	return list(
		"minimum" = minimum,
		"maximum" = maximum,
		"step" = step,
	)

/datum/preference/numeric/user_edit(mob/user, datum/preferences/prefs)
	var/input = tgui_input_number(user, "Change [explanation] ([minimum] - [maximum][step != 1 ? "increment [step]" : ""])",, prefs.read_preference(type), maximum, minimum, round_value = step)
	if(!input)
		return
	return prefs.update_preference(src, input)

/datum/preference/numeric/get_button(datum/preferences/prefs)
	return button_element(prefs, prefs.read_preference(type), "pref_act=[type]")

/// A prefernece whose value is always TRUE or FALSE
/datum/preference/toggle
	abstract_type = /datum/preference/toggle

	/// The default value of the toggle, if create_default_value is not specified
	var/default_value = TRUE

/datum/preference/toggle/create_default_value()
	return default_value

/datum/preference/toggle/deserialize(input, datum/preferences/preferences)
	return !!input

/datum/preference/toggle/is_valid(value)
	return value == TRUE || value == FALSE

/datum/preference/text
	abstract_type = /datum/preference/text

/datum/preference/text/deserialize(input, datum/preferences/preferences)
	return STRIP_HTML_SIMPLE(input, MAX_FLAVOR_LEN)

/datum/preference/text/create_default_value()
	return ""

/datum/preference/text/is_valid(value)
	return istext(value)

///Holds any kind of abstract list data you'd like it to. MUST impliment `is_valid`!
/datum/preference/blob
	abstract_type = /datum/preference/blob

/datum/preference/blob/create_default_value()
	return list()

/datum/preference/blob/deserialize(input, datum/preferences/preferences)
	if(!islist(input))
		return list()
	return input

/datum/preference/blob/is_valid(value)
	return islist(value)

/datum/preference/blob/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return
