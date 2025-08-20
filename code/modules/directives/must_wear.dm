/datum/directive/must_wear
	abstract_type = /datum/directive/must_wear

	severity = DIRECTIVE_SEVERITY_LOW

	reward = 1000
	/// The name of the thing all colonists must wear.
	var/object_name

/datum/directive/must_wear/New()
	..()
	name = "Enforced Clothing ([object_name])"
	desc = "All colonists are required to wear [object_name] at all times."

/datum/directive/must_wear/get_announce_start_text()
	return "All colonists are now required to be wearing [object_name] at all times."

/datum/directive/must_wear/get_announce_end_text(successful)
	return "Wearing [object_name] is no longer enforced by law."

/datum/directive/must_wear/hats
	object_name = "a hat or helmet"
	mutual_blacklist = list(/datum/directive/must_not_wear/hats)

/datum/directive/must_wear/gloves
	object_name = "gloves"
	mutual_blacklist = list(/datum/directive/must_not_wear/gloves)

/datum/directive/must_wear/shoes
	object_name = "shoes"
	mutual_blacklist = list(/datum/directive/must_not_wear/shoes)

// Inverse //
/datum/directive/must_not_wear
	abstract_type = /datum/directive/must_not_wear

	severity = DIRECTIVE_SEVERITY_LOW

	/// The name of the thing all colonists must not wear.
	var/object_name

/datum/directive/must_not_wear/New()
	..()
	name = "Prohibited Clothing ([object_name])"
	desc = "Wearing [object_name] is prohibited."

/datum/directive/must_not_wear/get_announce_start_text()
	return "The wearing of [object_name] is now prohibited."

/datum/directive/must_not_wear/get_announce_end_text(successful)
	return "The wearing of [object_name] is no longer prohibited."

/datum/directive/must_not_wear/hats
	object_name = "hats and helmets"
	mutual_blacklist = list(/datum/directive/must_wear/hats)

/datum/directive/must_not_wear/gloves
	object_name = "gloves"
	mutual_blacklist = list(/datum/directive/must_wear/gloves)

/datum/directive/must_not_wear/shoes
	object_name = "shoes"
	mutual_blacklist = list(/datum/directive/must_wear/shoes)
