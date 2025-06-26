//Fallout 13 Vault blast doors and controls directory

/obj/structure/vault_door
	name = "Vault 113 blast door"
	desc = "A conventional Vault blast door of \"Nine cog\" model.<br>A blast door design incorporates proper sealants against radiation and other hazardous elements that may be created in the event of a nuclear war, to properly protect its inhabitants."
	icon = 'modular_fallout/master_files/icons/fallout/machines/gear.dmi'
	icon_state = "113closed"
	density = 1
	opacity = 1
	layer = ABOVE_ALL_MOB_LAYER
	anchored = 1
	var/is_busy = 0
	var/destroyed = 0
	var/id = 1
	var/close_state = "113closed"
	var/open_state = "113open"
	var/closing_state = "113closing"
	var/opening_state = "113opening"
	var/broken_state = "113empty"
	pixel_x = -32
	pixel_y = -32
	obj_integrity = -1
	max_integrity = -1
	integrity_failure = 0

/obj/structure/vault_door/old
	name = "\proper ancient Vault blast door"
	icon_state = "oldclosed"
	close_state = "oldclosed"
	open_state = "oldopen"
	closing_state = "oldclosing"
	opening_state = "oldopening"
	broken_state = "oldempty"

/obj/structure/vault_door/obj_break(damage_flag)
	icon_state = broken_state
	src.set_opacity(0)
	src.density = 0
	destroyed = 1

/obj/structure/vault_door/proc/open()
	is_busy = 1
	flick(opening_state, src)
	icon_state = open_state
	spawn(11)
		playsound(loc, 'sound/f13machines/doorgear_open.ogg', 50, 0, 10)
		spawn(19)
			src.set_opacity(0)
			src.density = 0
			is_busy = 0
/obj/structure/vault_door/proc/close()
	is_busy = 1
	flick(closing_state, src)
	icon_state = close_state
	spawn(11)
		playsound(loc, 'sound/f13machines/doorgear_close.ogg', 50, 0, 10)
		spawn(19)
			src.set_opacity(1)
			src.density = 1
			is_busy = 0

/obj/structure/vault_door/proc/toggle()
	if(destroyed)
		usr << "<span class='warning'>[src] is broken.</span>"
		return
	if(is_busy)
		usr << "<span class='warning'>[src] is busy.</span>"
		return
	if (density)
		open()
		return
	close()

//Lever

/obj/machinery/doorButtons/vaultButton
	name = "Vault access panel"
	desc = "Pull the lever to open the door - it's that simple."
	icon = 'modular_fallout/master_files/icons/fallout/machines/lever.dmi'
	icon_state = "lever"
	anchored = 1
	density = 1
	var/id = 1

/obj/machinery/doorButtons/vaultButton/proc/toggle_door()
	var/opened
	icon_state = "lever0"
	for(var/obj/structure/vault_door/door in GLOB.vault_doors)
		if(door.id == id)
			door.toggle()
			opened = !door.density
	spawn(50)
		if(opened)
			icon_state = "lever2"
		else
			icon_state = "lever"

/obj/machinery/doorButtons/vaultButton/attackby(obj/item/weapon/W, mob/user, params)
	attack_hand(user)

/obj/machinery/doorButtons/vaultButton/attack_hand(mob/user)
	..()
	if(iscarbon(user))
		var/mob/living/carbon/C = user
		if(C.handcuffed)
			return
	toggle_door()
