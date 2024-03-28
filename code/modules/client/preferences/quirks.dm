/datum/preference/blob/quirks
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "quirked_up"

/datum/preference/blob/quirks/deserialize(input, datum/preferences/preferences)
	if(!islist(input))
		return create_default_value()

	input = SSquirks.filter_invalid_quirks(input)

	return input

/datum/preference/blob/quirks/create_default_value()
	return list()

/datum/preference/blob/quirks/user_edit(mob/user, datum/preferences/prefs, list/params)
	if(params["info"])
		var/datum/quirk/Q = SSquirks.quirks[params["info"]]
		if(!Q)
			return
		var/datum/browser/window = new(usr, "QuirkInfo", initial(Q.name), 400, 120)
		window.set_content(initial(Q.desc))
		window.open()
		return FALSE

	if(params["toggle_quirk"]) //Deserialize sanitizes this fine so we can accept junk data
		var/quirk = params["toggle_quirk"]
		var/list/user_quirks = prefs.read_preference(type)
		if(quirk in user_quirks)
			user_quirks -= quirk
		else
			user_quirks += quirk
		return prefs.update_preference(src, user_quirks)
