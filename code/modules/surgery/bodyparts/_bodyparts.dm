/obj/item/bodypart
	name = "limb"
	desc = "Why is it detached..."

	germ_level = 0

	force = 6
	throwforce = 3
	stamina_damage = 40
	stamina_cost = 23
	stamina_critical_chance = 5

	w_class = WEIGHT_CLASS_SMALL
	icon = 'icons/mob/human_parts.dmi'
	icon_state = "" //Leave this blank! Bodyparts are built using overlays
	layer = BELOW_MOB_LAYER //so it isn't hidden behind objects when on the floor

	VAR_PRIVATE/icon/current_icon = null
	VAR_PRIVATE/icon/current_aux_icon = null

	/// The icon for Organic limbs using greyscale
	VAR_PROTECTED/icon_greyscale = DEFAULT_BODYPART_ICON_ORGANIC
	///The icon for non-greyscale limbs
	VAR_PROTECTED/icon_static = 'icons/mob/human_parts.dmi'
	///The icon for husked limbs
	VAR_PROTECTED/icon_husk = 'icons/mob/human_parts.dmi'
	///The type of husk for building an iconstate
	var/husk_type = "humanoid"
	///The file to pull damage overlays from. Null is valid.
	var/icon_dmg_overlay = 'icons/mob/species/human/damage.dmi'
	/// The file to pull bloody clothing overlays from. Null is valid.
	var/icon_bloodycover = 'icons/effects/blood.dmi'

	grind_results = list(/datum/reagent/bone_dust = 10, /datum/reagent/liquidgibs = 5) // robotic bodyparts and chests/heads cannot be ground

	/// The mob that "owns" this limb
	/// DO NOT MODIFY DIRECTLY. Use set_owner()
	var/mob/living/carbon/owner

	///A bitfield of bodytypes for clothing, surgery, and misc information
	var/bodytype = BODYTYPE_HUMANOID | BODYTYPE_ORGANIC
	///Defines when a bodypart should not be changed. Example: BP_BLOCK_CHANGE_SPECIES prevents the limb from being overwritten on species gain
	var/change_exempt_flags

	var/is_husked = FALSE
	///The ID of a species used to generate the icon. Needs to match the icon_state portion in the limbs file!
	var/limb_id = SPECIES_HUMAN
	//Defines what sprite the limb should use if it is also sexually dimorphic.
	VAR_PROTECTED/limb_gender = "m"
	///Which mutcolor to use, if mutcolors are used
	var/mutcolor_used = MUTCOLORS_GENERIC_1
	///Is there a sprite difference between male and female?
	var/is_dimorphic = FALSE
	///The actual color a limb is drawn as, set by /proc/update_limb()
	var/draw_color //NEVER. EVER. EDIT THIS VALUE OUTSIDE OF UPDATE_LIMB. I WILL FIND YOU. It ruins the limb icon pipeline.
	///We always copy the list of mutcolors our owner has incase our organs want it
	var/list/mutcolors

	/// BODY_ZONE_CHEST, BODY_ZONE_L_ARM, etc , used for def_zone
	var/body_zone
	/// The body zone of this part in english ("chest", "left arm", etc) without the species attached to it
	var/plaintext_zone
	var/aux_zone // used for hands
	var/aux_layer
	/// bitflag used to check which clothes cover this bodypart
	var/body_part
	/// are we a hand? if so, which one!
	var/held_index = 0
	/// For limbs that don't really exist, eg chainsaws
	var/is_pseudopart = FALSE

	///If disabled, limb is as good as missing.
	var/bodypart_disabled = FALSE
	///Multiplied by max_damage it returns the threshold which defines a limb being disabled or not. From 0 to 1. 0 means no disable thru damage
	var/disable_threshold = 0
	///Controls whether bodypart_disabled makes sense or not for this limb.
	var/can_be_disabled = FALSE
	/// The interaction speed modifier when this limb is used to interact with the world. ONLY WORKS FOR ARMS
	var/interaction_speed_modifier = 1

	var/brutestate = 0
	var/burnstate = 0

	///The current amount of brute damage the limb has
	var/brute_dam = 0
	///The current amount of burn damage the limb has
	var/burn_dam = 0
	///The maximum "physical" damage a bodypart can take. Set by children
	var/max_damage = 0
	///The current "physical" damage a bodypart has taken
	var/current_damage = 0
	///The % of current_damage that is brute
	var/brute_ratio = 0
	///The % of current_damage that is burn
	var/burn_ratio = 0
	/// How much pain this limb is applying.
	VAR_PRIVATE/pain = 0
	///The minimum damage a part must have before it's bones may break. Defaults to max_damage * BODYPART_MINIMUM_BREAK_MOD
	var/minimum_break_damage = 0
	/// Bleed multiplier
	var/arterial_bleed_severity = 1

	/// Needs to be opened with a saw to access the organs. For robotic bodyparts, you can open the "hatch"
	var/encased
	/// Is a stump. This is handled at runtime, do not touch.
	var/is_stump
	/// Does this limb have a cavity?
	var/cavity
	/// The name of the cavity of the limb
	var/cavity_name
	/// The type of storage datum to use for cavity storage.
	var/cavity_storage_max_weight = WEIGHT_CLASS_SMALL
	/// For robotic limbs: Hatch states, used by "surgery"
	var/hatch_state

	/// List of obj/item's embedded inside us. Managed by embedded components, do not modify directly
	var/list/embedded_objects = list()
	/// List of obj/items stuck TO us. Managed by embedded components, do not directly modify
	var/list/stuck_objects = list()
	/// The items stored in our cavity
	var/list/cavity_items = list()

	///Bodypart flags, keeps track of blood, bones, arteries, tendons, and the like.
	var/bodypart_flags = NONE
	/// The name of the artery this limb has
	var/artery_name = "artery"
	/// The name of the tendon this limb has
	var/tendon_name = "tendon"
	/// The name of the joint you can dislocate
	var/joint_name = "joint"
	/// The name for the amputation point of the limb
	var/amputation_point
	/// Surgical stage. Magic BS. Do not touch
	var/stage = 0

	///Gradually increases while burning when at full damage, destroys the limb when at 100
	var/cremation_progress = 0
	///Subtracted to brute damage taken
	var/brute_reduction = 0
	///Subtracted to burn damage taken
	var/burn_reduction = 0

	//Coloring and proper item icon update
	var/skin_tone = ""
	var/species_color = ""
	///Limbs need this information as a back-up incase they are generated outside of a carbon (limbgrower)
	var/should_draw_greyscale = TRUE
	///An "override" color that can be applied to ANY limb, greyscale or not.
	var/variable_color = ""

	///whether it can be dismembered with a weapon.
	var/dismemberable = 1

	var/px_x = 0
	var/px_y = 0

	var/species_flags_list = list()
	/// If we're bleeding, which icon are we displaying on this part
	var/bleed_overlay_icon

	//Damage messages used by help_shake_act()
	var/light_brute_msg = "bruised"
	var/medium_brute_msg = "battered"
	var/heavy_brute_msg = "mangled"

	var/light_burn_msg = "numb"
	var/medium_burn_msg = "blistered"
	var/heavy_burn_msg = "peeling away"

	///The description used when the bones are broken.
	var/broken_description

	/// The wounds currently afflicting this body part
	var/list/wounds

	/// NOT wounds.len! Multiple wounds of the same type compress onto the same wound datum.
	var/real_wound_count = 0

	/// Our current stored wound damage multiplier
	var/wound_damage_multiplier = 1

	/// This number is subtracted from all wound rolls on this bodypart, higher numbers mean more defense, negative means easier to wound
	var/wound_resistance = 0
	/// When this bodypart hits max damage, this number is added to all wound rolls. Obviously only relevant for bodyparts that have damage caps.
	var/disabled_wound_penalty = 15

	/// So we know if we need to scream if this limb hits max damage
	var/last_maxed
	/// Our current bleed rate. Cached, update with refresh_bleed_rate()
	var/cached_bleed_rate = 0
	/// How much generic bleedstacks we have on this bodypart
	var/generic_bleedstacks

	/// If something is currently supporting this limb as a splint
	var/obj/item/splint
	/// The bandage that may-or-may-not be absorbing our blood
	var/obj/item/stack/bandage

	///A list of all the organs inside of us.
	var/list/obj/item/organ/contained_organs = list()

	/// Type of an attack from this limb does. Arms will do punches, Legs for kicks, and head for bites. (TO ADD: tactical chestbumps)
	var/attack_type = BRUTE
	/// the verb used for an unarmed attack when using this limb, such as arm.unarmed_attack_verb = punch
	var/unarmed_attack_verb = "bump"
	/// what visual effect is used when this limb is used to strike someone.
	var/unarmed_attack_effect = ATTACK_EFFECT_PUNCH
	/// Sounds when this bodypart is used in an umarmed attack
	var/sound/unarmed_attack_sound = SFX_PUNCH
	var/sound/unarmed_miss_sound = 'sound/weapons/punchmiss.ogg'
	///Lowest possible punch damage this bodypart can give. If this is set to 0, unarmed attacks will always miss.
	var/unarmed_damage_low = 1
	///Highest possible punch damage this bodypart can ive.
	var/unarmed_damage_high = 1
	///Damage at which attacks from this bodypart will stun
	var/unarmed_stun_threshold = 2

	/// Traits that are given to the holder of the part. If you want an effect that changes this, don't add directly to this. Use the add_bodypart_trait() proc
	var/list/bodypart_traits = list()
	/// The name of the trait source that the organ gives. Should not be altered during the events of gameplay, and will cause problems if it is.
	var/bodypart_trait_source = BODYPART_TRAIT

	///A lazylist of this bodypart's appearance_modifier datums.
	var/list/appearance_mods

