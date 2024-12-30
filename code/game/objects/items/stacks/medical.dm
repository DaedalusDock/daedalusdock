/obj/item/stack/medical
	name = "medical pack"
	singular_name = "medical pack"
	icon = 'icons/obj/stack_medical.dmi'
	amount = 6
	max_amount = 6
	w_class = WEIGHT_CLASS_TINY
	full_w_class = WEIGHT_CLASS_TINY

	throw_range = 7
	stamina_damage = 0
	stamina_cost = 0
	stamina_critical_chance = 0

	resistance_flags = FLAMMABLE
	max_integrity = 40
	novariants = FALSE
	item_flags = NOBLUDGEON
	cost = 250
	source = /datum/robot_energy_storage/medical
	merge_type = /obj/item/stack/medical

	/// A sound to play on use
	var/use_sound
	/// How long it takes to apply it to yourself
	var/self_delay = 5 SECONDS
	/// How long it takes to apply it to someone else
	var/other_delay = 0
	/// If we've still got more and the patient is still hurt, should we keep going automatically?
	var/repeating = FALSE
	/// How much brute we heal per application. This is the only number that matters for simplemobs
	var/heal_brute
	/// How much burn we heal per application
	var/heal_burn
	/// How much sanitization to apply to burn wounds on application
	var/sanitization
	/// How much we add to flesh_healing for burn wounds on application
	var/flesh_regeneration

/obj/item/stack/medical/attack(mob/living/M, mob/user)
	. = ..()
	try_heal(M, user)

/// In which we print the message that we're starting to heal someone, then we try healing them. Does the do_after whether or not it can actually succeed on a targeted mob
/obj/item/stack/medical/proc/try_heal(mob/living/patient, mob/user, silent = FALSE)
	if(!patient.try_inject(user, injection_flags = INJECT_TRY_SHOW_ERROR_MESSAGE))
		return

	if(patient == user)
		if(!silent)
			user.visible_message(span_notice("[user] starts to apply [src] on [user.p_them()]self..."), span_notice("You begin applying [src] on yourself..."))
		if(!do_after(user, patient, self_delay, DO_PUBLIC, extra_checks=CALLBACK(patient, TYPE_PROC_REF(/mob/living, try_inject), user, null, INJECT_TRY_SHOW_ERROR_MESSAGE), display = src))
			return

	else if(other_delay)
		if(!silent)
			user.visible_message(span_notice("[user] starts to apply [src] on [patient]."), span_notice("You begin applying [src] on [patient]..."))
		if(!do_after(user, patient, other_delay, DO_PUBLIC, extra_checks=CALLBACK(patient, TYPE_PROC_REF(/mob/living, try_inject), user, null, INJECT_TRY_SHOW_ERROR_MESSAGE), display = src))
			return

	if(use_sound)
		playsound(loc, use_sound, 50)

	if(heal(patient, user))
		log_combat(user, patient, "healed", src.name)
		use(1)
		if(repeating && amount > 0)
			try_heal(patient, user, TRUE)

/// Apply the actual effects of the healing if it's a simple animal, goes to [/obj/item/stack/medical/proc/heal_carbon] if it's a carbon, returns TRUE if it works, FALSE if it doesn't
/obj/item/stack/medical/proc/heal(mob/living/patient, mob/user)
	if(patient.stat == DEAD)
		to_chat(user, span_warning("[patient] is dead! You can not help [patient.p_them()]."))
		return

	if(isanimal(patient) && heal_brute) // only brute can heal
		var/mob/living/simple_animal/critter = patient
		if (!critter.healable)
			to_chat(user, span_warning("You cannot use [src] on [patient]!"))
			return FALSE

		else if (critter.health == critter.maxHealth)
			to_chat(user, span_notice("[patient] is at full health."))
			return FALSE

		user.visible_message("<span class='infoplain'><span class='green'>[user] applies [src] on [patient].</span></span>", "<span class='infoplain'><span class='green'>You apply [src] on [patient].</span></span>")
		patient.heal_bodypart_damage((heal_brute * 0.5))
		return TRUE

	if(iscarbon(patient))
		return heal_carbon(patient, user, heal_brute, heal_burn)

	to_chat(user, span_warning("You can't heal [patient] with [src]!"))

