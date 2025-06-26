// In this document: Goat, Chicken, Brahmin, Radstag, Bighorner (also cow but extinct so basically brahmin)

//////////
// GOAT //
//////////

#warn Hey, this has a lot of dupes from the original farm_animals.dm

//cow
/mob/living/simple_animal/cow
	health = 200
	maxHealth = 200
	var/list/ride_offsets = list(
		"1" = list(0, 8),
		"2" = list(0, 8),
		"4" = list(-2, 8),
		"8" = list(2, 8)
		)
	var/datum/reagent/milk_reagent = /datum/reagent/consumable/milk
	var/list/food_types = list(/obj/item/food/grown/wheat, /obj/item/stack/sheet/hay)
	gold_core_spawnable = FRIENDLY_SPAWN
	var/is_calf = 0
	var/has_calf = 0
	var/young_type = null
	blood_volume = 480
	var/ride_move_delay = 2
	var/hunger = 1
	COOLDOWN_DECLARE(hunger_cooldown)

	footstep_type = FOOTSTEP_MOB_SHOE
///////////////////////
//Dave's Brahmin Bags//
///////////////////////


	var/mob/living/owner = null
	var/follow = FALSE

	var/bridle = FALSE
	var/bags = FALSE
	var/collar = FALSE
	var/saddle = FALSE
	var/brand = ""

/mob/living/simple_animal/cow/death(gibbed)
	. = ..()
	if(can_buckle)
		can_buckle = FALSE
	if(buckled_mobs)
		for(var/mob/living/M in buckled_mobs)
			unbuckle_mob(M)
	for(var/atom/movable/stuff_innit in contents)
		stuff_innit.forceMove(get_turf(src))
	if(collar)
		new /obj/item/brahmincollar(get_turf(src))
	if(bridle)
		new /obj/item/brahminbridle(get_turf(src))
	if(saddle)
		new /obj/item/brahminsaddle(get_turf(src))

/mob/living/simple_animal/cow/examine(mob/user)
	. = ..()
	if(collar)
		. += "<br>A collar with a tag etched '[name]' is hanging from its neck."
	if(brand)
		. += "<br>It has a brand reading '[brand]' on its backside."
	if(bridle)
		. += "<br>It has a bridle and reins attached to its head."
	if(bags)
		. += "<br>It has some bags attached."
	if(saddle)
		. += "<br>It has a saddle across its back."
	if(health <= 0 || stat != CONSCIOUS)
		return
	if(saddle || bridle)
		. += "<br>Feeding this beast will let it move quickly for longer! You'll need to remove their bridle and saddle to get them pregnant."
	else
		. += "<br>Feeding this beast will get it pregnant! You'll need to give them a bridle and/or a saddle to feed their hunger."
	switch(hunger)
		if(1)
			. += "<br>They look well fed."
		if(2)
			. += "<br>They look hungry."
		if(3)
			. += "<br>They look <i>really</i> hungry."
		else
			. += "<br>They look fuckin <i>famished</i>."

