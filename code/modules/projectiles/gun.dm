#define FIRING_PIN_REMOVAL_DELAY 50

/particles/firing_smoke
	icon = 'icons/particles/96x96.dmi'
	icon_state = "smoke"
	width = 500
	height = 500
	count = 5
	spawning = 15
	lifespan = 0.5 SECONDS
	fade = 2.4 SECONDS
	grow = 0.12
	drift = generator(GEN_CIRCLE, 8, 8)
	scale = 0.1
	spin = generator(GEN_NUM, -20, 20)
	velocity = list(50, 0)
	friction = generator(GEN_NUM, 0.3, 0.6)

/obj/item/gun
	name = "gun"
	desc = "It's a gun. It's pretty terrible, though."
	icon = 'icons/obj/guns/ballistic.dmi'
	icon_state = "revolver"
	inhand_icon_state = "gun"
	worn_icon_state = "gun"
	lefthand_file = 'icons/mob/inhands/weapons/guns_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/guns_righthand.dmi'

	flags_1 = CONDUCT_1
	item_flags = NEEDS_PERMIT
	slot_flags = ITEM_SLOT_BELT
	custom_materials = list(/datum/material/iron=2000)

	w_class = WEIGHT_CLASS_NORMAL
	throwforce = 5
	throw_range = 5
	force = 5

	attack_verb_continuous = list("strikes", "hits", "bashes")
	attack_verb_simple = list("strike", "hit", "bash")

	var/gun_flags = NONE

	/// The next round to be fired, if any.
	var/obj/item/ammo_casing/chambered = null

	/// Required for firing, [/obj/item/firing_pin/proc/pin_auth] is called as part of firing.
	var/obj/item/firing_pin/pin = /obj/item/firing_pin

	/// True if a gun dosen't need a pin, mostly used for abstract guns like tentacles and meathooks
	var/pinless = FALSE

	/* Sounds */
	var/fire_sound = 'sound/weapons/gun/pistol/shot.ogg'
	var/fire_sound_volume = 50
	var/vary_fire_sound = TRUE

	var/dry_fire_sound = 'sound/weapons/gun/general/dry_fire.ogg'

	var/suppressed_sound = 'sound/weapons/gun/general/heavy_shot_suppressed.ogg'
	var/suppressed_volume = 60

	/* Misc flavor */
	/// Should smoke particles be created when fired?
	var/smoking_gun = FALSE

	/* Suppression */
	/// whether or not a message is displayed when fired
	var/obj/item/suppressed = null
	var/can_suppress = FALSE
	var/can_unsuppress = TRUE

	/* BALANCE RELATED THINGS */

	/// Screenshake applied to the firer
	var/recoil = 0 // boom boom shake the room
	/// How much recoil there is when fired with one hand
	var/unwielded_recoil = 0
	/// How many shots to fire per fire sequence
	var/burst_size = 1
	/// The cooldown (DS) before the gun can be fired again after firing
	var/fire_delay = 0

	/// Boolean var used to control the speed a gun can be fired. See the "fire_delay" var.
	VAR_PRIVATE/fire_lockout = FALSE
	/// Boolean var used to prevent the weapon from firing again while already firing
	VAR_PRIVATE/firing_burst = FALSE //Prevent the weapon from firing again while already firing

	/// For every turf a fired projectile travels, increase the target bodyzone inaccuracy by this much.
	var/accuracy_falloff = 3

	/// Just 'slightly' snowflakey way to modify projectile damage for projectiles fired from this gun.
	var/projectile_damage_multiplier = 1

	trigger_guard = TRIGGER_GUARD_NORMAL //trigger guard on the weapon, hulks can't fire them with their big meaty fingers

	/* Projectile spread */

	/// Default spread
	var/spread = 0
	/// Additional spread when fired while unwielded
	var/unwielded_spread_bonus = 5
	/// Additional spread when dual wielding
	var/dual_wield_spread = 24

	/// If set to FALSE, uses a "smart spread" that changes the spread based on the amount of shots in a burst.
	var/randomspread = 1 //Set to 0 for shotguns. This is used for weapons that don't fire all their bullets at once.

	/// How many tiles do we knock the poor bastard we just point-blanked back?
	var/pb_knockback = 0

	/// Can this weapon be misfired?
	var/clumsy_check = TRUE

	/* RANDOM BULLSHIT */

	//Description to use if sawn off
	var/sawn_desc = null
	/// Is the weapon currently sawn off?
	var/sawn_off = FALSE

	///if a bayonet can be added, or removed, if it already has one.
	var/can_bayonet = FALSE
	var/obj/item/knife/bayonet
	var/knife_x_offset = 0
	var/knife_y_offset = 0

	//used for positioning ammo count overlay on sprite
	var/ammo_x_offset = 0
	var/ammo_y_offset = 0

