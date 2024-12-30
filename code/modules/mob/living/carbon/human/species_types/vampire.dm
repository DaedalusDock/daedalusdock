
///how many vampires exist in each house
#define VAMPIRES_PER_HOUSE 5
///maximum a vampire will drain, they will drain less if they hit their cap
#define VAMP_DRAIN_AMOUNT 50

/datum/species/vampire
	name = "\improper Vampire"
	id = SPECIES_VAMPIRE
	default_color = "FFFFFF"
	species_traits = list(
		EYECOLOR,
		HAIR,
		FACEHAIR,
		LIPS,
		DRINKSBLOOD,
		BLOOD_CLANS,
		HAIRCOLOR,
		FACEHAIRCOLOR,
	)
	inherent_traits = list(
		TRAIT_ADVANCEDTOOLUSER,
		TRAIT_CAN_STRIP,
		TRAIT_NOHUNGER,
		TRAIT_NOBREATH,
	)
	inherent_biotypes = MOB_UNDEAD|MOB_HUMANOID
	mutant_bodyparts = list("wings" = "None")
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_PRIDE | MIRROR_MAGIC | ERT_SPAWN
	use_skintones = TRUE

	examine_limb_id = SPECIES_HUMAN
	skinned_type = /obj/item/stack/sheet/animalhide/human
	///some starter text sent to the vampire initially, because vampires have shit to do to stay alive
	var/info_text = "You are a <span class='danger'>Vampire</span>. You will slowly but constantly lose blood if outside of a coffin. If inside a coffin, you will slowly heal. You may gain more blood by grabbing a live victim and using your drain ability."

	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain,
		ORGAN_SLOT_HEART = /obj/item/organ/heart/vampire,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes,
		ORGAN_SLOT_EARS =  /obj/item/organ/ears,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue/vampire,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach,
		ORGAN_SLOT_APPENDIX = /obj/item/organ/appendix,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver,
		ORGAN_SLOT_KIDNEYS = /obj/item/organ/kidneys,
	)

/datum/species/vampire/check_roundstart_eligible()
	if(SSevents.holidays && SSevents.holidays[HALLOWEEN])
		return TRUE
	return ..()

/datum/species/vampire/on_species_gain(mob/living/carbon/human/new_vampire, datum/species/old_species)
	. = ..()
	to_chat(new_vampire, "[info_text]")
	new_vampire.skin_tone = "albino"
	new_vampire.update_body(0)
	new_vampire.set_safe_hunger_level()
	RegisterSignal(new_vampire, COMSIG_MOB_APPLY_DAMAGE_MODIFIERS, PROC_REF(damage_weakness))

/datum/species/vampire/on_species_loss(mob/living/carbon/human/C, datum/species/new_species, pref_load)
	. = ..()
	UnregisterSignal(C, COMSIG_MOB_APPLY_DAMAGE_MODIFIERS)

/datum/species/vampire/spec_life(mob/living/carbon/human/vampire, delta_time, times_fired)
	. = ..()
	if(istype(vampire.loc, /obj/structure/closet/crate/coffin))
		vampire.heal_overall_damage(2 * delta_time, 2 * delta_time, BODYTYPE_ORGANIC)
		vampire.adjustToxLoss(-2 * delta_time)
		vampire.adjustOxyLoss(-2 * delta_time)
		vampire.adjustCloneLoss(-2 * delta_time)
		return
	vampire.blood_volume -= 0.125 * delta_time
	if(vampire.blood_volume <= BLOOD_VOLUME_SURVIVE)
		to_chat(vampire, span_danger("You ran out of blood!"))
		var/obj/shapeshift_holder/holder = locate() in vampire
		if(holder)
			holder.shape.dust() //vampires do not have batform anymore, but this would still lead to very weird stuff with other shapeshift holders
		vampire.dust()
	var/area/A = get_area(vampire)
	if(istype(A, /area/station/service/chapel))
		to_chat(vampire, span_warning("You don't belong here!"))
		vampire.adjustFireLoss(10 * delta_time)
		vampire.adjust_fire_stacks(3 * delta_time)
		vampire.ignite_mob()

/datum/species/vampire/proc/damage_weakness(datum/source, list/damage_mods, damage_amount, damagetype, def_zone, sharpness, attack_direction, obj/item/attacking_item)
	SIGNAL_HANDLER

	if(istype(attacking_item, /obj/item/nullrod/whip))
		damage_mods += 2

