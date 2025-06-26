//Pastry is a food that is made from dough which is made from wheat or rye flour.
//This file contains pastries that don't fit any existing categories.
/obj/item/food/cracker
	name = "cracker"
	desc = "It's a salted cracker."
	icon_state = "cracker"
	bite_consumption = 1
	initial_reagents = list(/datum/reagent/consumable/nutriment = 1)
	tastes = list("cracker" = 1)
	foodtypes = GRAIN

/obj/item/food/cracker/c_ration
	name = "army cracker"
	bite_consumption = 2
	icon_state = "c_ration_cracker"

/obj/item/food/cracker/k_ration
	name = "ranger biscuit"
	bite_consumption = 2
	icon_state = "k_ration_cracker"
	tastes = list("biscuit" = 1, "brahmin butter" = 1)
