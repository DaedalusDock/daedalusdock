/obj/item/ammo_box
	var/multiload = FALSE

/obj/item/ammo_box/attempt_load_round(obj/item/A, mob/user, params, silent = FALSE, replace_spent = 0)
	.=..()
	if(istype(A, /obj/item/ammo_box))
		var/obj/item/ammo_box/AM = A
		for(var/obj/item/ammo_casing/AC in AM.stored_ammo)
			var/did_load = give_round(AC, replace_spent)
			if(did_load)
				AM.stored_ammo -= AC
				num_loaded++
			if(!did_load || !multiload)
				break

	return num_loaded
