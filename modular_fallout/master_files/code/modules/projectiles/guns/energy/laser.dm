
//Fallout


/obj/item/gun/energy/laser
	name = "energy weapon template"
	desc = "Should not exists. Bugreport."
	icon_state = "laser"
	icon = 'modular_fallout/master_files/icons/fallout/objects/guns/laser.dmi'
	base_icon_state = "laser"
	inhand_icon_state = "laser"
	slowdown = 0.3
	w_class = WEIGHT_CLASS_BULKY
	weapon_weight = WEAPON_HEAVY
	custom_materials = list(/datum/material/iron=2000)
	ammo_type = list(/obj/item/ammo_casing/energy/lasergun)
	ammo_x_offset = 1
	shaded_charge = 1

/obj/item/gun/energy/laser/attackby(obj/item/A, mob/user, params)
	. = ..()
	if(.)
		return
	if(istype(A, /obj/item/stock_parts/cell/ammo))
		var/obj/item/stock_parts/cell/ammo/AM = A
		if(istype(AM, cell_type))
			var/obj/item/stock_parts/cell/ammo/oldcell = cell
			if(user.transferItemToLoc(AM, src))
				cell = AM
				if(oldcell)
					to_chat(user, "<span class='notice'>You perform a tactical reload on \the [src], replacing the cell.</span>")
					oldcell.unequipped()
					oldcell.forceMove(get_turf(src.loc))
					oldcell.update_icon()
				//else
				//	to_chat(user, "<span class='notice'>You insert the cell into \the [src].</span>")

				//playsound(src, 'modular_fallout/master_files/sound/weapons/autoguninsert.ogg', 60, TRUE)
				//chamber_round()
				A.update_icon()
				update_icon()
				return 1
			else
				to_chat(user, "<span class='warning'>You cannot seem to get \the [src] out of your hands!</span>")

/////////////////
//LASER PISTOLS//
/////////////////


//Wattz 1000 Laser pistol
/obj/item/gun/energy/laser/wattz
	name = "Wattz 1000 laser pistol"
	desc = "A Wattz 1000 Laser Pistol. Civilian model, so the wattage is lower than military or police versions. Uses small energy cells."
	icon = 'modular_fallout/master_files/icons/fallout/objects/guns/energy.dmi'
	lefthand_file = 'modular_fallout/master_files/icons/fallout/onmob/weapons/guns_lefthand.dmi'
	righthand_file = 'modular_fallout/master_files/icons/fallout/onmob/weapons/guns_righthand.dmi'
	icon_state = "wattz1000"
	base_icon_state = "wattz1000"
	inhand_icon_state = "laser-pistol"
	fire_delay = 0
	slowdown = 0.2
	w_class = WEIGHT_CLASS_NORMAL
	weapon_weight = WEAPON_LIGHT
	slot_flags = ITEM_SLOT_BELT
	ammo_type = list(/obj/item/ammo_casing/energy/laser/pistol/wattz/hitscan)
	cell_type = /obj/item/stock_parts/cell/ammo/ec
	equipsound = 'modular_fallout/master_files/sound/f13weapons/equipsounds/aep7equip.ogg'

//Watss 1000 Magneto-laser pistol
/obj/item/gun/energy/laser/wattz/magneto
	name = "Wattz 1000 magneto-laser pistol"
	desc = "This Wattz 1000 laser pistol has been upgraded with a magnetic field targeting system that tightens the laser emission, giving this pistol extra penetrating power."
	icon_state = "magnetowattz"
	base_icon_state = "magnetowattz"
	fire_delay = 0
	inhand_icon_state = "laser-pistol"
	ammo_type = list(/obj/item/ammo_casing/energy/laser/pistol/wattz/magneto/hitscan)


