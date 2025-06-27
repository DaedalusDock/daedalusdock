//Fallout 13 Vault blast doors and controls directory

/obj/machinery/door/poddoor/vault_door
	name = "Vault 113 blast door"
	desc = "A conventional Vault blast door of \"Nine cog\" model.<br>A blast door design incorporates proper sealants against radiation and other hazardous elements that may be created in the event of a nuclear war, to properly protect its inhabitants."
	icon = 'modular_fallout/master_files/icons/fallout/machines/gear.dmi'
	icon_state = "113closed"
	layer = ABOVE_ALL_MOB_LAYER
	anchored = 1
	var/broken_state = "113empty"
	var/destroyed = FALSE
	pixel_x = -32
	pixel_y = -32
	max_integrity = 2000
	integrity_failure = 0
	resistance_flags = null
	damage_deflection = 80

/obj/structure/vault_door/old
	name = "\proper ancient Vault blast door"
	icon_state = "oldclosed"
	closing_state = "oldclosing"
	opening_state = "oldopening"
	broken_state = "oldempty"

/obj/machinery/door/poddoor/vault_door/obj_break(damage_flag)
	icon_state = broken_state
	src.set_opacity(0)
	src.density = FALSE
	destroyed = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF

/obj/machinery/door/poddoor/vault_door/do_animate(animation)
	switch(animation)
		if("opening")
			z_flick("opening", src)
			playsound(src, 'modular_fallout/master_files/sound/f13machines/doorgear_open.ogg', 60, TRUE)
		if("closing")
			z_flick("closing", src)
			playsound(src, 'modular_fallout/master_files/sound/f13machines/doorgear_close.ogg', 60, TRUE)

/obj/machinery/door/poddoor/vault_door/open()
	.=..()
	flick(opening_state, src)
	icon_state = open_state
	spawn(11)
		playsound(loc, 'modular_fallout/master_files/sound/f13machines/doorgear_open.ogg', 50, 0, 10)
		spawn(19)
			set_density(FALSE)
			flags_1 &= ~PREVENT_CLICK_UNDER_1
	..()

/obj/machinery/door/poddoor/vault_door/close()
	.=..()
	flick(closing_state, src)
	icon_state = close_state
	spawn(11)
		playsound(loc, 'modular_fallout/master_files/sound/f13machines/doorgear_close.ogg', 50, 0, 10)
		spawn(19)
			set_density(TRUE)
			flags_1 |= PREVENT_CLICK_UNDER_1
	..()

/obj/machinery/door/poddoor/vault_door/proc/toggle()
	if(destroyed)
		usr << "<span class='warning'>[src] is broken.</span>"
		return
	if(operating)
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
	for(var/obj/machinery/door/poddoor/vault_door/ in GLOB.vault_doors)
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