/obj/item/bodypart/Initialize(mapload)
	. = ..()

	if(can_be_disabled)
		RegisterSignal(src, SIGNAL_ADDTRAIT(TRAIT_PARALYSIS), PROC_REF(on_paralysis_trait_gain))
		RegisterSignal(src, SIGNAL_REMOVETRAIT(TRAIT_PARALYSIS), PROC_REF(on_paralysis_trait_loss))
	if(!IS_ORGANIC_LIMB(src))
		grind_results = null

	name = "[limb_id] [parse_zone(body_zone)]"
	update_icon_dropped()
	refresh_bleed_rate()

/obj/item/bodypart/Destroy()
	for(var/wound in wounds)
		qdel(wound) // wounds is a lazylist, and each wound removes itself from it on deletion.
	if(length(wounds))
		stack_trace("[type] qdeleted with [length(wounds)] uncleared wounds")
		wounds.Cut()

	QDEL_LIST(contained_organs)
	QDEL_LIST(cavity_items)
	if(owner)
		drop_limb(TRUE)

	QDEL_NULL(splint)
	QDEL_NULL(bandage)
	return ..()

/obj/item/bodypart/forceMove(atom/destination) //Please. Never forcemove a limb if its's actually in use. This is only for borgs.
	SHOULD_CALL_PARENT(TRUE)
	. = ..()

	if(isturf(destination))
		update_icon_dropped()

/obj/item/bodypart/Moved(atom/old_loc, movement_dir, forced, list/old_locs, momentum_change)
	. = ..()
	if(owner && loc != owner)
		drop_limb(FALSE, TRUE)
		stack_trace("Bodypart moved while it still had an owner")

/obj/item/bodypart/examine(mob/user)
	SHOULD_CALL_PARENT(TRUE)
	. = ..()
	. += mob_examine()

/obj/item/bodypart/proc/mob_examine(hallucinating, covered, just_wounds_please)
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

	if(hallucinating == SCREWYHUD_HEALTHY)
		return

	if(hallucinating == SCREWYHUD_CRIT)
		var/list/flavor_text = list("a")
		flavor_text += pick(" pair of ", " ton of ", " several ")
		flavor_text += pick("large cuts", "severe burns")
		. += "[owner.p_they(TRUE)] [owner.p_have()] [english_list(flavor_text)] on [owner.p_their()] [plaintext_zone]."
		return

	var/list/flavor_text = list()
	if((bodypart_flags & BP_CUT_AWAY) && !is_stump)
		flavor_text += "a tear at the [amputation_point] so severe that it hangs by a scrap of flesh"

	if(!IS_ORGANIC_LIMB(src))
		if(brute_dam)
			switch(brute_dam)
				if(0 to 20)
					flavor_text += "some dents"
				if(21 to INFINITY)
					flavor_text += pick("a lot of dents","severe denting")
		if(burn_dam)
			switch(burn_dam)
				if(0 to 20)
					flavor_text += "some burns"
				if(21 to INFINITY)
					flavor_text += pick("a lot of burns","severe melting")
	else
		var/list/wound_descriptors = list()
		for(var/datum/wound/W as anything in wounds)
			var/descriptor = W.get_examine_desc()
			if(descriptor)
				wound_descriptors[descriptor] += W.amount

		if(how_open() >= SURGERY_RETRACTED)
			var/bone = encased ? encased : "bone"
			if(bodypart_flags & BP_BROKEN_BONES)
				bone = "broken [bone]"
			wound_descriptors["[bone] exposed"] = 1

			if(!encased || how_open() >= SURGERY_DEENCASED)
				var/list/bits = list()
				for(var/obj/item/organ/organ in contained_organs)
					if(organ.cosmetic_only)
						continue
					bits += organ.get_visible_state()

				for(var/obj/item/implant in cavity_items)
					bits += implant.name
				if(length(bits))
					wound_descriptors["[english_list(bits)] visible in the wounds"] = 1

		for(var/wound in wound_descriptors)
			switch(wound_descriptors[wound])
				if(1)
					flavor_text += "a [wound]"
				if(2)
					flavor_text += "a pair of [wound]s"
				if(3 to 5)
					flavor_text += "several [wound]s"
				if(6 to INFINITY)
					flavor_text += "a ton of [wound]\s"

	if(just_wounds_please)
		return english_list(flavor_text)

	if(owner)
		if(current_damage)
			. += "[owner.p_they(TRUE)] [owner.p_have()] [english_list(flavor_text)] on [owner.p_their()] [plaintext_zone]."

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
		if(current_damage)
			. += "It has [english_list(flavor_text)]."
		if(bodypart_flags & BP_BROKEN_BONES)
			. += span_warning("It is dented and swollen.")
		return

/obj/item/bodypart/blob_act()
	receive_damage(max_damage)

/obj/item/bodypart/ex_act(severity, target)
	if(owner) // Do not explode if we are attached to a person.
		return
	return ..()

