

/mob/living/carbon/apply_damage(
	damage = 0,
	damagetype = BRUTE,
	def_zone = null,
	blocked = 0,
	forced = FALSE,
	spread_damage = FALSE,
	sharpness = NONE,
	attack_direction = null,
	obj/item/attacking_item = null,
)
	// Spread damage should always have def zone be null
	if(spread_damage)
		def_zone = null

	// Otherwise if def zone is null, we'll get a random bodypart / zone to hit.
	// ALso we'll automatically covnert string def zones into bodyparts to pass into parent call.
	else if(!isbodypart(def_zone))
		var/random_zone = def_zone ? deprecise_zone(def_zone) : get_random_valid_zone(def_zone)
		def_zone = get_bodypart(random_zone) || bodyparts[1]

	. = ..()
	// Taking brute or burn to bodyparts gives a damage flash
	if(def_zone && (damagetype == BRUTE || damagetype == BURN))
		damageoverlaytemp += .

	return .

/mob/living/carbon/human/apply_damage(
	damage = 0,
	damagetype = BRUTE,
	def_zone = null,
	blocked = 0,
	forced = FALSE,
	spread_damage = FALSE,
	sharpness = NONE,
	attack_direction = null,
	obj/item/attacking_item = null,
)

	// Add relevant DR modifiers into blocked value to pass to parent
	blocked += physiology?.damage_resistance
	return ..()

/mob/living/carbon/human/get_incoming_damage_modifier(
	damage = 0,
	damagetype = BRUTE,
	def_zone = null,
	sharpness = NONE,
	attack_direction = null,
	attacking_item,
)
	. = ..()

	switch(damagetype)
		if(BRUTE)
			. *= physiology.brute_mod
		if(BURN)
			. *= physiology.burn_mod
		if(TOX)
			. *= physiology.tox_mod
		if(CLONE)
			. *= physiology.clone_mod
		if(STAMINA)
			. *= physiology.stamina_mod
		if(BRAIN)
			. *= physiology.brain_mod

	return .


//These procs fetch a cumulative total damage from all bodyparts
/mob/living/carbon/getBruteLoss()
	var/amount = 0
	for(var/obj/item/bodypart/BP as anything in bodyparts)
		if(!IS_ORGANIC_LIMB(BP))
			continue
		amount += BP.brute_dam
	return amount

/mob/living/carbon/getFireLoss()
	var/amount = 0
	for(var/obj/item/bodypart/BP as anything in bodyparts)
		if(!IS_ORGANIC_LIMB(BP))
			continue
		amount += BP.burn_dam
	return amount


/mob/living/carbon/adjustBruteLoss(amount, updating_health = TRUE, forced = FALSE, required_status)
	if(!forced && (status_flags & GODMODE))
		return FALSE
	if(amount > 0)
		take_overall_damage(amount, 0, updating_health, required_status, modifiers = NONE)
	else
		heal_overall_damage(abs(amount), 0, required_status ? required_status : BODYTYPE_ORGANIC, updating_health)
	return amount

/mob/living/carbon/adjustFireLoss(amount, updating_health = TRUE, forced = FALSE, required_status)
	if(!forced && (status_flags & GODMODE))
		return FALSE
	if(amount > 0)
		take_overall_damage(0, amount, updating_health, required_status, modifiers = FALSE)
	else
		heal_overall_damage(0, abs(amount), required_status ? required_status : BODYTYPE_ORGANIC, updating_health)
	return amount

