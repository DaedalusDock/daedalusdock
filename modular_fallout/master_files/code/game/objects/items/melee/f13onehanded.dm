// In this document: Onehanded templates, Swords, Knives, Clubs, Glove weapons, Tool weapons

/obj/item/melee //Melee weapon template
	attack_speed = CLICK_CD_MELEE
	max_integrity = 200
	armor = list(BLUNT = 0, PUNCTURE = 0, SLASH = 25, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 90, ACID = 50)

/obj/item/melee/onehanded
	name = "onehand melee template"
	desc = "should not exist"
	icon = 'modular_fallout/master_files/icons/fallout/objects/melee/melee.dmi'
	lefthand_file = 'modular_fallout/master_files/icons/fallout/onmob/weapons/melee1h_lefthand.dmi'
	righthand_file = 'modular_fallout/master_files/icons/fallout/onmob/weapons/melee1h_righthand.dmi'
	hitsound = 'modular_fallout/master_files/sound/weapons/bladeslice.ogg'
	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_BELT
	force = 30
	throwforce = 10
	w_class = WEIGHT_CLASS_NORMAL
	attack_verb_simple = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	resistance_flags = FIRE_PROOF

////////////
// SWORDS //
////////////		-block, 34-39 damage

/obj/item/melee/onehanded/machete
	name = "simple machete"
	desc = "A makeshift machete made of a lawn mower blade."
	icon_state = "machete_imp"
	inhand_icon_state  = "salvagedmachete"
	force = 34
	block_chance = 7
	throwforce = 20
	sharpness = SHARP_EDGED

/obj/item/melee/onehanded/machete/forgedmachete
	name = "machete"
	desc = "A forged machete made of high quality steel."
	icon_state = "machete"
	force = 35
	block_chance = 8

/obj/item/melee/onehanded/machete/training
	name = "training machete"
	desc = "A training machete made of tough wood."
	icon_state = "machete_training"
	force = 1
	throwforce = 5
	block_chance = 8

/obj/item/melee/onehanded/machete/training/attack(mob/living/M, mob/living/user)
	. = ..()
	if(!istype(M))
		return
	M.apply_damage(20, STAMINA, null, 0)

/obj/item/melee/onehanded/machete/gladius
	name = "gladius"
	desc = "A heavy cutting blade, made for war and mass produced in Legion territory."
	icon_state = "gladius"
	inhand_icon_state  = "gladius"
	force = 36
	block_chance = 10

/obj/item/melee/onehanded/machete/spatha
	name = "spatha"
	desc = "This long blade is favoured by Legion officers and leaders, a finely crafted weapon with good steel and hilt made from bronze and bone."
	icon_state = "spatha"
	inhand_icon_state  = "spatha"
	force = 38
	block_chance = 18

/obj/item/melee/onehanded/machete/spatha/longblade
	name = "forged claymore"
	desc = "A long one-handed blade sporting lovingly applied wraps and a wonderfully forged and engraved guard. The blade looks to be carefully sharpened."
	icon_state = "longblade"
	inhand_icon_state  = "longblade"
	force = 38
	block_chance = 18

/obj/item/melee/onehanded/machete/scrapsabre
	name = "scrap sabre"
	desc = "Made from materials found in the wastes, a skilled blacksmith has turned it into a thing of deadly beauty."
	icon_state = "scrapsabre"
	inhand_icon_state  = "scrapsabre"
	force = 37
	block_chance = 15

/obj/item/throwing_star/spear
	name = "throwing spear"
	desc = "An heavy hefty ancient weapon used to this day, due to its ease of lodging itself into its victim's body parts."
	lefthand_file = 'modular_fallout/master_files/icons/fallout/onmob/weapons/items_lefthand.dmi'
	righthand_file = 'modular_fallout/master_files/icons/fallout/onmob/weapons/items_righthand.dmi'
	icon_state = "throw_spear"
	inhand_icon_state  = "tribalspear"
	force = 20
	throwforce = 35
	armor_penetration = 10
	max_reach = 2
	item_flags = SLOWS_WHILE_IN_HAND
	slowdown = 0.3
	embedding = list("pain_mult" = 2, "embed_chance" = 60, "fall_chance" = 20)
	w_class = WEIGHT_CLASS_NORMAL



////////////
// KNIVES //
////////////		-small AP bonus, 24-31 damage

