//Supply modules for MODsuits

///Internal GPS - Extends a GPS you can use.
/obj/item/mod/module/gps
	name = "MOD internal GPS module"
	desc = "This module uses common Nanotrasen technology to calculate the user's position anywhere in space, \
		down to the exact coordinates. This information is fed to a central database viewable from the device itself, \
		though using it to help people is up to you."
	icon_state = "gps"
	module_type = MODULE_USABLE
	complexity = 1
	use_power_cost = DEFAULT_CHARGE_DRAIN * 0.2
	incompatible_modules = list(/obj/item/mod/module/gps)
	cooldown_time = 0.5 SECONDS

/obj/item/mod/module/gps/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/gps/item, "MOD0", state = GLOB.deep_inventory_state, overlay_state = FALSE)

/obj/item/mod/module/gps/on_use()
	attack_self(mod.wearer)

///Hydraulic Clamp - Lets you pick up and drop crates.
/obj/item/mod/module/clamp
	name = "MOD hydraulic clamp module"
	desc = "A series of actuators installed into both arms of the suit, boasting a lifting capacity of almost a ton. \
		However, this design has been locked by Hermes Galactic to be primarily utilized for lifting various crates. \
		A lot of people would say that loading cargo is a dull job, but you could not disagree more."
	icon_state = "clamp"
	module_type = MODULE_ACTIVE
	complexity = 3
	use_power_cost = DEFAULT_CHARGE_DRAIN
	incompatible_modules = list(/obj/item/mod/module/clamp)
	cooldown_time = 0.5 SECONDS
	overlay_state_inactive = "module_clamp"
	overlay_state_active = "module_clamp_on"
	required_slots = list(ITEM_SLOT_GLOVES, ITEM_SLOT_BACK)
	/// Time it takes to load a crate.
	var/load_time = 3 SECONDS
	/// The max amount of crates you can carry.
	var/max_crates = 3
	/// The crates stored in the module.
	var/list/stored_crates = list()

/obj/item/mod/module/clamp/on_select_use(atom/target)
	. = ..()
	if(!.)
		return
	if(!mod.wearer.Adjacent(target))
		return
	if(istype(target, /obj/structure/closet/crate) || istype(target, /obj/item/delivery/big))
		var/atom/movable/picked_crate = target
		if(!check_crate_pickup(picked_crate))
			return
		playsound(src, 'sound/mecha/hydraulic.ogg', 25, TRUE)
		if(!do_after(mod.wearer, target, load_time))
			balloon_alert(mod.wearer, "interrupted!")
			return
		if(!check_crate_pickup(picked_crate))
			return
		stored_crates += picked_crate
		picked_crate.forceMove(src)
		balloon_alert(mod.wearer, "picked up [picked_crate]")
		drain_power(use_power_cost)
		mod.wearer.update_worn_back()
	else if(length(stored_crates))
		var/turf/target_turf = get_turf(target)
		if(target_turf.is_blocked_turf())
			return
		playsound(src, 'sound/mecha/hydraulic.ogg', 25, TRUE)
		if(!do_after(mod.wearer, target, load_time))
			balloon_alert(mod.wearer, "interrupted!")
			return
		if(target_turf.is_blocked_turf())
			return
		var/atom/movable/dropped_crate = pop(stored_crates)
		dropped_crate.forceMove(target_turf)
		balloon_alert(mod.wearer, "dropped [dropped_crate]")
		drain_power(use_power_cost)
		mod.wearer.update_worn_back()
	else
		balloon_alert(mod.wearer, "invalid target!")

/obj/item/mod/module/clamp/on_suit_deactivation(deleting = FALSE)
	if(deleting)
		return
	for(var/atom/movable/crate as anything in stored_crates)
		crate.forceMove(drop_location())
		stored_crates -= crate

/obj/item/mod/module/clamp/proc/check_crate_pickup(atom/movable/target)
	if(length(stored_crates) >= max_crates)
		balloon_alert(mod.wearer, "too many crates!")
		return FALSE
	for(var/mob/living/mob in target.get_all_contents())
		if(mob.mob_size < MOB_SIZE_HUMAN)
			continue
		balloon_alert(mod.wearer, "crate too heavy!")
		return FALSE
	return TRUE

/obj/item/mod/module/clamp/loader
	name = "MOD loader hydraulic clamp module"
	icon_state = "clamp_loader"
	complexity = 0
	removable = FALSE
	overlay_state_inactive = null
	overlay_state_active = "module_clamp_loader"
	load_time = 1 SECONDS
	max_crates = 5
	use_mod_colors = TRUE
	required_slots = list(ITEM_SLOT_BACK)

