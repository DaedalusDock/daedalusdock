#define MINING_MESSAGE_COOLDOWN 20
/**********************Mineral deposits**************************/

/turf/closed/mineral //wall piece
	name = "rock"
	icon = MAP_SWITCH('icons/turf/smoothrocks.dmi', 'icons/turf/mining.dmi')
	icon_state = "rock"

	smoothing_flags = SMOOTH_BITMASK | SMOOTH_BORDER
	smoothing_groups = SMOOTH_GROUP_CLOSED_TURFS + SMOOTH_GROUP_MINERAL_WALLS
	canSmoothWith = SMOOTH_GROUP_MINERAL_WALLS
	baseturfs = /turf/open/misc/asteroid/airless
	initial_gas = AIRLESS_ATMOS
	opacity = TRUE
	density = TRUE
	base_icon_state = "smoothrocks"
	temperature = TCMB

	// This is static
	// Done like this to avoid needing to make it dynamic and save cpu time
	// 4 to the left, 4 down
	transform = MAP_SWITCH(TRANSLATE_MATRIX(-4, -4), matrix())

	/// Health decreased by mining.
	var/mining_health = 20
	var/mining_max_health = 20

	var/turf/open/floor/plating/turf_type = /turf/open/misc/asteroid/airless
	var/datum/ore/mineralType = null
	var/mineralAmt = 3

	var/defer_change = 0

	/// If a turf is "weak" it can be broken with no tools
	var/weak_turf = FALSE

	///How long it takes to mine this turf without tools, if it's weak.
	var/hand_mine_speed = 15 SECONDS

//We don't call parent for perf reasons. Instead, we copy paste everything. BYOND!
/turf/closed/mineral/Initialize(mapload)
	SHOULD_CALL_PARENT(FALSE)

	if(initialized)
		stack_trace("Warning: [src]([type]) initialized multiple times!")

	initialized = TRUE

	if(mapload && permit_ao)
		queue_ao()

	// by default, vis_contents is inherited from the turf that was here before
	if(length(vis_contents))
		vis_contents.len = 0

	assemble_baseturfs()

	levelupdate()

	#ifdef UNIT_TESTS
	ASSERT_SORTED_SMOOTHING_GROUPS(smoothing_groups)
	ASSERT_SORTED_SMOOTHING_GROUPS(canSmoothWith)
	#endif

	SETUP_SMOOTHING()

	QUEUE_SMOOTH(src)

	// visibilityChanged() will never hit any path with side effects during mapload
	if (!mapload)
		visibilityChanged()

	var/area/our_area = loc
	if(!our_area.luminosity && always_lit) //Only provide your own lighting if the area doesn't for you
		add_overlay(global.fullbright_overlay)

	if (light_power && light_outer_range)
		update_light()

	if (opacity)
		directional_opacity = ALL_CARDINALS

	// apply materials properly from the default custom_materials value
	if (length(custom_materials))
		set_custom_materials(custom_materials)

	if(uses_integrity)
		atom_integrity = max_integrity

	if(mineralType)
		change_ore(mineralType, mineralAmt, TRUE)

	return INITIALIZE_HINT_NORMAL

// Inlined version of the bump click element. way faster this way, the element's nice but it's too much overhead
/turf/closed/mineral/BumpedBy(atom/movable/bumped_atom)
	. = ..()
	if(!isliving(bumped_atom))
		return

	var/mob/living/bumping = bumped_atom
	if(!ISADVANCEDTOOLUSER(bumping)) // Unadvanced tool users can't mine anyway (this is a lie). This just prevents message spam from attackby()
		return

	var/obj/item/held_item = bumping.get_active_held_item()
	// !held_item exists to be nice to snow. the other bit is for pickaxes obviously
	if(!held_item)
		INVOKE_ASYNC(bumping, TYPE_PROC_REF(/mob, ClickOn), src)
	else if(held_item.tool_behaviour == TOOL_MINING)
		attackby(held_item, bumping)

	return INITIALIZE_HINT_NORMAL

