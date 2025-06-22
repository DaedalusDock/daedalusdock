/mob/living/silicon/ai/death(gibbed, cause_of_death = "Unknown")
	if(stat == DEAD)
		return

	if(!gibbed)
		// Will update all AI status displays with a blue screen of death
		INVOKE_ASYNC(src, PROC_REF(emote), "bsod")

	. = ..()

	SSblackbox.record_feedback("amount", "ai_deaths", 1)

	update_appearance()
	if(!gibbed && !QDELING(src))
		vis_holder.death_animation()

	cameraFollow = null

	set_anchored(FALSE) //unbolt floorbolts
	status_flags |= CANPUSH //we want it to be pushable when unanchored on death
	REMOVE_TRAIT(src, TRAIT_NO_TELEPORT, AI_ANCHOR_TRAIT) //removes the anchor trait, because its not anchored anymore
	move_resist = MOVE_FORCE_NORMAL

	if(eyeobj)
		eyeobj.setLoc(get_turf(src))
		set_eyeobj_visible(FALSE)


	UNSET_TRACKING(TRACKING_KEY_SHUTTLE_CALLER)
	SSshuttle.autoEvac()

	ShutOffDoomsdayDevice()

	if(explosive)
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(explosion), loc, 3, 6, 12, null, 15), 1 SECONDS)

/mob/living/silicon/ai/proc/ShutOffDoomsdayDevice()
	if(nuking)
		nuking = FALSE
	if(doomsday_device)
		qdel(doomsday_device)
