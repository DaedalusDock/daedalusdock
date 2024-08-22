/obj/item/gun/ballistic/rifle/tranqrifle
	name = "tranquilizer rifle"
	desc = "A veterinary tranquilizer rifle chambered in .308 caliber. The bolt will only open if there's a magazine inserted or the chamber is empty."
	icon = 'goon/icons/obj/tranqgun.dmi'
	icon_state = "hunting_rifle0"
	lefthand_file = 'goon/icons/mob/inhands/guns_left.dmi'
	righthand_file = 'goon/icons/mob/inhands/guns_right.dmi'
	inhand_icon_state = "hunting_rifle"
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = null
	throw_range = 7
	force = 6
	custom_materials = list(/datum/material/iron=2000)
	clumsy_check = FALSE
	fire_sound = 'sound/items/syringeproj.ogg'
	mag_type = /obj/item/ammo_box/magazine/tranq_rifle/ryetalyn
	internal_magazine = FALSE
	empty_alarm = FALSE
	hidden_chambered = TRUE
	empty_indicator = FALSE
	pinless = TRUE
	rack_delay = 2

/obj/item/gun/ballistic/rifle/tranqrifle/update_icon_state()
	. = ..() //We do not want parent behavior
	icon_state = "hunting_rifle[magazine ? "" : "0"]"

//Snowflake supreme cuz im lazy as fuuuuuck
/obj/item/gun/ballistic/rifle/update_overlays()
	..()
	return list()

/obj/item/gun/ballistic/rifle/tranqrifle/rack(mob/user)
	if(!bolt.is_locked)
		if(!magazine && chambered)
			to_chat(user, span_warning("The bolt won't budge!"))
			return

		if(magazine && chambered && !magazine.give_round(chambered))
			to_chat(user, span_warning("The bolt won't budge!"))
			return

		to_chat(user, span_notice("You open the bolt of \the [src]."))
		playsound(src, rack_sound, rack_sound_volume, rack_sound_vary)
		chambered = null
		bolt.is_locked = TRUE
		return
	drop_bolt(user)
