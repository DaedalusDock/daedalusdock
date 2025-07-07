////////////////////////////
/// Themes loot spawners ///
////////////////////////////	-mix of crafting materials, guns, ammo, junk, sorted into themes. The sub-lists are further down in the document.

/obj/effect/spawner/lootdrop/waste_loot_poor
	name = "wasteloot poor"
	loot = list(
		/obj/effect/spawner/lootdrop/f13/junkspawners = 60,
		/obj/effect/spawner/lootdrop/f13/deadrodent_or_brainwashdisk = 10,
		/obj/effect/spawner/lootdrop/toolsbasic = 9,
		/obj/effect/spawner/lootdrop/weapons/waster = 5,
		/obj/effect/spawner/lootdrop/ammo/civilian = 5,
		/obj/effect/spawner/lootdrop/kitchen = 4,
		/obj/effect/spawner/lootdrop/f13/alcoholspawner = 2,
		/obj/effect/spawner/lootdrop/f13/resourcespawner = 2,
		/obj/effect/spawner/lootdrop/bombparts = 1,
		/obj/effect/spawner/lootdrop/weapons/hunting = 1,
		/obj/effect/spawner/lootdrop/f13/cash_random_low = 1,
		)

/obj/effect/spawner/lootdrop/wastelootgood
	name = "wasteloot good"
	loot = list(
		/obj/effect/spawner/lootdrop/f13/junkspawners = 40,
		/obj/effect/spawner/lootdrop/ammo/civilian = 13,
		/obj/effect/spawner/lootdrop/toolsbasic = 10,
		/obj/effect/spawner/lootdrop/weapons/waster = 6,
		/obj/effect/spawner/lootdrop/f13/crafting = 5,
		/obj/effect/spawner/lootdrop/f13/resourcespawner = 5,
		/obj/effect/spawner/lootdrop/bombparts = 3,
		/obj/effect/spawner/lootdrop/f13/alcoholspawner = 2,
		/obj/effect/spawner/lootdrop/weapons/hunting = 2,
		/obj/effect/spawner/lootdrop/weapons/selfdefence = 2,
		/obj/effect/spawner/lootdrop/f13/cash_random_low = 2,
		/obj/effect/spawner/lootdrop/toolsgood = 5,
		)

/obj/effect/spawner/lootdrop/raiderloot
	name = "raiderloot"
	loot = list(
		/obj/effect/spawner/lootdrop/f13/junkspawners = 15,
		/obj/effect/spawner/lootdrop/ammo/civilian = 15,
		/obj/effect/spawner/lootdrop/weapons/criminal = 13,
		/obj/effect/spawner/lootdrop/f13/foodspawner = 10,
		/obj/effect/spawner/lootdrop/bombparts = 10,
		/obj/effect/spawner/lootdrop/f13/alcoholspawner = 6,
		/obj/effect/spawner/lootdrop/f13/medical/wasteland/meds/drug = 6,
		/obj/effect/spawner/lootdrop/f13/deadrodent_or_brainwashdisk = 5,
		/obj/effect/spawner/lootdrop/f13/cash_random_low = 5,
		/obj/effect/spawner/lootdrop/toolsbasic = 4,
		/obj/effect/spawner/lootdrop/weapons/waster = 4,
		/obj/effect/spawner/lootdrop/f13/cash_random_med = 2,
		/obj/effect/spawner/lootdrop/weapons/selfdefence = 2,
		/obj/effect/spawner/lootdrop/f13/resourcespawner = 1,
		/obj/effect/spawner/lootdrop/weapons/security = 1,
		/obj/effect/spawner/lootdrop/f13/cash_random_high = 1,
		)

/obj/effect/spawner/lootdrop/securityloot
	name = "securityloot"
	loot = list(
		/obj/effect/spawner/lootdrop/ammo/civilian = 35,
		/obj/effect/spawner/lootdrop/f13/junkspawners = 24,
		/obj/effect/spawner/lootdrop/weapons/security = 10,
		/obj/effect/spawner/lootdrop/f13/deadrodent_or_brainwashdisk = 5,
		/obj/effect/spawner/lootdrop/f13/cash_random_low = 5,
		/obj/effect/spawner/lootdrop/toolsgood = 5,
		/obj/effect/spawner/lootdrop/weapons/selfdefence = 5,
		/obj/effect/spawner/lootdrop/f13/resourcespawner = 5,
		/obj/effect/spawner/lootdrop/f13/advcrafting = 2,
		/obj/effect/spawner/lootdrop/f13/blueprintLow = 2,
		/obj/effect/spawner/lootdrop/f13/traitbooks = 2,
		)

