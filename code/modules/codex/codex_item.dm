/obj/item/get_codex_value()
	if(tool_behaviour && SScodex.get_entry_by_string(tool_behaviour))
		return tool_behaviour
	return ..()

