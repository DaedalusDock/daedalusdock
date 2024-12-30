/datum/grab/normal/neck
	upgrab = /datum/grab/normal/kill
	downgrab = /datum/grab/normal/aggressive

	grab_slowdown = 4

	drop_headbutt = FALSE
	shift = -10
	stop_move = TRUE
	reverse_facing = TRUE
	point_blank_mult = 2
	damage_stage = GRAB_NECK
	same_tile = TRUE
	can_throw = TRUE
	enable_violent_interactions = TRUE
	restrains = TRUE
	icon_state = "kill"
	break_chance_table = list(3, 18, 45, 100)

/datum/grab/normal/neck/apply_unique_grab_effects(atom/movable/affecting)
	. = ..()
	if(!isliving(affecting))
		return

	var/mob/living/L = affecting
	ADD_TRAIT(L, TRAIT_FLOORED, NECK_GRAB)

/datum/grab/normal/neck/remove_unique_grab_effects(atom/movable/affecting)
	. = ..()
	REMOVE_TRAIT(affecting, TRAIT_FLOORED, NECK_GRAB)

/datum/grab/normal/neck/enter_as_up(obj/item/hand_item/grab/G, silent)
	. = ..()
	if(!silent)
		G.assailant.visible_message(
			span_danger("<b>[G.assailant]</b> places their arm around [G.affecting]'s neck!"),
			blind_message = span_hear("You hear aggressive shuffling."),
			vision_distance = COMBAT_MESSAGE_RANGE
		)

/datum/grab/normal/neck/enter_as_down(obj/item/hand_item/grab/G, silent)
	. = ..()
	if(!silent)
		G.assailant.visible_message(
			span_danger("<b>[G.assailant]</b> stops strangling [G.affecting]."),
			vision_distance = COMBAT_MESSAGE_RANGE
		)
