/datum/grab/normal/neck
	//upgrab =   /datum/grab/normal/kill
	downgrab = /datum/grab/normal/aggressive

	drop_headbutt = 0

	shift = -10
	stop_move = 1
	reverse_facing = 1
	shield_assailant = 1
	point_blank_mult = 2
	damage_stage = GRAB_NECK
	same_tile = 1
	can_throw = 1
	force_danger = 1
	restrains = 1
	icon_state = "3"
	break_chance_table = list(3, 18, 45, 100)

/datum/grab/normal/neck/apply_grab_effects(obj/item/hand_item/grab/G)
	if(!isliving(G.affecting))
		return

	var/mob/living/L = G.affecting
	ADD_TRAIT(L, TRAIT_FORCED_STANDING, NECK_GRAB)
	ADD_TRAIT(L, TRAIT_HANDS_BLOCKED, NECK_GRAB)

/datum/grab/normal/neck/remove_grab_effects(obj/item/hand_item/grab/G)
	REMOVE_TRAIT(G.affecting, TRAIT_FORCED_STANDING, NECK_GRAB)
	REMOVE_TRAIT(G.affecting, TRAIT_HANDS_BLOCKED, NECK_GRAB)
