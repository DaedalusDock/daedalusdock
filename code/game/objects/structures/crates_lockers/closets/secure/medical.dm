/obj/structure/closet/secure_closet/medical1
	name = "medicine closet"
	desc = "Filled to the brim with medical junk."
	icon_state = "med"
	req_access = list(ACCESS_MEDICAL)

/obj/structure/closet/secure_closet/medical1/PopulateContents()
	..()
	var/static/items_inside = list(
		/obj/item/reagent_containers/cup/beaker = 2,
		/obj/item/reagent_containers/dropper = 2,
		/obj/item/storage/belt/medical = 1,
		/obj/item/storage/box/syringes = 1,
		/obj/item/reagent_containers/cup/bottle/toxin = 1,
		/obj/item/reagent_containers/cup/bottle/morphine = 2,
		/obj/item/reagent_containers/cup/bottle/epinephrine= 3,
		/obj/item/reagent_containers/cup/bottle/dylovene = 3,
		/obj/item/storage/box/rxglasses = 1)
	generate_items_inside(items_inside,src)

/obj/structure/closet/secure_closet/medical2
	name = "anesthetic closet"
	desc = "Used to knock people out."
	req_access = list(ACCESS_MEDICAL)

/obj/structure/closet/secure_closet/medical2/PopulateContents()
	..()
	for(var/i in 1 to 3)
		new /obj/item/tank/internals/anesthetic(src)
	for(var/i in 1 to 3)
		new /obj/item/clothing/mask/muzzle/breath(src)

/obj/structure/closet/secure_closet/medical3
	name = "'s locker"
	req_access = list(ACCESS_MEDICAL)
	icon_state = "med_secure"

/obj/structure/closet/secure_closet/medical3/PopulateContents()
	..()
	new /obj/item/radio/headset/headset_med(src)
	new /obj/item/defibrillator/loaded(src)
	new /obj/item/clothing/gloves/color/latex/nitrile(src)
	new /obj/item/storage/belt/medical(src)
	new /obj/item/clothing/glasses/hud/health(src)
	return

/obj/structure/closet/secure_closet/psychology
	name = "psychology locker"
	req_access = list(ACCESS_MEDICAL)
	icon_state = "cabinet"
	open_sound = 'sound/machines/wooden_closet_open.ogg'
	close_sound = 'sound/machines/wooden_closet_close.ogg'
	open_sound_volume = 25
	close_sound_volume = 50

/obj/structure/closet/secure_closet/psychology/PopulateContents()
	..()
	new /obj/item/clothing/under/suit/black(src)
	new /obj/item/clothing/under/suit/black/skirt(src)
	new /obj/item/clothing/shoes/laceup(src)
	new /obj/item/storage/backpack/medic(src)
	new /obj/item/clipboard(src)
	new /obj/item/clothing/suit/straight_jacket(src)
	new /obj/item/clothing/ears/earmuffs(src)
	new /obj/item/clothing/mask/muzzle(src)
	new /obj/item/clothing/glasses/blindfold(src)

/obj/structure/closet/secure_closet/chief_medical
	name = "\proper medical director's locker"
	req_access = list(ACCESS_CMO)
	icon_state = "cmo"

/obj/structure/closet/secure_closet/chief_medical/PopulateContents()
	..()

	new /obj/item/clothing/suit/bio_suit/cmo(src)
	new /obj/item/clothing/head/bio_hood/cmo(src)
	new /obj/item/storage/bag/garment/chief_medical(src)
	new /obj/item/computer_hardware/hard_drive/role/cmo(src)
	new /obj/item/radio/headset/heads/cmo(src)
	new /obj/item/megaphone/command(src)
	new /obj/item/defibrillator/compact/loaded(src)
	new /obj/item/assembly/flash/handheld(src)
	new /obj/item/reagent_containers/hypospray/cmo(src)
	new /obj/item/wallframe/defib_mount(src)
	new /obj/item/circuitboard/machine/fabricator/department/medical(src)
	new /obj/item/storage/photo_album/cmo(src)
	new /obj/item/storage/lockbox/medal/med(src)
	new /obj/item/gun/ballistic/rifle/tranqrifle(src)
	new /obj/item/ammo_box/magazine/tranq_rifle/ryetalyn(src)
	new /obj/item/ammo_box/magazine/tranq_rifle/ryetalyn(src)

/obj/structure/closet/secure_closet/animal
	name = "animal control"
	req_access = list(ACCESS_MEDICAL)

/obj/structure/closet/secure_closet/animal/PopulateContents()
	..()
	new /obj/item/assembly/signaler(src)
	for(var/i in 1 to 3)
		new /obj/item/electropack(src)

/obj/structure/closet/secure_closet/chemical
	name = "chemical closet"
	desc = "Store dangerous chemicals in here."
	req_access = list(ACCESS_PHARMACY)
	icon_door = "chemical"

/obj/structure/closet/secure_closet/chemical/PopulateContents()
	..()
	new /obj/item/storage/box/pillbottles(src)
	new /obj/item/storage/box/pillbottles(src)
	new /obj/item/storage/box/medigels(src)
	new /obj/item/storage/box/medigels(src)
	new /obj/item/reagent_containers/dropper(src)

/obj/structure/closet/secure_closet/chemical/heisenberg //contains one of each beaker, syringe etc.
	name = "advanced chemical closet"
	req_access = list(ACCESS_PHARMACY)

/obj/structure/closet/secure_closet/chemical/heisenberg/PopulateContents()
	..()
	new /obj/item/reagent_containers/dropper(src)
	new /obj/item/reagent_containers/dropper(src)
	new /obj/item/storage/box/syringes/variety(src)
	new /obj/item/storage/box/beakers/variety(src)
	new /obj/item/clothing/glasses/science(src)

/obj/structure/closet/secure_closet/chemical/cartridge
	name = "cartridge closet"
	desc = "Store dangerous chemical cartridges in here."
	req_access = list(ACCESS_PHARMACY)
	icon_door = "chemical"

/obj/structure/closet/secure_closet/chemical/cartridge/PopulateContents()
	var/list/spawn_cartridges = GLOB.cartridge_list_chems

	for(var/datum/reagent/chem_type as anything in spawn_cartridges)
		var/obj/item/reagent_containers/chem_cartridge/chem_cartridge = spawn_cartridges[chem_type]
		chem_cartridge = new chem_cartridge(src)
		chem_cartridge.reagents.add_reagent(chem_type, chem_cartridge.volume)
		chem_cartridge.setLabel(initial(chem_type.name))
