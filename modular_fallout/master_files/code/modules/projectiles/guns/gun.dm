/obj/item/gun
	var/extra_damage = 0
	var/extra_penetration = 0
	var/extra_speed = 0
	var/inaccuracy_modifier = 1

	var/flight_y_offset = 0
	var/flight_x_offset = 0

	var/knife_x_offset = 0
	var/knife_y_offset = 0

	var/scope_x_offset = 5
	var/scope_y_offset = 14

	var/scope_state = "scope_medium"
	var/mutable_appearance/scope_overlay
	var/can_scope = FALSE

	var/can_automatic = FALSE
	var/can_attachments = FALSE
	var/can_flashlight = FALSE //if a flashlight can be added or removed if it already has one.

	var/obj/item/flashlight/seclite/gun_light
	var/datum/action/item_action/toggle_gunlight/alight
	var/gunlight_state = "flight"
	var/mutable_appearance/flashlight_overlay

	var/mutable_appearance/suppressor_overlay
	var/suppressor_state = null
	var/suppressed = null					//whether or not a message is displayed when fired

	var/mutable_appearance/knife_overlay
	var/bayonet_state = "bayonetstraight"

	var/weapon_weight = WEAPON_LIGHT	//used for inaccuracy and wielding requirements/penalties

	var/obj/item/attachments/scope
	var/obj/item/attachments/recoil_decrease
	var/obj/item/attachments/burst_improvement
	var/obj/item/attachments/auto_sear

	//Zooming
	var/zoomable = FALSE //whether the gun generates a Zoom action on creation
	var/zoomed = FALSE //Zoom toggle
	var/zoom_amt = 3 //Distance in TURFs to move the user's screen forward (the "zoom" effect)
	var/zoom_out_amt = 0
	var/datum/action/item_action/toggle_scope_zoom/azoom

	var/dualwield_spread_mult = 1		//dualwield spread multiplier

	var/equipsound = 'modular_fallout/master_files/sound/f13weapons/equipsounds/pistolequip.ogg'
	var/isenergy = null
	var/isbow = null

	var/burst_shot_delay = 1

	var/worn_out = FALSE

/obj/item/gun/update_overlays()
	. = ..()
	if(gun_light)
		var/state = "[gunlight_state][gun_light.on? "_on":""]"	//Generic state.
		if(gun_light.icon_state in icon_states('modular_fallout/master_files/icons/fallout/objects/guns/attachments.dmi'))	//Snowflake state?
			state = gun_light.icon_state
		flashlight_overlay = mutable_appearance('modular_fallout/master_files/icons/fallout/objects/guns/attachments.dmi', state)
		flashlight_overlay.pixel_x = flight_x_offset
		flashlight_overlay.pixel_y = flight_y_offset
		. += flashlight_overlay
	else
		flashlight_overlay = null

	if(bayonet)
		if(bayonet.icon_state in icon_states('modular_fallout/master_files/icons/fallout/objects/guns/attachments.dmi'))		//Snowflake state?
			knife_overlay = bayonet.icon_state
		var/icon/bayonet_icons = 'modular_fallout/master_files/icons/fallout/objects/guns/attachments.dmi'
		knife_overlay = mutable_appearance(bayonet_icons, bayonet_state)
		knife_overlay.pixel_x = knife_x_offset
		knife_overlay.pixel_y = knife_y_offset
		. += knife_overlay
	else
		knife_overlay = null

	if(scope)
		if(scope.icon_state in icon_states('modular_fallout/master_files/icons/fallout/objects/guns/attachments.dmi'))
			scope_overlay = scope.icon_state
		var/icon/scope_icons = 'modular_fallout/master_files/icons/fallout/objects/guns/attachments.dmi'
		scope_overlay = mutable_appearance(scope_icons, scope_state)
		scope_overlay.pixel_x = scope_x_offset
		scope_overlay.pixel_y = scope_y_offset
		. += scope_overlay
	else
		scope_overlay = null

	if(suppressed)
		var/icon/suppressor_icons = 'modular_fallout/master_files/icons/fallout/objects/guns/attachments.dmi'
		suppressor_overlay = mutable_appearance(suppressor_icons, suppressor_state)
		suppressor_overlay.pixel_x = suppressor_x_offset
		suppressor_overlay.pixel_y = suppressor_y_offset
		. += suppressor_overlay
	else
		suppressor_overlay = null

	if(worn_out)
		. += ("[initial(icon_state)]_worn")
		src.fire_delay += 0.1
		src.spread += 2
		src.extra_damage -= 1

