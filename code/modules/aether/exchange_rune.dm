/obj/effect/aether_rune/exchange

/obj/effect/aether_rune/exchange/wipe_state()
	for(var/item in blackboard[RUNE_BB_EXCHANGE_PARTS])
		unregister_item(item)
	return ..()

/obj/effect/aether_rune/exchange/pre_invoke(mob/living/user, obj/item/book/tome)
	. = ..()

	var/list/things = list()

	for(var/obj/item/I in orange(1, src))
		if(!isturf(I.loc))
			continue

		if(isbodypart(I) || isorgan(I))
			register_item(I)
			things += I

	blackboard[RUNE_BB_EXCHANGE_PARTS] = things

/obj/effect/aether_rune/exchange/can_invoke()
	. = ..()
	if(!.)
		return

	return length(blackboard[RUNE_BB_EXCHANGE_PARTS])

/obj/effect/aether_rune/exchange/succeed_invoke(mob/living/carbon/human/target_mob)
	var/list/parts = blackboard[RUNE_BB_EXCHANGE_PARTS]
	for(var/obj/item/bodypart/new_limb in parts)
		var/oldloc = get_turf(new_limb)
		var/obj/item/bodypart/old_limb = target_mob.get_bodypart(new_limb.body_zone)

		if(new_limb.replace_limb(target_mob, TRUE))
			old_limb?.forceMove(oldloc)

	for(var/obj/item/organ/new_organ in parts)
		var/oldloc = get_turf(new_organ)
		var/obj/item/organ/old_organ = target_mob.getorganslot(new_organ.slot)

		old_organ.Remove(target_mob, TRUE)
		new_organ.Insert(target_mob, TRUE)
		old_organ.forceMove(oldloc)

	return ..()

/obj/effect/aether_rune/exchange/proc/register_item(obj/item/I)
	RegisterSignal(I, list(COMSIG_PARENT_QDELETING, COMSIG_MOVABLE_MOVED), PROC_REF(item_moved_or_deleted))

/obj/effect/aether_rune/exchange/proc/unregister_item(obj/item/I)
	UnregisterSignal(I, list(COMSIG_PARENT_QDELETING, COMSIG_MOVABLE_MOVED))

/obj/effect/aether_rune/exchange/proc/item_moved_or_deleted(datum/source)
	SIGNAL_HANDLER

	var/obj/item/I = source
	if(QDELETED(I))
		try_cancel_invoke(RUNE_FAIL_GRACEFUL)
		return

	if(get_dist(src, I) > 1)
		try_cancel_invoke(RUNE_FAIL_TARGET_ITEM_OUT_OF_RUNE, I)
