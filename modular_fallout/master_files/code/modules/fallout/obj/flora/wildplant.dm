//Fallout 13 wild plants directory

/turf/open
	var/list/allowed_plants

/obj/structure/flora/wild_plant
	name = "wild plant"
	density = 0
	anchored = 1
	var/age
	var/health = 100
	var/harvest
	var/dead
	var/lastcycle
	var/cycledelay = 1200
	var/obj/item/seeds/myseed
	var/lastproduce

#warn ensure this works right!

/obj/structure/flora/wild_plant/Initialize(turf/turf,seed)
	if(!seed)
		return
	..(turf)
	myseed = new seed()
	if(!istype(myseed, /obj/item/seeds))
		qdel(myseed)
		return
	myseed.forceMove(src)
	name = myseed.plant_datum.name
	icon = myseed.plant_datum.growing_icon
	START_PROCESSING(SSobj, src)
	update_icon()

/obj/structure/flora/wild_plant/attackby(obj/item/O, mob/user, params)
	if(istype(O, /obj/item/shovel))
		user << "<span class='notice'>You clear up [src]!</span>"
		qdel(src)
		return
	return ..()

/obj/structure/flora/wild_plant/attack_hand(mob/user)
	if(!iscarbon(user))
		return
	if(harvest)
		if(myseed.plant_datum.base_harvest_yield(user))
			harvest = 0
			update_icon()
	else if(dead)
		dead = 0
		to_chat(user, "<span class='notice'>You remove the dead plant.</span>")
		qdel(myseed)
		qdel(src)
	else
		to_chat(user, "<span class='notice'>You touched the plant... Are you happy now?</span>") // Does this make you happy, Stanley?

/obj/structure/flora/wild_plant/examine(user)
	if(myseed)
		to_chat(user, "<span class='info'>It has <span class='name'>[myseed.plant_datum.name]</span> planted.</span>")
		if (dead)
			to_chat(user, "<span class='warning'>It's dead!</span>")
		else if (harvest)
			to_chat(user, "<span class='info'>It's ready to harvest.</span>")
		else if (health <= (myseed.plant_datum.base_endurance / 2))
			to_chat(user, "<span class='warning'>It looks unhealthy.</span>")

/obj/structure/flora/wild_plant/proc/plantdies()
	health = 0
	harvest = 0
	if(!dead)
		update_icon()
		dead = 1
		spawn(3000)
			qdel(src)

/obj/structure/flora/wild_plant/process()

	if(!myseed)
		qdel(src)
		return
	var/needs_update = 0

	if(myseed.loc != src)
		myseed.forceMove(src)

	if(world.time > (lastcycle + cycledelay))
		lastcycle = world.time
		if(!dead)
			age++
			needs_update = 1

			if(health <= 0)
				plantdies()

			if(age > myseed.plant_datum.base_lifespan)
				health -= 50 / myseed.plant_datum.base_endurance

			// Harvest code
			if(age > myseed.plant_datum.base_production && (age - lastproduce) > myseed.plant_datum.base_production && (!harvest && !dead))
				if(myseed && myseed.plant_datum.base_harvest_yield != -1) // Unharvestable shouldn't be harvested
					harvest = 1
				else
					lastproduce = age
	if (needs_update)
		update_icon()
	return

/obj/structure/flora/wild_plant/update_icon()
	if(dead)
		icon_state = icon_state = myseed.plant_datum.icon_dead
	else if(harvest)
		if(!myseed.plant_datum.icon_harvest)
			icon_state = "[myseed.plant_datum.icon_grow][myseed.plant_datum.growthstages]"
		else
			icon_state = myseed.plant_datum.icon_harvest
	else
		var/t_growthstate = min(max(round((age / myseed.plant_datum.base_maturation) * myseed.plant_datum.growthstages), 1), myseed.plant_datum.growthstages)
		icon_state = "[myseed.plant_datum.icon_grow][t_growthstate]"
	if(myseed && myseed.plant_datum.get_gene(/datum/plant_gene/trait/glow))
		var/datum/plant_gene/trait/glow/G = myseed.plant_datum.get_gene(/datum/plant_gene/product_trait/glow)
		set_light(G.glow_color)
	else
		set_light(0)

#warn mayb add glow range and glow light to glow trait later

https://discord.gg/RYnQZvxrmH
https://discord.gg/RYnQZvxrmH