/mob/living/simple_animal/cow/attackby(obj/item/O, mob/user, params)
	if(stat == CONSCIOUS && is_type_in_list(O, food_types))
		feed_em(O, user)
		return
	/* if (istype(O,/obj/item/brahminbags))
		if(bags)
			to_chat(user, span_warning("The mount already has bags attached!"))
			return
		if(is_calf)
			to_chat(user, span_warning("The young animal cannot carry the bags!"))
			return
		to_chat(user, span_notice("You add [O] to [src]..."))
		bags = TRUE
		qdel(O)
		ComponentInitialize()
		return */

	if(istype(O,/obj/item/brahmincollar))
		if(user != owner)
			to_chat(user, span_warning("You need to claim the mount with a bridle before you can rename it!"))
			return

		name = input("Choose a new name for your mount!","Name", name)

		if(!name)
			return

		collar = TRUE
		to_chat(user, span_notice("You add [O] to [src]..."))
		message_admins(span_notice("[ADMIN_LOOKUPFLW(user)] renamed a mount to [name].")) //So people don't name their brahmin the N-Word without notice
		qdel(O)
		return

	if(istype(O,/obj/item/brahminbridle))
		if(bridle)
			to_chat(user, span_warning("This mount already has a bridle!"))
			return

		owner = user
		bridle = TRUE
		tame = TRUE
		to_chat(user, span_notice("You add [O] to [src], claiming it as yours."))
		qdel(O)
		return

	if(istype(O,/obj/item/brahminsaddle))
		if(saddle)
			to_chat(user, span_warning("This mount already has a saddle!"))
			return

		saddle = TRUE
		can_buckle = TRUE
		buckle_lying = FALSE
		var/datum/component/riding/D = LoadComponent(/datum/component/riding)
		D.set_riding_offsets(RIDING_OFFSET_ALL, ride_offsets)
		D.set_vehicle_dir_layer(SOUTH, ABOVE_MOB_LAYER)
		D.set_vehicle_dir_layer(NORTH, OBJ_LAYER)
		D.set_vehicle_dir_layer(EAST, OBJ_LAYER)
		D.set_vehicle_dir_layer(WEST, OBJ_LAYER)
		D.vehicle_move_delay = ride_move_delay
		D.drive_verb = "ride"
		to_chat(user, span_notice("You add [O] to [src]."))
		qdel(O)
		return

	if(istype(O,/obj/item/brahminbrand))
		if(brand)
			to_chat(user, span_warning("This mount already has a brand!"))
			return

		brand = input("What would you like to brand on your mount?","Brand", brand)

		if(!brand)
			return
	. = ..()

/mob/living/simple_animal/cow/proc/become_hungry()
	hunger++
	update_speed()

/mob/living/simple_animal/cow/proc/refuel_horse()
	hunger = 1
	update_speed()

/mob/living/simple_animal/cow/proc/update_speed()
	ride_move_delay = initial(ride_move_delay) + round(log(1.6,hunger), 0.2) // vOv
	if(saddle)
		var/datum/component/riding/D = LoadComponent(/datum/component/riding)
		D.vehicle_move_delay = ride_move_delay

/* /mob/living/simple_animal/cow/ComponentInitialize()
	if(!bags)
		return
	AddComponent(/datum/component/storage/concrete/brahminbag)
	return */

/mob/living/simple_animal/cow/proc/feed_em(obj/item/I, mob/user)
	if(!I || !user)
		return
	var/obj/item/stack/stax
	if(istype(I, /obj/item/stack))
		stax = I
		if(!stax.tool_use_check(user, 2))
			return

	if(saddle || bridle)
		visible_message(span_alertalien("[src] consumes the [I]."))
		refuel_horse()
	else if(is_calf)
		visible_message(span_alertalien("[src] adorably chews the [I]."))
	else if(!has_calf)
		has_calf = 1
		visible_message(span_alertalien("[src] fertilely consumes the [I]."))
	else
		visible_message(span_alertalien("[src] absently munches the [I]."))

	if(stax)
		stax.use(2)
	else
		qdel(I)

/mob/living/simple_animal/cow/proc/handle_following()
	if(stat == DEAD)
		return
	if(health <= 0)
		return
	if(owner)
		if(!follow)
			return
		else if(CHECK_MOBILITY(src, MOBILITY_MOVE) && isturf(loc))
			step_to(src, owner)

/mob/living/simple_animal/cow/CtrlShiftClick(mob/user)
	if(get_dist(user, src) > 1)
		return

	if(bridle)
		bridle = FALSE
		tame = FALSE
		owner = null
		to_chat(user, span_notice("You remove the bridle gear from [src], dropping it on the ground."))
		new /obj/item/brahminbridle(get_turf(user))

	if(collar)
		collar = FALSE
		name = initial(name)
		to_chat(user, span_notice("You remove the collar from [src], dropping it on the ground."))
		new /obj/item/brahmincollar(get_turf(user))

	if(user == owner)
		if(bridle)
			if(stat == DEAD || health <= 0)
				to_chat(user, span_alert("[src] can't obey your commands anymore. It is dead."))
				return
			if(follow)
				to_chat(user, span_notice("You tug on the reins of [src], telling it to stay."))
				follow = FALSE
				return
			else if(!follow)
				to_chat(user, span_notice("You tug on the reins of [src], telling it to follow."))
				follow = TRUE
				return

