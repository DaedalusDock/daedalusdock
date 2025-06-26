//In the beginning of time, there was a door subtype called /dooor/ to allow a shitcode copypaste.
// "Fuck them copypastes, someone pls, make a system for dooor so no one gets to copypaste shit!"
//  - bartnixon
// "The system was always there, you just needed to use it ..."
//  - bauen1, the guy having to clean up the mess
// "I know what you feel, bro (and thx)."
//  - maxyo

// Ok, this is the main door directory. They open, they close, they take padlocks, easy. For ID locked doors use either airlocks for mechanical ones, or machinery/unpowered for secure wooden doors or cell doors.

/obj/structure/simple_door
	name = "wooden door"
	desc = "It opens and closes - nothing out of the ordinary."
	icon = 'modular_fallout/master_files/icons/fallout/structures/doors.dmi'
	icon_state = "house"
	opacity = TRUE
	density = TRUE
	anchored = TRUE
	layer = CLOSED_DOOR_LAYER
	explosion_block = 0.5
	var/can_hold_padlock = FALSE
	var/obj/item/lock_construct/padlock
	var/door_type = "house"
	var/base_opacity = TRUE
	var/manual_opened = 0
	var/material_count = 10
	var/hard_open = FALSE
	var/moving = 0
	var/material_type = /obj/item/stack/sheet/mineral/wood
	var/can_disasemble = 0
	var/open_sound = 'sound/machines/door_open.ogg'
	var/close_sound = 'sound/machines/door_close.ogg'
	var/opening_time = 2
	var/closing_time = 4

/obj/structure/simple_door/Initialize()
	. = ..()
	icon_state = door_type


/obj/structure/simple_door/Destroy()
	if(padlock)
		padlock.forceMove(get_turf(src))
		padlock = null
	//fortuna edit
	investigate_log("Door '[src]' destroyed at [AREACOORD(src)]. Last fingerprints: [src.fingerprintslast]", INVESTIGATE_DESTROYED)
	message_admins("Door '[ADMIN_JMP(src)]' destroyed at [AREACOORD(src)]. Last fingerprints(If any): [src.fingerprintslast]")
	log_game("Door '[src]' destroyed at [AREACOORD(src)]. Last fingerprints: [src.fingerprintslast]")
	return ..()

/obj/structure/simple_door/proc/attach_padlock(obj/item/lock_construct/P, force = FALSE, mob/user)
	if(!force && (!can_hold_padlock || !P ))
		return FALSE
	if(padlock)
		to_chat(user, "[src] already has \a [padlock] attached")
		return FALSE
	padlock = P
	padlock.forceMove(src)
	add_cached_overlay("padlock", "[initial(icon_state)]_padlock")

/obj/structure/simple_door/proc/remove_padlock(force = FALSE)
	if(!force && (!padlock))
		return FALSE
	padlock.forceMove(get_turf(src))
	padlock = null
	remove_cached_overlay("padlock")


/obj/structure/simple_door/bullet_act(obj/item/projectile/Proj)
	..()

/obj/structure/simple_door/Bumped(atom/user)
	..()
	if(density)
		if(hard_open)
			return TryToSwitchState(user, 0)
		else
			return TryToSwitchState(user, 1)
	return

/obj/structure/simple_door/proc/Open(animate)
	playsound(src.loc, open_sound, 30, 0, 0)
	if(animate)
		moving = 1
		flick("[door_type]opening", src)
		sleep(opening_time)
		moving = 0
	set_opacity(0)
	density = 0
	icon_state = "[door_type]open"
	layer = OPEN_DOOR_LAYER

/obj/structure/simple_door/proc/Close(animate)
	playsound(src.loc, close_sound, 30, 0, 0)
	manual_opened = 0
	if(animate)
		moving = 1
		flick("[door_type]closing", src)
		sleep(closing_time)
	icon_state = door_type
	set_opacity(base_opacity)
	density = 1
	moving = 0
	layer = CLOSED_DOOR_LAYER

