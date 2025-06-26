/obj/item/stack
	var/latin = FALSE

/obj/item/stack/examine(mob/user)
	. = ..()
	if(singular_name)
		if (latin)
			if(get_amount()>1)
				to_chat(user, "There are [get_amount()] [singular_name]i in the stack.")
			else
				to_chat(user, "There is [get_amount()] [singular_name]us in the stack.")
		else
			if(get_amount()>1)
				to_chat(user, "There are [get_amount()] [singular_name]\s in the stack.")
			else
				to_chat(user, "There is [get_amount()] [singular_name] in the stack.")
		if(get_amount()>1)
			. += "There are [get_amount()] [singular_name]\s in the stack."
		else
			. += "There is [get_amount()] [singular_name] in the stack."
	else if(get_amount()>1)
		. += "There are [get_amount()] in the stack."
	else
		. += "There is [get_amount()] in the stack."
	. += "<span class='notice'>Alt-click to take a custom amount.</span>"
