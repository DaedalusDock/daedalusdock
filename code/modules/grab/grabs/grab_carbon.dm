/mob/living/carbon/get_active_grabs()
	. = list()
	for(var/obj/item/hand_item/grab/grab in get_held_items())
		. += grab

/mob/living/carbon/make_grab(atom/movable/target,grab_type)
	. = ..(target, species?.grab_type || grab_type)