/mob/living/carbon/adjustToxLoss(amount, updating_health = TRUE, forced = FALSE, cause_of_death = "Systemic organ failure")
	if(!amount)
		return
	var/heal = amount < 0
	if(!forced && HAS_TRAIT(src, TRAIT_TOXINLOVER)) //damage becomes healing and healing becomes damage
		amount = -amount
		if(HAS_TRAIT(src, TRAIT_TOXIMMUNE)) //Prevents toxin damage, but not healing
			amount = min(amount, 0)
		if(!heal)
			adjustBloodVolume(-5 * amount)
		else
			adjustBloodVolume(-amount)

	else if(HAS_TRAIT(src, TRAIT_TOXIMMUNE)) //Prevents toxin damage, but not healing
		amount = min(amount, 0)

	if(!heal) //Not a toxin lover
		amount *= (1 - (CHEM_EFFECT_MAGNITUDE(src, CE_ANTITOX) * 0.25)) || 1

	var/list/pick_organs = shuffle(processing_organs)
	// Prioritize damaging our filtration organs first.
	var/obj/item/organ/kidneys/kidneys = organs_by_slot[ORGAN_SLOT_KIDNEYS]
	if(kidneys)
		pick_organs -= kidneys
		pick_organs.Insert(1, kidneys)
	var/obj/item/organ/liver/liver = organs_by_slot[ORGAN_SLOT_LIVER]
	if(liver)
		pick_organs -= liver
		pick_organs.Insert(1, liver)

	// Move the brain to the very end since damage to it is vastly more dangerous
	// (and isn't technically counted as toxloss) than general organ damage.
	var/obj/item/organ/brain/brain = organs_by_slot[ORGAN_SLOT_BRAIN]
	if(brain)
		pick_organs -= brain
		pick_organs += brain

	for(var/obj/item/organ/O as anything in pick_organs)
		if(heal)
			if(amount >= 0)
				break
		else if(amount <= 0)
			break

		amount -= O.applyOrganDamage(amount, silent = TRUE, cause_of_death = cause_of_death)

/mob/living/carbon/getToxLoss()
	for(var/obj/item/organ/O as anything in processing_organs)
		. += O.getToxLoss()

/mob/living/carbon/pre_stamina_change(diff as num, forced)
	if(!forced && (status_flags & GODMODE))
		return 0
	return diff

/**
 * If an organ exists in the slot requested, and we are capable of taking damage (we don't have [GODMODE] on), call the damage proc on that organ.
 *
 * Arguments:
 * * slot - organ slot, like [ORGAN_SLOT_HEART]
 * * amount - damage to be done
 * * maximum - currently an arbitrarily large number, can be set so as to limit damage
 */
/mob/living/carbon/adjustOrganLoss(slot, amount, maximum, updating_health)
	var/obj/item/organ/O = getorganslot(slot)
	if(O && !(status_flags & GODMODE))
		O.applyOrganDamage(amount, maximum, updating_health = updating_health)

/**
 * If an organ exists in the slot requested, and we are capable of taking damage (we don't have [GODMODE] on), call the set damage proc on that organ, which can
 * set or clear the failing variable on that organ, making it either cease or start functions again, unlike adjustOrganLoss.
 *
 * Arguments:
 * * slot - organ slot, like [ORGAN_SLOT_HEART]
 * * amount - damage to be set to
 */
/mob/living/carbon/setOrganLoss(slot, amount)
	var/obj/item/organ/O = getorganslot(slot)
	if(O && !(status_flags & GODMODE))
		O.setOrganDamage(amount)

/**
 * If an organ exists in the slot requested, return the amount of damage that organ has
 *
 * Arguments:
 * * slot - organ slot, like [ORGAN_SLOT_HEART]
 */
/mob/living/carbon/getOrganLoss(slot)
	if(slot == ORGAN_SLOT_BRAIN)
		return getBrainLoss()

	var/obj/item/organ/O = getorganslot(slot)
	if(O)
		return O.damage

/mob/living/carbon/getBrainLoss()
	if(!needs_organ(ORGAN_SLOT_BRAIN))
		return 0

	var/obj/item/organ/brain/B = getorganslot(ORGAN_SLOT_BRAIN)
	return B ? B.damage : maxHealth

////////////////////////////////////////////

///Returns a list of damaged bodyparts
/mob/living/carbon/proc/get_damaged_bodyparts(brute = FALSE, burn = FALSE, status, check_flags)
	var/list/obj/item/bodypart/parts = list()
	for(var/obj/item/bodypart/BP as anything in bodyparts)
		if(status && !(BP.bodytype & status))
			continue
		if((brute && BP.brute_dam) || (burn && BP.burn_dam) || (BP.bodypart_flags & check_flags))
			parts += BP

	return parts