/turf/closed/mineral/update_overlays()
	. = ..()
	var/image/I
	switch(round((mining_health / mining_max_health) * 100))
		if(67 to 99)
			I = image('goon/icons/turf/damage_states.dmi', "damage1")
		if(33 to 66)
			I = image('goon/icons/turf/damage_states.dmi', "damage2")
		if(0 to 65)
			I = image('goon/icons/turf/damage_states.dmi', "damage3")
	if(I)
		I.blend_mode = BLEND_MULTIPLY
		. += I

/turf/closed/mineral/proc/spread_vein()
	var/spreadChance = mineralType.spread_chance
	if(!spreadChance)
		return

	for(var/dir in GLOB.cardinals)
		if(!prob(spreadChance))
			continue

		var/turf/T = get_step(src, dir)
		var/turf/closed/mineral/random/M = T
		if(istype(M) && !M.mineralType)
			M.change_ore(mineralType, mineralAmt, TRUE)

/turf/closed/mineral/proc/change_ore(datum/ore/new_ore, amount, random)
	if(ispath(new_ore))
		new_ore = locate(new_ore) in SSmaterials.ores
	mineralType = new_ore

	if(new_ore.mining_health)
		mining_health = new_ore.mining_health
		mining_max_health = mining_health

	if(amount)
		mineralAmt = amount

	else if(random)
		mineralAmt = rand(new_ore.amount_per_turf_min, new_ore.amount_per_turf_max)

/turf/closed/mineral/proc/mine(damage, obj/item/I, user)
	if(damage <= 0)
		return

	mining_health -= damage
	if(mining_health < 0)
		MinedAway()
		SSblackbox.record_feedback("tally", "pick_used_mining", 1, I.type)
	else
		update_appearance(UPDATE_OVERLAYS)

/turf/closed/mineral/attackby(obj/item/I, mob/user, params)
	if (!ISADVANCEDTOOLUSER(user))
		to_chat(usr, span_warning("You don't have the dexterity to do this!"))
		return

	if(!(I.tool_behaviour == TOOL_MINING))
		return

	var/turf/T = user.loc
	if (!isturf(T))
		return

	if(DOING_INTERACTION(user, "MINING_ORE"))
		return

	if(!I.use_tool(src, user, 1 SECONDS, volume=50, interaction_key = "MINING_ORE"))
		return

	if(ismineralturf(src)) // Changeturf memes
		var/damage = 40
		//I'm a hack
		if(istype(I, /obj/item/pickaxe))
			var/obj/item/pickaxe/pick = I
			damage = pick.mining_damage

		mine(damage, I)

/turf/closed/mineral/attack_hand(mob/user)
	if(!weak_turf)
		return ..()

	var/turf/user_turf = user.loc
	if (!isturf(user_turf))
		return

	if(TIMER_COOLDOWN_CHECK(src, REF(user))) //prevents mining turfs in progress
		return

	TIMER_COOLDOWN_START(src, REF(user), hand_mine_speed)

	to_chat(user, span_notice("You start pulling out pieces of [src]..."))
	if(!do_after(user, src, hand_mine_speed))
		TIMER_COOLDOWN_END(src, REF(user)) //if we fail we can start again immediately
		return

	if(ismineralturf(src))
		to_chat(user, span_notice("You finish pulling apart [src]."))
		MinedAway()

/turf/closed/mineral/attack_robot(mob/living/silicon/robot/user)
	if(user.Adjacent(src))
		attack_hand(user)

/turf/closed/mineral/proc/MinedAway()
	if (mineralType?.stack_path && (mineralAmt > 0))
		var/stack_path = mineralType.stack_path
		new mineralType.stack_path(src, mineralAmt)
		SSblackbox.record_feedback("tally", "ore_mined", mineralAmt, stack_path)

	for(var/obj/effect/temp_visual/mining_overlay/M in src)
		qdel(M)

	var/flags = NONE
	var/old_type = type
	if(defer_change) // TODO: make the defer change var a var for any changeturf flag
		flags = CHANGETURF_DEFER_CHANGE

	ScrapeAway(null, flags)
	SSzas.mark_for_update(src)
	addtimer(CALLBACK(src, PROC_REF(AfterChange), flags, old_type), 1, TIMER_UNIQUE)
	playsound(src, 'sound/effects/break_stone.ogg', 50, TRUE) //beautiful destruction


