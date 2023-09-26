/mob/living/proc/get_active_grabs()
	. = list()
	for(var/obj/item/hand_item/grab/G in held_items)
		. += G

/// Returns TRUE if src is grabbing hold of the target
/mob/living/proc/is_grabbing(atom/movable/AM)
	RETURN_TYPE(/obj/item/hand_item/grab)
	for(var/obj/item/hand_item/grab/G in get_active_grabs())
		if(G.affecting == AM)
			return G

/// Release all grabs we have
/mob/living/proc/release_all_grabs()
	for(var/obj/item/hand_item/grab/G in get_active_grabs())
		qdel(G)

/// Release the given movable from a grab
/mob/living/proc/release_grab(atom/movable/AM)
	for(var/obj/item/hand_item/grab/G in get_active_grabs())
		if(G.affecting == AM)
			qdel(G)

/// Returns a list of every movable we are grabbing
/mob/living/proc/get_all_grabbed_movables()
	. = list()
	for(var/obj/item/hand_item/grab/G in get_active_grabs())
		. |= G.affecting

/// Checks to see if we have a grab with atleast the given damage_stage
/atom/movable/proc/check_grab_severities(stage)
	for(var/obj/item/hand_item/grab/G in grabbed_by)
		if(G.current_grab.damage_stage >= stage)
			return G

/// Frees src from all grabs.
/atom/movable/proc/free_from_all_grabs()
	for(var/obj/item/hand_item/grab/G in grabbed_by)
		qdel(G)

