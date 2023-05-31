/datum/codex_entry/tool
	name = "You shouldn't see this!"
	abstract_type = /datum/codex_entry/tool
	disambiguator = "tool"

/datum/codex_entry/tool/New(_display_name, list/_associated_paths, list/_associated_strings, _lore_text, _mechanics_text, _antag_text, _controls_text)
	. = ..()
	GLOB.tool_codex_entries += name

/datum/codex_entry/tool/crowbar
	name = "Crowbar"
	mechanics_text = "Capable of removing floor tiles or forcing open unpowered doors. Used for construction, or bashing an alien's skull inwards."
	lore_text = "The crowbar is clearly well made, but the branding has been scraped off long ago.  You’re fairly sure they’re all like this, isn’t that strange?"
	antag_text = "Causing a power outage and using a crowbar is a quick way to get into areas you shouldn’t be, just remember forcing open doors is very loud."

/datum/codex_entry/tool/wrench
	name = "Wrench"
	lore_text = "A short adjustable wrench, ever since the space-standardization of bolt sizes, why do they even make them adjustable anymore?"
	mechanics_text = "A tool for un-securing and securing machinery to the ground. Alongside deconstructing a lot of furniture, such as chairs, tables and empty crates."

/datum/codex_entry/tool/multitool
	name = "Multitool"
	lore_text = "Produced by Daedalus Industries, to this day, nobody knows what the little green screen is for."
	mechanics_text = "Used to manipulate a door’s function by pulsing the wires. Can also be used to reset locks on safes and secure briefcases. \
	Using the multitool on a wire will tell you how much power is in the wire’s network. \
	Furthermore, using a multitool on a blinking light will return it to normal function. "

/datum/codex_entry/tool/wirecutters
	name = "Wirecutters"
	lore_text = "Wirecutters with a cheap plastic grip, clearly Daedalus have been cost-cutting."
	mechanics_text = "Wirecutters are used to remove placed wire, bear in mind you will need insulated gloves to cut a wire with power going through it. \
	It can also cut the wires of doors, permanently activating the cut wire’s effect."
	antag_text = "Cutting the AI Control Wires on a door can stop the AI from interacting with the door full-stop, as opposed to the thirty seconds pulsing the wire provides. Use this to your advantage to stop the AI cornering you."

/datum/codex_entry/tool/weldingtool
	name = "Welding Tool"
	associated_paths = list(/obj/item/weldingtool)
	associated_strings = list("Welder")
	use_typesof = TRUE
	mechanics_text = "The welder is used for repairing damaged windows and walls; alongside welding shut doors, firelocks and vents. \
	Not just being a repair-tool, it is a potent melee weapon if it’s lit. Just don’t forget fuel."