//AEP 7 Laser pistol
/obj/item/gun/energy/laser/pistol
	name = "\improper AEP7 laser pistol"
	desc = "A basic energy-based laser gun that fires concentrated beams of light."
	slowdown = 0.2
	icon_state = "AEP7"
	base_icon_state = "AEP7"
	inhand_icon_state = "laser-pistol"
	w_class = WEIGHT_CLASS_NORMAL
	weapon_weight = WEAPON_MEDIUM
	slot_flags = ITEM_SLOT_BELT
	ammo_type = list(/obj/item/ammo_casing/energy/laser/pistol/hitscan)
	cell_type = /obj/item/stock_parts/cell/ammo/ec
	fire_delay = 0
	can_scope = TRUE
	scope_state = "AEP7_scope"
	scope_x_offset = 7
	scope_y_offset = 22
	equipsound = 'modular_fallout/master_files/sound/f13weapons/equipsounds/aep7equip.ogg'


//Solar Scorcher
/obj/item/gun/energy/laser/solar
	name = "\improper Solar Scorcher"
	slowdown = 0.2
	desc = "This modified AEP7 laser pistol takes its power from the sun, recharging slowly using stored solar energy. However, it cannot be recharged manually as a result."
	icon_state = "solarscorcher"
	base_icon_state = "solarscorcher"
	inhand_icon_state = "solarscorcher"
	weapon_weight = WEAPON_MEDIUM
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = ITEM_SLOT_BELT
	ammo_type = list(/obj/item/ammo_casing/energy/laser/solar/hitscan) //27 dmg, .15 AP
	cell_type = /obj/item/stock_parts/cell/ammo/ec //16 shots, self-charges
	can_charge = 0
	selfcharge = 1 //selfcharging adds 100 a shot
	equipsound = 'modular_fallout/master_files/sound/f13weapons/equipsounds/aep7equip.ogg'


//Ultracite Laser pistol
/obj/item/gun/energy/laser/ultra_pistol
	name = "\improper Ultracite laser pistol"
	desc = "An ultracite enhanced energy-based laser gun that fires concentrated beams of light."
	slowdown = 0.2
	icon_state = "ultra_pistol"
	base_icon_state = "ultra_pistol"
	inhand_icon_state = "laser-pistol"
	w_class = WEIGHT_CLASS_NORMAL
	weapon_weight = WEAPON_MEDIUM
	slot_flags = ITEM_SLOT_BELT
	fire_delay = 2
	scope_x_offset = 7
	scope_y_offset = 22
	ammo_type = list(/obj/item/ammo_casing/energy/laser/ultra_pistol)
	cell_type = /obj/item/stock_parts/cell/ammo/ec
	equipsound = 'modular_fallout/master_files/sound/f13weapons/equipsounds/aep7equip.ogg'



////////////////
//LASER RIFLES//
////////////////


//Wattz 2000 Laser rifle
/obj/item/gun/energy/laser/wattz2k
	name = "wattz 2000"
	desc = "Wattz 2000 Laser Rifle. Uses micro fusion cells for more powerful lasers, and an extended barrel for additional range."
	icon = 'modular_fallout/master_files/icons/fallout/objects/guns/energy.dmi'
	lefthand_file = 'modular_fallout/master_files/icons/fallout/onmob/weapons/guns_lefthand.dmi'
	righthand_file = 'modular_fallout/master_files/icons/fallout/onmob/weapons/guns_righthand.dmi'
	icon_state = "wattz2k"
	base_icon_state = "wattz2k"
	inhand_icon_state = "sniper_rifle"
	fire_delay = 1
	ammo_type = list(/obj/item/ammo_casing/energy/wattz2k/hitscan)
	cell_type = /obj/item/stock_parts/cell/ammo/mfc
	zoomable = TRUE
	zoom_amt = 10
	zoom_out_amt = 13
	equipsound = 'modular_fallout/master_files/sound/f13weapons/equipsounds/aer14equip.ogg'

