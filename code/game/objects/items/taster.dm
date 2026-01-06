/obj/item/taster
	name = "taster"
	desc = "Tastes things, so you don't have to!"
	icon = 'icons/obj/surgery.dmi'
	icon_state = "tonguenormal"

	w_class = WEIGHT_CLASS_TINY

	var/taste_sensitivity = 15

/obj/item/taster/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)

	var/atom/O = interacting_with // Yes i am supremely lazy

	if(!O.reagents)
		to_chat(user, span_notice("[src] cannot taste [O], since [O.p_they()] [O.p_have()] have no reagents."))
		return NONE

	else if(O.reagents.total_volume == 0)
		to_chat(user, "<span class='notice'>[src] cannot taste [O], since [O.p_they()] [O.p_are()] empty.</span>")
		return NONE

	else
		var/message = O.reagents.generate_taste_message(user, taste_sensitivity)
		to_chat(user, "<span class='notice'>[src] tastes <span class='italics'>[message]</span> in [O].</span>")
		return ITEM_INTERACT_SUCCESS
