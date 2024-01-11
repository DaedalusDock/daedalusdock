//Meat Hook

/obj/item/gun/magic/hook
	name = "meat hook"
	desc = "Mid or feed."
	ammo_type = /obj/item/ammo_casing/magic/hook
	icon_state = "hook"
	inhand_icon_state = "hook"
	lefthand_file = 'icons/mob/inhands/weapons/melee_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/melee_righthand.dmi'
	fire_sound = 'sound/weapons/batonextend.ogg'
	pinless = TRUE
	max_charges = 1
	item_flags = NEEDS_PERMIT | NOBLUDGEON
	sharpness = SHARP_POINTY
	force = 18

/obj/item/gun/magic/hook/shoot_with_empty_chamber(mob/living/user)
	to_chat(user, span_warning("[src] isn't ready to fire yet!"))

/obj/item/ammo_casing/magic/hook
	name = "hook"
	desc = "A hook."
	projectile_type = /obj/projectile/hook
	caliber = CALIBER_HOOK
	icon_state = "hook"
	firing_effect_type = /obj/effect/temp_visual/dir_setting/firing_effect/energy

/obj/projectile/hook
	name = "hook"
	icon_state = "hook"
	icon = 'icons/obj/lavaland/artefacts.dmi'
	pass_flags = PASSTABLE
	damage = 20
	stamina = 20
	armor_penetration = 60
	damage_type = BRUTE
	hitsound = 'sound/effects/splat.ogg'
	var/chain
	var/knockdown_time = (0.5 SECONDS)
	var/chain_iconstate = "chain"

/obj/projectile/hook/fire(setAngle)
	if(firer)
		chain = firer.Beam(src, icon_state = "chain", emissive = FALSE)
	..()
	//TODO: root the firer until the chain returns

/obj/projectile/hook/on_hit(atom/target)
	. = ..()
	if(ismovable(target))
		var/atom/movable/A = target
		if(A.anchored)
			return
		A.visible_message(span_danger("[A] is snagged by [firer]'s hook!"))
		//Should really be a movement loop, but I don't want to support moving 5 tiles a tick
		//It just looks bad
		new /datum/forced_movement(A, get_turf(firer), 5, TRUE)
		if (isliving(target))
			var/mob/living/fresh_meat = target
			fresh_meat.Knockdown(knockdown_time)
			return
		//TODO: keep the chain beamed to A
		//TODO: needs a callback to delete the chain

/obj/projectile/hook/Destroy()
	qdel(chain)
	return ..()

//just a nerfed version of the real thing for the bounty hunters.
/obj/item/gun/magic/hook/bounty
	name = "hook"
	ammo_type = /obj/item/ammo_casing/magic/hook/bounty

/obj/item/ammo_casing/magic/hook/bounty
	projectile_type = /obj/projectile/hook/bounty

/obj/projectile/hook/bounty
	damage = 0
	stamina = 40

/// non-damaging version for contractor MODsuits
/obj/item/gun/magic/hook/contractor
	name = "SCORPION hook"
	desc = "A hardlight hook used to non-lethally pull targets much closer to the user."
	icon_state = "contractor_hook"
	inhand_icon_state = "" //nah
	ammo_type = /obj/item/ammo_casing/magic/hook/contractor

/obj/item/ammo_casing/magic/hook/contractor
	projectile_type = /obj/projectile/hook/contractor

/obj/projectile/hook/contractor
	icon_state = "contractor_hook"
	damage = 0
	stamina = 25
	chain_iconstate = "contractor_chain"

/obj/item/gun/magic/hook/contractor/do_fire_gun(atom/target, mob/living/user, message, params, zone_override, bonus_spread)
	if(prob(1))
		user.say("+GET OVER HERE!+", forced = "scorpion hook")
	return ..()
