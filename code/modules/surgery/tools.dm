TYPEINFO_DEF(/obj/item/retractor)
	default_materials = list(/datum/material/iron=6000, /datum/material/glass=3000)

/obj/item/retractor
	name = "retractor"
	desc = "Retracts stuff."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "retractor"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	inhand_icon_state = "clamps"
	flags_1 = CONDUCT_1
	item_flags = SURGICAL_TOOL
	w_class = WEIGHT_CLASS_TINY
	tool_behaviour = TOOL_RETRACTOR
	toolspeed = 1

/obj/item/retractor/augment
	desc = "Micro-mechanical manipulator for retracting stuff."
	toolspeed = 0.5


TYPEINFO_DEF(/obj/item/hemostat)
	default_materials = list(/datum/material/iron=5000, /datum/material/glass=2500)

/obj/item/hemostat
	name = "hemostat"
	desc = "You think you have seen this before."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "hemostat"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	inhand_icon_state = "clamps"
	flags_1 = CONDUCT_1
	item_flags = SURGICAL_TOOL
	w_class = WEIGHT_CLASS_TINY
	attack_verb_continuous = list("attacks", "pinches")
	attack_verb_simple = list("attack", "pinch")
	tool_behaviour = TOOL_HEMOSTAT
	toolspeed = 1

/obj/item/hemostat/augment
	desc = "Tiny servos power a pair of pincers to stop bleeding."
	toolspeed = 0.5


TYPEINFO_DEF(/obj/item/cautery)
	default_materials = list(/datum/material/iron=2500, /datum/material/glass=750)

/obj/item/cautery
	name = "cautery"
	desc = "This stops bleeding."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "cautery"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	inhand_icon_state = "cautery"
	flags_1 = CONDUCT_1
	item_flags = SURGICAL_TOOL
	w_class = WEIGHT_CLASS_TINY
	attack_verb_continuous = list("burns")
	attack_verb_simple = list("burn")
	tool_behaviour = TOOL_CAUTERY
	toolspeed = 1

/obj/item/cautery/ignition_effect(atom/ignitable_atom, mob/user)
	. = span_notice("[user] touches the end of [src] to \the [ignitable_atom], igniting it with a puff of smoke.")

/obj/item/cautery/augment
	desc = "A heated element that cauterizes wounds."
	toolspeed = 0.5

TYPEINFO_DEF(/obj/item/cautery/advanced)
	default_materials = list(/datum/material/iron = 4000, /datum/material/glass = 2000, /datum/material/plasma = 2000, /datum/material/uranium = 3000, /datum/material/titanium = 3000)

/obj/item/cautery/advanced
	name = "searing tool"
	desc = "It projects a high power laser used for medical applications."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "e_cautery"
	hitsound = 'sound/items/welder.ogg'
	toolspeed = 0.7
	light_system = OVERLAY_LIGHT
	light_outer_range = 1
	light_color = COLOR_SOFT_RED

/obj/item/cautery/advanced/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/transforming, \
		force_on = force, \
		throwforce_on = throwforce, \
		hitsound_on = hitsound, \
		w_class_on = w_class, \
		clumsy_check = FALSE)
	RegisterSignal(src, COMSIG_TRANSFORMING_ON_TRANSFORM, PROC_REF(on_transform))

/*
 * Signal proc for [COMSIG_TRANSFORMING_ON_TRANSFORM].
 *
 * Toggles between drill and cautery and gives feedback to the user.
 */
/obj/item/cautery/advanced/proc/on_transform(obj/item/source, mob/user, active)
	SIGNAL_HANDLER

	tool_behaviour = (active ? TOOL_DRILL : TOOL_CAUTERY)
	balloon_alert(user, "lenses set to [active ? "drill" : "mend"]")
	playsound(user ? user : src, 'sound/weapons/tap.ogg', 50, TRUE)
	return COMPONENT_NO_DEFAULT_MESSAGE

/obj/item/cautery/advanced/examine()
	. = ..()
	. += span_notice("It's set to [tool_behaviour == TOOL_CAUTERY ? "mending" : "drilling"] mode.")

TYPEINFO_DEF(/obj/item/surgicaldrill)
	default_materials = list(/datum/material/iron=10000, /datum/material/glass=6000)

/obj/item/surgicaldrill
	name = "surgical drill"
	desc = "You can drill using this item. You dig?"
	icon = 'icons/obj/surgery.dmi'
	icon_state = "drill"
	lefthand_file = 'icons/mob/inhands/equipment/tools_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/tools_righthand.dmi'
	hitsound = 'sound/weapons/circsawhit.ogg'
	flags_1 = CONDUCT_1
	item_flags = SURGICAL_TOOL
	force = 15
	w_class = WEIGHT_CLASS_NORMAL
	attack_verb_continuous = list("drills")
	attack_verb_simple = list("drill")
	tool_behaviour = TOOL_DRILL
	toolspeed = 1
	sharpness = SHARP_POINTY

