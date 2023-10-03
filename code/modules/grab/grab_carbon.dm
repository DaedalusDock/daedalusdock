/mob/living/carbon/get_active_grabs()
	. = list()
	for(var/obj/item/hand_item/grab/grab in held_items)
		. += grab

// We're changing the default grab type here.
/mob/living/carbon/make_grab(atom/movable/target, grab_type = /datum/grab/normal/passive)
	. = ..()
