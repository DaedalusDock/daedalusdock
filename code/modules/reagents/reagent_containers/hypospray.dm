/obj/item/reagent_containers/hypospray
	name = "hypospray"
	desc = "The DeForest Medical Corporation hypospray is a sterile, air-needle autoinjector for rapid administration of drugs to patients."
	icon = 'icons/obj/syringe.dmi'
	inhand_icon_state = "hypo"
	worn_icon_state = "hypo"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	icon_state = "hypo"
	worn_icon_state = "hypo"
	amount_per_transfer_from_this = 5
	volume = 30
	possible_transfer_amounts = list(5)
	resistance_flags = ACID_PROOF
	reagent_flags = OPENCONTAINER
	slot_flags = ITEM_SLOT_BELT

	var/ignore_flags = NONE
	var/infinite = FALSE
	var/time = 0

/obj/item/reagent_containers/hypospray/attack_paw(mob/user, list/modifiers)
	return attack_hand(user, modifiers)

/obj/item/reagent_containers/hypospray/attack(mob/living/affected_mob, mob/user)
	inject(affected_mob, user)

///Handles all injection checks, injection and logging.
/obj/item/reagent_containers/hypospray/proc/inject(mob/living/affected_mob, mob/user)
	if(!reagents.total_volume)
		to_chat(user, span_warning("[src] is empty!"))
		return FALSE
	if(!iscarbon(affected_mob))
		return FALSE

	//Always log attemped injects for admins
	var/list/injected = list()
	for(var/datum/reagent/injected_reagent in reagents.reagent_list)
		injected += injected_reagent.name
	var/contained = english_list(injected)

	log_combat(user, affected_mob, "attempted to inject", src, "([contained])")

	if(!reagents.total_volume)
		return FALSE

	if(!inject_check(user, affected_mob))
		return FALSE

	playsound(src, 'sound/effects/autoinjector.ogg', 25)
	user.changeNext_move(CLICK_CD_RAPID)

	if(time && user != affected_mob && !affected_mob.incapacitated())
		if(!do_after(user, affected_mob, time, DO_PUBLIC|DO_RESTRICT_USER_DIR_CHANGE, extra_checks = CALLBACK(src, PROC_REF(inject_check), user, affected_mob), interaction_key = src, display = src))
			return FALSE

	affected_mob.apply_pain(1, BODY_ZONE_CHEST, "You feel a tiny prick.")

	if(user == affected_mob)
		user.visible_message(span_notice("<b>[user]</b> jabs [src] into <b>[user.p_them()]self</b>."), vision_distance = COMBAT_MESSAGE_RANGE)
	else
		user.do_attack_animation(affected_mob, used_item = src, do_hurt = FALSE)
		user.visible_message(span_notice("<b>[user]</b> jabs [src] into <b>[affected_mob]</b>."), vision_distance = COMBAT_MESSAGE_RANGE)

	var/fraction = min(amount_per_transfer_from_this/reagents.total_volume, 1)

	if(affected_mob.reagents)
		var/trans = 0
		if(!infinite)
			trans = reagents.trans_to(affected_mob, amount_per_transfer_from_this, transfered_by = user, methods = INJECT)
		else
			reagents.expose(affected_mob, INJECT, fraction)
			trans = reagents.copy_to(affected_mob, amount_per_transfer_from_this)
		to_chat(user, span_obviousnotice("[trans] unit\s injected. [reagents.total_volume] unit\s remaining in [src]."))
		log_combat(user, affected_mob, "injected", src, "([contained])")
	return TRUE


/obj/item/reagent_containers/hypospray/proc/inject_check(mob/living/user, mob/living/affected_mob)
	return ignore_flags || affected_mob.try_inject(user, injection_flags = INJECT_TRY_SHOW_ERROR_MESSAGE)

/obj/item/reagent_containers/hypospray/cmo
	list_reagents = list(/datum/reagent/medicine/tricordrazine = 30)
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF

//combat

/obj/item/reagent_containers/hypospray/combat
	name = "combat stimulant injector"
	desc = "A modified air-needle autoinjector, used by support operatives to quickly heal injuries in combat."
	amount_per_transfer_from_this = 10
	inhand_icon_state = "combat_hypo"
	icon_state = "combat_hypo"
	volume = 90
	possible_transfer_amounts = list(5,10)
	ignore_flags = 1 // So they can heal their comrades.
	list_reagents = list(/datum/reagent/medicine/epinephrine = 30, /datum/reagent/medicine/tricordrazine = 30, /datum/reagent/medicine/leporazine = 15, /datum/reagent/medicine/atropine = 15)

/obj/item/reagent_containers/hypospray/combat/nanites
	name = "experimental combat stimulant injector"
	desc = "A modified air-needle autoinjector for use in combat situations. Prefilled with experimental medical nanites and a stimulant for rapid healing and a combat boost."
	inhand_icon_state = "nanite_hypo"
	icon_state = "nanite_hypo"
	base_icon_state = "nanite_hypo"
	volume = 100
	list_reagents = list(/datum/reagent/medicine/adminordrazine/quantum_heal = 80, /datum/reagent/medicine/synaptizine = 20)

/obj/item/reagent_containers/hypospray/combat/nanites/update_icon_state()
	icon_state = "[base_icon_state][(reagents.total_volume > 0) ? null : 0]"
	return ..()

/obj/item/reagent_containers/hypospray/combat/heresypurge
	name = "holy water piercing injector"
	desc = "A modified air-needle autoinjector for use in combat situations. Prefilled with 5 doses of a holy water and pacifier mixture. Not for use on your teammates."
	inhand_icon_state = "holy_hypo"
	icon_state = "holy_hypo"
	volume = 250
	possible_transfer_amounts = list(25,50)
	list_reagents = list(/datum/reagent/water/holywater = 150, /datum/reagent/cryptobiolin = 50)
	amount_per_transfer_from_this = 50

//MediPens

/obj/item/reagent_containers/hypospray/medipen
	name = "emergency autoinjector"
	desc = "A device for simple subcutaneous injection of chemicals."
	icon_state = "medipen"
	inhand_icon_state = "medipen"
	worn_icon_state = "medipen"
	base_icon_state = "medipen"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'

	time = 1.5 SECOND

	amount_per_transfer_from_this = 30
	volume = 30
	reagent_flags = DRAWABLE
	flags_1 = null

	list_reagents = list(
		/datum/reagent/medicine/inaprovaline = 10,
		/datum/reagent/medicine/peridaxon = 10,
		/datum/reagent/medicine/coagulant = 5,
		/datum/reagent/medicine/adenosine = 5,
	)

	custom_price = PAYCHECK_MEDIUM
	custom_premium_price = PAYCHECK_HARD

/obj/item/reagent_containers/hypospray/medipen/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user] begins to choke on \the [src]! It looks like [user.p_theyre()] trying to commit suicide!"))
	return OXYLOSS//ironic. he could save others from oxyloss, but not himself.

/obj/item/reagent_containers/hypospray/medipen/inject(mob/living/affected_mob, mob/user)
	. = ..()
	if(.)
		reagents.maximum_volume = 0 //Makes them useless afterwards
		reagents.flags = NONE
		update_appearance()

/obj/item/reagent_containers/hypospray/medipen/attack_self(mob/user)
	if(user.canUseTopic(src, USE_CLOSE|USE_IGNORE_TK|USE_RESTING))
		inject(user, user)

/obj/item/reagent_containers/hypospray/medipen/update_icon_state()
	icon_state = "[base_icon_state][(reagents.total_volume > 0) ? null : 0]"
	return ..()

/obj/item/reagent_containers/hypospray/medipen/examine()
	. = ..()
	if(reagents?.reagent_list.len)
		. += span_notice("It is currently loaded.")
	else
		. += span_notice("It is spent.")

