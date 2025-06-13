/*
 * Nitrogen Tanks for Vox
 */

/obj/item/tank/internals/nitrogen
	name = "nitrogen tank"
	desc = "A tank of nitrogen."
	icon_state = "nitrogen_big"
	force = 10
	distribute_pressure = TANK_DEFAULT_RELEASE_PRESSURE

/obj/item/tank/internals/nitrogen/populate_gas()
	air_contents.adjustGas(GAS_NITROGEN, (3*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C))

/obj/item/tank/internals/nitrogen/full/populate_gas()
	air_contents.adjustGas(GAS_NITROGEN, (10*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C))

/obj/item/tank/internals/nitrogen/belt
	icon_state = "nitrogen_extended"
	slot_flags = ITEM_SLOT_BELT
	force = 5
	volume = 24
	w_class = WEIGHT_CLASS_SMALL
	supports_variations_flags = CLOTHING_VOX_VARIATION

/obj/item/tank/internals/nitrogen/belt/full/populate_gas()
	air_contents.adjustGas(GAS_NITROGEN, (10*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C))

/obj/item/tank/internals/nitrogen/belt/emergency
	name = "emergency nitrogen tank"
	desc = "Used for emergencies. Contains very little nitrogen, so try to conserve it until you actually need it."
	icon_state = "nitrogen"
	volume = 3

/obj/item/tank/internals/nitrogen/belt/emergency/populate_gas()
	air_contents.adjustGas(GAS_NITROGEN, (10*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C))

