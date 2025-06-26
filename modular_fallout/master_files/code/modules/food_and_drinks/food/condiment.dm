
/obj/item/reagent_containers/food/condiment/milk
	name = "milk"
	desc = "You hope it hasn't expired, but its likely."
	icon_state = "milk"
	item_state = "carton"
	lefthand_file = 'icons/mob/inhands/equipment/kitchen_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/kitchen_righthand.dmi'

/obj/item/reagent_containers/food/condiment/flour
	name = "flour sack"
	desc = "A big bag of flour. Good for baking!"
	icon_state = "flour"
	item_state = "flour"

/obj/item/reagent_containers/food/condiment/soymilk
	name = "soy milk"
	desc = "It's soy milk. White and nutritious goodness!"
	icon_state = "soymilk"
	item_state = "carton"
	lefthand_file = 'icons/mob/inhands/equipment/kitchen_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/kitchen_righthand.dmi'

/obj/item/reagent_containers/food/condiment/rice
	name = "rice sack"
	desc = "A big bag of rice. Good for cooking!"
	icon_state = "rice"
	item_state = "flour"

/obj/item/reagent_containers/food/condiment/soysauce
	name = "soy sauce"
	desc = "A salty soy-based flavoring."
	icon_state = "soysauce"

/obj/item/reagent_containers/food/condiment/mayonnaise
	name = "mayonnaise"
	desc = "An oily condiment made from egg yolks."
	icon_state = "mayonnaise"



//Food packs. To easily apply deadly toxi... delicious sauces to your food!

/obj/item/reagent_containers/food/condiment/pack
	name = "condiment pack"
	desc = "A small plastic pack with condiments to put on your food."
	icon_state = "condi_empty"

//Ketchup
/obj/item/reagent_containers/food/condiment/pack/ketchup
	name = "ketchup pack"
	originalname = "ketchup"
	list_reagents = list(/datum/reagent/consumable/ketchup = 10)

//Mustard
/obj/item/reagent_containers/food/condiment/pack/mustard
	name = "mustard pack"
	originalname = "mustard"
	list_reagents = list(/datum/reagent/consumable/mustard = 10)

//Hot sauce
/obj/item/reagent_containers/food/condiment/pack/hotsauce
	name = "hotsauce pack"
	originalname = "hotsauce"
	list_reagents = list(/datum/reagent/consumable/capsaicin = 10)

/obj/item/reagent_containers/food/condiment/pack/astrotame
	name = "astrotame pack"
	originalname = "astrotame"
	list_reagents = list(/datum/reagent/consumable/astrotame = 5)

//Other Sauce
/obj/item/reagent_containers/food/condiment/pack/bbqsauce
	name = "bbq sauce pack"
	originalname = "bbq sauce"
	list_reagents = list(/datum/reagent/consumable/bbqsauce = 10)

/obj/item/reagent_containers/food/condiment/pack/soysauce
	name = "soy sauce pack"
	originalname = "soy sauce"
	list_reagents = list(/datum/reagent/consumable/soysauce = 10)

/obj/item/reagent_containers/food/condiment/ketchup
	name = "Ketchup"
	desc = "A classic American Sauce."
	icon_state = "ketchup"
	list_reagents = list(/datum/reagent/consumable/ketchup = 50)
	possible_states = list()

/obj/item/reagent_containers/food/condiment/yeast
	name = "yeast"
	desc = "A can of yeast extract used, in the of cooking various dishes."
	icon_state = "yeast"
	list_reagents = list(/datum/reagent/consumable/enzyme = 50)

/obj/item/reagent_containers/food/condiment/pack/coffee
	name = "instant coffee pack"
	list_reagents = list(/datum/reagent/toxin/coffeepowder = 10)

/obj/item/reagent_containers/food/condiment/pack/soup
	name = "soup bouillon pack"
	list_reagents = list(/datum/reagent/consumable/dry_ramen = 10)