///////////////////////////
//End Dave's Brahmin Bags//
///////////////////////////


/////////////
// BRAHMIN //
/////////////

/mob/living/simple_animal/cow/brahmin
	name = "brahmin"
	desc = "Brahmin or brahma are mutated cattle with two heads and looking udderly ridiculous.<br>Known for their milk, just don't tip them over."
	icon = 'modular_fallout/master_files/icons/fallout/mobs/friendly/animals.dmi'
	icon_state = "brahmin"
	icon_living = "brahmin"
	icon_dead = "brahmin_dead"
	icon_gib = "brahmin_gib"
	speak = list("moo?","moo","MOOOOOO")
	speak_emote = list("moos","moos hauntingly")
	emote_hear = list("brays.")
	emote_see = list("shakes its head.")
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	response_help_continuous  = "pets"
	response_help_simple = "pet"
	response_disarm_continuous = "gently pushes aside"
	response_disarm_simple = "gently push aside"
	response_harm_continuous = "kicks"
	response_harm_simple = "kick"
	attack_verb_simple_continuous = "kicks"
	attack_verb_simple = "kick"
	waddle_amount = 3
	waddle_up_time = 1
	waddle_side_time = 2
	can_ghost_into = TRUE
	attack_sound = 'modular_fallout/master_files/sound/weapons/punch1.ogg'
	young_type = /mob/living/simple_animal/cow/brahmin/calf
	var/obj/item/inventory_back
	footstep_type = FOOTSTEP_MOB_HOOF
	guaranteed_butcher_results = list(
		/obj/item/food/meat/slab = 4,
		/obj/item/food/rawbrahminliver = 1,
		/obj/item/food/rawbrahmintongue = 2,
		/obj/item/stack/sheet/animalhide/brahmin = 3,
		/obj/item/stack/sheet/bone = 2
		)
	butcher_results = list(
		/obj/item/food/meat/slab = 4,
		/obj/item/stack/sheet/bone = 2
		)
	butcher_difficulty = 1

/mob/living/simple_animal/cow/brahmin/molerat
	name = "tamed molerat"
	desc = "That's a big ol' molerat, seems to be able to take a saddle!"
	icon = 'fallout/icons/mob/mounts.dmi'
	icon_state = "molerat"
	icon_living = "molerat"
	icon_dead = "molerat_dead"
	icon_gib = "brahmin_gib"
	speak = list("*gnarl","*scrungy")
	speak_emote = list("grrrllgs","makes horrible molerat noises")
	emote_hear = list("chatters.")
	emote_see = list("shakes its head.")
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	response_help_continuous  = "pets"
	response_help_simple = "pet"
	response_disarm_continuous = "gently pushes aside"
	response_disarm_simple = "gently push aside"
	response_harm_continuous = "bites"
	response_harm_simple = "bite"
	attack_verb_simple_continuous = "bites"
	attack_verb_simple = "bite"
	waddle_amount = 4
	waddle_up_time = 1
	waddle_side_time = 2
	can_ghost_into = TRUE
	attack_sound = 'modular_fallout/master_files/sound/weapons/punch1.ogg'
	footstep_type = FOOTSTEP_MOB_HOOF
	ride_offsets = list(
		"1" = list(0, 8),
		"2" = list(0, 8),
		"4" = list(0, 8),
		"8" = list(0, 8)
		)
	guaranteed_butcher_results = list(
		/obj/item/food/meat/slab = 4,
		/obj/item/stack/sheet/bone = 2
		)
	butcher_results = list(
		/obj/item/food/meat/slab = 4,
		/obj/item/stack/sheet/bone = 2
		)
	butcher_difficulty = 1

//Horse

