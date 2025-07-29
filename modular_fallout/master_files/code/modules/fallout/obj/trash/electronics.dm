/obj/item/trash/f13/electronic
	name = "electronic trash"
	components = list(/obj/item/stock_parts/capacitor=1)

/obj/item/trash/f13/electronic/toaster
	name = "toaster"
	desc = "A working toaster of prewar design, for making toast. You can insert various things inside the slot. This General Electronics model has two slots."
	icon_state = "toaster"
	components = list(	/obj/item/stock_parts/capacitor=1,
						/obj/item/stock_parts/matter_bin=1,
						/obj/item/stock_parts/micro_laser=2,
					)
	var/toast_time = 35
	var/obj/item/stock_parts/cell/cell = null
	var/fork_damage = 6
	var/is_toasting = 0
	var/power_use = 2
	var/toast_slots = 2
	var/max_item_size = WEIGHT_CLASS_TINY
	var/list/toastables = list()

/obj/item/trash/f13/electronic/toaster/Initialize()
	. = ..()
	cell = new /obj/item/stock_parts/cell(src)

	toastables = typecacheof(list(/obj/item/food/breadslice,
		/obj/item/food/bagel,
		/obj/item/food/twobread,
		/obj/item/food/cracker, //Why toast a cracker? Who the fuck knows
		/obj/item/food/sandwich)) //Ehhhhhhhhhhhhhhhhh. I guess for toaster ovens, and "toast" items

	if(!rand(0,9) && isturf(loc) && src.type == /obj/item/trash/f13/electronic/toaster) //Randomized variants. strict type check, not istype, as that checks subtypes
		new /obj/item/trash/f13/electronic/toaster/oven(get_turf(src))
		qdel(src)
	else if(!rand(0,9999) && isturf(loc) && src.type == /obj/item/trash/f13/electronic/toaster)
		new /obj/item/trash/f13/electronic/toaster/atomics(get_turf(src))
		qdel(src)

/obj/item/trash/f13/electronic/toaster/Destroy()
	spew_contents()
	QDEL_NULL(cell)
	. = ..()

/obj/item/trash/f13/electronic/toaster/examine(mob/user)
	. = ..()
	if(is_toasting)
		. += span_notice("The smell of something being toasted wafts from the slot.")
	if(!cell || cell.charge <= 0)
		. += span_warning("The power cell seems to be faulty.")

/obj/item/trash/f13/electronic/toaster/attackby(obj/item/W, mob/user, params)
	var/mob/living/carbon/human/U = user
	if(!istype(U) || !istype(W))
		return ..()

	if(istype(W,/obj/item/kitchen/fork) || istype(W,/obj/item/melee/onehanded/knife))
		if(alert(U, "You sure you want to jam that in there?",,"Yes","No") == "Yes")
			if(do_after(user, 10, 1, target = src))
				U.visible_message("<span class='warning'>[user] jams [W] into [src]!</span>", "<span class='notice'>You jam [W] into [src]!</span>")
				U.transferItemToLoc(W,src)
				playsound(get_turf(src), "sparks", 40, 1)
				if(cell && cell.charge)
					U.electrocute_act(fork_damage,src)
				addtimer(CALLBACK(src,.proc/spew_contents), rand(5,15))
				is_toasting = 0
				return

	if(istype(W,/obj/item/stock_parts/cell))
		playsound(get_turf(src), 'sound/items/screwdriver.ogg', 40, 1)
		if(cell)
			cell.forceMove(get_turf(src))
		if(user.transferItemToLoc(W,src))
			cell = W
		return

	if(LAZYLEN(src.contents) - 1 >= toast_slots) //Account for the power cell
		to_chat(user, "<span class='warning'>[src] looks full. Adding more to it might cause instability in the local space-time continuum, or worse; bad toast.</span>")
		return

	if(!cell || cell.charge <= 0)
		to_chat(user, "<span class='warning'>The power cell light on [src] blinks red. Putting things in it now would make it a mere bread holder and thus a mockery of all toasters.</span>")
		return

	if(is_type_in_typecache(W,toastables))
		if(user.transferItemToLoc(W, src))
			U.visible_message("<span class='notice'>[user] slides [W] smoothly into [src].</span>", "<span class='notice'>You slide [W] smoothly into [src].</span>")
			is_toasting = 1
			addtimer(CALLBACK(src,.proc/toasterize),toast_time)
			return

	to_chat(user, "<span class='warning'>Try as you might, you can't get [W] to fit into [src].</span>")
	return ..()

