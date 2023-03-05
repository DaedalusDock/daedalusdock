/obj/item/bodypart/proc/check_bones()
	if(!(bodypart_flags & BP_HAS_BONES))
		return CHECKBONES_NONE

	if(bodypart_flags & BP_BROKEN_BONES)
		return CHECKBONES_BROKEN
	return CHECKBONES_OK

/obj/item/bodypart/proc/check_artery()
	if(!(bodypart_flags & BP_HAS_ARTERY))
		return CHECKARTERY_NONE

	if(bodypart_flags & BP_ARTERY_CUT)
		return CHECKARTERY_SEVERED
	return CHECKARTERY_OK

/obj/item/bodypart/proc/check_tendon()
	if(!(bodypart_flags & BP_HAS_TENDON))
		return CHECKTENDON_NONE

	if(bodypart_flags & BP_TENDON_CUT)
		return CHECKTENDON_SEVERED
	return CHECKTENDON_OK


/obj/item/bodypart/proc/break_bones()
	SHOULD_NOT_OVERRIDE(TRUE)

	if(check_bones() & (CHECKBONES_NONE|CHECKBONES_BROKEN))
		return FALSE

	if(owner)
		owner.visible_message(
			span_danger("You hear a loud cracking sound coming from \the [owner]."),
			span_danger("Something feels like it shattered in your [name]!"),
			span_danger("You hear a sickening crack.")
		)

		jostle_bones()
		INVOKE_ASYNC(owner, /mob/proc/emote, "scream")

	playsound(loc, SFX_BREAK_BONE, 100, 1, -2)

	if(!IS_ORGANIC_LIMB(src))
		broken_description = pick("broken","shattered","structural rupture")
	else
		broken_description = pick("broken","fracture","hairline fracture")

	bodypart_flags |= BP_BROKEN_BONES
	if(owner)
		apply_bone_break(owner)
	return TRUE

/obj/item/bodypart/proc/apply_bone_break(mob/living/carbon/C)
	SHOULD_CALL_PARENT(TRUE)

	SEND_SIGNAL(C, COMSIG_CARBON_BREAK_BONE, src)
	return TRUE

/obj/item/bodypart/leg/apply_bone_break(mob/living/carbon/C)
	. = ..()
	if(!.)
		return TRUE

	C.apply_status_effect(/datum/status_effect/limp)

/obj/item/bodypart/proc/heal_bones()
	if(!(check_bones() & CHECKBONES_BROKEN))
		return FALSE

	bodypart_flags &= ~BP_BROKEN_BONES

	if(owner)
		SEND_SIGNAL(owner, COMSIG_CARBON_HEAL_BONE, src)

/obj/item/bodypart/proc/jostle_bones(force)
	if(!(bodypart_flags & BP_BROKEN_BONES)) //intact bones stay still
		return
	if(brute_dam + force < BODYPART_MINIMUM_DAMAGE_TO_JIGGLEBONES)	//no papercuts moving bones
		return

	if(!prob(brute_dam + force))
		return

	receive_damage(force, breaks_bones = FALSE) //NO RECURSIVE BONE JOSTLING
	if(owner)
		owner.audible_message(
			span_warning("A sickening noise comes from [owner]'s [plaintext_zone]!"),
			null,
			2,
			span_warning("You feel something moving in your [plaintext_zone]!")
		)
		INVOKE_ASYNC(owner, /mob/proc/emote, "scream")

/obj/item/bodypart/proc/clamp_wounds()
	for(var/datum/wound/W as anything in wounds)
		. |= !W.clamped
		W.clamped = 1

	refresh_bleed_rate()
	return .

/obj/item/bodypart/proc/remove_clamps()
	for(var/datum/wound/W as anything in wounds)
		. |= W.clamped
		W.clamped = 0

	refresh_bleed_rate()
	return .

/obj/item/bodypart/proc/clamped()
	for(var/datum/wound/W as anything in wounds)
		if(W.clamped)
			return TRUE

/obj/item/bodypart/proc/how_open()
	. = 0
	var/datum/wound/incision = get_incision()
	if(!incision)
		return

	var/smol_threshold = minimum_break_damage * 0.4
	var/beeg_threshold = minimum_break_damage * 0.6
	if(!(incision.autoheal_cutoff == 0)) //not clean incision
		smol_threshold *= 1.5
		beeg_threshold = max(beeg_threshold, min(beeg_threshold * 1.5, incision.damage_list[1])) //wounds can't achieve bigger
	if(incision.damage >= smol_threshold) //smol incision
		. = SURGERY_OPEN
	if(incision.damage >= beeg_threshold) //beeg incision
		. = SURGERY_RETRACTED

/obj/item/bodypart/proc/get_incision(strict)

	var/datum/wound/incision

	for(var/datum/wound/cut/W in wounds)
		if(W.bandaged || W.current_stage > W.max_bleeding_stage) // Shit's unusable
			continue
		if(strict && !W.is_surgical()) //We don't need dirty ones
			continue
		if(!incision)
			incision = W
			continue
		var/same = W.is_surgical() == incision.is_surgical()
		if(same) //If they're both dirty or both are surgical, just get bigger one
			if(W.damage > incision.damage)
				incision = W
		else if(W.is_surgical()) //otherwise surgical one takes priority
			incision = W
	return incision

/obj/item/bodypart/proc/open_incision()
	var/datum/wound/W = get_incision()
	if(!W)
		return
	W.open_wound(min(W.damage * 2, W.damage_list[1] - W.damage))
