//FALLOUT POWERCELLS

/obj/item/stock_parts/cell
	var/can_charge = TRUE

/obj/item/stock_parts/cell/ammo/mfc
	name = "microfusion cell"
	desc = "A microfusion cell, typically used as ammunition for large energy weapons."
	icon = 'modular_fallout/master_files/icons/fallout/objects/powercells.dmi'
	icon_state = "mfc-full"
	maxcharge = 2000

/obj/item/stock_parts/cell/ammo/mfc/update_icon()
	switch(charge)
		if (1001 to 2000)
			icon_state = "mfc-full"
		if (51 to 1000)
			icon_state = "mfc-half"
		if (0 to 50)
			icon_state = "mfc-empty"
	. = ..()

/obj/item/stock_parts/cell/ammo/ultracite
	name = "ultracite cell"
	desc = "An advanced ultracite cell, used as ammunition for special energy weapons."
	icon = 'modular_fallout/master_files/icons/fallout/objects/powercells.dmi'
	icon_state = "ultracite"
	maxcharge = 2000

/obj/item/stock_parts/cell/ammo/ec
	name = "energy cell"
	desc = "An energy cell, typically used as ammunition for small-arms energy weapons."
	icon = 'modular_fallout/master_files/icons/fallout/objects/powercells.dmi'
	icon_state = "ec-full"
	maxcharge = 1600

/obj/item/stock_parts/cell/ammo/ec/update_icon()
	switch(charge)
		if (1101 to 1600)
			icon_state = "ec-full"
		if (551 to 1100)
			icon_state = "ec-twothirds"
		if (51 to 550)
			icon_state = "ec-onethirds"
		if (0 to 50)
			icon_state = "ec-empty"
	. = ..()

/obj/item/stock_parts/cell/ammo/alien
	name = "alien weapon cell"
	desc = "A weapon cell that glows and thrums with unearthly energies. You're not sure you'd be able to recharge it, but it seems very powerful."
	icon = 'modular_fallout/master_files/icons/fallout/objects/powercells.dmi'
	icon_state = "aliencell"
	ratingdesc = FALSE
	maxcharge = 4000
	can_charge = FALSE

/obj/item/stock_parts/cell/ammo/ecp
	name = "electron charge pack"
	desc = "An electron charge pack, typically used as ammunition for rapidly-firing energy weapons."
	icon_state = "icell"
	maxcharge = 2400

// Cell Charger can_charge modification (I can't be bothered making a cell_charger modular file for this.)
/*
/obj/machinery/cell_charger/attackby(obj/item/W, mob/user, params)
	.=..()
	if(istype(W, /obj/item/stock_parts/cell) && !panel_open)
		if(!W.can_charge)
			to_chat(user, "<span class='warning'>The cell isn't compatible with this charger!</span>")
			return
*/