/obj/effect/spawner/lootdrop/armylootbasic
	name = "armyloot basic"
	loot = list(
		/obj/effect/spawner/lootdrop/ammo/military = 28,
		/obj/effect/spawner/lootdrop/weapons/oldarmy = 20,
		/obj/effect/spawner/lootdrop/toolsgood = 10,
		/obj/effect/spawner/lootdrop/f13/deadrodent_or_brainwashdisk = 7,
		/obj/effect/spawner/lootdrop/f13/junkspawners = 5,
		/obj/effect/spawner/lootdrop/f13/cash_random_low = 5,
		/obj/effect/spawner/lootdrop/f13/resourcespawner = 5,
		/obj/effect/spawner/lootdrop/f13/advcrafting = 5,
		/obj/effect/spawner/lootdrop/f13/blueprintLow = 5,
		/obj/effect/spawner/lootdrop/f13/traitbooks = 5,
		/obj/effect/spawner/lootdrop/bombparts = 3,
		/obj/effect/spawner/lootdrop/weapons/security = 2,
		)

/obj/effect/spawner/lootdrop/armylootelite
	name = "armyloot elite"
	loot = list(
		/obj/effect/spawner/lootdrop/ammo/military = 20,
		/obj/effect/spawner/lootdrop/weapons/oldarmyelite = 20,
		/obj/effect/spawner/lootdrop/weapons/oldarmy = 10,
		/obj/effect/spawner/lootdrop/ammo/rare = 10,
		/obj/effect/spawner/lootdrop/toolsgood = 5,
		/obj/effect/spawner/lootdrop/f13/junkspawners = 5,
		/obj/effect/spawner/lootdrop/f13/resourcespawner = 5,
		/obj/effect/spawner/lootdrop/f13/advcrafting = 5,
		/obj/effect/spawner/lootdrop/f13/blueprintLow = 5,
		/obj/effect/spawner/lootdrop/f13/traitbooks = 5,
		/obj/effect/spawner/lootdrop/weapons/experimental = 5,
		/obj/effect/spawner/lootdrop/f13/deadrodent_or_brainwashdisk = 3,
		)

/obj/effect/spawner/lootdrop/rareloot
	name = "rare loot"
	loot = list(
		/obj/effect/spawner/lootdrop/ammo/military = 10,
		/obj/effect/spawner/lootdrop/ammo/rare = 30,
		/obj/effect/spawner/lootdrop/toolsgood = 10,
		/obj/effect/spawner/lootdrop/f13/advcrafting = 10,
		/obj/effect/spawner/lootdrop/f13/blueprintLow = 10,
		/obj/effect/spawner/lootdrop/weapons/experimental = 10,
		/obj/effect/spawner/lootdrop/weapons/collectors = 10,
		/obj/effect/spawner/lootdrop/weapons/unique = 5,
		/obj/effect/spawner/lootdrop/f13/traitbooks = 4,
		/obj/item/reagent_containers/cup/bottle/FEV_solution = 1,
		)

/////////////////////////
/// Sub-lists Weapons ///
/////////////////////////

/obj/effect/spawner/lootdrop/weapons/selfdefence
	name = "weaponspawner self-defence"
	loot = list(
		/obj/item/gun/ballistic/revolver/detective = 20,
		/obj/effect/spawner/bundle/f13/n99 = 11,
		/obj/effect/spawner/bundle/f13/pistol22 = 10,
		/obj/effect/spawner/bundle/f13/m1911c = 10,
		/obj/item/gun/ballistic/revolver/m29/snub = 7,
		/obj/effect/spawner/bundle/f13/smg10mm = 5,
		/obj/item/gun/energy/laser/wattz = 5,
		/obj/item/gun/ballistic/automatic/smg/american180 = 1,
		/obj/effect/spawner/bundle/f13/deagle = 1,
		/obj/item/gun/ballistic/automatic/pistol/pistol14/compact = 1,
		/obj/item/melee/onehanded/knife/survival = 10,
		/obj/item/melee/onehanded/knife/cosmicdirty = 6,
		/obj/item/melee/onehanded/knife/switchblade = 5,
//		/obj/item/melee/unarmed/brass = 4,
		/obj/item/melee/baton/telescopic = 2,
		/obj/item/twohanded/baseball/louisville = 2,
		)

