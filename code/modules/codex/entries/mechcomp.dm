/datum/codex_entry/mechcomp
	abstract_type = /datum/codex_entry/mechcomp
	disambiguator = "mechcomp"

/datum/codex_entry/mechcomp/New(_display_name, list/_associated_paths, list/_associated_strings, _lore_text, _mechanics_text, _antag_text, _controls_text)
	. = ..()
	GLOB.mechcomp_codex_entries += name

/datum/codex_entry/mechcomp/array
	name = "Array (Data Type)"
	mechanics_text = "Components communicate by using text called Messages.Some components will output a special type called and Array, and require a \
	<span codexlink='Array Access Component'>special component</span> to make use of.<br> \
	Arrays are messages with a special format to denote they are an Array. \
	The \"=\" symbol creates a Key:Value pair, where accessing the Array using that Key will output the linked Value. \
	The \"&\" symbol ends the Key:Value pair and starts a new one."

/datum/codex_entry/mechcomp/array_access
	name = "Array Access Component"
	mechanics_text = "Accesses the Value of an <span codexlink='Array (Data Type)'>Array</span> based on it's trigger.<br>\
	<b>Example</b><br> \
	A <span codexlink='Radio Scanner Component'>Radio Scanner</span> may output \"name=John Doe&message=Hello\". \
	You can access the message by setting the trigger to \"message\". The output will be \"Hello\"."
	associated_paths = list(/obj/item/mcobject/messaging/wifi_split)

/datum/codex_entry/mechcomp/radio_scanner
	name = "Radio Scanner Component"
	mechanics_text = "Outputs speech heard over it's frequency as an <span codexlink='Array (Data Type)'>Array</span>."
	associated_paths = list(/obj/item/mcobject/messaging/radioscanner)

/datum/codex_entry/mechcomp/and
	name = "AND Component"
	mechanics_text = "After receiving a Message in one input, it will wait the duration of it's Time Window. If the other input receives a \
	message during this window, it will send it's output."
	associated_paths = list(/obj/item/mcobject/messaging/and)

/datum/codex_entry/mechcomp/or
	name = "OR Component"
	mechanics_text = "After receiving a Message in any input, if it matches the Trigger, the component will send it's output."
	associated_paths = list(/obj/item/mcobject/messaging/or)

/datum/codex_entry/mechcomp/arithmetic
	name = "Arithmetic Component"
	mechanics_text = "Using it's \"A\" and \"B\" inputs, it can perform various mathematical operations."
	associated_paths = list(/obj/item/mcobject/messaging/arithmetic)

/datum/codex_entry/mechcomp/array_builder
	name = "Array Component"
	mechanics_text = "Used to create an internal <span codexlink='Array (Data Type)'>Array</span>.<br\
	<b>Functions</b><br>\
	Push Value: Output the Value for the inputted Key.<br>\
	Add Association: Create a new Key:Value pair.<br>\
	Remove Association: Remove a Key:Value pair.<br>\
	<br>\
	<b>Modes</b>\
	Mutable: A standard <span codexlink='Array (Data Type)'>Array</span>.<br>\
	Immutable: A standard <span codexlink='Array (Data Type)'>Array</span> where Key:Value pairs cannot be modified once created.<br>\
	List: Instead of replacing Values when inputting a new one, the new value will be appended to the old one."
	associated_paths = list(/obj/item/mcobject/messaging/association)

/datum/codex_entry/mechcomp/button
	name = "Button Component"
	mechanics_text = "Sends an output when pressed."
	associated_paths = list(/obj/item/mcobject/messaging/button)

/datum/codex_entry/mechcomp/delay
	name = "Delay Component"
	mechanics_text = "When receiving a Message, the received input will be outputted after a set delay."
	associated_paths = list(/obj/item/mcobject/messaging/delay)

/datum/codex_entry/mechcomp/dispatch
	name = "Dispatch Component"
	//I just yoinked this from the Goon wiki, https://wiki.ss13.co/MechComp
	mechanics_text = "Similar to the <span codexlink='Simple Find Component'>Simple Find Component</span>, \
	but it allows filters to be set on a per-connection basis. \
	When creating an outgoing connection from the Dispatch Component, you have the option to add a comma-delimited list of filters. \
	The incoming signal must contain at least one of these filters or it will not be passed to the connected component.\
	The filter list can be left blank to allow all messages to pass.<br>\
	There is also an exact mode toggle - when exact mode is on, the incoming signal must match a filter exactly (case insensitive). \
	Connections with no filter will still fire for all messages in exact mode. \
	If Single Output Mode is set, then only the first connection with a matching filter will fire. ."
	associated_paths = list(/obj/item/mcobject/messaging/dispatch)

/datum/codex_entry/mechcomp/simple_find
	name = "Simple Find Component"
	mechanics_text = "Searches for text in a Message, and relays the message, or outputs it's own. Can be set to only look for exact matches."
	associated_paths = list(/obj/item/mcobject/messaging/signal_check)
