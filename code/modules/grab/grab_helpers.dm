/// Returns TRUE if src is grabbing hold of the target
/mob/living/proc/is_grabbing(atom/movable/AM)
	RETURN_TYPE(/obj/item/hand_item/grab)
	for(var/obj/item/hand_item/grab/G in active_grabs)
		if(G.affecting == AM)
			return G

/// Release all grabs we have
/mob/living/proc/release_all_grabs()
	for(var/obj/item/hand_item/grab/G in active_grabs)
		qdel(G)

/// Release the given movable from a grab
/mob/living/proc/release_grabs(atom/movable/AM)
	for(var/obj/item/hand_item/grab/G in active_grabs)
		if(G.affecting == AM)
			qdel(G)

/// Returns the currently selected grab item
/mob/living/proc/get_active_grab()
	RETURN_TYPE(/obj/item/hand_item/grab)
	var/obj/item/hand_item/grab/G = locate() in src
	return G

/mob/living/carbon/get_active_grab()
	RETURN_TYPE(/obj/item/hand_item/grab)
	var/item = get_active_held_item()
	if(isgrab(item))
		return item
	return ..()

/// Releases the currently selected grab item
/mob/living/proc/release_active_grab()
	qdel(get_active_grab())

/// Returns a list of every movable we are grabbing
/mob/living/proc/get_all_grabbed_movables()
	. = list()
	for(var/obj/item/hand_item/grab/G in active_grabs)
		. |= G.affecting

/// Frees src from all grabs.
/atom/movable/proc/free_from_all_grabs()
	if(!LAZYLEN(grabbed_by))
		return

	for(var/obj/item/hand_item/grab/G in grabbed_by)
		qdel(G)

/// Gets every grabber of this atom, and every grabber of those grabbers, repeat
/atom/movable/proc/recursively_get_all_grabbers()
	RETURN_TYPE(/list)
	. = list()
	for(var/obj/item/hand_item/grab/G in grabbed_by)
		. |= G.assailant
		. |= G.assailant.recursively_get_all_grabbers()

/// Gets every grabbed atom of this mob, and every grabbed atom of that grabber, repeat
/mob/living/proc/recursively_get_all_grabbed_movables()
	RETURN_TYPE(/list)
	. = list()
	for(var/obj/item/hand_item/grab/G in active_grabs)
		. |= G.affecting
		var/mob/living/L = G.get_affecting_mob()
		if(L)
			. |= L.recursively_get_all_grabbed_movables()

/// Gets every grab object owned by this mob, and every grabbed atom of those grabbed mobs
/mob/living/proc/recursively_get_conga_line()
	RETURN_TYPE(/list)
	. = list()
	for(var/obj/item/hand_item/grab/G in active_grabs)
		. |= G
		var/mob/living/L = G.get_affecting_mob()
		if(L)
			. |= L.recursively_get_conga_line()

/// Get every single member of a grab chain
/atom/movable/proc/get_all_grab_chain_members()
	RETURN_TYPE(/list)
	return recursively_get_all_grabbers()

/mob/living/get_all_grab_chain_members()
	. = ..()
	. |= recursively_get_all_grabbed_movables()
