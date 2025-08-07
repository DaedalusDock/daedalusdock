//////////////////////////////////////////////////////////////////////////////
/////////////////////// General Vending Restocks /////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/vending
	group = "Vending Restocks"

/datum/supply_pack/vending/bartending
	name = "Booze-o-mat and Coffee Supply Crate"
	desc = "Bring on the booze and coffee vending machine refills."
	cost = PAYCHECK_ASSISTANT * 7.9 + CARGO_CRATE_VALUE
	contains = list(/obj/item/vending_refill/boozeomat,
					/obj/item/vending_refill/coffee)
	crate_name = "bartending supply crate"

/datum/supply_pack/vending/cigarette
	name = "Cigarette Supply Crate"
	desc = "Don't believe the reports - smoke today! Contains a cigarette vending machine refill."
	cost = PAYCHECK_ASSISTANT * 5 + CARGO_CRATE_VALUE
	contains = list(/obj/item/vending_refill/cigarette)
	crate_name = "cigarette supply crate"
	crate_type = /obj/structure/closet/crate

/datum/supply_pack/vending/dinnerware
	name = "Dinnerware Supply Crate"
	desc = "More knives for the chef."
	cost = PAYCHECK_ASSISTANT * 3 + CARGO_CRATE_VALUE
	contains = list(/obj/item/vending_refill/dinnerware)
	crate_name = "dinnerware supply crate"

/datum/supply_pack/vending/games
	name = "Games Supply Crate"
	desc = "Get your game on with this game vending machine refill."
	cost = PAYCHECK_ASSISTANT * 2.3 + CARGO_CRATE_VALUE
	contains = list(/obj/item/vending_refill/games)
	crate_name = "games supply crate"
	crate_type = /obj/structure/closet/crate

/datum/supply_pack/vending/snack
	name = "Snack Supply Crate"
	desc = "One vending machine refill of cavity-bringin' goodness! The number one dentist recommended order!"
	cost = PAYCHECK_ASSISTANT * 2.5 + CARGO_CRATE_VALUE
	contains = list(/obj/item/vending_refill/snack)
	crate_name = "snacks supply crate"

/datum/supply_pack/vending/cola
	name = "Softdrinks Supply Crate"
	desc = "Got whacked by a toolbox, but you still have those pesky teeth? Get rid of those pearly whites with this soda machine refill, today!"
	cost = PAYCHECK_ASSISTANT * 1.9 + CARGO_CRATE_VALUE
	contains = list(/obj/item/vending_refill/cola)
	crate_name = "soft drinks supply crate"

