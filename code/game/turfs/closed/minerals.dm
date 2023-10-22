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

	var/turf/open/floor/plating/turf_type = /turf/open/misc/asteroid/airless
	var/obj/item/stack/ore/mineralType = null
	var/mineralAmt = 3
	var/scan_state = "" //Holder for the image we display when we're pinged by a mining scanner
	var/defer_change = 0
	// If true you can mine the mineral turf without tools.
	var/weak_turf = FALSE
	///How long it takes to mine this turf with tools, before the tool's speed and the user's skill modifier are factored in.
	var/tool_mine_speed = 4 SECONDS
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
	if(!our_area.area_has_base_lighting && always_lit) //Only provide your own lighting if the area doesn't for you
		add_overlay(global.fullbright_overlay)

	if (light_power && light_outer_range)
		update_light()

	if (opacity)
		directional_opacity = ALL_CARDINALS

	// apply materials properly from the default custom_materials value
	if (!length(custom_materials))
		set_custom_materials(custom_materials)

	if(uses_integrity)
		atom_integrity = max_integrity

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

/turf/closed/mineral/proc/Spread_Vein()
	var/spreadChance = initial(mineralType.spreadChance)
	if(spreadChance)
		for(var/dir in GLOB.cardinals)
			if(prob(spreadChance))
				var/turf/T = get_step(src, dir)
				var/turf/closed/mineral/random/M = T
				if(istype(M) && !M.mineralType)
					M.Change_Ore(mineralType)

/turf/closed/mineral/proc/Change_Ore(ore_type, random = 0)
	if(random)
		mineralAmt = rand(1, 5)
	if(ispath(ore_type, /obj/item/stack/ore)) //If it has a scan_state, switch to it
		var/obj/item/stack/ore/the_ore = ore_type
		scan_state = initial(the_ore.scan_state) // I SAID. SWITCH. TO. IT.
		mineralType = ore_type // Everything else assumes that this is typed correctly so don't set it to non-ores thanks.

/turf/closed/mineral/attackby(obj/item/I, mob/user, params)
	if (!ISADVANCEDTOOLUSER(user))
		to_chat(usr, span_warning("You don't have the dexterity to do this!"))
		return

	if(I.tool_behaviour == TOOL_MINING)
		var/turf/T = user.loc
		if (!isturf(T))
			return

		if(TIMER_COOLDOWN_CHECK(src, REF(user))) //prevents mining turfs in progress
			return

		TIMER_COOLDOWN_START(src, REF(user), tool_mine_speed)

		to_chat(user, span_notice("You start picking..."))

		if(!I.use_tool(src, user, tool_mine_speed, volume=50))
			TIMER_COOLDOWN_END(src, REF(user)) //if we fail we can start again immediately
			return
		if(ismineralturf(src))
			to_chat(user, span_notice("You finish cutting into the rock."))
			gets_drilled(user, TRUE)
			SSblackbox.record_feedback("tally", "pick_used_mining", 1, I.type)

/turf/closed/mineral/attack_hand(mob/user)
	if(!weak_turf)
		return ..()
	var/turf/user_turf = user.loc
	if (!isturf(user_turf))
		return
	if(TIMER_COOLDOWN_CHECK(src, REF(user))) //prevents mining turfs in progress
		return
	TIMER_COOLDOWN_START(src, REF(user), hand_mine_speed)
	var/skill_modifier = 1
	skill_modifier = user?.mind.get_skill_modifier(/datum/skill/mining, SKILL_SPEED_MODIFIER)
	to_chat(user, span_notice("You start pulling out pieces of [src]..."))
	if(!do_after(user, src, hand_mine_speed * skill_modifier))
		TIMER_COOLDOWN_END(src, REF(user)) //if we fail we can start again immediately
		return
	if(ismineralturf(src))
		to_chat(user, span_notice("You finish pulling apart [src]."))
		gets_drilled(user)

/turf/closed/mineral/attack_robot(mob/living/silicon/robot/user)
	if(user.Adjacent(src))
		attack_hand(user)

/turf/closed/mineral/proc/gets_drilled(user, give_exp = FALSE)
	if (mineralType && (mineralAmt > 0))
		new mineralType(src, mineralAmt)
		SSblackbox.record_feedback("tally", "ore_mined", mineralAmt, mineralType)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(give_exp)
			if (mineralType && (mineralAmt > 0))
				H.mind.adjust_experience(/datum/skill/mining, initial(mineralType.mine_experience) * mineralAmt)
			else
				H.mind.adjust_experience(/datum/skill/mining, 4)

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
	//mined.update_visuals()

/turf/closed/mineral/attack_animal(mob/living/simple_animal/user, list/modifiers)
	if((user.environment_smash & ENVIRONMENT_SMASH_WALLS) || (user.environment_smash & ENVIRONMENT_SMASH_RWALLS))
		gets_drilled(user)
	..()

/turf/closed/mineral/attack_alien(mob/living/carbon/alien/user, list/modifiers)
	to_chat(user, span_notice("You start digging into the rock..."))
	playsound(src, 'sound/effects/break_stone.ogg', 50, TRUE)
	if(do_after(user, src, 4 SECONDS))
		to_chat(user, span_notice("You tunnel into the rock."))
		gets_drilled(user)

