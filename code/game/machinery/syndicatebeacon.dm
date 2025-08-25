/obj/item/sbeacondrop
	name = "suspicious beacon"
	icon = 'icons/obj/device.dmi'
	icon_state = "beacon"
	lefthand_file = 'icons/mob/inhands/misc/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/devices_righthand.dmi'
	desc = "A label on it reads: <i>Warning: Activating this device will send a special beacon to your location</i>."
	w_class = WEIGHT_CLASS_SMALL
	var/droptype = /obj/machinery/syndicatebomb


/obj/item/sbeacondrop/attack_self(mob/user)
	if(user)
		to_chat(user, span_notice("Locked In."))
		new droptype( user.loc )
		playsound(src, 'sound/effects/pop.ogg', 100, TRUE, TRUE)
		qdel(src)
	return

/obj/item/sbeacondrop/bomb
	desc = "A label on it reads: <i>Warning: Activating this device will send a high-ordinance explosive to your location</i>."
	droptype = /obj/machinery/syndicatebomb

/obj/item/sbeacondrop/emp
	desc = "A label on it reads: <i>Warning: Activating this device will send a high-powered electromagnetic device to your location</i>."
	droptype = /obj/machinery/syndicatebomb/emp

/obj/item/sbeacondrop/powersink
	desc = "A label on it reads: <i>Warning: Activating this device will send a power draining device to your location</i>."
	droptype = /obj/item/powersink

/obj/item/sbeacondrop/clownbomb
	desc = "A label on it reads: <i>Warning: Activating this device will send a silly explosive to your location</i>."
	droptype = /obj/machinery/syndicatebomb/badmin/clown
