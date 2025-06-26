/obj/item/reagent_containers/food/drinks/flask
	name = "metal flask"
	desc = "A metallic liquid container. Never leave home without one."
	icon_state = "flask"
	icon = 'modular_fallout/master_files/icons/fallout/objects/food&drinks/drinks.dmi'
	custom_materials = list(/datum/material/iron = 500)
	volume = 60
	list_reagents = list(/datum/reagent/water = 50)

/obj/item/reagent_containers/food/drinks/flask/survival
	name = "metal flask"
	desc = "A metallic liquid container. Essential for survival out in the wastes."
	list_reagents = list(/datum/reagent/water = 40, /datum/reagent/medicine/silver_sulfadiazine = 10)

/obj/item/reagent_containers/food/drinks/flask/vault13
	name = "Vault 13 flask"
	desc = "Take a sip from your trusty Vault 13 canteen."
	icon_state = "flask13"
	list_reagents = list(/datum/reagent/water = 30, /datum/reagent/medicine/silver_sulfadiazine = 10, /datum/reagent/medicine/activated_charcoal = 20)

/obj/item/reagent_containers/food/drinks/flask/vault113
	name = "Vault 113 flask"
	desc = "See this large yellow number? It means it's a Vault 113 canteen. Never forget."
	icon_state = "flask113"
	list_reagents = list(/datum/reagent/water = 30, /datum/reagent/uranium/radium = 10, /datum/reagent/medicine/mine_salve = 20)

/obj/item/reagent_containers/food/drinks/flask/ss13
	name = "metal flask"
	desc = "A strange metal flask with some meaningless letters engraved on the side."
	icon_state = "flaskss13"
	list_reagents = list(/datum/reagent/medicine/tricordrazine = 40, /datum/reagent/medicine/adminordrazine = 10)