/obj/item/surgicaldrill/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/eyestab)

/obj/item/surgicaldrill/suicide_act(mob/user)
	user.visible_message(span_suicide("[user] rams [src] into [user.p_their()] chest! It looks like [user.p_theyre()] trying to commit suicide!"))
	addtimer(CALLBACK(user, TYPE_PROC_REF(/mob/living/carbon, gib), null, null, TRUE, TRUE), 25)
	user.SpinAnimation(3, 10)
	playsound(user, 'sound/machines/juicer.ogg', 20, TRUE)
	return (MANUAL_SUICIDE)

/obj/item/surgicaldrill/augment
	desc = "Effectively a small power drill contained within your arm. May or may not pierce the heavens."
	hitsound = 'sound/weapons/circsawhit.ogg'
	w_class = WEIGHT_CLASS_SMALL
	toolspeed = 0.5


TYPEINFO_DEF(/obj/item/scalpel)
	default_materials = list(/datum/material/iron=4000, /datum/material/glass=1000)

/obj/item/scalpel
	name = "scalpel"
	desc = "Cut, cut, and once more cut."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "scalpel"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	inhand_icon_state = "scalpel"
	flags_1 = CONDUCT_1
	item_flags = SURGICAL_TOOL
	w_class = WEIGHT_CLASS_TINY

	force = 10
	throwforce = 5
	throw_speed = 1.5
	throw_range = 5
	stamina_damage = 5
	stamina_cost = 5
	stamina_critical_chance = 35

	attack_verb_continuous = list("attacks", "slashes", "stabs", "slices", "tears", "lacerates", "rips", "dices", "cuts")
	attack_verb_simple = list("attack", "slash", "stab", "slice", "tear", "lacerate", "rip", "dice", "cut")
	hitsound = 'sound/weapons/bladeslice.ogg'
	sharpness = SHARP_EDGED
	tool_behaviour = TOOL_SCALPEL
	toolspeed = 1

/obj/item/scalpel/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/butchering, 80 * toolspeed, 100, 0)
	AddElement(/datum/element/eyestab)

/obj/item/scalpel/augment
	desc = "Ultra-sharp blade attached directly to your bone for extra-accuracy."
	toolspeed = 0.5

/obj/item/scalpel/suicide_act(mob/user)
	user.visible_message(span_suicide("[user] is slitting [user.p_their()] [pick("wrists", "throat", "stomach")] with [src]! It looks like [user.p_theyre()] trying to commit suicide!"))
	return (BRUTELOSS)


TYPEINFO_DEF(/obj/item/circular_saw)
	default_materials = list(/datum/material/iron=1000)

/obj/item/circular_saw
	name = "circular saw"
	desc = "For heavy duty cutting."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "saw"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	hitsound = 'sound/weapons/circsawhit.ogg'
	mob_throw_hit_sound = 'sound/weapons/pierce.ogg'
	flags_1 = CONDUCT_1
	item_flags = SURGICAL_TOOL

	force = 15
	w_class = WEIGHT_CLASS_NORMAL
	throwforce = 9
	throw_range = 5
	stamina_damage = 5
	stamina_cost = 5
	stamina_critical_chance = 35

	attack_verb_continuous = list("attacks", "slashes", "saws", "cuts")
	attack_verb_simple = list("attack", "slash", "saw", "cut")
	sharpness = SHARP_EDGED
	tool_behaviour = TOOL_SAW
	toolspeed = 1

/obj/item/circular_saw/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/butchering, 40 * toolspeed, 100, 5, 'sound/weapons/circsawhit.ogg') //saws are very accurate and fast at butchering

/obj/item/circular_saw/augment
	desc = "A small but very fast spinning saw. It rips and tears until it is done."
	w_class = WEIGHT_CLASS_SMALL
	toolspeed = 0.5

TYPEINFO_DEF(/obj/item/scalpel/advanced)
	default_materials = list(/datum/material/iron = 6000, /datum/material/glass = 1500, /datum/material/silver = 2000, /datum/material/gold = 1500, /datum/material/diamond = 200, /datum/material/titanium = 4000)

/obj/item/scalpel/advanced
	name = "laser scalpel"
	desc = "An advanced scalpel which uses laser technology to cut."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "e_scalpel"
	hitsound = 'sound/weapons/blade1.ogg'
	force = 16
	toolspeed = 0.7
	light_system = OVERLAY_LIGHT
	light_outer_range = 1
	light_color = LIGHT_COLOR_GREEN
	sharpness = SHARP_EDGED

