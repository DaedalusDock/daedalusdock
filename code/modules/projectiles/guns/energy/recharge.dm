//Recharge subtype - used by stuff like protokinetic accelerators and ebows, one shot at a time, recharges.
/obj/item/gun/energy/recharge
	icon_state = "kineticgun"
	base_icon_state = "kineticgun"
	desc = "A self recharging gun. Holds one shot at a time."
	automatic_charge_overlays = FALSE
	cell_type = /obj/item/stock_parts/cell/emproof
	/// If set to something, instead of an overlay, sets the icon_state directly.
	var/no_charge_state
	/// Does it hold charge when not put away?
	var/holds_charge = FALSE
	/// How much time we need to recharge
	var/recharge_time = 1.6 SECONDS
	/// Sound we use when recharged
	var/recharge_sound = 'sound/weapons/kenetic_reload.ogg'
	/// An ID for our recharging timer.
	var/recharge_timerid
	/// Do we recharge slower with more of our type?
	var/unique_frequency = FALSE

/obj/item/gun/energy/recharge/Initialize(mapload)
	. = ..()
	if(!holds_charge)
		empty()

/obj/item/gun/energy/recharge/after_firing(mob/living/user, pointblank = 0, atom/pbtarget = null, message = 1)
	. = ..()
	attempt_reload()

/obj/item/gun/energy/recharge/equipped(mob/user)
	. = ..()
	if(!can_fire())
		attempt_reload()

/obj/item/gun/energy/recharge/unequipped()
	. = ..()
	if(!QDELING(src) && !holds_charge)
		// Put it on a delay because moving item from slot to hand
		// calls dropped().
		addtimer(CALLBACK(src, PROC_REF(empty_if_not_held)), 0.1 SECONDS)

/obj/item/gun/energy/recharge/do_chamber_update()
	. = ..()
	attempt_reload()

/obj/item/gun/energy/recharge/proc/empty_if_not_held()
	if(!equipped_to)
		empty()
		deltimer(recharge_timerid)

/obj/item/gun/energy/recharge/proc/empty()
	if(cell)
		cell.use(cell.charge)
	update_appearance()

/obj/item/gun/energy/recharge/proc/attempt_reload(set_recharge_time)
	if(!cell)
		return
	if(cell.charge == cell.maxcharge)
		return
	if(!set_recharge_time)
		set_recharge_time = recharge_time
	var/carried = 0
	if(!unique_frequency)
		for(var/obj/item/gun/energy/recharge/recharging_gun in loc.get_all_contents())
			if(recharging_gun.type != type || recharging_gun.unique_frequency)
				continue
			carried++
	carried = max(carried, 1)
	deltimer(recharge_timerid)
	recharge_timerid = addtimer(CALLBACK(src, PROC_REF(reload)), set_recharge_time * carried, TIMER_STOPPABLE)

/obj/item/gun/energy/recharge/emp_act(severity)
	return

/obj/item/gun/energy/recharge/proc/reload()
	cell.give(cell.maxcharge)
	if(!suppressed && recharge_sound)
		playsound(src.loc, recharge_sound, 60, TRUE)
	else
		to_chat(loc, span_warning("[src] silently charges up."))
	update_appearance()

/obj/item/gun/energy/recharge/update_overlays()
	. = ..()
	if(!no_charge_state && !can_fire())
		. += "[base_icon_state]_empty"

/obj/item/gun/energy/recharge/update_icon_state()
	. = ..()
	if(no_charge_state && !can_fire())
		icon_state = no_charge_state

TYPEINFO_DEF(/obj/item/gun/energy/recharge/ebow)
	default_materials = list(/datum/material/iron=2000)

/obj/item/gun/energy/recharge/ebow
	name = "mini energy crossbow"
	desc = "A weapon favored by syndicate stealth specialists."
	icon_state = "crossbow"
	base_icon_state = "crossbow"
	inhand_icon_state = "crossbow"
	no_charge_state = "crossbow_empty"
	w_class = WEIGHT_CLASS_SMALL
	suppressed = TRUE
	ammo_type = list(/obj/item/ammo_casing/energy/bolt)
	recharge_time = 2 SECONDS
	holds_charge = TRUE
	unique_frequency = TRUE
	can_bayonet = TRUE
	knife_x_offset = 20
	knife_y_offset = 12

/obj/item/gun/energy/recharge/ebow/halloween
	name = "candy corn crossbow"
	desc = "A weapon favored by Syndicate trick-or-treaters."
	icon_state = "crossbow_halloween"
	base_icon_state = "crossbow_halloween"
	no_charge_state = "crossbow_halloween_empty"
	ammo_type = list(/obj/item/ammo_casing/energy/bolt/halloween)

TYPEINFO_DEF(/obj/item/gun/energy/recharge/ebow/large)
	default_materials = list(/datum/material/iron=4000)

/obj/item/gun/energy/recharge/ebow/large
	name = "energy crossbow"
	desc = "A reverse engineered weapon using syndicate technology."
	icon_state = "crossbowlarge"
	base_icon_state = "crossbowlarge"
	no_charge_state = "crossbowlarge_empty"
	w_class = WEIGHT_CLASS_BULKY
	suppressed = null
	ammo_type = list(/obj/item/ammo_casing/energy/bolt/large)
