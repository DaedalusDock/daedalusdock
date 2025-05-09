/datum/c4_file/user
	name = "user account"
	extension = "USR"
	size = 1

	/// Login name, name on ID card.
	var/registered_name
	/// Job on ID card.
	var/assignment
	/// Access o- okay you get the idea.
	var/list/access

/datum/c4_file/user/copy()
	var/datum/c4_file/user/clone = ..()
	clone.registered_name = registered_name
	clone.assignment = assignment
	clone.access = access.Copy()
	return clone
