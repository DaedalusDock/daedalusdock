/datum/damage_packet
	/// Weapon used to deal damage, if any.
	var/obj/item/weapon
	/// Special attack used, if any.
	var/datum/special_attack/used_special
	/// Damage applied
	var/damage
	/// Damage type
	var/damage_type
	/// Body zone or bodypart hit, if any.
	var/def_zone
	/// The % of damage negated by armor.
	var/armor_block
	/// The direction the attack came from.
	var/attack_direction
	/// The sharpness of the attack.
	var/sharpness
	/// "Forced" usually means the damage cannot be reduced, or something.
	var/forced
	/// If TRUE, spread the damage across multiple limbs instead of just the def_zone.
	var/spread_damage

/datum/damage_packet/New(
	damage,
	damage_type,
	def_zone,
	armor_block,
	forced,
	spread_damage,
	sharpness,
	attack_direction,
	obj/item/attacking_item
)
	src.damage = damage
	src.damage_type = damage_type
	src.def_zone = def_zone
	src.armor_block = armor_block
	src.forced = forced
	src.spread_damage = spread_damage
	src.sharpness = sharpness
	src.attack_direction = attack_direction
	src.weapon = attacking_item

/// Helper for providing intellisense argument autofill.
/proc/create_damage_packet(
	damage,
	damage_type,
	def_zone,
	armor_block,
	forced,
	spread_damage,
	sharpness,
	attack_direction,
	obj/item/attacking_item
) as /datum/damage_packet
	return new /datum/damage_packet(damage, damage_type, def_zone, armor_block, forced, spread_damage, sharpness, attack_direction, attacking_item)

/// Apply the damage packet, deleting it after.
/datum/damage_packet/proc/apply_damage(mob/living/target)
	. = target.apply_damage(
		damage = damage,
		damagetype = damage_type,
		def_zone = def_zone,
		blocked = armor_block,
		forced = forced,
		spread_damage = spread_damage,
		sharpness = sharpness,
		attack_direction = attack_direction,
		attacking_item = weapon,
	)
	qdel(src)