/obj/item/gun/Initialize(mapload)
	. = ..()
	if(pin)
		pin = new pin(src, src)

	add_seclight_point()

/obj/item/gun/Destroy()
	if(!ispath(pin)) //Can still be the initial path, then we skip
		QDEL_NULL(pin)

	QDEL_NULL(bayonet)
	QDEL_NULL(chambered)

	if(isatom(suppressed)) //SUPPRESSED IS USED AS BOTH A TRUE/FALSE AND AS A REF, WHAT THE FUCKKKKKKKKKKKKKKKKK
		QDEL_NULL(suppressed)
	return ..()

/// Handles adding [the seclite mount component][/datum/component/seclite_attachable] to the gun.
/// If the gun shouldn't have a seclight mount, override this with a return.
/// Or, if a child of a gun with a seclite mount has slightly different behavior or icons, extend this.
/obj/item/gun/proc/add_seclight_point()
	return

/obj/item/gun/handle_atom_del(atom/A)
	if(A == pin)
		pin = null

	if(A == chambered)
		chambered = null

	if(A == bayonet)
		clear_bayonet()

	if(A == suppressed)
		clear_suppressor()
	return ..()

///Clears var and updates icon. In the case of ballistic weapons, also updates the gun's weight.
/obj/item/gun/proc/clear_suppressor()
	if(!can_unsuppress)
		return

	suppressed = null
	update_appearance()
	verbs -= /obj/item/gun/proc/user_remove_suppressor

/obj/item/gun/examine(mob/user)
	. = ..()
	if(!pinless)
		if(pin)
			. += "It has \a [pin] installed."
			. += span_info("[pin] looks like it could be removed with some <b>tools</b>.")
		else
			. += "It doesn't have a <b>firing pin</b> installed, and won't fire."

	if(bayonet)
		. += "It has \a [bayonet] [can_bayonet ? "" : "permanently "]affixed to it."
		if(can_bayonet) //if it has a bayonet and this is false, the bayonet is permanent.
			. += span_info("[bayonet] looks like it can be <b>unscrewed</b> from [src].")

	if(can_bayonet)
		. += "It has a <b>bayonet</b> lug on it."

/// check if there's enough ammo/energy/whatever to shoot one time
/// i.e if clicking would make it shoot
/obj/item/gun/proc/can_fire()
	return TRUE

/// Check if the user is firing this gun with telekinesis.
/obj/item/gun/proc/tk_firing(mob/living/user)
	return !user.contains(src)

/// Play the bang bang sound
/obj/item/gun/proc/play_fire_sound()
	if(suppressed)
		playsound(src, suppressed_sound, suppressed_volume, vary_fire_sound, ignore_walls = FALSE, extrarange = SILENCED_SOUND_EXTRARANGE, falloff_distance = 0)
	else
		playsound(src, fire_sound, fire_sound_volume, vary_fire_sound)

/obj/item/gun/emp_act(severity)
	. = ..()
	if(!(. & EMP_PROTECT_CONTENTS))
		for(var/obj/O in contents)
			O.emp_act(severity)

/obj/item/gun/afterattack_secondary(mob/living/victim, mob/living/user, params)
	. = SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	if(!isliving(victim))
		return

	if(user.gunpoint)
		if(user.gunpoint.target == victim)
			return
		user.gunpoint.register_to_target(victim)
		return

	if (user == victim)
		to_chat(user,span_warning("You can't hold yourself up!"))
		return

	user.gunpoint = new(null, user, victim, src)
	return

/obj/item/gun/afterattack(atom/target, mob/living/user, flag, params)
	..()
	if(user.use_gunpoint)
		afterattack_secondary(target, user, params)
		return TRUE //Cancel the shot!

	return try_fire_gun(target, user, flag, params)

/obj/item/gun/can_trigger_gun(mob/living/user, akimbo_usage)
	. = ..()
	if(!handle_pins(user))
		return FALSE

	if(HAS_TRAIT(user, TRAIT_PACIFISM) && chambered?.harmful)
		to_chat(user, span_warning("[src] is lethally chambered! You don't want to risk harming anyone..."))
		return FALSE

