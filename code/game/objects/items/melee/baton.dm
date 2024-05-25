/obj/item/melee/baton
	name = "police baton"
	desc = "A wooden truncheon for beating criminal scum. Left click to stun, right click to harm."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "classic_baton"
	inhand_icon_state = "classic_baton"
	worn_icon_state = "classic_baton"
	lefthand_file = 'icons/mob/inhands/equipment/security_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/security_righthand.dmi'
	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_NORMAL

	stamina_damage = 15
	stamina_cost = 21
	stamina_critical_chance = 5
	force = 12

	/// Whether this baton is active or not
	var/active = TRUE
	/// Default wait time until can stun again.
	var/cooldown = (4 SECONDS)
	/// The length of the knockdown applied to a struck living mob, if they are disoriented.
	var/knockdown_time = (10 SECONDS)
	/// If affect_cyborg is TRUE, this is how long we stun cyborgs for on a hit.
	var/stun_time_cyborg = (5 SECONDS)
	/// The length of the knockdown applied to the user on clumsy_check()
	var/clumsy_knockdown_time = 10 SECONDS
	/// How much stamina damage we deal on a successful hit against a living, non-cyborg mob.
	var/charged_stamina_damage = 130
	/// Can we stun cyborgs?
	var/affect_cyborg = FALSE
	/// The path of the default sound to play when we stun something.
	var/on_stun_sound = 'sound/effects/woodhit.ogg'
	/// The volume of the above.
	var/on_stun_volume = 75
	/// Do we animate the "hit" when stunning something?
	var/stun_animation = TRUE
	/// Whether the stun attack is logged. Only relevant for abductor batons, which have different modes.
	var/log_stun_attack = TRUE

	/// The context to show when the baton is active and targetting a living thing
	var/context_living_target_active = "Stun"

	/// The context to show when the baton is active and targetting a living thing in combat mode
	var/context_living_target_active_combat_mode = "Stun Self"

	/// The context to show when the baton is inactive and targetting a living thing
	var/context_living_target_inactive = "Prod"

	/// The context to show when the baton is inactive and targetting a living thing in combat mode
	var/context_living_target_inactive_combat_mode = "Bludgeon"

	/// When flipped, you can beat the clown. Or kill simplemobs. Or beat the clown.
	var/flipped = FALSE
	var/can_be_flipped = FALSE

	var/unflipped_force = 5

/obj/item/melee/baton/Initialize(mapload)
	. = ..()
	// Adding an extra break for the sake of presentation
	if(charged_stamina_damage != 0)
		offensive_notes = "\nVarious interviewed security forces report being able to beat criminals into exhaustion with only [span_warning("[CEILING(100 / charged_stamina_damage, 1)] hit\s!")]"

	if(can_be_flipped)
		AddElement(/datum/element/update_icon_updates_onmob)
		force = unflipped_force

	register_item_context()

/obj/item/melee/baton/update_icon_state()
	. = ..()
	if(!can_be_flipped)
		return

	if(flipped)
		icon_state = "[initial(icon_state)]_f"
	else
		icon_state = initial(icon_state)

/**
 * Ok, think of baton attacks like a melee attack chain:
 */
/obj/item/melee/baton/attack(mob/living/target, mob/living/user, params)
	if(flipped && !active)
		return ..() // Go straight up the chain

	if(melee_baton_attack(target, user))
		if(!baton_effect(target, user))
			return ..()

	add_fingerprint(user) //Only happens if we didn't go up the chain

/obj/item/melee/baton/equipped(mob/user, slot, initial)
	. = ..()
	if(!(slot & ITEM_SLOT_HANDS))
		return
	RegisterSignal(user, COMSIG_LIVING_TOGGLE_COMBAT_MODE, PROC_REF(user_flip))
	var/mob/living/L = user
	user_flip(L, L.combat_mode)

/obj/item/melee/baton/dropped(mob/user, silent)
	. = ..()
	UnregisterSignal(user, COMSIG_LIVING_TOGGLE_COMBAT_MODE)
	user_flip(null, FALSE)

