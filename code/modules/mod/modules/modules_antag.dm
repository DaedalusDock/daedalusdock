//Antag modules for MODsuits

///Armor Booster - Grants your suit more armor and speed in exchange for EVA protection. Also acts as a welding screen.
/obj/item/mod/module/armor_booster
	name = "MOD armor booster module"
	desc = "A retrofitted series of retractable armor plates, allowing the suit to function as essentially power armor, \
		giving the user incredible protection against conventional firearms, or everyday attacks in close-quarters. \
		However, the additional plating cannot deploy alongside parts of the suit used for vacuum sealing, \
		so this extra armor provides zero ability for extravehicular activity while deployed."
	icon_state = "armor_booster"
	module_type = MODULE_TOGGLE
	active_power_cost = DEFAULT_CHARGE_DRAIN * 0.3
	removable = FALSE
	incompatible_modules = list(/obj/item/mod/module/armor_booster, /obj/item/mod/module/welding)
	cooldown_time = 0.5 SECONDS
	overlay_state_inactive = "module_armorbooster_off"
	overlay_state_active = "module_armorbooster_on"
	use_mod_colors = TRUE
	/// Whether or not this module removes pressure protection.
	var/remove_pressure_protection = TRUE
	/// Slowdown added to the suit.
	var/added_slowdown = -0.5
	/// Armor values added to the suit parts.
	var/list/armor_values = list(BLUNT = 25, PUNCTURE = 30, LASER = 15, ENERGY = 15)
	/// List of parts of the suit that are spaceproofed, for giving them back the pressure protection.
	var/list/spaceproofed = list()

/obj/item/mod/module/armor_booster/on_suit_activation()
	var/obj/item/clothing/head_cover = mod.get_part_from_slot(ITEM_SLOT_HEAD) || mod.get_part_from_slot(ITEM_SLOT_MASK) || mod.get_part_from_slot(ITEM_SLOT_EYES)
	if(istype(head_cover))
		head_cover.flash_protect = FLASH_PROTECTION_WELDER

/obj/item/mod/module/armor_booster/on_suit_deactivation(deleting = FALSE)
	if(deleting)
		return

	var/obj/item/clothing/head_cover = mod.get_part_from_slot(ITEM_SLOT_HEAD) || mod.get_part_from_slot(ITEM_SLOT_MASK) || mod.get_part_from_slot(ITEM_SLOT_EYES)
	if(istype(head_cover))
		head_cover.flash_protect = initial(head_cover.flash_protect)

