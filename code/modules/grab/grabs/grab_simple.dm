/datum/grab/simple
	shift = 8
	stop_move = FALSE
	reverse_facing = FALSE
	shield_assailant = FALSE
	point_blank_mult = 1
	same_tile = FALSE
	icon_state = "1"
	break_chance_table = list(15, 60, 100)

/datum/grab/simple/upgrade(obj/item/hand_item/grab/G)
	return

/datum/grab/simple/on_hit_disarm(var/obj/item/hand_item/grab/G, var/atom/A)
	return FALSE

/datum/grab/simple/on_hit_grab(var/obj/item/hand_item/grab/G, var/atom/A)
	return FALSE

/datum/grab/simple/on_hit_harm(var/obj/item/hand_item/grab/G, var/atom/A)
	return FALSE

/datum/grab/simple/resolve_openhand_attack(var/obj/item/hand_item/grab/G)
	return FALSE
