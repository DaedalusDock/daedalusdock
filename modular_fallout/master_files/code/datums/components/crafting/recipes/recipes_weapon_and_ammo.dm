/datum/crafting_recipe/twohanded/spear
	name = "Spear"
	result = /obj/item/twohanded/spear
	reqs = list(/obj/item/restraints/handcuffs/cable = 1,
				/obj/item/melee/onehanded/knife = 1,
				/obj/item/stack/rods = 1,
				/obj/item/stack/crafting/goodparts = 2)
	time = 60
	category = CAT_WEAPONRY
	subcategory = CAT_MELEE

/datum/crafting_recipe/melee/scrapspear
	name = "Scrap Spear"
	result = /obj/item/twohanded/spear/scrapspear
	reqs = list(/obj/item/crafting/duct_tape = 1,
				/obj/item/stack/rods = 2,
				/obj/item/shard = 1)
	time = 40
	category = CAT_WEAPONRY
	subcategory = CAT_MELEE

/datum/crafting_recipe/scrapshield
	name = "Scrap Shield"
	result = /obj/item/shield/riot/scrapshield
	reqs = list(/obj/item/stack/cable_coil = 30,
				/obj/item/stack/sheet/iron = 10,
				/obj/item/crafting/wonderglue = 1)
	tool_behaviors = list(TOOL_WELDER)
	time = 100
	category = CAT_WEAPONRY
	subcategory = CAT_MELEE

/datum/crafting_recipe/buckler
	name = "Wooden Buckler"
	result = /obj/item/shield/riot/buckler
	reqs = list(/obj/item/stack/sheet/mineral/wood = 15,
				/obj/item/stack/sheet/leather = 1)
	tool_behaviors = list(TOOL_SCREWDRIVER)
	time = 40
	category = CAT_WEAPONRY
	subcategory = CAT_MELEE

/datum/crafting_recipe/melee/improvisedbayonet
	name = "Improvised bayonet"
	result = /obj/item/melee/onehanded/knife/bayonet
	time = 300
	reqs = list(/obj/item/melee/onehanded/knife/hunting = 1,
				/obj/item/crafting/duct_tape = 1)
	category = CAT_WEAPONRY
	subcategory = CAT_MELEE

/datum/crafting_recipe/bola
	name = "Bola"
	result = /obj/item/restraints/legcuffs/bola
	reqs = list(/obj/item/restraints/handcuffs/cable = 1,
				/obj/item/stack/sheet/iron = 6)
	time = 20//15 faster than crafting them by hand!
	category= CAT_WEAPONRY
	subcategory = CAT_WEAPON

//////////////////
///BOMB CRAFTING//
//////////////////

/datum/crafting_recipe/compressedpowder
	name = "Compressed Gunpowder"
	result = /obj/item/stack/ore/blackpowder
	time = 5
	reqs = list(/datum/reagent/blackpowder = 50)
	category = CAT_WEAPONRY
	subcategory = CAT_AMMO

/datum/crafting_recipe/chemical_payload
	name = "Chemical Payload (C4)"
	result = /obj/item/bombcore/chemical
	reqs = list(
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/grenade/c4 = 1,
		/obj/item/grenade/chem_grenade = 2
	)
	parts = list(/obj/item/stock_parts/matter_bin = 1, /obj/item/grenade/chem_grenade = 2)
	time = 30
	category = CAT_WEAPONRY
	subcategory = CAT_AMMO

/datum/crafting_recipe/explosive/molotov
	name = "Molotov Cocktail"
	result = /obj/item/reagent_containers/cup/glass/bottle/molotov
	reqs = list(/obj/item/reagent_containers/cup/rag = 1,
		/obj/item/reagent_containers/cup/glass/bottle = 1,
		)
	time = 2 SECONDS
	category = CAT_WEAPONRY
	subcategory = CAT_AMMO

/datum/crafting_recipe/explosive/firebomb
	name = "Firebomb"
	result = /obj/item/grenade/homemade/firebomb
	reqs = list(/datum/reagent/fuel = 50,
				/obj/item/stack/cable_coil = 1,
				/obj/item/assembly/igniter = 1,
				/obj/item/reagent_containers/food/drinks/flask = 1)
	time = 30
	category = CAT_WEAPONRY
	subcategory = CAT_AMMO

/datum/crafting_recipe/explosive/coffeepotbomb
	name = "Coffeepot Bomb"
	result = /obj/item/grenade/homemade/coffeepotbomb
	reqs = list(/datum/reagent/blackpowder = 50,
				/obj/item/crafting/coffee_pot = 1,
				/obj/item/stack/cable_coil = 1,
				/obj/item/crafting/timer = 1,)
	time = 30
	category = CAT_WEAPONRY
	subcategory = CAT_AMMO

/datum/crafting_recipe/shrapnelmine
	name = "Shrapnel Mine (WARNING: MINE PLACED IMMEDIATLY)"
	result = /obj/effect/mine/shrapnel
	reqs = list(/obj/item/grenade/homemade/firebomb = 1,
				/obj/item/stack/tile = 1,
				/obj/item/ammo_casing/a22 = 5
				)
	time = 15
	category = CAT_WEAPONRY
	subcategory = CAT_AMMO

/datum/crafting_recipe/lance
	name = "Explosive Spear (Grenade)"
	result = /obj/item/twohanded/spear
	reqs = list(/obj/item/twohanded/spear = 1,
				/obj/item/grenade = 1)
	parts = list(/obj/item/twohanded/spear = 1,
				/obj/item/grenade = 1)
	time = 15
	category = CAT_WEAPONRY
	subcategory = CAT_AMMO