/turf/closed/mineral/attack_hulk(mob/living/carbon/human/H)
	..()
	if(do_after(H, src, 50))
		playsound(src, 'sound/effects/meteorimpact.ogg', 100, TRUE)
		H.say(pick(";RAAAAAAAARGH!", ";HNNNNNNNNNGGGGGGH!", ";GWAAAAAAAARRRHHH!", "NNNNNNNNGGGGGGGGHH!", ";AAAAAAARRRGH!" ), forced = "hulk")
		gets_drilled(H)
	return TRUE

/turf/closed/mineral/acid_melt()
	ScrapeAway()

/turf/closed/mineral/ex_act(severity, target)
	. = ..()
	switch(severity)
		if(EXPLODE_DEVASTATE)
			gets_drilled(null, FALSE)
		if(EXPLODE_HEAVY)
			if(prob(90))
				gets_drilled(null, FALSE)
		if(EXPLODE_LIGHT)
			if(prob(75))
				gets_drilled(null, FALSE)
	return

/turf/closed/mineral/blob_act(obj/structure/blob/B)
	if(prob(50))
		gets_drilled(give_exp = FALSE)

/turf/closed/mineral/random
	var/list/mineralSpawnChanceList = list(/obj/item/stack/ore/uranium = 5, /obj/item/stack/ore/diamond = 1, /obj/item/stack/ore/gold = 10,
		/obj/item/stack/ore/silver = 12, /obj/item/stack/ore/plasma = 20, /obj/item/stack/ore/iron = 40, /obj/item/stack/ore/titanium = 11,
		/turf/closed/mineral/gibtonite = 4, /obj/item/stack/ore/bluespace_crystal = 1)
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
			Change_Ore(path, 1)
			Spread_Vein(path)

/turf/closed/mineral/random/high_chance
	icon_state = "rock_highchance"
	mineralChance = 25
	mineralSpawnChanceList = list(
		/obj/item/stack/ore/uranium = 35, /obj/item/stack/ore/diamond = 30, /obj/item/stack/ore/gold = 45, /obj/item/stack/ore/titanium = 45,
		/obj/item/stack/ore/silver = 50, /obj/item/stack/ore/plasma = 50, /obj/item/stack/ore/bluespace_crystal = 20)

/turf/closed/mineral/random/low_chance
	icon_state = "rock_lowchance"
	mineralChance = 6
	mineralSpawnChanceList = list(
		/obj/item/stack/ore/uranium = 2, /obj/item/stack/ore/diamond = 1, /obj/item/stack/ore/gold = 4, /obj/item/stack/ore/titanium = 4,
		/obj/item/stack/ore/silver = 6, /obj/item/stack/ore/plasma = 15, /obj/item/stack/ore/iron = 40,
		/turf/closed/mineral/gibtonite = 2, /obj/item/stack/ore/bluespace_crystal = 1)

//extremely low chance of rare ores, meant mostly for populating stations with large amounts of asteroid
/turf/closed/mineral/random/stationside
	icon_state = "rock_nochance"
	mineralChance = 4
	mineralSpawnChanceList = list(
		/obj/item/stack/ore/uranium = 1, /obj/item/stack/ore/diamond = 1, /obj/item/stack/ore/gold = 3, /obj/item/stack/ore/titanium = 5,
		/obj/item/stack/ore/silver = 4, /obj/item/stack/ore/plasma = 3, /obj/item/stack/ore/iron = 50)

/turf/closed/mineral/random/labormineral
	icon_state = "rock_labor"
	mineralSpawnChanceList = list(
		/obj/item/stack/ore/uranium = 3, /obj/item/stack/ore/diamond = 1, /obj/item/stack/ore/gold = 8, /obj/item/stack/ore/titanium = 8,
		/obj/item/stack/ore/silver = 20, /obj/item/stack/ore/plasma = 30, /obj/item/stack/ore/iron = 95,
		/turf/closed/mineral/gibtonite = 2)

// Subtypes for mappers placing ores manually.
/turf/closed/mineral/iron
	mineralType = /obj/item/stack/ore/iron
	scan_state = "rock_Iron"

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
	mineralType = /obj/item/stack/ore/uranium
	scan_state = "rock_Uranium"

/turf/closed/mineral/diamond
	mineralType = /obj/item/stack/ore/diamond
	scan_state = "rock_Diamond"

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
	mineralType = /obj/item/stack/ore/gold
	scan_state = "rock_Gold"

/turf/closed/mineral/silver
	mineralType = /obj/item/stack/ore/silver
	scan_state = "rock_Silver"

/turf/closed/mineral/titanium
	mineralType = /obj/item/stack/ore/titanium
	scan_state = "rock_Titanium"

/turf/closed/mineral/plasma
	mineralType = /obj/item/stack/ore/plasma
	scan_state = "rock_Plasma"

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
	mineralType = /obj/item/stack/ore/bananium
	mineralAmt = 3
	scan_state = "rock_Bananium"

/turf/closed/mineral/bscrystal
	mineralType = /obj/item/stack/ore/bluespace_crystal
	mineralAmt = 1
	scan_state = "rock_BScrystal"

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
	scan_state = "rock_Gibtonite"
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

/turf/closed/mineral/gibtonite/gets_drilled(mob/user, give_exp = FALSE, triggered_by_explosion = FALSE)
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