/obj/item/gun/process_afterattack(atom/target, mob/living/user, flag, params)
	.=..()
	if(weapon_weight == WEAPON_HEAVY && user.get_inactive_held_item())
		to_chat(user, "<span class='userdanger'>You need both hands free to fire \the [src]!</span>")
		return

	user.DelayNextAction(ranged_attack_speed)

	//DUAL (or more!) WIELDING
	var/bonus_spread = 0
	var/loop_counter = 0

	if(user)
		bonus_spread = getinaccuracy(user, bonus_spread, stamloss) //CIT CHANGE - adds bonus spread while not aiming
	if(ishuman(user) && user.a_intent == INTENT_HARM && weapon_weight <= WEAPON_LIGHT)
		var/mob/living/carbon/human/H = user
		for(var/obj/item/gun/G in H.held_items)
			if(G == src || G.weapon_weight >= WEAPON_MEDIUM)
				continue
			else if(G.can_trigger_gun(user))
				bonus_spread += 24 * G.weapon_weight * G.dualwield_spread_mult
				loop_counter++
				var/stam_cost = G.getstamcost(user)
				addtimer(CALLBACK(G, /obj/item/gun.proc/process_fire, target, user, TRUE, params, null, bonus_spread, stam_cost), loop_counter)

	var/stam_cost = getstamcost(user)
	process_fire(target, user, TRUE, params, null, bonus_spread, stam_cost)
/*
/obj/item/gun/proc/do_fire_gun(atom/target, mob/living/user, message = TRUE, params, zone_override = "", bonus_spread = 0, stam_cost = 0)
	var/sprd = 0
	var/randomized_gun_spread = 0
	var/rand_spr = rand()
	if(spread)
		randomized_gun_spread = rand(0, spread)
	else if(burst_size > 1 && burst_spread)
		randomized_gun_spread = rand(0, burst_spread)
	var/randomized_bonus_spread = rand(0, bonus_spread)

	if(burst_size > 1)
		do_burst_shot(user, target, message, params, zone_override, sprd, randomized_gun_spread, randomized_bonus_spread, rand_spr, 1)
		for(var/i in 2 to burst_size)
			sleep(burst_shot_delay)
			if(QDELETED(src))
				break
			do_burst_shot(user, target, message, params, zone_override, sprd, randomized_gun_spread, randomized_bonus_spread, rand_spr, i, stam_cost)
	else
		if(chambered)
			sprd = round((rand() - 0.5) * DUALWIELD_PENALTY_EXTRA_MULTIPLIER * (randomized_gun_spread + randomized_bonus_spread))
			before_firing(target,user)
			if(!chambered.fire_casing(target, user, params, , suppressed, zone_override, sprd, extra_damage, extra_penetration, src))
				shoot_with_empty_chamber(user)
				return
			else
				if(get_dist(user, target) <= 1) //Making sure whether the target is in vicinity for the pointblank shot
					shoot_live_shot(user, 1, target, message, stam_cost)
				else
					shoot_live_shot(user, 0, target, message, stam_cost)
		else
			shoot_with_empty_chamber(user)
			return
		process_chamber(user)
		update_icon()

	SSblackbox.record_feedback("tally", "gun_fired", 1, type)
	return TRUE
*/
/obj/item/gun/do_fire_in_burst(mob/living/user, atom/target, message = TRUE, params=null, zone_override = "", sprd = 0, randomized_gun_spread = 0, randomized_bonus_spread = 0, rand_spr = 0, iteration = 0, stam_cost = 0)
	.=..()
	if(chambered && chambered.BB)
		if(HAS_TRAIT(user, TRAIT_PACIFISM)) // If the user has the pacifist trait, then they won't be able to fire [src] if the round chambered inside of [src] is lethal.
			if(chambered.harmful) // Is the bullet chambered harmful?
				to_chat(user, "<span class='notice'> [src] is lethally chambered! You don't want to risk harming anyone...</span>")
				return
		if(randomspread)
			sprd = round((rand() - 0.5) * DUALWIELD_PENALTY_EXTRA_MULTIPLIER * (randomized_gun_spread + randomized_bonus_spread), 1)
		else //Smart spread
			sprd = round((((rand_spr/burst_size) * iteration) - (0.5 + (rand_spr * 0.25))) * (randomized_gun_spread + randomized_bonus_spread), 1)
		before_firing(target,user)
		if(!chambered.fire_casing(target, user, params, , suppressed, zone_override, sprd, extra_damage, extra_penetration, src))
			shoot_with_empty_chamber(user)
			firing = FALSE
			return FALSE
		else
			if(get_dist(user, target) <= 1) //Making sure whether the target is in vicinity for the pointblank shot
				shoot_live_shot(user, 1, target, message, stam_cost)
			else
				shoot_live_shot(user, 0, target, message, stam_cost)
			if (iteration >= burst_size)
				firing = FALSE
	else
		shoot_with_empty_chamber(user)
		firing = FALSE
		return FALSE
	process_chamber(user)
	update_icon()
	return TRUE