/mob/living/simple_animal/cow/brahmin/horse //faster than a brahmin, but much less tanky
	name = "horse"
	desc = "Horses are commonly used for logistics and transportation over long distances. Surprisingly this horse isn't fully mutated like the rest of the animals."
	icon = 'fallout/icons/mob/horse.dmi'
	icon_state = "horse"
	icon_living = "horse"
	icon_dead = "horse_dead"
	speak = list("*shiver", "*alert")
	speak_emote = list("nays","nays hauntingly")
	emote_hear = list("brays.")
	emote_see = list("shakes its head.")
	speak_chance = 1
	turns_per_move = -1 //no random movement
	see_in_dark = 6
	health = 100
	maxHealth = 100
	ride_move_delay = 1.5
	can_ghost_into = TRUE
	response_help_continuous  = "pets"
	response_help_simple = "pet"
	response_disarm_continuous = "gently pushes aside"
	response_disarm_simple = "gently push aside"
	response_harm_continuous = "kicks"
	response_harm_simple = "kick"
	attack_verb_simple_continuous = "kicks"
	attack_verb_simple = "kick"
	waddle_amount = 3
	waddle_up_time = 1
	waddle_side_time = 2
	attack_sound = 'modular_fallout/master_files/sound/weapons/punch1.ogg'
	young_type = /mob/living/simple_animal/cow/brahmin/horse
	footstep_type = FOOTSTEP_MOB_HOOF
	guaranteed_butcher_results = list(
		/obj/item/food/meat/slab = 4,
		/obj/item/stack/sheet/bone = 2
		)
	butcher_results = list(
		/obj/item/food/meat/slab = 4,
		/obj/item/crafting/wonderglue = 1,
		/obj/item/stack/sheet/bone = 2
		)
	butcher_difficulty = 1


//Ridable Nightstalker

/mob/living/simple_animal/cow/brahmin/nightstalker //faster than a brahmin, but slower than a horse, mid ground tanky
	name = "tamed nightstalker"
	desc = "A crazed genetic hybrid of rattlesnake and coyote DNA. This one seems a bit less crazed, at least."
	icon = 'modular_fallout/master_files/icons/fallout/mobs/hostile/animals/nightstalker.dmi'
	icon_state = "nightstalker-legion"
	icon_living = "nightstalker-legion"
	icon_dead = "nightstalker-legion-dead"
	speak = list("*shiss","*gnarl","*bark")
	speak_emote = list("barks","hisses")
	emote_hear = list("perks its head up.")
	emote_see = list("stares.")
	speak_chance = 1
	turns_per_move = -1 //no random movement
	see_in_dark = 6
	health = 150
	maxHealth = 150
	ride_move_delay = 1.8
	can_ghost_into = TRUE
	response_help_continuous  = "pets"
	response_help_simple = "pet"
	response_disarm_continuous = "gently pushes aside"
	response_disarm_simple = "gently push aside"
	response_harm_continuous = "bites"
	response_harm_simple = "bites"
	attack_verb_simple_continuous = "bites"
	attack_verb_simple = "bite"
	waddle_amount = 3
	waddle_up_time = 1
	waddle_side_time = 2
	attack_sound = 'modular_fallout/master_files/sound/weapons/punch1.ogg'
	young_type = /mob/living/simple_animal/cow/brahmin/nightstalker
	food_types = list(
		/obj/item/food/meat/slab/gecko,
		/obj/item/food/f13/canned/dog
		)
	milk_reagent = /datum/reagent/toxin
	ride_offsets = list(
		"1" = list(15, 8),
		"2" = list(15, 8),
		"4" = list(15, 8),
		"8" = list(15, 8)
		)
	guaranteed_butcher_results = list(
		/obj/item/food/meat/slab/nightstalker_meat = 2,
		/obj/item/stack/sheet/sinew = 2,
		/obj/item/stack/sheet/bone = 2
		)
	butcher_results = list(
		/obj/item/clothing/head/f13/stalkerpelt = 1,
		/obj/item/food/meat/slab/nightstalker_meat = 1
		)
	butcher_difficulty = 1


