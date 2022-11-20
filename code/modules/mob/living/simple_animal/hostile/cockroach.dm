//New simple_animal cockroaches, they will eat food and reproduce afterwards
/mob/living/simple_animal/hostile/cockroach
	name = "cockroach"
	desc = "An exceptionally hungry pest. Keep away from food."
	icon_state = "cockroach_new"
	icon_living = "cockroach_new"
	verb_say = "chitters"
	verb_ask = "chitters inquisitively"
	verb_exclaim = "chitters loudly"
	verb_yell = "chitters loudly"
	friendly_verb_simple = "nibble"
	friendly_verb_continuous = "nibbles"
	response_disarm_continuous = "shoos"
	response_disarm_simple = "shoo"
	response_harm_continuous = "splats"
	response_harm_simple = "splat"
	speak_emote = list("chitters")
	deathsound = 'sound/creatures/roach_die.ogg'
	maxHealth = 1
	health = 1
	//combat_mode = FALSE
	loot = list(/obj/effect/decal/cleanable/insectguts)
	environment_smash = ENVIRONMENT_SMASH_NONE
	pass_flags = PASSTABLE | PASSGRILLE | PASSMOB
	gold_core_spawnable = FRIENDLY_SPAWN
	density = FALSE
	mob_size = MOB_SIZE_TINY
	mob_biotypes = MOB_ORGANIC|MOB_BUG
	search_objects = 1
	wanted_objects = list(/obj/item/food)
	del_on_death = 1
	minimum_distance = 0
	vision_range = 4
	robust_searching = 1 //for checking friend list
	lose_patience_timeout = 5 SECONDS

	var/burner = FALSE //is the roach on fire
	var/sterile = FALSE //no self-reproduction
	var/obj/item/grenade/explosive = null
	var/explode_chance = 0

/mob/living/simple_animal/hostile/cockroach/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_VENTCRAWLER_ALWAYS, INNATE_TRAIT)
	AddComponent(/datum/component/clickbox, x_offset = -2, y_offset = -2)
	AddComponent(/datum/component/swarming)
	AddComponent(/datum/component/squashable, squash_chance = 35, squash_damage = 1)
	AddComponent(/datum/component/tameable, food_types = list(/obj/item/food), tame_chance = 30, copy_faction = FALSE, bonus_tame_chance = 20)

/mob/living/simple_animal/hostile/cockroach/GiveTarget(new_target)
	add_target(new_target)
	LosePatience()
	if(target != null)
		if(istype(target, /obj/item/food))
			GainPatience()
			Aggro()
			retreat_distance = 0
			minimum_distance = 0
			return TRUE
		else if(isliving(target))
			GainPatience()
			Aggro()
			if(explosive)
				retreat_distance = 0
				minimum_distance = 1
				return TRUE
			visible_message(span_danger("[name] scuttles away!"))
			retreat_distance = 10
			minimum_distance = 10
			return TRUE

/mob/living/simple_animal/hostile/cockroach/AttackingTarget()
	if(istype(target, /obj/item))
		consume(target)
		return
	return ..()

/mob/living/simple_animal/hostile/cockroach/proc/consume(atom/movable/fooditem)
	playsound(src, 'sound/items/eatfood.ogg', 100, FALSE)
	visible_message(span_danger("[name] devours [fooditem]!"))
	qdel(fooditem)
	if(sterile)
		return
	var/cap = CONFIG_GET(number/roachcap)
	if(LAZYLEN(SSmobs.roaches) >= cap)
		return
	new /mob/living/simple_animal/hostile/cockroach(get_turf(src))