/obj/item/gun/proc/getinaccuracy(mob/living/user, bonus_spread, stamloss)
	if(inaccuracy_modifier == 0)
		return bonus_spread
	var/base_inaccuracy = weapon_weight * 25 * inaccuracy_modifier //+ 50 + (-user.special_p*5)//SPECIAL Integration
	var/aiming_delay = 0 //Otherwise aiming would be meaningless for slower guns such as sniper rifles and launchers.
	if(fire_delay)
		var/penalty = (last_fire + GUN_AIMING_TIME + fire_delay) - world.time
		if(penalty > 0) //Yet we only penalize users firing it multiple times in a haste. fire_delay isn't necessarily cumbersomeness.
			aiming_delay = penalty
	if(HAS_TRAIT(user, TRAIT_EXHAUSTED)) //This can null out the above bonus.
		base_inaccuracy *= 1 + (stamloss - STAMINA_NEAR_SOFTCRIT)/(STAMINA_NEAR_CRIT - STAMINA_NEAR_SOFTCRIT)*0.5
	if(HAS_TRAIT(user, TRAIT_POOR_AIM)) //nice shootin' tex
		if(!HAS_TRAIT(user, TRAIT_INSANE_AIM))
			bonus_spread += 60
		else
			//you have both poor aim and insane aim, why?
			bonus_spread += rand(0,50)
	var/mult = max((GUN_AIMING_TIME + aiming_delay + user.last_click_move - world.time)/GUN_AIMING_TIME, -0.5) //Yes, there is a bonus for taking time aiming.
	if(mult < 0) //accurate weapons should provide a proper bonus with negative inaccuracy. the opposite is true too.
		mult *= 1/inaccuracy_modifier
	return max(bonus_spread + (base_inaccuracy * mult), 0) //no negative spread.

/obj/item/gun/proc/getstamcost(mob/living/carbon/user)
	. = recoil
	if(user && !user.has_gravity())
		. = recoil*5

/obj/item/gun/attackby(obj/item/I, mob/user, params)
	if(user.a_intent == INTENT_HARM)
		return ..()

	if(istype(I, /obj/item/flashlight/seclite))
		if(!can_flashlight)
			return ..()
		var/obj/item/flashlight/seclite/S = I
		if(!gun_light)
			if(!user.transferItemToLoc(I, src))
				return
			to_chat(user, "<span class='notice'>You click [S] into place on [src].</span>")
			set_gun_light(S)
			update_gunlight()
			alight = new(src)
			if(loc == user)
				alight.Grant(user)
		return

	if(istype(I, /obj/item/melee/onehanded/knife/bayonet))
		var/obj/item/melee/onehanded/knife/bayonet/K = I
		if(!can_bayonet || !K.bayonet || bayonet) //ensure the gun has an attachment point available, and that the knife is compatible with it.
			return ..()
		if(!user.transferItemToLoc(I, src))
			return
		to_chat(user, "<span class='notice'>You attach \the [K] to the front of \the [src].</span>")
		bayonet = K
		update_icon()
		update_overlays()
		return

	if(istype(I, /obj/item/attachments/scope))
		if(!can_scope)
			return ..()
		var/obj/item/attachments/scope/C = I
		if(!scope)
			if(!user.transferItemToLoc(I, src))
				return
			to_chat(user, "<span class='notice'>You attach \the [C] to the top of \the [src].</span>")
			scope = C
			src.zoomable = TRUE
			src.zoom_amt = 10
			src.zoom_out_amt = 13
			src.build_zooming()
			update_overlays()
			update_icon()
		return

	if(istype(I, /obj/item/attachments/recoil_decrease))
		var/obj/item/attachments/recoil_decrease/R = I
		if(!recoil_decrease && can_attachments)
			if(!user.transferItemToLoc(I, src))
				return
			recoil_decrease = R
			src.desc += " It has a recoil compensator installed."
			if (src.spread > 10)
				src.spread -= 4
			else
				src.spread -= 2
			to_chat(user, "<span class='notice'>You attach \the [R] to \the [src].</span>")
			return

	if(istype(I, /obj/item/attachments/burst_improvement))
		var/obj/item/attachments/burst_improvement/T = I
		if(!burst_improvement && burst_size > 1 && can_attachments)
			if(!user.transferItemToLoc(I, src))
				return
			burst_improvement = T
			src.desc += " It has a modified burst cam installed."
			src.burst_size += 2
			src.spread += 5
			to_chat(user, "<span class='notice'>You attach \the [T] to \the [src].</span>")
			update_icon()
			return
	return ..()


