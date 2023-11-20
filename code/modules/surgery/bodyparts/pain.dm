/// Adjusts the pain of a limb, returning the difference. Do not call directly, use carbon.apply_pain().
/obj/item/bodypart/proc/adjustPain(amount)
	if(bodypart_flags & BP_NO_PAIN)
		return

	var/last_pain = pain
	pain = clamp(pain + amount, 0, max_damage)
	return pain - last_pain

/// Returns the amount of pain this bodypart is contributing
/obj/item/bodypart/proc/getPain()
	if(bodypart_flags & BP_NO_PAIN)
		return

	var/lasting_pain = 0
	if(bodypart_flags & BP_BROKEN_BONES)
		lasting_pain += 10

	else if(bodypart_flags & BP_DISLOCATED)
		lasting_pain += 5

	var/organ_dam = 0
	for(var/obj/item/organ/O as anything in contained_organs)
		if(O.cosmetic_only || istype(O, /obj/item/organ/brain))
			continue

		organ_dam += min(O.damage, O.maxHealth)

	return pain + lasting_pain + (0.7 * brute_dam) + (0.8 * burn_dam) + (0.3 * organ_dam)
