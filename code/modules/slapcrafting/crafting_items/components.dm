//Misc. items that exist for other crafting recipes. Only add new ones if you can't justify making a crafting step instead.
TYPEINFO_DEF(/obj/item/wirerod)
	default_materials = list(/datum/material/iron=1150, /datum/material/glass=75)

/obj/item/wirerod
	name = "wired rod"
	desc = "A rod with some wire wrapped around the top. It'd be easy to attach something to the top bit."
	icon = 'icons/obj/slapcrafting/components.dmi'
	icon_state = "wiredrod"
	inhand_icon_state = "rods"
	flags_1 = CONDUCT_1
	force = 9
	throwforce = 10
	w_class = WEIGHT_CLASS_BULKY
	attack_verb_continuous = list("hits", "bludgeons", "whacks", "bonks")
	attack_verb_simple = list("hit", "bludgeon", "whack", "bonk")

TYPEINFO_DEF(/obj/item/metal_ball)
	default_materials = list(/datum/material/iron=2000)

/obj/item/metal_ball
	name = "metal ball"
	desc = "A small metal ball. It's rather heavy, and could roll easily."
	icon = 'icons/obj/slapcrafting/components.dmi'
	icon_state = "metalball" //this is a shitty placeholder sprite PLEASE replace it later
	inhand_icon_state = "minimeteor" //conveniently grey and ball-shaped
	flags_1 = CONDUCT_1
	force = 6
	throwforce = 10 //time to go bowling!
	w_class = WEIGHT_CLASS_BULKY
	attack_verb_continuous = list("hits", "thwacks", "bowls")
	attack_verb_simple = list("hit", "thwack", "bowl")