/////////////////////////
///POWER CELL RECYCLING//
/////////////////////////

/datum/crafting_recipe/ecrecharge
	name = "Small Energy Cell (recycle)"
	result = /obj/item/stock_parts/cell/ammo/ec
	reqs = list(/obj/item/stock_parts/cell/ammo/ec=2)
	tool_behaviors = list(TOOL_WORKBENCH)
	time = 10
	category = CAT_WEAPONRY
	subcategory = CAT_AMMO

/datum/crafting_recipe/mfcrecharge
	name = "Microfusion Cell (recycle)"
	result = /obj/item/stock_parts/cell/ammo/mfc
	reqs = list(/obj/item/stock_parts/cell/ammo/mfc=2)
	tool_behaviors = list(TOOL_WORKBENCH)
	time = 10
	category = CAT_WEAPONRY
	subcategory = CAT_AMMO

/datum/crafting_recipe/ecprecharge
	name = "Electron Charge Pack (recycle)"
	result = /obj/item/stock_parts/cell/ammo/ecp
	reqs = list(/obj/item/stock_parts/cell/ammo/ecp=2)
	tool_behaviors = list(TOOL_WORKBENCH)
	time = 10
	category = CAT_WEAPONRY
	subcategory = CAT_AMMO

/datum/crafting_recipe/batteryboxplasma //plasmamusket ammo
	name = "Plasma Can"
	result = /obj/item/ammo_box/plasmamusket
	reqs = list(/obj/item/stack/crafting/electronicparts = 2,
				/obj/item/stack/sheet/glass = 3,
				/obj/item/stack/sheet/iron = 3)
	tool_behaviors = list(TOOL_WORKBENCH, TOOL_MULTITOOL)
	time = 20
	category = CAT_WEAPONRY
	subcategory = CAT_AMMO

/datum/crafting_recipe/batterybox //lasmusket ammo
	name = "Laser Musket battery pack"
	result = /obj/item/ammo_box/lasmusket
	reqs = list(/obj/item/stack/crafting/electronicparts = 1,
				/obj/item/stack/sheet/glass = 2,
				/obj/item/stack/sheet/iron = 2)
	tool_behaviors = list(TOOL_WORKBENCH, TOOL_MULTITOOL)
	time = 20
	category = CAT_WEAPONRY
	subcategory = CAT_AMMO

/datum/crafting_recipe/flamerfuel
	name = "Flamethrower Fuel"
	result = /obj/item/ammo_box/jerrycan
	reqs = list(/datum/reagent/napalm = 50,
				/obj/item/reagent_containers/glass/beaker/large)
	tool_behaviors = list(TOOL_WORKBENCH)
	time = 30
	category = CAT_WEAPONRY
	subcategory = CAT_AMMO



/////////////////
///GUN CRAFTING//
/////////////////

//Hobo Guns
/datum/crafting_recipe/gun/zipgun
	name = "Zip gun (9mm)"
	result = /obj/item/gun/ballistic/automatic/hobo/zipgun
	reqs = list(/obj/item/stack/sheet/mineral/wood = 1,
				/obj/item/crafting/wonderglue = 1,
				/obj/item/stack/rods = 1,
				/obj/item/ammo_casing/c9mm = 5,
				/obj/item/stack/crafting/metalparts = 1)
	tool_behaviors = list(TOOL_WORKBENCH)
	time = 120
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/gun/pepperbox
	name = "Pepperbox gun (10mm)"
	result = /obj/item/gun/ballistic/revolver/hobo/pepperbox
	reqs = list(/obj/item/stack/sheet/mineral/wood = 2,
				/obj/item/stack/crafting/metalparts = 1,
				/obj/item/ammo_casing/c10mm = 4,
				/obj/item/stack/rods = 4)
	tool_behaviors = list(TOOL_WORKBENCH)
	time = 120
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/gun/piperifle
	name = "Piperifle (.223)"
	result = /obj/item/gun/ballistic/revolver/hobo/piperifle
	reqs = list(/obj/item/stack/sheet/mineral/wood = 2,
				/obj/item/stack/crafting/metalparts = 1,
				/obj/item/stack/rods = 1)
	tool_behaviors = list(TOOL_WORKBENCH)
	time = 120
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/gun/autopiperifle
	name = "Auto-pipe rifle (.357)"
	result = /obj/item/gun/ballistic/automatic/autopipe
	reqs = list(/obj/item/ammo_casing/a357 = 30,
	/obj/item/stack/crafting/metalparts = 2,
	/obj/item/crafting/duct_tape = 1,
	/obj/item/stack/sheet/cloth = 1,
	/obj/item/stack/sheet/mineral/wood = 2)
	tool_behaviors = list(TOOL_WORKBENCH)
	time = 120
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/gun/shotgunbat
	name = "Shotgun bat"
	result = /obj/item/gun/ballistic/revolver/single_shotgun
	reqs = list(/obj/item/screwdriver = 1,
	/obj/item/twohanded/baseball = 1,
	/obj/item/stack/crafting/metalparts = 2,
	/obj/item/ammo_casing/shotgun = 1,
	/obj/item/stack/rods = 1)
	tool_behaviors = list(TOOL_WORKBENCH)
	time = 120
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/gun/winchesterrebored
	name = "Winchester rebored (.308)"
	result = /obj/item/gun/ballistic/revolver/winchesterrebored
	reqs = list(/obj/item/gun/ballistic/revolver/widowmaker = 1,
				/obj/item/stack/rods = 2)
	tool_behaviors = list(TOOL_WORKBENCH, TOOL_DRILL)
	time = 120
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/m29snub
	name = "snubnose .44 magnum revolver"
	result = /obj/item/gun/ballistic/revolver/m29/snub
	reqs = list(
		/obj/item/gun/ballistic/revolver/m29 = 1,
		/obj/item/stack/crafting/goodparts = 1,
		)
	tool_behaviors = list(TOOL_WORKBENCH, TOOL_SAW, TOOL_SCREWDRIVER)
	time = 120
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/gun/plasmamusket
	name = "Plasma musket"
	result = /obj/item/gun/ballistic/rifle/hobo/plasmacaster
	reqs = list(/obj/item/gun/ballistic/rifle/hobo/lasmusket = 1,
				/obj/item/stack/crafting/electronicparts = 2,
				/obj/item/advanced_crafting_components/conductors = 1)
	tool_behaviors = list(TOOL_WORKBENCH, TOOL_MULTITOOL)
	time = 120
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/gun/lasmusket
	name = "Laser musket"
	result = /obj/item/gun/ballistic/rifle/hobo/lasmusket
	reqs = list(/obj/item/trash/f13/electronic/toaster = 1,
				/obj/item/gun/ballistic/revolver/hobo/piperifle = 1,
				/obj/item/reagent_containers/food/drinks/bottle = 1,
				/obj/item/stack/cable_coil = 3)
	tool_behaviors = list(TOOL_WORKBENCH, TOOL_MULTITOOL)
	time = 120
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON


//browning hi-power
/datum/crafting_recipe/ninemil
	name = "9mm Pistol"
	result = /obj/item/gun/ballistic/automatic/pistol/ninemil
	reqs = list(/obj/item/stack/sheet/mineral/wood = 1,
				/obj/item/stack/crafting/metalparts = 1,
				/obj/item/stack/sheet/iron = 2)
	tool_behaviors = list(TOOL_WORKBENCH)
	time = 120
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON
	always_availible = FALSE

//colt 6520
/datum/crafting_recipe/colt6520
	name = "Colt 6520 Revolver"
	result = /obj/item/gun/ballistic/revolver/colt6520
	reqs = list(/obj/item/stack/sheet/mineral/wood = 1,
				/obj/item/stack/crafting/metalparts = 5,
				/datum/reagent/blackpowder = 10,
				/obj/item/stack/sheet/iron = 1)
	tool_behaviors = list(TOOL_WORKBENCH)
	time = 120
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON
	always_availible = FALSE

//m1911
/datum/crafting_recipe/m1911
	name = "M1911"
	result = /obj/item/gun/ballistic/automatic/pistol/m1911
	reqs = list(/obj/item/stack/sheet/mineral/wood = 1,
				/obj/item/stack/crafting/metalparts = 2,
				/obj/item/stack/sheet/iron = 1)
	tool_behaviors = list(TOOL_WORKBENCH)
	time = 120
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON
	always_availible = FALSE

//n99
/datum/crafting_recipe/n99
	name = "10mm Pistol"
	result = /obj/item/gun/ballistic/automatic/pistol/n99
	reqs = list(/obj/item/stack/sheet/mineral/wood = 1,
				/obj/item/stack/crafting/metalparts = 3,
				/obj/item/stack/sheet/iron = 1,)
	tool_behaviors = list(TOOL_WORKBENCH)
	time = 120
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON
	always_availible = FALSE

//hunting rifle
/datum/crafting_recipe/huntingrifle
	name = "Hunting Rifle"
	result = /obj/item/gun/ballistic/rifle/hunting
	reqs = list(/obj/item/stack/sheet/mineral/wood = 1,
				/obj/item/stack/crafting/metalparts = 4,
				/obj/item/stack/sheet/iron = 3,)
	tool_behaviors = list(TOOL_WORKBENCH)
	time = 120
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON
	always_availible = FALSE

//battle rifle
/datum/crafting_recipe/m1garand
	name = "M1 Garand"
	result = /obj/item/gun/ballistic/automatic/m1garand
	reqs = list(/obj/item/stack/sheet/mineral/wood = 1,
				/obj/item/stack/crafting/metalparts = 2,
				/obj/item/advanced_crafting_components/assembly = 1,
				/obj/item/advanced_crafting_components/receiver = 1,
				/obj/item/stack/crafting/goodparts = 2,
				/obj/item/stack/sheet/iron = 1)
	tool_behaviors = list(TOOL_WORKBENCH)
	time = 120
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON
	always_availible = FALSE

//varmint rifle
/datum/crafting_recipe/varmintrifle
	name = "Varmint Rifle"
	result = /obj/item/gun/ballistic/automatic/varmint
	reqs = list(/obj/item/stack/sheet/mineral/wood = 1,
				/obj/item/stack/crafting/metalparts = 4,
				/obj/item/stack/sheet/iron = 1)
	tool_behaviors = list(TOOL_WORKBENCH)
	time = 120
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON
	always_availible = FALSE



//rangemaster
/datum/crafting_recipe/rangemaster
	name = "Colt Rangemaster"
	result = /obj/item/gun/ballistic/automatic/rangemaster
	reqs = list(/obj/item/stack/sheet/mineral/wood = 1,
				/obj/item/stack/crafting/metalparts = 4,
				/obj/item/advanced_crafting_components/receiver = 1,
				/obj/item/advanced_crafting_components/alloys = 1,
				/obj/item/advanced_crafting_components/assembly = 1,
				/obj/item/stack/crafting/goodparts = 5,
				/obj/item/stack/sheet/iron = 3)
	tool_behaviors = list(TOOL_WORKBENCH)
	time = 120
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON
	always_availible = FALSE

