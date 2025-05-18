/mob/living/carbon/human/getarmor(def_zone, type)
	var/armorval = 0
	var/organnum = 0

	if(def_zone)
		if(isbodypart(def_zone))
			var/obj/item/bodypart/bp = def_zone
			if(bp)
				return checkarmor(def_zone, type)
		var/obj/item/bodypart/affecting = get_bodypart(deprecise_zone(def_zone))
		if(affecting)
			return checkarmor(affecting, type)
		//If a specific bodypart is targetted, check how that bodypart is protected and return the value.

	//If you don't specify a bodypart, it checks ALL your bodyparts for protection, and averages out the values
	for(var/obj/item/bodypart/BP as anything in bodyparts)
		armorval += checkarmor(BP, type)
		organnum++
	return (armorval/max(organnum, 1))


/mob/living/carbon/human/proc/checkarmor(obj/item/bodypart/limb, d_type)
	if(!d_type)
		return 0
	var/protection = limb.returnArmor().getRating(d_type)
	var/list/body_parts = list(head, wear_mask, wear_suit, w_uniform, back, gloves, shoes, belt, s_store, glasses, ears, wear_id, wear_neck) //Everything but pockets. Pockets are l_store and r_store. (if pockets were allowed, putting something armored, gloves or hats for example, would double up on the armor)

	for(var/obj/item/clothing/C in body_parts)
		if(C.body_parts_covered & limb.body_part)
			protection += C.returnArmor().getRating(d_type)

	protection += physiology.returnArmor().getRating(d_type)
	return protection

///Get all the clothing on a specific body part
/mob/living/carbon/human/proc/clothingonpart(obj/item/bodypart/def_zone)
	var/list/covering_part = list()
	var/list/body_parts = list(head, wear_mask, wear_suit, w_uniform, back, gloves, shoes, belt, s_store, glasses, ears, wear_id, wear_neck) //Everything but pockets. Pockets are l_store and r_store. (if pockets were allowed, putting something armored, gloves or hats for example, would double up on the armor)
	for(var/bp in body_parts)
		if(!bp)
			continue
		if(bp && istype(bp , /obj/item/clothing))
			var/obj/item/clothing/C = bp
			if(C.body_parts_covered & def_zone.body_part)
				covering_part += C
	return covering_part

/mob/living/carbon/human/on_hit(obj/projectile/P)
	if(dna?.species)
		dna.species.on_hit(P, src)


/mob/living/carbon/human/bullet_act(obj/projectile/P, def_zone, piercing_hit = FALSE)
	if(dna?.species)
		var/spec_return = dna.species.bullet_act(P, src)
		if(spec_return)
			return spec_return

	//MARTIAL ART STUFF
	if(mind)
		if(mind.martial_art && mind.martial_art.can_use(src)) //Some martial arts users can deflect projectiles!
			var/martial_art_result = mind.martial_art.on_projectile_hit(src, P, def_zone)
			if(!(martial_art_result == BULLET_ACT_HIT))
				return martial_art_result

	if(!(P.original == src && P.firer == src)) //can't block or reflect when shooting yourself
		if(P.reflectable & REFLECT_NORMAL)
			var/obj/item/reflected_with = check_reflect(def_zone)
			if(reflected_with) // Checks if you've passed a reflection% check
				visible_message(
					span_danger("[src] reflects [P] with [reflected_with]!"),
					span_userdanger("You reflect [P] with [reflected_with]!")
				)
				reflected_with.play_block_sound(src, PROJECTILE_ATTACK)
				// Find a turf near or on the original location to bounce to
				if(!isturf(loc)) //Open canopy mech (ripley) check. if we're inside something and still got hit
					P.force_hit = TRUE //The thing we're in passed the bullet to us. Pass it back, and tell it to take the damage.
					loc.bullet_act(P, def_zone, piercing_hit)
					return BULLET_ACT_HIT

				if(P.starting)
					var/new_x = P.starting.x + pick(0, 0, 0, 0, 0, -1, 1, -2, 2)
					var/new_y = P.starting.y + pick(0, 0, 0, 0, 0, -1, 1, -2, 2)
					var/turf/curloc = get_turf(src)

					// redirect the projectile
					P.original = locate(new_x, new_y, P.z)
					P.starting = curloc
					P.firer = src
					P.yo = new_y - curloc.y
					P.xo = new_x - curloc.x
					var/new_angle_s = P.Angle + rand(120,240)
					while(new_angle_s > 180) // Translate to regular projectile degrees
						new_angle_s -= 360
					P.set_angle(new_angle_s)

				return BULLET_ACT_FORCE_PIERCE // complete projectile permutation

		if(check_block(P, P.damage, "the [P.name]", PROJECTILE_ATTACK, P.armor_penetration))
			P.on_hit(src, 100, def_zone, piercing_hit)
			return BULLET_ACT_HIT

	return ..()

