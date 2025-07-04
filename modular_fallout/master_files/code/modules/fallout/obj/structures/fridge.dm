//Fallout 13 fridge directory

/obj/structure/closet/fridge
	name = "fridge"
	desc = "An old, pre-War refrigerator.<br>Despite being covered in rust and making noises straight out of a horror film, it still keeps your Nuka-Cola cold."
	icon_state = "fridge"

/obj/structure/closet/fridge/standard/New()
	..()
	for(var/i = 0, i < 4, i++)
		new /obj/item/food/grown/mutfruit(src)
	for(var/i = 0, i < 3, i++)
		new /obj/item/food/f13/cram(src)
	for(var/i = 0, i < 2, i++)
		new /obj/item/bottle/f13nukacola(src)
	for(var/i = 0, i < 1, i++)
		new /obj/item/food/meat/steak/molerat(src)

/obj/structure/closet/fridge/meat/New()
	..()
	for(var/i = 0, i < 4, i++)
		new /obj/item/food/meat/slab/gecko(src)

/obj/structure/closet/fridge/cannibal/New()
	..()
	for(var/i = 0, i < 4, i++)
		new /obj/item/food/meat/slab/human(src)

/obj/structure/closet/crate/freezer
	desc = "An old, rusted freezer.<br>Despite going through a nuclear holocaust, it's somehow still good at keeping things cold."
	name = "freezer"
	icon_state = "freezer"