//r91
/datum/crafting_recipe/r91
	name = "R91 Assault Rifle"
	result = /obj/item/gun/ballistic/automatic/assault_rifle
	reqs = list(/obj/item/stack/sheet/mineral/wood = 1,
				/obj/item/stack/crafting/metalparts = 1,
				/obj/item/stack/sheet/iron = 4,
				/obj/item/advanced_crafting_components/assembly = 1,
				/obj/item/advanced_crafting_components/receiver = 1,
				/obj/item/stack/crafting/goodparts = 1,
				/obj/item/stack/sheet/mineral/titanium = 2)
	tool_behaviors = list(TOOL_WORKBENCH)
	time = 120
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON
	always_availible = FALSE

/datum/crafting_recipe/pps
	name = "Ppsh-41"
	result = /obj/item/gun/ballistic/automatic/smg/ppsh
	reqs = list(/obj/item/stack/sheet/iron = 5,
				/obj/item/advanced_crafting_components/receiver = 1,
				/obj/item/stack/crafting/metalparts = 2
				)
	tool_behaviors = list(TOOL_AWORKBENCH)
	time = 120
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON
	always_availible = FALSE

/datum/crafting_recipe/commando
	name = "DeLisle Commando Carbine"
	result = /obj/item/gun/ballistic/automatic/delisle/commando
	reqs = list(/obj/item/stack/sheet/iron = 5,
				/obj/item/advanced_crafting_components/receiver = 1,
				/obj/item/stack/crafting/metalparts = 2
				)
	tool_behaviors = list(TOOL_WORKBENCH)
	time = 120
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON
	always_availible = FALSE

//infiltrator
/datum/crafting_recipe/infiltrator
	name = "Infiltrator Carbine"
	result = /obj/item/gun/ballistic/automatic/assault_rifle/infiltrator
	reqs = list(/obj/item/gun/ballistic/automatic/assault_rifle = 1,
				/obj/item/stack/sheet/glass = 2,
				/obj/item/stack/crafting/goodparts = 1,
				/obj/item/suppressor = 1,
				/obj/item/stack/sheet/plastic = 3,
	)
	tool_behaviors = list(TOOL_AWORKBENCH)
	time = 120
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON
	always_availible = FALSE

//hunting shotgun
/datum/crafting_recipe/huntingshotgun
	name = "Hunting Shotgun"
	result = /obj/item/gun/ballistic/shotgun/hunting
	reqs = list(/obj/item/stack/sheet/mineral/wood = 1,
				/obj/item/stack/crafting/metalparts = 3,
				/obj/item/stack/sheet/iron = 3,
	)
	tool_behaviors = list(TOOL_WORKBENCH)
	time = 120
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON
	always_availible = FALSE

//marksman carbine
/datum/crafting_recipe/marksmancarbine
	name = "Marksman Carbine"
	result = /obj/item/gun/ballistic/automatic/marksman
	reqs = list(/obj/item/stack/sheet/iron = 10,
				/obj/item/advanced_crafting_components/assembly = 1,
				/obj/item/stack/crafting/goodparts = 3
				)
	tool_behaviors = list(TOOL_WORKBENCH)
	time = 120
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON
	always_availible = FALSE

//r84 lmg
/datum/crafting_recipe/lmg
	name = "R84 LMG"
	result = /obj/item/gun/ballistic/automatic/r84
	reqs = list(/obj/item/stack/sheet/iron = 5,
				/obj/item/advanced_crafting_components/assembly = 1,
				/obj/item/advanced_crafting_components/alloys = 1,
				/obj/item/stack/crafting/goodparts = 5
				)
	tool_behaviors = list(TOOL_WORKBENCH)
	time = 120
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON
	always_availible = FALSE

//lsw lmg
/datum/crafting_recipe/gun/lsw
	name = "LSW LMG"
	result = /obj/item/gun/ballistic/automatic/lsw
	reqs = list(/obj/item/stack/sheet/iron = 5,
				/obj/item/advanced_crafting_components/assembly = 1,
				/obj/item/advanced_crafting_components/alloys = 1,
				/obj/item/stack/crafting/goodparts = 5,
				/obj/item/attachments/scope = 1
				)
	tool_behaviors = list(TOOL_WORKBENCH)
	time = 120
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON
	always_availible = FALSE


//service rifle
/datum/crafting_recipe/servicerifle
	name = "Service Rifle 5.56mm"
	result = /obj/item/gun/ballistic/automatic/service
	reqs = list(/obj/item/stack/sheet/iron = 10,
				/obj/item/stack/crafting/metalparts = 10,
				/obj/item/stack/sheet/mineral/wood = 5,
				/obj/item/stack/crafting/goodparts = 5
				)
	tool_behaviors = list(TOOL_WORKBENCH)
	time = 120
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON
	always_availible = FALSE

//scout carbine
/datum/crafting_recipe/scoutcarbine
	name = "Scout Carbine"
	result = /obj/item/gun/ballistic/automatic/service/carbine
	reqs = list(/obj/item/stack/sheet/iron = 5,
				/obj/item/stack/crafting/metalparts = 10,
				/obj/item/stack/sheet/mineral/wood = 5,
				/obj/item/stack/crafting/goodparts = 5
				)
	tool_behaviors = list(TOOL_WORKBENCH)
	time = 120
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON
	always_availible = FALSE

