//The contant in the rate of reagent transfer on life ticks
#define STOMACH_METABOLISM_CONSTANT 0.25

/obj/item/organ/stomach
	name = "stomach"
	icon_state = "stomach"
	visual = FALSE
	w_class = WEIGHT_CLASS_SMALL
	zone = BODY_ZONE_CHEST
	slot = ORGAN_SLOT_STOMACH
	attack_verb_continuous = list("gores", "squishes", "slaps", "digests")
	attack_verb_simple = list("gore", "squish", "slap", "digest")
	desc = "Onaka ga suite imasu."

	decay_factor = STANDARD_ORGAN_DECAY * 1.15 // ~13 minutes, the stomach is one of the first organs to die

	low_threshold_passed = "<span class='info'>Your stomach flashes with pain before subsiding. Food doesn't seem like a good idea right now.</span>"
	high_threshold_passed = "<span class='warning'>Your stomach flares up with constant pain- you can hardly stomach the idea of food right now!</span>"
	high_threshold_cleared = "<span class='info'>The pain in your stomach dies down for now, but food still seems unappealing.</span>"
	low_threshold_cleared = "<span class='info'>The last bouts of pain in your stomach have died out.</span>"

	food_reagents = list(/datum/reagent/consumable/nutriment/organ_tissue = 5)
	//This is a reagent user and needs more then the 10u from edible component
	reagent_vol = 1000

	///The rate that disgust decays
	var/disgust_metabolism = 1

/obj/item/organ/stomach/Initialize(mapload)
	. = ..()
	//None edible organs do not get a reagent holder by default
	if(!reagents)
		create_reagents(reagent_vol)

/obj/item/organ/create_reagents(max_vol, flags)
	. = ..()
	reagents.metabolism_class = CHEM_INGEST

/obj/item/organ/stomach/Insert(mob/living/carbon/reciever, special, drop_if_replaced)
	. = ..()
	if(!.)
		return

	reagents.my_atom = reciever

/obj/item/organ/stomach/Remove(mob/living/carbon/stomach_owner, special)
	reagents.my_atom = src
	reagents.end_metabolization(stomach_owner)
	if(ishuman(stomach_owner))
		var/mob/living/carbon/human/human_owner = owner
		human_owner.clear_alert(ALERT_DISGUST)
		human_owner.clear_alert(ALERT_NUTRITION)
	return ..()

/obj/item/organ/stomach/set_organ_dead(failing, cause_of_death)
	. = ..()
	if(!.)
		return

	if((organ_flags & ORGAN_DEAD) && owner)
		reagents.end_metabolization(owner)

/obj/item/organ/stomach/on_life(delta_time, times_fired)
	. = ..()

	//Manage species digestion
	if(istype(owner, /mob/living/carbon/human))
		var/mob/living/carbon/human/humi = owner
		if(!(organ_flags & ORGAN_DEAD))
			handle_hunger(humi, delta_time, times_fired)

	var/mob/living/carbon/body = owner

	//Handle disgust
	if(body)
		handle_disgust(body, delta_time, times_fired)

	//If the stomach is not damage exit out
	if(damage < low_threshold)
		return

	//We are checking if we have nutriment in a damaged stomach.
	var/datum/reagent/nutri = locate(/datum/reagent/consumable/nutriment) in reagents.reagent_list
	//No nutriment found lets exit out
	if(!nutri)
		return

	// remove the food reagent amount
	var/nutri_vol = nutri.volume
	var/amount_food = food_reagents[nutri.type]
	if(amount_food)
		nutri_vol = max(nutri_vol - amount_food, 0)

	// found nutriment was stomach food reagent
	if(!(nutri_vol > 0))
		return

	//The stomach is damage has nutriment but low on theshhold, lo prob of vomit
	if(DT_PROB(0.0125 * damage * nutri_vol * nutri_vol, delta_time))
		body.vomit(damage)
		to_chat(body, span_warning("Your stomach reels in pain as you're incapable of holding down all that food!"))
		return

	// the change of vomit is now high
	if(damage > (high_threshold * maxHealth) && DT_PROB(0.05 * damage * nutri_vol * nutri_vol, delta_time))
		body.vomit(damage)
		to_chat(body, span_warning("Your stomach reels in pain as you're incapable of holding down all that food!"))

