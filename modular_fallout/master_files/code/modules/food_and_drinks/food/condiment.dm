
/obj/item/reagent_containers/condiment/milk
	name = "milk"
	desc = "You hope it hasn't expired, but its likely."
	icon_state = "milk"
	inhand_icon_state = "carton"
	lefthand_file = 'icons/mob/inhands/equipment/kitchen_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/kitchen_righthand.dmi'
	list_reagents = list(/datum/reagent/consumable/milk = 50)

/obj/item/reagent_containers/condiment/flour
	name = "flour sack"
	desc = "A big bag of flour. Good for baking!"
	icon_state = "flour"
	inhand_icon_state = "flour"
	list_reagents = list(/datum/reagent/consumable/flour = 30)

/obj/item/reagent_containers/condiment/soymilk
	name = "soy milk"
	desc = "It's soy milk. White and nutritious goodness!"
	icon_state = "soymilk"
	inhand_icon_state = "carton"
	lefthand_file = 'icons/mob/inhands/equipment/kitchen_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/kitchen_righthand.dmi'
	list_reagents = list(/datum/reagent/consumable/soymilk = 50)

/obj/item/reagent_containers/condiment/rice
	name = "rice sack"
	desc = "A big bag of rice. Good for cooking!"
	icon_state = "rice"
	inhand_icon_state = "flour"
	list_reagents = list(/datum/reagent/consumable/rice = 30)

/obj/item/reagent_containers/condiment/soysauce
	name = "soy sauce"
	desc = "A salty soy-based flavoring."
	icon_state = "soysauce"
	list_reagents = list(/datum/reagent/consumable/soysauce = 50)

/obj/item/reagent_containers/condiment/mayonnaise
	name = "mayonnaise"
	desc = "An oily condiment made from egg yolks."
	icon_state = "mayonnaise"
	list_reagents = list(/datum/reagent/consumable/mayonnaise = 50)


//Food packs. To easily apply deadly toxi... delicious sauces to your food!

/obj/item/reagent_containers/condiment/pack
	name = "condiment pack"
	desc = "A small plastic pack with condiments to put on your food."
	icon_state = "condi_empty"

//Ketchup
/obj/item/reagent_containers/condiment/pack/ketchup
	name = "ketchup pack"
	originalname = "ketchup"
	list_reagents = list(/datum/reagent/consumable/ketchup = 10)

//Mustard
/obj/item/reagent_containers/condiment/pack/mustard
	name = "mustard pack"
	originalname = "mustard"
	list_reagents = list(/datum/reagent/consumable/mustard = 10)

//Hot sauce
/obj/item/reagent_containers/condiment/pack/hotsauce
	name = "hotsauce pack"
	originalname = "hotsauce"
	list_reagents = list(/datum/reagent/consumable/capsaicin = 10)

/obj/item/reagent_containers/condiment/pack/astrotame
	name = "astrotame pack"
	originalname = "astrotame"
	list_reagents = list(/datum/reagent/consumable/astrotame = 5)

//Other Sauce
/obj/item/reagent_containers/condiment/pack/bbqsauce
	name = "bbq sauce pack"
	originalname = "bbq sauce"
	list_reagents = list(/datum/reagent/consumable/bbqsauce = 10)

/obj/item/reagent_containers/condiment/pack/soysauce
	name = "soy sauce pack"
	originalname = "soy sauce"
	list_reagents = list(/datum/reagent/consumable/soysauce = 10)

/obj/item/reagent_containers/condiment/ketchup
	name = "Ketchup"
	desc = "A classic American Sauce."
	icon_state = "ketchup"
	list_reagents = list(/datum/reagent/consumable/ketchup = 50)
	possible_states = list()

/obj/item/reagent_containers/condiment/yeast
	name = "yeast"
	desc = "A can of yeast extract used, in the of cooking various dishes."
	icon_state = "yeast"
	list_reagents = list(/datum/reagent/consumable/enzyme = 50)

/obj/item/reagent_containers/condiment/pack/coffee
	name = "instant coffee pack"
	list_reagents = list(/datum/reagent/toxin/coffeepowder = 10)

/obj/item/reagent_containers/condiment/pack/soup
	name = "soup bouillon pack"
	list_reagents = list(/datum/reagent/consumable/dry_ramen = 10)