/obj/effect/spawner/lootdrop/weapons/waster
	name = "weaponspawner wastelander"
	loot = list(
		/obj/item/gun/ballistic/revolver/caravan_shotgun = 10,
		/obj/item/gun/ballistic/revolver/hobo/piperifle = 10,
		/obj/effect/spawner/bundle/f13/zipgun = 8,
		/obj/item/gun/ballistic/revolver/hobo/pepperbox = 8,
		/obj/item/gun/ballistic/revolver/colt6520 = 9,
		/obj/item/gun/ballistic/rifle/hunting/obrez = 5,
		/obj/item/gun/ballistic/revolver/colt357 = 4,
		/obj/item/gun/ballistic/revolver/winchesterrebored = 4,
		/obj/item/gun/ballistic/automatic/pistol/m1911/no_mag = 4,
		/obj/effect/spawner/bundle/f13/revolverm29 = 4,
		/obj/effect/spawner/bundle/f13/guns/rockwell = 2,
		/obj/effect/spawner/bundle/weapon/worn10mmsmg = 1,
		/obj/effect/spawner/bundle/weapon/lasmusket = 1,
		/obj/item/melee/onehanded/machete = 5,
		/obj/item/twohanded/baseball = 4,
		/obj/item/melee/onehanded/club = 4,
		/obj/item/shield/riot/buckler = 4,
		/obj/item/melee/onehanded/club/tireiron = 2,
		/obj/item/twohanded/baseball/golfclub = 2,
		/obj/item/melee/onehanded/machete/scrapsabre = 2,
		/obj/item/twohanded/fireaxe/bmprsword = 2,
		/obj/item/twohanded/sledgehammer = 2,
		/obj/item/twohanded/spear/scrapspear = 2,
		/obj/item/twohanded/chainsaw = 1,
		)

/obj/effect/spawner/lootdrop/weapons/hunting
	name = "weaponspawner hunting"
	loot = list(
		/obj/item/gun/ballistic/rifle/hunting = 20,
		/obj/item/gun/ballistic/revolver/widowmaker = 17,
		/obj/item/gun/ballistic/shotgun/hunting = 10,
		/obj/effect/spawner/bundle/f13/mosin = 8,
		/obj/effect/spawner/bundle/f13/varmint = 8,
		/obj/effect/spawner/bundle/f13/cowboy = 5,
		/obj/effect/spawner/bundle/f13/trail = 4,
		/obj/item/gun/ballistic/automatic/m1garand = 2,
		/obj/effect/spawner/bundle/f13/hunting = 1,
		/obj/item/gun/ballistic/revolver/revolver45 = 3,
		/obj/item/melee/onehanded/knife/hunting = 10,
		/obj/item/twohanded/spear = 5,
		/obj/item/melee/onehanded/knife/bowie = 3,
		/obj/item/throwing_star/spear = 2,
		/obj/item/melee/onehanded/machete/forgedmachete = 2,
		)

/obj/effect/spawner/lootdrop/weapons/criminal
	name = "weaponspawner criminal"
	loot = list(
		/obj/item/gun/ballistic/automatic/autopipe = 18,
		/obj/item/gun/ballistic/automatic/pistol/type17 = 16,
		/obj/effect/spawner/bundle/f13/single_shotgun = 13,
		/obj/item/gun/ballistic/revolver/thatgun = 8,
		/obj/effect/spawner/bundle/f13/miniuzi = 4,
		/obj/item/gun/ballistic/revolver/hobo/knifegun = 4,
		/obj/item/gun/ballistic/revolver/hobo/knucklegun = 3,
		/obj/effect/spawner/bundle/f13/guns/tommygun = 2,
		/obj/item/gun/ballistic/automatic/hobo/destroyer = 1,
		/obj/item/gun/ballistic/revolver/russian = 1,
		/obj/item/twohanded/baseball/spiked = 8,
//		/obj/item/melee/unarmed/brass/spiked = 5,
//		/obj/item/melee/unarmed/lacerator = 5,
//		/obj/item/melee/unarmed/maceglove = 3,
//		/obj/item/melee/unarmed/punchdagger = 3,
//		/obj/item/melee/unarmed/tigerclaw = 5,
//		/obj/item/shishkebabpack = 1,
		)