/obj/item/organ/stomach/proc/handle_hunger(mob/living/carbon/human/human, delta_time, times_fired)
	if(HAS_TRAIT(human, TRAIT_NOHUNGER))
		return //hunger is for BABIES

	//The fucking TRAIT_FAT mutation is the dumbest shit ever. It makes the code so difficult to work with
	if(HAS_TRAIT_FROM(human, TRAIT_FAT, OBESITY))//I share your pain, past coder.
		if(human.overeatduration < (200 SECONDS))
			to_chat(human, span_notice("You feel fit again!"))
			REMOVE_TRAIT(human, TRAIT_FAT, OBESITY)
			human.remove_movespeed_modifier(/datum/movespeed_modifier/obesity)
			human.update_worn_undersuit()
			human.update_worn_oversuit()
	else
		if(human.overeatduration >= (200 SECONDS))
			to_chat(human, span_danger("You suddenly feel blubbery!"))
			ADD_TRAIT(human, TRAIT_FAT, OBESITY)
			human.add_movespeed_modifier(/datum/movespeed_modifier/obesity)
			human.update_worn_undersuit()
			human.update_worn_oversuit()

	// nutrition decrease and satiety
	if (human.nutrition > 0 && human.stat != DEAD)
		// THEY HUNGER
		var/hunger_rate = HUNGER_DECAY
		// Whether we cap off our satiety or move it towards 0
		if(human.satiety > MAX_SATIETY)
			human.satiety = MAX_SATIETY
		else if(human.satiety > 0)
			human.satiety = max(human.satiety - (SATIETY_DECAY * delta_time), 0)
		else if(human.satiety < -MAX_SATIETY)
			human.satiety = -MAX_SATIETY
		else if(human.satiety < 0)
			human.satiety = min(human.satiety + (SATIETY_DECAY * delta_time), 0)
			if(DT_PROB(round(-human.satiety/77), delta_time))
				human.set_timed_status_effect(10 SECONDS, /datum/status_effect/jitter, only_if_higher = TRUE)
			hunger_rate = 3 * HUNGER_DECAY
		hunger_rate *= human.physiology.hunger_mod
		human.adjust_nutrition(-hunger_rate * delta_time)

	var/nutrition = human.nutrition
	if(nutrition > NUTRITION_LEVEL_FULL)
		if(human.overeatduration < 20 MINUTES) //capped so people don't take forever to unfat
			human.overeatduration = min(human.overeatduration + (1 SECONDS * delta_time), 20 MINUTES)
	else
		if(human.overeatduration > 0)
			human.overeatduration = max(human.overeatduration - (2 SECONDS * delta_time), 0) //doubled the unfat rate

	//metabolism change
	if(nutrition > NUTRITION_LEVEL_FAT)
		human.metabolism_efficiency = 1
	else if(nutrition > NUTRITION_LEVEL_FED && human.satiety > 80)
		if(human.metabolism_efficiency != 1.25)
			to_chat(human, span_notice("You feel vigorous."))
			human.metabolism_efficiency = 1.25
	else if(nutrition < NUTRITION_LEVEL_STARVING + 50)
		if(human.metabolism_efficiency != 0.8)
			to_chat(human, span_notice("You feel sluggish."))
		human.metabolism_efficiency = 0.8
	else
		if(human.metabolism_efficiency == 1.25)
			to_chat(human, span_notice("You no longer feel vigorous."))
		human.metabolism_efficiency = 1

	handle_hunger_slowdown(human)

	// If we did anything more then just set and throw alerts here I would add bracketing
	// But well, it is all we do, so there's not much point bothering with it you get me?
	switch(nutrition)
		if(NUTRITION_LEVEL_FULL to INFINITY)
			human.throw_alert(ALERT_NUTRITION, /atom/movable/screen/alert/fat)
		if(NUTRITION_LEVEL_HUNGRY to NUTRITION_LEVEL_FULL)
			human.clear_alert(ALERT_NUTRITION)
		if(NUTRITION_LEVEL_STARVING to NUTRITION_LEVEL_HUNGRY)
			human.throw_alert(ALERT_NUTRITION, /atom/movable/screen/alert/hungry)
		if(0 to NUTRITION_LEVEL_STARVING)
			human.throw_alert(ALERT_NUTRITION, /atom/movable/screen/alert/starving)

///for when mood is disabled and hunger should handle slowdowns
/obj/item/organ/stomach/proc/handle_hunger_slowdown(mob/living/carbon/human/human)
	var/hungry = (500 - human.nutrition) / 5 //So overeat would be 100 and default level would be 80
	if(hungry >= 70)
		human.add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/hunger, slowdown = (hungry / 50))
	else
		human.remove_movespeed_modifier(/datum/movespeed_modifier/hunger)