//Wattz 2000 Extended
/obj/item/gun/energy/laser/wattz2k/extended
	name = "wattz 2000e"
	desc = "This Wattz 2000 laser rifle has had its recharging system upgraded and a special recycling chip installed that reduces the drain on the micro fusion cell by 50%."
	icon_state = "wattz2k_ext"
	lefthand_file = 'modular_fallout/master_files/icons/fallout/onmob/weapons/guns_lefthand.dmi'
	righthand_file = 'modular_fallout/master_files/icons/fallout/onmob/weapons/guns_righthand.dmi'
	icon_state = "wattz2k"
	base_icon_state = "wattz2k"
	inhand_icon_state = "sniper_rifle"
	fire_delay = 1
	ammo_type = list(/obj/item/ammo_casing/energy/wattz2k/extended/hitscan)
	cell_type = /obj/item/stock_parts/cell/ammo/mfc
	zoomable = TRUE
	zoom_amt = 10
	zoom_out_amt = 13
	equipsound = 'modular_fallout/master_files/sound/f13weapons/equipsounds/aer14equip.ogg'



//AER9 Laser rifle
/obj/item/gun/energy/laser/aer9
	name = "\improper AER9 laser rifle"
	desc = "A sturdy pre-war laser rifle. Emits beams of concentrated light to kill targets. Fast firing, but not very powerful."
	icon_state = "laser"
	base_icon_state = "laser"
	inhand_icon_state = "laser-rifle9"
	ammo_type = list(/obj/item/ammo_casing/energy/laser/lasgun/hitscan)
	cell_type = /obj/item/stock_parts/cell/ammo/mfc
	fire_delay = 1
	scope_state = "AEP7_scope"
	scope_x_offset = 12
	scope_y_offset = 20
	equipsound = 'modular_fallout/master_files/sound/f13weapons/equipsounds/aer9equip.ogg'

//Ultracite Laser rifle
/obj/item/gun/energy/laser/ultra_rifle
	name = "\improper Ultracite laser rifle"
	desc = "A sturdy and advanced military grade pre-war service laser rifle, now enhanced with ultracite"
	icon_state = "ultra_rifle"
	base_icon_state = "ultra_rifle"
	inhand_icon_state = "laser-rifle9"
	ammo_type = list(/obj/item/ammo_casing/energy/laser/lasgun)
	cell_type = /obj/item/stock_parts/cell/ammo/ultracite
	fire_delay = 3
	zoomable = TRUE
	zoom_amt = 10
	zoom_out_amt = 13
	equipsound = 'modular_fallout/master_files/sound/f13weapons/equipsounds/aer9equip.ogg'


//Tribeam Laser rifle
/obj/item/gun/energy/laser/scatter
	name = "tribeam laser rifle"
	desc = "A modified AER9 equipped with a refraction kit that divides the laser shot into three separate beams. While powerful, it has a reputation for friendly fire."
	icon_state = "tribeam"
	base_icon_state = "tribeam"
	inhand_icon_state = "laser-rifle9"
	fire_delay = 3
	ammo_type = list(/obj/item/ammo_casing/energy/laser/scatter/tribeam/hitscan)
	cell_type = /obj/item/stock_parts/cell/ammo/mfc
	equipsound = 'modular_fallout/master_files/sound/f13weapons/equipsounds/tribeamequip.ogg'


//AER12 Laser rifle
/obj/item/gun/energy/laser/aer12
	name = "\improper AER12 laser rifle"
	desc = "A cutting-edge, pre-war laser rifle. Its focusing crystal array is housed in gold alloy, making it difficult to maintain."
	icon_state = "aer12"
	base_icon_state = "aer12"
	inhand_icon_state = "laser-rifle9"
	ammo_type = list(/obj/item/ammo_casing/energy/laser/aer12/hitscan)
	cell_type = /obj/item/stock_parts/cell/ammo/mfc
	fire_delay = 1.5
	scope_state = "AEP7_scope"
	scope_x_offset = 12
	scope_y_offset = 20
	equipsound = 'modular_fallout/master_files/sound/f13weapons/equipsounds/tribeamequip.ogg'


//AER14 Laser rifle
/obj/item/gun/energy/laser/aer14
	name = "\improper AER14 laser rifle"
	desc = "A bleeding-edge, pre-war laser rifle. Extremely powerful, but eats MFCs like nothing else."
	icon_state = "aer14"
	base_icon_state = "aer14"
	inhand_icon_state = "laser-rifle9"
	ammo_type = list(/obj/item/ammo_casing/energy/laser/aer14/hitscan)
	cell_type = /obj/item/stock_parts/cell/ammo/mfc
	fire_delay = 1.5
	scope_state = "AEP7_scope"
	scope_x_offset = 12
	scope_y_offset = 20
	equipsound = 'modular_fallout/master_files/sound/f13weapons/equipsounds/aer14equip.ogg'