/mob/living/simple_animal/cow/brahmin/nightstalker/hunterspider
	name = "tamed spider"
	desc = "SOMEONE TAMED A FUCKING GIANT SPIDER?"
	icon = 'modular_fallout/master_files/icons/fallout/mobs/hostile/animals/nightstalker.dmi'
	icon = 'fallout/icons/mob/mounts.dmi'
	icon_state = "hunter"
	icon_living = "hunter"
	icon_dead = "hunter_dead"
	speak = list("*chitter","*hiss")
	speak_emote = list("chitters","hisses")
	emote_hear = list("rubs it mandibles together.")
	emote_see = list("stares, with all 8 eyes.")
	speak_chance = 1
	turns_per_move = -1 //no random movement
	see_in_dark = 6
	health = 150
	maxHealth = 150
	ride_move_delay = 1.8
	can_ghost_into = TRUE
	response_help_continuous  = "pets"
	response_help_simple = "pet"
	response_disarm_continuous = "gently pushes aside"
	response_disarm_simple = "gently push aside"
	response_harm_continuous = "bites"
	response_harm_simple = "bites"
	attack_verb_simple_continuous = "bites"
	attack_verb_simple = "bite"
	waddle_amount = 4
	waddle_up_time = 1
	waddle_side_time = 2
	attack_sound = 'modular_fallout/master_files/sound/weapons/punch1.ogg'
	young_type = /mob/living/simple_animal/cow/brahmin/nightstalker
	food_types = list(
		/obj/item/food/meat/slab/gecko,
		/obj/item/food/f13/canned/dog
		)
	milk_reagent = /datum/reagent/toxin
	ride_offsets = list(
		"1" = list(0, 9),
		"2" = list(0, 13),
		"4" = list(-2, 9),
		"8" = list(-2, 9)
		)
	guaranteed_butcher_results = list(
		/obj/item/food/meat/slab/nightstalker_meat = 2,
		/obj/item/stack/sheet/sinew = 2,
		/obj/item/stack/sheet/bone = 2
		)
	butcher_results = list(
		/obj/item/clothing/head/f13/stalkerpelt = 1,
		/obj/item/food/meat/slab/nightstalker_meat = 1
		)
	butcher_difficulty = 1


	/*
/obj/item/brahminbags
	name = "saddle bags"
	desc = "Attach these bags to a mount and leave the heavy lifting to them!"
	icon = 'modular_fallout/master_files/icons/fallout/objects/storage.dmi'
	icon_state = "trekkerpack"
*/
/*

/obj/item/brahmincollar
	name = "mount collar"
	desc = "A collar with a piece of etched metal serving as a tag. Use this on a mount you own to rename them."
	icon = 'modular_fallout/master_files/icons/mob/pets.dmi'
	icon_state = "petcollar"

/obj/item/brahminbridle
	name = "mount bridle gear"
	desc = "A set of headgear used to control and claim a mount. Consists of a bit, reins, and leather straps stored in a satchel."
	icon = 'modular_fallout/master_files/icons/fallout/objects/tool_behaviors.dmi'
	icon_state = "brahminbridle"

/obj/item/brahminsaddle
	name = "mount saddle"
	desc = "A saddle fit for a mutant beast of burden."
	icon = 'modular_fallout/master_files/icons/fallout/objects/tool_behaviors.dmi'
	icon_state = "brahminsaddle"

/obj/item/brahminbrand
	name = "mount branding tool"
	desc = "Use this on a mount to claim it as yours!"
	icon = 'modular_fallout/master_files/icons/fallout/objects/tool_behaviors.dmi'
	icon_state = "brahminbrand"

/obj/item/storage/backpack/duffelbag/debug_brahmin_kit
	name = "Lets test brahmin!"

/obj/item/storage/backpack/duffelbag/debug_brahmin_kit/PopulateContents()
	. = ..()
	//new /obj/item/brahminbags(src)
	new /obj/item/brahmincollar(src)
	new /obj/item/brahminbridle(src)
	new /obj/item/brahminsaddle(src)
	new /obj/item/brahminbrand(src)
	new /obj/item/choice_beacon/pet(src)
	new /obj/item/gun/ballistic/rifle/mag/antimateriel(src)
*/
/*
/datum/crafting_recipe/brahminbags
	name = "Saddle bags"
	result = /obj/item/brahminbags
	time = 60
	reqs = list(/obj/item/storage/backpack/duffelbag = 2,
				/obj/item/stack/sheet/cloth = 5)
	tool_behaviors = list(TOOL_WORKBENCH)
	subcategory = CAT_MISC
	category = CAT_MISC
*/
/*
/datum/crafting_recipe/blast_doors
	name = "Blast Door"
	reqs = list(/obj/item/stack/sheet/plasteel = 15,
				/obj/item/stack/cable_coil = 15,
				/obj/item/electronics/airlock = 1
				)
	result = /obj/machinery/door/poddoor/preopen
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_MULTITOOL, TOOL_WIRECUTTER, TOOL_WELDER)
	time = 30 SECONDS
	category = CAT_MISC
	one_per_turf = TRUE
*/
#warn fix brahmin stuff at some point pls
/*
/datum/crafting_recipe/brahmincollar
	name = "Mount collar"
	result = /obj/item/brahmincollar
	time = 60
	reqs = list(obj/item/stack/sheet/iron = 1,
				/obj/item/stack/sheet/cloth = 1)
	tool_behaviors = list(TOOL_WORKBENCH)
	subcategory = CAT_MISC
	category = CAT_MISC

/datum/crafting_recipe/brahminbridle
	name = "Mount bridle gear"
	result = /obj/item/brahminbridle
	time = 60
	reqs = list(/obj/item/stack/sheet/iron = 3,
				/obj/item/stack/sheet/leather = 2,
				/obj/item/stack/sheet/cloth = 1)
	tool_behaviors = list(TOOL_WORKBENCH)
	subcategory = CAT_MISC
	category = CAT_MISC

/datum/crafting_recipe/brahminsaddle
	name = "Mount saddle"
	result = /obj/item/brahminsaddle
	time = 60
	reqs = list(/obj/item/stack/sheet/iron = 1,
				/obj/item/stack/sheet/leather = 4,
				/obj/item/stack/sheet/cloth = 1)
	tool_behaviors = list(TOOL_WORKBENCH)
	subcategory = CAT_MISC
	category = CAT_MISC

/datum/crafting_recipe/brahminbrand
	name = "Mount branding tool"
	result = /obj/item/brahminbrand
	time = 60
	reqs = list(/obj/item/stack/sheet/iron = 1,
				/obj/item/stack/rods = 1)
	tool_behaviors = list(TOOL_WORKBENCH)
	subcategory = CAT_MISC
	category = CAT_MISC
*/
/*
/datum/component/storage/concrete/brahminbag
	max_w_class = WEIGHT_CLASS_HUGE //Allows the storage of shotguns and other two handed items.
	max_combined_w_class = 35
	max_items = 20
	drop_all_on_destroy = TRUE
	allow_big_nesting = TRUE
*/