/// The healing effects on a carbon patient. Since we have extra details for dealing with bodyparts, we get our own fancy proc. Still returns TRUE on success and FALSE on fail
/obj/item/stack/medical/proc/heal_carbon(mob/living/carbon/C, mob/user, brute, burn)
	var/obj/item/bodypart/affecting = C.get_bodypart(deprecise_zone(user.zone_selected), TRUE)
	if(!affecting) //Missing limb?
		to_chat(user, span_warning("[C] doesn't have \a [parse_zone(user.zone_selected)]!"))
		return FALSE
	if(!IS_ORGANIC_LIMB(affecting)) //Limb must be organic to be healed - RR
		to_chat(user, span_warning("[src] won't work on a robotic limb!"))
		return FALSE
	if(affecting.brute_dam && brute || affecting.burn_dam && burn)
		user.visible_message(
			span_infoplain(span_green("[user] applies [src] on [C]'s [parse_zone(affecting.body_zone)].")),
			span_infoplain(span_green("You apply [src] on [C]'s [parse_zone(affecting.body_zone)]."))
		)
		var/previous_damage = affecting.get_damage()
		affecting.heal_damage(brute, burn)
		post_heal_effects(max(previous_damage - affecting.get_damage(), 0), C, user)
		return TRUE
	to_chat(user, span_warning("[C]'s [parse_zone(affecting.body_zone)] can not be healed with [src]!"))
	return FALSE

///Override this proc for special post heal effects.
/obj/item/stack/medical/proc/post_heal_effects(amount_healed, mob/living/carbon/healed_mob, mob/user)
	return

/obj/item/stack/medical/bruise_pack
	name = "bruise packs"
	singular_name = "bruise pack"
	desc = "A therapeutic gel pack and bandages designed to treat blunt-force trauma."
	icon_state = "brutepack"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	heal_brute = 15
	self_delay = 4 SECONDS
	other_delay = 2 SECONDS
	grind_results = list(/datum/reagent/medicine/bicaridine = 10)
	merge_type = /obj/item/stack/medical/bruise_pack

	dynamically_set_name = TRUE

/obj/item/stack/medical/bruise_pack/suicide_act(mob/user)
	user.visible_message(span_suicide("[user] is bludgeoning [user.p_them()]self with [src]! It looks like [user.p_theyre()] trying to commit suicide!"))
	return (BRUTELOSS)

/obj/item/stack/gauze
	name = "medical gauze rolls"
	desc = "A roll of elastic cloth, perfect for stabilizing all kinds of wounds, from cuts and burns, to broken bones. "

	singular_name = "roll of medical gauze"
	multiple_gender = NEUTER

	icon_state = "gauze"
	icon = 'icons/obj/stack_medical.dmi'
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'

	max_amount = 12
	amount = 6
	grind_results = list(/datum/reagent/cellulose = 2)
	custom_price = PAYCHECK_ASSISTANT * 0.5
	absorption_capacity = 50
	absorption_rate_modifier = 0.5
	burn_cleanliness_bonus = 0.35

	merge_type = /obj/item/stack/gauze
	dynamically_set_name = TRUE

/obj/item/stack/gauze/twelve
	amount = 12

/obj/item/stack/gauze/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_WIRECUTTER || (I.sharpness & SHARP_EDGED))
		if(get_amount() < 2)
			to_chat(user, span_warning("You need at least two gauzes to do this!"))
			return
		new /obj/item/stack/sheet/cloth(I.drop_location())
		if(IsReachableBy(user))
			user.visible_message(span_notice("[user] cuts [src] into pieces of cloth with [I]."), \
				span_notice("You cut [src] into pieces of cloth with [I]."), \
				span_hear("You hear cutting."))
		else //telekinesis
			visible_message(span_notice("[I] cuts [src] into pieces of cloth."), \
				blind_message = span_hear("You hear cutting."))
		use(2)
	else
		return ..()

/obj/item/stack/gauze/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] begins tightening [src] around [user.p_their()] neck! It looks like [user.p_they()] forgot how to use medical supplies!"))
	return OXYLOSS

///Absorb an incoming bleed amount, return the amount we failed to absorb.
/obj/item/stack/proc/absorb_blood(bleed_amt, mob/living/carbon/owner)
	if(!bleed_amt)
		return 0

	add_blood_DNA(owner.get_blood_dna_list())
	if(!absorption_capacity)
		return null

	absorption_capacity = absorption_capacity - bleed_amt
	if(absorption_capacity < 0)
		. = absorption_capacity * -1 // Blood we failed to absorb
		var/obj/item/bodypart/BP = loc
		to_chat(BP.owner, span_danger("The blood spills out from underneath \the [singular_name] on your [BP.plaintext_zone]!"))
		absorption_capacity = 0
	else
		return 0 //Absorbed all blood, and bandage is still good.

/obj/item/stack/gauze/improvised
	name = "improvised gauze rolls"
	singular_name = "roll of improvised gauze"
	desc = "A roll of cloth roughly cut from something that does a decent job of stabilizing wounds, but less efficiently so than real medical gauze."
	burn_cleanliness_bonus = 0.7
	absorption_capacity = 20
	absorption_rate_modifier = 0.8

	merge_type = /obj/item/stack/gauze/improvised

