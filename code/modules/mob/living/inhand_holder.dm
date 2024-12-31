/// Simple holder for picked-up mobs
/obj/item/mob_holder
	name = "bugged mob"
	desc = "Yell at coderbrush."

	/// The mob being held by this item.
	var/mob/living/held_mob
	/// Should the held mob be examined instead of the holder?
	var/examine_mob = TRUE

/obj/item/mob_holder/Initialize(mapload, mob/living/target_mob, worn_state, head_icon, lh_icon, rh_icon, worn_slot_flags = NONE)
	. = ..()
	if(!istype(target_mob))
		return INITIALIZE_HINT_QDEL
	if(worn_state)
		inhand_icon_state = worn_state
	if(head_icon)
		worn_icon = head_icon
	if(lh_icon)
		lefthand_file = lh_icon
	if(rh_icon)
		righthand_file = rh_icon
	if(worn_slot_flags)
		slot_flags = worn_slot_flags

	w_class = target_mob.held_w_class
	deposit(target_mob)

/obj/item/mob_holder/Destroy(force)
	if(held_mob)
		release_mob(del_on_release = FALSE)
	return ..()

/obj/item/mob_holder/examine(mob/user)
	if(examine_mob)
		return held_mob.examine(user)
	return ..()

/obj/item/mob_holder/proc/deposit(mob/living/target_mob)
	target_mob.setDir(SOUTH)
	target_mob.forceMove(src)
	held_mob = target_mob
	name = held_mob.name
	desc = held_mob.desc
	appearance = held_mob.appearance

/obj/item/mob_holder/proc/release_mob(del_on_release = TRUE, display_messages = TRUE)
	if(!held_mob)
		return
	if(display_messages)
		// Both procs can handle non-mob locs so a check isn't needed here
		to_chat(loc, span_warning("[held_mob] wriggles free!"))
		visible_message(span_warning("[held_mob] uncurls!"), ignored_mobs = loc)
	held_mob.forceMove(drop_location())
	held_mob.reset_perspective()
	held_mob.setDir()
	held_mob = null
	if(del_on_release)
		qdel(src)

/obj/item/mob_holder/unequipped(mob/user, silent)
	. = ..()
	if(held_mob && isturf(loc))
		release_mob(display_messages = !silent)

/obj/item/mob_holder/attackby(obj/item/attacking_item, mob/user, params)
	return held_mob.attackby(attacking_item, user, params)

/obj/item/mob_holder/relaymove(mob/living/user, direction)
	release_mob()

/obj/item/mob_holder/container_resist_act(mob/living/user)
	release_mob()

/obj/item/mob_holder/on_thrown(mob/living/carbon/user, atom/target)
	. = held_mob
	if(!..())
		return null

/obj/item/mob_holder/on_found(mob/finder)
	if(held_mob.will_escape_storage())
		finder.visible_message(span_warning("[held_mob] pops out of the container [finder] is opening!"), ignored_mobs = finder)
		to_chat(finder, span_warning("[held_mob] pops out!"))
		release_mob(display_messages = FALSE)

/obj/item/mob_holder/emp_act(severity)
	return held_mob.emp_act(severity)

/obj/item/mob_holder/machine_wash(obj/machinery/washing_machine/washer)
	..()
	held_mob.machine_wash(washer)


/// Identical to the parent [/obj/item/mob_holder], except `Destroy()` also deletes the held mob.
/obj/item/mob_holder/destructible

/obj/item/mob_holder/destructible/Destroy(force)
	QDEL_NULL(held_mob)
	return ..()


/obj/item/mob_holder/drone
	examine_mob = FALSE

/obj/item/mob_holder/drone/Initialize(mapload, mob/living/target_mob, worn_state, head_icon, lh_icon, rh_icon, worn_slot_flags)
	//If we're not going to hold a drone, end it all
	if(!isdrone(target_mob))
		return INITIALIZE_HINT_QDEL
	return ..()

/obj/item/mob_holder/drone/deposit(mob/living/target_mob)
	. = ..()
	var/mob/living/simple_animal/drone/held_drone = held_mob
	name = "drone (hiding)"
	desc = "This drone is scared and has curled up into a ball!"
	icon = 'icons/mob/drone.dmi'
	icon_state = "[held_drone.visualAppearance]_hat"