///Returns a list of damageable bodyparts
/mob/living/carbon/proc/get_damageable_bodyparts(status)
	var/list/obj/item/bodypart/parts = list()
	for(var/X in bodyparts)
		var/obj/item/bodypart/BP = X
		if(status && !(BP.bodytype & status))
			continue
		if(BP.is_damageable())
			parts += BP
	return parts

/**
 * Heals ONE bodypart randomly selected from damaged ones.
 *
 * It automatically updates damage overlays if necessary
 *
 * It automatically updates health status
 */
/mob/living/carbon/heal_bodypart_damage(brute = 0, burn = 0, updating_health = TRUE, required_status)
	var/list/obj/item/bodypart/parts = get_damaged_bodyparts(brute,burn,required_status)
	if(!parts.len)
		return
	var/obj/item/bodypart/picked = pick(parts)
	var/damage_calculator = picked.get_damage() //heal_damage returns update status T/F instead of amount healed so we dance gracefully around this
	if(picked.heal_damage(brute, burn, required_status))
		update_damage_overlays()
	return max(damage_calculator - picked.get_damage(), 0)


/**
 * Damages ONE bodypart randomly selected from damagable ones.
 *
 * It automatically updates damage overlays if necessary
 *
 * It automatically updates health status
 */
/mob/living/carbon/take_bodypart_damage(brute = 0, burn = 0, updating_health = TRUE, required_status, check_armor = FALSE, sharpness = NONE)
	var/list/obj/item/bodypart/parts = get_damageable_bodyparts(required_status)
	if(!parts.len)
		return
	var/obj/item/bodypart/picked = pick(parts)
	if(picked.receive_damage(brute, burn, blocked = check_armor ? run_armor_check(picked, (brute ? BLUNT : burn ? FIRE : null)) : FALSE, sharpness = sharpness))
		update_damage_overlays()

///Heal MANY bodyparts, in random order
/mob/living/carbon/heal_overall_damage(brute = 0, burn = 0, required_status, updating_health = TRUE)
	var/list/obj/item/bodypart/parts = get_damaged_bodyparts(brute, burn, required_status)

	var/update = NONE
	while(parts.len && (brute > 0 || burn > 0))
		var/obj/item/bodypart/picked = pick(parts)

		var/brute_was = picked.brute_dam
		var/burn_was = picked.burn_dam

		update |= picked.heal_damage(brute, burn, required_status, FALSE)

		brute = round(brute - (brute_was - picked.brute_dam), DAMAGE_PRECISION)
		burn = round(burn - (burn_was - picked.burn_dam), DAMAGE_PRECISION)

		parts -= picked

	if(updating_health)
		updatehealth()
	if(update)
		update_damage_overlays()

/// damage MANY bodyparts, in random order
/mob/living/carbon/take_overall_damage(brute = 0, burn = 0, updating_health = TRUE, required_status, sharpness, modifiers = DEFAULT_DAMAGE_FLAGS)
	if(status_flags & GODMODE)
		return //godmode

	var/list/obj/item/bodypart/not_full = get_damageable_bodyparts(required_status)
	if(!length(not_full))
		return

	var/update = 0

	// Receive_damage() rounds to damage precision, dont bother doing it here.
	brute /= length(not_full)
	burn /= length(not_full)

	for(var/obj/item/bodypart/bp as anything in not_full)
		update |= bp.receive_damage(brute, burn, 0, FALSE, required_status, sharpness, modifiers = modifiers)

	if(updating_health && (update & BODYPART_LIFE_UPDATE_HEALTH))
		updatehealth()
	if(update & BODYPART_LIFE_UPDATE_DAMAGE_OVERLAYS)
		update_damage_overlays()

/mob/living/carbon/getOxyLoss()
	if(HAS_TRAIT(src, TRAIT_NOBREATH))
		return 0
	var/obj/item/organ/lungs/L = getorganslot(ORGAN_SLOT_LUNGS)
	if(!L || (L.organ_flags & ORGAN_DEAD))
		return maxHealth

	return ..()