/* can crowbar off a lock, to force a door open. This is overriden in airlock so shouldnt be an issue */
/obj/structure/simple_door/proc/try_to_crowbar(obj/item/I, mob/user)
	if(padlock) /* attempt to pry the lock off */
		if(padlock.pry_off(user,src))
			qdel(padlock)
			padlock = null
			src.desc = "[initial(desc)]"
	return

/obj/structure/simple_door/proc/SwitchState(animate)
	if(density)
		if(padlock)
			if(!padlock.locked)
				Open(animate)
			else
				playsound(src.loc, pick('sound/f13items/door_knock1.wav', 'sound/f13items/door_knock2.wav', 'sound/f13items/door_knock3.wav', 'sound/f13items/door_knock4.wav'), 80, 0, 0)

		else
			Open(animate)

	else
		var/turf/T = get_turf(src)
		for(var/mob/living/L in T)
			return
		Close(animate)
	return 1

/obj/structure/simple_door/attackby(obj/item/weapon/I, mob/living/user, params)
	if(user.a_intent != INTENT_HARM && (istype(I, /obj/item/crowbar) || istype(I, /obj/item/twohanded/fireaxe)))
		try_to_crowbar(I, user)
		return TRUE
	if(!istype(I, /obj/item/stack/sheet/mineral/wood))
		for(var/obj/structure/barricade/wooden/planks/P in loc)
			P.attackby(I, user, params)
			return TRUE
	if(istype(I, /obj/item/screwdriver))
		if(padlock)
			to_chat(user, "<span class='warning'>Remove padlock before door dissasembling.</span>")
			return 1
		else
			if(can_disasemble && do_after(user, 60, target = src))
				for(var/i = 1, i <= material_count, i++)
					new material_type(get_turf(src))
				to_chat(user,"<span class='notice'>You disassemble [name].</span>")
				playsound(loc, 'sound/items/Screwdriver.ogg', 25, -3)
				qdel(src)
				return 1
/*	if(istype(I, /obj/item/storage/keys_set))
		var/obj/item/storage/keys_set/S = I
		if(padlock)
			var/obj/item/key/K = S.get_key_with_id(padlock.id)
			if(istype(K))
				I = K
		if(istype(user.get_inactive_held_item(), /obj/item/lock))
			var/obj/item/lock/L = user.get_inactive_held_item()
			var/obj/item/key/K = S.get_key_with_id(L.id)
			if(istype(K))
				I = K
				*/
				//I'll deal with that shit later -harcourt
	if(istype(I, /obj/item/lock_construct) && can_hold_padlock)
		if(padlock)
			to_chat(user, "[src] already has \a [padlock] attached")
			return
		else
			if(user.transferItemToLoc(I, src))
				user.visible_message("<span class='notice'>[user] adds [I] to [src].</span>", \
								"<span class='notice'>You add [I] to [src].</span>")
				if (istype(I, /obj/item/lock_construct))
					desc = "[src.desc] Has a lock."//Fuck it im not doing this bullshit tonight. This will do. :) -with love, harcourt
				padlock = I
	if(istype(I, /obj/item/key))
		if(!padlock)
			to_chat(user, "[src] has no lock attached")
			return
		else
			return padlock.check_key(I,user)
	if(user.a_intent == INTENT_HARM)
//		if(padlock)
//			add_logs(user, src, "attacked", src)
		return ..()
	attack_hand(user)



/obj/structure/simple_door/proc/TryToSwitchState(atom/user, animate)
	if(moving)
		return 0
	if(isliving(user))
		var/mob/living/M = user
		if(/obj/structure/barricade in src.loc)
			M << "It won't budge!"
			return 0
		if(M.client)
			if(iscarbon(M))
				var/mob/living/carbon/C = M
				if(!C.handcuffed)
					SwitchState(animate)
					return 1
			else
				SwitchState(animate)
				return 1
	else if(istype(user, /obj/mecha))
		SwitchState(animate)
		return 1
	return 0

/obj/structure/simple_door/attack_hand(mob/user)
	if(TryToSwitchState(user, 1) && !density)
		manual_opened = 1
//	user.changeNext_move(CLICK_CD_MELEE)
	..()


/obj/structure/simple_door/attack_tk(mob/user)
	if(TryToSwitchState(user, 1) && !density)
		manual_opened = 1
