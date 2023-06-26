/obj/effect/abstract/aim_overlay
	vis_flags = VIS_INHERIT_ID
	icon = 'icons/effects/aim.dmi'
	icon_state = "locking"
	anchored = TRUE

	/// The man with the gun
	var/mob/living/user
	/// The man on the other end of the gun
	var/mob/living/target
	/// The gun
	var/obj/item/gun/tool

	/// Are we locked on?
	var/locked = FALSE
	/// When will we lock on?
	var/lock_time = 0
	/// Will we fire when a trigger condition is met?
	var/active
	/// What target actions will not trigger a shot?
	var/target_permissions = TARGET_CAN_MOVE | TARGET_CAN_CLICK | TARGET_CAN_RADIO

/obj/effect/abstract/aim_overlay/Initialize(mapload, mob/living/user, obj/item/gun/tool)
	. = ..()
	src.user = user
	src.tool = tool
	target = loc
	loc = null
	target.vis_contents += src
	RegisterSignal(target, COMSIG_PARENT_QDELETING, target_del)
	RegisterSignal(target, COMSIG_MOVABLE_MOVED, target_moved)
	RegisterSignal(target, COMSIG_CLIENT_CLICK, target_clicked)
	RegisterSignal(target, COMSIG_LIVING_USE_RADIO, target_use_radio)

/obj/effect/abstract/aim_overlay/proc/target_del(datum/source)
	SIGNAL_HANDLER
	qdel(src)

/obj/effect/abstract/aim_overlay/proc/target_moved(mob/living/source)
	SIGNAL_HANDLER

	if(target_permissions & TARGET_CAN_MOVE)
		return

	if(source.m_intent == MOVE_INTENT_WALK || (target_permissions & TARGET_CAN_RUN))
		return

	trigger()

/obj/effect/abstract/aim_overlay/proc/target_clicked(client/source)
	if(target_permissions & TARGET_CAN_CLICK)
		return

	trigger()

/obj/effect/abstract/aim_overlay/proc/target_use_radio(mob/living/source)
	if(target_permissions & TARGET_CAN_RADIO)
		return

	trigger()

/obj/effect/abstract/aim_overlay/proc/toggle_permission(permission)
	target_permissions ^= permission

	var/message = "no longer permitted to "
	var/use_span = "warning"
	if (target_permissions & perm)
		message = "now permitted to "
		use_span = "notice"

	switch(perm)
		if (TARGET_CAN_MOVE)
			message += "move"
		if (TARGET_CAN_CLICK)
			message += "use items"
		if (TARGET_CAN_RADIO)
			message += "use a radio"
		else
			return

	if (aiming_at && aiming_at != owner)
		to_chat(owner, SPAN_CLASS("[use_span]", "\The [aiming_at] is [message]."))
		to_chat(aiming_at, SPAN_CLASS("[use_span]", "You are [message]."))
	else
		to_chat(owner, SPAN_CLASS("[use_span]", "Your targets are [message]."))


/obj/effect/abstract/aim_overlay/proc/trigger()