//LAER Energy rifle
/obj/item/gun/energy/laser/laer
	name = "\improper LAER"
	desc = "The Laser Assister Energy Rifle is a powerful pre-war weapon developed just before the turn of the Great War. Due to its incredible rarity and unprecedented firepower, the weapon is coveted and nearly solely possesed by the Brotherhood of Steel; typically held by an Elder as a status symbol."
	icon_state = "laer"
	base_icon_state = "laer"
	inhand_icon_state = "laer"
	fire_delay = 3
	burst_size = 1
	ammo_type = list(/obj/item/ammo_casing/energy/laser/laer/hitscan)
	cell_type = /obj/item/stock_parts/cell/ammo/mfc
	equipsound = 'modular_fallout/master_files/sound/f13weapons/equipsounds/laerequip.ogg'


//Fallout 4 laser tommy gun.
/obj/item/gun/energy/laser/rcw
	name = "laser RCW"
	desc = "A rapid-fire laser rifle modeled after the familiar \"Thompson\" SMG. It features high-accuracy burst fire that will whittle down targets in a matter of seconds."
	icon_state = "lasercw"
	base_icon_state = "lasercw"
	inhand_icon_state = "rcw"
	fire_delay = 3
	burst_size = 2
	ammo_type = list(/obj/item/ammo_casing/energy/laser/rcw/hitscan)
	cell_type = /obj/item/stock_parts/cell/ammo/ecp
	equipsound = 'modular_fallout/master_files/sound/f13weapons/equipsounds/RCWequip.ogg'

/obj/item/gun/energy/laser/rcw/afterattack()
	. = ..()
//	empty_alarm()
	return



//////////////////
//PLASMA WEAPONS//
//////////////////


//Plasma pistol
/obj/item/gun/energy/laser/plasma/pistol
	name ="plasma pistol"
	slowdown = 0.2
	inhand_icon_state = "plasma-pistol"
	icon_state = "plasma-pistol"
	base_icon_state = "plasma-pistol"
	desc = "A pistol-sized miniaturized plasma caster built by REPCONN. It fires heavy low penetration plasma clots."
	w_class = WEIGHT_CLASS_NORMAL
	weapon_weight = WEAPON_LIGHT
	slot_flags = ITEM_SLOT_BELT
	ammo_type = list(/obj/item/ammo_casing/energy/plasma/pistol)
	cell_type = /obj/item/stock_parts/cell/ammo/ec
	equipsound = 'modular_fallout/master_files/sound/f13weapons/equipsounds/pistolplasequip.ogg'


//Glock 86 Plasma pistol
/obj/item/gun/energy/laser/plasma/glock
	name = "glock 86"
	desc = "Glock 86 Plasma Pistol. Designed by the Gaston Glock artificial intelligence. Shoots a small bolt of superheated plasma. Powered by a small energy cell."
	inhand_icon_state = "plasma-pistol"
	icon_state = "glock86"
	base_icon_state = "glock86"
	slowdown = 0.2
	w_class = WEIGHT_CLASS_NORMAL
	weapon_weight = WEAPON_HEAVY
	slot_flags = ITEM_SLOT_BELT
	ammo_type = list(/obj/item/ammo_casing/energy/plasma/pistol/glock)
	equipsound = 'modular_fallout/master_files/sound/f13weapons/equipsounds/pistolplasequip.ogg'
	cell_type = /obj/item/stock_parts/cell/ammo/ec