///Reflection checks for anything in your l_hand, r_hand, or wear_suit based on the reflection chance of the object
/mob/living/carbon/human/proc/check_reflect(def_zone)
	if(wear_suit)
		if(wear_suit.IsReflect(def_zone))
			return wear_suit
	if(head)
		if(head.IsReflect(def_zone))
			return head
	for(var/obj/item/I in held_items)
		if(I.IsReflect(def_zone))
			return I
	return FALSE

/mob/living/carbon/human/check_block(atom/hit_by, damage, attack_text = "the attack", attack_type = MELEE_ATTACK, armor_penetration = 0)
	. = ..()
	if(.)
		return

	for(var/obj/item/I in held_items)
		if(!istype(I, /obj/item/clothing))
			if(I.try_block_attack(src, hit_by, attack_text, damage, attack_type))
				return TRUE

	for(var/obj/item/clothing/I in get_all_worn_items(FALSE))
		if(I.try_block_attack(src, hit_by, attack_text, damage, attack_type))
			return TRUE

	return FALSE

/mob/living/carbon/human/attack_hulk(mob/living/carbon/human/user)
	. = ..()
	if(!.)
		return

	var/hulk_verb = pick("smash","pummel")
	if(check_block(user, 15, "the [hulk_verb]ing", attack_type = UNARMED_ATTACK))
		return

	var/obj/item/bodypart/arm/active_arm = user.get_active_hand()
	playsound(loc, active_arm.unarmed_attack_sound, 25, TRUE, -1)
	visible_message(span_danger("[user] [hulk_verb]ed [src]!"), \
					span_userdanger("[user] [hulk_verb]ed [src]!"), span_hear("You hear a sickening sound of flesh hitting flesh!"), null, user)
	to_chat(user, span_danger("You [hulk_verb] [src]!"))
	apply_damage(15, BRUTE)

/mob/living/carbon/human/attack_hand(mob/user, list/modifiers)
	if(..()) //to allow surgery to return properly.
		return
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		dna.species.spec_attack_hand(H, src, null, modifiers)