/datum/crafting_recipe/gaussrifle
	name = "M72 Gauss Rifle"
	result = /obj/item/gun/ballistic/automatic/m72
	reqs = list(/obj/item/stack/sheet/iron = 15,
				/obj/item/advanced_crafting_components/flux = 1,
				/obj/item/advanced_crafting_components/conductors = 2,
				/obj/item/advanced_crafting_components/alloys = 2,
				/obj/item/advanced_crafting_components/assembly = 1,
				/obj/item/advanced_crafting_components/receiver = 1,
				/obj/item/stack/crafting/metalparts = 5,
				/obj/item/stack/crafting/electronicparts = 15
				)
	tool_behaviors = list(TOOL_AWORKBENCH)
	time = 120
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON
	always_availible = FALSE

/datum/crafting_recipe/neostead
	name = "Neostead 2000"
	result = /obj/item/gun/ballistic/shotgun/automatic/combat/neostead
	reqs = list(/obj/item/stack/sheet/iron = 10,
				/obj/item/advanced_crafting_components/assembly = 1,
				/obj/item/advanced_crafting_components/alloys = 1,
				/obj/item/advanced_crafting_components/receiver = 1,
				/obj/item/stack/crafting/goodparts = 15,
				)
	tool_behaviors = list(TOOL_AWORKBENCH)
	time = 120
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON
	always_availible = FALSE


//aep7
/datum/crafting_recipe/AEP7
	name = "AEP-7"
	result = /obj/item/gun/energy/laser/pistol
	reqs = list(/obj/item/stack/sheet/iron = 5,
				/obj/item/advanced_crafting_components/lenses = 1,
				/obj/item/stack/crafting/metalparts = 3,
				/obj/item/stack/crafting/electronicparts = 3
				)
	tool_behaviors = list(TOOL_WORKBENCH)
	time = 120
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON
	always_availible = FALSE

//lever action shotgun
/datum/crafting_recipe/lever_action
	name = "Lever Action Shotgun"
	result = /obj/item/gun/ballistic/shotgun/automatic/combat/shotgunlever
	reqs = list(/obj/item/stack/sheet/iron = 5,
				/obj/item/advanced_crafting_components/receiver = 1,
				/obj/item/stack/crafting/metalparts = 3,
	)
	tool_behaviors = list(TOOL_WORKBENCH)
	time = 120
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON
	always_availible = FALSE

//trail carbine
/datum/crafting_recipe/trail_carbine
	name = "Trail Carbine"
	result = /obj/item/gun/ballistic/rifle/repeater/trail
	reqs = list(/obj/item/stack/sheet/iron = 5,
				/obj/item/advanced_crafting_components/receiver = 1,
				/obj/item/stack/crafting/metalparts = 3,
	)
	tool_behaviors = list(TOOL_WORKBENCH)
	time = 120
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON
	always_availible = FALSE

//.223 pistol
/datum/crafting_recipe/thatgun
	name = ".223 Pistol"
	result = /obj/item/gun/ballistic/revolver/thatgun
	reqs = list(/obj/item/stack/crafting/metalparts = 2,
				/obj/item/stack/sheet/iron = 3,)
	tool_behaviors = list(TOOL_WORKBENCH)
	time = 120
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON
	always_availible = FALSE

//plasma pistol
/datum/crafting_recipe/plasmapistol
	name = "Plasma Pistol"
	result = /obj/item/gun/energy/laser/plasma/pistol
	reqs = list(/obj/item/stack/sheet/iron = 5,
				/obj/item/advanced_crafting_components/flux = 1,
				/obj/item/stack/crafting/metalparts = 3,
				/obj/item/stack/crafting/electronicparts = 3
				)
	tool_behaviors = list(TOOL_WORKBENCH)
	time = 120
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON
	always_availible = FALSE

//uzi
/datum/crafting_recipe/uzi
	name = "Uzi SMG"
	result = /obj/item/gun/ballistic/automatic/smg/mini_uzi
	reqs = list(/obj/item/stack/sheet/iron = 10,
				/obj/item/advanced_crafting_components/receiver = 1
				)
	tool_behaviors = list(TOOL_WORKBENCH)
	time = 120
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON
	always_availible = FALSE

//10mm smg
/datum/crafting_recipe/smg10mm
	name = "10mm SMG"
	result = /obj/item/gun/ballistic/automatic/smg/smg10mm
	reqs = list(/obj/item/stack/sheet/iron = 10,
				/obj/item/advanced_crafting_components/receiver = 1
				)
	tool_behaviors = list(TOOL_WORKBENCH)
	time = 120
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON
	always_availible = FALSE

//grease gun
/datum/crafting_recipe/grease_gun
	name = "Grease Gun"
	result = /obj/item/gun/ballistic/automatic/smg/greasegun
	reqs = list(/obj/item/stack/sheet/iron = 10,
				/obj/item/advanced_crafting_components/receiver = 1,
				)
	tool_behaviors = list(TOOL_WORKBENCH)
	time = 120
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON
	always_availible = FALSE

//brush gun
/datum/crafting_recipe/brush
	name = "Brush Gun"
	result = /obj/item/gun/ballistic/rifle/repeater/brush
	reqs = list(/obj/item/stack/sheet/iron = 10,
				/obj/item/advanced_crafting_components/assembly = 1,
				/obj/item/advanced_crafting_components/receiver = 1,
				/obj/item/stack/crafting/goodparts = 3,
	)
	tool_behaviors = list(TOOL_WORKBENCH)
	time = 120
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON
	always_availible = FALSE