/obj/item/gun/screwdriver_act(mob/living/user, obj/item/I)
	. = ..()
	if(.)
		return

	if(!user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
		return

	if(can_flashlight && gun_light)
		I.play_tool_sound(src)
		var/obj/item/flashlight/seclite/S = gun_light
		to_chat(user, "<span class='notice'>You unscrew the seclite from \the [src].</span>")
		S.forceMove(get_turf(user))
		clear_gunlight()
		return TRUE

	if(can_bayonet && bayonet)
		I.play_tool_sound(src)
		to_chat(user, "<span class='notice'>You unscrew the bayonet from \the [src].</span>")
		var/obj/item/melee/onehanded/knife/bayonet/K = bayonet
		K.forceMove(get_turf(user))
		bayonet = null
		update_icon()
		return TRUE

	if(scope)
		I.play_tool_sound(src)
		to_chat(user, "<span class='notice'>You unscrew the scope from \the [src].</span>")
		var/obj/item/attachments/scope/C = scope
		C.forceMove(get_turf(user))
		src.zoomable = FALSE
		azoom.Remove(user)
		scope = null
		update_icon()
		return TRUE


/obj/item/gun/proc/clear_gunlight()
	if(!gun_light)
		return
	var/obj/item/flashlight/seclite/removed_light = gun_light
	set_gun_light(null)
	update_gunlight()
	removed_light.update_brightness()
	QDEL_NULL(alight)
	return TRUE


/**
 * Swaps the gun's seclight, dropping the old seclight if it has not been qdel'd.
 *
 * Returns the former gun_light that has now been replaced by this proc.
 * Arguments:
 * * new_light - The new light to attach to the weapon. Can be null, which will mean the old light is removed with no replacement.
 */
/obj/item/gun/proc/set_gun_light(obj/item/flashlight/seclite/new_light)
	// Doesn't look like this should ever happen? We're replacing our old light with our old light?
	if(gun_light == new_light)
		CRASH("Tried to set a new gun light when the old gun light was also the new gun light.")

	. = gun_light

	// If there's an old gun light that isn't being QDELETED, detatch and drop it to the floor.
	if(!QDELETED(gun_light))
		gun_light.set_light_flags(gun_light.light_flags & ~LIGHT_ATTACHED)
		if(gun_light.loc == src)
			gun_light.forceMove(get_turf(src))

	// If there's a new gun light to be added, attach and move it to the gun.
	if(new_light)
		new_light.set_light_flags(new_light.light_flags | LIGHT_ATTACHED)
		if(new_light.loc != src)
			new_light.forceMove(src)

	gun_light = new_light


/obj/item/gun/ui_action_click(mob/user, action)
	if(istype(action, /datum/action/item_action/toggle_scope_zoom))
		zoom(user)
	else if(istype(action, alight))
		toggle_gunlight()

/obj/item/gun/proc/toggle_gunlight()
	if(!gun_light)
		return

	var/mob/living/carbon/human/user = usr
	gun_light.on = !gun_light.on
	gun_light.update_brightness()
	to_chat(user, "<span class='notice'>You toggle the gunlight [gun_light.on ? "on":"off"].</span>")

	playsound(user, 'modular_fallout/master_files/sound/weapons/empty.ogg', 100, TRUE)
	update_gunlight()

/obj/item/gun/proc/update_gunlight(mob/user = null)
	update_icon()
	for(var/X in actions)
		var/datum/action/A = X
		A.UpdateButtonIcon()

/obj/item/gun/pickup(mob/user)
	..()
	if(azoom)
		azoom.Grant(user)
	if(alight)
		alight.Grant(user)

/obj/item/gun/equipped(mob/living/user, slot)
	. = ..()
	if(user.get_active_held_item() != src) //we can only stay zoomed in if it's in our hands	//yeah and we only unzoom if we're actually zoomed using the gun!!
		zoom(user, FALSE)
		if(zoomable == TRUE)
			azoom.Remove(user)

/obj/item/gun/dropped(mob/user)
	. = ..()
	if(zoomed)
		zoom(user,FALSE)
	if(azoom)
		azoom.Remove(user)
	if(alight)
		alight.Remove(user)

/obj/item/gun/item_action_slot_check(slot, mob/user, datum/action/A)
	if(istype(A, /datum/action/item_action/toggle_scope_zoom) && slot != SLOT_HANDS)
		return FALSE
	return ..()

/////////////
// ZOOMING //
/////////////

/datum/action/item_action/toggle_scope_zoom
	name = "Toggle Scope"
	check_flags = AB_CHECK_CONSCIOUS|AB_CHECK_HANDS_BLOCKED|AB_CHECK_IMMOBILE
	icon = 'modular_fallout/master_files/icons/mob/actions/actions_items.dmi'
	button_icon_state = "sniper_zoom"

/datum/action/item_action/toggle_scope_zoom/Trigger()
	var/obj/item/gun/gun = target
	gun.zoom(owner)

/datum/action/item_action/toggle_scope_zoom/IsAvailable(silent = FALSE)
	. = ..()
	if(!. && target)
		var/obj/item/gun/gun = target
		gun.zoom(owner, FALSE)

/datum/action/item_action/toggle_scope_zoom/Remove(mob/living/L)
	var/obj/item/gun/gun = target
	gun.zoom(L, FALSE)
	..()

/obj/item/gun/proc/zoom(mob/living/user, forced_zoom)
	if(!(user?.client))
		return

	if(!isnull(forced_zoom))
		if(zoomed == forced_zoom)
			return
		zoomed = forced_zoom
	else
		zoomed = !zoomed

	if(zoomed)//if we need to be zoomed in
		user.add_movespeed_modifier(/datum/movespeed_modifier/scoped_in)
		var/_x = 0
		var/_y = 0
		switch(user.dir)
			if(NORTH)
				_y = zoom_amt
			if(EAST)
				_x = zoom_amt
			if(SOUTH)
				_y = -zoom_amt
			if(WEST)
				_x = -zoom_amt

		user.client.change_view(zoom_out_amt)
		user.client.pixel_x = world.icon_size*_x
		user.client.pixel_y = world.icon_size*_y
		RegisterSignal(user, COMSIG_ATOM_DIR_CHANGE, .proc/rotate)
		UnregisterSignal(user, COMSIG_MOVABLE_MOVED) //pls don't conflict with anything else using this signal
		user.visible_message("<span class='notice'>[user] looks down the scope of [src].</span>", "<span class='notice'>You look down the scope of [src].</span>")
	else
		user.remove_movespeed_modifier(/datum/movespeed_modifier/scoped_in)
		user.client.change_view(CONFIG_GET(string/default_view))
		user.client.pixel_x = 0
		user.client.pixel_y = 0
		UnregisterSignal(user, COMSIG_ATOM_DIR_CHANGE)
		user.visible_message("<span class='notice'>[user] looks up from the scope of [src].</span>", "<span class='notice'>You look up from the scope of [src].</span>")
		RegisterSignal(user, COMSIG_MOVABLE_MOVED, .proc/on_walk) //Extra proc to make sure your zoom resets for bug where you don't unzoom when toggling while moving

/obj/item/gun/proc/on_walk(mob/living/user)
	UnregisterSignal(user, COMSIG_MOVABLE_MOVED)
	user.client.change_view(CONFIG_GET(string/default_view))
	user.client.pixel_x = 0
	user.client.pixel_y = 0

/obj/item/gun/proc/rotate(mob/living/user, old_dir, direction = FALSE)
	var/_x = 0
	var/_y = 0
	switch(direction)
		if(NORTH)
			_y = zoom_amt
		if(EAST)
			_x = zoom_amt
		if(SOUTH)
			_y = -zoom_amt
		if(WEST)
			_x = -zoom_amt
	user.client.change_view(zoom_out_amt)
	user.client.pixel_x = world.icon_size*_x
	user.client.pixel_y = world.icon_size*_y

//Proc, so that gun accessories/scopes/etc. can easily add zooming.
/obj/item/gun/proc/build_zooming()
	if(azoom)
		return

	if(zoomable)
		azoom = new(src)
