/// A screenshot test to make sure every antag icon in the preferences menu is consistent
/datum/unit_test/screenshot/screenshot_antag_icons
	name = "SCREENSHOTS: Antag Portraits"

/datum/unit_test/screenshot/screenshot_antag_icons/Run()
	var/datum/asset/spritesheet/antagonists/antagonists = get_asset_datum(/datum/asset/spritesheet/antagonists)

	//Create a github job collapse category.
	log_test("::group::[type]")

	for (var/antag_icon_key in antagonists.antag_icons)
		var/icon/reference_icon = antagonists.antag_icons[antag_icon_key]

		var/icon/icon = new()
		icon.Insert(reference_icon, null, SOUTH, 1)
		test_screenshot(antag_icon_key, icon)

	log_test("::endgroup::")

/// Sprites generated for the antagonists panel
/datum/asset/spritesheet/antagonists
	name = "antagonists"
	abstract_type = /datum/asset/spritesheet/antagonists //This ensures it doesn't load unless it's requested.

	/// Mapping of spritesheet keys -> icons
	var/list/antag_icons = list()

/datum/asset/spritesheet/antagonists/create_spritesheets()
	// Antagonists that don't have a dynamic ruleset, but do have a preference
	var/static/list/non_ruleset_antagonists = list(
		ROLE_FUGITIVE = /datum/antagonist/fugitive,
		ROLE_LONE_OPERATIVE = /datum/antagonist/nukeop/lone,
	)

	var/list/antagonists = non_ruleset_antagonists.Copy()

	for (var/datum/dynamic_ruleset/ruleset as anything in subtypesof(/datum/dynamic_ruleset))
		var/datum/antagonist/antagonist_type = initial(ruleset.antag_datum)
		if (isnull(antagonist_type))
			continue

		// antag_flag is guaranteed to be unique by unit tests.
		antagonists[initial(ruleset.antag_flag)] = antagonist_type

	var/list/generated_icons = list()

	for (var/antag_flag in antagonists)
		var/datum/antagonist/antagonist_type = antagonists[antag_flag]

		// antag_flag is guaranteed to be unique by unit tests.
		var/spritesheet_key = serialize_antag_name(antag_flag)

		if (!isnull(generated_icons[antagonist_type]))
			antag_icons[spritesheet_key] = generated_icons[antagonist_type]
			continue

		var/datum/antagonist/antagonist = new antagonist_type
		var/icon/preview_icon = antagonist.get_preview_icon()

		if (isnull(preview_icon))
			continue

		qdel(antagonist)

		// preview_icons are not scaled at this stage INTENTIONALLY.
		// If an icon is not prepared to be scaled to that size, it looks really ugly, and this
		// makes it harder to figure out what size it *actually* is.
		generated_icons[antagonist_type] = preview_icon
		antag_icons[spritesheet_key] = preview_icon

	for (var/spritesheet_key in antag_icons)
		Insert(spritesheet_key, antag_icons[spritesheet_key])

/// Serializes an antag name to be used for preferences UI
/proc/serialize_antag_name(antag_name)
	// These are sent through CSS, so they need to be safe to use as class names.
	return lowertext(sanitize_css_class_name(antag_name))