/obj/item/melee/onehanded/knife
	name = "knife template"
	desc = "should not exist"
	inhand_icon_state  = "knife"
	flags_1 = CONDUCT_1
	w_class = WEIGHT_CLASS_SMALL
	throwforce = 15
	hitsound = 'modular_fallout/master_files/sound/weapons/bladeslice.ogg'
	armor_penetration = 0.05
	throw_speed = 3
	throw_range = 6
	attack_verb_simple = list("slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	sharpness = SHARP_POINTY
	armor = list(BLUNT = 0, PUNCTURE = 0, SLASH = 25, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 50, ACID = 50)
	var/bayonet = FALSE	//Can this be attached to a gun?
	custom_materials = list(/datum/material/iron=6000)
	resistance_flags = FIRE_PROOF

/obj/item/melee/onehanded/knife/Initialize()
	. = ..()
	AddComponent(/datum/component/butchering, 80 - force, 100, force - 10) //bonus chance increases depending on force
	AddElement(/datum/element/eyestab)

/obj/item/melee/onehanded/knife/suicide_act(mob/user)
	user.visible_message(pick("<span class='suicide'>[user] is slitting [user.p_their()] wrists with the [src.name]! It looks like [user.p_theyre()] trying to commit suicide.</span>", \
						"<span class='suicide'>[user] is slitting [user.p_their()] throat with the [src.name]! It looks like [user.p_theyre()] trying to commit suicide.</span>", \
						"<span class='suicide'>[user] is slitting [user.p_their()] stomach open with the [src.name]! It looks like [user.p_theyre()] trying to commit seppuku.</span>"))
	return (BRUTELOSS)


/obj/item/melee/onehanded/knife/hunting
	name = "hunting knife"
	icon_state = "knife_hunting"
	desc = "Dependable hunting knife."
	embedding = list("pain_mult" = 4, "embed_chance" = 65, "fall_chance" = 10, "ignore_throwspeed_threshold" = TRUE)
	force = 27
	throwforce = 25
	attack_verb_simple = list("slashed", "stabbed", "sliced", "torn", "ripped", "cut")

/obj/item/melee/onehanded/knife/survival
	name = "survival knife"
	icon_state = "knife_survival"
	desc = "Multi-purpose knife with blackened steel."
	embedding = list("pain_mult" = 4, "embed_chance" = 35, "fall_chance" = 10)
	force = 27
	throwforce = 25

/obj/item/melee/onehanded/knife/bayonet
	name = "bayonet knife"
	icon_state = "knife_bayonet"
	desc = "This weapon is made for stabbing, not much use for other things."
	force = 26
	bayonet = TRUE

/obj/item/melee/onehanded/knife/bowie
	name = "bowie knife"
	icon_state = "knife_bowie"
	inhand_icon_state  = "knife_bowie"
	desc = "A large clip point fighting knife."
	force = 30
	throwforce = 25
	attack_verb_simple = list("slashed", "stabbed", "sliced", "shanked", "ripped", "lacerated")

/obj/item/melee/onehanded/knife/trench
	name = "trench knife"
	icon_state = "knife_trench"
	inhand_icon_state  = "knife_trench"
	desc = "This blade is designed for brutal close quarters combat."
	force = 31
	custom_materials = list(/datum/material/iron=8000)
	attack_verb_simple = list("slashed", "stabbed", "sliced", "shanked", "ripped", "lacerated")

/obj/item/melee/onehanded/knife/bone
	name = "bone dagger"
	inhand_icon_state  = "knife_bone"
	icon_state = "knife_bone"
	lefthand_file = 'icons/onmob/weapons/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/onmob/weapons/weapons/swords_righthand.dmi'
	desc = "A sharpened bone. The bare minimum in survival."
	embedding = list("pain_mult" = 4, "embed_chance" = 35, "fall_chance" = 10)
	force = 24
	throwforce = 20
	custom_materials = null

/obj/item/melee/onehanded/knife/ritualdagger
	name = "ritual dagger"
	desc = "An ancient blade used to carry out the spiritual rituals of the Wayfarer people."
	icon_state = "knife_ritual"
	inhand_icon_state  = "knife_ritual"
	force = 25
	armor_penetration = 10
	custom_materials = null

obj/item/melee/onehanded/knife/switchblade
	name = "switchblade"
	desc = "A sharp, concealable, spring-loaded knife."
	icon_state = "knife_switch"
	force = 3
	throwforce = 5
	hitsound = 'modular_fallout/master_files/sound/weapons/genhit.ogg'
	attack_verb_simple = list("stubbed", "poked")
	var/extended = 0
	var/extended_force = 24
	var/extended_throwforce = 23
	var/extended_icon_state = "knife_switch_ext"
	var/retracted_icon_state = "knife_switch"

/obj/item/melee/onehanded/knife/switchblade/Initialize()
	. = ..()
	AddComponent(/datum/component/butchering, 40, 105)

/obj/item/melee/onehanded/knife/switchblade/attack_self(mob/user)
	extended = !extended
	playsound(src.loc, 'modular_fallout/master_files/sound/weapons/batonextend.ogg', 50, 1)
	if(extended)
		force = extended_force
		w_class = WEIGHT_CLASS_NORMAL
		throwforce = extended_throwforce
		icon_state = extended_icon_state
		attack_verb_simple = list("slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
		hitsound = 'modular_fallout/master_files/sound/weapons/bladeslice.ogg'
		sharpness = SHARP_EDGED
	else
		force = initial(force)
		w_class = WEIGHT_CLASS_SMALL
		throwforce = initial(throwforce)
		icon_state = retracted_icon_state
		attack_verb_simple = list("stubbed", "poked")
		hitsound = 'modular_fallout/master_files/sound/weapons/genhit.ogg'
		sharpness = NONE

/obj/item/melee/onehanded/knife/cosmicdirty
	name = "dirty cosmic knife"
	desc = "A high-quality kitchen knife made from Saturnite alloy."
	icon_state = "knife_cosmic_dirty"
	inhand_icon_state  = "knife"
	force = 20
	throwforce = 10
	armor_penetration = 0

/obj/item/melee/onehanded/knife/cosmic
	name = "cosmic knife"
	desc = "A high-quality kitchen knife made from Saturnite alloy, this one seems to be in better condition."
	icon_state = "knife_cosmic"
	inhand_icon_state  = "knife"
	force = 25
	throwforce = 15
	armor_penetration = 10

/obj/item/melee/onehanded/knife/cosmicheated
	name = "superheated cosmic knife"
	desc = "A high-quality kitchen knife made from Saturnite alloy, this one looks like it has been heated to high temperatures."
	icon_state = "knife_cosmic_heated"
	inhand_icon_state  = "knife"
	damtype = BURN
	force = 35
	throwforce = 20
	armor_penetration = 20


///////////
// CLUBS //
///////////		- stamina damage, 26-30 damage

// Pipe
/obj/item/melee/onehanded/club
	name = "pipe"
	desc = "A piece of rusted metal pipe, good for smashing heads. "
	icon_state = "pipe"
	inhand_icon_state  = "pipe"
	attack_verb_simple = list("mashed", "bashed", "piped", "hit", "bludgeoned", "whacked", "bonked")
	force = 26
	throwforce = 10
	throw_speed = 3
	throw_range = 3
	sharpness = NONE
	slot_flags = ITEM_SLOT_BELT

/obj/item/melee/onehanded/club/attack(mob/living/M, mob/living/user)
	. = ..()
	if(!istype(M))
		return
	M.apply_damage(10, STAMINA, null, 0)

// War Club
/obj/item/melee/onehanded/club/warclub
	name = "war club"
	desc = "A simple carved wooden club with turquoise inlays."
	icon_state = "warclub"
	inhand_icon_state  = "warclub"
	attack_verb_simple = list("mashed", "bashed", "hit", "bludgeoned", "whacked")
	force = 30
	throwforce = 25
	block_chance = 5

/obj/item/melee/onehanded/club/warclub/attack(mob/living/M, mob/living/user)
	. = ..()
	if(!istype(M))
		return
	M.apply_damage(20, STAMINA, null, 0)

// Tire Iron
/obj/item/melee/onehanded/club/tireiron
	name = "tire iron"
	desc = "A rusty old tire iron, normally used for loosening nuts from car tires.<br>Though it has a short reach, it has decent damage and a fast swing."
	icon_state = "tire"
	inhand_icon_state  = "tire"
	force = 30

// NCR Flag			Keywords: NCR, Damage 26, Stamina damage, Block
/obj/item/melee/onehanded/club/ncrflag
	name = "NCR flagpole"
	desc = "The proud standard of the New California Republic. Used as a tool by patriots, used as a weapon by legends."
	icon_state = "flag-ncr"
	inhand_icon_state  = "flag-ncr"
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = null
	force = 26
	block_chance = 30
	attack_verb_simple = list("smacked", "thwacked", "democratized", "freedomed")
/*
// Classic Baton
/obj/item/melee/classic_baton
	name = "wooden baton"
	desc = "A wooden truncheon for beating criminal scum."
	icon = 'modular_fallout/master_files/icons/obj/items_and_weapons.dmi'
	icon_state = "baton"
	inhand_icon_state  = "classic_baton"
	lefthand_file = 'modular_fallout/master_files/icons/fallout/onmob/weapons/equipment/security_lefthand.dmi'
	righthand_file = 'modular_fallout/master_files/icons/fallout/onmob/weapons/equipment/security_righthand.dmi'
	slot_flags = ITEM_SLOT_BELT
	force = 18
	w_class = WEIGHT_CLASS_NORMAL
	var/stun_stam_cost_coeff = 1.25
	var/hardstun_ds = TRUE
	var/softstun_ds = 0
	var/stam_dmg = 30
	var/cooldown_check = 0 // Used internally, you don't want to modify
	var/cooldown = 13 // Default wait time until can stun again.
	var/stun_time_silicon = 60 // How long it stuns silicons for - 6 seconds.
	var/affect_silicon = FALSE // Does it stun silicons.
	var/on_sound // "On" sound, played when switching between able to stun or not.
	var/on_stun_sound = "sound/effects/woodhit.ogg" // Default path to sound for when we stun.
	var/stun_animation = TRUE // Do we animate the "hit" when stunning.
	var/on = TRUE // Are we on or off
	var/on_icon_state // What is our sprite when turned on
	var/off_icon_state // What is our sprite when turned off
	var/on_inhand_icon_state // What is our in-hand sprite when turned on
	var/force_on // Damage when on - not stunning
	var/force_off // Damage when off - not stunning
	var/weight_class_on // What is the new size class when turned on

/obj/item/melee/classic_baton/Initialize()
	. = ..()

// Description for trying to stun when still on cooldown.
/obj/item/melee/classic_baton/proc/get_wait_description()
	return

// Description for when turning their baton "on"
/obj/item/melee/classic_baton/proc/get_on_description()
	. = list()
	.["local_on"] = "<span class ='warning'>You extend the baton.</span>"
	.["local_off"] = "<span class ='notice'>You collapse the baton.</span>"
	return .

// Default message for stunning mob.
/obj/item/melee/classic_baton/proc/get_stun_description(mob/living/target, mob/living/user)
	. = list()
	.["visible"] =  "<span class ='danger'>[user] has knocked down [target] with [src]!</span>"
	.["local"] = "<span class ='danger'>[user] has knocked down [target] with [src]!</span>"
	return .

// Default message for stunning a silicon.
/obj/item/melee/classic_baton/proc/get_silicon_stun_description(mob/living/target, mob/living/user)
	. = list()
	.["visible"] = "<span class='danger'>[user] pulses [target]'s sensors with the baton!</span>"
	.["local"] = "<span class='danger'>You pulse [target]'s sensors with the baton!</span>"
	return .

// Are we applying any special effects when we stun to carbon
/obj/item/melee/classic_baton/proc/additional_effects_carbon(mob/living/target, mob/living/user)
	return

// Are we applying any special effects when we stun to silicon
/obj/item/melee/classic_baton/proc/additional_effects_silicon(mob/living/target, mob/living/user)
	return

/obj/item/melee/classic_baton/attack(mob/living/target, mob/living/user)
	if(!on)
		return ..()

	if(IS_STAMCRIT(user))//CIT CHANGE - makes batons unusuable in stamina softcrit
		to_chat(user, "<span class='warning'>You're too exhausted for that.</span>")//CIT CHANGE - ditto
		return //CIT CHANGE - ditto

	add_fingerprint(user)
	if((HAS_TRAIT(user, TRAIT_CLUMSY)) && prob(50))
		to_chat(user, "<span class ='danger'>You club yourself over the head.</span>")
		user.DefaultCombatKnockdown(60 * force)
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			H.apply_damage(2*force, BRUTE, BODY_ZONE_HEAD)
		else
			user.take_bodypart_damage(2*force)
		return
	if(iscyborg(target))
		if(user.a_intent != INTENT_HARM)	// We don't stun if we're on harm.
			if(affect_silicon)
				var/list/desc = get_silicon_stun_description(target, user)
				target.flash_act(affect_silicon = TRUE)
				target.Stun(stun_time_silicon)
				additional_effects_silicon(target, user)
				user.visible_message(desc["visible"], desc["local"])
				playsound(get_turf(src), on_stun_sound, 100, TRUE, -1)
				if(stun_animation)
					user.do_attack_animation(target)
			else
				..()
		else
			..()
		return
	if(!isliving(target))
		return
	if(user.a_intent == INTENT_HARM)
		if(!..() || !iscyborg(target))
			return
	else
		if(cooldown_check < world.time)
			if(target.mob_run_block(src, 0, "[user]'s [name]", ATTACK_TYPE_MELEE, 0, user, null, null) & BLOCK_SUCCESS)
				playsound(target, 'modular_fallout/master_files/sound/weapons/genhit.ogg', 50, 1)
				return
			if(ishuman(target) && !user.zone_selected ==	BODY_ZONE_L_LEG || !user.zone_selected == BODY_ZONE_R_LEG)
				var/mob/living/carbon/human/H = target
				if(check_martial_counter(H, user))
					return
			var/list/desc = get_stun_description(target, user)
			if(stun_animation)
				user.do_attack_animation(target)
			playsound(get_turf(src), on_stun_sound, 75, 1, -1)
			target.adjustStaminaLoss(30)
			additional_effects_carbon(target, user)
			add_fingerprint(user)
			target.visible_message(desc["visible"], desc["local"])
			if(!iscarbon(user))
				target.LAssailant = null
			else
				target.LAssailant = WEAKREF(user)
			cooldown_check = world.time + cooldown
			user.adjustStaminaLossBuffered(getweight(user, STAM_COST_BATON_MOB_MULT))
		else
			var/wait_desc = get_wait_description()
			if(wait_desc)
				to_chat(user, wait_desc)
			return DISCARD_LAST_ACTION

// Military baton - Desired effect instant disarm on hit on NCR when used by MP, could be sorted with a interesting martial art maybe.
/obj/item/melee/classic_baton/militarypolice
	name = "military baton"
	desc = "Sturdy stick painted white, used by military police to get unruly troopers into line."
	icon = 'modular_fallout/master_files/icons/fallout/objects/melee/melee.dmi'
	lefthand_file = 'modular_fallout/master_files/icons/fallout/onmob/weapons/melee1h_lefthand.dmi'
	righthand_file = 'modular_fallout/master_files/icons/fallout/onmob/weapons/melee1h_righthand.dmi'
	icon_state = "batonmp"
	inhand_icon_state  = "batonmp"


// Telescopic baton
/obj/item/melee/classic_baton/telescopic
	name = "telescopic baton"
	desc = "A compact yet robust personal defense weapon. Can be concealed when folded."
	icon = 'modular_fallout/master_files/icons/obj/items_and_weapons.dmi'
	icon_state = "telebaton_0"
	lefthand_file = 'modular_fallout/master_files/icons/fallout/onmob/weapons/weapons/melee_lefthand.dmi'
	righthand_file = 'modular_fallout/master_files/icons/fallout/onmob/weapons/weapons/melee_righthand.dmi'
	inhand_icon_state  = null
	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_SMALL
	item_flags = NONE
	force = 0
	on = FALSE
	on_sound = 'modular_fallout/master_files/sound/weapons/batonextend.ogg'
	on_icon_state = "telebaton_1"
	off_icon_state = "telebaton_0"
	on_inhand_icon_state = "nullrod"
	force_on = 10
	force_off = 0
	weight_class_on = WEIGHT_CLASS_BULKY
	total_mass = TOTAL_MASS_NORMAL_ITEM

/obj/item/melee/classic_baton/telescopic/suicide_act(mob/user)
	var/mob/living/carbon/human/H = user
	var/obj/item/organ/brain/B = H.getorgan(/obj/item/organ/brain)

	user.visible_message("<span class='suicide'>[user] stuffs [src] up [user.p_their()] nose and presses the 'extend' button! It looks like [user.p_theyre()] trying to clear [user.p_their()] mind.</span>")
	if(!on)
		src.attack_self(user)
	else
		playsound(loc, on_sound, 50, 1)
		add_fingerprint(user)
	sleep(3)
	if (H && !QDELETED(H))
		if (B && !QDELETED(B))
			H.internal_organs -= B
			qdel(B)
		H.spawn_gibs()
		return (BRUTELOSS)

/obj/item/melee/classic_baton/telescopic/attack_self(mob/user)
	on = !on
	var/list/desc = get_on_description()
	if(on)
		to_chat(user, desc["local_on"])
		icon_state = on_icon_state
		inhand_icon_state  = on_inhand_icon_state
		w_class = weight_class_on
		force = force_on
		attack_verb_simple = list("smacked", "struck", "cracked", "beaten")
	else
		to_chat(user, desc["local_off"])
		icon_state = off_icon_state
		inhand_icon_state  = null //no sprite for concealment even when in hand
		slot_flags = ITEM_SLOT_BELT
		w_class = WEIGHT_CLASS_SMALL
		force = force_off
		attack_verb_simple = list("hit", "poked")
	playsound(loc, on_sound, 50, TRUE)
	add_fingerprint(user)

*/

// Slave whip
/obj/item/melee/onehanded/slavewhip
	name = "slave whip"
	desc = "Corded leather strips turned into a instrument of pain. Cracks ominously when a skilled wielder uses it."
	icon_state = "whip"
	inhand_icon_state  = "chain"
	force = 10
	sharpness = SHARP_EDGED
	attack_verb_simple = list("flogged", "whipped", "lashed", "disciplined")
	hitsound = 'modular_fallout/master_files/sound/weapons/whip.ogg'

/obj/item/melee/onehanded/slavewhip/attack(mob/living/M, mob/living/user)
	. = ..()
	if(!istype(M))
		return
	M.apply_damage(20, STAMINA, null, 0)

///////////////////
// GLOVE WEAPONS //
///////////////////		-faster attack speed

/*
/obj/item/melee/unarmed
	name = "glove weapon template"
	desc = "should not be here"
	icon = 'modular_fallout/master_files/icons/fallout/objects/melee/melee.dmi'
	lefthand_file = 'modular_fallout/master_files/icons/fallout/onmob/weapons/melee1h_lefthand.dmi'
	righthand_file = 'modular_fallout/master_files/icons/fallout/onmob/weapons/melee1h_righthand.dmi'
	attack_speed = CLICK_CD_MELEE * 0.9
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_GLOVES
	w_class = WEIGHT_CLASS_SMALL
	flags_1 = CONDUCT_1
	sharpness = SHARP_NONE
	throwforce = 10
	throw_range = 5
	attack_verb_simple = list("punched", "jabbed", "whacked")
	var/can_adjust_unarmed = TRUE
	var/unarmed_adjusted = TRUE

/obj/item/melee/unarmed/equipped(mob/user, slot)
	. = ..()
	var/mob/living/carbon/human/H = user
	if(unarmed_adjusted)
		mob_overlay_icon = righthand_file
	if(!unarmed_adjusted)
		mob_overlay_icon = lefthand_file
	if(ishuman(user) && slot == SLOT_GLOVES)
		ADD_TRAIT(user, TRAIT_UNARMED_WEAPON, "glove")
		if(HAS_TRAIT(user, TRAIT_UNARMED_WEAPON))
			H.dna.species.punchdamagehigh = force + 8 //The +8 damage is what brings up your punch damage to the unarmed weapon's force fully
			H.dna.species.punchdamagelow = force + 8
			H.dna.species.attack_sound = hitsound
			if(sharpness == SHARP_POINTY || sharpness ==  SHARP_EDGED)
				H.dna.species.attack_verb_simple = pick("slash","slice","rip","tear","cut","dice")
			if(sharpness == SHARP_NONE)
				H.dna.species.attack_verb_simple = pick("punch","jab","whack")
	if(ishuman(user) && slot != SLOT_GLOVES && !H.gloves)
		REMOVE_TRAIT(user, TRAIT_UNARMED_WEAPON, "glove")
		if(!HAS_TRAIT(user, TRAIT_UNARMED_WEAPON))
			H.dna.species.punchdamagehigh = 1
			H.dna.species.punchdamagelow = 10
		if(HAS_TRAIT(user, TRAIT_IRONFIST))
			H.dna.species.punchdamagehigh = 4
			H.dna.species.punchdamagelow = 11
		H.dna.species.attack_sound = 'modular_fallout/master_files/sound/weapons/punch1.ogg'
		H.dna.species.attack_verb_simple = "punch"

/obj/item/melee/unarmed/examine(mob/user)
	. = ..()
	if(can_adjust_unarmed == TRUE)
		if(unarmed_adjusted == TRUE)
			. += "<span class='notice'>Alt-click on [src] to wear it on a different hand. You must take it off first, then put it on again.</span>"
		else
			. += "<span class='notice'>Alt-click on [src] to wear it on a different hand. You must take it off first, then put it on again.</span>"

/obj/item/melee/unarmed/AltClick(mob/user)
	. = ..()
	if(!istype(user) || !user.canUseTopic(src, BE_CLOSE, ishuman(user)))
		return
	if(can_adjust_unarmed == TRUE)
		toggle_unarmed_adjust()

/obj/item/melee/unarmed/proc/toggle_unarmed_adjust()
	unarmed_adjusted = !unarmed_adjusted
	to_chat(usr, "<span class='notice'>[src] is ready to be worn on another hand.</span>")


// Brass knuckles	Keywords: Damage 23
/obj/item/melee/unarmed/brass
	name = "brass knuckles"
	desc = "Hardened knuckle grip that is actually made out of steel. They protect your hand, and do more damage, in unarmed combat."
	icon_state = "brass"
	inhand_icon_state  = "brass"
	attack_verb_simple = list("punched", "jabbed", "whacked")
	force = 24

// Spiked knuckles	Keywords: Damage 24
/obj/item/melee/unarmed/brass/spiked
	name = "spiked knuckes"
	desc = "Unlike normal brass knuckles, these have a metal plate across the knuckles with four spikes on, one for each knuckle. So not only does the victim feel the force of the punch, but also the devastating effects of spikes being driven in."
	icon_state = "spiked"
	inhand_icon_state  = "spiked"
	sharpness = SHARP_POINTY
	force = 25

// Sappers			Keywords: Damage 26
/obj/item/melee/unarmed/sappers
	name = "sappers"
	desc = "Lead filled gloves which are ideal for beating the crap out of opponents."
	icon_state = "sapper"
	inhand_icon_state  = "sapper"
	w_class = WEIGHT_CLASS_NORMAL
	force = 26

// Tiger claws		Keywords: Damage 28, Pointy
/obj/item/melee/unarmed/tigerclaw
	name = "tiger claws"
	desc = "Gloves with short claws built into the palms."
	icon_state = "tiger_claw"
	inhand_icon_state  = "tiger_claw"
	w_class = WEIGHT_CLASS_NORMAL
	attack_verb_simple = list("slashed", "sliced", "torn", "ripped", "diced", "cut")
	sharpness = SHARP_POINTY
	force = 28
	hitsound = 'modular_fallout/master_files/sound/weapons/bladeslice.ogg'

// Lacerator		Keywords: Damage 27, Edged, Wound bonus
/obj/item/melee/unarmed/lacerator
	name = "lacerator"
	desc = "Leather gloves with razor blades built into the back of the hand."
	icon_state = "lacerator"
	inhand_icon_state  = "lacerator"
	w_class = WEIGHT_CLASS_NORMAL
	force = 27
	sharpness = SHARP_EDGED
	attack_verb_simple = list("slashed", "sliced", "torn", "ripped", "diced", "cut")
	hitsound = 'modular_fallout/master_files/sound/weapons/bladeslice.ogg'

// Mace Glove		Keywords: Damage 31
/obj/item/melee/unarmed/maceglove
	name = "mace glove"
	desc = "Weighted metal gloves that are covered in spikes.  Don't expect to grab things with this."
	icon_state = "mace_glove"
	inhand_icon_state  = "mace_glove"
	w_class = WEIGHT_CLASS_BULKY
	force = 31
	sharpness = SHARP_NONE

// Punch Dagger		Keywords: Damage 29, Pointy
/obj/item/melee/unarmed/punchdagger
	name = "punch dagger"
	desc = "A dagger designed to be gripped in the user�s fist with the blade protruding between the middle and ring fingers, to increase the penetration of a punch."
	icon_state = "punch_dagger"
	inhand_icon_state  = "punch_dagger"
	force = 29
	sharpness = SHARP_POINTY
	attack_verb_simple = list("stabbed", "sliced", "pierced", "diced", "cut")
	hitsound = 'modular_fallout/master_files/sound/weapons/bladeslice.ogg'

// Deathclaw Gauntlet	Keywords: Damage 28, AP 1
/obj/item/melee/unarmed/deathclawgauntlet
	name = "deathclaw gauntlet"
	desc = "The severed hand of a mighty Deathclaw, cured, hollowed out, and given a harness to turn it into the deadliest gauntlet the wastes have ever seen."
	icon_state = "deathclaw_g"
	inhand_icon_state  = "deathclaw_g"
	slot_flags = ITEM_SLOT_GLOVES
	w_class = WEIGHT_CLASS_NORMAL
	force = 28
	armor_penetration = 1
	sharpness = SHARP_EDGED
	attack_verb_simple = list("slashed", "sliced", "torn", "ripped", "diced", "cut")
	hitsound = 'modular_fallout/master_files/sound/weapons/bladeslice.ogg'

*/

///////////
// TOOLS //
///////////		-generally max 24 damage


// Frying pan
/obj/item/melee/onehanded/club/fryingpan
	name = "frying pan"
	desc = "An ancient cast iron frying pan.<br>It's heavy, but fairly useful if you need to keep the mutants away, and don't have a better weapon around."
	icon_state = "pan"
	inhand_icon_state  = "pan"
	force = 24 //Just try to swing a frying pan//BONK
	throw_speed = 1
	throw_range = 3
	throwforce = 20
	hitsound = 'modular_fallout/master_files/sound/f13weapons/pan.ogg'

// Entrenching tool P81
/obj/item/shovel/trench
	name = "p81 entrenching tool"
	desc = "The 'Pattern 2281' Entrenching Tool is a new piece of infantry equipment given in limited quantity to infantry troops. An extremely robust shovel with a serrated edge for chopping wood."
	icon = 'modular_fallout/master_files/icons/fallout/objects/melee/melee.dmi'
	lefthand_file = 'modular_fallout/master_files/icons/fallout/onmob/weapons/melee1h_lefthand.dmi'
	righthand_file = 'modular_fallout/master_files/icons/fallout/onmob/weapons/melee1h_righthand.dmi'
	icon_state = "entrenching_tool"
	inhand_icon_state  = "trench"
	w_class = WEIGHT_CLASS_NORMAL
	force = 30
	throwforce = 15
	toolspeed = 0.7
	sharpness = SHARP_EDGED
	attack_verb_simple = list("cleaved", "chopped", "sliced", "slashed")

// Hatchet
/obj/item/hatchet
	name = "hatchet"
	desc = "Simple small metal axehead on a handle made from wood or some other hard material."
	icon = 'modular_fallout/master_files/icons/obj/items_and_weapons.dmi'
	icon_state = "hatchet"
	inhand_icon_state  = "hatchet"
	lefthand_file = 'modular_fallout/master_files/icons/fallout/onmob/weapons/equipment/hydroponics_lefthand.dmi'
	righthand_file = 'modular_fallout/master_files/icons/fallout/onmob/weapons/equipment/hydroponics_righthand.dmi'
	attack_speed = CLICK_CD_MELEE
	flags_1 = CONDUCT_1
	force = 24
	w_class = WEIGHT_CLASS_SMALL
	throwforce = 15
	throw_speed = 3
	throw_range = 4
	custom_materials = list(/datum/material/iron = 6000)
	attack_verb_simple = list("chopped", "torn", "cut")
	hitsound = 'modular_fallout/master_files/sound/weapons/bladeslice.ogg'
	sharpness = SHARP_EDGED

/obj/item/hatchet/Initialize()
	. = ..()
	AddComponent(/datum/component/butchering, 70, 100)

/obj/item/hatchet/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is chopping at [user.p_them()]self with [src]! It looks like [user.p_theyre()] trying to commit suicide!</span>")
	playsound(src, 'modular_fallout/master_files/sound/weapons/bladeslice.ogg', 50, 1, -1)
	return (BRUTELOSS)

// Wrench				Force 12
// Crowbar				Force 15
// Kitchen knife		Force 15
// Rolling pin			Force x


/*
CODE ARCHIVE MELEE

CODE FOR BLEEDING STACK
/obj/item/kitchen/knife/bloodletter/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(!isliving(target) || !proximity_flag)
		return
	var/mob/living/M = target
	if(!(M.mob_biotypes & MOB_ORGANIC))
		return
	var/datum/status_effect/stacking/saw_bleed/bloodletting/B = M.has_status_effect(/datum/status_effect/stacking/saw_bleed/bloodletting)
	if(!B)
		M.apply_status_effect(/datum/status_effect/stacking/saw_bleed/bloodletting, bleed_stacks_per_hit)
	else
		B.add_stacks(bleed_stacks_per_hit)
*/


// BETA // Obsolete

/obj/item/melee/onehanded/machete/knifetesting
	name = "testing knife"
	icon_state = "knife_bowie"
	inhand_icon_state  = "knife_bowie"
	force = 18
	throwforce = 15

/obj/item/melee/onehanded/machete/clubtesting
	name = "1hgeneric"
	icon_state = "tire"
	inhand_icon_state  = "tire"
	force = 20

/obj/item/melee/onehanded/machete/swordtesting
	name = "topmelee"
	icon_state = "machete_imp"
	inhand_icon_state  = "salvagedmachete"
	force = 30