/turf/closed/mineral/attack_animal(mob/living/simple_animal/user, list/modifiers)
	if((user.environment_smash & ENVIRONMENT_SMASH_WALLS) || (user.environment_smash & ENVIRONMENT_SMASH_RWALLS))
		MinedAway()
	..()

/turf/closed/mineral/attack_alien(mob/living/carbon/alien/user, list/modifiers)
	to_chat(user, span_notice("You start digging into the rock..."))
	playsound(src, 'sound/effects/break_stone.ogg', 50, TRUE)
	if(do_after(user, src, 4 SECONDS))
		to_chat(user, span_notice("You tunnel into the rock."))
		MinedAway()

/turf/closed/mineral/attack_hulk(mob/living/carbon/human/H)
	..()
	if(do_after(H, src, 50))
		playsound(src, 'sound/effects/meteorimpact.ogg', 100, TRUE)
		H.say(pick(";RAAAAAAAARGH!", ";HNNNNNNNNNGGGGGGH!", ";GWAAAAAAAARRRHHH!", "NNNNNNNNGGGGGGGGHH!", ";AAAAAAARRRGH!" ), forced = "hulk")
		MinedAway()
	return TRUE

/turf/closed/mineral/acid_melt()
	ScrapeAway()

/turf/closed/mineral/ex_act(severity, target)
	. = ..()
	switch(severity)
		if(EXPLODE_DEVASTATE)
			MinedAway()
		if(EXPLODE_HEAVY)
			if(prob(90))
				MinedAway()
		if(EXPLODE_LIGHT)
			if(prob(75))
				MinedAway()
	return

/turf/closed/mineral/blob_act(obj/structure/blob/B)
	if(prob(50))
		MinedAway()

/turf/closed/mineral/random
	var/list/mineralSpawnChanceList = list(
		/datum/ore/uranium = 5,
		/datum/ore/diamond = 1,
		/datum/ore/gold = 10,
		/datum/ore/silver = 12,
		/datum/ore/plasma = 20,
		/datum/ore/iron = 40,
		/datum/ore/titanium = 11,
		/datum/ore/bluespace_crystal = 1
	)
	var/mineralChance = 13

/turf/closed/mineral/random/Initialize(mapload)
	mineralSpawnChanceList = typelist("mineralSpawnChanceList", mineralSpawnChanceList)

	. = ..()

	if (prob(mineralChance))
		var/path = pick_weight(mineralSpawnChanceList)
		if(ispath(path, /turf))
			var/stored_flags = 0
			if(turf_flags & NO_RUINS)
				stored_flags |= NO_RUINS
			var/turf/T = ChangeTurf(path,null,CHANGETURF_IGNORE_AIR)
			T.flags_1 |= stored_flags

			T.baseturfs = src.baseturfs
			if(ismineralturf(T))
				var/turf/closed/mineral/M = T
				M.turf_type = src.turf_type
				M.mineralAmt = rand(1, 5)
				src = M
				M.levelupdate()
			else
				src = T
				T.levelupdate()

		else
			change_ore(path, random = TRUE)
			spread_vein(path)

/turf/closed/mineral/random/high_chance
	icon_state = "rock_highchance"
	mineralChance = 25
	mineralSpawnChanceList = list(
		/datum/ore/uranium = 35, /datum/ore/diamond = 30, /datum/ore/gold = 45, /datum/ore/titanium = 45,
		/datum/ore/silver = 50, /datum/ore/plasma = 50, /datum/ore/bluespace_crystal = 20)

/turf/closed/mineral/random/low_chance
	icon_state = "rock_lowchance"
	mineralChance = 6
	mineralSpawnChanceList = list(
		/datum/ore/uranium = 2, /datum/ore/diamond = 1, /datum/ore/gold = 4, /datum/ore/titanium = 4,
		/datum/ore/silver = 6, /datum/ore/plasma = 15, /datum/ore/iron = 40,
		/turf/closed/mineral/gibtonite = 2, /datum/ore/bluespace_crystal = 1)

