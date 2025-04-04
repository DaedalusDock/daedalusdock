/obj/item/bodypart/examine(mob/user)
	SHOULD_CALL_PARENT(TRUE)
	. = ..()
	var/hallucinating = FALSE
	if(ishuman(user))
		var/mob/living/carbon/human/human_user
		hallucinating = human_user.hal_screwyhud
	. += mob_examine(hallucinating)

/// Called when the parent mob is examined. Except also not because fuck you.
/obj/item/bodypart/proc/mob_examine(hallucinating, covered)
	. = list()

	if(covered)
		for(var/obj/item/I in embedded_objects)
			if(I.isEmbedHarmless())
				. += "<a href='?src=[REF(src)];embedded_object=[REF(I)]' class='danger'>There is \a [I] stuck to [owner.p_their()] [plaintext_zone]!</a>"
			else
				. += "<a href='?src=[REF(src)];embedded_object=[REF(I)]' class='danger'>There is \a [I] embedded in [owner.p_their()] [plaintext_zone]!</a>"

		if(splint)
			. += span_notice("\t <a href='?src=[REF(src)];splint_remove=1' class='notice'>[owner.p_their(TRUE)] [plaintext_zone] is splinted with [splint].</a>")

		if(bandage)
			. += span_notice("\t <a href='?src=[REF(src)];bandage_remove=1' class='[bandage.absorption_capacity ? "notice" : "warning"]'>[owner.p_their(TRUE)] [plaintext_zone] is bandaged with [bandage][bandage.absorption_capacity ? "." : ", blood is trickling out."]</a>")
		return

	. += get_wound_descriptions(hallucinating)

	if(!owner)
		if(bodypart_flags & BP_BROKEN_BONES)
			. += span_alert("It is dented and swollen.")
		return

	// Everything below this comment assumes there is an owner, and the bodypart is not visibly obscured.

	for(var/obj/item/I in embedded_objects)
		if(I.isEmbedHarmless())
			. += "\t <a href='?src=[REF(src)];embedded_object=[REF(I)]' class='warning'>There is \a [I] stuck to [owner.p_their()] [plaintext_zone]!</a>"
		else
			. += "\t <a href='?src=[REF(src)];embedded_object=[REF(I)]' class='warning'>There is \a [I] embedded in [owner.p_their()] [plaintext_zone]!</a>"

	if(splint)
		. += span_notice("\t <a href='?src=[REF(src)];splint_remove=1' class='warning'>[owner.p_their(TRUE)] [plaintext_zone] is splinted with [splint].</a>")
	if(bandage)
		. += span_notice("\n\t <a href='?src=[REF(src)];bandage_remove=1' class='notice'>[owner.p_their(TRUE)] [plaintext_zone] is bandaged with [bandage][bandage.absorption_capacity ? "." : ", <span class='warning'>it is no longer absorbing blood</span>."]</a>")

	if((bodypart_flags & BP_HAS_BLOOD) && (owner.undergoing_jaundice() == JAUNDICE_SKIN))
		. += span_alert("The skin of [owner.p_their()] [plaintext_zone] is a faint yellow.")

/obj/item/bodypart/arm/mob_examine(hallucinating, covered)
	. = ..()
	if((bodypart_flags & BP_HAS_BLOOD) && owner.undergoing_cyanosis() && !(HANDS & owner.get_all_covered_flags()))
		. += span_alert("[owner.p_their(TRUE)] [parse_zone(aux_zone)] is a sickly blue.")

/obj/item/bodypart/leg/mob_examine(hallucinating, covered)
	. = ..()
	if((bodypart_flags & BP_HAS_BLOOD) && owner.undergoing_cyanosis() && !(FEET & owner.get_all_covered_flags()))
		. += span_alert("[owner.p_their(TRUE)] [body_zone == BODY_ZONE_L_LEG ? "left foot" : "right foot"] is a sickly blue.")