///Drill - Lets you dig through rock and basalt.
/obj/item/mod/module/drill
	name = "MOD drill module"
	desc = "An integrated drill, typically extending over the user's hand. While useful for drilling through rock, \
		your drill is surely the one that both pierces and creates the heavens."
	icon_state = "drill"
	module_type = MODULE_ACTIVE
	complexity = 2
	use_power_cost = DEFAULT_CHARGE_DRAIN
	incompatible_modules = list(/obj/item/mod/module/drill)
	cooldown_time = 0.5 SECONDS
	overlay_state_active = "module_drill"

/obj/item/mod/module/drill/on_activation()
	RegisterSignal(mod.wearer, COMSIG_MOVABLE_BUMP, PROC_REF(bump_mine))

/obj/item/mod/module/drill/on_deactivation(display_message = TRUE, deleting = FALSE)
	UnregisterSignal(mod.wearer, COMSIG_MOVABLE_BUMP)

/obj/item/mod/module/drill/on_select_use(atom/target)
	. = ..()
	if(!.)
		return
	if(!mod.wearer.Adjacent(target))
		return
	if(istype(target, /turf/closed/mineral))
		var/turf/closed/mineral/mineral_turf = target
		mineral_turf.MinedAway()
		drain_power(use_power_cost)
	else if(istype(target, /turf/open/misc/asteroid))
		var/turf/open/misc/asteroid/sand_turf = target
		if(!sand_turf.can_dig(mod.wearer))
			return
		sand_turf.getDug()
		drain_power(use_power_cost)

/obj/item/mod/module/drill/proc/bump_mine(mob/living/carbon/human/bumper, atom/bumped_into, proximity)
	SIGNAL_HANDLER
	if(!istype(bumped_into, /turf/closed/mineral) || !drain_power(use_power_cost))
		return
	var/turf/closed/mineral/mineral_turf = bumped_into
	mineral_turf.MinedAway()
	return COMPONENT_CANCEL_ATTACK_CHAIN

///Ore Bag - Lets you pick up ores and drop them from the suit.
/obj/item/mod/module/orebag
	name = "MOD ore bag module"
	desc = "An integrated ore storage system installed into the suit, \
		this utilizes precise electromagnets and storage compartments to automatically collect and deposit ore. \
		It's recommended by Nakamura Engineering to actually deposit that ore at local refineries."
	icon_state = "ore"
	module_type = MODULE_USABLE
	complexity = 1
	use_power_cost = DEFAULT_CHARGE_DRAIN * 0.2
	incompatible_modules = list(/obj/item/mod/module/orebag)
	required_slots = list(ITEM_SLOT_BACK)
	cooldown_time = 0.5 SECONDS
	/// The ores stored in the bag.
	var/list/ores = list()

/obj/item/mod/module/orebag/on_equip()
	RegisterSignal(mod.wearer, COMSIG_MOVABLE_MOVED, PROC_REF(ore_pickup))

/obj/item/mod/module/orebag/on_unequip()
	UnregisterSignal(mod.wearer, COMSIG_MOVABLE_MOVED)

/obj/item/mod/module/orebag/proc/ore_pickup(atom/movable/source, atom/old_loc, dir, forced)
	SIGNAL_HANDLER

	for(var/obj/item/stack/ore/ore in get_turf(mod.wearer))
		INVOKE_ASYNC(src, PROC_REF(move_ore), ore)
		playsound(src, SFX_RUSTLE, 50, TRUE)

/obj/item/mod/module/orebag/proc/move_ore(obj/item/stack/ore)
	for(var/obj/item/stack/stored_ore as anything in ores)
		if(!ore.can_merge(stored_ore))
			continue
		ore.merge(stored_ore)
		if(QDELETED(ore))
			return
		break
	ore.forceMove(src)
	ores += ore

/obj/item/mod/module/orebag/on_use()
	for(var/obj/item/ore as anything in ores)
		ore.forceMove(drop_location())
		ores -= ore
	drain_power(use_power_cost)

/obj/item/mod/module/hydraulic
	name = "MOD loader hydraulic arms module"
	desc = "A pair of powerful hydraulic arms installed in a MODsuit."
	icon_state = "launch_loader"
	module_type = MODULE_ACTIVE
	removable = FALSE
	use_power_cost = DEFAULT_CHARGE_DRAIN*10
	incompatible_modules = list(/obj/item/mod/module/hydraulic)
	required_slots = list(ITEM_SLOT_BACK)
	cooldown_time = 4 SECONDS
	overlay_state_inactive = "module_hydraulic"
	overlay_state_active = "module_hydraulic_active"
	use_mod_colors = TRUE
	/// Time it takes to launch
	var/launch_time = 2 SECONDS
	/// User overlay
	var/mutable_appearance/lightning