/obj/item/scalpel/advanced/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/transforming, \
		force_on = force + 1, \
		throwforce_on = throwforce, \
		throw_speed_on = throw_speed, \
		sharpness_on = sharpness, \
		hitsound_on = hitsound, \
		w_class_on = w_class, \
		clumsy_check = FALSE)
	RegisterSignal(src, COMSIG_TRANSFORMING_ON_TRANSFORM, PROC_REF(on_transform))

/*
 * Signal proc for [COMSIG_TRANSFORMING_ON_TRANSFORM].
 *
 * Toggles between saw and scalpel and updates the light / gives feedback to the user.
 */
/obj/item/scalpel/advanced/proc/on_transform(obj/item/source, mob/user, active)
	SIGNAL_HANDLER

	if(active)
		tool_behaviour = TOOL_SAW
		set_light_range(2)
	else
		tool_behaviour = TOOL_SCALPEL
		set_light_range(1)

	balloon_alert(user, "[active ? "enabled" : "disabled"] bone-cutting mode")
	playsound(user ? user : src, 'sound/machines/click.ogg', 50, TRUE)
	return COMPONENT_NO_DEFAULT_MESSAGE

/obj/item/scalpel/advanced/examine()
	. = ..()
	. += span_notice("It's set to [tool_behaviour == TOOL_SCALPEL ? "scalpel" : "saw"] mode.")

TYPEINFO_DEF(/obj/item/retractor/advanced)
	default_materials = list(/datum/material/iron = 12000, /datum/material/glass = 4000, /datum/material/silver = 4000, /datum/material/titanium = 5000)

/obj/item/retractor/advanced
	name = "mechanical pinches"
	desc = "An agglomerate of rods and gears."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "adv_retractor"
	toolspeed = 0.7

/obj/item/retractor/advanced/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/transforming, \
		force_on = force, \
		throwforce_on = throwforce, \
		hitsound_on = hitsound, \
		w_class_on = w_class, \
		clumsy_check = FALSE)
	RegisterSignal(src, COMSIG_TRANSFORMING_ON_TRANSFORM, PROC_REF(on_transform))

/*
 * Signal proc for [COMSIG_TRANSFORMING_ON_TRANSFORM].
 *
 * Toggles between retractor and hemostat and gives feedback to the user.
 */
/obj/item/retractor/advanced/proc/on_transform(obj/item/source, mob/user, active)
	SIGNAL_HANDLER

	tool_behaviour = (active ? TOOL_HEMOSTAT : TOOL_RETRACTOR)
	balloon_alert(user, "gears set to [active ? "clamp" : "retract"]")
	playsound(user ? user : src, 'sound/items/change_drill.ogg', 50, TRUE)
	return COMPONENT_NO_DEFAULT_MESSAGE

/obj/item/retractor/advanced/examine()
	. = ..()
	. += span_notice("It resembles a [tool_behaviour == TOOL_RETRACTOR ? "retractor" : "hemostat"].")

TYPEINFO_DEF(/obj/item/shears)
	default_materials = list(/datum/material/iron=8000, /datum/material/titanium=6000)

/obj/item/shears
	name = "amputation shears"
	desc = "A type of heavy duty surgical shears used for achieving a clean separation between limb and patient. Keeping the patient still is imperative to be able to secure and align the shears."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "shears"
	flags_1 = CONDUCT_1
	item_flags = SURGICAL_TOOL
	toolspeed = 1
	force = 12
	w_class = WEIGHT_CLASS_NORMAL
	throwforce = 6
	throw_range = 5
	attack_verb_continuous = list("shears", "snips")
	attack_verb_simple = list("shear", "snip")
	sharpness = SHARP_EDGED
	custom_premium_price = PAYCHECK_MEDIUM * 14

