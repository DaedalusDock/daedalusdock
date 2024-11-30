/mob/living/attacked_by(obj/item/attacking_item, mob/living/attacker)
	var/hit_zone = BODY_ZONE_CHEST
	var/hit_zone_text = "body"

	var/ishuman = ishuman(src)
	// Humans have miss chance. We dont apply this to living mobs for my sanity, i guess.
	if(ishuman)
		var/target_zone = deprecise_zone(attacker.zone_selected) //our REAL intended target

		// Can't hit a bodypart that doesn't exist!
		var/obj/item/bodypart/affecting = get_bodypart(target_zone)
		if (!affecting || affecting.is_stump)
			to_chat(attacker, span_danger("[p_they(TRUE)] do not have a [parse_zone(target_zone)]!"))
			return MOB_ATTACKEDBY_FAIL

		// If we aren't being hit by ourself, roll for accuracy.
		if(attacker != src)
			var/bodyzone_modifier = GLOB.bodyzone_gurps_mods[target_zone]
			var/roll
			if(HAS_TRAIT(attacker, TRAIT_PERFECT_ATTACKER))
				roll = SUCCESS
			else
				roll = attacker.stat_roll(10, /datum/rpg_skill/skirmish, bodyzone_modifier, -7, src).outcome

			switch(roll)
				if(CRIT_FAILURE)
					visible_message(span_danger("\The [attacker] swings at [src] with [attacking_item], narrowly missing!"))
					return MOB_ATTACKEDBY_MISS // lol owned

				if(FAILURE)
					hit_zone = get_random_valid_zone()

				else
					hit_zone = target_zone

			affecting = get_bodypart(hit_zone)

		hit_zone_text = affecting.plaintext_zone

	send_item_attack_message(attacking_item, attacker, hit_zone_text != "body" ? hit_zone_text : null)

	var/attack_flag = attacking_item.get_attack_flag()
	var/armor_block = min(run_armor_check(
		def_zone = hit_zone,
		attack_flag = attack_flag,
		absorb_text = span_notice("Your armor has protected your [hit_zone_text]!"),
		soften_text = span_warning("Your armor has softened a [armor_flag_to_strike_string(attack_flag)] to your [hit_zone_text]!"),
		armor_penetration = attacking_item.armor_penetration,
		weak_against_armor = attacking_item.weak_against_armor
	), ARMOR_MAX_BLOCK)

	var/damage = attacking_item.force

	if(attacker != src)
		// This doesn't factor in armor, or most damage modifiers (physiology). Your mileage may vary
		if(check_block(attacking_item, damage, "[attacking_item]", MELEE_ATTACK, attacking_item.armor_penetration, attacking_item.damtype))
			return MOB_ATTACKEDBY_NO_DAMAGE

	SEND_SIGNAL(attacking_item, COMSIG_ITEM_ATTACK_ZONE, src, attacker, hit_zone)

	if(damage <= 0)
		return MOB_ATTACKEDBY_NO_DAMAGE

	if(ishuman || client) // istype(src) is kinda bad, but it's to avoid spamming the blackbox
		SSblackbox.record_feedback("nested tally", "item_used_for_combat", 1, list("[attacking_item.force]", "[attacking_item.type]"))
		SSblackbox.record_feedback("tally", "zone_targeted", 1, parse_zone(deprecise_zone(attacker.zone_selected)))

	var/damage_done = apply_damage(
		damage = damage,
		damagetype = attacking_item.damtype,
		def_zone = BODY_ZONE_CHEST,
		blocked = armor_block,
		sharpness = attacking_item.sharpness,
		attack_direction = get_dir(attacker, src),
		attacking_item = attacking_item
	)

	on_take_combat_damage(damage_done, hit_zone, armor_block, attacking_item, attacker)
	return MOB_ATTACKEDBY_SUCCESS

/mob/living/carbon/human/attacked_by(obj/item/attacking_item, mob/living/attacker)
	. = ..()
	if(. != MOB_ATTACKEDBY_SUCCESS)
		return .

	if(attacking_item.stamina_damage)
		var/damage = attacking_item.stamina_damage
		if(prob(attacking_item.stamina_critical_chance))
			damage *= attacking_item.stamina_critical_modifier
		stamina.adjust(-damage)
/**
 * Called when we take damage, used to cause effects such as a blood splatter.
 *
 * Return TRUE if an effect was done, FALSE otherwise.
 */
/mob/living/proc/on_take_combat_damage(damage_done, hit_zone, armor_block, obj/item/attacking_item, mob/living/attacker)
	if(damage_done > 0 && attacking_item.damtype == BRUTE && prob(25 + damage_done * 2))
		attacking_item.add_mob_blood(src)
		if(prob(damage_done * 2)) //blood spatter!
			add_splatter_floor(get_turf(src))
			if(get_dist(attacker, src) <= 1)
				attacker.add_mob_blood(src)
		return TRUE

/mob/living/silicon/robot/on_take_combat_damage(damage_done, hit_zone, armor_block, obj/item/attacking_item, mob/living/attacker)
	if(damage_done > 0 && attacking_item.damtype != STAMINA && stat != DEAD)
		spark_system.start()
		. = TRUE
	return ..() || .

/mob/living/silicon/ai/on_take_combat_damage(damage_done, hit_zone, armor_block, obj/item/attacking_item, mob/living/attacker)
	if(damage_done > 0 && attacking_item.damtype != STAMINA && stat != DEAD)
		spark_system.start()
		. = TRUE
	return ..() || .

/mob/living/carbon/on_take_combat_damage(damage_done, hit_zone, armor_block, obj/item/attacking_item, mob/living/attacker)
	var/obj/item/bodypart/hit_bodypart = get_bodypart(hit_zone)
	if(!(hit_bodypart.bodypart_flags & BP_HAS_BLOOD))
		return FALSE

	return ..()

/mob/living/carbon/human/on_take_combat_damage(damage_done, hit_zone, armor_block, obj/item/attacking_item, mob/living/attacker)
	. = ..()
	var/list/blood_dna
	if(.)
		blood_dna = get_blood_dna_list()

	switch(hit_zone)
		if(BODY_ZONE_HEAD)
			if(blood_dna) //Apply blood
				add_blood_DNA_to_items(blood_dna, ITEM_SLOT_EYES | ITEM_SLOT_HEAD | ITEM_SLOT_MASK)

			// Massive physical trauma to the head causes very bad things to happen!
			if(armor_block < 50 && damage_done >= 20 && prob(damage_done))
				var/effect_duration = min(. * 0.2, 20)

				if(stat == CONSCIOUS)
					flash_act(INFINITY, visual = TRUE)
					visible_message(span_danger("[src] is knocked to the floor."))

				blur_eyes(damage_done)
				adjust_confusion_up_to(effect_duration SECONDS, 20 SECONDS)
				Unconscious(effect_duration SECONDS)

				if(prob(10))
					gain_trauma(/datum/brain_trauma/mild/concussion)

				// rev deconversion through blunt trauma.
				// this can be signalized to the rev datum
				if(mind && stat != CONSCIOUS && src != attacker && prob(attacking_item.force + ((100 - health) * 0.5))) // rev deconversion through blunt trauma.
					var/datum/antagonist/rev/rev = mind.has_antag_datum(/datum/antagonist/rev)
					if(rev)
						rev.remove_revolutionary(FALSE, attacker)

		if(BODY_ZONE_CHEST)
			if(blood_dna)
				add_blood_DNA_to_items(blood_dna, ITEM_SLOT_ICLOTHING | ITEM_SLOT_OCLOTHING)