/obj/item/melee/baton/proc/user_flip(mob/living/user, new_mode)
	SIGNAL_HANDLER

	if(!can_be_flipped)
		return

	if(new_mode == flipped)
		return

	if(new_mode)
		flipped = TRUE
		force = initial(force)
		SpinAnimation(0.06 SECONDS, 1)
		transform = null
		update_icon(UPDATE_ICON_STATE)
		to_chat(user, span_notice("You flip [src] and wield it by the head.[active ? "This doesn't seem very safe." : ""]"))

	else
		flipped = FALSE
		force = unflipped_force
		SpinAnimation(0.06 SECONDS, 1)
		transform = null
		update_icon(UPDATE_ICON_STATE)
		to_chat(user, span_notice("You flip [src] and wield it by the handle."))

/obj/item/melee/baton/add_item_context(datum/source, list/context, atom/target, mob/living/user)
	if (isturf(target))
		return NONE

	if (isobj(target))
		context[SCREENTIP_CONTEXT_LMB] = "Attack"
	else
		if (active)

			if (user.combat_mode)
				context[SCREENTIP_CONTEXT_LMB] = context_living_target_active_combat_mode
			else
				context[SCREENTIP_CONTEXT_LMB] = context_living_target_active
		else

			if (user.combat_mode)
				context[SCREENTIP_CONTEXT_LMB] = context_living_target_inactive_combat_mode
			else
				context[SCREENTIP_CONTEXT_LMB] = context_living_target_inactive

	return CONTEXTUAL_SCREENTIP_SET

/obj/item/melee/baton/proc/melee_baton_attack(mob/living/target, mob/living/user)
	if(clumsy_check(user, target))
		return

	if(check_parried(target, user))
		return

	if(stun_animation)
		user.do_attack_animation(target)

	if(!flipped && !active)
		user.visible_message(span_notice("[user] prods [target] with [src]."))
		return

	var/desc

	if(iscyborg(target))
		if(affect_cyborg)
			desc = get_cyborg_stun_description(target, user)
		else
			desc = get_unga_dunga_cyborg_stun_description(target, user)
			playsound(get_turf(src), 'sound/effects/bang.ogg', 10, TRUE) //bonk
			return FALSE
	else
		desc = get_stun_description(target, user)

	if(desc)
		user.visible_message(desc)

	return TRUE

/obj/item/melee/baton/proc/check_parried(mob/living/carbon/human/human_target, mob/living/user)
	if(!ishuman(human_target))
		return
	if (human_target.check_shields(src, 0, "[user]'s [name]", MELEE_ATTACK))
		playsound(human_target, 'sound/weapons/genhit.ogg', 50, TRUE)
		return TRUE
	if(check_martial_counter(human_target, user))
		return TRUE

/obj/item/melee/baton/proc/baton_effect(mob/living/target, mob/living/user)
	if(on_stun_sound)
		playsound(get_turf(src), on_stun_sound, on_stun_volume, TRUE, -1)
	if(user)
		target.lastattacker = user.real_name
		target.lastattackerckey = user.ckey
		target.LAssailant = WEAKREF(user)
		if(log_stun_attack)
			log_combat(user, target, "stun attacked", src)

	var/trait_check = HAS_TRAIT(target, TRAIT_STUNRESISTANCE)
	var/disable_duration =  knockdown_time * (trait_check ? 0.1 : 1)
	if(iscyborg(target))
		if(!affect_cyborg)
			return FALSE

		target.flash_act(affect_silicon = TRUE)
		target.Disorient(6 SECONDS, charged_stamina_damage, paralyze = disable_duration, stack_status = FALSE)
		additional_effects_cyborg(target, user)

	else
		target.Disorient(6 SECONDS, charged_stamina_damage, paralyze = disable_duration)
		additional_effects_non_cyborg(target, user)

	return TRUE


/// Default message for stunning a living, non-cyborg mob.
/obj/item/melee/baton/proc/get_stun_description(mob/living/target, mob/living/user)
	return span_danger("<b>[user]</b> knocks <b>[target]</b> down with [src]!")

/// Default message for stunning a cyborg.
/obj/item/melee/baton/proc/get_cyborg_stun_description(mob/living/target, mob/living/user)
	return span_danger("<b>[user]</b> pulses <b>[target]'s</b> sensors with [src]!")

/// Default message for trying to stun a cyborg with a baton that can't stun cyborgs.
/obj/item/melee/baton/proc/get_unga_dunga_cyborg_stun_description(mob/living/target, mob/living/user)
	return span_danger("<b>[user]</b> tries to knock down <b>[target]</b> with [src], and predictably fails!")

/// Contains any special effects that we apply to living, non-cyborg mobs we stun. Does not include applying a knockdown, dealing stamina damage, etc.
/obj/item/melee/baton/proc/additional_effects_non_cyborg(mob/living/target, mob/living/user)
	return

/// Contains any special effects that we apply to cyborgs we stun. Does not include flashing the cyborg's screen, hardstunning them, etc.
/obj/item/melee/baton/proc/additional_effects_cyborg(mob/living/target, mob/living/user)
	return

/obj/item/melee/baton/proc/clumsy_check(mob/living/user, mob/living/intented_target)
	if(!active || (!HAS_TRAIT(user, TRAIT_CLUMSY) && (!flipped || !can_be_flipped)))
		return FALSE

	if(!flipped && prob(70)) //70% chance to not hit yourself, if you aren't holding it wrong
		return FALSE

	user.visible_message(span_danger("<b>[user]</b> shocks [user.p_them()]self with [src]."))

	if(iscyborg(user) && !affect_cyborg)
		playsound(get_turf(src), 'sound/effects/bang.ogg', 10, TRUE)
		return TRUE

	var/log = log_stun_attack //A little hack to avoid double logging
	log_stun_attack = FALSE
	baton_effect(user, user)
	log_stun_attack = log

	log_combat(user, user, "accidentally stun attacked [user.p_them()]self due to their clumsiness", src)
	if(stun_animation)
		user.do_attack_animation(user)
	return TRUE

/obj/item/conversion_kit
	name = "conversion kit"
	desc = "A strange box containing wood working tools and an instruction paper to turn stun batons into something else."
	icon = 'icons/obj/storage.dmi'
	icon_state = "uk"
	custom_price = PAYCHECK_ASSISTANT * 7

/obj/item/melee/baton/telescopic
	name = "telescopic baton"
	desc = "A compact yet robust personal defense weapon. Can be concealed when folded."
	icon_state = "telebaton"
	lefthand_file = 'icons/mob/inhands/weapons/melee_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/melee_righthand.dmi'
	inhand_icon_state = null
	attack_verb_continuous = list("hits", "pokes")
	attack_verb_simple = list("hit", "poke")
	worn_icon_state = "tele_baton"
	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_SMALL
	item_flags = NONE
	force = 0

	clumsy_knockdown_time = 1 SECONDS
	active = FALSE
	can_be_flipped = FALSE
	knockdown_time = 1 SECOND

	/// The sound effecte played when our baton is extended.
	var/on_sound = 'sound/weapons/batonextend.ogg'
	/// The inhand iconstate used when our baton is extended.
	var/on_inhand_icon_state = "nullrod"
	/// The force on extension.
	var/active_force = 10

/obj/item/melee/baton/telescopic/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/transforming, \
		force_on = active_force, \
		hitsound_on = hitsound, \
		w_class_on = WEIGHT_CLASS_NORMAL, \
		clumsy_check = FALSE, \
		attack_verb_continuous_on = list("smacks", "strikes", "cracks", "beats"), \
		attack_verb_simple_on = list("smack", "strike", "crack", "beat"))
	RegisterSignal(src, COMSIG_TRANSFORMING_ON_TRANSFORM, PROC_REF(on_transform))

/obj/item/melee/baton/telescopic/baton_effect(mob/living/target, mob/living/user)
	if(user)
		target.lastattacker = user.real_name
		target.lastattackerckey = user.ckey
		target.LAssailant = WEAKREF(user)
		if(log_stun_attack)
			log_combat(user, target, "telescopic batoned", src)

	if(iscyborg(target))
		return FALSE

	var/trait_check = HAS_TRAIT(target, TRAIT_STUNRESISTANCE)
	var/disable_duration =  knockdown_time * (trait_check ? 0.1 : 1)
	target.Knockdown(disable_duration)
	additional_effects_non_cyborg(target)
	return TRUE

/obj/item/melee/baton/telescopic/suicide_act(mob/user)
	var/mob/living/carbon/human/human_user = user
	var/obj/item/organ/brain/our_brain = human_user.getorgan(/obj/item/organ/brain)

	user.visible_message(span_suicide("[user] stuffs [src] up [user.p_their()] nose and presses the 'extend' button! It looks like [user.p_theyre()] trying to clear [user.p_their()] mind."))
	if(active)
		playsound(src, on_sound, 50, TRUE)
		add_fingerprint(user)
	else
		attack_self(user)

	sleep(0.3 SECONDS)
	if (QDELETED(human_user))
		return
	if(!QDELETED(our_brain))
		qdel(our_brain)
	new /obj/effect/gibspawner/generic(human_user.drop_location(), human_user)
	return (BRUTELOSS)

/*
 * Signal proc for [COMSIG_TRANSFORMING_ON_TRANSFORM].
 *
 * Gives feedback to the user and makes it show up inhand.
 */
/obj/item/melee/baton/telescopic/proc/on_transform(obj/item/source, mob/user, active)
	SIGNAL_HANDLER

	src.active = active
	inhand_icon_state = active ? on_inhand_icon_state : null // When inactive, there is no inhand icon_state.
	balloon_alert(user, active ? "extended" : "collapsed")
	playsound(user ? user : src, on_sound, 50, TRUE)
	return COMPONENT_NO_DEFAULT_MESSAGE

/obj/item/melee/baton/security
	name = "stun baton"
	desc = "A stun baton for incapacitating people with. Left click to stun, right click to harm."

	icon_state = "stunbaton"
	inhand_icon_state = "baton"
	worn_icon_state = "baton"
	lefthand_file = 'goon/icons/mob/inhands/baton_left.dmi'
	righthand_file = 'goon/icons/mob/inhands/baton_right.dmi'

	force = 10
	attack_verb_continuous = list("beats")
	attack_verb_simple = list("beat")

	armor = list(BLUNT = 0, PUNCTURE = 0, SLASH = 0, LASER = 0, ENERGY = 0, BOMB = 50, BIO = 0, FIRE = 80, ACID = 80)

	throwforce = 7
	charged_stamina_damage = 130
	knockdown_time = 6 SECONDS
	clumsy_knockdown_time = 6 SECONDS
	cooldown = 2.5 SECONDS
	on_stun_sound = 'sound/weapons/egloves.ogg'
	on_stun_volume = 50
	active = FALSE
	can_be_flipped = TRUE

	var/throw_stun_chance = 35
	var/obj/item/stock_parts/cell/cell
	var/preload_cell_type //if not empty the baton starts with this type of cell
	var/cell_hit_cost = 1000
	var/can_remove_cell = TRUE
	var/convertible = TRUE //if it can be converted with a conversion kit

/obj/item/melee/baton/security/Initialize(mapload)
	. = ..()
	if(preload_cell_type)
		if(!ispath(preload_cell_type, /obj/item/stock_parts/cell))
			log_mapping("[src] at [AREACOORD(src)] had an invalid preload_cell_type: [preload_cell_type].")
		else
			cell = new preload_cell_type(src)
	RegisterSignal(src, COMSIG_PARENT_ATTACKBY, PROC_REF(convert))
	update_appearance()

/obj/item/melee/baton/security/get_cell()
	return cell

/obj/item/melee/baton/security/suicide_act(mob/user)
	if(cell?.charge && active)
		user.visible_message(span_suicide("[user] is putting the live [name] in [user.p_their()] mouth! It looks like [user.p_theyre()] trying to commit suicide!"))
		. = (FIRELOSS)
		attack(user, user)
	else
		user.visible_message(span_suicide("[user] is shoving the [name] down their throat! It looks like [user.p_theyre()] trying to commit suicide!"))
		. = (OXYLOSS)

/obj/item/melee/baton/security/Destroy()
	if(cell)
		QDEL_NULL(cell)
	UnregisterSignal(src, COMSIG_PARENT_ATTACKBY)
	return ..()

/obj/item/melee/baton/security/proc/convert(datum/source, obj/item/item, mob/user)
	SIGNAL_HANDLER

	if(!istype(item, /obj/item/conversion_kit) || !convertible)
		return
	var/turf/source_turf = get_turf(src)
	var/obj/item/melee/baton/baton = new (source_turf)
	baton.alpha = 20
	playsound(source_turf, 'sound/items/drill_use.ogg', 80, TRUE, -1)
	animate(src, alpha = 0, time = 1 SECONDS)
	animate(baton, alpha = 255, time = 1 SECONDS)
	qdel(item)
	qdel(src)

/obj/item/melee/baton/security/Exited(atom/movable/mov_content)
	. = ..()
	if(mov_content == cell)
		cell.update_appearance()
		cell = null
		active = FALSE
		update_appearance()

/obj/item/melee/baton/security/update_icon_state()
	. = ..()
	var/active
	var/nocell
	var/flipped

	if(src.active)
		active = "_active"

	else if(!cell)
		nocell = "_nocell"

	if(src.flipped)
		flipped = "_f"

	icon_state = "[initial(icon_state)][active][nocell][flipped]"
	inhand_icon_state = "[initial(inhand_icon_state)][active][flipped]"

/obj/item/melee/baton/security/examine(mob/user)
	. = ..()
	if(cell)
		. += span_notice("\The [src] is [round(cell.percent())]% charged.")
	else
		. += span_warning("\The [src] does not have a power source installed.")

/obj/item/melee/baton/security/screwdriver_act(mob/living/user, obj/item/tool)
	if(tryremovecell(user))
		tool.play_tool_sound(src)
	return TRUE

/obj/item/melee/baton/security/attackby(obj/item/item, mob/user, params)
	if(istype(item, /obj/item/stock_parts/cell))
		var/obj/item/stock_parts/cell/active_cell = item
		if(cell)
			to_chat(user, span_warning("[src] already has a cell!"))
		else
			if(active_cell.maxcharge < cell_hit_cost)
				to_chat(user, span_notice("[src] requires a higher capacity cell."))
				return
			if(!user.transferItemToLoc(item, src))
				return
			cell = item
			to_chat(user, span_notice("You install a cell in [src]."))
			update_appearance()
	else
		return ..()

/obj/item/melee/baton/security/proc/tryremovecell(mob/user)
	if(cell && can_remove_cell)
		cell.forceMove(drop_location())
		to_chat(user, span_notice("You remove the cell from [src]."))
		return TRUE
	return FALSE

/obj/item/melee/baton/security/attack_self(mob/user)
	if(cell?.charge >= cell_hit_cost)
		active = !active
		balloon_alert(user, "turned [active ? "on" : "off"]")
		playsound(src, SFX_SPARKS, 75, TRUE, -1)
	else
		active = FALSE
		if(!cell)
			balloon_alert(user, "no power source!")
		else
			balloon_alert(user, "out of charge!")
	update_appearance()
	add_fingerprint(user)

/obj/item/melee/baton/security/proc/deductcharge(deducted_charge)
	if(!cell)
		return
	//Note this value returned is significant, as it will determine
	//if a stun is applied or not
	. = cell.use(deducted_charge)
	if(active && cell.charge < cell_hit_cost)
		//we're below minimum, turn off
		active = FALSE
		update_appearance()
		playsound(src, SFX_SPARKS, 75, TRUE, -1)

/obj/item/melee/baton/security/clumsy_check(mob/living/carbon/human/user)
	. = ..()
	if(.)
		SEND_SIGNAL(user, COMSIG_LIVING_MINOR_SHOCK)
		deductcharge(cell_hit_cost)

/obj/item/melee/baton/security/baton_effect(mob/living/target, mob/living/user)
	if(iscyborg(loc))
		var/mob/living/silicon/robot/robot = loc
		if(!robot || !robot.cell || !robot.cell.use(cell_hit_cost))
			return FALSE
	else if(!deductcharge(cell_hit_cost))
		return FALSE
	return ..()

/*
 * After a target is hit, we apply some status effects.
 * After a period of time, we then check to see what stun duration we give.
 */
/obj/item/melee/baton/security/additional_effects_non_cyborg(mob/living/target, mob/living/user)
	target.set_timed_status_effect(10 SECONDS, /datum/status_effect/jitter, only_if_higher = TRUE)
	target.set_timed_status_effect(10 SECONDS, /datum/status_effect/confusion, only_if_higher = TRUE)
	target.set_timed_status_effect(10 SECONDS, /datum/status_effect/speech/stutter, only_if_higher = TRUE)

	SEND_SIGNAL(target, COMSIG_LIVING_MINOR_SHOCK)

/obj/item/melee/baton/security/get_stun_description(mob/living/target, mob/living/user)
	return span_danger("<b>[user]</b> stuns <b>[target]</b> with [src]!")

/obj/item/melee/baton/security/get_unga_dunga_cyborg_stun_description(mob/living/target, mob/living/user)
	return span_danger("<b>[user]</b> tries to stun <b>[target]</b> with [src], and predictably fails!")

/obj/item/melee/baton/security/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	if(active && prob(throw_stun_chance) && isliving(hit_atom))
		baton_effect(hit_atom, thrownby?.resolve())

/obj/item/melee/baton/security/emp_act(severity)
	. = ..()
	if (!cell)
		return
	if (!(. & EMP_PROTECT_SELF))
		deductcharge(1000 / severity)
	if (cell.charge >= cell_hit_cost)
		var/scramble_time
		scramble_mode()
		for(var/loops in 1 to rand(6, 12))
			scramble_time = rand(5, 15) / (1 SECONDS)
			addtimer(CALLBACK(src, PROC_REF(scramble_mode)), scramble_time*loops * (1 SECONDS))

/obj/item/melee/baton/security/proc/scramble_mode()
	if (!cell || cell.charge < cell_hit_cost)
		return
	active = !active
	playsound(src, SFX_SPARKS, 75, TRUE, -1)
	update_appearance()

/obj/item/melee/baton/security/loaded //this one starts with a cell pre-installed.
	preload_cell_type = /obj/item/stock_parts/cell/high

//Makeshift stun baton. Replacement for stun gloves.
/obj/item/melee/baton/security/cattleprod
	name = "stunprod"
	desc = "An improvised stun baton."
	icon_state = "stunprod"
	inhand_icon_state = "prod"
	worn_icon_state = null
	lefthand_file = 'icons/mob/inhands/weapons/melee_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/melee_righthand.dmi'
	w_class = WEIGHT_CLASS_HUGE
	force = 3
	throwforce = 5
	cell_hit_cost = 2000
	throw_stun_chance = 10
	slot_flags = ITEM_SLOT_BACK
	convertible = FALSE
	var/obj/item/assembly/igniter/sparkler

/obj/item/melee/baton/security/cattleprod/Initialize(mapload)
	. = ..()
	sparkler = new (src)

/obj/item/melee/baton/security/cattleprod/attackby(obj/item/item, mob/user, params)//handles sticking a crystal onto a stunprod to make a teleprod
	if(!istype(item, /obj/item/stack/ore/bluespace_crystal))
		return ..()
	if(!cell)
		var/obj/item/stack/ore/bluespace_crystal/crystal = item
		var/obj/item/melee/baton/security/cattleprod/teleprod/prod = new
		remove_item_from_storage(user)
		qdel(src)
		crystal.use(1)
		user.put_in_hands(prod)
		to_chat(user, span_notice("You place the bluespace crystal firmly into the igniter."))
	else
		user.visible_message(span_warning("You can't put the crystal onto the stunprod while it has a power cell installed!"))

/obj/item/melee/baton/security/cattleprod/melee_baton_attack()
	if(!sparkler.activate())
		return
	return ..()

/obj/item/melee/baton/security/cattleprod/update_icon_state()
	. = ..()
	inhand_icon_state = initial(inhand_icon_state)

/obj/item/melee/baton/security/cattleprod/Destroy()
	if(sparkler)
		QDEL_NULL(sparkler)
	return ..()

/obj/item/melee/baton/security/boomerang
	name = "\improper OZtek Boomerang"
	desc = "A device invented in 2486 for the great Space Emu War by the confederacy of Australicus, these high-tech boomerangs also work exceptionally well at stunning crewmembers. Just be careful to catch it when thrown!"
	throw_speed = 1
	icon_state = "boomerang"
	inhand_icon_state = "boomerang"
	lefthand_file = 'icons/mob/inhands/equipment/security_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/security_righthand.dmi'

	force = 5
	throwforce = 5
	throw_range = 5
	cell_hit_cost = 2000
	throw_stun_chance = 99  //Have you prayed today?
	convertible = FALSE
	custom_materials = list(/datum/material/iron = 10000, /datum/material/glass = 4000, /datum/material/silver = 10000, /datum/material/gold = 2000)
	can_be_flipped = FALSE

/obj/item/melee/baton/security/boomerang/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/boomerang, throw_range+2, TRUE)