//extremely low chance of rare ores, meant mostly for populating stations with large amounts of asteroid
/turf/closed/mineral/random/stationside
	icon_state = "rock_nochance"
	mineralChance = 4
	mineralSpawnChanceList = list(
		/datum/ore/uranium = 1, /datum/ore/diamond = 1, /datum/ore/gold = 3, /datum/ore/titanium = 5,
		/datum/ore/silver = 4, /datum/ore/plasma = 3, /datum/ore/iron = 50)

/turf/closed/mineral/random/labormineral
	icon_state = "rock_labor"
	mineralSpawnChanceList = list(
		/datum/ore/uranium = 3, /datum/ore/diamond = 1, /datum/ore/gold = 8, /datum/ore/titanium = 8,
		/datum/ore/silver = 20, /datum/ore/plasma = 30, /datum/ore/iron = 95,
		/turf/closed/mineral/gibtonite = 2)

// Subtypes for mappers placing ores manually.
/turf/closed/mineral/iron
	mineralType = /datum/ore/iron

/turf/closed/mineral/iron/ice
	icon_state = "icerock_iron"
	icon = MAP_SWITCH('icons/turf/walls/legacy/icerock_wall.dmi', 'icons/turf/mining.dmi')
	base_icon_state = "icerock_wall"
	smoothing_flags = SMOOTH_BITMASK | SMOOTH_BORDER
	turf_type = /turf/open/misc/asteroid/snow/ice
	baseturfs = /turf/open/misc/asteroid/snow/ice
	temperature = 180
	defer_change = TRUE

/turf/closed/mineral/uranium
	mineralType = /datum/ore/uranium

/turf/closed/mineral/diamond
	mineralType = /datum/ore/diamond

/turf/closed/mineral/diamond/ice
	icon_state = "icerock_iron"
	icon = MAP_SWITCH('icons/turf/walls/legacy/icerock_wall.dmi', 'icons/turf/mining.dmi')
	base_icon_state = "icerock_wall"
	smoothing_flags = SMOOTH_BITMASK | SMOOTH_BORDER
	turf_type = /turf/open/misc/asteroid/snow/ice
	baseturfs = /turf/open/misc/asteroid/snow/ice
	temperature = 180
	defer_change = TRUE

/turf/closed/mineral/gold
	mineralType = /datum/ore/gold

/turf/closed/mineral/silver
	mineralType = /datum/ore/silver

/turf/closed/mineral/titanium
	mineralType = /datum/ore/titanium

/turf/closed/mineral/plasma
	mineralType = /datum/ore/plasma

/turf/closed/mineral/plasma/ice
	icon_state = "icerock_plasma"
	icon = MAP_SWITCH('icons/turf/walls/legacy/icerock_wall.dmi', 'icons/turf/mining.dmi')
	base_icon_state = "icerock_wall"
	smoothing_flags = SMOOTH_BITMASK | SMOOTH_BORDER
	turf_type = /turf/open/misc/asteroid/snow/ice
	baseturfs = /turf/open/misc/asteroid/snow/ice
	temperature = 180
	defer_change = TRUE

/turf/closed/mineral/bananium
	mineralType = /datum/ore/bananium
	mineralAmt = 3

/turf/closed/mineral/bscrystal
	mineralType = /datum/ore/bluespace_crystal
	mineralAmt = 1

/turf/closed/mineral/volcanic
	turf_type = /turf/open/misc/asteroid/basalt
	baseturfs = /turf/open/misc/asteroid/basalt
	initial_gas = OPENTURF_LOW_PRESSURE

/turf/closed/mineral/ash_rock //wall piece
	name = "rock"
	icon = MAP_SWITCH('icons/turf/walls/legacy/rock_wall.dmi', 'icons/turf/mining.dmi')
	icon_state = "rock2"
	base_icon_state = "rock_wall"
	smoothing_flags = SMOOTH_BITMASK | SMOOTH_BORDER
	canSmoothWith = SMOOTH_GROUP_CLOSED_TURFS
	baseturfs = /turf/open/misc/ashplanet/wateryrock
	initial_gas = OPENTURF_LOW_PRESSURE
	turf_type = /turf/open/misc/ashplanet/rocky
	defer_change = TRUE