/obj/item/mod/module/hydraulic/on_select_use(atom/target)
	. = ..()
	if(!.)
		return
	var/atom/game_renderer = mod.wearer.hud_used.plane_masters["[RENDER_PLANE_GAME]"]
	var/matrix/render_matrix = matrix(game_renderer.transform)
	render_matrix.Scale(1.25, 1.25)
	animate(game_renderer, launch_time, transform = render_matrix)
	var/current_time = world.time
	mod.wearer.visible_message(span_warning("[mod.wearer] starts whirring!"), \
		blind_message = span_hear("You hear a whirring sound."))
	playsound(src, 'sound/items/modsuit/loader_charge.ogg', 75, TRUE)
	lightning = mutable_appearance('icons/effects/effects.dmi', "electricity3", plane = GAME_PLANE)
	mod.wearer.add_overlay(lightning)
	balloon_alert(mod.wearer, "you start charging...")
	var/power = launch_time
	if(!do_after(mod.wearer, mod, launch_time))
		power = world.time - current_time
		animate(game_renderer)
	drain_power(use_power_cost)
	new /obj/effect/temp_visual/mook_dust(get_turf(src))
	playsound(src, 'sound/items/modsuit/loader_launch.ogg', 75, TRUE)
	game_renderer.transform = game_renderer.transform.Scale(0.8, 0.8)
	mod.wearer.cut_overlay(lightning)
	var/angle = get_angle(mod.wearer, target)
	mod.wearer.transform = mod.wearer.transform.Turn(angle)
	mod.wearer.throw_at(get_ranged_target_turf_direct(mod.wearer, target, power), \
		range = power, speed = max(round(0.2*power), 1), thrower = mod.wearer, spin = FALSE, \
		callback = CALLBACK(src, PROC_REF(on_throw_end), target, -angle))

/obj/item/mod/module/hydraulic/proc/on_throw_end(atom/target, angle)
	if(!mod?.wearer)
		return
	mod.wearer.transform = mod.wearer.transform.Turn(angle)

/obj/item/mod/module/disposal_connector
	name = "MOD disposal selector module"
	desc = "A module that connects to the disposal pipeline, causing the user to go into their config selected disposal. \
		Only seems to work when the suit is on."
	icon_state = "disposal"
	complexity = 2
	idle_power_cost = DEFAULT_CHARGE_DRAIN * 0.3
	incompatible_modules = list(/obj/item/mod/module/disposal_connector)
	var/disposal_tag = NONE

/obj/item/mod/module/disposal_connector/Initialize(mapload)
	. = ..()
	disposal_tag = pick(GLOB.TAGGERLOCATIONS)

/obj/item/mod/module/disposal_connector/on_suit_activation()
	RegisterSignal(mod.wearer, COMSIG_MOVABLE_DISPOSING, PROC_REF(disposal_handling))

/obj/item/mod/module/disposal_connector/on_suit_deactivation(deleting = FALSE)
	UnregisterSignal(mod.wearer, COMSIG_MOVABLE_DISPOSING)

/obj/item/mod/module/disposal_connector/get_configuration()
	. = ..()
	.["disposal_tag"] = add_ui_configuration("Disposal Tag", "list", GLOB.TAGGERLOCATIONS[disposal_tag], GLOB.TAGGERLOCATIONS)

/obj/item/mod/module/disposal_connector/configure_edit(key, value)
	switch(key)
		if("disposal_tag")
			for(var/tag in 1 to length(GLOB.TAGGERLOCATIONS))
				if(GLOB.TAGGERLOCATIONS[tag] == value)
					disposal_tag = tag
					break

/obj/item/mod/module/disposal_connector/proc/disposal_handling(datum/disposal_source, obj/structure/disposalholder/disposal_holder, obj/machinery/disposal/disposal_machine, hasmob)
	SIGNAL_HANDLER

	disposal_holder.destinationTag = disposal_tag

/obj/item/mod/module/magnet
	name = "MOD loader hydraulic magnet module"
	desc = "A powerful hydraulic electromagnet able to launch crates and lockers towards the user, and keep 'em attached."
	icon_state = "magnet_loader"
	module_type = MODULE_ACTIVE
	removable = FALSE
	use_power_cost = DEFAULT_CHARGE_DRAIN*3
	incompatible_modules = list(/obj/item/mod/module/magnet)
	required_slots = list(ITEM_SLOT_BACK)
	cooldown_time = 1.5 SECONDS
	overlay_state_active = "module_magnet"
	use_mod_colors = TRUE