/obj/item/gun/proc/handle_pins(mob/living/user)
	if(pinless)
		return TRUE

	if(pin)
		if(pin.pin_auth(user) || (pin.obj_flags & EMAGGED))
			return TRUE
		else
			pin.auth_fail(user)
			return FALSE
	else
		to_chat(user, span_warning("[src]'s trigger is locked. This weapon doesn't have a firing pin installed!"))
	return FALSE

/obj/item/gun/proc/recharge_newshot()
	return

/obj/item/gun/attack(mob/M, mob/living/user)
	if(user.combat_mode) //Flogging
		if(bayonet)
			M.attackby(bayonet, user)
			return
		else
			return ..()
	return

/obj/item/gun/attack_obj(obj/O, mob/living/user, params)
	if(user.combat_mode)
		if(bayonet)
			O.attackby(bayonet, user)
			return
	return ..()

/obj/item/gun/attackby(obj/item/I, mob/living/user, params)
	if(user.combat_mode)
		return ..()

	else if(istype(I, /obj/item/knife))
		var/obj/item/knife/K = I
		if(!can_bayonet || !K.bayonet || bayonet) //ensure the gun has an attachment point available, and that the knife is compatible with it.
			return ..()
		if(!user.transferItemToLoc(I, src))
			return
		to_chat(user, span_notice("You attach [K] to [src]'s bayonet lug."))
		bayonet = K
		update_appearance()

	else
		return ..()

/obj/item/gun/screwdriver_act(mob/living/user, obj/item/I)
	. = ..()
	if(.)
		return
	if(!user.canUseTopic(src, USE_CLOSE|USE_IGNORE_TK))
		return

	if(bayonet && can_bayonet) //if it has a bayonet, and the bayonet can be removed
		return remove_bayonet(user, I)

	else if(pin && user.is_holding(src))
		user.visible_message(span_warning("[user] attempts to remove [pin] from [src] with [I]."),
		span_notice("You attempt to remove [pin] from [src]. (It will take [DisplayTimeText(FIRING_PIN_REMOVAL_DELAY)].)"), null, 3)

		if(I.use_tool(src, user, FIRING_PIN_REMOVAL_DELAY, volume = 50))
			if(!pin) //check to see if the pin is still there, or we can spam messages by clicking multiple times during the tool delay
				return

			user.visible_message(
				span_notice("[pin] is pried out of [src] by [user], destroying the pin in the process."),
				span_warning("You pry [pin] out with [I], destroying the pin in the process."),
				null,
				3
			)
			QDEL_NULL(pin)
			return TRUE

/obj/item/gun/welder_act(mob/living/user, obj/item/I)
	. = ..()
	if(.)
		return
	if(!user.canUseTopic(src, USE_CLOSE|USE_IGNORE_TK))
		return

	if(pin && user.is_holding(src))
		user.visible_message(span_warning("[user] attempts to remove [pin] from [src] with [I]."),
		span_notice("You attempt to remove [pin] from [src]. (It will take [DisplayTimeText(FIRING_PIN_REMOVAL_DELAY)].)"), null, 3)

		if(I.use_tool(src, user, FIRING_PIN_REMOVAL_DELAY, 5, volume = 50))
			if(!pin) //check to see if the pin is still there, or we can spam messages by clicking multiple times during the tool delay
				return

			user.visible_message(
				span_notice("[pin] is spliced out of [src] by [user], melting part of the pin in the process."),
				span_warning("You splice [pin] out of [src] with [I], melting part of the pin in the process."),
				null,
				3
			)
			QDEL_NULL(pin)
			return TRUE

/obj/item/gun/wirecutter_act(mob/living/user, obj/item/I)
	. = ..()
	if(.)
		return
	if(!user.canUseTopic(src, USE_CLOSE|USE_IGNORE_TK))
		return

	if(pin && user.is_holding(src))
		user.visible_message(span_warning("[user] attempts to remove [pin] from [src] with [I]."),
		span_notice("You attempt to remove [pin] from [src]. (It will take [DisplayTimeText(FIRING_PIN_REMOVAL_DELAY)].)"), null, 3)

		if(I.use_tool(src, user, FIRING_PIN_REMOVAL_DELAY, volume = 50))
			if(!pin) //check to see if the pin is still there, or we can spam messages by clicking multiple times during the tool delay
				return

			user.visible_message(
				span_notice("[pin] is ripped out of [src] by [user], mangling the pin in the process."),
				span_warning("You rip [pin] out of [src] with [I], mangling the pin in the process."),
				null,
				3
			)
			QDEL_NULL(pin)
			return TRUE