/obj/item/bodypart/attack(mob/living/carbon/victim, mob/user)
	SHOULD_CALL_PARENT(TRUE)

	if(!ishuman(victim) || !HAS_TRAIT(victim, TRAIT_LIMBATTACHMENT))
		return ..()

	var/mob/living/carbon/human/human_victim = victim
	if(human_victim.get_bodypart(body_zone))
		return ..()

	if(!user.temporarilyRemoveItemFromInventory(src))
		return ..()

	if(!attach_limb(victim))
		to_chat(user, span_warning("[human_victim]'s body rejects [src]!"))
		return

	if(human_victim == user)
		human_victim.visible_message(span_warning("[human_victim] jams [src] into [human_victim.p_their()] empty socket!"),\
		span_notice("You force [src] into your empty socket, and it locks into place!"))
	else
		human_victim.visible_message(span_warning("[user] jams [src] into [human_victim]'s empty socket!"),\
		span_notice("[user] forces [src] into your empty socket, and it locks into place!"))


/obj/item/bodypart/attackby(obj/item/weapon, mob/user, params)
	SHOULD_CALL_PARENT(TRUE)

	if(weapon.sharpness)
		weapon.leave_evidence(user, src)
		if(!contents.len)
			to_chat(user, span_warning("There is nothing left inside [src]!"))
			return
		playsound(loc, 'sound/weapons/slice.ogg', 50, TRUE, -1)
		user.visible_message(span_warning("[user] begins to cut open [src]."),\
			span_notice("You begin to cut open [src]..."))
		if(do_after(user, src, 54))
			drop_contents(user, TRUE)
	else
		return ..()

/obj/item/bodypart/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	SHOULD_CALL_PARENT(TRUE)

	..()
	if(IS_ORGANIC_LIMB(src))
		playsound(get_turf(src), 'sound/misc/splort.ogg', 50, TRUE, -1)
	pixel_x = rand(-3, 3)
	pixel_y = rand(-3, 3)

//Bodyparts should always be facing south
/obj/item/bodypart/setDir(newdir)
	. = ..()
	dir = SOUTH

//empties the bodypart from its organs and other things inside it
/obj/item/bodypart/proc/drop_contents(mob/user, violent_removal)
	SHOULD_CALL_PARENT(TRUE)

	var/turf/bodypart_turf = get_turf(src)
	if(IS_ORGANIC_LIMB(src))
		playsound(bodypart_turf, 'sound/misc/splort.ogg', 50, TRUE, -1)

	if(splint)
		remove_splint()
	if(bandage)
		remove_bandage()

	for(var/obj/item/I in cavity_items)
		remove_cavity_item(I)
		I.forceMove(bodypart_turf)

	for(var/obj/item/item_in_bodypart in src)
		if(isorgan(item_in_bodypart))
			var/obj/item/organ/O = item_in_bodypart
			if(O.organ_flags & ORGAN_UNREMOVABLE)
				continue
			else
				if(O.owner)
					O.Remove(O.owner)
				else
					remove_organ(O)

		item_in_bodypart.forceMove(bodypart_turf)
		if(!violent_removal)
			continue
		item_in_bodypart.throw_at(get_edge_target_turf(item_in_bodypart, pick(GLOB.alldirs)), rand(1,3), 5)


//Return TRUE to get whatever mob this is in to update health.
/obj/item/bodypart/proc/on_life(delta_time, times_fired, stam_heal)
	SHOULD_CALL_PARENT(TRUE)
	if(owner.stat != DEAD)
		pain = max(pain - (owner.body_position == LYING_DOWN ? 3 : 1), 0)
		. |= wound_life()
	. |= update_germs()

/obj/item/bodypart/proc/wound_life()
	if(!LAZYLEN(wounds))
		return

	if(!IS_ORGANIC_LIMB(src)) //Robotic limbs don't heal or get worse.
		for(var/datum/wound/W as anything in wounds) //Repaired wounds disappear though
			if(W.damage <= 0)  //and they disappear right away
				qdel(W)
		return

	for(var/datum/wound/W as anything in wounds)
		// wounds can disappear after 10 minutes at the earliest
		if(W.damage <= 0 && W.created + (10 MINUTES) <= world.time)
			qdel(W)
			continue
			// let the GC handle the deletion of the wound

		// slow healing
		var/heal_amt = 0
		// if damage >= 50 AFTER treatment then it's probably too severe to heal within the timeframe of a round.
		if ( W.can_autoheal() && W.wound_damage() && brute_ratio < 0.5 && burn_ratio < 0.5)
			heal_amt += 0.5

		//configurable regen speed woo, no-regen hardcore or instaheal hugbox, choose your destiny
		heal_amt = heal_amt * WOUND_REGENERATION_MODIFIER
		// amount of healing is spread over all the wounds
		heal_amt = heal_amt / (LAZYLEN(wounds) + 1)
		// making it look prettier on scanners
		heal_amt = round(heal_amt,0.1)
		var/dam_type = BRUTE
		if (W.wound_type == WOUND_BURN)
			dam_type = BURN
		if(owner.can_autoheal(dam_type))
			W.heal_damage(heal_amt)

	// sync the bodypart's damage with its wounds
	return update_damage()

/obj/item/bodypart/proc/is_damageable(added_damage)
	return !IS_ORGANIC_LIMB(src) || ((brute_dam + burn_dam + added_damage) < max_damage * 4)

