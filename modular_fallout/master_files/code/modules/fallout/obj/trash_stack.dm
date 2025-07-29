/obj/item/storage/trash_stack
	name = "pile of garbage"
	desc = "a pile of garbage. Smells as good, as it looks, though it may contain something useful. Or may not"
	icon = 'modular_fallout/master_files/icons/fallout/objects/crafting.dmi'
	icon_state = "trash_1"
	anchored = TRUE
	density = FALSE
	var/list/loot_players = list()
	var/list/lootable_trash = list()
	var/list/garbage_list = list()

/obj/item/storage/trash_stack/proc/initialize_lootable_trash()
	garbage_list = list(GLOB.trash_ammo, GLOB.trash_chem, GLOB.trash_clothing, GLOB.trash_craft,
						GLOB.trash_gun, GLOB.trash_misc, GLOB.trash_money,
						GLOB.trash_part, GLOB.trash_tool)
	lootable_trash = list() //we are setting them to an empty list so you can't double the amount of stuff
	for(var/i in garbage_list)
		for(var/ii in i)
			lootable_trash += ii

/obj/item/storage/trash_stack/Initialize()
	. = ..()
	icon_state = "trash_[rand(1,3)]"
	GLOB.trash_piles += src
	initialize_lootable_trash()

/obj/item/storage/trash_stack/Destroy()
	GLOB.trash_piles -= src
	. = ..()

/obj/item/storage/trash_stack/attack_hand(mob/user)
	var/turf/ST = get_turf(src)
	if(user in loot_players)
		to_chat(user, "<span class='notice'>You already have looted [src].</span>")
		return
	for(var/i=0, i<rand(1,4), i++)
		var/itemtype= pick_weight(lootable_trash)
		//var/itemtypebonus= pick_weight(lootable_trash)
		if(itemtype)
			to_chat(user, "<span class='notice'>You scavenge through [src].</span>")
			var/obj/item/item = new itemtype(ST)
			//if (prob(10+(user.special_l*3.5)))//SPECIAL Integration
			//	to_chat(user, "<span class='notice'>You get lucky and find even more loot!</span>")
			//	var/obj/item/bonusitem = new itemtypebonus(ST)
			//	if(istype(bonusitem))
			//		bonusitem.from_trash = TRUE
			if(istype(item))
				item.from_trash = TRUE
	loot_players += user

/obj/item
	var/from_trash = FALSE

/datum/controller/subsystem/itemspawners/proc/restock_trash_piles()
	for(var/obj/item/storage/trash_stack/TS in GLOB.trash_piles)
		TS.loot_players.Cut() //This culls a list safely
		for(var/obj/item/A in TS.loc.contents)
			if(A.from_trash)
				qdel(A)

/obj/item/storage/money_stack
	name = "payroll safe"
	desc = "a payroll safe. Use it every hour to recieve your pay."
	icon = 'modular_fallout/master_files/icons/obj/structures.dmi'
	icon_state = "safe"
	anchored = TRUE
	density = TRUE
	var/list/paid_players = list()
	var/list/pay = list(/obj/item/stack/f13Cash/random/med)

/obj/item/storage/money_stack/ncr
	pay = list(/obj/item/stack/f13Cash/random/ncr/med)

/obj/item/storage/money_stack/legion
	pay = list(/obj/item/stack/f13Cash/random/denarius/med)

/obj/item/storage/money_stack/Initialize()
	. = ..()
	GLOB.money_piles += src

/obj/item/storage/money_stack/Destroy()
	GLOB.money_piles -= src
	. = ..()

/obj/item/storage/money_stack/attack_hand(mob/user)
	var/turf/ST = get_turf(src)
	if(user in paid_players)
		to_chat(user, "<span class='notice'>You have already taken your pay from the [src].</span>")
		return
	for(var/i=0, i<rand(1,2), i++)
		var/itemtype = pick(pay)
		if(itemtype)
			to_chat(user, "<span class='notice'>You get your pay from the [src].</span>")
			new itemtype(ST)
	paid_players += user