/mob/living/simple_animal/cow/brahmin/calf
	name = "brahmin calf"
	is_calf = 1

/mob/living/simple_animal/cow/brahmin/calf/Initialize()
	. = ..()
	resize = 0.7
	update_transform()

/mob/living/simple_animal/cow/brahmin/sgtsillyhorn
	name = "Sergeant Sillyhorn"
	desc = "A distinguished war veteran alongside his junior enlisted sidekick, Corporal McCattle. The two of them wear a set of golden rings, smelted from captured Centurions."
	emote_see = list("shakes its head.","swishes its tail eagerly.")
	speak_chance = 2



/mob/living/simple_animal/cow/brahmin/proc/update_brahmin_fluff() //none of this should do anything for now, but it may be used for updating sprites later
	// First, change back to defaults
	name = real_name
	desc = initial(desc)
	// BYOND/DM doesn't support the use of initial on lists.
	speak = list("Moo?","Moo!","Mooo!","Moooo!","Moooo.")
	emote_hear = list("brays.")
	desc = initial(desc)




/////////////
// RADSTAG //
/////////////

/mob/living/simple_animal/radstag
	name = "radstag"
	desc = "a two headed deer that will run at the first sight of danger."
	icon = 'modular_fallout/master_files/icons/fallout/mobs/friendly/animals.dmi'
	icon_state = "radstag"
	icon_living = "radstag"
	icon_dead = "radstag_dead"
	icon_gib = "radstag_gib"
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	turns_per_move = 5
	see_in_dark = 6
	guaranteed_butcher_results = list(/obj/item/food/meat/slab = 4, /obj/item/stack/sheet/sinew = 2, /obj/item/stack/sheet/animalhide/radstag = 2, /obj/item/stack/sheet/bone = 2)
	butcher_results = list(/obj/item/food/meat/slab = 4, /obj/item/stack/sheet/bone = 2)
	butcher_difficulty = 1

	response_help_simple  = "pets"
	response_disarm_simple = "gently pushes aside"
	response_harm_simple   = "kicks"
	attack_verb_simple = "kicks"
	attack_sound = 'modular_fallout/master_files/sound/weapons/punch1.ogg'
	health = 50
	maxHealth = 50
	gold_core_spawnable = FRIENDLY_SPAWN
	blood_volume = BLOOD_VOLUME_NORMAL
	faction = list("neutral")

