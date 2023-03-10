/datum/security_level
	/// Easy to stringify.
	var/name = "!!INVALID SECURITY LEVEL!!"
	/// Internal ID for switching and such
	var/id = "!!ABSTRACT"
	///Closest abstract type. Set to own path to prevent usage.
	var/abstract_type = /datum/security_level
	/// Used to determine which message to use.
	var/severity = INFINITY
	/// Are we the starting security level?
	var/default = FALSE
	// What message should be announced?

	var/message_up
	var/message_equal
	var/message_down

	var/datum/looping_sound // :smug:

	// Alert features
	/// Shuttle may be called without providing a reason
	var/allow_reasonless_shuttlecall = FALSE
	/// Alert level is not selectable by players
	var/allow_player_set = TRUE
	/// Alert level can not be changed from, while active, by players
	var/allow_player_changefrom = TRUE

/datum/security_level/proc/switching_up_to()
	CRASH("Attempted to raise to invalid level")

/datum/security_level/proc/switching_down_to()
	CRASH("Attempted to lower to invalid level")

/datum/security_level/proc/switching_equal_to()
	CRASH("Attempted to change equal to invalid level")