/obj/item/shears/attack(mob/living/amputee, mob/living/user)
	if(!iscarbon(amputee) || user.combat_mode)
		return ..()

	if(user.zone_selected == BODY_ZONE_CHEST)
		return ..()

	var/mob/living/carbon/patient = amputee

	if(HAS_TRAIT(patient, TRAIT_NODISMEMBER))
		to_chat(user, span_warning("The patient's limbs look too sturdy to amputate."))
		return

	var/candidate_name
	var/obj/item/organ/tail_snip_candidate
	var/obj/item/bodypart/limb_snip_candidate

	if(user.zone_selected == BODY_ZONE_PRECISE_GROIN)
		tail_snip_candidate = patient.getorganslot(ORGAN_SLOT_EXTERNAL_TAIL)
		if(!tail_snip_candidate)
			to_chat(user, span_warning("[patient] does not have a tail."))
			return
		candidate_name = tail_snip_candidate.name

	else
		limb_snip_candidate = patient.get_bodypart(deprecise_zone(user.zone_selected))
		if(!limb_snip_candidate)
			to_chat(user, span_warning("[patient] is already missing that limb, what more do you want?"))
			return
		candidate_name = limb_snip_candidate.name

	var/amputation_speed_mod = 1

	patient.visible_message(span_danger("[user] begins to secure [src] around [patient]'s [candidate_name]."), span_userdanger("[user] begins to secure [src] around your [candidate_name]!"))
	playsound(get_turf(patient), 'sound/items/ratchet.ogg', 20, TRUE)
	if(patient.stat >= UNCONSCIOUS || HAS_TRAIT(patient, TRAIT_INCAPACITATED)) //if you're incapacitated (due to paralysis, a stun, being in staminacrit, etc.), critted, unconscious, or dead, it's much easier to properly line up a snip
		amputation_speed_mod *= 0.5
	if(patient.stat != DEAD && patient.has_status_effect(/datum/status_effect/jitter)) //jittering will make it harder to secure the shears, even if you can't otherwise move
		amputation_speed_mod *= 1.5 //15*0.5*1.5=11.25, so staminacritting someone who's jittering (from, say, a stun baton) won't give you enough time to snip their head off, but staminacritting someone who isn't jittering will

	if(do_after(user, patient, toolspeed * 15 SECONDS * amputation_speed_mod))
		playsound(get_turf(patient), 'sound/weapons/bladeslice.ogg', 250, TRUE)
		if(user.zone_selected == BODY_ZONE_PRECISE_GROIN) //OwO
			tail_snip_candidate.Remove(patient)
			tail_snip_candidate.forceMove(get_turf(patient))
		else
			limb_snip_candidate.dismember()
		user.visible_message(span_danger("[src] violently slams shut, amputating [patient]'s [candidate_name]."), span_notice("You amputate [patient]'s [candidate_name] with [src]."))

/obj/item/shears/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user] is pinching [user.p_them()]self with \the [src]! It looks like [user.p_theyre()] trying to commit suicide!"))
	var/timer = 1 SECONDS
	for(var/obj/item/bodypart/thing in user.bodyparts)
		if(thing.body_part == CHEST)
			continue
		addtimer(CALLBACK(thing, TYPE_PROC_REF(/obj/item/bodypart, dismember)), timer)
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound), user, 'sound/weapons/bladeslice.ogg', 70), timer)
		timer += 1 SECONDS
	sleep(timer)
	return BRUTELOSS

TYPEINFO_DEF(/obj/item/bonesetter)
	default_materials = list(/datum/material/iron=5000, /datum/material/glass=2500)

/obj/item/bonesetter
	name = "bonesetter"
	desc = "For setting things right."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "bone setter"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	flags_1 = CONDUCT_1
	item_flags = SURGICAL_TOOL
	w_class = WEIGHT_CLASS_SMALL
	attack_verb_continuous = list("corrects", "properly sets")
	attack_verb_simple = list("correct", "properly set")
	tool_behaviour = TOOL_BONESET
	toolspeed = 1

TYPEINFO_DEF(/obj/item/blood_filter)
	default_materials = list(/datum/material/iron=2000, /datum/material/glass=1500, /datum/material/silver=500)

/obj/item/blood_filter
	name = "blood filter"
	desc = "For filtering the blood."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "bloodfilter"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	item_flags = SURGICAL_TOOL
	w_class = WEIGHT_CLASS_NORMAL
	attack_verb_continuous = list("pumps", "siphons")
	attack_verb_simple = list("pump", "siphon")
	tool_behaviour = TOOL_BLOODFILTER
	toolspeed = 1
	/// Assoc list of chem ids to names, used for deciding which chems to filter when used for surgery
	var/list/whitelist = list()

/obj/item/blood_filter/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "BloodFilter", name)
		ui.open()

/obj/item/blood_filter/ui_data(mob/user)
	var/list/data = list()
	var/list/chem_names = list()
	for(var/key in whitelist)
		chem_names += whitelist[key]
	data["whitelist"] = chem_names
	return data

/obj/item/blood_filter/ui_act(action, params)
	. = ..()
	if(.)
		return
	. = TRUE
	switch(action)
		if("add")
			var/new_chem_name = params["name"]
			var/chem_id = get_chem_id(new_chem_name)
			if(!chem_id || !new_chem_name)
				to_chat(usr, span_warning("No such known reagent exists!"))
				return
			if(!(chem_id in whitelist))
				whitelist[chem_id] = new_chem_name


		if("remove")
			var/chem_name = params["reagent"]
			var/chem_id = get_chem_id(chem_name)
			whitelist -= chem_id

/obj/item/fixovein
	name = "vascular recoupler"
	desc = "Derived from a Vey-Med design, this miniature 3D printer is used to quickly synthetize and thread new organic tissue during surgical procedures."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "fixovein"
	force = 0
	throwforce = 1.0
	w_class = WEIGHT_CLASS_SMALL
