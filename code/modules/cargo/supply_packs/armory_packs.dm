/datum/supply_pack/mpc
	group = "MPC Armory"
	access = ACCESS_SECURITY
	crate_type = /obj/structure/closet/crate/secure/gear

/datum/supply_pack/mpc/armor
	name = "Armor Set (Plated)"
	desc = "Contains a set of well-rounded, decently-protective armor."
	cost = PAYCHECK_ASSISTANT * 15.2 + CARGO_CRATE_VALUE
	access_view = ACCESS_SECURITY
	contains = list(
		/obj/item/clothing/suit/armor/vest,
		/obj/item/clothing/head/helmet,
	)
	crate_name = "armor crate"

/datum/supply_pack/mpc/bulletarmor
	name = "Armor Set (Ceramic)"
	desc = "Contains a set of bulletproof armor. Guaranteed to reduce a bullet's stopping power by over half."
	cost = PAYCHECK_ASSISTANT * 28.6 + CARGO_CRATE_VALUE
	contains = list(
		/obj/item/clothing/suit/armor/bulletproof,
		/obj/item/clothing/head/helmet/alt,
	)
	crate_name = "bulletproof armor crate"

/datum/supply_pack/mpc/riotgear
	name = "Armor Set (Riot)"
	desc = "Contains a set of heavy body armor, a heavy helmet, and a riot shield."
	cost = PAYCHECK_ASSISTANT * 24 + CARGO_CRATE_VALUE
	contains = list(
		/obj/item/clothing/suit/armor/riot,
		/obj/item/clothing/head/helmet/riot,
		/obj/item/shield/riot
	)
	crate_name = "riot armor crate"

/datum/supply_pack/mpc/securityclothes
	name = "MPC Uniform Crate"
	desc = "Contains four Mars People's Coalition uniforms."
	cost = PAYCHECK_ASSISTANT * 10 + CARGO_CRATE_VALUE
	access_view = ACCESS_SECURITY
	contains = list(
		/obj/item/clothing/suit/security/officer,
		/obj/item/clothing/suit/security/officer,
		/obj/item/clothing/suit/security/officer,
		/obj/item/clothing/suit/security/officer,
	)
	crate_name = "MPC uniform crate"

/datum/supply_pack/mpc/stingpack
	name = "Box of Stingbangs"
	desc = "Contains five \"stingbang\" grenades, perfect for stopping riots and playing morally unthinkable pranks. Requires Security access to open."
	cost = PAYCHECK_ASSISTANT * 17.1 + CARGO_CRATE_VALUE
	access_view = ACCESS_ARMORY
	contains = list(/obj/item/storage/box/stingbangs)
	crate_name = "stingbang grenade pack crate"

/datum/supply_pack/mpc/handcuffs
	name = "Box of Handcuffs"
	desc = "Contains 7 pairs of handcuffs."
	cost = /obj/item/restraints/handcuffs::custom_price * 6 + CARGO_CRATE_VALUE //You get one free
	access_view = ACCESS_ARMORY
	contains = list(
		/obj/item/storage/box/handcuffs,
	)
	crate_name = "handcuff crate"

/datum/supply_pack/mpc/ballistic
	name = "Combat Shotgun Bundle"
	desc = "Contains a semi-automatic shotgun and a bandolier."
	cost = PAYCHECK_ASSISTANT * 62 + CARGO_CRATE_VALUE
	contains = list(
		/obj/item/gun/ballistic/shotgun/automatic/combat,
		/obj/item/storage/belt/bandolier,
	)
	crate_name = "combat shotgun crate"

/datum/supply_pack/mpc/energy
	name = "Energy Guns Crate"
	desc = "Contains two Energy Guns, capable of firing both nonlethal and lethal blasts of light."
	cost = PAYCHECK_ASSISTANT * 45.1 + CARGO_CRATE_VALUE
	contains = list(
		/obj/item/gun/energy/e_gun,
		/obj/item/gun/energy/e_gun
	)
	crate_name = "energy gun crate"
	crate_type = /obj/structure/closet/crate/secure/plasma

/datum/supply_pack/mpc/fire
	name = "Incendiary Weapons Crate"
	desc = "We don't need no water, let the motherfucker burn, burn, motherfucker burn. Contains three incendiary grenades, three plasma canisters, and a flamethrower. Requires Armory access to open."
	cost = PAYCHECK_ASSISTANT * 35.5 + CARGO_CRATE_VALUE
	access = ACCESS_SECURITY
	contains = list(
		/obj/item/flamethrower/full,
		/obj/item/tank/internals/plasma,
		/obj/item/tank/internals/plasma,
		/obj/item/tank/internals/plasma,
		/obj/item/grenade/chem_grenade/incendiary,
		/obj/item/grenade/chem_grenade/incendiary,
		/obj/item/grenade/chem_grenade/incendiary
	)
	crate_name = "incendiary weapons crate"
	crate_type = /obj/structure/closet/crate/secure/plasma
	dangerous = TRUE

/datum/supply_pack/mpc/survival_knife
	name = "Survival Knife"
	desc = "Contains one sharpened survival knife. Guaranteed to fit snugly inside any standard boot."
	cost = PAYCHECK_ASSISTANT * 8.9 + CARGO_CRATE_VALUE
	contains = list(/obj/item/knife/combat/survival)