/obj/effect/spawner/lootdrop/weapons/security
	name = "weaponspawner security"
	loot = list(
		/obj/item/gun/ballistic/revolver/police = 16,
		/obj/item/gun/ballistic/automatic/m1carbine = 12,
		/obj/item/gun/ballistic/shotgun/police = 12,
		/obj/effect/spawner/bundle/f13/beretta = 12,
		/obj/effect/spawner/bundle/f13/mk23 = 6,
		/obj/item/gun/energy/laser/pistol = 7,
		/obj/item/gun/ballistic/automatic/m1carbine/compact = 2,
		/obj/item/gun/ballistic/automatic/pistol/automag = 2,
		/obj/effect/spawner/bundle/f13/mp5 = 1,
		/obj/item/gun/ballistic/shotgun/automatic/combat/auto5 = 2,
		/obj/effect/spawner/bundle/f13/riotshotgun = 2,
		/obj/item/shield/riot = 8,
		/obj/item/melee/baton = 5,
//		/obj/item/melee/unarmed/sappers = 3,
		/obj/item/twohanded/fireaxe = 3,
		/obj/item/twohanded/sledgehammer/rockethammer = 1,
		)

/obj/effect/spawner/lootdrop/weapons/oldarmy
	name = "weaponspawner old army"
	loot = list(
		/obj/effect/spawner/bundle/f13/m1911 = 18,
		/obj/item/gun/ballistic/automatic/pistol/ninemil = 15,
		/obj/effect/spawner/bundle/f13/assault_rifle = 10,
		/obj/item/gun/ballistic/automatic/marksman/sniper = 8,
		/obj/effect/spawner/bundle/f13/marksman = 6,
		/obj/item/gun/ballistic/shotgun/trench = 6,
		/obj/effect/spawner/bundle/f13/rangemaster = 5,
		/obj/effect/spawner/bundle/f13/remington = 4,
		/obj/item/gun/energy/laser/aer9 = 4,
		/obj/item/gun/ballistic/automatic/assault_carbine = 3,
		/obj/item/gun/energy/laser/wattz2k = 3,
		/obj/effect/spawner/bundle/f13/infiltrator = 1,
		/obj/item/melee/onehanded/knife/bayonet = 10,
		/obj/item/melee/onehanded/knife/trench = 4,
//		/obj/item/melee/powered/ripper = 3,
		)

/obj/effect/spawner/lootdrop/weapons/oldarmyelite
	name = "weaponspawner old army elite"
	loot = list(
		/obj/effect/spawner/bundle/f13/sig = 17,
		/obj/item/gun/ballistic/shotgun/automatic/combat/citykiller = 17,
		/obj/effect/spawner/bundle/f13/amr = 17,
		/obj/item/gun/ballistic/automatic/pistol/pistol14 = 12,
		/obj/item/gun/energy/laser/aer12 = 10,
		/obj/item/gun/energy/laser/plasma/pistol = 7,
		/obj/effect/spawner/bundle/f13/bozar = 5,
		/obj/item/gun/ballistic/automatic/m1919 = 2,
		/obj/item/gun/ballistic/automatic/lsw = 1,
		/obj/item/twohanded/sledgehammer/supersledge = 5,
		/obj/item/melee/powerfist = 5,
		/obj/item/melee/energy/thermic_lance = 2,
		)

