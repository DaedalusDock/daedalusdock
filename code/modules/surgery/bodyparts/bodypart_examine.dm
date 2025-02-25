/obj/item/bodypart/examine(mob/user)
	SHOULD_CALL_PARENT(TRUE)
	. = ..()
	var/hallucinating = FALSE
	if(ishuman(user))
		var/mob/living/carbon/human/human_user
		hallucinating = human_user.hal_screwyhud
	. += mob_examine(hallucinating)

/obj/item/bodypart/proc/mob_examine(hallucinating, covered)
	. = list()

	if(covered)
		for(var/obj/item/I in embedded_objects)
			if(I.isEmbedHarmless())
				. += "<a href='?src=[REF(src)];embedded_object=[REF(I)]' class='danger'>There is \a [I] stuck to [owner.p_their()] [plaintext_zone]!</a>"
			else
				. += "<a href='?src=[REF(src)];embedded_object=[REF(I)]' class='danger'>There is \a [I] embedded in [owner.p_their()] [plaintext_zone]!</a>"

		if(splint && istype(splint, /obj/item/stack))
			. += span_notice("\t <a href='?src=[REF(src)];splint_remove=1' class='notice'>[owner.p_their(TRUE)] [plaintext_zone] is splinted with [splint].</a>")

		if(bandage)
			. += span_notice("\t <a href='?src=[REF(src)];bandage_remove=1' class='[bandage.absorption_capacity ? "notice" : "warning"]'>[owner.p_their(TRUE)] [plaintext_zone] is bandaged with [bandage][bandage.absorption_capacity ? "." : ", blood is trickling out."]</a>")
		return

	. += get_wound_descriptions(hallucinating)

	if(owner)
		for(var/obj/item/I in embedded_objects)
			if(I.isEmbedHarmless())
				. += "\t <a href='?src=[REF(src)];embedded_object=[REF(I)]' class='warning'>There is \a [I] stuck to [owner.p_their()] [plaintext_zone]!</a>"
			else
				. += "\t <a href='?src=[REF(src)];embedded_object=[REF(I)]' class='warning'>There is \a [I] embedded in [owner.p_their()] [plaintext_zone]!</a>"

		if(splint && istype(splint, /obj/item/stack))
			. += span_notice("\t <a href='?src=[REF(src)];splint_remove=1' class='warning'>[owner.p_their(TRUE)] [plaintext_zone] is splinted with [splint].</a>")
		if(bandage)
			. += span_notice("\n\t <a href='?src=[REF(src)];bandage_remove=1' class='notice'>[owner.p_their(TRUE)] [plaintext_zone] is bandaged with [bandage][bandage.absorption_capacity ? "." : ", <span class='warning'>it is no longer absorbing blood</span>."]</a>")
		return

	else
		if(bodypart_flags & BP_BROKEN_BONES)
			. += span_warning("It is dented and swollen.")
		return

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
