/* Types of tanks!
 * Contains:
 * Oxygen
 * Anesthetic
 * Air
 * Plasma
 * Emergency Oxygen
 * Generic
 */

/*
 * Oxygen
 */
/obj/item/tank/internals/oxygen
	name = "oxygen tank"
	desc = "A tank of oxygen, this one is blue."
	icon_state = "oxygen"
	tank_holder_icon_state = "holder_oxygen"
	distribute_pressure = TANK_DEFAULT_RELEASE_PRESSURE
	force = 10
	dog_fashion = /datum/dog_fashion/back
	supports_variations_flags = CLOTHING_TESHARI_VARIATION


/obj/item/tank/internals/oxygen/populate_gas()
	air_contents.adjustGas(GAS_OXYGEN,(6*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C))


/obj/item/tank/internals/oxygen/yellow
	desc = "A tank of oxygen, this one is yellow."
	icon_state = "oxygen_f"
	tank_holder_icon_state = "holder_oxygen_f"
	dog_fashion = null
	supports_variations_flags = NONE

/obj/item/tank/internals/oxygen/red
	desc = "A tank of oxygen, this one is red."
	icon_state = "oxygen_fr"
	tank_holder_icon_state = "holder_oxygen_fr"
	dog_fashion = null
	supports_variations_flags = NONE

/obj/item/tank/internals/oxygen/empty/populate_gas()
	return

/*
 * Anesthetic
 */
/obj/item/tank/internals/anesthetic
	name = "anesthetic tank"
	desc = "A tank with an N2O/O2 gas mix."
	icon_state = "anesthetic"
	inhand_icon_state = "an_tank"
	tank_holder_icon_state = "holder_anesthetic"
	force = 10
	supports_variations_flags = CLOTHING_TESHARI_VARIATION

/obj/item/tank/internals/anesthetic/populate_gas()
	air_contents.adjustGas(GAS_OXYGEN,(3*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C) * O2STANDARD)
	air_contents.adjustGas(GAS_N2O, (3*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C) * N2STANDARD)

/*
 * Plasma
 */
/obj/item/tank/internals/plasma
	name = "plasma tank"
	desc = "Contains dangerous plasma. Do not inhale. Warning: extremely flammable."
	icon_state = "plasma"
	worn_icon_state = "plasmatank"
	tank_holder_icon_state = null
	flags_1 = CONDUCT_1
	slot_flags = null //they have no straps!
	force = 8


/obj/item/tank/internals/plasma/populate_gas()
	air_contents.adjustGas(GAS_PLASMA, (3*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C))

/obj/item/tank/internals/plasma/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/flamethrower))
		var/obj/item/flamethrower/F = W
		if ((!F.status)||(F.ptank))
			return
		if(!user.transferItemToLoc(src, F))
			return
		src.master = F
		F.ptank = src
		F.update_appearance()
	else
		return ..()

/obj/item/tank/internals/plasma/full/populate_gas()
	air_contents.adjustGas(GAS_PLASMA, (10*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C))

/obj/item/tank/internals/plasma/empty/populate_gas()
	return

/*
 * Emergency Oxygen
 */
/obj/item/tank/internals/emergency_oxygen
	name = "emergency oxygen tank"
	desc = "Used for emergencies. Contains very little oxygen, so try to conserve it until you actually need it."
	icon_state = "emergency"
	worn_icon_state = "emergency"
	tank_holder_icon_state = "holder_emergency"
	worn_icon = null
	supports_variations_flags = CLOTHING_TESHARI_VARIATION
	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_SMALL

	force = 1
	stamina_damage = 20
	stamina_cost = 8

	distribute_pressure = TANK_DEFAULT_RELEASE_PRESSURE
	volume = 3 //Tiny. Real life equivalents only have 21 breaths of oxygen in them. They're EMERGENCY tanks anyway -errorage (dangercon 2011)


/obj/item/tank/internals/emergency_oxygen/populate_gas()
	air_contents.adjustGas(GAS_OXYGEN, (10*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C))


/obj/item/tank/internals/emergency_oxygen/empty/populate_gas()
	return

/obj/item/tank/internals/emergency_oxygen/engi
	name = "extended-capacity emergency oxygen tank"
	icon_state = "emergency_engi"
	worn_icon_state = "emergency_engi"
	tank_holder_icon_state = "holder_emergency_engi"
	worn_icon = null
	volume = 6 // should last 24 minutes if full

/obj/item/tank/internals/emergency_oxygen/engi/empty/populate_gas()
	return

/obj/item/tank/internals/emergency_oxygen/double
	name = "double emergency oxygen tank"
	icon_state = "emergency_double"
	worn_icon_state = "emergency_engi"
	tank_holder_icon_state = "holder_emergency_engi"
	supports_variations_flags = NONE
	volume = 12 //If it's double of the above, shouldn't it be double the volume??

/obj/item/tank/internals/emergency_oxygen/double/empty/populate_gas()
	return

// *
// * GENERIC
// *

/obj/item/tank/internals/generic
	name = "gas tank"
	desc = "A generic tank used for storing and transporting gasses. Can be used for internals."
	icon_state = "generic"
	distribute_pressure = TANK_DEFAULT_RELEASE_PRESSURE
	force = 10
	dog_fashion = /datum/dog_fashion/back

/obj/item/tank/internals/generic/populate_gas()
	return
