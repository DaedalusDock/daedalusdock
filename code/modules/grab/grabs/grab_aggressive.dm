/datum/grab/normal/aggressive
	upgrab =   /datum/grab/normal/neck
	downgrab = /datum/grab/normal/passive
	shift = 12
	stop_move = 1
	reverse_facing = 0
	shield_assailant = 0
	point_blank_mult = 1.5
	damage_stage = 1
	same_tile = 0
	can_throw = 1
	force_danger = 1
	breakability = 3
	icon_state = "2"

	break_chance_table = list(5, 20, 40, 80, 100)

/datum/grab/normal/aggressive/apply_grab_effects(obj/item/hand_item/grab/G)
	if(!isliving(G.affecting))
		return

	var/mob/living/L = G.affecting
	RegisterSignal(G.affecting, COMSIG_LIVING_SET_BODY_POSITION, PROC_REF(target_bodyposition_change))

	if(L.body_position == LYING_DOWN)
		ADD_TRAIT(L, TRAIT_FLOORED, AGGRESSIVE_GRAB)
	ADD_TRAIT(L, TRAIT_HANDS_BLOCKED, AGGRESSIVE_GRAB)

/datum/grab/normal/aggressive/remove_grab_effects(obj/item/hand_item/grab/G)
	UnregisterSignal(G.affecting, COMSIG_LIVING_SET_BODY_POSITION)
	REMOVE_TRAIT(G.affecting, TRAIT_FLOORED, AGGRESSIVE_GRAB)
	REMOVE_TRAIT(G.affecting, TRAIT_HANDS_BLOCKED, AGGRESSIVE_GRAB)

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
				if((C.clothing_flags & STOPSPRESSUREDAMAGE) && C.returnArmor().getRating(MELEE) > 20)
					to_chat(G.assailant, span_warning("\The [C] is in the way!"))
					return FALSE

/datum/grab/normal/aggressive/enter_as_up(obj/item/hand_item/grab/G)
	. = ..()
	G.assailant.visible_message(
		span_danger("<b>[G.assailant]</b> tightens their grip on [G.affecting] (now hands)!"),
		blind_message = span_hear("You hear aggressive shuffling.")
	)

/datum/grab/normal/aggressive/enter_as_down(obj/item/hand_item/grab/G)
	. = ..()
	G.assailant.visible_message(
		span_danger("<b>[G.assailant]</b> loosens their grip on [G.affecting], allowing them to breathe!"),
	)