/turf/closed/mineral/snowmountain
	name = "snowy mountainside"
	icon = MAP_SWITCH('icons/turf/walls/legacy/mountain_wall.dmi', 'icons/turf/mining.dmi')
	icon_state = "mountainrock"
	base_icon_state = "mountain_wall"
	smoothing_flags = SMOOTH_BITMASK | SMOOTH_BORDER
	canSmoothWith = SMOOTH_GROUP_CLOSED_TURFS
	baseturfs = /turf/open/misc/asteroid/snow
	temperature = 180
	turf_type = /turf/open/misc/asteroid/snow
	defer_change = TRUE

/turf/closed/mineral/snowmountain/cavern
	name = "ice cavern rock"
	icon = MAP_SWITCH('icons/turf/walls/legacy/icerock_wall.dmi', 'icons/turf/mining.dmi')
	icon_state = "icerock"
	base_icon_state = "icerock_wall"
	smoothing_flags = SMOOTH_BITMASK | SMOOTH_BORDER
	baseturfs = /turf/open/misc/asteroid/snow/ice
	turf_type = /turf/open/misc/asteroid/snow/ice

//yoo RED ROCK RED ROCK

/turf/closed/mineral/asteroid
	name = "iron rock"
	icon = MAP_SWITCH('icons/turf/walls/legacy/red_wall.dmi', 'icons/turf/mining.dmi')
	icon_state = "redrock"
	base_icon_state = "red_wall"

/// Breaks down to an asteroid floor that breaks down to space
/turf/closed/mineral/asteroid/tospace
	baseturfs = /turf/open/misc/asteroid/airless/tospace

/turf/closed/mineral/random/stationside/asteroid
	name = "iron rock"
	icon = MAP_SWITCH('icons/turf/walls/legacy/red_wall.dmi', 'icons/turf/mining.dmi')
	base_icon_state = "red_wall"

/turf/closed/mineral/random/stationside/asteroid/porus
	name = "porous iron rock"
	desc = "This rock is filled with pockets of breathable air."
	baseturfs = /turf/open/misc/asteroid

/turf/closed/mineral/asteroid/porous
	name = "porous rock"
	desc = "This rock is filled with pockets of breathable air."
	baseturfs = /turf/open/misc/asteroid

//GIBTONITE

/turf/closed/mineral/gibtonite
	mineralAmt = 1
	var/det_time = 8 //Countdown till explosion, but also rewards the player for how close you were to detonation when you defuse it
	var/stage = GIBTONITE_UNSTRUCK //How far into the lifecycle of gibtonite we are
	var/activated_ckey = null //These are to track who triggered the gibtonite deposit for logging purposes
	var/activated_name = null
	var/mutable_appearance/activated_overlay

/turf/closed/mineral/gibtonite/Initialize(mapload)
	det_time = rand(8,10) //So you don't know exactly when the hot potato will explode
	. = ..()

/turf/closed/mineral/gibtonite/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/mining_scanner) || istype(I, /obj/item/t_scanner/adv_mining_scanner) && stage == 1)
		user.visible_message(span_notice("[user] holds [I] to [src]..."), span_notice("You use [I] to locate where to cut off the chain reaction and attempt to stop it..."))
		defuse()
	..()

/turf/closed/mineral/gibtonite/proc/explosive_reaction(mob/user = null, triggered_by_explosion = 0)
	if(stage == GIBTONITE_UNSTRUCK)
		activated_overlay = mutable_appearance('icons/turf/smoothrocks.dmi', "rock_Gibtonite_inactive", ON_EDGED_TURF_LAYER) //shows in gaps between pulses if there are any
		activated_overlay.plane = GAME_PLANE
		add_overlay(activated_overlay)
		name = "gibtonite deposit"
		desc = "An active gibtonite reserve. Run!"
		stage = GIBTONITE_ACTIVE
		visible_message(span_danger("There's gibtonite inside! It's going to explode!"))

		var/notify_admins = !is_mining_level(z)

		if(!triggered_by_explosion)
			log_bomber(user, "has trigged a gibtonite deposit reaction via", src, null, notify_admins)
		else
			log_bomber(null, "An explosion has triggered a gibtonite deposit reaction via", src, null, notify_admins)

		countdown(notify_admins)