/// Returns a list of wound descriptions in text form.
/obj/item/bodypart/proc/get_wound_descriptions(hallucinating) as /list
	RETURN_TYPE(/list)

	if(hallucinating == SCREWYHUD_HEALTHY)
		return list()

	switch(hallucinating)
		if(SCREWYHUD_HEALTHY)
			return list()

		if(SCREWYHUD_CRIT, SCREWYHUD_DEAD)
			var/list/hal_wounds = list("a")
			hal_wounds += pick("pair of", "ton of")
			hal_wounds += pick("large cuts", "severe burns")
			return list("[owner.p_they(TRUE)] [owner.p_have()] [english_list(jointext(hal_wounds, " "))] on [owner.p_their()] [plaintext_zone].")

	if(!IS_ORGANIC_LIMB(src))
		var/cyber_wounds = list()
		if(brute_dam)
			switch(brute_dam)
				if(0 to 20)
					cyber_wounds += "some dents"
				if(21 to INFINITY)
					cyber_wounds += pick("a lot of dents","severe denting")
		if(burn_dam)
			switch(burn_dam)
				if(0 to 20)
					cyber_wounds += "some burns"
				if(21 to INFINITY)
					cyber_wounds += pick("a lot of burns","severe melting")

		return list("[owner.p_they(TRUE)] [owner.p_have()] [english_list(cyber_wounds)] on [owner.p_their()] [plaintext_zone].")

	var/list/flavor_text = list()
	var/list/wound_locations = list(
		"[plaintext_zone]" = list(),
	)

	if((bodypart_flags & BP_CUT_AWAY) && !is_stump)
		wound_locations[plaintext_zone]["tear at the [amputation_point] so severe that it hangs by a scrap of flesh"] = 1

	for(var/datum/wound/W as anything in wounds)
		var/descriptor = W.get_examine_desc()
		if(descriptor)
			var/wound_location = W.wound_location()
			LAZYINITLIST(wound_locations[wound_location])
			wound_locations[wound_location][descriptor] += W.amount

	if(how_open() >= SURGERY_RETRACTED)
		var/bone = encased ? encased : "bone"
		if(bodypart_flags & BP_BROKEN_BONES)
			bone = "broken [bone]"
		wound_locations[plaintext_zone]["[bone] exposed"] = 1

		if(!encased || how_open() >= SURGERY_DEENCASED)
			var/list/bits = list()
			for(var/obj/item/organ/organ in contained_organs)
				if(organ.cosmetic_only)
					continue
				bits += organ.get_visible_state()

			for(var/obj/item/implant in cavity_items)
				bits += implant.name

			if(length(bits))
				wound_locations[plaintext_zone]["[english_list(bits)] visible in the wounds"] = 1

	if(owner)
		for(var/wound_loc in wound_locations)
			var/list/wound_text = list()
			if(!length(wound_locations[wound_loc]))
				continue

			for(var/wound in wound_locations[wound_loc])
				switch(wound_locations[wound_loc][wound])
					if(1)
						wound_text += "a [wound]"
					if(2)
						wound_text += "a pair of [wound]s"
					if(3 to 5)
						wound_text += "several [wound]s"
					if(6 to INFINITY)
						wound_text += "a ton of [wound]\s"

			if(length(wound_text))
				flavor_text += span_warning("[owner.p_they(TRUE)] [owner.p_have()] [english_list(wound_text)] on [owner.p_their()] [wound_loc].")
	else
		var/list/wound_text = list()
		for(var/wound_loc in wound_locations)
			if(!length(wound_locations[wound_loc]))
				continue

			for(var/wound in wound_locations[wound_loc])
				switch(wound_locations[wound_loc][wound])
					if(1)
						wound_text += "a [wound]"
					if(2)
						wound_text += "a pair of [wound]s"
					if(3 to 5)
						wound_text += "several [wound]s"
					if(6 to INFINITY)
						wound_text += "a ton of [wound]\s"

		if(length(wound_text))
			flavor_text += span_warning("It has [english_list(wound_text)].")


	return flavor_text

/obj/item/bodypart/proc/inspect(mob/user)
	if(is_stump)
		to_chat(user, span_notice("[owner] is missing that bodypart."))
		return

	user.visible_message(span_notice("[user] starts inspecting [owner]'s [plaintext_zone] carefully."))

	if(!do_after(user, owner, 1 SECOND, DO_PUBLIC|DO_RESTRICT_USER_DIR_CHANGE))
		return

	if(LAZYLEN(wounds))
		to_chat(user, span_warning("You find the following:"))
		for(var/wound_desc in get_wound_descriptions())
			to_chat(user, wound_desc)

		var/list/stuff = list()
		for(var/datum/wound/wound as anything in wounds)
			if(LAZYLEN(wound.embedded_objects))
				stuff |= wound.embedded_objects

		if(length(stuff))
			to_chat(user, span_warning("There's [english_list(stuff)] sticking out of [owner]'s [plaintext_zone]."))
	else
		to_chat(user, span_notice("You find no visible wounds."))

	to_chat(user, span_notice("Checking skin now..."))

	if(!do_after(user, owner, 1 SECOND, DO_PUBLIC|DO_RESTRICT_USER_DIR_CHANGE))
		return

	if(skin_tone)
		if(owner.undergoing_cyanosis() && (body_part & (ARMS|LEGS)))
			to_chat(user, span_alert("The digits are turning blue."))

		if(owner.undergoing_pale_skin())
			to_chat(user, span_alert("The skin is very pale."))

		if(owner.undergoing_jaundice())
			to_chat(user, span_alert("The skin is yellowed."))

		if(owner.shock_stage >= SHOCK_TIER_2)
			to_chat(user, span_alert("The skin is clammy and cool to the touch."))

	if(IS_ORGANIC_LIMB(src) && (bodypart_flags & BP_NECROTIC))
		to_chat(user, span_alert("The surface is rotting."))

	to_chat(user, span_notice("Checking bones now..."))
	if(!do_after(user, owner, 1 SECOND, DO_PUBLIC|DO_RESTRICT_USER_DIR_CHANGE))
		return

	if(bodypart_flags & BP_BROKEN_BONES)
		to_chat(user, span_alert("The [encased ? encased : "bone in the [plaintext_zone]"] moves slightly when you poke it."))
		owner.apply_pain(40, src, "Your [plaintext_zone] hurts where it's poked.")
	else
		to_chat(user, span_notice("The [encased ? encased : "bones in the [plaintext_zone]"] appear[encased && "s"] to be fine."))

	if(bodypart_flags & BP_TENDON_CUT)
		to_chat(user, span_alert("The tendons in the [plaintext_zone] are severed."))
	if(bodypart_flags & BP_DISLOCATED)
		to_chat(user, span_alert("The [joint_name] is dislocated."))
	if(bodypart_flags & BP_ARTERY_CUT)
		to_chat(user, span_alert("The [plaintext_zone] is gushing blood."))
	return TRUE