/obj/item/mod/module/magnet/on_select_use(atom/target)
	. = ..()
	if(!.)
		return
	var/obj/structure/closet/locker = mod.wearer.get_active_grab()?.affecting
	if(istype(locker, /obj/structure/closet))
		playsound(locker, 'sound/effects/gravhit.ogg', 75, TRUE)
		locker.forceMove(mod.wearer.loc)
		locker.throw_at(target, range = 7, speed = 4, thrower = mod.wearer)
		return
	if(!istype(target, /obj/structure/closet) || !(target in view(mod.wearer)))
		balloon_alert(mod.wearer, "invalid target!")
		return

	if(locker.anchored || locker.move_resist >= MOVE_FORCE_OVERPOWERING)
		balloon_alert(mod.wearer, "target anchored!")
		return
	new /obj/effect/temp_visual/mook_dust(get_turf(locker))
	playsound(locker, 'sound/effects/gravhit.ogg', 75, TRUE)
	locker.throw_at(mod.wearer, range = 7, speed = 3, force = MOVE_FORCE_WEAK, \
		callback = CALLBACK(src, PROC_REF(check_locker), locker))

/obj/item/mod/module/magnet/on_deactivation(display_message = TRUE, deleting = FALSE)
	for(var/obj/item/hand_item/grab/G in mod.wearer.active_grabs)
		if(istype(G.affecting, /obj/structure/closet))
			qdel(G)

/obj/item/mod/module/magnet/proc/check_locker(obj/structure/closet/locker)
	if(!mod?.wearer)
		return
	if(!locker.Adjacent(mod.wearer) || !isturf(locker.loc) || !isturf(mod.wearer.loc))
		return
	mod.wearer.try_make_grab(locker)
	locker.strong_grab = TRUE
	RegisterSignal(locker, COMSIG_ATOM_NO_LONGER_GRABBED, PROC_REF(on_stop_pull))

/obj/item/mod/module/magnet/proc/on_stop_pull(obj/structure/closet/locker, atom/movable/last_puller)
	SIGNAL_HANDLER

	locker.strong_grab = FALSE
	UnregisterSignal(locker, COMSIG_ATOM_NO_LONGER_GRABBED)

/obj/projectile/bullet/reusable/mining_bomb
	name = "mining bomb"
	desc = "A bomb. Why are you examining this?"
	icon_state = "mine_bomb"
	icon = 'icons/obj/clothing/modsuit/mod_modules.dmi'
	damage = 0
	nodamage = TRUE
	range = 6
	suppressed = SUPPRESSED_VERY
	armor_flag = BOMB
	light_system = OVERLAY_LIGHT
	light_outer_range = 1
	light_power = 1
	light_color = COLOR_LIGHT_ORANGE
	ammo_type = /obj/structure/mining_bomb

/obj/structure/mining_bomb
	name = "mining bomb"
	desc = "A bomb. Why are you examining this?"
	icon_state = "mine_bomb"
	icon = 'icons/obj/clothing/modsuit/mod_modules.dmi'
	anchored = TRUE
	resistance_flags = FIRE_PROOF|LAVA_PROOF
	light_system = OVERLAY_LIGHT
	light_outer_range = 1
	light_power = 1
	light_color = COLOR_LIGHT_ORANGE
	/// Time to prime the explosion
	var/prime_time = 0.5 SECONDS
	/// Time to explode from the priming
	var/explosion_time = 1 SECONDS
	/// Damage done on explosion.
	var/damage = 15
	/// Damage multiplier on hostile fauna.
	var/fauna_boost = 4
	/// Damage multiplier on objects
	var/object_boost = 2
	/// Image overlaid on explosion.
	var/static/image/explosion_image

/obj/structure/mining_bomb/Initialize(mapload)
	. = ..()
	if(!explosion_image)
		explosion_image = image('icons/effects/96x96.dmi', "judicial_explosion", layer = FLY_LAYER)
		explosion_image.pixel_x = -32
		explosion_image.pixel_y = -32
	addtimer(CALLBACK(src, PROC_REF(prime)), prime_time)

/obj/structure/mining_bomb/proc/prime()
	add_overlay(explosion_image)
	addtimer(CALLBACK(src, PROC_REF(boom)), explosion_time)

/obj/structure/mining_bomb/proc/boom()
	visible_message(span_danger("[src] explodes!"))
	playsound(src, 'sound/magic/magic_missile.ogg', 200, vary = TRUE)
	for(var/turf/closed/mineral/rock in circle_range_turfs(src, 2))
		rock.MinedAway()
	for(var/mob/living/mob in range(1, src))
		mob.apply_damage(12 * (ishostile(mob) ? fauna_boost : 1), BRUTE, spread_damage = TRUE)
	for(var/obj/object in range(1, src))
		object.take_damage(damage * object_boost, BRUTE, BOMB)
	qdel(src)