/obj/item/reagent_containers/hypospray/medipen/stimpack //goliath kiting
	name = "stimpack autoinjector"
	desc = "A rapid way to stimulate your body's adrenaline, allowing for freer movement in restrictive armor."
	icon_state = "stimpen"
	inhand_icon_state = "stimpen"
	base_icon_state = "stimpen"
	volume = 20
	amount_per_transfer_from_this = 20
	list_reagents = list(/datum/reagent/medicine/ephedrine = 10, /datum/reagent/consumable/coffee = 10)

/obj/item/reagent_containers/hypospray/medipen/stimpack/traitor
	desc = "A modified stimulants autoinjector for use in combat situations. Has a mild healing effect."
	list_reagents = list(/datum/reagent/stimulants = 10, /datum/reagent/medicine/tricordrazine = 10)

/obj/item/reagent_containers/hypospray/medipen/stimulants
	name = "stimulant autoinjector"
	desc = "Contains a very large amount of an incredibly powerful stimulant, vastly increasing your movement speed and reducing stuns by a very large amount for around five minutes. Do not take if pregnant."
	icon_state = "syndipen"
	inhand_icon_state = "tbpen"
	base_icon_state = "syndipen"
	volume = 50
	amount_per_transfer_from_this = 50
	list_reagents = list(/datum/reagent/stimulants = 50)

/obj/item/reagent_containers/hypospray/medipen/morphine
	name = "morphine autoinjector"
	desc = "A rapid way to get you out of a tight situation and fast! You'll feel rather drowsy, though."
	icon_state = "morphen"
	inhand_icon_state = "morphen"
	base_icon_state = "morphen"
	list_reagents = list(/datum/reagent/medicine/morphine = 10)

/obj/item/reagent_containers/hypospray/medipen/dermaline
	name = "dermaline autoinjector"
	desc = "An autoinjector containing dermaline, used to treat severe burns."
	icon_state = "oxapen"
	inhand_icon_state = "oxapen"
	base_icon_state = "oxapen"
	list_reagents = list(/datum/reagent/medicine/dermaline = 10)

/obj/item/reagent_containers/hypospray/medipen/meralyne
	name = "meralyne autoinjector"
	desc = "An autoinjector containing meralyne, used to treat severe brute damage."
	icon_state = "salacid"
	inhand_icon_state = "salacid"
	base_icon_state = "salacid"
	list_reagents = list(/datum/reagent/medicine/meralyne = 10)

/obj/item/reagent_containers/hypospray/medipen/dexalin
	name = "dexalin autoinjector"
	desc = "An autoinjector containing dexalin, used to heal oxygen damage quickly."
	icon_state = "salpen"
	inhand_icon_state = "salpen"
	base_icon_state = "salpen"
	list_reagents = list(/datum/reagent/medicine/dexalin = 10)

/obj/item/reagent_containers/hypospray/medipen/dylovene
	name = "dylovene autoinjector"
	desc = "An autoinjector containing dylovene, used to heal toxin damage quickly."
	icon_state = "salpen"
	inhand_icon_state = "salpen"
	base_icon_state = "salpen"
	list_reagents = list(/datum/reagent/medicine/dylovene = 10)

/obj/item/reagent_containers/hypospray/medipen/tuberculosiscure
	name = "BVAK autoinjector"
	desc = "Bio Virus Antidote Kit autoinjector. Has a two use system for yourself, and someone else. Inject when infected."
	icon_state = "tbpen"
	inhand_icon_state = "tbpen"
	base_icon_state = "tbpen"
	volume = 20
	amount_per_transfer_from_this = 10
	list_reagents = list(/datum/reagent/vaccine/fungal_tb = 20)

/obj/item/reagent_containers/hypospray/medipen/tuberculosiscure/update_icon_state()
	. = ..()
	if(reagents.total_volume >= volume)
		icon_state = base_icon_state
		return
	icon_state = "[base_icon_state][(reagents.total_volume > 0) ? 1 : 0]"

