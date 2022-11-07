/datum/preference/choiced/employer
	savefile_key = "employer"
	savefile_identifier = PREFERENCE_CHARACTER

/datum/preference/choiced/employer/create_default_value()
	return EMPLOYER_FREELANCER

/datum/preference/choiced/employer/init_possible_values()
	return list(EMPLOYER_FREELANCER, EMPLOYER_DAEDALUS, EMPLOYER_HERMES, EMPLOYER_AETHER, EMPLOYER_MARS_EXEC, EMPLOYER_PRIAPUS, EMPLOYER_ANANKE)

/datum/preference/choiced/employer/should_show_on_page(preference_tab)
	return preference_tab == PREFERENCE_TAB_CHARACTER_PREFERENCES
