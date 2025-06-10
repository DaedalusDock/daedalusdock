/datum/storage/trash_bag
	open_sound = null

/datum/storage/trash_bag/can_dump_contents(atom/destination, mob/user)
	if(istype(parent.loc, /obj/structure/trash_can))
		return FALSE
	return ..()