//r91
/datum/crafting_recipe/r91
	name = "R91 Assault Rifle"
	result = /obj/item/gun/ballistic/automatic/assault_rifle
	reqs = list(/obj/item/stack/sheet/iron = 5,
				/obj/item/advanced_crafting_components/assembly = 1,
				/obj/item/advanced_crafting_components/receiver = 1,
				/obj/item/stack/sheet/mineral/wood = 5,
				/obj/item/stack/crafting/goodparts = 5
				)
	tool_behaviors = list(TOOL_WORKBENCH)
	time = 120
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON
	always_availible = FALSE

//Riot shotgun
/datum/crafting_recipe/riotshotgun
	name = "Riot Shotgun"
	result = /obj/item/gun/ballistic/automatic/shotgun/riot
	reqs = list(/obj/item/stack/sheet/iron = 5,
				/obj/item/advanced_crafting_components/alloys = 1,
				/obj/item/advanced_crafting_components/receiver = 1,
				/obj/item/stack/sheet/mineral/wood = 5,
				/obj/item/stack/crafting/goodparts = 5
				)
	tool_behaviors = list(TOOL_WORKBENCH)
	time = 120
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON
	always_availible = FALSE

//sniper
/datum/crafting_recipe/sniper
	name = "Sniper Rifle"
	result = /obj/item/gun/ballistic/automatic/marksman/sniper
	reqs = list(/obj/item/stack/sheet/iron = 5,
				/obj/item/advanced_crafting_components/assembly = 1,
				/obj/item/advanced_crafting_components/alloys = 1,
				/obj/item/stack/sheet/mineral/wood = 5,
				/obj/item/stack/crafting/goodparts = 5
				)
	tool_behaviors = list(TOOL_WORKBENCH)
	time = 120
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON
	always_availible = FALSE

/datum/crafting_recipe/m1carbine
	name = "M1 Carbine"
	result = /obj/item/gun/ballistic/automatic/m1carbine
	reqs = list(/obj/item/stack/sheet/iron = 5,
				/obj/item/stack/sheet/mineral/wood = 5,
				/obj/item/stack/crafting/goodparts = 5
				)
	tool_behaviors = list(TOOL_WORKBENCH)
	time = 120
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON
	always_availible = FALSE

//deagle
/datum/crafting_recipe/deagle
	name = "Desert Eagle"
	result = /obj/item/gun/ballistic/automatic/pistol/deagle
	reqs = list(/obj/item/stack/sheet/iron = 5,
				/obj/item/stack/crafting/metalparts = 10,
				/obj/item/stack/sheet/mineral/wood = 5,
				/obj/item/advanced_crafting_components/alloys = 1,
				/obj/item/stack/crafting/goodparts = 5
				)
	tool_behaviors = list(TOOL_WORKBENCH)
	time = 120
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON
	always_availible = FALSE

//aer9
/datum/crafting_recipe/AER9
	name = "AER-9"
	result = /obj/item/gun/energy/laser/aer9
	reqs = list(/obj/item/stack/sheet/iron = 15,
				/obj/item/advanced_crafting_components/lenses = 1,
				/obj/item/advanced_crafting_components/alloys = 1,
				/obj/item/stack/crafting/goodparts = 3,
				/obj/item/stack/crafting/electronicparts = 3
				)
	tool_behaviors = list(TOOL_AWORKBENCH)
	time = 120
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON
	always_availible = FALSE

//plasma rifle
/datum/crafting_recipe/plasmarifle
	name = "Plasma Rifle"
	result = /obj/item/gun/energy/laser/plasma
	reqs = list(/obj/item/stack/sheet/iron = 15,
				/obj/item/advanced_crafting_components/flux = 1,
				/obj/item/advanced_crafting_components/conductors = 2,
				/obj/item/advanced_crafting_components/alloys = 1,
				/obj/item/stack/crafting/metalparts = 3,
				/obj/item/stack/crafting/electronicparts = 3
				)
	tool_behaviors = list(TOOL_AWORKBENCH)
	time = 120
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON
	always_availible = FALSE

//tribeam
/datum/crafting_recipe/tribeam
	name = "Tribeam Laser Rifle"
	result = /obj/item/gun/energy/laser/scatter
	reqs = list(/obj/item/stack/sheet/iron = 15,
				/obj/item/advanced_crafting_components/conductors = 1,
				/obj/item/advanced_crafting_components/alloys = 1,
				/obj/item/advanced_crafting_components/lenses = 1,
				/obj/item/stack/crafting/goodparts = 3,
				/obj/item/stack/crafting/electronicparts = 3
				)
	tool_behaviors = list(TOOL_AWORKBENCH)
	time = 120
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON
	always_availible = FALSE

//AM rifle
/datum/crafting_recipe/am_rifle
	name = "Anti-Materiel Rifle"
	result = /obj/item/gun/ballistic/rifle/mag/antimateriel
	reqs = list(/obj/item/stack/sheet/iron = 10,
				/obj/item/advanced_crafting_components/assembly = 1,
				/obj/item/advanced_crafting_components/alloys = 1,
				/obj/item/advanced_crafting_components/receiver = 1,
				/datum/reagent/blackpowder = 30,
				/obj/item/stack/crafting/goodparts = 5
				)
	tool_behaviors = list(TOOL_AWORKBENCH)
	time = 120
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON
	always_availible = FALSE

