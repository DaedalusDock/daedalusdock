/obj/item/gun/magic/wand
	name = "wand"
	desc = "You shouldn't have this."
	ammo_type = /obj/item/ammo_casing/magic
	icon_state = "nothingwand"
	inhand_icon_state = "wand"
	base_icon_state = "nothingwand"
	w_class = WEIGHT_CLASS_SMALL
	can_charge = FALSE
	max_charges = 100 //100, 50, 50, 34 (max charge distribution by 25%ths)
	var/variable_charges = TRUE

/obj/item/gun/magic/wand/Initialize(mapload)
	if(prob(75) && variable_charges) //25% chance of listed max charges, 50% chance of 1/2 max charges, 25% chance of 1/3 max charges
		if(prob(33))
			max_charges = CEILING(max_charges / 3, 1)
		else
			max_charges = CEILING(max_charges / 2, 1)
	return ..()

/obj/item/gun/magic/wand/examine(mob/user)
	. = ..()
	. += "Has [charges] charge\s remaining."

/obj/item/gun/magic/wand/update_icon_state()
	icon_state = "[base_icon_state][charges ? null : "-drained"]"
	return ..()

/obj/item/gun/magic/wand/attack(atom/target, mob/living/user)
	if(target == user)
		return
	..()

/obj/item/gun/magic/wand/try_fire_gun(atom/target, mob/living/user, proximity, params)
	if(!charges)
		shoot_with_empty_chamber(user)
		return FALSE

	if(target == user)
		if(no_den_usage)
			var/area/A = get_area(user)
			if(istype(A, /area/centcom/wizard_station))
				to_chat(user, span_warning("You know better than to violate the security of The Den, best wait until you leave to use [src]."))
				return FALSE
			else
				no_den_usage = 0
		zap_self(user)
	else
		. = ..()
	update_appearance()


/obj/item/gun/magic/wand/proc/zap_self(mob/living/user)
	user.visible_message(span_danger("[user] zaps [user.p_them()]self with [src]."))
	playsound(user, fire_sound, 50, TRUE)
	user.log_message("zapped [user.p_them()]self with a <b>[src]</b>", LOG_ATTACK)


/////////////////////////////////////
//WAND OF DEATH
/////////////////////////////////////

/obj/item/gun/magic/wand/death
	name = "wand of death"
	desc = "This deadly wand overwhelms the victim's body with pure energy, slaying them without fail."
	school = SCHOOL_NECROMANCY
	fire_sound = 'sound/magic/wandodeath.ogg'
	ammo_type = /obj/item/ammo_casing/magic/death
	icon_state = "deathwand"
	base_icon_state = "deathwand"
	max_charges = 3 //3, 2, 2, 1

/obj/item/gun/magic/wand/death/zap_self(mob/living/user)
	..()
	charges--
	if(user.can_block_magic())
		user.visible_message(span_warning("[src] has no effect on [user]!"))
		return
	if(isliving(user))
		var/mob/living/L = user
		if(L.mob_biotypes & MOB_UNDEAD) //negative energy heals the undead
			user.revive(full_heal = TRUE, admin_revive = TRUE)
			to_chat(user, span_notice("You feel great!"))
			return
	to_chat(user, "<span class='warning'>You irradiate yourself with pure negative energy! \
	[pick("Do not pass go. Do not collect 200 zorkmids.","You feel more confident in your spell casting skills.","You die...","Do you want your possessions identified?")]\
	</span>")
	user.death(FALSE)

/obj/item/gun/magic/wand/death/debug
	desc = "In some obscure circles, this is known as the 'cloning tester's friend'."
	max_charges = 500
	variable_charges = FALSE
	can_charge = TRUE
	recharge_rate = 1


/////////////////////////////////////
//WAND OF HEALING
/////////////////////////////////////

/obj/item/gun/magic/wand/resurrection
	name = "wand of healing"
	desc = "This wand uses healing magics to heal and revive. They are rarely utilized within the Wizard Federation for some reason."
	school = SCHOOL_RESTORATION
	ammo_type = /obj/item/ammo_casing/magic/heal
	fire_sound = 'sound/magic/staff_healing.ogg'
	icon_state = "revivewand"
	base_icon_state = "revivewand"
	max_charges = 10 //10, 5, 5, 4

/obj/item/gun/magic/wand/resurrection/zap_self(mob/living/user)
	..()
	charges--
	if(user.can_block_magic())
		user.visible_message(span_warning("[src] has no effect on [user]!"))
		return
	if(isliving(user))
		var/mob/living/L = user
		if(L.mob_biotypes & MOB_UNDEAD) //positive energy harms the undead
			to_chat(user, "<span class='warning'>You irradiate yourself with pure positive energy! \
			[pick("Do not pass go. Do not collect 200 zorkmids.","You feel more confident in your spell casting skills.","You die...","Do you want your possessions identified?")]\
			</span>")
			user.death(0)
			return
	user.revive(full_heal = TRUE, admin_revive = TRUE)
	to_chat(user, span_notice("You feel great!"))

