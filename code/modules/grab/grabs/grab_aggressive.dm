/datum/grab/normal/aggressive
	upgrab =   /datum/grab/normal/neck
	downgrab = /datum/grab/normal/passive

	grab_slowdown = 0.7
	shift = 12
	stop_move = TRUE
	reverse_facing = FALSE
	point_blank_mult = 1.5
	damage_stage = GRAB_AGGRESSIVE
	same_tile = FALSE
	can_throw = TRUE
	enable_violent_interactions = TRUE
	breakability = 3
	icon_state = "reinforce1"

	break_chance_table = list(5, 20, 40, 80, 100)

/datum/grab/normal/aggressive/apply_unique_grab_effects(atom/movable/affecting)
	. = ..()
	if(!isliving(affecting))
		return

	var/mob/living/L = affecting
	RegisterSignal(L, COMSIG_LIVING_SET_BODY_POSITION, PROC_REF(target_bodyposition_change))

	if(L.body_position == LYING_DOWN)
		ADD_TRAIT(L, TRAIT_FLOORED, AGGRESSIVE_GRAB)

/datum/grab/normal/aggressive/remove_unique_grab_effects(atom/movable/affecting)
	. = ..()
	UnregisterSignal(affecting, COMSIG_LIVING_SET_BODY_POSITION)
	REMOVE_TRAIT(affecting, TRAIT_FLOORED, AGGRESSIVE_GRAB)

/datum/grab/normal/aggressive/proc/target_bodyposition_change(mob/living/source)
	if(source.body_position == LYING_DOWN)
		ADD_TRAIT(source, TRAIT_FLOORED, AGGRESSIVE_GRAB)

/datum/grab/normal/aggressive/can_upgrade(obj/item/hand_item/grab/G)
	. = ..()
	if(.)
		if(!ishuman(G.affecting))
			to_chat(G.assailant, span_warning("You can only upgrade an aggressive grab when grappling a human!"))
			return FALSE
		if(!(G.target_zone in list(BODY_ZONE_CHEST, BODY_ZONE_HEAD)))
			to_chat(G.assailant, span_warning("You need to be grabbing their torso or head for this!"))
			return FALSE

		var/mob/living/carbon/human/affecting_mob = G.get_affecting_mob()
		if(istype(affecting_mob))
			var/obj/item/clothing/C = affecting_mob.head
			if(istype(C)) //hardsuit helmets etc
				if((C.clothing_flags & STOPSPRESSUREDAMAGE) && C.returnArmor().getRating(BLUNT) > 20)
					to_chat(G.assailant, span_warning("\The [C] is in the way!"))
					return FALSE

/datum/grab/normal/aggressive/enter_as_up(obj/item/hand_item/grab/G, silent)
	. = ..()
	if(!silent)
		G.assailant.visible_message(
			span_danger("<b>[G.assailant]</b> tightens their grip on [G.affecting] (now hands)!"),
			blind_message = span_hear("You hear aggressive shuffling."),
			vision_distance = COMBAT_MESSAGE_RANGE,
		)

/datum/grab/normal/aggressive/enter_as_down(obj/item/hand_item/grab/G, silent)
	. = ..()
	if(!silent)
		G.assailant.visible_message(
			span_danger("<b>[G.assailant]</b> loosens their grip on [G.affecting], allowing them to breathe!"),
			vision_distance = COMBAT_MESSAGE_RANGE,
		)