/obj/item/trash/f13/electronic/toaster/proc/spew_contents()
	var/atom/throw_target
	for(var/obj/item/I in contents)
		if(I == cell)
			continue
		throw_target = get_edge_target_turf(get_turf(src), pick(GLOB.alldirs))
		I.forceMove(get_turf(src))
		I.throw_at(throw_target,2,3)

/obj/item/trash/f13/electronic/toaster/proc/toasterize()
	if(!cell || cell.charge <= 0 || !is_toasting)
		return
	cell.charge = cell.charge - power_use //Use min() or floor? not here, this is the badlands
	if(cell.charge <= 0)
		cell.charge = 0
		return

	is_toasting = 0
	playsound(get_turf(src), 'sound/machines/ping.ogg', 50, 1, -1) //Need a better toaster sound
	for(var/obj/item/I in src.contents)
		if(I == cell) //Let's not toast our power cell
			continue

		if(I.color == "#111111") //You fool!! You imbecile! You utter moron!! You can't toast burnt bread! It just disintegrates!
			qdel(I)
			new /obj/effect/decal/cleanable/ash(get_turf(src))
			continue
		else if(I.color == "#444433") //This is dumb as hell and I don't give a fuck
			I.name = "[initial(I.name)] (burnt)"
			I.color = "#111111"
		else if(I.color == "#c27430") //You IDIOT, of COURSE it forces lowercase, what is WRONG with you
			I.name = "[initial(I.name)] (double toasted)"
			I.color = "#444433"
		else
			I.name = "[initial(I.name)] (toasted)"
			I.color = "#c27430"

		I.throwforce = I.throwforce + 2 //The corners are sharper ok
		I.forceMove(get_turf(src))


/obj/item/trash/f13/electronic/toaster/proc/is_toastable(obj/item/I)
	return is_type_in_typecache(I,toastables)


//Don't judge me
/obj/item/food/bagel
	name = "bagel"
	desc = "A rounded, dense, donut-like loop of bread. Perfect for toasting, as they're rather chewy untoasted."
	icon_state = "donut1"// need bagel sprite pfffffffffffffff
	bite_consumption = 3
	food_reagents = list(/datum/reagent/consumable/nutriment = 6, /datum/reagent/consumable/nutriment/vitamin = 2)
	tastes = list("bagelness" = 1)
	foodtypes = GRAIN
	throwforce = 10 //Bonk


/obj/item/trash/f13/electronic/toaster/atomics
	name = "pristine General Atomics toaster"
	desc = "An incredibly rare General Atomics nuclear-powered toaster. It can be used to make some excellent toast, or disassembled for parts. It has two slots for bread."
	icon_state = "toaster" //Can probably find a better one oh well
	toast_time = 3
	fork_damage = 20
	power_use = 0
	components = list(	/obj/item/stock_parts/capacitor/quadratic=1,
						/obj/item/stock_parts/matter_bin/bluespace=1,
						/obj/item/stock_parts/micro_laser/quadultra=1,
						/obj/item/stack/sheet/mineral/uranium=1
					)
	light_color = LIGHT_COLOR_GREEN
	light_power = 2
	outer_light_range = 3

/obj/item/trash/f13/electronic/toaster/oven
	name = "toaster oven"
	desc = "A large, unwieldy device meant to sit on a counter and slowly, painstakingly toast bread. It's clearly inferior to the double-slot models but it may be useful for toast heathens who prefer quantity over quality."
	icon_state = "toaster" //ToDO COME ON how is there no toaster oven sprite
	toast_slots = 4
	toast_time = 70
	power_use = 20
