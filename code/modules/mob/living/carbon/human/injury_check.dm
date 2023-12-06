/mob/living/carbon/human/check_self_for_injuries()
	if(stat >= UNCONSCIOUS)
		return

	var/list/combined_msg = list("<div class='examine_block'>") //PARIAH EDIT CHANGE

	visible_message(span_notice("[src] examines [p_them()]self.")) //PARIAH EDIT CHANGE

	var/list/missing = list(BODY_ZONE_HEAD, BODY_ZONE_CHEST, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)

	var/list/bodyparts = sort_list(src.bodyparts, GLOBAL_PROC_REF(cmp_bodyparts_display_order))
	for(var/obj/item/bodypart/body_part as anything in bodyparts)
		missing -= body_part.body_zone
		if(body_part.is_pseudopart) //don't show injury text for fake bodyparts; ie chainsaw arms or synthetic armblades
			continue

		var/self_aware = FALSE
		if(HAS_TRAIT(src, TRAIT_SELF_AWARE))
			self_aware = TRUE

		var/limb_max_damage = body_part.max_damage
		var/status = ""
		var/brutedamage = body_part.brute_dam
		var/burndamage = body_part.burn_dam
		if(hallucination)
			if(prob(30))
				brutedamage += rand(30,40)
			if(prob(30))
				burndamage += rand(30,40)

		if(HAS_TRAIT(src, TRAIT_SELF_AWARE))
			status = "[brutedamage] brute damage and [burndamage] burn damage"
			if(!brutedamage && !burndamage)
				status = "no damage"

		else
			if(body_part.type in hal_screwydoll)//Are we halucinating?
				brutedamage = (hal_screwydoll[body_part.type] * 0.2)*limb_max_damage

			if(brutedamage > 0)
				status = body_part.light_brute_msg
			if(brutedamage > (limb_max_damage*0.4))
				status = body_part.medium_brute_msg
			if(brutedamage > (limb_max_damage*0.8))
				status = body_part.heavy_brute_msg
			if(brutedamage > 0 && burndamage > 0)
				status += " and "

			if(burndamage > (limb_max_damage*0.8))
				status += body_part.heavy_burn_msg
			else if(burndamage > (limb_max_damage*0.2))
				status += body_part.medium_burn_msg
			else if(burndamage > 0)
				status += body_part.light_burn_msg

			if(status == "")
				status = "OK"

		var/no_damage
		if(status == "OK" || status == "no damage")
			no_damage = TRUE

		var/isdisabled = ""
		if(body_part.bodypart_disabled && !body_part.is_stump)
			isdisabled = " is disabled"
			if(no_damage)
				isdisabled += " but otherwise"
			else
				isdisabled += " and"

		var/broken = ""
		if(body_part.check_bones() & CHECKBONES_BROKEN)
			broken = " has a broken bone and"

		combined_msg += "<span class='[no_damage ? "notice" : "warning"]'>Your [body_part.name][isdisabled][broken][self_aware ? " has " : " is "][status].</span>"

		if(body_part.check_bones() & BP_BROKEN_BONES)
			combined_msg += "[span_warning("Your [body_part.plaintext_zone] is broken!")]"

	for(var/t in missing)
		combined_msg += span_boldannounce("Your [parse_zone(t)] is missing!")

	if(is_bleeding())
		var/list/obj/item/bodypart/bleeding_limbs = list()
		for(var/obj/item/bodypart/part as anything in bodyparts)
			if(part.get_modified_bleed_rate())
				bleeding_limbs += part

		var/num_bleeds = LAZYLEN(bleeding_limbs)
		var/bleed_text = "<span class='danger'>You are bleeding from your"
		switch(num_bleeds)
			if(1 to 2)
				bleed_text += " [bleeding_limbs[1].name][num_bleeds == 2 ? " and [bleeding_limbs[2].name]" : ""]"
			if(3 to INFINITY)
				for(var/i in 1 to (num_bleeds - 1))
					var/obj/item/bodypart/BP = bleeding_limbs[i]
					bleed_text += " [BP.name],"
				bleed_text += " and [bleeding_limbs[num_bleeds].name]"
		bleed_text += "!</span>"
		combined_msg += bleed_text

	if(stamina.loss)
		if(HAS_TRAIT(src, TRAIT_EXHAUSTED))
			combined_msg += span_info("You're completely exhausted.")
		else
			combined_msg += span_info("You feel fatigued.")
	if(HAS_TRAIT(src, TRAIT_SELF_AWARE))
		var/toxloss = getToxLoss()
		if(toxloss)
			if(toxloss > 10)
				combined_msg += span_danger("You feel sick.")
			else if(toxloss > 20)
				combined_msg += span_danger("You feel nauseated.")
			else if(toxloss > 40)
				combined_msg += span_danger("You feel very unwell!")
		if(oxyloss)
			if(oxyloss > 10)
				combined_msg += span_danger("You feel lightheaded.")
			else if(oxyloss > 20)
				combined_msg += span_danger("Your thinking is clouded and distant.")
			else if(oxyloss > 30)
				combined_msg += span_danger("You're choking!")

	if(!HAS_TRAIT(src, TRAIT_NOHUNGER))
		switch(nutrition)
			if(NUTRITION_LEVEL_FULL to INFINITY)
				combined_msg += span_info("You're completely stuffed!")
			if(NUTRITION_LEVEL_WELL_FED to NUTRITION_LEVEL_FULL)
				combined_msg += span_info("You're well fed!")
			if(NUTRITION_LEVEL_FED to NUTRITION_LEVEL_WELL_FED)
				combined_msg += span_info("You're not hungry.")
			if(NUTRITION_LEVEL_HUNGRY to NUTRITION_LEVEL_FED)
				combined_msg += span_info("You could use a bite to eat.")
			if(NUTRITION_LEVEL_STARVING to NUTRITION_LEVEL_HUNGRY)
				combined_msg += span_info("You feel quite hungry.")
			if(0 to NUTRITION_LEVEL_STARVING)
				combined_msg += span_danger("You're starving!")

	//Compiles then shows the list of damaged organs and broken organs
	var/list/broken = list()
	var/list/damaged = list()
	var/broken_message
	var/damaged_message
	var/broken_plural
	var/damaged_plural
	//Sets organs into their proper list
	for(var/obj/item/organ/organ as anything in processing_organs)
		if(organ.organ_flags & ORGAN_DEAD)
			if(broken.len)
				broken += ", "
			broken += organ.name
		else if(organ.damage > organ.low_threshold)
			if(damaged.len)
				damaged += ", "
			damaged += organ.name

	//Checks to enforce proper grammar, inserts words as necessary into the list
	if(broken.len)
		if(broken.len > 1)
			broken.Insert(broken.len, "and ")
			broken_plural = TRUE
		else
			var/holder = broken[1] //our one and only element
			if(holder[length(holder)] == "s")
				broken_plural = TRUE
		//Put the items in that list into a string of text
		for(var/B in broken)
			broken_message += B
		combined_msg += span_warning("Your [broken_message] [broken_plural ? "are" : "is"] non-functional!")

	if(damaged.len)
		if(damaged.len > 1)
			damaged.Insert(damaged.len, "and ")
			damaged_plural = TRUE
		else
			var/holder = damaged[1]
			if(holder[length(holder)] == "s")
				damaged_plural = TRUE
		for(var/D in damaged)
			damaged_message += D
		combined_msg += span_info("Your [damaged_message] [damaged_plural ? "are" : "is"] hurt.")

	if(quirks.len)
		combined_msg += span_notice("You have these quirks: [get_quirk_string(FALSE, CAT_QUIRK_ALL)].")

	combined_msg += "</div>" //close initial div

	to_chat(src, combined_msg.Join("\n"))