/mob/living/carbon/human/attack_paw(mob/living/carbon/human/user, list/modifiers)
	var/dam_zone = pick(BODY_ZONE_CHEST, BODY_ZONE_PRECISE_L_HAND, BODY_ZONE_PRECISE_R_HAND, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
	var/obj/item/bodypart/affecting = get_bodypart(ran_zone(dam_zone))
	if(!affecting)
		affecting = get_bodypart(BODY_ZONE_CHEST)

	var/martial_result = user.apply_martial_art(src, modifiers)
	if (martial_result != MARTIAL_ATTACK_INVALID)
		return martial_result

	if(LAZYACCESS(modifiers, RIGHT_CLICK)) //Always drop item in hand, if no item, get stunned instead.
		var/obj/item/I = get_active_held_item()
		if(I && !(I.item_flags & ABSTRACT) && dropItemToGround(I))
			playsound(loc, 'sound/weapons/slash.ogg', 25, TRUE, -1)
			visible_message(span_danger("[user] disarmed [src]!"), \
							span_userdanger("[user] disarmed you!"), span_hear("You hear aggressive shuffling!"), null, user)
			to_chat(user, span_danger("You disarm [src]!"))
		else if(!user.client || prob(5)) // only natural monkeys get to stun reliably, (they only do it occasionaly)
			playsound(loc, 'sound/weapons/pierce.ogg', 25, TRUE, -1)
			if (src.IsKnockdown() && !src.IsParalyzed())
				Paralyze(40)
				log_combat(user, src, "pinned")
				visible_message(span_danger("[user] pins [src] down!"), \
								span_userdanger("[user] pins you down!"), span_hear("You hear shuffling and a muffled groan!"), null, user)
				to_chat(user, span_danger("You pin [src] down!"))
			else
				Knockdown(30)
				log_combat(user, src, "tackled")
				visible_message(span_danger("[user] tackles [src] down!"), \
								span_userdanger("[user] tackles you down!"), span_hear("You hear aggressive shuffling followed by a loud thud!"), null, user)
				to_chat(user, span_danger("You tackle [src] down!"))
		return TRUE

	if(!user.combat_mode)
		..() //shaking
		return FALSE

	if(user.limb_destroyer)
		dismembering_strike(user, affecting.body_zone)

	if(try_inject(user, affecting, injection_flags = INJECT_TRY_SHOW_ERROR_MESSAGE))//Thick suits can stop monkey bites.
		if(..()) //successful monkey bite, this handles disease contraction.
			var/obj/item/bodypart/head/monkey_mouth = user.get_bodypart(BODY_ZONE_HEAD)
			var/damage = HAS_TRAIT(user, TRAIT_PERFECT_ATTACKER) ? monkey_mouth.unarmed_damage_high : rand(monkey_mouth.unarmed_damage_low, monkey_mouth.unarmed_damage_high)

			if(!damage)
				return FALSE
			if(check_block(user, damage, "the [user.name]"))
				return FALSE

			apply_damage(damage, BRUTE, affecting, run_armor_check(affecting, PUNCTURE))
		return TRUE

/mob/living/carbon/human/attack_alien(mob/living/carbon/alien/humanoid/user, list/modifiers)
	. = ..()
	if(!.)
		return

	if(LAZYACCESS(modifiers, RIGHT_CLICK)) //Always drop item in hand, if no item, get stun instead.
		var/obj/item/I = get_active_held_item()
		if(I && dropItemToGround(I))
			playsound(loc, 'sound/weapons/slash.ogg', 25, TRUE, -1)
			visible_message(span_danger("[user] disarms [src]!"), \
							span_userdanger("[user] disarms you!"), span_hear("You hear aggressive shuffling!"), null, user)
			to_chat(user, span_danger("You disarm [src]!"))
		else
			playsound(loc, 'sound/weapons/pierce.ogg', 25, TRUE, -1)
			Paralyze(100)
			log_combat(user, src, "tackled")
			visible_message(span_danger("[user] tackles [src] down!"), \
							span_userdanger("[user] tackles you down!"), span_hear("You hear aggressive shuffling followed by a loud thud!"), null, user)
			to_chat(user, span_danger("You tackle [src] down!"))
		return TRUE

	if(user.combat_mode)
		if (w_uniform)
			w_uniform.add_fingerprint(user)
		var/damage = prob(90) ? rand(user.melee_damage_lower, user.melee_damage_upper) : 0
		if(!damage)
			playsound(loc, 'sound/weapons/slashmiss.ogg', 50, TRUE, -1)
			visible_message(span_danger("[user] lunges at [src]!"), \
							span_userdanger("[user] lunges at you!"), span_hear("You hear a swoosh!"), null, user)
			to_chat(user, span_danger("You lunge at [src]!"))
			return FALSE
		var/obj/item/bodypart/affecting = get_bodypart(ran_zone(user.zone_selected))
		if(!affecting)
			affecting = get_bodypart(BODY_ZONE_CHEST)

		var/armor_block = run_armor_check(affecting, BLUNT,"","",10)

		playsound(loc, 'sound/weapons/slice.ogg', 25, TRUE, -1)
		visible_message(span_danger("[user] slashes at [src]!"), \
						span_userdanger("[user] slashes at you!"), span_hear("You hear a sickening sound of a slice!"), null, user)
		to_chat(user, span_danger("You slash at [src]!"))
		log_combat(user, src, "attacked")
		if(!dismembering_strike(user, user.zone_selected)) //Dismemberment successful
			return TRUE
		apply_damage(damage, BRUTE, affecting, armor_block)




/mob/living/carbon/human/attack_larva(mob/living/carbon/alien/larva/L)
	. = ..()
	if(!.)
		return //successful larva bite.
	var/damage = rand(L.melee_damage_lower, L.melee_damage_upper)
	if(!damage)
		return
	if(check_block(L, damage, "the [L.name]"))
		return FALSE
	if(stat != DEAD)
		L.amount_grown = min(L.amount_grown + damage, L.max_grown)
		var/obj/item/bodypart/affecting = get_bodypart(ran_zone(L.zone_selected))
		if(!affecting)
			affecting = get_bodypart(BODY_ZONE_CHEST)
		var/armor_block = run_armor_check(affecting, BLUNT)
		apply_damage(damage, BRUTE, affecting, armor_block)


/mob/living/carbon/human/attack_basic_mob(mob/living/basic/user, list/modifiers)
	. = ..()
	if(!.)
		return
	var/damage = rand(user.melee_damage_lower, user.melee_damage_upper)
	if(check_block(user, damage, "the [user.name]", MELEE_ATTACK, user.armor_penetration))
		return FALSE
	var/dam_zone = dismembering_strike(user, pick(BODY_ZONE_CHEST, BODY_ZONE_PRECISE_L_HAND, BODY_ZONE_PRECISE_R_HAND, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG))
	if(!dam_zone) //Dismemberment successful
		return TRUE
	var/obj/item/bodypart/affecting = get_bodypart(ran_zone(dam_zone))
	if(!affecting)
		affecting = get_bodypart(BODY_ZONE_CHEST)
	var/armor = run_armor_check(affecting, BLUNT, armor_penetration = user.armor_penetration)
	var/attack_direction = get_dir(user, src)
	apply_damage(damage, user.melee_damage_type, affecting, armor, sharpness = user.sharpness, attack_direction = attack_direction)

/mob/living/carbon/human/attack_slime(mob/living/simple_animal/slime/M)
	. = ..()
	if(!.) // slime attack failed
		return
	var/damage = rand(M.melee_damage_lower, M.melee_damage_upper)
	if(!damage)
		return
	if(M.is_adult)
		damage += rand(5, 10)

	if(check_block(M, damage, "the [M.name]"))
		return FALSE

	var/dam_zone = dismembering_strike(M, pick(BODY_ZONE_HEAD, BODY_ZONE_CHEST, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG))
	if(!dam_zone) //Dismemberment successful
		return TRUE

	var/obj/item/bodypart/affecting = get_bodypart(ran_zone(dam_zone))
	if(!affecting)
		affecting = get_bodypart(BODY_ZONE_CHEST)
	var/armor_block = run_armor_check(affecting, BLUNT)
	apply_damage(damage, BRUTE, affecting, armor_block)


/mob/living/carbon/human/ex_act(severity, target, origin)
	if(TRAIT_BOMBIMMUNE in dna.species.species_traits)
		return FALSE

	. = ..()
	if (!. || !severity || QDELETED(src))
		return
	var/brute_loss = 0
	var/burn_loss = 0
	var/bomb_armor = getarmor(null, BOMB)

//200 max knockdown for EXPLODE_HEAVY
//160 max knockdown for EXPLODE_LIGHT

	var/obj/item/organ/ears/ears = getorganslot(ORGAN_SLOT_EARS)
	switch (severity)
		if (EXPLODE_DEVASTATE)
			if(bomb_armor < EXPLODE_GIB_THRESHOLD) //gibs the mob if their bomb armor is lower than EXPLODE_GIB_THRESHOLD
				contents_explosion(EXPLODE_DEVASTATE)
				gib()
				return

			else
				brute_loss = 400
				var/atom/throw_target = get_edge_target_turf(src, get_dir(src, get_step_away(src, src)))
				throw_at(throw_target, 200, 4)
				damage_clothes(400 - bomb_armor, BRUTE, BOMB)
				Unconscious(15 SECONDS) //short amount of time for follow up attacks against elusive enemies like wizards

		if (EXPLODE_HEAVY)
			brute_loss = 60
			burn_loss = 60
			if(bomb_armor)
				brute_loss = 30*(2 - round(bomb_armor*0.01, 0.05))
				burn_loss = brute_loss //damage gets reduced from 120 to up to 60 combined brute+burn

			damage_clothes(200 - bomb_armor, BRUTE, BOMB)

			if (ears && !HAS_TRAIT_FROM(src, TRAIT_DEAF, CLOTHING_TRAIT))
				ears.adjustEarDamage(rand(15, 30), 120)

			if(prob(70))
				Unconscious(10 SECONDS) //short amount of time for follow up attacks against elusive enemies like wizards
			Knockdown(200 - (bomb_armor * 1.6)) //between ~4 and ~20 seconds of knockdown depending on bomb armor

		if(EXPLODE_LIGHT)
			brute_loss = 30

			if(bomb_armor)
				brute_loss = 15*(2 - round(bomb_armor*0.01, 0.05))

			damage_clothes(max(50 - bomb_armor, 0), BRUTE, BOMB)

			if (ears && !HAS_TRAIT_FROM(src, TRAIT_DEAF, CLOTHING_TRAIT))
				ears.adjustEarDamage(rand(10, 20), 60)

			Knockdown(160 - (bomb_armor * 1.6)) //100 bomb armor will prevent knockdown altogether

	take_overall_damage(brute_loss,burn_loss, sharpness = SHARP_EDGED|SHARP_POINTY)

	//attempt to dismember bodyparts
	if(severity >= EXPLODE_HEAVY || !bomb_armor)
		var/max_limb_loss = 0
		var/probability = 0
		switch(severity)
			if(EXPLODE_NONE)
				max_limb_loss = 1
				probability = 20
			if(EXPLODE_LIGHT)
				max_limb_loss = 2
				probability = 30
			if(EXPLODE_HEAVY)
				max_limb_loss = 3
				probability = 40
			if(EXPLODE_DEVASTATE)
				max_limb_loss = 4
				probability = 50

		for(var/obj/item/bodypart/BP as anything in bodyparts)
			if(prob(probability) && !prob(getarmor(BP, BOMB)) && BP.body_zone != BODY_ZONE_HEAD && BP.body_zone != BODY_ZONE_CHEST)
				BP.receive_damage(BP.max_damage)
				if(BP.owner)
					BP.dismember()
				max_limb_loss--
				if(!max_limb_loss)
					break

/mob/living/carbon/human/blob_act(obj/structure/blob/B)
	if(stat == DEAD)
		return
	show_message(span_userdanger("The blob attacks you!"))
	var/dam_zone = pick(BODY_ZONE_CHEST, BODY_ZONE_PRECISE_L_HAND, BODY_ZONE_PRECISE_R_HAND, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
	var/obj/item/bodypart/affecting = get_bodypart(ran_zone(dam_zone))
	apply_damage(5, BRUTE, affecting, run_armor_check(affecting, BLUNT))


///Calculates the siemens coeff based on clothing and species, can also restart hearts.
/mob/living/carbon/human/electrocute_act(shock_damage, siemens_coeff = 1, flags = SHOCK_HANDS, stun_multiplier = 1)
	//Calculates the siemens coeff based on clothing. Completely ignores the arguments
	if(flags & SHOCK_USE_AVG_SIEMENS)
		siemens_coeff = get_average_siemens_coeff()

	else if((flags & SHOCK_HANDS)) //This gets the siemens_coeff for all non tesla shocks
		if(gloves)
			siemens_coeff *= gloves.siemens_coefficient

	siemens_coeff *= physiology.siemens_coeff
	siemens_coeff *= dna.species.siemens_coeff

	. = ..()

	//Don't go further if the shock was blocked/too weak.
	if(!.)
		return

	//Note we both check that the user is in cardiac arrest and can actually heartattack
	//If they can't, they're missing their heart and this would runtime
	if(undergoing_cardiac_arrest() && !(flags & SHOCK_ILLUSION))
		if(shock_damage >= 1 && prob(25))
			var/obj/item/organ/heart/heart = getorganslot(ORGAN_SLOT_HEART)
			if(heart.Restart() && stat != DEAD)
				to_chat(src, span_obviousnotice("You feel your heart beating again!"))

	electrocution_animation(40)

/mob/living/carbon/human/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_CONTENTS)
		return

	for(var/obj/item/bodypart/L as anything in src.bodyparts)
		if(!IS_ORGANIC_LIMB(L))
			L.emp_act()

/mob/living/carbon/human/acid_act(acidpwr, acid_volume, bodyzone_hit, affect_clothing = TRUE, affect_body = TRUE) //todo: update this to utilize check_obscured_slots() //and make sure it's check_obscured_slots(TRUE) to stop aciding through visors etc
	var/list/damaged = list()
	var/list/inventory_items_to_kill = list()
	var/bodypart
	if(!bodyzone_hit || bodyzone_hit == BODY_ZONE_HEAD) //only if we didn't specify a zone or if that zone is the head.
		var/obj/item/clothing/head_clothes = null
		if(glasses)
			head_clothes = glasses
		if(wear_mask)
			head_clothes = wear_mask
		if(wear_neck)
			head_clothes = wear_neck
		if(head)
			head_clothes = head
		if(head_clothes)
			if(!(head_clothes.resistance_flags & UNACIDABLE) && affect_clothing)
				head_clothes.acid_act(acidpwr, acid_volume)
				update_worn_glasses()
				update_worn_mask()
				update_worn_neck()
				update_worn_head()
			else
				to_chat(src, span_notice("Your [head_clothes.name] protects your head and face from the acid!"))
		else
			bodypart = get_bodypart(BODY_ZONE_HEAD)
			if(bodypart)
				damaged += bodypart
			if(ears)
				inventory_items_to_kill += ears

	//CHEST//
	if(!bodyzone_hit || bodyzone_hit == BODY_ZONE_CHEST)
		var/obj/item/clothing/chest_clothes = null
		if(w_uniform)
			chest_clothes = w_uniform
		if(wear_suit)
			chest_clothes = wear_suit
		if(chest_clothes)
			if(!(chest_clothes.resistance_flags & UNACIDABLE) && affect_clothing)
				chest_clothes.acid_act(acidpwr, acid_volume)
				update_worn_undersuit()
				update_worn_oversuit()
			else
				to_chat(src, span_notice("Your [chest_clothes.name] protects your body from the acid!"))
		else
			bodypart = get_bodypart(BODY_ZONE_CHEST)
			if(bodypart)
				damaged += bodypart
			if(wear_id)
				inventory_items_to_kill += wear_id
			if(r_store)
				inventory_items_to_kill += r_store
			if(l_store)
				inventory_items_to_kill += l_store
			if(s_store)
				inventory_items_to_kill += s_store


	//ARMS & HANDS//
	if(!bodyzone_hit || bodyzone_hit == BODY_ZONE_L_ARM || bodyzone_hit == BODY_ZONE_R_ARM)
		var/obj/item/clothing/arm_clothes = null
		if(gloves)
			arm_clothes = gloves
		if(w_uniform && ((w_uniform.body_parts_covered & HANDS) || (w_uniform.body_parts_covered & ARMS)))
			arm_clothes = w_uniform
		if(wear_suit && ((wear_suit.body_parts_covered & HANDS) || (wear_suit.body_parts_covered & ARMS)))
			arm_clothes = wear_suit

		if(arm_clothes)
			if(!(arm_clothes.resistance_flags & UNACIDABLE) && affect_clothing)
				arm_clothes.acid_act(acidpwr, acid_volume)
				update_worn_gloves()
				update_worn_undersuit()
				update_worn_oversuit()
			else
				to_chat(src, span_notice("Your [arm_clothes.name] protects your arms and hands from the acid!"))
		else
			bodypart = get_bodypart(BODY_ZONE_R_ARM)
			if(bodypart)
				damaged += bodypart
			bodypart = get_bodypart(BODY_ZONE_L_ARM)
			if(.)
				damaged += bodypart


	//LEGS & FEET//
	if(!bodyzone_hit || bodyzone_hit == BODY_ZONE_L_LEG || bodyzone_hit == BODY_ZONE_R_LEG || bodyzone_hit == "feet")
		var/obj/item/clothing/leg_clothes = null
		if(shoes)
			leg_clothes = shoes
		if(w_uniform && ((w_uniform.body_parts_covered & FEET) || (bodyzone_hit != "feet" && (w_uniform.body_parts_covered & LEGS))))
			leg_clothes = w_uniform
		if(wear_suit && ((wear_suit.body_parts_covered & FEET) || (bodyzone_hit != "feet" && (wear_suit.body_parts_covered & LEGS))))
			leg_clothes = wear_suit
		if(leg_clothes)
			if(!(leg_clothes.resistance_flags & UNACIDABLE) && affect_clothing)
				leg_clothes.acid_act(acidpwr, acid_volume)
				update_worn_shoes()
				update_worn_undersuit()
				update_worn_oversuit()
			else
				to_chat(src, span_notice("Your [leg_clothes.name] protects your legs and feet from the acid!"))
		else
			bodypart = get_bodypart(BODY_ZONE_R_LEG)
			if(bodypart)
				damaged += bodypart
			bodypart = get_bodypart(BODY_ZONE_L_LEG)
			if(bodypart)
				damaged += bodypart

	//DAMAGE//
	if(affect_body)
		var/screamed
		var/affected_skin = FALSE
		var/exposure_coeff = (bodyzone_hit ? 1 : BODYPARTS_DEFAULT_MAXIMUM)
		var/damage = acidpwr * acid_volume / exposure_coeff
		for(var/obj/item/bodypart/affecting in damaged)
			damage *= (1 - get_permeability_protection(body_zone2cover_flags(affecting.body_zone)))
			if(!damage)
				continue

			affecting.receive_damage(damage, damage * 2, updating_health = FALSE, modifiers = NONE)
			affected_skin = TRUE
			if(prob(round(10 / exposure_coeff, 1)) && !screamed)
				emote("agony")
				screamed = TRUE

			if(affecting.body_zone == BODY_ZONE_HEAD && !HAS_TRAIT(src, TRAIT_DISFIGURED))
				if(prob(min(acidpwr*acid_volume, 90))) //Applies disfigurement
					emote("agony")
					facial_hairstyle = "Shaved"
					hairstyle = "Bald"
					update_body_parts()
					ADD_TRAIT(src, TRAIT_DISFIGURED, TRAIT_GENERIC)

		updatehealth()
		update_damage_overlays()
		if(affected_skin)
			to_chat(src, span_danger("The acid on your skin eats away at your flesh!"))

	if(affect_clothing)
		//MELTING INVENTORY ITEMS//
		//these items are all outside of armour visually, so melt regardless.
		if(!bodyzone_hit)
			if(back)
				inventory_items_to_kill += back
			if(belt)
				inventory_items_to_kill += belt

			inventory_items_to_kill += held_items

		for(var/obj/item/inventory_item in inventory_items_to_kill)
			inventory_item.acid_act(acidpwr, acid_volume)
	return TRUE

///Overrides the point value that the mob is worth
/mob/living/carbon/human/singularity_act()
	. = 20
	switch(mind?.assigned_role.title)
		if(JOB_CHIEF_ENGINEER, JOB_STATION_ENGINEER)
			. = 100
		if(JOB_CLOWN)
			if(!mind.miming)
				. = rand(-1000, 1000)
	..() //Called afterwards because getting the mind after getting gibbed is sketchy

/mob/living/carbon/human/help_shake_act(mob/living/carbon/helper)
	if(!istype(helper))
		return

	if(wear_suit)
		wear_suit.add_fingerprint(helper)
	else if(w_uniform)
		w_uniform.add_fingerprint(helper)

	return ..()

/mob/living/carbon/human/damage_clothes(damage_amount, damage_type = BRUTE, damage_flag = 0, def_zone)
	if(damage_type != BRUTE && damage_type != BURN)
		return
	damage_amount *= 0.5 //0.5 multiplier for balance reason, we don't want clothes to be too easily destroyed
	var/list/torn_items = list()

	//HEAD//
	if(!def_zone || def_zone == BODY_ZONE_HEAD)
		var/obj/item/clothing/head_clothes = null
		if(glasses)
			head_clothes = glasses
		if(wear_mask)
			head_clothes = wear_mask
		if(wear_neck)
			head_clothes = wear_neck
		if(head)
			head_clothes = head
		if(head_clothes)
			torn_items += head_clothes
		else if(ears)
			torn_items += ears

	//CHEST//
	if(!def_zone || def_zone == BODY_ZONE_CHEST)
		var/obj/item/clothing/chest_clothes = null
		if(w_uniform)
			chest_clothes = w_uniform
		if(wear_suit)
			chest_clothes = wear_suit
		if(chest_clothes)
			torn_items += chest_clothes

	//ARMS & HANDS//
	if(!def_zone || def_zone == BODY_ZONE_L_ARM || def_zone == BODY_ZONE_R_ARM)
		var/obj/item/clothing/arm_clothes = null
		if(gloves)
			arm_clothes = gloves
		if(w_uniform && ((w_uniform.body_parts_covered & HANDS) || (w_uniform.body_parts_covered & ARMS)))
			arm_clothes = w_uniform
		if(wear_suit && ((wear_suit.body_parts_covered & HANDS) || (wear_suit.body_parts_covered & ARMS)))
			arm_clothes = wear_suit
		if(arm_clothes)
			torn_items |= arm_clothes

	//LEGS & FEET//
	if(!def_zone || def_zone == BODY_ZONE_L_LEG || def_zone == BODY_ZONE_R_LEG)
		var/obj/item/clothing/leg_clothes = null
		if(shoes)
			leg_clothes = shoes
		if(w_uniform && ((w_uniform.body_parts_covered & FEET) || (w_uniform.body_parts_covered & LEGS)))
			leg_clothes = w_uniform
		if(wear_suit && ((wear_suit.body_parts_covered & FEET) || (wear_suit.body_parts_covered & LEGS)))
			leg_clothes = wear_suit
		if(leg_clothes)
			torn_items |= leg_clothes

	for(var/obj/item/I in torn_items)
		I.take_damage(damage_amount, damage_type, damage_flag, 0)

/**
 * Used by fire code to damage worn items.
 *
 * Arguments:
 * - delta_time
 * - times_fired
 * - stacks: Current amount of firestacks
 *
 */

/mob/living/carbon/human/proc/burn_clothing(delta_time, times_fired, stacks)
	var/list/burning_items = list()
	var/obscured = check_obscured_slots(TRUE)
	//HEAD//

	if(glasses && !(obscured & ITEM_SLOT_EYES))
		burning_items += glasses
	if(wear_mask && !(obscured & ITEM_SLOT_MASK))
		burning_items += wear_mask
	if(wear_neck && !(obscured & ITEM_SLOT_NECK))
		burning_items += wear_neck
	if(ears && !(obscured & ITEM_SLOT_EARS))
		burning_items += ears
	if(head)
		burning_items += head

	//CHEST//
	if(w_uniform && !(obscured & ITEM_SLOT_ICLOTHING))
		burning_items += w_uniform
	if(wear_suit)
		burning_items += wear_suit

	//ARMS & HANDS//
	var/obj/item/clothing/arm_clothes = null
	if(gloves && !(obscured & ITEM_SLOT_GLOVES))
		arm_clothes = gloves
	else if(wear_suit && ((wear_suit.body_parts_covered & HANDS) || (wear_suit.body_parts_covered & ARMS)))
		arm_clothes = wear_suit
	else if(w_uniform && ((w_uniform.body_parts_covered & HANDS) || (w_uniform.body_parts_covered & ARMS)))
		arm_clothes = w_uniform
	if(arm_clothes)
		burning_items |= arm_clothes

	//LEGS & FEET//
	var/obj/item/clothing/leg_clothes = null
	if(shoes && !(obscured & ITEM_SLOT_FEET))
		leg_clothes = shoes
	else if(wear_suit && ((wear_suit.body_parts_covered & FEET) || (wear_suit.body_parts_covered & LEGS)))
		leg_clothes = wear_suit
	else if(w_uniform && ((w_uniform.body_parts_covered & FEET) || (w_uniform.body_parts_covered & LEGS)))
		leg_clothes = w_uniform
	if(leg_clothes)
		burning_items |= leg_clothes

	for(var/obj/item/burning in burning_items)
		burning.fire_act((stacks * 25 * delta_time)) //damage taken is reduced to 2% of this value by fire_act()

/mob/living/carbon/human/update_fire_overlay(stacks, on_fire, last_icon_state, suffix = "")
	var/fire_icon = "generic_burning[suffix]"
	if(stacks > HUMAN_FIRE_STACK_ICON_NUM)
		if(dna && dna.species)
			fire_icon = "[dna.species.fire_overlay][suffix]"
		else
			fire_icon = "human_burning[suffix]"

	if(!GLOB.fire_appearances[fire_icon])
		var/mutable_appearance/new_fire_overlay = mutable_appearance('icons/mob/onfire.dmi', fire_icon, -FIRE_LAYER)
		new_fire_overlay.appearance_flags = RESET_COLOR
		GLOB.fire_appearances[fire_icon] = new_fire_overlay

	if((stacks > 0 && on_fire) || HAS_TRAIT(src, TRAIT_PERMANENTLY_ONFIRE))
		if(fire_icon == last_icon_state)
			return last_icon_state

		remove_overlay(FIRE_LAYER)
		overlays_standing[FIRE_LAYER] = GLOB.fire_appearances[fire_icon]
		apply_overlay(FIRE_LAYER)
		return fire_icon

	if(!last_icon_state)
		return last_icon_state

	remove_overlay(FIRE_LAYER)
	apply_overlay(FIRE_LAYER)
	return null

/mob/living/carbon/human/on_fire_stack(delta_time, times_fired, datum/status_effect/fire_handler/fire_stacks/fire_handler)
	SEND_SIGNAL(src, COMSIG_HUMAN_BURNING)
	burn_clothing(delta_time, times_fired, fire_handler.stacks)
	var/no_protection = FALSE
	if(dna && dna.species)
		no_protection = dna.species.handle_fire(src, delta_time, times_fired, no_protection)
	fire_handler.harm_human(delta_time, times_fired, no_protection)
