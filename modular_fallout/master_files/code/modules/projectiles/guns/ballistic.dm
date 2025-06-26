/obj/item/gun/ballistic
	desc = "Now comes in flavors like GUN. Uses 10mm ammo, for some reason."
	name = "projectile gun"
	var/en_bloc = 0
	var/init_mag_type = null

/obj/item/gun/ballistic/Initialize()
	. = ..()
	if(!spawnwithmagazine)
		update_icon()
		return
	if (!magazine)
		if(init_mag_type)
			magazine = new init_mag_type(src)
		else
			magazine = new mag_type(src)
	chamber_round()
	update_icon()

/obj/item/gun/ballistic/attack_self(mob/living/user)
	.=..()
	var/obj/item/ammo_casing/AC = chambered //Find chambered round
	if(magazine)
		if(en_bloc)
			magazine.forceMove(drop_location())
			user.dropItemToGround(magazine)
			magazine.update_icon()
			playsound(src, "sound/f13weapons/garand_ping.ogg", 70, 1)
			magazine = null
			to_chat(user, "<span class='notice'>You eject the enbloc clip out of \the [src].</span>")
	else if(chambered)
		AC.forceMove(drop_location())
		AC.bounce_away()
		chambered = null
		to_chat(user, "<span class='notice'>You unload the round from \the [src]'s chamber.</span>")
		playsound(src, "gun_slide_lock", 70, 1)
	else
		to_chat(user, "<span class='notice'>There's no magazine in \the [src].</span>")
	update_icon()
	return
