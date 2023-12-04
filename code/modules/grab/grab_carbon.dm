// We're changing the default grab type here.
/mob/living/carbon/make_grab(atom/movable/target, grab_type = /datum/grab/normal/passive)
	. = ..()