//	user.changeNext_move(CLICK_CD_MELEE)
	..()

/obj/structure/simple_door/CanPass(atom/movable/mover, border_dir, height=0)
	if(mover.loc == loc)
		return 1
	return !density

/obj/structure/simple_door/CheckExit(atom/movable/O as mob|obj, target)
	if(!density && !manual_opened && ishuman(O))
		var/mob/living/carbon/human/H = O
		if(H.client && H.stat != 2)
			if(hard_open)
				spawn(H.movement_delay())TryToSwitchState(H) //AutoClosing
			else
				spawn(H.movement_delay())TryToSwitchState(H,1)
	if(O.loc == loc)
		return 1
	return !density

// Fallout 13 general doors directory

/obj/structure/simple_door/tentflap_leather
	name = "brahminskin tent entrance"
	icon_state = "tentflap_leather"
	door_type = "tentflap_leather"
	base_opacity = TRUE
	can_disasemble = FALSE
	can_hold_padlock = FALSE
	open_sound = 'sound/effects/footstep/hardbarefoot4.ogg'
	close_sound = 'sound/effects/footstep/hardbarefoot5.ogg'

/obj/structure/simple_door/tentflap_cloth
	name = "cotton tent entrance"
	icon_state = "tentflap_cloth"
	door_type = "tentflap_cloth"
	base_opacity = TRUE
	can_disasemble = FALSE
	can_hold_padlock = FALSE
	open_sound = 'sound/effects/footstep/hardbarefoot4.ogg'
	close_sound = 'sound/effects//footstep/hardbarefoot5.ogg'

// weathered white door
/obj/structure/simple_door/house
	icon_state = "house"
	door_type = "house"
	can_disasemble = TRUE
	can_hold_padlock = TRUE

// cleaned and repainted white
/obj/structure/simple_door/house/clean
	icon_state = "houseclean"
	door_type = "houseclean"

// Rough outer door
/obj/structure/simple_door/wood
	icon_state = "wood"
	door_type = "wood"
	can_disasemble = TRUE
	can_hold_padlock = TRUE


/obj/structure/simple_door/interior
	icon_state = "interior"
	door_type = "interior"
	can_disasemble = 1
	can_hold_padlock = TRUE

/obj/structure/simple_door/room
	icon_state = "room"
	door_type = "room"
	can_disasemble = TRUE
	can_hold_padlock = TRUE

/obj/structure/simple_door/room/dirty
	icon_state = "room_d"
	door_type = "room_d"

/obj/structure/simple_door/repaired
	name = "old damaged door"
	desc = "Battered and hastily repaired."
	icon_state = "room_repaired"
	door_type = "room_repaired"
	can_hold_padlock = TRUE

/obj/structure/simple_door/metal
	name = "metal door"
	icon_state = "metal"
	door_type = "metal"
	material_type = /obj/item/stack/sheet/metal
	open_sound = "sound/f13machines/doorstore_open.ogg"
	close_sound = "sound/f13machines/doorstore_close.ogg"
	explosion_block = 1.5
	material_count = 5

// Supposed to be the heaviest defensive door thats craftable without machinery. Maybe too weak still.
/obj/structure/simple_door/metal/iron
	name = "iron door"
	desc = "A heavy iron door."
	icon_state = "iron"
	door_type = "iron"
	explosion_block = 5
	can_hold_padlock = TRUE
	opening_time = 12
	closing_time = 8


/obj/structure/simple_door/dirtyglass
	desc = "The glass is dirty, you can't see a thing behind it."
	icon_state = "dirtyglass"
	door_type = "dirtyglass"
	can_hold_padlock = TRUE

/obj/structure/simple_door/brokenglass
	name = "shattered glass door"
	desc = "It still opens and closes."
	icon_state = "brokenglass"
	door_type = "brokenglass"
	opacity = FALSE
	base_opacity = FALSE
	can_hold_padlock = TRUE

/obj/structure/simple_door/glass
	desc = "The glass is quite clean, someone took care of this door."
	icon_state = "glass"
	door_type = "glass"
	opacity = FALSE
	base_opacity = FALSE
	can_hold_padlock = TRUE


