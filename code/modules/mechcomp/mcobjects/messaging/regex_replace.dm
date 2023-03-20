//Thank you mark
/obj/item/mcobject/messaging/regreplace
	name = "RegEx Replace Component"
	base_icon_state = "comp_regrep"
	var/expressionpatt = "original"
	var/expressionrepl = "replacement"
	var/expressionflag = "g"

/obj/item/mcobject/messaging/regreplace/Initialize(mapload)
	. = ..()
	MC_ADD_INPUT("replace string", check_str)
	MC_ADD_INPUT("set pattern", set_pattern)
	MC_ADD_INPUT("set replacement", set_replacement)
	MC_ADD_INPUT("set flags", set_flags)
	MC_ADD_CONFIG("Set Pattern", set_pattern_cfg)
	MC_ADD_CONFIG("Set Replacement", set_replacement_cfg)
	MC_ADD_CONFIG("Set Flags", set_flags_cfg)

/obj/item/mcobject/messaging/regreplace/examine(mob/user)
	. = ..()
	. += {"<br/><span class='notice'>Current Pattern: [html_encode(expressionpatt)]</span><br/>
		<span class='notice'>Current Replacement: [html_encode(expressionrepl)]</span><br/>
		<span class='notice'>Current Flags: [html_encode(expressionflag)]</span><br/>
		Your replacement string can contain $0-$9 to insert that matched group(things between parenthesis)<br/>
		$` will be replaced with the text that came before the match, and $' will be replaced by the text after the match.<br/>
		$0 or $& will be the entire matched string."}

/obj/item/mcobject/messaging/regreplace/proc/set_pattern(datum/mcmessage/input)
	expressionpatt = input.cmd

/obj/item/mcobject/messaging/regreplace/proc/set_replacement(datum/mcmessage/input)
	expressionrepl= input.cmd

/obj/item/mcobject/messaging/regreplace/proc/set_flags(datum/mcmessage/input)
	expressionflag = input.cmd

/obj/item/mcobject/messaging/regreplace/proc/set_pattern_cfg(mob/user, obj/item/tool)
	var/msg = stripped_input(user, "Enter pattern:", "Configure Component", expressionpatt)
	if(!msg)
		return
	expressionpatt = msg
	to_chat(user, span_notice("You set the pattern of [src] to [expressionpatt]."))
	return TRUE

/obj/item/mcobject/messaging/regreplace/proc/set_replacement_cfg(mob/user, obj/item/tool)
	var/msg = stripped_input(user, "Enter replacement:", "Configure Component", expressionrepl)
	if(!msg)
		return
	expressionrepl = msg
	to_chat(user, span_notice("You set the replacement of [src] to [expressionrepl]."))
	return TRUE

/obj/item/mcobject/messaging/regreplace/proc/set_flags_cfg(mob/user, obj/item/tool)
	var/msg = stripped_input(user, "Enter flags:", "Configure Component", expressionflag)
	if(!msg)
		return
	expressionflag = msg
	to_chat(user, span_notice("You set the flags of [src] to [expressionflag]."))
	return TRUE

/obj/item/mcobject/messaging/regreplace/proc/check_str(datum/mcmessage/input)
	if(!expressionpatt)
		return
	var/regex/R = new(expressionpatt, expressionflag)
	if(!R)
		return

	var/mod = R.Replace(input.cmd, expressionrepl)
	mod = strip_html(mod)
	if(mod)
		input.cmd = mod
		fire(input)