/obj/item/mod/module/armor_booster/on_activation()
	playsound(src, 'sound/mecha/mechmove03.ogg', 25, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
	mod.slowdown += added_slowdown
	mod.wearer.update_equipment_speed_mods()

	for(var/obj/item/part as anything in mod.get_parts(include_control = TRUE))
		part.setArmor(part.returnArmor().modifyRating(arglist(armor_values)))
		if(!remove_pressure_protection || !isclothing(part))
			continue

		var/obj/item/clothing/clothing_part = part
		if(clothing_part.clothing_flags & STOPSPRESSUREDAMAGE)
			clothing_part.clothing_flags &= ~STOPSPRESSUREDAMAGE
			spaceproofed[clothing_part] = TRUE

/obj/item/mod/module/armor_booster/on_deactivation(display_message = TRUE, deleting = FALSE)
	if(!deleting)
		playsound(src, 'sound/mecha/mechmove03.ogg', 25, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)

	mod.slowdown -= added_slowdown
	mod.wearer.update_equipment_speed_mods()
	var/list/removed_armor = armor_values.Copy()
	for(var/armor_type in removed_armor)
		removed_armor[armor_type] = -removed_armor[armor_type]

	for(var/obj/item/part as anything in mod.get_parts(include_control = TRUE))
		part.setArmor(part.returnArmor().modifyRating(arglist(removed_armor)))
		if(!remove_pressure_protection || !isclothing(part))
			continue

		var/obj/item/clothing/clothing_part = part
		if(spaceproofed[clothing_part])
			clothing_part.clothing_flags |= STOPSPRESSUREDAMAGE

	spaceproofed = list()

/obj/item/mod/module/armor_booster/generate_worn_overlay(mutable_appearance/standing)
	overlay_state_inactive = "[initial(overlay_state_inactive)]-[mod.skin]"
	overlay_state_active = "[initial(overlay_state_active)]-[mod.skin]"
	return ..()

///Energy Shield - Gives you a rechargeable energy shield that nullifies attacks.
/obj/item/mod/module/energy_shield
	name = "MOD energy shield module"
	desc = "A personal, protective forcefield typically seen in military applications. \
		This advanced deflector shield is essentially a scaled down version of those seen on starships, \
		and the power cost can be an easy indicator of this. However, it is capable of blocking nearly any incoming attack, \
		though with its' low amount of separate charges, the user remains mortal."
	icon_state = "energy_shield"
	complexity = 3
	idle_power_cost = DEFAULT_CHARGE_DRAIN * 0.5
	use_power_cost = DEFAULT_CHARGE_DRAIN * 2
	incompatible_modules = list(/obj/item/mod/module/energy_shield)
	required_slots = list(ITEM_SLOT_BACK)
	/// Max charges of the shield.
	var/max_charges = 3
	/// The time it takes for the first charge to recover.
	var/recharge_start_delay = 20 SECONDS
	/// How much time it takes for charges to recover after they started recharging.
	var/charge_increment_delay = 1 SECONDS
	/// How much charge is recovered per recovery.
	var/charge_recovery = 1
	/// Whether or not this shield can lose multiple charges.
	var/lose_multiple_charges = FALSE
	/// The item path to recharge this shielkd.
	var/recharge_path = null
	/// The icon file of the shield.
	var/shield_icon_file = 'icons/effects/effects.dmi'
	/// The icon_state of the shield.
	var/shield_icon = "shield-red"
	/// Charges the shield should start with.
	var/charges

/obj/item/mod/module/energy_shield/Initialize(mapload)
	. = ..()
	charges = max_charges

/obj/item/mod/module/energy_shield/on_suit_activation()
	mod.AddComponent(/datum/component/shielded, max_charges = max_charges, recharge_start_delay = recharge_start_delay, charge_increment_delay = charge_increment_delay, \
	charge_recovery = charge_recovery, lose_multiple_charges = lose_multiple_charges, recharge_path = recharge_path, starting_charges = charges, shield_icon_file = shield_icon_file, shield_icon = shield_icon)
	RegisterSignal(mod.wearer, COMSIG_LIVING_CHECK_BLOCK, PROC_REF(shield_reaction))

/obj/item/mod/module/energy_shield/on_suit_deactivation(deleting = FALSE)
	var/datum/component/shielded/shield = mod.GetComponent(/datum/component/shielded)
	charges = shield.current_charges
	qdel(shield)
	UnregisterSignal(mod.wearer, COMSIG_LIVING_CHECK_BLOCK)

/obj/item/mod/module/energy_shield/proc/shield_reaction(mob/living/carbon/human/owner, atom/movable/hitby, damage = 0, attack_text = "the attack", attack_type = MELEE_ATTACK, armor_penetration = 0)
	if(SEND_SIGNAL(mod, COMSIG_ITEM_CHECK_BLOCK, owner, hitby, attack_text, 0, damage, attack_type) & COMPONENT_CHECK_BLOCK_BLOCKED)
		drain_power(use_power_cost)
		return SUCCESSFUL_BLOCK
	return NONE

/obj/item/mod/module/energy_shield/wizard
	name = "MOD battlemage shield module"
	desc = "The caster wielding this spell gains a visible barrier around them, channeling arcane power through \
		specialized runes engraved onto the surface of the suit to generate a wall of force. \
		This shield can perfectly nullify attacks ranging from high-caliber rifles to magic missiles, \
		though can also be drained by more mundane attacks. It will not protect the caster from social ridicule."
	icon_state = "battlemage_shield"
	idle_power_cost = DEFAULT_CHARGE_DRAIN * 0 //magic
	use_power_cost = DEFAULT_CHARGE_DRAIN * 0 //magic too
	max_charges = 15
	recharge_start_delay = 0 SECONDS
	charge_recovery = 8
	shield_icon_file = 'icons/effects/magic.dmi'
	shield_icon = "mageshield"
	recharge_path = /obj/item/wizard_armour_charge
	required_slots = list()

///Magic Nullifier - Protects you from magic.
/obj/item/mod/module/anti_magic
	name = "MOD magic nullifier module"
	desc = "A series of obsidian rods installed into critical points around the suit, \
		vibrated at a certain low frequency to enable them to resonate. \
		This creates a low-range, yet strong, magic nullification field around the user, \
		aided by a full replacement of the suit's normal coolant with holy water. \
		Spells will spall right off this field, though it'll do nothing to help others believe you about all this."
	icon_state = "magic_nullifier"
	removable = FALSE
	incompatible_modules = list(/obj/item/mod/module/anti_magic)
	required_slots = list(ITEM_SLOT_BACK)

/obj/item/mod/module/anti_magic/on_suit_activation()
	ADD_TRAIT(mod.wearer, TRAIT_ANTIMAGIC, MOD_TRAIT)
	ADD_TRAIT(mod.wearer, TRAIT_HOLY, MOD_TRAIT)

/obj/item/mod/module/anti_magic/on_suit_deactivation(deleting = FALSE)
	REMOVE_TRAIT(mod.wearer, TRAIT_ANTIMAGIC, MOD_TRAIT)
	REMOVE_TRAIT(mod.wearer, TRAIT_HOLY, MOD_TRAIT)

/obj/item/mod/module/anti_magic/wizard
	name = "MOD magic neutralizer module"
	desc = "The caster wielding this spell gains an invisible barrier around them, channeling arcane power through \
		specialized runes engraved onto the surface of the suit to generate anti-magic field. \
		The field will neutralize all magic that comes into contact with the user. \
		It will not protect the caster from social ridicule."
	icon_state = "magic_neutralizer"
	required_slots = list()

/obj/item/mod/module/anti_magic/wizard/on_suit_activation()
	ADD_TRAIT(mod.wearer, TRAIT_ANTIMAGIC_NO_SELFBLOCK, MOD_TRAIT)

/obj/item/mod/module/anti_magic/wizard/on_suit_deactivation(deleting = FALSE)
	REMOVE_TRAIT(mod.wearer, TRAIT_ANTIMAGIC_NO_SELFBLOCK, MOD_TRAIT)

///Insignia - Gives you a skin specific stripe.
/obj/item/mod/module/insignia
	name = "MOD insignia module"
	desc = "Despite the existence of IFF systems, radio communique, and modern methods of deductive reasoning involving \
		the wearer's own eyes, colorful paint jobs remain a popular way for different factions in the galaxy to display who \
		they are. This system utilizes a series of tiny moving paint sprayers to both apply and remove different \
		color patterns to and from the suit."
	icon_state = "insignia"
	removable = FALSE
	incompatible_modules = list(/obj/item/mod/module/insignia)
	overlay_state_inactive = "module_insignia"

/obj/item/mod/module/insignia/generate_worn_overlay(mutable_appearance/standing)
	overlay_state_inactive = "[initial(overlay_state_inactive)]-[mod.skin]"
	. = ..()
	for(var/mutable_appearance/appearance as anything in .)
		appearance.color = color

/obj/item/mod/module/insignia/commander
	color = "#4980a5"

/obj/item/mod/module/insignia/security
	color = "#b30d1e"

/obj/item/mod/module/insignia/engineer
	color = "#e9c80e"

/obj/item/mod/module/insignia/medic
	color = "#ebebf5"

/obj/item/mod/module/insignia/janitor
	color = "#7925c7"

/obj/item/mod/module/insignia/clown
	color = "#ff1fc7"

/obj/item/mod/module/insignia/chaplain
	color = "#f0a00c"

///Anti Slip - Prevents you from slipping on water.
/obj/item/mod/module/noslip
	name = "MOD anti slip module"
	desc = "These are a modified variant of standard magnetic boots, utilizing piezoelectric crystals on the soles. \
		The two plates on the bottom of the boots automatically extend and magnetize as the user steps; \
		a pull that's too weak to offer them the ability to affix to a hull, but just strong enough to \
		protect against the fact that you didn't read the wet floor sign. Honk Co. has come out numerous times \
		in protest of these modules being legal."
	icon_state = "noslip"
	complexity = 1
	idle_power_cost = DEFAULT_CHARGE_DRAIN * 0.1
	incompatible_modules = list(/obj/item/mod/module/noslip)
	required_slots = list(ITEM_SLOT_FEET)

/obj/item/mod/module/noslip/on_suit_activation()
	ADD_TRAIT(mod.wearer, TRAIT_NO_SLIP_WATER, MOD_TRAIT)

/obj/item/mod/module/noslip/on_suit_deactivation(deleting = FALSE)
	REMOVE_TRAIT(mod.wearer, TRAIT_NO_SLIP_WATER, MOD_TRAIT)

/obj/item/mod/module/springlock/bite_of_87

/obj/item/mod/module/springlock/bite_of_87/Initialize(mapload)
	. = ..()
	var/obj/item/mod/module/dna_lock/the_dna_lock_behind_the_slaughter = /obj/item/mod/module/dna_lock
	name = initial(the_dna_lock_behind_the_slaughter.name)
	desc = initial(the_dna_lock_behind_the_slaughter.desc)
	icon_state = initial(the_dna_lock_behind_the_slaughter.icon_state)
	complexity = initial(the_dna_lock_behind_the_slaughter.complexity)
	use_power_cost = initial(the_dna_lock_behind_the_slaughter.use_power_cost)

/obj/item/mod/module/springlock/bite_of_87/on_install()
	mod.activation_step_time *= 0.1

/obj/item/mod/module/springlock/bite_of_87/on_uninstall(deleting = FALSE)
	mod.activation_step_time *= 10

/obj/item/mod/module/springlock/bite_of_87/on_suit_activation()
	..()
	if(SSevents.holidays && SSevents.holidays[APRIL_FOOLS] || prob(1))
		mod.set_mod_color("#b17f00")
		mod.wearer.remove_atom_colour(WASHABLE_COLOUR_PRIORITY) // turns purple guy purple
		mod.wearer.add_atom_colour("#704b96", FIXED_COLOUR_PRIORITY)

///Flamethrower - Launches fire across the area.
/obj/item/mod/module/flamethrower
	name = "MOD flamethrower module"
	desc = "A custom-manufactured flamethrower, used to burn through your path. Burn well."
	icon_state = "flamethrower"
	module_type = MODULE_ACTIVE
	complexity = 3
	use_power_cost = DEFAULT_CHARGE_DRAIN * 3
	incompatible_modules = list(/obj/item/mod/module/flamethrower)
	cooldown_time = 2.5 SECONDS
	overlay_state_inactive = "module_flamethrower"
	overlay_state_active = "module_flamethrower_on"

/obj/item/mod/module/flamethrower/on_select_use(atom/target)
	. = ..()
	if(!.)
		return
	var/obj/projectile/flame = new /obj/projectile/bullet/incendiary/backblast/flamethrower(mod.wearer.loc)
	flame.preparePixelProjectile(target, mod.wearer)
	flame.firer = mod.wearer
	playsound(src, 'sound/items/modsuit/flamethrower.ogg', 75, TRUE)
	INVOKE_ASYNC(flame, TYPE_PROC_REF(/obj/projectile, fire))
	drain_power(use_power_cost)

/obj/projectile/bullet/incendiary/backblast/flamethrower
	range = 6

/// Chameleon - Allows you to disguise your modsuit as another type
/obj/item/mod/module/chameleon
	name = "MOD chameleon module"
	desc = "An illegal module that lets you disguise your MODsuit as any other kind with the help of chameleon technology. However, due to technological challenges, the module only functions when the MODsuit is undeployed."
	icon_state = "chameleon"
	module_type = MODULE_USABLE
	active_power_cost = DEFAULT_CHARGE_DRAIN * 0.25
	removable = FALSE
	incompatible_modules = list(/obj/item/mod/module/chameleon)
	cooldown_time = 0.5 SECONDS
	/// All of these below are the stored MODsuit original stats
	var/chameleon_type = /obj/item/mod/control
	var/chameleon_name
	var/chameleon_desc
	var/chameleon_icon_state
	var/chameleon_icon
	var/chameleon_worn_icon
	var/chameleon_left
	var/chameleon_right
	/// MODsuit controllers that aren't allowed
	var/list/chameleon_blacklist = list()
	/// List of MODsuits that can be used
	var/list/chameleon_list = list()
	/// If the module's in use or not
	var/on = FALSE

/obj/item/mod/module/chameleon/Initialize(mapload)
	. = ..()
	init_chameleon_list()

/obj/item/mod/module/chameleon/on_select()
	if(!length(chameleon_list))
		init_chameleon_list()
	for(var/obj/item/part as anything in mod.mod_parts)
		if(!(part.loc == mod.wearer))
			continue
		balloon_alert(mod.wearer, "parts cannot be deployed to use this!")
		playsound(mod, 'sound/machines/scanbuzz.ogg', 25, TRUE, SILENCED_SOUND_EXTRARANGE)
		return FALSE
	used()
	SEND_SIGNAL(mod, COMSIG_MOD_MODULE_SELECTED, src)

/obj/item/mod/module/chameleon/on_use()
	var/obj/item/picked_item
	var/picked_name = tgui_input_list(mod.wearer, "Select [chameleon_name] to change into", "Chameleon Settings", sort_list(chameleon_list, GLOBAL_PROC_REF(cmp_typepaths_asc)))
	if(isnull(picked_name) || isnull(chameleon_list[picked_name]))
		return
	picked_item = chameleon_list[picked_name]
	update_look(mod.wearer, picked_item)

/obj/item/mod/module/chameleon/on_install()
	chameleon_name = mod.name
	chameleon_desc = mod.desc
	chameleon_icon_state = "[mod.skin]-[initial(mod.icon_state)]"
	chameleon_icon = mod.icon
	chameleon_worn_icon = initial(mod.worn_icon)
	chameleon_left = initial(mod.lefthand_file)
	chameleon_right = initial(mod.righthand_file)
	RegisterSignal(mod, COMSIG_MOD_ACTIVATE, PROC_REF(reset_chameleon))

/obj/item/mod/module/chameleon/on_uninstall(deleting = FALSE)
	UnregisterSignal(mod, COMSIG_MOD_ACTIVATE)
	reset_chameleon()

/obj/item/mod/module/chameleon/proc/reset_chameleon()
	if(on)
		balloon_alert(mod.wearer, "chameleon module disabled!")
	for(var/obj/item/mod/module/storage/syndicate/synd_store in mod.modules)
		synd_store.name = initial(synd_store.name)
		synd_store.chameleon_disguised = FALSE
	on = FALSE
	mod.name = chameleon_name
	mod.desc = chameleon_desc
	mod.icon_state = chameleon_icon_state
	mod.icon = chameleon_icon
	mod.worn_icon = chameleon_worn_icon
	mod.lefthand_file = chameleon_left
	mod.righthand_file = chameleon_right

/obj/item/mod/module/chameleon/proc/update_look(mob/living/user, obj/item/picked_item)
	if(!isliving(user))
		return
	var/datum/storage/holding_storage = mod.loc.atom_storage
	if(!holding_storage || holding_storage.max_specific_storage >= mod.w_class)
		return

	update_item(picked_item)
	for(var/obj/item/mod/module/storage/syndicate/synd_store in mod.modules)
		synd_store.name = "MOD expanded storage module"
		synd_store.chameleon_disguised = TRUE
	var/obj/item/thing = mod
	thing.update_slot_icon()
	on = TRUE

/obj/item/mod/module/chameleon/proc/update_item(obj/item/picked_item)
	var/obj/item/mod/control/modsuit = new picked_item() //initial() doesn't work for a ton of these.
	mod.name = modsuit.name
	mod.desc = modsuit.desc
	mod.icon_state = modsuit.icon_state
	mod.worn_icon = modsuit.worn_icon
	mod.lefthand_file = modsuit.lefthand_file
	mod.righthand_file = modsuit.righthand_file
	if(modsuit.greyscale_colors)
		if(modsuit.greyscale_config_worn)
			mod.worn_icon = SSgreyscale.GetColoredIconByType(modsuit.greyscale_config_worn, modsuit.greyscale_colors)
		if(modsuit.greyscale_config_inhand_left)
			mod.lefthand_file = SSgreyscale.GetColoredIconByType(modsuit.greyscale_config_inhand_left, modsuit.greyscale_colors)
		if(modsuit.greyscale_config_inhand_right)
			mod.righthand_file = SSgreyscale.GetColoredIconByType(modsuit.greyscale_config_inhand_right, modsuit.greyscale_colors)
	mod.worn_icon_state = modsuit.worn_icon_state
	mod.inhand_icon_state = modsuit.inhand_icon_state
	if(modsuit.greyscale_config && modsuit.greyscale_colors)
		mod.icon = SSgreyscale.GetColoredIconByType(modsuit.greyscale_config, modsuit.greyscale_colors)
	else
		mod.icon = modsuit.icon
	update_slot_icon()
	qdel(modsuit)

/obj/item/mod/module/chameleon/proc/init_chameleon_list()
	for(var/obj/item/modsuit as anything in typesof(chameleon_type))
		if(chameleon_blacklist[modsuit] || (initial(modsuit.item_flags) & ABSTRACT) || !initial(modsuit.icon_state))
			continue
		var/chameleon_item_name = "[modsuit]"
		chameleon_list[chameleon_item_name] = modsuit

/// Contractor armor booster - Slows you down, gives you armor, makes you lose spaceworthiness
/obj/item/mod/module/armor_booster/contractor // Much flatter distribution because contractor suit gets a shitton of armor already
	armor_values = list(BLUNT = 20, PUNCTURE = 20, LASER = 20, ENERGY = 20)
	added_slowdown = 0.5 //Bulky as shit
	desc = "An embedded set of armor plates, allowing the suit's already extremely high protection \
		to be increased further. However, the plating, while deployed, will slow down the user \
		and make the suit unable to vacuum seal so this extra armor provides zero ability for extravehicular activity while deployed."

/// Non-deathtrap contractor springlock module
/obj/item/mod/module/springlock/contractor
	name = "MOD magnetic deployment module"
	desc = "A much more modern version of a springlock system. \
	This is a module that uses magnets to speed up the deployment and retraction time of your MODsuit."
	icon_state = "magnet_springlock"

/obj/item/mod/module/springlock/contractor/on_suit_activation() // This module is actually *not* a death trap
	return

/obj/item/mod/module/springlock/contractor/on_suit_deactivation(deleting = FALSE)
	return

/// This exists for the adminbus contractor modsuit. Do not use otherwise
/obj/item/mod/module/springlock/contractor/no_complexity
	complexity = 0

/// SCORPION - hook a target into baton range quickly and non-lethally
/obj/item/mod/module/scorpion_hook
	name = "MOD SCORPION hook module"
	desc = "A module installed in the wrist of a MODSuit, this highly \
			illegal module uses a hardlight hook to forcefully pull \
			a target towards you at high speed, knocking them down and \
			partially exhausting them."
	icon_state = "hook"
	incompatible_modules = list(/obj/item/mod/module/scorpion_hook)
	module_type = MODULE_ACTIVE
	complexity = 3
	active_power_cost = DEFAULT_CHARGE_DRAIN * 0.3
	device = /obj/item/gun/magic/hook/contractor
	cooldown_time = 0.5 SECONDS
	allowed_inactive = TRUE