/obj/item/gun/on_disarm_attempt(mob/living/user, mob/living/attacker)
	var/list/turfs = list()
	for(var/turf/T in view())
		turfs += T

	if(!length(turfs))
		return FALSE

	var/turf/shoot_to = pick(turfs)
	if(do_fire_gun(shoot_to, user, message = FALSE, bonus_spread = 10))
		user.visible_message(
			span_danger("\The [src] goes off during the struggle!"),
			blind_message = span_hear("You hear a gunshot!")
		)
		log_combat(attacker, user, "caused a misfire with a disarm")
		return TRUE

	log_combat(attacker, user, "caused a misfire with a disarm, but the gun didn't go off")
	return FALSE

/obj/item/gun/proc/remove_bayonet(mob/living/user, obj/item/tool_item)
	tool_item?.play_tool_sound(src)
	to_chat(user, span_notice("You unfix [bayonet] from [src]."))
	bayonet.forceMove(drop_location())

	if(Adjacent(user) && !issilicon(user))
		user.put_in_hands(bayonet)

	return clear_bayonet()

/obj/item/gun/proc/clear_bayonet()
	if(!bayonet)
		return
	bayonet = null
	update_appearance()
	return TRUE

/obj/item/gun/update_overlays()
	. = ..()
	if(!bayonet)
		return

	var/state = "bayonet" //Generic state.
	if(icon_exists('icons/obj/guns/bayonets.dmi', bayonet.icon_state))
		state = bayonet.icon_state

	var/mutable_appearance/knife_overlay = mutable_appearance('icons/obj/guns/bayonets.dmi', state)
	knife_overlay.pixel_x = knife_x_offset
	knife_overlay.pixel_y = knife_y_offset
	. += knife_overlay

/obj/item/gun/proc/handle_suicide(mob/living/carbon/human/user, mob/living/carbon/human/target, params, bypass_timer)
	if(!ishuman(user) || !ishuman(target))
		return

	if(fire_lockout)
		return

	if(user == target)
		target.visible_message(span_warning("[user] sticks [src] in [user.p_their()] mouth, ready to pull the trigger..."), \
			span_userdanger("You stick [src] in your mouth, ready to pull the trigger..."))
	else
		target.visible_message(span_warning("[user] points [src] at [target]'s head, ready to pull the trigger..."), \
			span_userdanger("[user] points [src] at your head, ready to pull the trigger..."))

	fire_lockout = TRUE

	if(!bypass_timer && (!do_after(user, target, 12 SECONDS) || user.zone_selected != BODY_ZONE_PRECISE_MOUTH))
		if(user)
			if(user == target)
				user.visible_message(span_notice("[user] decided not to shoot."))
			else if(target?.Adjacent(user))
				target.visible_message(span_notice("[user] has decided to spare [target]"), span_notice("[user] has decided to spare your life!"))
		fire_lockout = FALSE
		return

	fire_lockout = FALSE

	target.visible_message(span_warning("[user] pulls the trigger!"), span_userdanger("[(user == target) ? "You pull" : "[user] pulls"] the trigger!"))

	if(chambered?.loaded_projectile)
		chambered.loaded_projectile.damage *= 5

	var/fired = do_fire_gun(target, user, TRUE, params, BODY_ZONE_HEAD)
	if(!fired && chambered?.loaded_projectile)
		chambered.loaded_projectile.damage /= 5

/obj/item/gun/proc/unlock()
	if(pin)
		qdel(pin)
	pin = new /obj/item/firing_pin(src, src)

/obj/item/gun/proc/user_remove_suppressor()
	set name = "Remove Suppressor"
	set category = "Object"
	set src in oview(1)

	if(!isliving(usr))
		return

	if(!usr.canUseTopic(src, USE_CLOSE|USE_DEXTERITY|USE_NEED_HANDS))
		return

	to_chat(usr, span_notice("You unscrew [suppressed] from [src]."))
	if(!usr.put_in_hands(suppressed))
		suppressed.forceMove(drop_location())
	clear_suppressor()

#undef FIRING_PIN_REMOVAL_DELAY
