//FO13 arrows
/obj/item/ammo_casing/caseless/arrow
	name = "metal arrow"
	desc = "A simple arrow with a metal head."
	icon = 'modular_fallout/master_files/icons/fallout/objects/guns/ammo.dmi'
	projectile_type = /obj/projectile/bullet/reusable/arrow
	caliber = "arrow"
	icon_state = "arrow"
	throwforce = 8 //good luck hitting someone with the pointy end of the arrow
	throw_speed = 3
	w_class = 3

/obj/item/ammo_casing/caseless/arrow/ap
	name = "sturdy arrow"
	desc = "A reinforced arrow with a metal shaft and heavy duty head."
	projectile_type = /obj/projectile/bullet/reusable/arrow/ap
	icon_state = "arrow_ap"

/obj/item/ammo_casing/caseless/arrow/poison
	name = "poison arrow"
	desc = "A simple arrow, tipped in a poisonous paste."
	projectile_type = /obj/projectile/bullet/reusable/arrow/poison
	icon_state = "arrow_poison"
