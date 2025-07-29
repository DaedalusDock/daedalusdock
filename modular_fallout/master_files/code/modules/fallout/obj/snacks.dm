/obj/item/food/rawbrahmintongue
	name = "Raw Brahmin Tongue"
	desc = "The raw tongue of a brahmin, a wastelander favorite"
	icon_state = "BrahminTongue"
	bite_consumption = 3
	//filling_color = "#CD853F"
	food_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/consumable/nutriment/vitamin = 2)
	microwaved_type = /obj/item/food/cookedbrahmintongue
	tastes = list("beef" = 4, "tender meat" = 1)
//	foodtypes = MEAT

/obj/item/food/cookedbrahmintongue
	name = "Brahmin Tongue"
	desc = "A brahmin tongue slow roasted over an open fire and topped with a large amount of thick brown gravy"
	icon_state = "stewedsoymeat"
	bite_consumption = 3
	//filling_color = "#CD853F"
	food_reagents = list(/datum/reagent/consumable/nutriment = 5, /datum/reagent/consumable/nutriment/vitamin = 2)
	microwaved_type = /obj/item/food/cookedbrahmintongue
	tastes = list("top quality beef" = 4, "tender meat" = 1, "tasty gravy" = 1)
//	foodtypes = MEAT


/obj/item/food/rawbrahminliver
	name = "Raw Brahmin Liver"
	desc = "The raw tongue of a brahmin, a wastelander favorite"
	icon_state = "Brahmin Liver"
	bite_consumption = 3
	//filling_color = "#CD853F"
	food_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/consumable/nutriment/vitamin = 2)
	microwaved_type = /obj/item/food/cookedbrahminliver
	tastes = list("beef" = 4, "tender meat" = 1)
//	foodtypes = MEAT

/obj/item/food/cookedbrahminliver
	name = "Charred Brahmin Liver"
	desc = "A fatty brahmin liver roasted in a cast iron pan over mesquite wood."
	icon_state = "Charred Brahmin Liver"
	bite_consumption = 3
	//filling_color = "#CD853F"
	food_reagents = list(/datum/reagent/consumable/nutriment = 5, /datum/reagent/consumable/nutriment/vitamin = 4)
	tastes = list("slow cooked liver" = 4, "delicious crunch" = 1)
//	foodtypes = MEAT

/obj/item/food/rawantbrain
	name = "Raw Ant Brain"
	desc = "Goppy reddish-grey flesh dug out of the brain case of a giant ant."
	icon_state = "AntBrain"
	bite_consumption = 3
	//filling_color = "#CD853F"
	food_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/consumable/nutriment/vitamin = 2)
	tastes = list("fat" = 4, "bitter meat" = 1)
//	foodtypes = MEAT
