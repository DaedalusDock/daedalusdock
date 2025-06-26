//Fallout 13 automobile tires directory

/obj/structure/tires
	name = "tire"
	desc = "A ring-shaped vehicle component that covers the wheel's rim to protect it and enable better vehicle performance."
	icon = 'modular_fallout/master_files/icons/fallout/trash.dmi'
	icon_state = "one_t"
	max_integrity = 50
	density = 1

/obj/structure/tires/half
	name = "half tire"
	desc = "A part of a part of a car." //The description is totally intentional.
	icon_state = "half_t"
	max_integrity = 10
	density = 0

/obj/structure/tires/two
	name = "couple of tires"
	desc = "Ring-shaped vehicle components that cover the wheel's rims to protect them and enable better vehicle performance."
	icon_state = "two_t"
	max_integrity = 100
	density = 1
	anchored = 1

/obj/structure/tires/five
	name = "pile of tires"
	desc = "Five tires stacked on top of each other in an orderly fashion.<br>Is the car shop nearby or something?"
	icon_state = "five_t"
	obj_integrity = 250
	density = 1
	anchored = 1