//Applies brute and burn damage to the organ. Returns 1 if the damage-icon states changed at all.
//Damage will not exceed max_damage using this proc
//Cannot apply negative damage
/obj/item/bodypart/proc/receive_damage(brute = 0, burn = 0, blocked = 0, updating_health = TRUE, required_status = null, sharpness = NONE, modifiers = DEFAULT_DAMAGE_FLAGS)
	SHOULD_CALL_PARENT(TRUE)
	var/hit_percent = (100-blocked)/100
	if((!brute && !burn) || hit_percent <= 0)
		return FALSE
	if(owner && (owner.status_flags & GODMODE))
		return FALSE	//godmode
	if(required_status && !(bodytype & required_status))
		return FALSE

	var/dmg_multi = CONFIG_GET(number/damage_multiplier) * hit_percent
	brute = round(max(brute * dmg_multi, 0),DAMAGE_PRECISION)
	burn = round(max(burn * dmg_multi, 0),DAMAGE_PRECISION)
	brute = max(0, brute - brute_reduction)
	burn = max(0, burn - burn_reduction)

	if(!brute && !burn)
		return FALSE

	if(bodytype & (BODYTYPE_ALIEN|BODYTYPE_LARVA_PLACEHOLDER)) //aliens take double burn //nothing can burn with so much snowflake code around
		burn *= 2

	var/spillover = 0
	var/pure_brute = brute
	var/damagable = is_damageable()
	var/total = brute + burn

	if(!is_damageable())
		spillover =  brute_dam + burn_dam + brute - max_damage
		if(spillover > 0)
			brute = max(brute - spillover, 0)
		else
			spillover = brute_dam + burn_dam + brute + burn - max_damage
			if(spillover > 0)
				burn = max(burn - spillover, 0)

	var/can_dismember = modifiers & DAMAGE_CAN_DISMEMBER
	var/can_jostle_bones = modifiers & DAMAGE_CAN_JOSTLE_BONES
	var/can_break_bones = modifiers & DAMAGE_CAN_FRACTURE

	#ifndef UNIT_TESTS
	/*
	// DISMEMBERMENT - Doesn't happen during unit tests due to fucking up damage.
	*/
	if(owner && can_dismember)
		var/total_damage = brute_dam + burn_dam + burn + brute + spillover
		if(total_damage >= max_damage * LIMB_DISMEMBERMENT_PERCENT)
			if(attempt_dismemberment(pure_brute, burn, sharpness, total_damage > max_damage * LIMB_AUTODISMEMBER_PERCENT))
				return update_damage() || .
	#endif


	//blunt damage is gud at fracturing
	if(brute && (can_break_bones || can_jostle_bones))
		if(LAZYLEN(contained_organs))
			brute -= damage_internal_organs(round(brute/2, DAMAGE_PRECISION), null, sharpness) // Absorb some brute damage
			if(!IS_ORGANIC_LIMB(src))
				burn -= damage_internal_organs(null, round(burn/2, DAMAGE_PRECISION))

		if((bodypart_flags & BP_BROKEN_BONES) && can_jostle_bones)
			jostle_bones(brute)
		else if(can_break_bones && (brute_dam + brute > minimum_break_damage) && prob((brute_dam + brute * (1 + !sharpness)) * BODYPART_BONES_BREAK_CHANCE_MOD))
			break_bones()


	if(!damagable)
		return FALSE

	/*
	// START WOUND HANDLING
	*/
	// If the limbs can break, make sure we don't exceed the maximum damage a limb can take before breaking
	var/block_cut = (pure_brute < 10) || !IS_ORGANIC_LIMB(src)
	var/can_cut = !block_cut && ((sharpness) || prob(brute))
	if(brute)
		var/to_create = WOUND_BRUISE
		if(can_cut)
			to_create = WOUND_CUT
			//need to check sharp again here so that blunt damage that was strong enough to break skin doesn't give puncture wounds
			if(sharpness && !(sharpness & SHARP_EDGED))
				to_create = WOUND_PIERCE
		create_wound(to_create, brute, update_damage = FALSE)

	if(burn)
		create_wound(WOUND_BURN, burn, update_damage = FALSE)

	//Initial pain spike
	owner?.apply_pain(0.8*burn + 0.6*brute, body_zone, updating_health = FALSE)

	if(owner && total > 15 && prob(total*4) && !(bodypart_flags & BP_NO_PAIN))
		owner.bloodstream.add_reagent(/datum/reagent/medicine/epinephrine, round(total/10))

	//Disturb treated burns
	if(brute > 5)
		var/disturbed = 0
		for(var/datum/wound/burn/W in wounds)
			if((W.disinfected || W.salved) && prob(brute + W.damage))
				W.disinfected = 0
				W.salved = 0
				disturbed += W.damage

		if(disturbed)
			to_chat(owner, span_warning("Ow! Your burns were disturbed."))
			owner.apply_pain(0.5*burn, body_zone, updating_health = FALSE)

		if(owner && can_break_bones && istype(src, /obj/item/bodypart/head) && (bodypart_flags & BP_HAS_BLOOD) && sharpness == NONE && (owner.stat == CONSCIOUS) && owner.has_mouth())
			if(prob(8) && owner.bleed(5))
				owner.spray_blood(pick(GLOB.alldirs), 1)
				owner.visible_message(span_danger("Blood sprays from [owner]'s mouth!"))

	/*
	// END WOUND HANDLING
	*/

	//back to our regularly scheduled program, we now actually apply damage if there's room below limb damage cap
	var/can_inflict = max_damage - get_damage()
	var/total_damage = brute + burn
	if(total_damage > can_inflict && total_damage > 0) // TODO: the second part of this check should be removed once disabling is all done
		brute = round(brute * (can_inflict / total_damage),DAMAGE_PRECISION)
		burn = round(burn * (can_inflict / total_damage),DAMAGE_PRECISION)

	. = update_damage()
	if(owner)
		update_disabled()
		if(updating_health)
			owner.updatehealth()
			if(. & BODYPART_LIFE_UPDATE_DAMAGE_OVERLAYS)
				owner.update_damage_overlays()
	return .

/// Damages internal organs. Does not call updatehealth(), be mindful.
/obj/item/bodypart/proc/damage_internal_organs(brute, burn, sharpness)
	#ifdef UNIT_TESTS
	return // This randomly changes the damage outcomes, this is bad for unit testing.
	#endif
	if(!LAZYLEN(contained_organs) || !(brute || burn))
		return FALSE

	var/organ_damage_threshold = 10
	if(sharpness & SHARP_POINTY)
		organ_damage_threshold *= 0.5

	var/damage
	if(brute)
		if(!(brute_dam + brute >= max_damage) && !(brute >= organ_damage_threshold))
			return FALSE
		damage = brute
	else
		if(!(burn_dam + burn >= max_damage) && !(burn >= organ_damage_threshold))
			return FALSE
		damage = burn

	var/list/victims = list()
	var/organ_hit_chance = 0
	for(var/obj/item/organ/I as anything in contained_organs)
		if(!I.cosmetic_only && I.damage < I.maxHealth)
			victims[I] = I.relative_size
			organ_hit_chance += I.relative_size

	//No damageable organs
	if(!length(victims))
		return FALSE

	organ_hit_chance += 5 * damage/organ_damage_threshold

	if(encased && !(bodypart_flags & BP_BROKEN_BONES)) //ribs protect
		organ_hit_chance *= 0.6

	organ_hit_chance = min(organ_hit_chance, 100)
	if(prob(organ_hit_chance))
		var/obj/item/organ/victim = pick_weight(victims)
		damage *= victim.external_damage_modifier
		return victim.applyOrganDamage(damage, updating_health = FALSE)

//Heals brute and burn damage for the organ. Returns 1 if the damage-icon states changed at all.
//Damage cannot go below zero.
//Cannot remove negative damage (i.e. apply damage)
/obj/item/bodypart/proc/heal_damage(brute, burn, required_status, updating_health = TRUE)
	SHOULD_CALL_PARENT(TRUE)

	if(required_status && !(bodytype & required_status)) //So we can only heal certain kinds of limbs, ie robotic vs organic.
		return

		//Heal damage on the individual wounds
	for(var/datum/wound/W as anything in wounds)
		if(brute == 0 && burn == 0)
			break

		// heal brute damage
		if (W.wound_type == WOUND_BURN)
			burn = W.heal_damage(burn)
		else
			brute = W.heal_damage(brute)

	. = update_damage()

	if(owner)
		update_disabled()
		if(updating_health)
			owner.updatehealth()
			if(. & BODYPART_LIFE_UPDATE_DAMAGE_OVERLAYS)
				owner.update_damage_overlays()
	cremation_progress = min(0, cremation_progress - ((brute_dam + burn_dam)*(100/max_damage)))
	return .

///Proc to hook behavior associated to the change of the brute_dam variable's value.
/obj/item/bodypart/proc/set_brute_dam(new_value)
	PROTECTED_PROC(TRUE)

	if(brute_dam == new_value)
		return
	. = brute_dam
	brute_dam = new_value


///Proc to hook behavior associated to the change of the burn_dam variable's value.
/obj/item/bodypart/proc/set_burn_dam(new_value)
	PROTECTED_PROC(TRUE)

	if(burn_dam == new_value)
		return
	. = burn_dam
	burn_dam = new_value

//Returns total damage.
/obj/item/bodypart/proc/get_damage()
	return brute_dam + burn_dam