//Glock 86 A Plasma pistol
/obj/item/gun/energy/laser/plasma/glock/extended
	name ="glock 86a"
	inhand_icon_state = "plasma-pistol"
	icon_state = "glock86a"
	base_icon_state = "glock86a"
	desc = "This Glock 86 plasma pistol has had its magnetic housing chamber realigned to reduce the drain on its energy cell. Its efficiency has doubled, allowing it to fire more shots before the battery is expended."
	ammo_type = list(/obj/item/ammo_casing/energy/plasma/pistol/glock/extended)
	cell_type = /obj/item/stock_parts/cell/ammo/ec


//Plasma Rifle
/obj/item/gun/energy/laser/plasma
	name ="plasma rifle"
	inhand_icon_state = "plasma"
	icon_state = "plasma"
	base_icon_state = "plasma"
	fire_delay = 4.5
	desc = "A miniaturized plasma caster that fires bolts of magnetically accelerated toroidal plasma towards an unlucky target."
	ammo_type = list(/obj/item/ammo_casing/energy/plasma)
	cell_type = /obj/item/stock_parts/cell/ammo/mfc
	equipsound = 'modular_fallout/master_files/sound/f13weapons/equipsounds/plasequip.ogg'


//Plasma carbine
/obj/item/gun/energy/laser/plasma/carbine
	name ="plasma carbine"
	inhand_icon_state = "plasma"
	icon_state = "plasmacarbine"
	base_icon_state = "plasmacarbine"
	desc = "A burst-fire energy weapon that fires a steady stream of toroidal plasma towards an unlucky target."
	ammo_type = list(/obj/item/ammo_casing/energy/plasmacarbine)
	cell_type = /obj/item/stock_parts/cell/ammo/mfc
	burst_size = 2
	burst_shot_delay = 1.5
	actions_types = list(/datum/action/item_action/toggle_firemode)
	can_scope = TRUE
	scope_state = "plasma_scope"
	scope_x_offset = 13
	scope_y_offset = 16
	equipsound = 'modular_fallout/master_files/sound/f13weapons/equipsounds/plasequip.ogg'

//Multiplas rifle
/obj/item/gun/energy/laser/plasma/scatter
	name = "multiplas rifle"
	inhand_icon_state = "multiplas"
	icon_state = "multiplas"
	base_icon_state = "multiplas"
	fire_delay = 3
	desc = "A modified A3-20 plasma caster built by REPCONN equipped with a multicasting kit that creates multiple weaker clots."
	equipsound = 'modular_fallout/master_files/sound/f13weapons/equipsounds/plasequip.ogg'
	ammo_type = list(/obj/item/ammo_casing/energy/plasma/scatter)
	cell_type = /obj/item/stock_parts/cell/ammo/mfc


//Alien Blaster
/obj/item/gun/energy/laser/plasma/pistol/alien
	name = "alien blaster"
	slowdown = 0.2
	inhand_icon_state = "alienblaster"
	icon_state = "alienblaster"
	base_icon_state = "alienblaster"
	desc = "This weapon is unlike any other you've ever seen before, and appears to be made out of metals not usually found on Earth. It certainly packs a punch, though."
	w_class = WEIGHT_CLASS_NORMAL
	weapon_weight = WEAPON_LIGHT
	slot_flags = ITEM_SLOT_BELT
	can_charge = FALSE
	ammo_type = list(/obj/item/ammo_casing/energy/plasma/pistol/alien)
	cell_type = /obj/item/stock_parts/cell/ammo/alien //unchargeable, but removable


//Gamma gun
/obj/item/gun/energy/gammagun
	name = "Gamma gun"
	desc = "A very crude weapon overall and appears to have been built from scavenged junk found throughout the wasteland."
	icon_state = "gammagun"
	base_icon_state = "gammagun"
	inhand_icon_state = "gammagun"
	w_class = WEIGHT_CLASS_NORMAL
	weapon_weight = WEAPON_LIGHT
	slot_flags = ITEM_SLOT_BELT
	ammo_type = list(/obj/item/ammo_casing/energy/gammagun)
	cell_type = /obj/item/stock_parts/cell/ammo/mfc
	ammo_x_offset = 3


//// BETA /// Obsolete
/obj/item/gun/energy/laser/lasertesting
	ammo_type = list(/obj/item/ammo_casing/energy/laser/pistol/lasertest)
