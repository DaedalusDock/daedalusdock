/obj/projectile/bullet/reusable/arrow
	name = "metal arrow"
	desc = "a simple arrow with a metal head."
	damage = 40
	armor_penetration = 20
	icon_state = "arrow"
	ammo_type = /obj/item/ammo_casing/caseless/arrow

//FO13 ARROWS
/obj/projectile/bullet/reusable/arrow/ap
	name = "sturdy arrow"
	desc = "A reinforced arrow with a metal shaft and heavy duty head."
	damage = 35
	armor_penetration = 50
	icon_state = "arrow"
	ammo_type = /obj/item/ammo_casing/caseless/arrow/ap

/obj/projectile/bullet/reusable/arrow/poison
	name = "poison arrow"
	desc = "A simple arrow, tipped in a poisonous paste."
	damage = 20 //really gotta balance this, holy cow
	armor_penetration = 10
	icon_state = "arrow"
	ammo_type = /obj/item/ammo_casing/caseless/arrow/poison

/obj/projectile/bullet/reusable/arrow/poison/on_hit(atom/target, blocked)
	. = ..()
	if(ishuman(target))
		var/mob/living/carbon/human/targetHuman = target
		targetHuman.reagents.add_reagent(/datum/reagent/toxin, 10) //so you get some toxin damage! around 30