///Proc to update the damage values of the bodypart.
/obj/item/bodypart/proc/update_damage()
	var/old_brute = brute_dam
	var/old_burn = burn_dam
	real_wound_count = 0
	brute_dam = 0
	burn_dam = 0

	//update damage counts
	for(var/datum/wound/W as anything in wounds)
		if(W.damage <= 0)
			qdel(W)
			continue

		if (W.wound_type == WOUND_BURN)
			burn_dam += W.damage
		else
			brute_dam += W.damage

		real_wound_count += W.amount

	current_damage = round(brute_dam + burn_dam, DAMAGE_PRECISION)
	burn_dam = round(burn_dam, DAMAGE_PRECISION)
	brute_dam = round(brute_dam, DAMAGE_PRECISION)
	var/limb_loss_threshold = max_damage
	brute_ratio = brute_dam / (limb_loss_threshold * 2)
	burn_ratio = burn_dam / (limb_loss_threshold * 2)

	var/tbrute = min(round( (brute_dam/max_damage)*3, 1 ), 3)
	var/tburn = min(round( (burn_dam/max_damage)*3, 1 ), 3)
	if((tbrute != brutestate) || (tburn != burnstate))
		brutestate = tbrute
		burnstate = tburn
		. |= BODYPART_LIFE_UPDATE_DAMAGE_OVERLAYS

	if(old_brute != brute_dam || old_burn != burn_dam)
		. |= BODYPART_LIFE_UPDATE_HEALTH

	if(.)
		refresh_bleed_rate()

//Checks disabled status thresholds
/obj/item/bodypart/proc/update_disabled()
	SHOULD_CALL_PARENT(TRUE)

	if(!owner)
		return

	if(bodypart_flags & (BP_CUT_AWAY|BP_TENDON_CUT))
		set_disabled(TRUE)
		return

	if(!can_be_disabled)
		set_disabled(FALSE)
		return

	if(HAS_TRAIT(src, TRAIT_PARALYSIS))
		set_disabled(TRUE)
		return

	if(bodypart_flags & BP_NECROTIC)
		set_disabled(TRUE)
		return

	var/total_damage = max(brute_dam + burn_dam)

	// this block of checks is for limbs that can be disabled, but not through pure damage (AKA limbs that suffer wounds, human/monkey parts and such)
	if(!disable_threshold)
		if(total_damage < max_damage)
			last_maxed = FALSE
		else
			if(!last_maxed && owner.stat < UNCONSCIOUS)
				INVOKE_ASYNC(owner, TYPE_PROC_REF(/mob, emote), "agony")
			last_maxed = TRUE
		set_disabled(FALSE) // we only care about the paralysis trait
		return

	// we're now dealing solely with limbs that can be disabled through pure damage, AKA robot parts
	if(total_damage >= max_damage * disable_threshold)
		if(!last_maxed)
			if(owner.stat < UNCONSCIOUS)
				INVOKE_ASYNC(owner, TYPE_PROC_REF(/mob, emote), "agony")
			last_maxed = TRUE
		set_disabled(TRUE)
		return

	if(bodypart_disabled && total_damage <= max_damage * 0.5) // reenable the limb at 50% health
		last_maxed = FALSE
		set_disabled(FALSE)


///Proc to change the value of the `disabled` variable and react to the event of its change.
/obj/item/bodypart/proc/set_disabled(new_disabled)
	SHOULD_CALL_PARENT(TRUE)
	PROTECTED_PROC(TRUE)

	if(bodypart_disabled == new_disabled)
		return
	. = bodypart_disabled
	bodypart_disabled = new_disabled

	if(!owner)
		return

	if(bodypart_flags & BP_IS_MOVEMENT_LIMB)
		if(!.)
			if(bodypart_disabled)
				owner.set_usable_legs(owner.usable_legs - 1)
				if(owner.stat < UNCONSCIOUS)
					to_chat(owner, span_userdanger("You lose control of your [plaintext_zone]!"))
		else if(!bodypart_disabled)
			owner.set_usable_legs(owner.usable_legs + 1)

	if(bodypart_flags & BP_IS_GRABBY_LIMB)
		if(!.)
			if(bodypart_disabled)
				owner.set_usable_hands(owner.usable_hands - 1)
				if(owner.stat < UNCONSCIOUS)
					to_chat(owner, span_userdanger("You lose control of your [plaintext_zone]!"))
				if(held_index)
					owner.dropItemToGround(owner.get_item_for_held_index(held_index))
		else if(!bodypart_disabled)
			owner.set_usable_hands(owner.usable_hands + 1)

		if(owner.hud_used)
			var/atom/movable/screen/inventory/hand/hand_screen_object = owner.hud_used.hand_slots["[held_index]"]
			hand_screen_object?.update_appearance()

	owner.update_health_hud() //update the healthdoll
	owner.update_body()


///Proc to change the value of the `owner` variable and react to the event of its change.
/obj/item/bodypart/proc/set_owner(new_owner)
	SHOULD_CALL_PARENT(TRUE)
	if(owner == new_owner)
		return FALSE //`null` is a valid option, so we need to use a num var to make it clear no change was made.
	var/mob/living/carbon/old_owner = owner
	owner = new_owner
	var/needs_update_disabled = FALSE //Only really relevant if there's an owner
	if(old_owner)
		if(initial(can_be_disabled))
			if(HAS_TRAIT(old_owner, TRAIT_NOLIMBDISABLE))
				if(!owner || !HAS_TRAIT(owner, TRAIT_NOLIMBDISABLE))
					set_can_be_disabled(initial(can_be_disabled))
					needs_update_disabled = TRUE
			UnregisterSignal(old_owner, list(
				SIGNAL_REMOVETRAIT(TRAIT_NOLIMBDISABLE),
				SIGNAL_ADDTRAIT(TRAIT_NOLIMBDISABLE),
				SIGNAL_REMOVETRAIT(TRAIT_NOBLEED),
				SIGNAL_ADDTRAIT(TRAIT_NOBLEED),
				))
	if(owner)
		if(initial(can_be_disabled))
			if(HAS_TRAIT(owner, TRAIT_NOLIMBDISABLE))
				set_can_be_disabled(FALSE)
				needs_update_disabled = FALSE
			RegisterSignal(owner, SIGNAL_REMOVETRAIT(TRAIT_NOLIMBDISABLE), PROC_REF(on_owner_nolimbdisable_trait_loss))
			RegisterSignal(owner, SIGNAL_ADDTRAIT(TRAIT_NOLIMBDISABLE), PROC_REF(on_owner_nolimbdisable_trait_gain))
			// Bleeding stuff
			RegisterSignal(owner, SIGNAL_REMOVETRAIT(TRAIT_NOBLEED), PROC_REF(on_owner_nobleed_loss))
			RegisterSignal(owner, SIGNAL_ADDTRAIT(TRAIT_NOBLEED), PROC_REF(on_owner_nobleed_gain))

		if(needs_update_disabled)
			update_disabled()

	update_damage()
	return old_owner

///Proc to change the value of the `can_be_disabled` variable and react to the event of its change.
/obj/item/bodypart/proc/set_can_be_disabled(new_can_be_disabled)
	PROTECTED_PROC(TRUE)
	SHOULD_CALL_PARENT(TRUE)

	if(can_be_disabled == new_can_be_disabled)
		return
	. = can_be_disabled
	can_be_disabled = new_can_be_disabled
	if(can_be_disabled)
		if(owner)
			if(HAS_TRAIT(owner, TRAIT_NOLIMBDISABLE))
				CRASH("set_can_be_disabled to TRUE with for limb whose owner has TRAIT_NOLIMBDISABLE")
			RegisterSignal(owner, SIGNAL_ADDTRAIT(TRAIT_PARALYSIS), PROC_REF(on_paralysis_trait_gain))
			RegisterSignal(owner, SIGNAL_REMOVETRAIT(TRAIT_PARALYSIS), PROC_REF(on_paralysis_trait_loss))
		update_disabled()
	else if(.)
		if(owner)
			UnregisterSignal(owner, list(
				SIGNAL_ADDTRAIT(TRAIT_PARALYSIS),
				SIGNAL_REMOVETRAIT(TRAIT_PARALYSIS),
				))
		set_disabled(FALSE)