/obj/effect/spawner/lootdrop/weapons/collectors
	name = "weaponspawner collector"
	loot = list(
		/obj/item/gun/ballistic/automatic/pistol/m1911/custom = 20,
		/obj/effect/spawner/bundle/f13/revolver44 = 16,
		/obj/item/gun/ballistic/revolver/m29/alt = 16,
		/obj/effect/spawner/bundle/f13/sig = 12,
		/obj/effect/spawner/bundle/f13/beretta/select = 8,
		/obj/effect/spawner/bundle/f13/brushgun = 8,
		/obj/item/gun/ballistic/automatic/smg/cg45 = 5,
		/obj/item/gun/ballistic/automatic/smg/ppsh = 3,
		/obj/item/gun/ballistic/automatic/type93 = 3,
		/obj/item/gun/ballistic/automatic/fnfal = 2,
		/obj/effect/spawner/bundle/f13/guns/p90 = 2,
		/obj/effect/spawner/bundle/f13/guns/commando = 2,
		/obj/item/gun/ballistic/revolver/revolver45/gunslinger = 1,
		/obj/item/gun/energy/laser/solar = 1,
		/obj/item/gun/energy/gammagun = 1,
		)

/obj/effect/spawner/lootdrop/weapons/unique
	name = "weaponspawner unique"
	loot = list(
		/obj/item/gun/ballistic/automatic/varmint/ratslayer,
		/obj/item/gun/ballistic/automatic/m1garand/oldglory,
		/obj/item/gun/ballistic/automatic/m1garand/republicspride,
		/obj/item/gun/ballistic/rifle/hunting/paciencia,
		/obj/item/gun/ballistic/revolver/colt357/lucky,
		/obj/item/gun/ballistic/automatic/pistol/pistol14/lildevil,
		/obj/item/gun/ballistic/automatic/pistol/n99/executive,
		/obj/item/gun/ballistic/automatic/pistol/ninemil/maria,
		/obj/item/gun/energy/laser/plasma/pistol/alien,
//		/obj/item/melee/unarmed/deathclawgauntlet,
		)

/obj/effect/spawner/lootdrop/weapons/experimental
	name = "weaponspawner experimental"
	loot = list(
		/obj/item/gun/ballistic/automatic/g11 = 15,
		/obj/effect/spawner/bundle/f13/needler = 10,
		/obj/item/gun/energy/laser/laer = 10,
		/obj/item/gun/energy/laser/aer14 = 10,
		/obj/item/gun/energy/laser/rcw = 10,
		/obj/item/gun/ballistic/automatic/m72 =10,
		/obj/item/gun/energy/laser/plasma/carbine = 5,
		/obj/item/gun/energy/laser/plasma/glock = 2,
		/obj/item/gun/energy/laser/plasma = 2,
		/obj/item/gun/energy/laser/plasma/scatter =1,
//		/obj/item/melee/powerfist/moleminer = 10,
		/obj/item/melee/energy/axe/protonaxe = 10,
//		/obj/item/gun/ballistic/revolver/ballisticfist = 5,
		)


//////////////////////
/// Sub-lists Ammo ///
//////////////////////

/obj/effect/spawner/lootdrop/ammo/civilian
	name = "ammospawner civilian"
	loot = list(
		/obj/item/ammo_box/c10mm/improvised = 10,
		/obj/item/ammo_box/shotgun/improvised = 10,
		/obj/item/ammo_box/c38box/improvised = 10,
		/obj/item/ammo_box/m44box/improvised = 10,
		/obj/item/ammo_box/a556/sport/improvised = 5,
		/obj/item/ammo_box/c45/improvised = 5,
		/obj/item/ammo_box/shotgun/buck = 5,
		/obj/item/ammo_box/shotgun/bean = 5,
		/obj/item/ammo_box/c38 = 5,
		/obj/item/ammo_box/m22 = 5,
		/obj/item/ammo_box/c9mm = 5,
		/obj/item/ammo_box/a308 = 5,
		/obj/item/ammo_box/a556/sport = 5,
		/obj/item/ammo_box/c10mm = 5,
		/obj/item/stock_parts/cell/ammo/ec = 3,
		/obj/item/ammo_box/a308box = 3,
		/obj/item/ammo_box/a357box = 2,
		/obj/item/ammo_box/m44box = 2,
		)

/obj/effect/spawner/lootdrop/ammo/military
	name = "ammospawner military"
	loot = list(
		/obj/item/ammo_box/c45 = 15,
		/obj/item/ammo_box/shotgun/slug = 15,
		/obj/item/stock_parts/cell/ammo/ec = 15,
		/obj/item/ammo_box/a556 = 15,
		/obj/item/ammo_box/a762 = 10,
		/obj/item/ammo_box/a762box = 10,
		/obj/item/ammo_box/magazine/m556/rifle/extended/empty = 8,
		/obj/item/ammo_box/magazine/m762/ext/empty = 7,
		/obj/item/ammo_box/a50MGbox = 5,
		)