/obj/item/gun/magic/wand/resurrection/debug //for testing
	desc = "Is it possible for something to be even more powerful than regular magic? This wand is."
	max_charges = 500
	variable_charges = FALSE
	can_charge = TRUE
	recharge_rate = 1

/////////////////////////////////////
//WAND OF POLYMORPH
/////////////////////////////////////

/obj/item/gun/magic/wand/polymorph
	name = "wand of polymorph"
	desc = "This wand is attuned to chaos and will radically alter the victim's form."
	school = SCHOOL_TRANSMUTATION
	ammo_type = /obj/item/ammo_casing/magic/change
	icon_state = "polywand"
	base_icon_state = "polywand"
	fire_sound = 'sound/magic/staff_change.ogg'
	max_charges = 10 //10, 5, 5, 4

/obj/item/gun/magic/wand/polymorph/zap_self(mob/living/user)
	..() //because the user mob ceases to exists by the time wabbajack fully resolves

	user.wabbajack()
	charges--

/////////////////////////////////////
//WAND OF TELEPORTATION
/////////////////////////////////////

/obj/item/gun/magic/wand/teleport
	name = "wand of teleportation"
	desc = "This wand will wrench targets through space and time to move them somewhere else."
	school = SCHOOL_TRANSLOCATION
	ammo_type = /obj/item/ammo_casing/magic/teleport
	fire_sound = 'sound/magic/wand_teleport.ogg'
	icon_state = "telewand"
	base_icon_state = "telewand"
	max_charges = 10 //10, 5, 5, 4
	no_den_usage = TRUE

/obj/item/gun/magic/wand/teleport/zap_self(mob/living/user)
	if(do_teleport(user, user, 10, channel = TELEPORT_CHANNEL_MAGIC))
		var/datum/effect_system/fluid_spread/smoke/smoke = new
		smoke.set_up(3, location = user.loc)
		smoke.start()
		charges--
	..()

/obj/item/gun/magic/wand/safety
	name = "wand of safety"
	desc = "This wand will use the lightest of bluespace currents to gently place the target somewhere safe."
	school = SCHOOL_TRANSLOCATION
	ammo_type = /obj/item/ammo_casing/magic/safety
	fire_sound = 'sound/magic/wand_teleport.ogg'
	icon_state = "telewand"
	base_icon_state = "telewand"
	max_charges = 10 //10, 5, 5, 4
	no_den_usage = FALSE

/obj/item/gun/magic/wand/safety/zap_self(mob/living/user)
	var/turf/origin = get_turf(user)
	var/turf/destination = find_safe_turf()

	if(do_teleport(user, destination, channel=TELEPORT_CHANNEL_MAGIC))
		for(var/t in list(origin, destination))
			var/datum/effect_system/fluid_spread/smoke/smoke = new
			smoke.set_up(0, location = t)
			smoke.start()
	..()

/obj/item/gun/magic/wand/safety/debug
	desc = "This wand has 'find_safe_turf()' engraved into its blue wood. Perhaps it's a secret message?"
	max_charges = 500
	variable_charges = FALSE
	can_charge = TRUE
	recharge_rate = 1


/////////////////////////////////////
//WAND OF DOOR CREATION
/////////////////////////////////////

/obj/item/gun/magic/wand/door
	name = "wand of door creation"
	desc = "This particular wand can create doors in any wall for the unscrupulous wizard who shuns teleportation magics."
	school = SCHOOL_TRANSMUTATION
	ammo_type = /obj/item/ammo_casing/magic/door
	icon_state = "doorwand"
	base_icon_state = "doorwand"
	fire_sound = 'sound/magic/staff_door.ogg'
	max_charges = 20 //20, 10, 10, 7
	no_den_usage = 1

/obj/item/gun/magic/wand/door/zap_self(mob/living/user)
	to_chat(user, span_notice("You feel vaguely more open with your feelings."))
	charges--
	..()

/////////////////////////////////////
//WAND OF FIREBALL
/////////////////////////////////////

/obj/item/gun/magic/wand/fireball
	name = "wand of fireball"
	desc = "This wand shoots scorching balls of fire that explode into destructive flames."
	school = SCHOOL_EVOCATION
	fire_sound = 'sound/magic/fireball.ogg'
	ammo_type = /obj/item/ammo_casing/magic/fireball
	icon_state = "firewand"
	base_icon_state = "firewand"
	max_charges = 8 //8, 4, 4, 3

/obj/item/gun/magic/wand/fireball/zap_self(mob/living/user)
	..()
	explosion(user, devastation_range = -1, light_impact_range = 2, flame_range = 2, flash_range = 3, adminlog = FALSE, explosion_cause = src)
	charges--

/////////////////////////////////////
//WAND OF NOTHING
/////////////////////////////////////

/obj/item/gun/magic/wand/nothing
	name = "wand of nothing"
	desc = "It's not just a stick, it's a MAGIC stick?"
	ammo_type = /obj/item/ammo_casing/magic/nothing