//city killer
/datum/crafting_recipe/city_killer
	name = "City-Killer Shotgun"
	result = /obj/item/gun/ballistic/shotgun/automatic/combat/citykiller
	reqs = list(/obj/item/stack/sheet/iron = 10,
				/obj/item/advanced_crafting_components/assembly = 1,
				/obj/item/advanced_crafting_components/alloys = 1,
				/obj/item/advanced_crafting_components/receiver = 1,
				/obj/item/stack/crafting/goodparts = 10,
				)
	tool_behaviors = list(TOOL_WORKBENCH)
	time = 120
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON
	always_availible = FALSE

//rangemaster
/datum/crafting_recipe/rangemaster
	name = "Colt Rangemaster"
	result = /obj/item/gun/ballistic/automatic/rangemaster
	reqs = list(/obj/item/stack/sheet/iron = 10,
				/obj/item/advanced_crafting_components/assembly = 1,
				/obj/item/advanced_crafting_components/alloys = 1,
				/obj/item/advanced_crafting_components/receiver = 1,
				/obj/item/stack/crafting/goodparts = 5
				)
	tool_behaviors = list(TOOL_WORKBENCH)
	time = 120
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON
	always_availible = FALSE

//bozar
/datum/crafting_recipe/bozar
	name = "Bozar"
	result = /obj/item/gun/ballistic/automatic/bozar
	reqs = list(/obj/item/stack/sheet/iron = 10,
				/obj/item/advanced_crafting_components/assembly = 1,
				/obj/item/advanced_crafting_components/alloys = 1,
				/obj/item/advanced_crafting_components/receiver = 1,
				/obj/item/stack/crafting/goodparts = 5,

				)
	tool_behaviors = list(TOOL_AWORKBENCH)
	time = 120
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON
	always_availible = FALSE

//wattz2000
/datum/crafting_recipe/gun/energy/wattz2k
	name = "Wattz 2000 Laser Rifle"
	result = /obj/item/gun/energy/laser/wattz2k
	reqs = list(/obj/item/stack/sheet/iron = 15,
				/obj/item/advanced_crafting_components/conductors = 1,
				/obj/item/advanced_crafting_components/alloys = 1,
				/obj/item/advanced_crafting_components/lenses = 1,
				/obj/item/stack/crafting/goodparts = 3,
				/obj/item/stack/crafting/electronicparts = 3
				)
	tool_behaviors = list(TOOL_AWORKBENCH)
	time = 120
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON
	always_availible = FALSE

//magneto
/datum/crafting_recipe/magnetowattz
	name = "Wattz 1000 Magneto-laser Pistol"
	result = /obj/item/gun/energy/laser/wattz/magneto
	reqs = list(/obj/item/gun/energy/laser/wattz = 1,
				/obj/item/stack/crafting/electronicparts = 2)
	tool_behaviors = list(TOOL_AWORKBENCH)
	time = 120
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

//extendo GLOCK
/datum/crafting_recipe/glock86a
	name = "Glock 86A Plasma Pistol"
	result = /obj/item/gun/energy/laser/plasma/glock/extended
	reqs = list(/obj/item/gun/energy/laser/plasma/glock = 1,
				/obj/item/stack/crafting/metalparts = 3,
				/obj/item/stack/sheet/iron = 1,
				/obj/item/stack/crafting/electronicparts = 3)
	tool_behaviors = list(TOOL_AWORKBENCH)
	time = 120
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

//SLR
/datum/crafting_recipe/slr
	name = "Enfield Self-loading Rifle"
	result = /obj/item/gun/ballistic/automatic/slr
	reqs = list(/obj/item/stack/sheet/mineral/wood = 1,
				/obj/item/stack/crafting/metalparts = 4,
				/obj/item/advanced_crafting_components/receiver = 1,
				/obj/item/advanced_crafting_components/alloys = 1,
				/obj/item/advanced_crafting_components/assembly = 1,
				/obj/item/stack/crafting/goodparts = 5,
				/obj/item/stack/sheet/iron = 3)
	tool_behaviors = list(TOOL_WORKBENCH)
	time = 120
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON
	always_availible = FALSE

//R82 heavy service rifle
/datum/crafting_recipe/R82
	name = "R82 heavy service rifle"
	result = /obj/item/gun/ballistic/automatic/service/r82
	reqs = list(/obj/item/stack/sheet/iron = 5,
				/obj/item/advanced_crafting_components/assembly = 1,
				/obj/item/advanced_crafting_components/receiver = 1,
				/obj/item/stack/sheet/mineral/wood = 5,
				/obj/item/stack/crafting/goodparts = 5
				)
	tool_behaviors = list(TOOL_WORKBENCH)
	time = 120
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON
	always_availible = FALSE




//////////////////////////////////
///GUN ATTACHMENT/PARTS CRAFTING//
//////////////////////////////////
/datum/crafting_recipe/scope
	name = "Weapon Optics"
	result = /obj/item/attachments/scope
	reqs = list(
				/obj/item/stack/sheet/iron = 3,
				/obj/item/stack/sheet/glass = 3,
				/obj/item/stack/crafting/metalparts = 1,
				/obj/item/stack/crafting/goodparts = 1
				)
	tool_behaviors = list(TOOL_WORKBENCH)
	time = 30
	category = CAT_WEAPONRY
	subcategory = CAT_PARTS
	always_availible = FALSE

/datum/crafting_recipe/suppressor
	name = "Suppressor"
	result = /obj/item/suppressor
	reqs = list(
				/obj/item/stack/sheet/iron = 3,
				/obj/item/stack/sheet/plastic = 2,
				/obj/item/stack/crafting/metalparts = 1,
				/obj/item/stack/crafting/goodparts = 1
				)
	tool_behaviors = list(TOOL_WORKBENCH)
	time = 30
	category = CAT_WEAPONRY
	subcategory = CAT_PARTS
	always_availible = FALSE