/obj/item/melee/baton/security/boomerang/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if(!active)
		return ..()
	var/caught = hit_atom.hitby(src, skipcatch = FALSE, hitpush = FALSE, throwingdatum = throwingdatum)
	var/mob/thrown_by = thrownby?.resolve()
	if(isliving(hit_atom) && !iscyborg(hit_atom) && !caught && prob(throw_stun_chance))//if they are a living creature and they didn't catch it
		baton_effect(hit_atom, thrown_by)

/obj/item/melee/baton/security/boomerang/loaded //Same as above, comes with a cell.
	preload_cell_type = /obj/item/stock_parts/cell/high

/obj/item/melee/baton/security/cattleprod/teleprod
	name = "teleprod"
	desc = "A prod with a bluespace crystal on the end. The crystal doesn't look too fun to touch."
	w_class = WEIGHT_CLASS_NORMAL
	icon_state = "teleprod"
	inhand_icon_state = "teleprod"
	slot_flags = null

/obj/item/melee/baton/security/cattleprod/update_icon_state()
	. = ..()
	inhand_icon_state = initial(inhand_icon_state)

/obj/item/melee/baton/security/cattleprod/teleprod/clumsy_check(mob/living/carbon/human/user)
	. = ..()
	if(!.)
		return
	do_teleport(user, get_turf(user), 50, channel = TELEPORT_CHANNEL_BLUESPACE)

/obj/item/melee/baton/security/cattleprod/teleprod/baton_effect(mob/living/target, mob/living/user)
	. = ..()
	if(!. || target.move_resist >= MOVE_FORCE_OVERPOWERING)
		return
	do_teleport(target, get_turf(target), 15, channel = TELEPORT_CHANNEL_BLUESPACE)

/obj/item/melee/baton/security/debug
	preload_cell_type = /obj/item/stock_parts/cell/bluespace
