/datum/preference/choiced/employer
	savefile_key = "employer"
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/choiced/employer/create_default_value()
	return FREELANCER

/datum/preference/choiced/employer/init_possible_values()
	return list(FREELANCER, DAEDALUS, HERMES, AETHER, MARS_EXEC, PRIAPUS, ANANKE)

/datum/preference/choiced/employer/should_show_on_page(preference_tab)
	return preference_tab == PREFERENCE_TAB_CHARACTER_PREFERENCES