///Called when TRAIT_PARALYSIS is added to the limb.
/obj/item/bodypart/proc/on_paralysis_trait_gain(obj/item/bodypart/source)
	PROTECTED_PROC(TRUE)
	SIGNAL_HANDLER

	if(can_be_disabled)
		set_disabled(TRUE)


///Called when TRAIT_PARALYSIS is removed from the limb.
/obj/item/bodypart/proc/on_paralysis_trait_loss(obj/item/bodypart/source)
	PROTECTED_PROC(TRUE)
	SIGNAL_HANDLER

	if(can_be_disabled)
		update_disabled()


///Called when TRAIT_NOLIMBDISABLE is added to the owner.
/obj/item/bodypart/proc/on_owner_nolimbdisable_trait_gain(mob/living/carbon/source)
	PROTECTED_PROC(TRUE)
	SIGNAL_HANDLER

	set_can_be_disabled(FALSE)


///Called when TRAIT_NOLIMBDISABLE is removed from the owner.
/obj/item/bodypart/proc/on_owner_nolimbdisable_trait_loss(mob/living/carbon/source)
	PROTECTED_PROC(TRUE)
	SIGNAL_HANDLER

	set_can_be_disabled(initial(can_be_disabled))

/obj/item/bodypart/deconstruct(disassembled = TRUE)
	SHOULD_CALL_PARENT(TRUE)

	drop_contents()
	return ..()

/// INTERNAL PROC, DO NOT USE
/// Properly sets us up to manage an inserted embeded object
/obj/item/bodypart/proc/_embed_object(obj/item/embed)
	if(embed in embedded_objects) // go away
		return
	// We don't need to do anything with projectile embedding, because it will never reach this point
	RegisterSignal(embed, COMSIG_ITEM_EMBEDDING_UPDATE, PROC_REF(embedded_object_changed))
	embedded_objects += embed
	refresh_bleed_rate()

/// INTERNAL PROC, DO NOT USE
/// Cleans up any attachment we have to the embedded object, removes it from our list
/obj/item/bodypart/proc/_unembed_object(obj/item/unembed)
	UnregisterSignal(unembed, COMSIG_ITEM_EMBEDDING_UPDATE)
	embedded_objects -= unembed
	refresh_bleed_rate()

/obj/item/bodypart/proc/embedded_object_changed(obj/item/embedded_source)
	SIGNAL_HANDLER
	/// Embedded objects effect bleed rate, gotta refresh lads
	refresh_bleed_rate()

/// Sets our generic bleedstacks
/obj/item/bodypart/proc/setBleedStacks(set_to)
	SHOULD_CALL_PARENT(TRUE)
	adjustBleedStacks(set_to - generic_bleedstacks)

/// Modifies our generic bleedstacks. You must use this to change the variable
/// Takes the amount to adjust by, and the lowest amount we're allowed to have post adjust
/obj/item/bodypart/proc/adjustBleedStacks(adjust_by, minimum = -INFINITY)
	if(!adjust_by)
		return
	var/old_bleedstacks = generic_bleedstacks
	generic_bleedstacks = max(generic_bleedstacks + adjust_by, minimum)

	// If we've started or stopped bleeding, we need to refresh our bleed rate
	if((old_bleedstacks <= 0 && generic_bleedstacks > 0) \
		|| old_bleedstacks > 0 && generic_bleedstacks <= 0)
		refresh_bleed_rate()

/obj/item/bodypart/proc/on_owner_nobleed_loss(datum/source)
	SIGNAL_HANDLER
	refresh_bleed_rate()

/obj/item/bodypart/proc/on_owner_nobleed_gain(datum/source)
	SIGNAL_HANDLER
	refresh_bleed_rate()

/// Refresh the cache of our rate of bleeding sans any modifiers
/// ANYTHING ADDED TO THIS PROC NEEDS TO CALL IT WHEN IT'S EFFECT CHANGES
/obj/item/bodypart/proc/refresh_bleed_rate()
	SHOULD_NOT_OVERRIDE(TRUE)

	var/old_bleed_rate = cached_bleed_rate
	cached_bleed_rate = 0
	bodypart_flags &= ~BP_BLEEDING
	if(!owner)
		return

	if(HAS_TRAIT(owner, TRAIT_NOBLEED) || !(bodypart_flags & BP_HAS_BLOOD))
		if(cached_bleed_rate != old_bleed_rate)
			update_part_wound_overlay()
		return

	if(generic_bleedstacks > 0)
		cached_bleed_rate += 0.5

	if(check_artery() & CHECKARTERY_SEVERED)
		cached_bleed_rate += 4

	for(var/obj/item/embeddies in embedded_objects)
		if(!embeddies.isEmbedHarmless())
			cached_bleed_rate += 0.25

	for(var/datum/wound/iter_wound as anything in wounds)
		if(iter_wound.bleeding())
			cached_bleed_rate += WOUND_BLEED_RATE(iter_wound)
			bodypart_flags |= BP_BLEEDING

	// Our bleed overlay is based directly off bleed_rate, so go aheead and update that would you?
	if(cached_bleed_rate != old_bleed_rate)
		update_part_wound_overlay()

	return cached_bleed_rate

/// Returns our bleed rate, taking into account laying down and grabbing the limb
/obj/item/bodypart/proc/get_modified_bleed_rate()
	var/bleed_rate = cached_bleed_rate
	if(owner.body_position == LYING_DOWN)
		bleed_rate *= 0.75

	if(HAS_TRAIT(src, TRAIT_BODYPART_GRABBED))
		bleed_rate *= 0.4

	if(bandage)
		bleed_rate *= bandage.absorption_rate_modifier

	var/coag_level = CHEM_EFFECT_MAGNITUDE(owner, CE_ANTICOAGULANT)
	if(coag_level)
		if(coag_level > 0)
			bleed_rate *= 1 + coag_level
		else
			bleed_rate *= 0.5 / coag_level

	return bleed_rate

// how much blood the limb needs to be losing per tick (not counting laying down/self grasping modifiers) to get the different bleed icons
#define BLEED_OVERLAY_LOW 0.5
#define BLEED_OVERLAY_MED 1.5
#define BLEED_OVERLAY_GUSH 3.25

/obj/item/bodypart/proc/update_part_wound_overlay()
	if(!owner || is_stump)
		return FALSE

	if(HAS_TRAIT(owner, TRAIT_NOBLEED) || !IS_ORGANIC_LIMB(src) || (NOBLOOD in species_flags_list))
		if(bleed_overlay_icon)
			bleed_overlay_icon = null
			owner.update_wound_overlays()
		return FALSE

	var/bleed_rate = cached_bleed_rate
	var/new_bleed_icon = null

	switch(bleed_rate)
		if(-INFINITY to BLEED_OVERLAY_LOW)
			new_bleed_icon = null
		if(BLEED_OVERLAY_LOW to BLEED_OVERLAY_MED)
			new_bleed_icon = "[body_zone]_1"
		if(BLEED_OVERLAY_MED to BLEED_OVERLAY_GUSH)
			if(owner.body_position == LYING_DOWN || IS_IN_STASIS(owner) || owner.stat == DEAD)
				new_bleed_icon = "[body_zone]_2s"
			else
				new_bleed_icon = "[body_zone]_2"
		if(BLEED_OVERLAY_GUSH to INFINITY)
			if(IS_IN_STASIS(owner) || owner.stat == DEAD)
				new_bleed_icon = "[body_zone]_2s"
			else
				new_bleed_icon = "[body_zone]_3"

	if(new_bleed_icon != bleed_overlay_icon)
		bleed_overlay_icon = new_bleed_icon
		owner.update_wound_overlays()