/obj/effect/spawner/lootdrop/ammo/rare
	name = "ammospawner rare"
	loot = list(
		/obj/item/ammo_box/c4570box = 25,
		/obj/item/ammo_box/m14mm = 15,
		/obj/item/stock_parts/cell/ammo/ec = 12,
		/obj/item/ammo_box/m473 = 10,
		/obj/item/ammo_box/magazine/automag = 10,
		/obj/item/stock_parts/cell/ammo/mfc = 10,
		/obj/item/ammo_box/magazine/m22smg = 9,
		/obj/item/ammo_box/a45lcbox = 3,
		)

/obj/effect/spawner/lootdrop/bombparts
	name = "bombpartspawner"
	lootcount = 2
	loot = list(
		/obj/item/reagent_containers/food/drinks/flask,
		/obj/item/reagent_containers/cup/bottle/blackpowder,
		/obj/item/stack/cable_coil,
		/obj/item/crafting/timer,
		/obj/item/crafting/coffee_pot,
		/obj/item/assembly/igniter,
		/obj/item/ammo_box/jerrycan,
		/obj/item/reagent_containers/cup/rag,
		/obj/item/reagent_containers/cup/glass/bottle,
		/obj/item/reagent_containers/cup/bottle/welding_fuel,
		)


/////////////////////////
/// Sub-lists Utility ///
/////////////////////////

/obj/effect/spawner/lootdrop/toolsbasic
	name = "toolspawner basic"
	loot = list(
		/obj/item/shovel,
		/obj/item/stack/cable_coil,
		/obj/item/screwdriver/crude,
		/obj/item/screwdriver/basic,
		/obj/item/crowbar/crude,
		/obj/item/crowbar/basic,
		/obj/item/crowbar,
		/obj/item/hatchet,
		/obj/item/pickaxe,
		/obj/item/wrench/crude,
		/obj/item/wrench/basic,
		/obj/item/weldingtool/crude,
		/obj/item/weldingtool/basic,
		)

/obj/effect/spawner/lootdrop/toolsgood
	name = "toolspawner good"
	loot = list(
		/obj/item/screwdriver,
		/obj/item/crowbar,
		/obj/item/extinguisher,
		/obj/item/pickaxe/mini,
		/obj/item/wrench,
		/obj/item/weldingtool,
		/obj/item/weldingtool/mini,
		/obj/item/multitool,
		)

/obj/effect/spawner/lootdrop/kitchen
	name = "kitchenspawner"
	loot = list(
		/obj/item/reagent_containers/cup/beaker/large,
		/obj/item/reagent_containers/condiment/saltshaker,
		/obj/item/knife/kitchen,
		/obj/item/kitchen/rollingpin,
		/obj/item/knife/butcher,
		)


//////////////////////////////
/// Single spawner objects ///
//////////////////////////////

/obj/effect/spawner/bundle/weapon/lasmusket
	name = "laskmusket and ammo spawner"
	items = list(
		/obj/item/gun/ballistic/rifle/hobo/lasmusket,
		/obj/item/ammo_box/lasmusket,
		)

/obj/effect/spawner/bundle/weapon/piperifle
	name = "piperifle and ammo spawner"
	items = list(
		/obj/item/gun/ballistic/revolver/hobo/piperifle,
		/obj/item/ammo_box/a556/sport/improvised,
		)

/obj/effect/spawner/bundle/weapon/pepperbox
	name = "pepperbox gun spawner"
	items = list(
		/obj/item/gun/ballistic/revolver/hobo/pepperbox,
		/obj/item/ammo_box/c10mm/improvised,
		)

/obj/effect/spawner/bundle/weapon/worn10mmsmg
	name = "worn 10mm SMG and ammo spawner"
	items = list(
		/obj/item/gun/ballistic/automatic/smg/smg10mm/worn,
		/obj/item/ammo_box/magazine/m10mm_adv/empty,
		)