/datum/crafting_recipe/burst_improvement
	name = "Burst Cam"
	result = /obj/item/attachments/burst_improvement
	reqs = list(
				/obj/item/stack/sheet/iron = 5,
				/obj/item/stack/crafting/metalparts = 5,
				/obj/item/stack/crafting/goodparts = 5
				)
	tool_behaviors = list(TOOL_AWORKBENCH)
	time = 30
	category = CAT_WEAPONRY
	subcategory = CAT_PARTS
	always_availible = FALSE

/datum/crafting_recipe/recoil_decrease
	name = "Recoil Compensator"
	result = /obj/item/attachments/recoil_decrease
	reqs = list(
				/obj/item/stack/sheet/iron = 5,
				/obj/item/stack/crafting/metalparts = 5,
				/obj/item/stack/crafting/goodparts = 5
				)
	tool_behaviors = list(TOOL_AWORKBENCH)
	time = 30
	category = CAT_WEAPONRY
	subcategory = CAT_PARTS
	always_availible = FALSE

/datum/crafting_recipe/automatic_sear
	name = "Automatic Sear"
	result = /obj/item/attachments/auto_sear
	reqs = list(
				/obj/item/stack/sheet/iron = 8,
				/obj/item/stack/crafting/metalparts = 8,
				/obj/item/stack/crafting/goodparts = 8
	)
	tool_behaviors = list(TOOL_AWORKBENCH)
	time = 30
	category = CAT_WEAPONRY
	subcategory = CAT_PARTS
	always_availible = FALSE
/*
/datum/crafting_recipe/flux
	name = "Flux capacitor"
	result = /obj/item/advanced_crafting_components/flux
	reqs = list(
				/obj/item/stack/cable_coil = 5,
				/obj/item/stack/crafting/goodparts = 5,
				/obj/item/stack/crafting/electronicparts = 5
				)
	tool_behaviors = list(TOOL_AWORKBENCH)
	time = 30
	category = CAT_WEAPONRY
	subcategory = CAT_PARTS
	always_availible = FALSE

/datum/crafting_recipe/lenses
	name = "Focused crystal lenses"
	result = /obj/item/advanced_crafting_components/lenses
	reqs = list(
				/obj/item/stack/cable_coil = 5,
				/obj/item/stack/crafting/goodparts = 2,
				/obj/item/stack/crafting/electronicparts = 1,
				/obj/item/stack/sheet/glass = 10
				)
	tool_behaviors = list(TOOL_AWORKBENCH)
	time = 30
	category = CAT_WEAPONRY
	subcategory = CAT_PARTS
	always_availible = FALSE

/datum/crafting_recipe/conductors
	name = "Superconductor coil"
	result = /obj/item/advanced_crafting_components/conductors
	reqs = list(
				/obj/item/stack/cable_coil = 30,
				/obj/item/stack/crafting/goodparts = 2,
				/obj/item/stack/crafting/electronicparts = 2
				)
	tool_behaviors = list(TOOL_AWORKBENCH)
	time = 30
	category = CAT_WEAPONRY
	subcategory = CAT_PARTS
	always_availible = FALSE

/datum/crafting_recipe/receiver
	name = "Advanced modular receiver"
	result = /obj/item/advanced_crafting_components/receiver
	reqs = list(
				/obj/item/stack/sheet/iron = 10,
				/obj/item/stack/crafting/goodparts = 2,
				/obj/item/stack/crafting/metalparts = 5
				)
	tool_behaviors = list(TOOL_AWORKBENCH)
	time = 30
	category = CAT_WEAPONRY
	subcategory = CAT_PARTS
	always_availible = FALSE

/datum/crafting_recipe/assembly
	name = "Pre-war weapon assembly"
	result = /obj/item/advanced_crafting_components/assembly
	reqs = list(
				/obj/item/stack/sheet/iron = 10,
				/obj/item/stack/crafting/goodparts = 2,
				/obj/item/stack/crafting/metalparts = 5,
				/obj/item/stack/sheet/plastic = 5
				)
	tool_behaviors = list(TOOL_AWORKBENCH)
	time = 30
	category = CAT_WEAPONRY
	subcategory = CAT_PARTS
	always_availible = FALSE

/datum/crafting_recipe/alloys
	name = "Superlight alloys"
	result = /obj/item/advanced_crafting_components/alloys
	reqs = list(
				/obj/item/stack/sheet/iron = 5,
				/obj/item/stack/sheet/mineral/titanium = 5,
				/obj/item/stack/sheet/plasteel = 5
				)
	tool_behaviors = list(TOOL_AWORKBENCH)
	time = 30
	category = CAT_WEAPONRY
	subcategory = CAT_PARTS
	always_availible = FALSE

Not implemented due to balance at the moment
/datum/crafting_recipe/caws
	name = "h&k caws"
	result = /obj/item/gun/ballistic/automatic/shotgun/caws
	reqs = list(/obj/item/stack/sheet/mineral/wood = 1,
				/obj/item/stack/sheet/mineral/titanium = 2,
				/obj/item/stack/sheet/iron = 2,
				/obj/item/stack/crafting/metalparts = 3,
				/obj/item/stack/crafting/goodparts = 3)
	tool_behaviors = list(TOOL_AWORKBENCH)
	time = 120
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON
	always_availible = FALSE
*/