/obj/item/organ/stomach/proc/handle_disgust(mob/living/carbon/human/disgusted, delta_time, times_fired)
	var/old_disgust = disgusted.old_disgust
	var/disgust = disgusted.disgust

	if(disgust)
		var/pukeprob = 2.5 + (0.025 * disgust)
		if(disgust >= DISGUST_LEVEL_GROSS)
			if(DT_PROB(5, delta_time))
				disgusted.adjust_timed_status_effect(2 SECONDS, /datum/status_effect/speech/stutter)
				disgusted.adjust_timed_status_effect(2 SECONDS, /datum/status_effect/confusion)
			if(DT_PROB(5, delta_time) && !disgusted.stat)
				to_chat(disgusted, span_warning("You feel kind of iffy..."))
			disgusted.adjust_timed_status_effect(-6 SECONDS, /datum/status_effect/jitter)
		if(disgust >= DISGUST_LEVEL_VERYGROSS)
			if(DT_PROB(pukeprob, delta_time)) //iT hAndLeS mOrE ThaN PukInG
				disgusted.adjust_timed_status_effect(2.5 SECONDS, /datum/status_effect/confusion)
				disgusted.adjust_timed_status_effect(2 SECONDS, /datum/status_effect/speech/stutter)
				disgusted.vomit(10, distance = 0, vomit_type = NONE)
			disgusted.set_timed_status_effect(10 SECONDS, /datum/status_effect/dizziness, only_if_higher = TRUE)
		if(disgust >= DISGUST_LEVEL_DISGUSTED)
			if(DT_PROB(13, delta_time))
				disgusted.blur_eyes(3) //We need to add more shit down here

		disgusted.adjust_disgust(-0.25 * disgust_metabolism * delta_time)

	// I would consider breaking this up into steps matching the disgust levels
	// But disgust is used so rarely it wouldn't save a significant amount of time, and it makes the code just way worse
	// We're in the same state as the last time we processed, so don't bother
	if(old_disgust == disgust)
		return

	disgusted.old_disgust = disgust
	switch(disgust)
		if(0 to DISGUST_LEVEL_GROSS)
			disgusted.clear_alert(ALERT_DISGUST)
		if(DISGUST_LEVEL_GROSS to DISGUST_LEVEL_VERYGROSS)
			disgusted.throw_alert(ALERT_DISGUST, /atom/movable/screen/alert/gross)
		if(DISGUST_LEVEL_VERYGROSS to DISGUST_LEVEL_DISGUSTED)
			disgusted.throw_alert(ALERT_DISGUST, /atom/movable/screen/alert/verygross)
		if(DISGUST_LEVEL_DISGUSTED to INFINITY)
			disgusted.throw_alert(ALERT_DISGUST, /atom/movable/screen/alert/disgusted)

/obj/item/organ/stomach/bone
	desc = "You have no idea what this strange ball of bones does."
	/// How much [BRUTE] damage milk heals every second
	var/milk_brute_healing = 2.5
	/// How much [BURN] damage milk heals every second
	var/milk_burn_healing = 2.5

/obj/item/organ/stomach/bone/on_life(delta_time, times_fired)
	var/datum/reagent/consumable/milk/milk = locate(/datum/reagent/consumable/milk) in reagents.reagent_list
	if(milk)
		var/mob/living/carbon/body = owner
		if(milk.volume > 50)
			reagents.remove_reagent(milk.type, milk.volume - 5)
			to_chat(owner, span_warning("The excess milk is dripping off your bones!"))
		body.heal_bodypart_damage(milk_brute_healing * milk.metabolization_rate, milk_burn_healing * milk.metabolization_rate)
		if(prob(10))
			for(var/obj/item/bodypart/BP as anything in body.bodyparts)
				BP.heal_bones()
		reagents.remove_reagent(milk.type, milk.metabolization_rate * delta_time)
	return ..()

/obj/item/organ/stomach/cybernetic
	name = "basic cybernetic stomach"
	icon_state = "stomach-c"
	desc = "A basic device designed to mimic the functions of a human stomach"
	organ_flags = ORGAN_SYNTHETIC
	var/emp_vulnerability = 80 //Chance of permanent effects if emp-ed.

/obj/item/organ/stomach/cybernetic/tier2
	name = "cybernetic stomach"
	icon_state = "stomach-c-u"
	desc = "An electronic device designed to mimic the functions of a human stomach. Handles disgusting food a bit better."
	maxHealth = 45
	disgust_metabolism = 2
	emp_vulnerability = 40

/obj/item/organ/stomach/cybernetic/tier3
	name = "upgraded cybernetic stomach"
	icon_state = "stomach-c-u2"
	desc = "An upgraded version of the cybernetic stomach, designed to improve further upon organic stomachs. Handles disgusting food very well."
	maxHealth = 60
	disgust_metabolism = 3
	emp_vulnerability = 20

/obj/item/organ/stomach/cybernetic/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	if(!COOLDOWN_FINISHED(src, severe_cooldown)) //So we cant just spam emp to kill people.
		owner.vomit(stun = FALSE)
		COOLDOWN_START(src, severe_cooldown, 10 SECONDS)
	if(prob(emp_vulnerability/severity)) //Chance of permanent effects
		organ_flags |= ORGAN_SYNTHETIC_EMP //Starts organ faliure - gonna need replacing soon.


#undef STOMACH_METABOLISM_CONSTANT
