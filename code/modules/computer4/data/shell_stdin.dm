/// Struct for the parsed stdin
/datum/shell_stdin
	var/raw = ""
	var/command = ""
	var/list/arguments = list()
	var/list/options = list()

/datum/shell_stdin/New(text)
	arguments = splittext(text, " ")

	raw = text
	command = lowertext(arguments[1])
	options = list()

	if(length(arguments) == 1)
		return


	arguments.Cut(1, 2)

	// Parse out options
	for(var/str in arguments)
		// Dangling "-" is considered an argument per POSIX, so do not trim it from the arguments list.
		if(length(str) <= 1 || str[1] != "-")
			break

		if(str[2] == "-")
			if(length(str) == 2) // "--", cease parsing options
				arguments.Cut(1,2)
				break

			if(str[3] == "-") //This is an argument, not an option.
				break

			options += copytext(str, 3)
			arguments.Cut(1, 2)
			continue

		options |= splittext(copytext(str, 2), "")
		arguments.Cut(1, 2)