#undef BLEED_OVERLAY_LOW
#undef BLEED_OVERLAY_MED
#undef BLEED_OVERLAY_GUSH

/obj/item/bodypart/proc/apply_bandage(obj/item/stack/new_bandage)
	if(bandage || !istype(new_bandage) || !new_bandage.absorption_capacity)
		return

	bandage = new_bandage.split_stack(null, 1, src)
	RegisterSignal(bandage, COMSIG_PARENT_QDELETING, PROC_REF(bandage_gone))
	if(bandage.absorption_capacity && owner.stat < UNCONSCIOUS)
		for(var/datum/wound/iter_wound as anything in wounds)
			if(iter_wound.bleeding())
				to_chat(owner, span_warning("You feel blood pool on your [plaintext_zone]."))
				break

/obj/item/bodypart/proc/remove_bandage()
	if(!bandage)
		return FALSE

	. = bandage
	UnregisterSignal(bandage, COMSIG_PARENT_QDELETING)
	if(bandage.loc == src)
		bandage.forceMove(drop_location())
	bandage = null

/obj/item/bodypart/proc/bandage_gone(obj/item/stack/bandage)
	SIGNAL_HANDLER
	remove_bandage()

/obj/item/bodypart/proc/apply_splint(obj/item/splint)
	if(src.splint)
		return FALSE

	src.splint = splint
	if(istype(splint, /obj/item/stack))
		splint.forceMove(src)

	update_interaction_speed()
	RegisterSignal(splint, COMSIG_PARENT_QDELETING, PROC_REF(splint_gone))
	SEND_SIGNAL(src, COMSIG_LIMB_SPLINTED, splint)
	return TRUE

/obj/item/bodypart/leg/apply_splint(obj/item/splint)
	. = ..()
	if(!.)
		return
	owner.apply_status_effect(/datum/status_effect/limp)

/obj/item/bodypart/proc/remove_splint()
	if(!splint)
		return FALSE

	. = splint

	UnregisterSignal(splint, COMSIG_PARENT_QDELETING)
	if(splint.loc == src)
		splint.forceMove(drop_location())

	splint = null
	update_interaction_speed()
	SEND_SIGNAL(src, COMSIG_LIMB_UNSPLINTED, splint)

/obj/item/bodypart/proc/splint_gone(obj/item/source)
	SIGNAL_HANDLER
	remove_splint()

/obj/item/bodypart/drop_location()
	if(owner)
		return owner.drop_location()
	return ..()

///Loops through all of the bodypart's external organs and update's their color.
/obj/item/bodypart/proc/recolor_cosmetic_organs()
	for(var/obj/item/organ/O as anything in contained_organs)
		if(!O.visual)
			continue
		O.inherit_color(force = TRUE)

///A multi-purpose setter for all things immediately important to the icon and iconstate of the limb.
/obj/item/bodypart/proc/change_appearance(icon, id, greyscale, dimorphic, update_owner = TRUE)
	if(!isnull(greyscale) && greyscale == TRUE)
		icon_greyscale = icon || icon_greyscale
		should_draw_greyscale = TRUE
	else if(greyscale == FALSE)
		icon_static = icon || icon_static
		should_draw_greyscale = FALSE

	if(id) //limb_id should never be falsey
		limb_id = id

	if(!isnull(dimorphic))
		is_dimorphic = dimorphic

	if(owner && update_owner)
		owner.update_body_parts()
	else
		update_icon_dropped()

	//This foot gun needs a safety
	if(!icon_exists(should_draw_greyscale ? icon_greyscale : icon_static, "[limb_id]_[body_zone][is_dimorphic ? "_[limb_gender]" : ""]"))
		reset_appearance()
		stack_trace("change_appearance([icon || "NULL"], [id || "NULL"], [greyscale|| "NULL"], [dimorphic|| "NULL"]) generated null icon. Appearance not applied.")

///Resets the base appearance of a limb to it's default values.
/obj/item/bodypart/proc/reset_appearance()
	icon_static = initial(icon_static)
	icon_greyscale = initial(icon_greyscale)
	limb_id = initial(limb_id)
	is_dimorphic = initial(is_dimorphic)
	should_draw_greyscale = initial(should_draw_greyscale)

	if(owner)
		owner.update_body_parts()
	else
		update_icon_dropped()

/obj/item/bodypart/proc/get_offset(direction)
	return null

/obj/item/bodypart/arm/right/get_offset(direction)
	switch(direction)
		if(NORTH)
			return list(6,-3)
		if(SOUTH)
			return list(-6,-3)
		if(EAST)
			return list(0,-3)
		if(WEST)
			return list(0,-3)

/obj/item/bodypart/arm/left/get_offset(direction)
	switch(direction)
		if(NORTH)
			return list(-6,-3)
		if(SOUTH)
			return list(6,-3)
		if(EAST)
			return list(0,-3)
		if(WEST)
			return list(0,-3)

/obj/item/bodypart/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_WIRES || !(bodytype & BODYTYPE_ROBOTIC))
		return FALSE

	if(!(body_zone == BODY_ZONE_CHEST))
		owner.visible_message(span_danger("<b>[owner]<b>'s [src.name] falls limp!"))

	var/time_needed = 10 SECONDS
	var/brute_damage = 1.5
	var/burn_damage = 2.5

	if(severity == EMP_HEAVY)
		time_needed *= 2
		brute_damage *= 2
		burn_damage *= 2

	receive_damage(brute_damage, burn_damage, modifiers = NONE)
	do_sparks(number = 1, cardinal_only = FALSE, source = owner)
	ADD_TRAIT(src, TRAIT_PARALYSIS, EMP_TRAIT)
	addtimer(CALLBACK(src, PROC_REF(un_paralyze)), time_needed)
	return TRUE

/obj/item/bodypart/proc/un_paralyze()
	REMOVE_TRAITS_IN(src, EMP_TRAIT)

/obj/item/bodypart/leg/emp_act(severity)
	. = ..()
	if(!.)
		return
	owner.Knockdown(severity == EMP_HEAVY ? 20 SECONDS : 10 SECONDS)

/obj/item/bodypart/chest/robot/emp_act(severity)
	. = ..()
	if(!.)
		return
	to_chat(owner, span_danger("Your [src.name]'s logic boards temporarily become unresponsive!"))
	if(severity == EMP_HEAVY)
		owner.Stun(6 SECONDS)
		owner.Shake(pixelshiftx = 5, pixelshifty = 2, duration = 4 SECONDS)
		return

	owner.Stun(3 SECONDS)
	owner.Shake(pixelshiftx = 3, pixelshifty = 0, duration = 2.5 SECONDS)

/// Add an item to our cavity. Call AFTER physically moving it via a proc like forceMove().
/obj/item/bodypart/proc/add_cavity_item(obj/item/I)
	cavity_items += I
	RegisterSignal(I, COMSIG_MOVABLE_MOVED, PROC_REF(item_gone))
	RegisterSignal(I, COMSIG_PARENT_QDELETING, PROC_REF(item_gone))

