/datum/vampire_state/bloodlust
	name = "Bloodlust!"
	regress_into_message = span_statsgood("The Thirst is too much, you must feed! More! More!")

	var/list/arm_weakrefs = list()

// Bloodlust is only active at this stage
/datum/vampire_state/bloodlust/can_be_active()
	return parent.thirst_stage == THIRST_STAGE_BLOODLUST

/datum/vampire_state/bloodlust/enter_state(mob/living/carbon/human/host)
	. = ..()
	host.add_movespeed_modifier(/datum/movespeed_modifier/vampire_bloodlust)
	host.mob_mood.add_mood_event(VAMPIRE_TRAIT, /datum/mood_event/vampire_bloodlust)
	host.stats.set_skill_modifier(2, /datum/rpg_skill/skirmish, VAMPIRE_TRAIT)
	host.AddComponentFrom(VAMPIRE_TRAIT, /datum/component/cult_eyes, initial_delay = 0 SECONDS)
	host.add_client_colour(/datum/client_colour/bloodlust)
	host.overlay_fullscreen("bloodlust", /atom/movable/screen/fullscreen/curse/bloodlust, 1)
	ADD_TRAIT(host, TRAIT_STRONG_GRABBER, VAMPIRE_TRAIT)

	for(var/obj/item/bodypart/arm/arm in host.bodyparts)
		arm_weakrefs += WEAKREF(arm)
		arm.unarmed_damage_low = 7
		arm.unarmed_damage_high = 14
		arm.unarmed_attack_verb = "slash"
		arm.unarmed_attack_effect = ATTACK_EFFECT_CLAW
		arm.unarmed_attack_sound = 'sound/weapons/slice.ogg'
		arm.unarmed_miss_sound = 'sound/weapons/slashmiss.ogg'


/datum/vampire_state/bloodlust/exit_state(mob/living/carbon/human/host)
	. = ..()
	host.mob_mood.clear_mood_event(VAMPIRE_TRAIT)
	host.stats.remove_skill_modifier(/datum/rpg_skill/skirmish, VAMPIRE_TRAIT)
	host.remove_movespeed_modifier(/datum/movespeed_modifier/vampire_bloodlust)
	host.RemoveComponentFrom(VAMPIRE_TRAIT, /datum/component/cult_eyes)
	host.remove_client_colour(/datum/client_colour/bloodlust)
	host.clear_fullscreen("bloodlust")
	REMOVE_TRAIT(host, TRAIT_STRONG_GRABBER, VAMPIRE_TRAIT)

	for(var/datum/weakref/W in arm_weakrefs)
		var/obj/item/bodypart/arm/arm = W.resolve()
		if(!W)
			continue

		arm.unarmed_damage_low = initial(arm.unarmed_damage_low)
		arm.unarmed_damage_high = initial(arm.unarmed_damage_high)
		arm.unarmed_attack_verb = initial(arm.unarmed_attack_verb)
		arm.unarmed_attack_effect = initial(arm.unarmed_attack_effect)
		arm.unarmed_attack_sound = initial(arm.unarmed_attack_sound)
		arm.unarmed_miss_sound = initial(arm.unarmed_miss_sound)

	arm_weakrefs.Cut()

/datum/vampire_state/bloodlust/tick(delta_time, mob/living/carbon/human/host)
	. = ..()

	if(host.stat != CONSCIOUS)
		return

	if(host.blood_volume >= BLOOD_VOLUME_NORMAL && DT_PROB(3.3, delta_time))
		host.bleed(1)
		host.visible_message(span_subtle("A drop of blood falls from <b>[host]</b>'s fangs."))

	for(var/obj/item/organ/O as anything in shuffle(host.processing_organs))
		if(!O.damage)
			continue

		if(O.organ_flags & (ORGAN_DEAD | ORGAN_CUT_AWAY | ORGAN_SYNTHETIC))
			continue

		O.applyOrganDamage(-2 * delta_time, silent = TRUE, updating_health = FALSE)
		break

	host.heal_overall_damage(2 * delta_time, 2 * delta_time)

	// I'd rather this be too strong than too weak, ideally a blood-crazed vampire is an extremely dangerous force.
	host.AdjustAllImmobility(-3 SECONDS * delta_time)
