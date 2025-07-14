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
	arguments.Cut(1, 2) // Pop out the command itself

	if(length(arguments) == 1)
		return

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

			var/option = copytext(str, 3)
			// Option-argument parsing
			var/list/option_argument_split = splittext(option, "=")
			if(length(option_argument_split) > 1)
				options[option_argument_split[1]] = jointext(option_argument_split.Copy(2), "")
			else
				options += option

			arguments.Cut(1, 2)
			continue

		options |= splittext(copytext(str, 2), "")
		arguments.Cut(1, 2)