/obj/item/bodypart/proc/remove_cavity_item(obj/item/I)
	cavity_items -= I
	UnregisterSignal(I, COMSIG_MOVABLE_MOVED)
	UnregisterSignal(I, COMSIG_PARENT_QDELETING)

/obj/item/bodypart/proc/item_gone(datum/source)
	SIGNAL_HANDLER
	remove_cavity_item(source)

/obj/item/bodypart/proc/get_scan_results(tag)
	RETURN_TYPE(/list)
	SHOULD_CALL_PARENT(TRUE)
	. = list()
	if(!IS_ORGANIC_LIMB(src))
		. += tag ? "<span style='font-weight: bold; color: [COLOR_MEDICAL_ROBOTIC]'>Mechanical</span>" : "Mechanical"

	if(bodypart_flags & BP_CUT_AWAY)
		. += tag ? "<span style='font-weight: bold; color: [COLOR_MEDICAL_INTERNAL]'>Severed</span>" : "Severed"

	if(check_tendon() & CHECKTENDON_SEVERED)
		. += tag ? "<span style='font-weight: bold; color: [COLOR_MEDICAL_INTERNAL_DANGER]'>Severed [tendon_name]</span>" : "Severed [tendon_name]"

	if(check_artery() & CHECKARTERY_SEVERED)
		. += tag ? "<span style='font-weight: bold; color: [COLOR_MEDICAL_INTERNAL_DANGER]'>Severed [artery_name]</span>" : "Severed [artery_name]"

	if(check_bones() & CHECKBONES_BROKEN)
		. += tag ? "<span style='font-weight: bold; color: [COLOR_MEDICAL_INTERNAL_DANGER]'>Fractured</span>" : "Fractured"

	if(bodypart_flags & BP_DISLOCATED)
		. += tag ? "<span style='font-weight: bold; color: [COLOR_MEDICAL_INTERNAL]'>Dislocated</span>" : "Dislocated"

	if (length(cavity_items) || length(embedded_objects))
		var/unknown_body = 0
		for(var/obj/item/I in cavity_items + embedded_objects)
			if(istype(I,/obj/item/implant))
				var/obj/item/implant/imp = I
				if(imp.implant_flags & IMPLANT_HIDDEN)
					continue
				if (imp.implant_flags & IMPLANT_KNOWN)
					. += tag ? "<span style='font-weight: bold; color: [COLOR_MEDICAL_IMPLANT]'>[capitalize(imp.name)] implanted</span>" : "[capitalize(imp.name)] implanted"
					continue
			unknown_body++

		if(unknown_body)
			. += tag ? "<span style='font-weight: bold; color: [COLOR_MEDICAL_UNKNOWN_IMPLANT]'>Unknown body present</span>" : "Unknown body present"

/obj/item/bodypart/Topic(href, href_list)
	. = ..()
	if(QDELETED(src) || !owner)
		return

	if(!ishuman(usr))
		return

	var/mob/living/carbon/human/user = usr
	if(!user.Adjacent(owner))
		return

	if(user.get_active_held_item())
		return

	if(href_list["embedded_object"])
		var/obj/item/I = locate(href_list["embedded_object"]) in embedded_objects
		if(!I || I.loc != src) //no item, no limb, or item is not in limb or in the person anymore
			return
		SEND_SIGNAL(src, COMSIG_LIMB_EMBED_RIP, I, user)
		return

	if(href_list["splint_remove"])
		if(!splint)
			return

		if(do_after(user, owner, 5 SECONDS, DO_PUBLIC))
			var/obj/item/removed = remove_splint()
			if(!removed)
				return
			if(!user.put_in_hands(removed))
				removed.forceMove(user.drop_location())
			if(user == owner)
				user.visible_message(span_notice("[user] removes [removed] from [user.p_their()] [plaintext_zone]."))
			else
				user.visible_message(span_notice("[user] removes [removed] from [owner]'s [plaintext_zone]."))
		return

	if(href_list["bandage_remove"])
		if(!bandage)
			return

		if(do_after(user, owner, 5 SECONDS, DO_PUBLIC))
			var/obj/item/removed = remove_bandage()
			if(!removed)
				return
			if(!user.put_in_hands(removed))
				removed.forceMove(user.drop_location())
			if(user == owner)
				user.visible_message(span_notice("[user] removes [removed] from [user.p_their()] [plaintext_zone]."))
			else
				user.visible_message(span_notice("[user] removes [removed] from [owner]'s [plaintext_zone]."))
		return

/obj/item/bodypart/proc/inspect(mob/user)
	if(is_stump)
		to_chat(user, span_notice("[owner] is missing that bodypart."))
		return

	user.visible_message(span_notice("[user] starts inspecting [owner]'s [plaintext_zone] carefully."))
	if(LAZYLEN(wounds))
		to_chat(user, span_warning("You find [mob_examine(just_wounds_please = TRUE)]."))
		var/list/stuff = list()
		for(var/datum/wound/wound as anything in wounds)
			if(LAZYLEN(wound.embedded_objects))
				stuff |= wound.embedded_objects

		if(length(stuff))
			to_chat(user, span_warning("There's [english_list(stuff)] sticking out of [owner]'s [plaintext_zone]."))
	else
		to_chat(user, span_notice("You find no visible wounds."))

	to_chat(user, span_notice("Checking skin now..."))

	if(!do_after(user, owner, 1 SECOND, DO_PUBLIC))
		return

	to_chat(user, span_notice("Checking bones now..."))
	if(!do_after(user, owner, 1 SECOND, DO_PUBLIC))
		return

	if(bodypart_flags & BP_BROKEN_BONES)
		to_chat(user, span_warning("The [encased ? encased : "bone in the [plaintext_zone]"] moves slightly when you poke it!"))
		owner.apply_pain(40, body_zone, "Your [plaintext_zone] hurts where it's poked.")
	else
		to_chat(user, span_notice("The [encased ? encased : "bones in the [plaintext_zone]"] seem to be fine."))

	if(bodypart_flags & BP_TENDON_CUT)
		to_chat(user, span_warning("The tendons in the [plaintext_zone] are severed!"))
	if(bodypart_flags & BP_DISLOCATED)
		to_chat(user, span_warning("The [joint_name] is dislocated!"))
	return TRUE

/// Applies all bodypart traits to the target.
/obj/item/bodypart/proc/apply_traits(mob/target)
	if(isnull(target))
		return

	for(var/trait in bodypart_traits)
		ADD_TRAIT(target, trait, bodypart_trait_source)

/// Adds a trait to be applied by this bodypart.
/obj/item/bodypart/proc/add_bodypart_trait(trait)
	bodypart_traits |= trait
	apply_traits(owner)

/// Removes a trait applied by this bodypart.
/obj/item/bodypart/proc/remove_bodypart_trait(trait)
	bodypart_traits -= trait
	if(owner)
		REMOVE_TRAIT(owner, trait, bodypart_trait_source)

/// Remove all bodypart traits this part grants.
/obj/item/bodypart/proc/remove_traits_from(mob/target)
	SHOULD_NOT_OVERRIDE(TRUE)
	PRIVATE_PROC(TRUE)
	if(isnull(target))
		return

	for(var/trait in bodypart_traits)
		REMOVE_TRAIT(target, trait, bodypart_trait_source)
