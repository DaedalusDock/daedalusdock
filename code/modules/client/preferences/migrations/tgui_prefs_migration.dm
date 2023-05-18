/// Handle the migrations necessary from pre-tgui prefs to post-tgui prefs
/datum/preferences/proc/migrate_preferences_to_tgui_prefs_menu()
	migrate_antagonists()
	migrate_key_bindings()

// Key bindings used to be "key" -> list("action"),
// such as "X" -> list("swap_hands").
// This made it impossible to determine any order, meaning placing a new
// hotkey would produce non-deterministic order.
// tgui prefs menu moves this over to "swap_hands" -> list("X").
/datum/preferences/proc/migrate_key_bindings()
	var/new_key_bindings = list()

	for (var/unbound_hotkey in key_bindings["Unbound"])
		new_key_bindings[unbound_hotkey] = list()

	for (var/hotkey in key_bindings)
		if (hotkey == "Unbound")
			continue

		for (var/keybind in key_bindings[hotkey])
			if (keybind in new_key_bindings)
				new_key_bindings[keybind] |= hotkey
			else
				new_key_bindings[keybind] = list(hotkey)

	key_bindings = new_key_bindings

// Before tgui preferences menu, "traitor" would handle both roundstart, midround, and latejoin.
// These were split apart.
/datum/preferences/proc/migrate_antagonists()
	migrate_antagonist(ROLE_HERETIC, list(ROLE_HERETIC_SMUGGLER))
	migrate_antagonist(ROLE_MALF, list(ROLE_MALF_MIDROUND))
	migrate_antagonist(ROLE_OPERATIVE, list(ROLE_OPERATIVE_MIDROUND, ROLE_LONE_OPERATIVE))
	migrate_antagonist(ROLE_REV_HEAD, list(ROLE_PROVOCATEUR))
	migrate_antagonist(ROLE_TRAITOR, list(ROLE_SYNDICATE_INFILTRATOR, ROLE_SLEEPER_AGENT))
	migrate_antagonist(ROLE_WIZARD, list(ROLE_WIZARD_MIDROUND))

	// "Familes [sic] Antagonists" was the old name of the catch-all.
	migrate_antagonist("Familes Antagonists", list(ROLE_FAMILIES, ROLE_FAMILY_HEAD_ASPIRANT))

// If you have an antagonist enabled, it will add the alternative preferences for said antag in be_special.
// will_exist is the role we check if enabled, to_add list is the antagonists we add onto the be_special list.
/datum/preferences/proc/migrate_antagonist(will_exist, list/to_add)
	if (will_exist in be_special)
		for (var/add in to_add)
			be_special += add