/obj/structure/simple_door/metal/dirtystore
	desc = "A metal door with dirty glass, you can't see a thing behind it."
	icon_state = "dirtystore"
	door_type = "dirtystore"
	can_hold_padlock = TRUE

/obj/structure/simple_door/metal/store
	icon_state = "store"
	door_type = "store"
	opacity = FALSE
	base_opacity = FALSE
	can_disasemble = 1
	can_hold_padlock = TRUE


/obj/structure/simple_door/metal/barred
	name = "barred door"
	desc = "Bars. No matter which side we're on, aren't we always behind them?"
	icon_state = "barred"
	door_type = "barred"
	open_sound = "sound/f13machines/doorchainlink_open.ogg"
	close_sound = "sound/f13machines/doorchainlink_close.ogg"
	opacity = FALSE
	base_opacity = FALSE
	can_hold_padlock = TRUE
	proj_pass_rate = 95

/obj/structure/simple_door/metal/ventilation
	name = "ventilation system"
	desc = "As you take a closer look, you notice a handle at the bottom of ventilation system access hatch."
	icon_state = "ventilation"
	door_type = "ventilation"
	open_sound = "sound/f13machines/doorhidden_open.ogg"
	close_sound = "sound/f13machines/doorhidden_close.ogg"
	opening_time = 25
	closing_time = 20

/obj/structure/simple_door/metal/vault
	name = "vault wall"
	desc = "A sturdy and cold metal wall."
	icon = 'modular_fallout/master_files/icons/fallout/turfs/walls/vault.dmi'
	icon_state = "vaultfwall"
	door_type = "vaultfwall"
	open_sound = "sound/f13items/flashlight_on.ogg"
	close_sound = "sound/f13items/flashlight_off.ogg"

/obj/structure/simple_door/metal/vaultreinforced
	name = "vault reinforced wall"
	desc = "A wall built to withstand an atomic explosion."
	icon = 'modular_fallout/master_files/icons/fallout/turfs/walls/vault_reinforced.dmi'
	icon_state = "vaultfrwall"
	door_type = "vaultfrwall"
	open_sound = "sound/f13items/flashlight_on.ogg"
	close_sound = "sound/f13items/flashlight_off.ogg"

/obj/structure/simple_door/blast
	name = "blast door"
	desc = "A blast door, alternatively referred to as a shielded door or safety door, is a type of door designed to be especially reliable and durable."
	icon_state = "blastdoor"
	door_type = "blastdoor"
	material_type = /obj/item/stack/sheet/plasteel
	open_sound = "sound/f13machines/doorblast_open.ogg"
	close_sound = "sound/f13machines/doorblast_close.ogg"
	explosion_block = 10
	opening_time = 30
	closing_time = 20

/obj/structure/simple_door/bunker
	name = "airlock"
	desc = "An olive green painted airlock.<br>The door mechanism itself is a complex mix of an electic engine and hydraulic motion.<br>This particular door looks like a pre-War military tech."
	icon_state = "bunker"
	door_type = "bunker"
	material_type = /obj/item/stack/sheet/metal
	open_sound = "sound/f13machines/doorairlock_open.ogg"
	close_sound = "sound/f13machines/doorairlock_close.ogg"
	explosion_block = 5

/obj/structure/simple_door/bunker/glass
	desc = "An olive green painted airlock, with semi-transparent glass window.<br>The door mechanism itself is a complex mix of an electic engine and hydraulic motion.<br>This particular door looks like a pre-War military tech."
	icon_state = "bunkerglass"
	door_type = "bunkerglass"
	explosion_block = 4 //A glass window in it, reduces the resistance, am I right?
	opacity = FALSE
	base_opacity = FALSE

/obj/structure/simple_door/tent
	name = "tent flap"
	desc = "A fairly simple looking entrance to a war tent."
	icon_state = "tent"
	door_type = "tent"
	material_type = /obj/item/stack/sheet/cloth
	open_sound = "sound/effects/curtain.ogg"
	close_sound = "sound/effects/curtain.ogg"
	can_hold_padlock = TRUE
