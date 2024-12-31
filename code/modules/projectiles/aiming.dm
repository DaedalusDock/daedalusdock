/obj/effect/abstract/aim_overlay
	vis_flags = VIS_INHERIT_ID|VIS_INHERIT_PLANE|VIS_INHERIT_LAYER
	icon = 'icons/effects/aim.dmi'
	icon_state = "locking"
	anchored = TRUE

	appearance_flags = RESET_COLOR | RESET_ALPHA | RESET_TRANSFORM

	/// The man with the gun
	var/mob/living/user
	/// The man on the other end of the gun
	var/mob/living/target
	/// The gun
	var/obj/item/gun/tool

	/// Are we locked on?
	var/locked = FALSE
	/// When will we lock on?
	var/lock_time = 0.5 SECONDS
	/// Will we fire when a trigger condition is met?
	var/active

/obj/effect/abstract/aim_overlay/Initialize(mapload, mob/living/user, mob/living/target, obj/item/gun/tool)
	. = ..()
	if(!istype(user) || !istype(target) || !istype(tool))
		return INITIALIZE_HINT_QDEL

	src.user = user
	src.tool = tool

	register_to_target(target)

	RegisterSignal(target, COMSIG_PARENT_QDELETING, PROC_REF(target_del))
	RegisterSignal(user, COMSIG_PARENT_QDELETING, PROC_REF(target_del))
	RegisterSignal(user, COMSIG_MOVABLE_MOVED, PROC_REF(check_sight))
	RegisterSignal(user, COMSIG_MOB_FIRED_GUN, PROC_REF(user_shot))
	RegisterSignal(user, list(COMSIG_PARENT_ATTACKBY, COMSIG_ATOM_GET_GRABBED, COMSIG_HUMAN_DISARM_HIT), PROC_REF(trigger))
	RegisterSignal(
		user,
		list(
			SIGNAL_ADDTRAIT(TRAIT_ARMS_RESTRAINED),
			SIGNAL_ADDTRAIT(TRAIT_HANDS_BLOCKED),
			SIGNAL_ADDTRAIT(TRAIT_INCAPACITATED),
			SIGNAL_ADDTRAIT(TRAIT_FLOORED)
		),
		PROC_REF(cancel)
	)
	RegisterSignal(tool, list(COMSIG_ITEM_UNEQUIPPED, COMSIG_ITEM_EQUIPPED), PROC_REF(check_item))

	user.apply_status_effect(/datum/status_effect/holdup, user)
	target.apply_status_effect(/datum/status_effect/grouped/heldup, REF(user))

	user.visible_message(
		span_warning("<b>[user]</b> aims [tool] at <b>[target]</b>!"), \
	)

	SEND_SOUND(target, sound('sound/weapons/TargetOn.ogg'))
	SEND_SOUND(user, sound('sound/weapons/TargetOn.ogg'))

	addtimer(CALLBACK(src, PROC_REF(set_locked)), lock_time)

/obj/effect/abstract/aim_overlay/Destroy(force)
	user?.remove_status_effect(/datum/status_effect/holdup)
	target?.remove_status_effect(/datum/status_effect/grouped/heldup, REF(user))
	user?.gunpoint = null
	user = null
	target = null
	tool = null
	return ..()

/obj/effect/abstract/aim_overlay/update_icon_state()
	. = ..()
	if(locked)
		icon_state = "locked"
	else
		icon_state = "locking"

/obj/effect/abstract/aim_overlay/proc/set_locked()
	locked = TRUE
	update_icon_state()

/obj/effect/abstract/aim_overlay/proc/register_to_target(mob/new_target)
	if(target)
		UnregisterSignal(
			target,
			list(
				COMSIG_PARENT_QDELETING,
				COMSIG_MOVABLE_MOVED,
				COMSIG_LIVING_UNARMED_ATTACK,
				COMSIG_MOB_ITEM_ATTACK,
				COMSIG_MOB_ATTACK_HAND,
				COMSIG_MOB_FIRED_GUN,
				COMSIG_MOB_ATTACK_RANGED,
				COMSIG_LIVING_USE_RADIO
			)
		)
		target.remove_viscontents(src)
		user.visible_message(span_warning("[user] turns [tool] on [new_target]!"))

	target = new_target
	target.add_viscontents(src)

	RegisterSignal(target, COMSIG_PARENT_QDELETING, PROC_REF(target_del))
	RegisterSignal(target, COMSIG_MOVABLE_MOVED, PROC_REF(target_moved))
	RegisterSignal(
		target,
		list(
			COMSIG_LIVING_UNARMED_ATTACK,
			COMSIG_MOB_ITEM_ATTACK,
			COMSIG_MOB_FIRED_GUN,
			COMSIG_MOB_ATTACK_HAND,
			COMSIG_MOB_ATTACK_RANGED
		),
		PROC_REF(target_acted)
	)
	RegisterSignal(target, COMSIG_LIVING_USE_RADIO, PROC_REF(target_use_radio))

	to_chat(target, span_danger("You now have [tool] point at you. No sudden moves!"))

/obj/effect/abstract/aim_overlay/proc/target_del(datum/source)
	SIGNAL_HANDLER
	qdel(src)

/obj/effect/abstract/aim_overlay/proc/user_shot(mob/living/source)
	if(!QDELETED(src))
		qdel(src)

/obj/effect/abstract/aim_overlay/proc/check_item(obj/item/source)
	SIGNAL_HANDLER
	if(!(source in user.held_items))
		qdel(src)
		return


/obj/effect/abstract/aim_overlay/proc/target_moved(mob/living/source)
	SIGNAL_HANDLER

	if(user.gunpoint_flags & TARGET_CAN_MOVE)
		return

	if(source.m_intent == MOVE_INTENT_WALK || (user.gunpoint_flags & TARGET_CAN_RUN))
		return

	trigger()

/obj/effect/abstract/aim_overlay/proc/target_acted(client/source)
	SIGNAL_HANDLER

	if(user.gunpoint_flags & TARGET_CAN_INTERACT)
		return

	trigger()

/obj/effect/abstract/aim_overlay/proc/target_use_radio(mob/living/source)
	SIGNAL_HANDLER

	if(user.gunpoint_flags & TARGET_CAN_RADIO)
		return

	trigger()

/obj/effect/abstract/aim_overlay/proc/check_sight(atom/movable/source)
	SIGNAL_HANDLER

	if(!can_see(user, target, 7))
		cancel()
	else
		spawn(0)
			user.face_atom(target)

/obj/effect/abstract/aim_overlay/proc/trigger()
	set waitfor = FALSE
	if(!locked)
		return

	tool.try_fire_gun(target, user)
	qdel(src)

/obj/effect/abstract/aim_overlay/proc/cancel()
	user.visible_message(span_notice("[user] lowers [user.p_their()] [tool.name]."))
	qdel(src)