/mob/living/simple_animal/hostile/cockroach/attackby(obj/item/I, mob/living/user)
	var/hot_thing = I.get_temperature()
	if(hot_thing) //FIRE IS THE BEST WAY TO KILL A SPIDER
		user.visible_message(span_warning("[user] lights [src] on fire!"), span_warning("You light [src] on fire!"))
		burner = TRUE
		update_icon()
		addtimer(CALLBACK(src, /mob/living/.proc/death), 10 SECONDS) //just in case the fire doesn't kill it.
		search_objects = 0 //run away from people
		qdel(GetComponent(/datum/component/squashable)) //you aren't getting out of this mess that easy
		return
	if(istype(I, /obj/item/grenade))
		attach_nade(I, user)
		update_icon()
		return
	if(istype(I, /obj/item/wirecutters))
		if(explosive)
			if(prob(explode_chance + 20))
				user.visible_message(span_warning("[src] fidgets as [user] tries to disarm it! OH SHIT-"), span_warning("[src] fidgets as you try to disarm it! OH SHIT-"))
				death() //cockroach death triggers the bomb
			to_chat(user, span_notice("You disarm [src]."))
			var/turf/roach_turf = get_turf(src)
			explosive.forceMove(roach_turf)
			explosive = null
			return
		update_icon()
	return ..()

/mob/living/simple_animal/hostile/cockroach/Moved()
	playsound(src, 'sound/creatures/roach_scuttle.ogg', 50, FALSE)
	if(burner)
		//currently on fire.
		var/turf/fire_turf = get_turf(src)
		addtimer(CALLBACK(src, .proc/setFire, fire_turf), 0.6 SECONDS)
		return ..()
	if(explosive)
		if(prob(explode_chance))
			death() //cockroach death triggers the bomb
			return
		explode_chance += 1 //+1% chance to explode after every movement
		playsound(src, 'sound/items/timer.ogg', 50, FALSE)
	return ..()

/mob/living/simple_animal/hostile/cockroach/proc/setFire(turf/fire_turf)
	fire_turf.create_fire(1, 0.3)

/mob/living/simple_animal/hostile/cockroach/proc/attach_nade(obj/item/grenade/nade, mob/living/user)
	if(explosive)
		to_chat(user, span_warning("[src] can only fit one grenade."))
		return
	log_combat(user, src, "attached [nade] to")
	to_chat(user, span_warning("You attach [nade] to [src] and whisper words of radical ideology."))
	nade.forceMove(src)
	explosive = nade

/mob/living/simple_animal/hostile/cockroach/examine(mob/user)
	. = ..()
	if(explosive)
		. += span_danger("...Holy shit, it has [explosive] tied to it!")

/mob/living/simple_animal/hostile/cockroach/death(gibbed)
	if(GLOB.station_was_nuked) //copied from old roaches. still nuke immune.
		return
	if(explosive)
		//had to add a delayed explosion because roaches were sacrificing themselves on their own bomb
		var/turf/roach_turf = get_turf(src)
		explosive.forceMove(roach_turf)
		addtimer(CALLBACK(explosive, /obj/item/grenade/.proc/detonate), 0.1 SECONDS)
		visible_message(span_warning("[src]'s [explosive] goes off!"))
		return ..()
	return ..()

/mob/living/simple_animal/hostile/cockroach/update_overlays()
	. = ..()
	if(burner)
		. += mutable_appearance(icon, "cockroach_fire_overlay")
	if(explosive)
		. += mutable_appearance(icon, "cockroach_bomb_overlay")


/mob/living/simple_animal/hostile/cockroach/sterile
	sterile = TRUE //won't reproduce

//in case an admin wants to spawn a roach with a bomb.
/mob/living/simple_animal/hostile/cockroach/bomber

/mob/living/simple_animal/hostile/cockroach/bomber/Initialize(mapload)
	explosive = new /obj/item/grenade/iedcasing/spawned()
	. = ..()


/mob/living/simple_animal/hostile/cockroach/steve
	name = "Radical Steve"
	desc = "An exceptionally hungry pest. This one has a label attached that says 'Radical Steve'."
	faction = list("neutral")
	var/smokin

/mob/living/simple_animal/hostile/cockroach/steve/attackby(obj/item/I, mob/living/user)
	if(istype(I, /obj/item/clothing/mask/cigarette))
		smokin = TRUE //puff that shit little homie
		update_icon()
		qdel(I)
		return
	return ..()

/mob/living/simple_animal/hostile/cockroach/steve/update_overlays()
	. = ..()
	if(smokin)
		. += mutable_appearance(icon, "cockroach_cig_overlay")
