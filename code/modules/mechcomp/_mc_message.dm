///When we have our ghetto computer 3, this will be more useful.
/datum/mcmessage
	var/cmd = MC_BOOL_TRUE

/datum/mcmessage/New(_cmd)
	cmd = _cmd

/datum/mcmessage/proc/True()
	return (cmd == MC_BOOL_TRUE)