/datum/species/vampire/get_random_blood_type()
	return /datum/blood/universal

// Vampire blood is special, so it needs to be handled with its own entry.
/datum/species/vampire/create_pref_blood_perks()
	var/list/to_add = list()

	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
		SPECIES_PERK_ICON = "tint",
		SPECIES_PERK_NAME = "The Thirst",
		SPECIES_PERK_DESC = "In place of eating, Vampires suffer from The Thirst. \
			Thirst of what? Blood! Their tongue allows them to grab people and drink \
			their blood, and they will die if they run out. As a note, it doesn't \
			matter whose blood you drink, it will all be converted into your blood \
			type when consumed.",
	))

	return to_add

// There isn't a "Minor Undead" biotype, so we have to explain it in an override (see: dullahans)
/datum/species/vampire/create_pref_biotypes_perks()
	var/list/to_add = list()

	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
		SPECIES_PERK_ICON = "skull",
		SPECIES_PERK_NAME = "Minor Undead",
		SPECIES_PERK_DESC = "[name] are minor undead. \
			Minor undead enjoy some of the perks of being dead, like \
			not needing to breathe or eat, but do not get many of the \
			environmental immunities involved with being fully undead.",
	))

	return to_add

/obj/item/organ/tongue/vampire
	name = "vampire tongue"
	actions_types = list(/datum/action/item_action/organ_action/vampire)
	color = "#1C1C1C"
	COOLDOWN_DECLARE(drain_cooldown)

/datum/action/item_action/organ_action/vampire
	name = "Drain Victim"
	desc = "Leech blood from any carbon victim you are passively grabbing."

/datum/action/item_action/organ_action/vampire/Trigger(trigger_flags)
	. = ..()
	if(iscarbon(owner))
		var/mob/living/carbon/H = owner
		var/obj/item/organ/tongue/vampire/V = target
		if(!COOLDOWN_FINISHED(V, drain_cooldown))
			to_chat(H, span_warning("You just drained blood, wait a few seconds!"))
			return
		var/obj/item/hand_item/grab/G = H.get_active_grab()
		if(!iscarbon(G?.affecting))
			return

		var/mob/living/carbon/victim = G.affecting
		if(H.blood_volume >= BLOOD_VOLUME_MAXIMUM)
			to_chat(H, span_warning("You're already full!"))
			return

		if(victim.stat == DEAD)
			to_chat(H, span_warning("You need a living victim!"))
			return

		if(!victim.blood_volume || (victim.dna && ((NOBLOOD in victim.dna.species.species_traits) || victim.dna.species.exotic_blood)))
			to_chat(H, span_warning("[victim] doesn't have blood!"))
			return

		COOLDOWN_START(V, drain_cooldown, 3 SECONDS)
		if(victim.can_block_magic(MAGIC_RESISTANCE_HOLY, charge_cost = 0))
			victim.show_message(span_warning("[H] tries to bite you, but stops before touching you!"))
			to_chat(H, span_warning("[victim] is blessed! You stop just in time to avoid catching fire."))
			return

		if(victim.has_reagent(/datum/reagent/consumable/garlic))
			victim.show_message(span_warning("[H] tries to bite you, but recoils in disgust!"))
			to_chat(H, span_warning("[victim] reeks of garlic! you can't bring yourself to drain such tainted blood."))
			return

		if(!do_after(H, victim, 3 SECONDS))
			return

		var/blood_volume_difference = BLOOD_VOLUME_MAXIMUM - H.blood_volume //How much capacity we have left to absorb blood
		var/drained_blood = min(victim.blood_volume, VAMP_DRAIN_AMOUNT, blood_volume_difference)

		victim.show_message(span_danger("[H] is draining your blood!"))
		to_chat(H, span_notice("You drain some blood!"))
		playsound(H, 'sound/items/drink.ogg', 30, TRUE, -2)

		victim.adjustBloodVolume(-drained_blood)
		H.adjustBloodVolumeUpTo(drained_blood, BLOOD_VOLUME_MAXIMUM)
		if(!victim.blood_volume)
			to_chat(H, span_notice("You finish off [victim]'s blood supply."))

/obj/item/organ/heart/vampire
	name = "vampire heart"
	color = "#1C1C1C"

#undef VAMPIRES_PER_HOUSE
#undef VAMP_DRAIN_AMOUNT
