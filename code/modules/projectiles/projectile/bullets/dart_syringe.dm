/obj/projectile/bullet/dart
	name = "dart"
	icon_state = "cbbolt"
	damage = 1
	embedding = null
	shrapnel_type = null
	var/inject_flags = null

/obj/projectile/bullet/dart/Initialize(mapload)
	. = ..()
	create_reagents(50, NO_REACT)

/obj/projectile/bullet/dart/on_hit(atom/target, blocked = FALSE)
	if(iscarbon(target))
		var/mob/living/carbon/M = target
		if(blocked != 100) // not completely blocked
			if(M.can_inject(target_zone = def_zone, injection_flags = inject_flags)) // Pass the hit zone to see if it can inject by whether it hit the head or the body.
				..()
				inject_hit_target(M)
				return BULLET_ACT_HIT
			else
				blocked = 100
				target.visible_message(span_danger("[src] hits <b>[target]</b> and falls to the ground."))

	..(target, blocked)
	reagents.flags &= ~(NO_REACT)
	reagents.handle_reactions()
	return BULLET_ACT_HIT

/// Called by on_hit if the target passes can_inject()
/obj/projectile/bullet/dart/proc/inject_hit_target(mob/living/carbon/hit)
	reagents.trans_to(hit, reagents.total_volume, methods = INJECT)

/obj/projectile/bullet/dart/metalfoam/Initialize(mapload)
	. = ..()
	reagents.add_reagent(/datum/reagent/aluminium, 15)
	reagents.add_reagent(/datum/reagent/foaming_agent, 5)
	reagents.add_reagent(/datum/reagent/toxin/acid/fluacid, 5)

/obj/projectile/bullet/dart/syringe
	name = "syringe"
	icon_state = "syringeproj"

/obj/projectile/bullet/dart/syringe/Initialize(mapload)
	. = ..()

	// This prevents the Ody from being used as a combat mech spamming RDX/Teslium syringes all over the place.
	// Other syringe guns are loaded manually with pre-filled syringes which will react chems themselves.
	// The traitor chem dartgun uses /obj/projectile/bullet/dart/piercing, so this does not impact it.
	reagents.flags &= ~NO_REACT

/obj/projectile/bullet/dart/piercing
	inject_flags = INJECT_CHECK_PENETRATE_THICK

/obj/projectile/bullet/dart/haloperidol

/obj/projectile/bullet/dart/haloperidol/Initialize(mapload)
	. = ..()
	reagents.add_reagent(/datum/reagent/medicine/haloperidol, 10)

/obj/projectile/bullet/dart/ryetalyn

/obj/projectile/bullet/dart/ryetalyn/Initialize(mapload)
	. = ..()
	reagents.add_reagent(/datum/reagent/medicine/ryetalyn, 10)
