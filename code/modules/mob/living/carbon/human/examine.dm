#define EXAMINE_LINK(item) button_element(item, "\[?\]", "examine=1")

/mob/living/carbon/human/examine(mob/user)
//this is very slightly better than it was because you can use it more places. still can't do \his[src] though.
	var/t_He = p_they(TRUE)
	var/t_His = p_their(TRUE)
	var/t_his = p_their()
	var/t_him = p_them()
	var/t_has = p_have()
	var/t_is = p_are()
	var/t_es = p_es()
	var/t_s = p_s()
	var/obscure_name

	if(isliving(user))
		var/mob/living/L = user
		if(HAS_TRAIT(L, TRAIT_PROSOPAGNOSIA) || HAS_TRAIT(L, TRAIT_INVISIBLE_MAN))
			obscure_name = TRUE

	var/obscured = check_obscured_slots()
	var/skipface = (wear_mask && (wear_mask.flags_inv & HIDEFACE)) || (head && (head.flags_inv & HIDEFACE))

	var/species_text
	if(dna.species && !skipface)
		species_text = ", \a [dna.species.name]"
		if(SScodex.get_codex_entry(get_codex_value(user)))
			species_text += span_notice(" \[<a href='?src=\ref[SScodex];show_examined_info=\ref[src];show_to=\ref[user]'>?</a>\]")

	. = list("<span class='info'>This is <EM>[!obscure_name ? name : "Unknown"][species_text]!</EM><hr>")

	if(!skipface)
		var/age_text
		switch(age)
			if(-INFINITY to 25) //what
				age_text = "very young"
			if(26 to 35)
				age_text = "of adult age"
			if(36 to 55)
				age_text = "middle-aged"
			if(56 to 75)
				age_text = "rather old"
			if(76 to 100)
				age_text = "very old"
			if(101 to INFINITY)
				age_text = "withering away"
		. += span_notice("[t_He] appear[t_s] to be [age_text].")

	//uniform
	if(w_uniform && !(obscured & ITEM_SLOT_ICLOTHING) && !(w_uniform.item_flags & EXAMINE_SKIP))
		//accessory
		var/accessory_msg
		if(istype(w_uniform, /obj/item/clothing/under))
			var/obj/item/clothing/under/U = w_uniform
			if(U.attached_accessory)
				accessory_msg += " with [icon2html(U.attached_accessory, user)] \a [U.attached_accessory] [EXAMINE_LINK(U.attached_accessory)]"

		. += "[t_He] [t_is] wearing [w_uniform.get_examine_string(user)] [EXAMINE_LINK(w_uniform)] [accessory_msg]."
	//head
	if(head && !(obscured & ITEM_SLOT_HEAD) && !(head.item_flags & EXAMINE_SKIP))
		. += "[t_He] [t_is] wearing [head.get_examine_string(user)] [EXAMINE_LINK(head)] on [t_his] head."
	//suit/armor
	if(wear_suit && !(wear_suit.item_flags & EXAMINE_SKIP))
		. += "[t_He] [t_is] wearing [wear_suit.get_examine_string(user)] [EXAMINE_LINK(wear_suit)]."
		//suit/armor storage
		if(s_store && !(obscured & ITEM_SLOT_SUITSTORE) && !(s_store.item_flags & EXAMINE_SKIP))
			. += "[t_He] [t_is] carrying [s_store.get_examine_string(user)] [EXAMINE_LINK(s_store)] on [t_his] [wear_suit.name]."
	//back
	if(back && !(back.item_flags & EXAMINE_SKIP))
		. += "[t_He] [t_has] [back.get_examine_string(user)] [EXAMINE_LINK(back)] on [t_his] back."

	//Hands
	for(var/obj/item/I in held_items)
		if(!(I.item_flags & ABSTRACT) && !(I.item_flags & EXAMINE_SKIP))
			. += "[t_He] [t_is] holding [I.get_examine_string(user)] [EXAMINE_LINK(I)] in [t_his] [I.wielded ? "hands" : get_held_index_name(get_held_index_of_item(I))]."

	//gloves
	if(gloves && !(obscured & ITEM_SLOT_GLOVES) && !(gloves.item_flags & EXAMINE_SKIP))
		. += "[t_He] [t_has] [gloves.get_examine_string(user)] [EXAMINE_LINK(gloves)] on [t_his] hands."

	else if(length(forensics?.blood_DNA))
		if(num_hands)
			. += span_warning("[t_He] [t_has] [num_hands > 1 ? "" : "a"] blood-stained hand[num_hands > 1 ? "s" : ""]!")

	//handcuffed?
	if(handcuffed)
		if(istype(handcuffed, /obj/item/restraints/handcuffs/cable))
			. += span_warning("[t_He] [t_is] [icon2html(handcuffed, user)] restrained with cable!")
		else if(istype(handcuffed, /obj/item/restraints/handcuffs/tape))
			. += span_warning("[t_He] [t_is] [icon2html(handcuffed, user)] bound by tape!")
		else
			. += span_warning("[t_He] [t_is] handcuffed with [icon2html(handcuffed, user)] [handcuffed] [EXAMINE_LINK(handcuffed)] !")

	//belt
	if(belt && !(belt.item_flags & EXAMINE_SKIP))
		. += "[t_He] [t_has] [belt.get_examine_string(user)] [EXAMINE_LINK(belt)] about [t_his] waist."

	//shoes
	if(shoes && !(obscured & ITEM_SLOT_FEET)  && !(shoes.item_flags & EXAMINE_SKIP))
		. += "[t_He] [t_is] wearing [shoes.get_examine_string(user)] [EXAMINE_LINK(shoes)] on [t_his] feet."

	//mask
	if(wear_mask && !(obscured & ITEM_SLOT_MASK)  && !(wear_mask.item_flags & EXAMINE_SKIP))
		. += "[t_He] [t_has] [wear_mask.get_examine_string(user)] [EXAMINE_LINK(wear_mask)] on [t_his] face."

	if(wear_neck && !(obscured & ITEM_SLOT_NECK)  && !(wear_neck.item_flags & EXAMINE_SKIP))
		. += "[t_He] [t_is] wearing [wear_neck.get_examine_string(user)] [EXAMINE_LINK(wear_neck)] around [t_his] neck."

	//eyes
	if(!(obscured & ITEM_SLOT_EYES) )
		if(glasses  && !(glasses.item_flags & EXAMINE_SKIP))
			. += "[t_He] [t_has] [glasses.get_examine_string(user)] [EXAMINE_LINK(glasses)] covering [t_his] eyes."
		else if(HAS_TRAIT(src, TRAIT_UNNATURAL_RED_GLOWY_EYES))
			. += "<span class='warning'><B>[t_His] eyes are glowing with an unnatural red aura!</B></span>"
		else if(HAS_TRAIT(src, TRAIT_BLOODSHOT_EYES))
			. += "<span class='warning'><B>[t_His] eyes are bloodshot!</B></span>"

	//ears
	if(ears && !(obscured & ITEM_SLOT_EARS) && !(ears.item_flags & EXAMINE_SKIP))
		. += "[t_He] [t_has] [ears.get_examine_string(user)] [EXAMINE_LINK(ears)] on [t_his] ears."

	//ID
	if(wear_id && !(wear_id.item_flags & EXAMINE_SKIP))
		var/id_topic = wear_id.GetID() ? " <a href='?src=\ref[wear_id];look_at_id=1'>\[Look at ID\]</a>" : ""
		. += "[t_He] [t_is] wearing [wear_id.get_examine_string(user)] [EXAMINE_LINK(wear_id)]. [id_topic]"

	//Status effects
	var/list/status_examines = get_status_effect_examinations()
	if (length(status_examines))
		. += status_examines

	var/appears_dead = FALSE
	var/adjacent = get_dist(user, src) <= 1
	if(stat != CONSCIOUS || (HAS_TRAIT(src, TRAIT_FAKEDEATH)))
		if(!adjacent)
			. += span_alert("[t_He] is not moving.")
		else
			if(stat == UNCONSCIOUS && !HAS_TRAIT(src, TRAIT_FAKEDEATH))
				. += span_notice("[t_He] [t_is] unconsious.")
				if(failed_last_breath)
					. += span_alert("[t_He] isn't breathing.")
			else
				. += span_danger("The spark of life has left [t_him].")
				if(suiciding)
					. += span_warning("[t_He] appear[t_s] to have committed suicide.")

	if(get_bodypart(BODY_ZONE_HEAD) && needs_organ(ORGAN_SLOT_BRAIN) && !getorgan(/obj/item/organ/brain))
		. += span_deadsay("It appears that [t_his] brain is missing...")

	var/list/msg = list()

	var/list/missing = list(BODY_ZONE_HEAD, BODY_ZONE_CHEST, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
	var/list/disabled = list()
	var/list/body_zones_covered = get_covered_body_zones(TRUE) //This is a bitfield of the body_zones_covered. Not parts. Yeah. Sucks.
	var/list/bodyparts = sort_list(src.bodyparts, GLOBAL_PROC_REF(cmp_bodyparts_display_order))

	var/visible_bodyparts = 0
	// Potentially pickweight from this list after a medicine check.
	var/list/fucked_reasons = list()

	for(var/obj/item/bodypart/body_part as anything in bodyparts)
		if(body_part.bodypart_disabled)
			disabled += body_part
		missing -= body_part.body_zone

		if(is_bodypart_visibly_covered(body_part, body_zones_covered))
			var/is_bloody
			for(var/datum/wound/W as anything in body_part.wounds)
				if(W.bleeding())
					msg += span_warning("Blood soaks through [t_his] [body_part.plaintext_zone] covering.\n")
					is_bloody = TRUE
					fucked_reasons["The blood soaking through [t_his] [body_part.plaintext_zone] indicates a dire wound."] = 1
					break
			if(!is_bloody)
				msg += span_notice("[t_His] [body_part.plaintext_zone] is covered.\n")
			for(var/string in body_part.mob_examine(hal_screwyhud, TRUE))
				msg += "[string]</br>"

			continue
		else
			visible_bodyparts++
			if((body_part.brute_dam + body_part.burn_dam) >= body_part.max_damage * 0.8)
				fucked_reasons["[t_His] [body_part.plaintext_zone] is greviously injured."] = 3

			for(var/string in body_part.mob_examine(hal_screwyhud, FALSE))
				msg += "[string]</br>"

	for(var/X in disabled)
		var/obj/item/bodypart/body_part = X
		var/damage_text
		if(HAS_TRAIT(body_part, TRAIT_DISABLED_BY_WOUND))
			continue // skip if it's disabled by a wound (cuz we'll be able to see the bone sticking out!)
		if(!(body_part.get_damage() >= body_part.max_damage)) //we don't care if it's stamcritted
			damage_text = "limp and lifeless"
		else
			damage_text = (body_part.brute_dam >= body_part.burn_dam) ? body_part.heavy_brute_msg : body_part.heavy_burn_msg
		msg += "<B>[capitalize(t_his)] [body_part.name] is [damage_text]!</B>\n"

	//stores missing limbs
	var/l_limbs_missing = 0
	var/r_limbs_missing = 0
	for(var/t in missing)
		if(t==BODY_ZONE_HEAD)
			msg += "<span class='deadsay'><B>[t_His] [parse_zone(t)] is missing!</B><span class='warning'>\n"
			continue
		if(t == BODY_ZONE_L_ARM || t == BODY_ZONE_L_LEG)
			l_limbs_missing++
		else if(t == BODY_ZONE_R_ARM || t == BODY_ZONE_R_LEG)
			r_limbs_missing++

		msg += "<B>[capitalize(t_his)] [parse_zone(t)] is missing!</B>\n"

	if(l_limbs_missing >= 2 && r_limbs_missing == 0)
		msg += "[t_He] look[t_s] all right now.\n"
	else if(l_limbs_missing == 0 && r_limbs_missing >= 2)
		msg += "[t_He] really keeps to the left.\n"
	else if(l_limbs_missing >= 2 && r_limbs_missing >= 2)
		msg += "[t_He] [p_do()]n't seem all there.\n"

	var/temp
	temp = getCloneLoss()
	if(temp)
		if(temp < 25)
			msg += "[t_He] [t_has] minor cellular damage.\n"
		else if(temp < 50)
			msg += "[t_He] [t_has] <b>moderate</b> cellular damage!\n"
		else
			msg += "<b>[t_He] [t_has] severe cellular damage!</b>\n"


	if(has_status_effect(/datum/status_effect/fire_handler/fire_stacks))
		msg += "[t_He] [t_is] covered in something flammable.\n"
	if(locate(/datum/reagent/toxin/acid) in touching?.reagent_list)
		msg += span_warning("[t_He] is covered in burning acid! \n")
	else if(has_status_effect(/datum/status_effect/fire_handler/wet_stacks) || length(touching?.reagent_list))
		msg += "[t_He] look[t_s] a little soaked.\n"


	for(var/obj/item/hand_item/grab/G in grabbed_by)
		if(G.assailant == src)
			msg += "[t_He] [t_is] gripping [t_His] [G.get_targeted_bodypart().plaintext_zone].\n"
			continue
		if(!G.current_grab.stop_move)
			continue
		msg += "[t_He] [t_is] restrained by [G.assailant]'s grip.\n"

	if(nutrition < NUTRITION_LEVEL_STARVING - 50)
		msg += "[t_He] [t_is] severely malnourished.\n"
	else if(nutrition >= NUTRITION_LEVEL_FAT)
		if(user.nutrition < NUTRITION_LEVEL_STARVING - 50)
			msg += "[t_He] [t_is] plump and delicious looking - Like a fat little piggy. A tasty piggy.\n"
		else
			msg += "[t_He] [t_is] quite chubby.\n"
	switch(disgust)
		if(DISGUST_LEVEL_GROSS to DISGUST_LEVEL_VERYGROSS)
			msg += "[t_He] look[t_s] a bit grossed out.\n"
		if(DISGUST_LEVEL_VERYGROSS to DISGUST_LEVEL_DISGUSTED)
			msg += "[t_He] look[t_s] really grossed out.\n"
		if(DISGUST_LEVEL_DISGUSTED to INFINITY)
			msg += "[t_He] look[t_s] extremely disgusted.\n"

	var/apparent_blood_volume = blood_volume
	if(skin_tone == "albino")
		apparent_blood_volume -= 150 // enough to knock you down one tier
	switch(apparent_blood_volume)
		if(BLOOD_VOLUME_OKAY to BLOOD_VOLUME_SAFE)
			msg += "[t_He] [t_has] pale skin.\n"
		if(BLOOD_VOLUME_BAD to BLOOD_VOLUME_OKAY)
			msg += "<b>[t_He] look[t_s] like pale death.</b>\n"
		if(-INFINITY to BLOOD_VOLUME_BAD)
			msg += "[span_deadsay("<b>[t_He] resemble[t_s] a crushed, empty juice pouch.</b>")]\n"

	if(islist(stun_absorption))
		for(var/i in stun_absorption)
			if(stun_absorption[i]["end_time"] > world.time && stun_absorption[i]["examine_message"])
				msg += "[t_He] [t_is][stun_absorption[i]["examine_message"]]\n"

	if(!appears_dead)
		if (combat_mode)
			msg += "[t_He] appear[p_s()] to be on guard.\n"
		if (getOxyLoss() >= 10)
			msg += "[t_He] appear[p_s()] winded.\n"
		if (getToxLoss() >= 10)
			msg += "[t_He] appear[p_s()] sickly.\n"

		if (bodytemperature < dna.species.cold_discomfort_level)
			msg += "[t_He] [t_is] shivering.\n"

		msg += "</span>"

		if(HAS_TRAIT(user, TRAIT_SPIRITUAL) && mind?.holy_role)
			msg += "[t_He] [t_has] a holy aura about [t_him].\n"

		switch(stat)
			if(CONSCIOUS)
				if(HAS_TRAIT(src, TRAIT_DUMB))
					msg += "[t_He] [t_has] a stupid expression on [t_his] face.\n"
				if(HAS_TRAIT(src, TRAIT_SOFT_CRITICAL_CONDITION))
					msg += "[t_He] [t_is] barely conscious.\n"

		if(getorgan(/obj/item/organ/brain))
			if(ai_controller?.ai_status == AI_STATUS_ON)
				msg += "[span_deadsay("[t_He] do[t_es]n't appear to be [t_him]self.")]\n"
			else if(!key)
				msg += "[span_deadsay("[t_He] [t_is] totally catatonic. The stresses of life in deep-space must have been too much for [t_him]. Any recovery is unlikely.")]\n"

	if (length(msg))
		. += span_warning("[msg.Join("")]")

	var/trait_exam = common_trait_examine()
	if (!isnull(trait_exam))
		. += trait_exam

	var/perpname = get_face_name(get_id_name(""))
	if(perpname && (HAS_TRAIT(user, TRAIT_SECURITY_HUD) || HAS_TRAIT(user, TRAIT_MEDICAL_HUD)))
		var/datum/data/record/R = SSdatacore.get_record_by_name(perpname, DATACORE_RECORDS_STATION)
		if(R)
			. += "<span class='deptradio'>Rank:</span> [R.fields[DATACORE_RANK]]\n<a href='?src=[REF(src)];hud=1;photo_front=1'>\[Front photo\]</a><a href='?src=[REF(src)];hud=1;photo_side=1'>\[Side photo\]</a>"
		if(HAS_TRAIT(user, TRAIT_MEDICAL_HUD))
			var/cyberimp_detect
			for(var/obj/item/organ/cyberimp/CI in processing_organs)
				if((CI.organ_flags & ORGAN_SYNTHETIC) && !CI.syndicate_implant)
					cyberimp_detect += "[!cyberimp_detect ? "[CI.get_examine_string(user)]" : ", [CI.get_examine_string(user)]"]"
			if(cyberimp_detect)
				. += "<span class='notice ml-1'>Detected cybernetic modifications:</span>"
				. += "<span class='notice ml-2'>[cyberimp_detect]</span>"
			if(R)
				var/health_r = R.fields[DATACORE_PHYSICAL_HEALTH]
				. += "<a href='?src=[REF(src)];hud=m;p_stat=1'>\[[health_r]\]</a>"
				health_r = R.fields[DATACORE_MENTAL_HEALTH]
				. += "<a href='?src=[REF(src)];hud=m;m_stat=1'>\[[health_r]\]</a>"
			R = SSdatacore.get_record_by_name(perpname, DATACORE_RECORDS_MEDICAL)
			if(R)
				. += "<a href='?src=[REF(src)];hud=m;evaluation=1'>\[Medical evaluation\]</a><br>"
			. += "<a href='?src=[REF(src)];hud=m;quirk=1'>\[See quirks\]</a>"

		if(HAS_TRAIT(user, TRAIT_SECURITY_HUD))
			if(!user.stat && user != src)
			//|| !user.canmove || user.restrained()) Fluff: Sechuds have eye-tracking technology and sets 'arrest' to people that the wearer looks and blinks at.
				var/criminal = "None"

				R = SSdatacore.get_record_by_name(perpname, DATACORE_RECORDS_SECURITY)
				if(R)
					criminal = R.fields[DATACORE_CRIMINAL_STATUS]

				. += "<span class='deptradio'>Criminal status:</span> <a href='?src=[REF(src)];hud=s;status=1'>\[[criminal]\]</a>"
				. += jointext(list("<span class='deptradio'>Security record:</span> <a href='?src=[REF(src)];hud=s;view=1'>\[View\]</a>",
					"<a href='?src=[REF(src)];hud=s;add_citation=1'>\[Add citation\]</a>",
					"<a href='?src=[REF(src)];hud=s;add_crime=1'>\[Add crime\]</a>",
					"<a href='?src=[REF(src)];hud=s;view_comment=1'>\[View comment log\]</a>",
					"<a href='?src=[REF(src)];hud=s;add_comment=1'>\[Add comment\]</a>"), "")
	else if(isobserver(user))
		. += span_info("<b>Traits:</b> [get_quirk_string(FALSE, CAT_QUIRK_ALL)]")

	var/flavor_text_link
	/// The first 1-FLAVOR_PREVIEW_LIMIT characters in the mob's "examine_text" variable. FLAVOR_PREVIEW_LIMIT is defined in flavor_defines.dm.
	var/preview_text = trim(copytext_char((examine_text), 1, FLAVOR_PREVIEW_LIMIT))
	if(preview_text)
		if (!(skipface))
			if(length_char(examine_text) <= FLAVOR_PREVIEW_LIMIT)
				flavor_text_link += "[preview_text]"
			else
				flavor_text_link += "[preview_text]... [button_element(src, "Look Closer?", "open_examine_panel=1")]"
		else
			flavor_text_link = span_notice("...?")
		if (flavor_text_link)
			. += span_notice(flavor_text_link)

	// AT THIS POINT WE'RE DONE WITH EXAMINE STUFF
	var/mob/living/living_user = user
	if(user == src && stat != CONSCIOUS || !istype(living_user) || !living_user.stats?.cooldown_finished("examine_medical_flavortext_[REF(src)]"))
		return

	var/possible_invisible_damage = getToxLoss() > 20 || getBrainLoss()

	if((possible_invisible_damage || length(fucked_reasons) || visible_bodyparts >= 3))
		var/datum/roll_result/result = living_user.stat_roll(15, /datum/rpg_skill/anatomia)
		switch(result.outcome)
			if(SUCCESS, CRIT_SUCCESS)
				spawn(0)
					if(possible_invisible_damage && living_user.stats.cooldown_finished("found_invisible_damage_[REF(src)]"))
						to_chat(living_user, result.create_tooltip("Something is not right, this person is not well. You can feel it in your very core."))
						living_user.stats.set_cooldown("found_invisible_damage_[REF(src)]", INFINITY) // Never again

					else if(length(fucked_reasons))
						to_chat(living_user, result.create_tooltip("[t_He] does not look long for this world. [pick_weight(fucked_reasons)]"))

					else
						to_chat(living_user, result.create_tooltip("[t_He] appears to be in great health, a testament to the endurance of humanity in these trying times."))

		living_user.stats.set_cooldown("examine_medical_flavortext_[REF(src)]", 20 MINUTES)

/**
 * Shows any and all examine text related to any status effects the user has.
 */
/mob/living/proc/get_status_effect_examinations()
	var/list/examine_list = list()

	for(var/datum/status_effect/effect as anything in status_effects)
		var/effect_text = effect.get_examine_text()
		if(!effect_text)
			continue

		examine_list += effect_text

	if(!length(examine_list))
		return

	return examine_list.Join("\n")

///This proc expects to be passed a list of covered zones, for optimization in loops. Use get_covered_body_zones(exact_only = TRUE) for that..
/mob/living/carbon/proc/is_bodypart_visibly_covered(obj/item/bodypart/BP, covered_zones)
	var/zone = BP.body_zone
	if(zone == BODY_ZONE_HEAD)
		return (head && ((head.flags_inv & HIDEMASK) || (head.flags_inv & HIDEFACE)))
	return zone in covered_zones