//Special Radstag
/mob/living/simple_animal/radstag/rudostag
	name = "Rudo the Rednosed Stag"
	desc = "An almost normal looking radstag. Apart from both of it's noses was a bright, glowing red."
	icon_state = "rudostag"
	icon_living = "rudostag"
	icon_dead = "rudostag_dead"

///////////////
// BIGHORNER //
///////////////

/mob/living/simple_animal/hostile/retaliate/goat/bighorn
	name = "bighorner"
	desc = "Mutated bighorn sheep that are often found in mountains, and are known for being foul-tempered even at the best of times."
	icon = 'modular_fallout/master_files/icons/fallout/mobs/friendly/animals.dmi'
	icon_state = "bighorner"
	icon_living = "bighorner"
	icon_dead = "bighorner_dead"
	icon_gib = "bighorner_gib"
	speak = list("EHEHEHEHEH","eh?")
	speak_emote = list("brays")
	emote_hear = list("brays.")
	emote_see = list("shakes its head.", "stamps a foot.", "glares around.", "grunts.")
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	guaranteed_butcher_results = list(/obj/item/food/meat/slab = 4, /obj/item/stack/sheet/sinew = 2, /obj/item/stack/sheet/bone = 3)
	butcher_results = list(/obj/item/food/meat/slab = 4, /obj/item/stack/sheet/sinew = 2, /obj/item/stack/sheet/bone = 1)
	butcher_difficulty = 1
	response_help_simple  = "pets"
	response_disarm_simple = "gently pushes aside"
	response_harm_simple   = "kicks"
	faction = list("bighorner")
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	attack_verb_simple = "rams"
	attack_sound = 'modular_fallout/master_files/sound/weapons/punch1.ogg'
	health = 120
	maxHealth = 120
	melee_damage_lower = 25
	melee_damage_upper = 20
	environment_smash = ENVIRONMENT_SMASH_NONE
	stop_automated_movement_when_pulled = 1
	var/is_calf = 0
	var/food_type = /obj/item/food/grown/wheat
	var/has_calf = 0
	var/young_type = /mob/living/simple_animal/hostile/retaliate/goat/bighorn/calf

/mob/living/simple_animal/hostile/retaliate/goat/bighorn/attackby(obj/item/O, mob/user, params)
	if(stat == CONSCIOUS && istype(O, food_type))
		if(is_calf)
			visible_message(span_alertalien("[src] adorably chews the [O]."))
			qdel(O)
		if(!has_calf && !is_calf)
			has_calf = 1
			visible_message(span_alertalien("[src] hungrily consumes the [O]."))
			qdel(O)
		else
			visible_message(span_alertalien("[src] absently munches the [O]."))
			qdel(O)
	else
		return ..()

/mob/living/simple_animal/hostile/retaliate/goat/bighorn/Life()
	. = ..()
	if(stat == CONSCIOUS)
		if((prob(3) && has_calf))
			has_calf++
		if(has_calf > 10)
			has_calf = 0
			visible_message(span_alertalien("[src] gives birth to a calf."))
			new young_type(get_turf(src))

		if(is_calf)
			if((prob(3)))
				is_calf = 0
				if(name == "bighorn lamb")
					name = "bighorn"
				else
					name = "bighorn"
				visible_message(span_alertalien("[src] has fully grown."))

#warn fix this

// BIGHORNER CALF
/mob/living/simple_animal/hostile/retaliate/goat/bighorn/calf
	name = "bighoner calf"