/turf/closed/mineral/gibtonite/proc/countdown(notify_admins = FALSE)
	set waitfor = FALSE
	while(istype(src, /turf/closed/mineral/gibtonite) && stage == GIBTONITE_ACTIVE && det_time > 0 && mineralAmt >= 1)
		flick_overlay_view(image('icons/turf/smoothrocks.dmi', src, "rock_Gibtonite_active"), src, 5) //makes the animation pulse one time per tick
		det_time--
		sleep(5)
	if(istype(src, /turf/closed/mineral/gibtonite))
		if(stage == GIBTONITE_ACTIVE && det_time <= 0 && mineralAmt >= 1)
			var/turf/bombturf = get_turf(src)
			mineralAmt = 0
			stage = GIBTONITE_DETONATE
			explosion(bombturf, devastation_range = 1, heavy_impact_range = 3, light_impact_range = 5, adminlog = notify_admins, explosion_cause = src)

/turf/closed/mineral/gibtonite/proc/defuse()
	if(stage == GIBTONITE_ACTIVE)
		cut_overlay(activated_overlay)
		activated_overlay.icon_state = "rock_Gibtonite_inactive"
		add_overlay(activated_overlay)
		desc = "An inactive gibtonite reserve. The ore can be extracted."
		stage = GIBTONITE_STABLE
		if(det_time < 0)
			det_time = 0
		visible_message(span_notice("The chain reaction stopped! The gibtonite had [det_time] reactions left till the explosion!"))

/turf/closed/mineral/gibtonite/MinedAway(mob/user, give_exp = FALSE, triggered_by_explosion = FALSE)
	if(stage == GIBTONITE_UNSTRUCK && mineralAmt >= 1) //Gibtonite deposit is activated
		playsound(src,'sound/effects/hit_on_shattered_glass.ogg',50,TRUE)
		explosive_reaction(user, triggered_by_explosion)
		return
	if(stage == GIBTONITE_ACTIVE && mineralAmt >= 1) //Gibtonite deposit goes kaboom
		var/turf/bombturf = get_turf(src)
		mineralAmt = 0
		stage = GIBTONITE_DETONATE
		explosion(bombturf, devastation_range = 1, heavy_impact_range = 2, light_impact_range = 5, adminlog = FALSE, explosion_cause = src)
	if(stage == GIBTONITE_STABLE) //Gibtonite deposit is now benign and extractable. Depending on how close you were to it blowing up before defusing, you get better quality ore.
		var/obj/item/gibtonite/G = new (src)
		if(det_time <= 0)
			G.quality = 3
			G.icon_state = "Gibtonite ore 3"
		if(det_time >= 1 && det_time <= 2)
			G.quality = 2
			G.icon_state = "Gibtonite ore 2"

	var/flags = NONE
	var/old_type = type
	if(defer_change) // TODO: make the defer change var a var for any changeturf flag
		flags = CHANGETURF_DEFER_CHANGE
	ScrapeAway(null, flags)
	SSzas.mark_for_update(src)
	addtimer(CALLBACK(src, PROC_REF(AfterChange), flags, old_type), 1, TIMER_UNIQUE)
	//mined.update_visuals()

/turf/closed/mineral/gibtonite/ice
	icon_state = "icerock_Gibtonite"
	icon = MAP_SWITCH('icons/turf/walls/legacy/icerock_wall.dmi', 'icons/turf/mining.dmi')
	base_icon_state = "icerock_wall"
	smoothing_flags = SMOOTH_BITMASK | SMOOTH_BORDER
	turf_type = /turf/open/misc/asteroid/snow/ice
	baseturfs = /turf/open/misc/asteroid/snow/ice
	temperature = 180
	defer_change = TRUE

#undef MINING_MESSAGE_COOLDOWN