/// Sutures close small cut or puncture wounds.
/obj/item/stack/medical/suture
	name = "sutures"
	desc = "Basic sterile sutures used to seal up cuts and stop bleeding."
	singular_name = "suture"

	icon_state = "suture"
	self_delay = 8 SECONDS
	other_delay = 5 SECONDS
	amount = 10
	max_amount = 10
	repeating = TRUE
	grind_results = list(/datum/reagent/medicine/spaceacillin = 2)
	merge_type = /obj/item/stack/medical/suture
	use_sound = 'sound/effects/sneedle.ogg'

	dynamically_set_name = TRUE

/obj/item/stack/medical/suture/heal_carbon(mob/living/carbon/C, mob/user, brute, burn)
	var/obj/item/bodypart/affecting = C.get_bodypart(deprecise_zone(user.zone_selected), TRUE)
	if(!affecting) //Missing limb?
		to_chat(user, span_warning("[C] doesn't have \a [parse_zone(user.zone_selected)]!"))
		return FALSE

	if(!IS_ORGANIC_LIMB(affecting)) //Limb must be organic to be healed - RR
		to_chat(user, span_warning("[src] won't work on a robotic limb!"))
		return FALSE

	var/wound_desc
	for(var/datum/wound/W as anything in shuffle(affecting.wounds))
		if(W.wound_type != WOUND_CUT && W.wound_type != WOUND_PIERCE)
			continue
		if(W.damage <= 15)
			wound_desc = W.desc
			W.heal_damage(15)
			affecting.update_damage()
			break

	if(!wound_desc)
		to_chat(user, span_warning("You can't find any wounds you can stitch shut."))
		return FALSE

	if(user == C)
		user.visible_message(span_notice("[user] stitches the [wound_desc] on [user.p_their()] [affecting.plaintext_zone] shut."))
	else
		user.visible_message(span_notice("[user] stitches the [wound_desc] on [C]'s [affecting.plaintext_zone] shut."))
	return TRUE

/obj/item/stack/medical/ointment
	name = "tube of burn ointment"
	desc = "Basic burn ointment, rated effective for second degree burns with proper bandaging, though it's still an effective stabilizer for worse burns. Not terribly good at outright healing burns though."
	singular_name = "use"
	multiple_gender = NEUTER

	icon_state = "ointment"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	amount = 8
	max_amount = 8
	self_delay = 4 SECONDS
	other_delay = 2 SECONDS

	heal_burn = 5
	flesh_regeneration = 2.5
	sanitization = 0.25
	grind_results = list(/datum/reagent/medicine/kelotane = 10)
	merge_type = /obj/item/stack/medical/ointment

/obj/item/stack/medical/ointment/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] is squeezing [src] into [user.p_their()] mouth! [user.p_do(TRUE)]n't [user.p_they()] know that stuff is toxic?"))
	return TOXLOSS

/obj/item/stack/medical/mesh
	name = "regenerative mesh"
	desc = "A bacteriostatic mesh used to dress burns."
	gender = NEUTER
	singular_name = "mesh piece"
	stack_name = "packet"

	icon_state = "regen_mesh"
	self_delay = 3 SECONDS
	other_delay = 1 SECONDS
	amount = 15
	heal_burn = 10
	max_amount = 15
	repeating = TRUE
	sanitization = 0.75
	flesh_regeneration = 3

	var/is_open = TRUE ///This var determines if the sterile packaging of the mesh has been opened.
	grind_results = list(/datum/reagent/medicine/spaceacillin = 2)
	merge_type = /obj/item/stack/medical/mesh

/obj/item/stack/medical/mesh/Initialize(mapload, new_amount, merge = TRUE, list/mat_override=null, mat_amt=1)
	. = ..()
	if(amount == max_amount)  //only seal full mesh packs
		is_open = FALSE
		update_appearance()

/obj/item/stack/medical/mesh/update_icon_state()
	if(is_open)
		return ..()
	icon_state = "regen_mesh_closed"

/obj/item/stack/medical/mesh/try_heal(mob/living/M, mob/user, silent = FALSE)
	if(!is_open)
		to_chat(user, span_warning("You need to open [src] first."))
		return
	return ..()

/obj/item/stack/medical/mesh/AltClick(mob/living/user)
	if(!is_open)
		to_chat(user, span_warning("You need to open [src] first."))
		return
	return ..()

/obj/item/stack/medical/mesh/attack_hand(mob/user, list/modifiers)
	if(!is_open && user.get_inactive_held_item() == src)
		to_chat(user, span_warning("You need to open [src] first."))
		return
	return ..()