/obj/item/reagent_containers/hypospray/medipen/survival
	name = "survival emergency autoinjector"
	desc = "A medipen for surviving in the harsh environments, heals most common damage sources. WARNING: May cause organ damage."
	icon_state = "stimpen"
	inhand_icon_state = "stimpen"
	base_icon_state = "stimpen"
	volume = 30
	amount_per_transfer_from_this = 30
	list_reagents = list(/datum/reagent/medicine/synaptizine = 4, /datum/reagent/medicine/dermaline = 8, /datum/reagent/medicine/meralyne = 8, /datum/reagent/medicine/leporazine = 6)

/obj/item/reagent_containers/hypospray/medipen/survival/inject(mob/living/affected_mob, mob/user)
	if(DOING_INTERACTION(user, DOAFTER_SOURCE_SURVIVALPEN))
		to_chat(user,span_notice("You are too busy to use \the [src]!"))
		return

	to_chat(user,span_notice("You start manually releasing the low-pressure gauge..."))
	if(!do_after(user, affected_mob, 10 SECONDS, interaction_key = DOAFTER_SOURCE_SURVIVALPEN))
		return

	amount_per_transfer_from_this = initial(amount_per_transfer_from_this) * 0.5
	return ..()


/obj/item/reagent_containers/hypospray/medipen/survival/luxury
	name = "luxury autoinjector"
	desc = "Cutting edge technology allowed humanity to compact 50u of volume into a single medipen. Contains rare and powerful chemicals used to aid in exploration of very hard enviroments."
	icon_state = "luxpen"
	inhand_icon_state = "atropen"
	base_icon_state = "luxpen"
	volume = 50
	amount_per_transfer_from_this = 50
	list_reagents = list(/datum/reagent/medicine/dexalin = 10, /datum/reagent/medicine/meralyne = 10, /datum/reagent/medicine/dermaline = 10, /datum/reagent/medicine/tricordrazine = 10 ,/datum/reagent/medicine/leporazine = 10)

/obj/item/reagent_containers/hypospray/medipen/atropine
	name = "atropine autoinjector"
	desc = "A rapid way to save a person from a critical injury state!"
	icon_state = "atropen"
	inhand_icon_state = "atropen"
	base_icon_state = "atropen"
	list_reagents = list(/datum/reagent/medicine/atropine = 10)

/obj/item/reagent_containers/hypospray/medipen/pumpup
	name = "maintenance pump-up"
	desc = "A ghetto looking autoinjector filled with a cheap adrenaline shot... Great for shrugging off the effects of stunbatons."
	volume = 15
	amount_per_transfer_from_this = 15
	list_reagents = list(/datum/reagent/drug/pumpup = 15)
	icon_state = "maintenance"
	base_icon_state = "maintenance"

/obj/item/reagent_containers/hypospray/medipen/ekit
	name = "emergency first-aid autoinjector"
	desc = "An epinephrine medipen with extra coagulant and antibiotics to help stabilize bad cuts and burns."
	icon_state = "firstaid"
	base_icon_state = "firstaid"
	volume = 15
	amount_per_transfer_from_this = 15
	list_reagents = list(/datum/reagent/medicine/epinephrine = 12, /datum/reagent/medicine/coagulant = 2.5, /datum/reagent/medicine/spaceacillin = 0.5)

/obj/item/reagent_containers/hypospray/medipen/blood_loss
	name = "hypovolemic-response autoinjector"
	desc = "A medipen designed to stabilize and rapidly reverse severe bloodloss."
	icon_state = "hypovolemic"
	base_icon_state = "hypovolemic"
	volume = 15
	amount_per_transfer_from_this = 15
	list_reagents = list(/datum/reagent/medicine/epinephrine = 5, /datum/reagent/medicine/coagulant = 2.5, /datum/reagent/iron = 3.5, /datum/reagent/medicine/saline_glucose = 4)
