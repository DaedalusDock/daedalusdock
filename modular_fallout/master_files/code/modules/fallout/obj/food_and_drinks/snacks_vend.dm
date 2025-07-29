////////////////////////////////////////////SNACKS FROM VENDING MACHINES////////////////////////////////////////////
//in other words: junk food
//don't even bother looking for recipes for these

/obj/item/food/candy
	name = "candy"
	desc = "Nougat love it or hate it."
	icon_state = "candy"
	trash_type = /obj/item/trash/candy
	food_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/consumable/sugar = 3, /datum/reagent/consumable/coco = 3)
	junkiness = 25
	tastes = list("candy" = 1)
	foodtypes = JUNKFOOD | SUGAR

/obj/item/food/sosjerky
	name = "\improper Scaredy's Private Reserve Beef Jerky"
	icon_state = "sosjerky"
	desc = "Beef jerky made from the finest space cows."
	trash_type = /obj/item/trash/sosjerky
	food_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/consumable/sugar = 3, /datum/reagent/consumable/salt = 2)
	junkiness = 25
	tastes = list("dried meat" = 1)
	foodtypes = JUNKFOOD | MEAT | SUGAR

/obj/item/food/sosjerky/healthy
	name = "homemade beef jerky"
	desc = "Homemade beef jerky made from the finest brahmin."
	food_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/consumable/nutriment/vitamin = 1)
	junkiness = 0

/obj/item/food/sosjerky/ration
	name = "brahmin jerky"
	desc = "Brahmin jerky strips in a sealed package."
	food_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/consumable/nutriment/vitamin = 1)
	junkiness = 0
	foodtypes = MEAT

/obj/item/food/chips
	name = "chips"
	desc = "Commander Riker's What-The-Crisps."
	icon_state = "chips"
	trash_type = /obj/item/trash/chips
	food_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/consumable/sugar = 3, /datum/reagent/consumable/salt = 1)
	junkiness = 20
	tastes = list("salt" = 1, "crisps" = 1)
	foodtypes = JUNKFOOD | FRIED

/obj/item/food/no_raisin
	name = "4no raisins"
	icon_state = "4no_raisins"
	desc = "Best raisins in the universe. Not sure why."
	trash_type = /obj/item/trash/raisins
	food_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/consumable/sugar = 4)
	junkiness = 25
	tastes = list("dried raisins" = 1)
	foodtypes = JUNKFOOD | FRUIT | SUGAR

/obj/item/food/no_raisin/healthy
	name = "homemade raisins"
	desc = "Homemade raisins, the best in all of spess."
	food_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/consumable/nutriment/vitamin = 2)
	junkiness = 0
	foodtypes = FRUIT

/obj/item/food/spacetwinkie
	name = "space twinkie"
	icon_state = "space_twinkie"
	desc = "Guaranteed to survive longer than you will."
	food_reagents = list(/datum/reagent/consumable/sugar = 4)
	junkiness = 25
	foodtypes = JUNKFOOD | GRAIN | SUGAR

/obj/item/food/cheesiehonkers
	name = "cheesie honkers"
	desc = "Bite sized cheesie snacks that will honk all over your mouth."
	icon_state = "cheesie_honkers"
	trash_type = /obj/item/trash/cheesie
	food_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/consumable/sugar = 3)
	junkiness = 25
	tastes = list("cheese" = 5, "crisps" = 2)
	foodtypes = JUNKFOOD | DAIRY | SUGAR

/obj/item/food/syndicake
	name = "syndi-cakes"
	icon_state = "syndi_cakes"
	desc = "An extremely moist snack cake that tastes just as good after being nuked."
	trash_type = /obj/item/trash/syndi_cakes
	food_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/consumable/doctor_delight = 5)
	tastes = list("sweetness" = 3, "cake" = 1)
	foodtypes = GRAIN | FRUIT | VEGETABLES