/obj/item/stack/medical/mesh/attack_self(mob/user)
	if(!is_open)
		is_open = TRUE
		to_chat(user, span_notice("You open the sterile mesh package."))
		update_appearance()
		playsound(src, 'sound/items/poster_ripped.ogg', 20, TRUE)
		return
	return ..()

/obj/item/stack/medical/mesh/advanced
	name = "advanced regenerative mesh"
	desc = "An advanced mesh made with aloe extracts and sterilizing chemicals, used to treat burns."

	gender = PLURAL
	icon_state = "aloe_mesh"
	heal_burn = 15
	sanitization = 1.25
	flesh_regeneration = 3.5
	grind_results = list(/datum/reagent/consumable/aloejuice = 1)
	merge_type = /obj/item/stack/medical/mesh/advanced

/obj/item/stack/medical/mesh/advanced/update_icon_state()
	if(is_open)
		return ..()
	icon_state = "aloe_mesh_closed"

/obj/item/stack/medical/aloe
	name = "tube of aloe cream"
	desc = "A healing paste for minor cuts and burns."

	multiple_gender = NEUTER
	singular_name = "use"
	stack_name = "tube"

	icon_state = "aloe_paste"
	self_delay = 2 SECONDS
	other_delay = 1 SECONDS
	novariants = TRUE
	amount = 20
	max_amount = 20
	repeating = TRUE
	heal_brute = 3
	heal_burn = 3
	grind_results = list(/datum/reagent/consumable/aloejuice = 1)
	merge_type = /obj/item/stack/medical/aloe

/obj/item/stack/medical/bone_gel
	name = "tube of bone gel"
	singular_name = "use"
	stack_name = "tube"

	desc = "A potent medical gel that, when applied to a damaged bone in a proper surgical setting, triggers an intense melding reaction to repair the wound. Can be directly applied alongside surgical sticky tape to a broken bone in dire circumstances, though this is very harmful to the patient and not recommended."
	multiple_gender = NEUTER

	icon = 'icons/obj/surgery.dmi'
	icon_state = "bone-gel"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'

	amount = 6
	self_delay = 20
	grind_results = list(/datum/reagent/bone_dust = 10, /datum/reagent/carbon = 10)
	novariants = TRUE
	merge_type = /obj/item/stack/medical/bone_gel

/obj/item/stack/medical/bone_gel/attack(mob/living/M, mob/user)
	to_chat(user, span_warning("Bone gel can only be used on fractured limbs!"))
	return

/obj/item/stack/medical/bone_gel/suicide_act(mob/user)
	if(!iscarbon(user))
		return
	var/mob/living/carbon/C = user
	C.visible_message(span_suicide("[C] is squirting all of [src] into [C.p_their()] mouth! That's not proper procedure! It looks like [C.p_theyre()] trying to commit suicide!"))
	if(!do_after(C, time = 2 SECONDS, timed_action_flags = DO_PUBLIC, display = src))
		C.visible_message(span_suicide("[C] screws up like an idiot and still dies anyway!"))
		return (BRUTELOSS)

	C.emote("agony")

	for(var/i in C.bodyparts)
		var/obj/item/bodypart/bone = i
		bone.receive_damage(brute=60)
	use(1)
	return (BRUTELOSS)

/obj/item/stack/medical/bone_gel/twelve
	amount = 12

/obj/item/stack/medical/poultice
	name = "mourning poultices"
	singular_name = "mourning poultice"
	desc = "A type of primitive herbal poultice.\nWhile traditionally used to prepare corpses for the mourning feast, it can also treat scrapes and burns on the living, however, it is liable to cause shortness of breath when employed in this manner.\nIt is imbued with ancient wisdom."
	icon_state = "poultice"
	amount = 15
	max_amount = 15
	heal_brute = 10
	heal_burn = 10
	self_delay = 40
	other_delay = 10
	repeating = TRUE
	drop_sound = 'sound/misc/moist_impact.ogg'
	mob_throw_hit_sound = 'sound/misc/moist_impact.ogg'
	hitsound = 'sound/misc/moist_impact.ogg'
	merge_type = /obj/item/stack/medical/poultice

/obj/item/stack/medical/poultice/heal(mob/living/M, mob/user)
	if(iscarbon(M))
		playsound(src, 'sound/misc/soggy.ogg', 30, TRUE)
		return heal_carbon(M, user, heal_brute, heal_burn)
	return ..()

/obj/item/stack/medical/poultice/post_heal_effects(amount_healed, mob/living/carbon/healed_mob, mob/user)
	. = ..()
	healed_mob.adjustOxyLoss(amount_healed)