//	update_transform(0.7)

/mob/living/simple_animal/hostile/retaliate/goat/bighorn/calf/Initialize() //calfs should not be a separate critter, they should just be a normal whatever with these vars
	. = ..()
//	update_transform(0.7)


/* Seems obsolete with Daves Brahmin packs, marked for death?
	if(inventory_back && inventory_back.brahmin_fashion)
		var/datum/brahmin_fashion/BF = new inventory_back.brahmin_fashion(src)
		BF.apply(src)
/mob/living/simple_animal/cow/brahmin/regenerate_icons()
	..()
	if(inventory_back)
		var/image/back_icon
		var/datum/brahmin_fashion/BF = new inventory_back.brahmin_fashion(src)
		if(!BF.obj_icon_state)
			BF.obj_icon_state = inventory_back.icon_state
		if(!BF.obj_alpha)
			BF.obj_alpha = inventory_back.alpha
		if(!BF.obj_color)
			BF.obj_color = inventory_back.color
		if(health <= 0)
			back_icon = BF.get_overlay(dir = EAST)
			back_icon.pixel_y = -11
			back_icon.transform = turn(back_icon.transform, 180)
		else
			back_icon = BF.get_overlay()
		add_overlay(back_icon)
	return
/mob/living/simple_animal/cow/brahmin/show_inv(mob/user)
	user.set_machine(src)
	if(user.stat)
		return
	var/dat = 	"<div align='center'><b>Inventory of [name]</b></div><p>"
	if(inventory_back)
		dat +=	"<br><b>Back:</b> [inventory_back] (<a href='?src=[REF(src)];remove_inv=back'>Remove</a>)"
	else
		dat +=	"<br><b>Back:</b> <a href='?src=[REF(src)];add_inv=back'>Nothing</a>"
	user << browse(dat, text("window=mob[];size=325x500", real_name))
	onclose(user, "mob[real_name]")
	return
mob/living/simple_animal/cow/brahmin/Topic(href, href_list)
	if(usr.stat)
		return
	//Removing from inventory
	if(href_list["remove_inv"])
		if(!Adjacent(usr) || !(ishuman(usr) || ismonkey(usr) || iscyborg(usr) ||  isalienadult(usr)))
			return
		var/remove_from = href_list["remove_inv"]
		switch(remove_from)
			if("back")
				if(inventory_back)
					inventory_back.forceMove(drop_location())
					inventory_back = null
					update_brahmin_fluff()
					regenerate_icons()
				else
					to_chat(usr, span_danger("There is nothing to remove from its [remove_from]."))
					return
		show_inv(usr)
	//Adding things to inventory
	else if(href_list["add_inv"])
		if(!Adjacent(usr) || !(ishuman(usr) || ismonkey(usr) || iscyborg(usr) ||  isalienadult(usr)))
			return
		var/add_to = href_list["add_inv"]
		switch(add_to)
			if("back")
				if(inventory_back)
					to_chat(usr, span_warning("It's already wearing something!"))
					return
				else
					var/obj/item/item_to_add = usr.get_active_held_item()
					if(!item_to_add)
						usr.visible_message("[usr] pets [src].",span_notice("You rest your hand on [src]'s back for a moment."))
						return
					if(!usr.temporarilyRemoveItemFromInventory(item_to_add))
						to_chat(usr, span_warning("\The [item_to_add] is stuck to your hand, you cannot put it on [src]'s back!"))
						return
					//The objects that brahmin can wear on their backs.
					var/allowed = FALSE
					if(ispath(item_to_add.brahmin_fashion, /datum/brahmin_fashion/back))
						allowed = TRUE
					if(!allowed)
						to_chat(usr, span_warning("You set [item_to_add] on [src]'s back, but it falls off!"))
						item_to_add.forceMove(drop_location())
						if(prob(25))
							step_rand(item_to_add)
						for(var/i in list(1,2,4,8,4,8,4,dir))
							setDir(i)
							sleep(1)
						return
					item_to_add.forceMove(src)
					src.inventory_back = item_to_add
					update_brahmin_fluff()
					regenerate_icons()
		show_inv(usr)
	else
		..()
*/
