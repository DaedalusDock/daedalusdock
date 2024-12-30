///SNAIL
/obj/item/bodypart/head/snail
	limb_id = SPECIES_SNAIL
	is_dimorphic = FALSE

/obj/item/bodypart/chest/snail
	limb_id = SPECIES_SNAIL
	is_dimorphic = FALSE

/obj/item/bodypart/arm/left/snail
	limb_id = SPECIES_SNAIL
	unarmed_attack_verb = "slap"
	unarmed_attack_effect = ATTACK_EFFECT_DISARM
	unarmed_damage_high = 0.5 //snails are soft and squishy


/obj/item/bodypart/arm/right/snail
	limb_id = SPECIES_SNAIL
	unarmed_attack_verb = "slap"
	unarmed_attack_effect = ATTACK_EFFECT_DISARM
	unarmed_damage_high = 0.5

/obj/item/bodypart/leg/left/snail
	limb_id = SPECIES_SNAIL
	unarmed_damage_high = 0.5
/obj/item/bodypart/leg/right/snail
	limb_id = SPECIES_SNAIL
	unarmed_damage_high = 0.5

///ABDUCTOR
/obj/item/bodypart/head/abductor
	limb_id = SPECIES_ABDUCTOR
	is_dimorphic = FALSE
	should_draw_greyscale = FALSE

	bodypart_flags = parent_type::bodypart_flags & ~BP_HAS_BLOOD

/obj/item/bodypart/chest/abductor
	limb_id = SPECIES_ABDUCTOR
	is_dimorphic = FALSE
	should_draw_greyscale = FALSE

	bodypart_flags = parent_type::bodypart_flags & ~BP_HAS_BLOOD

/obj/item/bodypart/arm/left/abductor
	limb_id = SPECIES_ABDUCTOR
	should_draw_greyscale = FALSE
	bodypart_traits = list(TRAIT_CHUNKYFINGERS)

	bodypart_flags = parent_type::bodypart_flags & ~BP_HAS_BLOOD

/obj/item/bodypart/arm/right/abductor
	limb_id = SPECIES_ABDUCTOR
	should_draw_greyscale = FALSE
	bodypart_traits = list(TRAIT_CHUNKYFINGERS)

	bodypart_flags = parent_type::bodypart_flags & ~BP_HAS_BLOOD

/obj/item/bodypart/leg/left/abductor
	limb_id = SPECIES_ABDUCTOR
	should_draw_greyscale = FALSE

	bodypart_flags = parent_type::bodypart_flags & ~BP_HAS_BLOOD

/obj/item/bodypart/leg/right/abductor
	limb_id = SPECIES_ABDUCTOR
	should_draw_greyscale = FALSE

	bodypart_flags = parent_type::bodypart_flags & ~BP_HAS_BLOOD

///JELLY
/obj/item/bodypart/head/jelly
	limb_id = SPECIES_JELLYPERSON
	is_dimorphic = TRUE
	icon_dmg_overlay = null

	bodypart_flags = parent_type::bodypart_flags & ~(BP_HAS_BLOOD|BP_HAS_BONES|BP_HAS_TENDON|BP_HAS_ARTERY)

/obj/item/bodypart/chest/jelly
	limb_id = SPECIES_JELLYPERSON
	is_dimorphic = TRUE
	icon_dmg_overlay = null

	bodypart_flags = parent_type::bodypart_flags & ~(BP_HAS_BLOOD|BP_HAS_BONES|BP_HAS_TENDON|BP_HAS_ARTERY)

/obj/item/bodypart/arm/left/jelly
	limb_id = SPECIES_JELLYPERSON
	icon_dmg_overlay = null

	bodypart_flags = parent_type::bodypart_flags & ~(BP_HAS_BLOOD|BP_HAS_BONES|BP_HAS_TENDON|BP_HAS_ARTERY)

/obj/item/bodypart/arm/right/jelly
	limb_id = SPECIES_JELLYPERSON
	icon_dmg_overlay = null

	bodypart_flags = parent_type::bodypart_flags & ~(BP_HAS_BLOOD|BP_HAS_BONES|BP_HAS_TENDON|BP_HAS_ARTERY)

/obj/item/bodypart/leg/left/jelly
	limb_id = SPECIES_JELLYPERSON
	icon_dmg_overlay = null

	bodypart_flags = parent_type::bodypart_flags & ~(BP_HAS_BLOOD|BP_HAS_BONES|BP_HAS_TENDON|BP_HAS_ARTERY)

/obj/item/bodypart/leg/right/jelly
	limb_id = SPECIES_JELLYPERSON
	icon_dmg_overlay = null

	bodypart_flags = parent_type::bodypart_flags & ~(BP_HAS_BLOOD|BP_HAS_BONES|BP_HAS_TENDON|BP_HAS_ARTERY)

///SLIME
/obj/item/bodypart/head/slime
	limb_id = SPECIES_SLIMEPERSON
	is_dimorphic = FALSE
	bodypart_flags = parent_type::bodypart_flags & ~(BP_HAS_BLOOD|BP_HAS_BONES|BP_HAS_TENDON|BP_HAS_ARTERY)

/obj/item/bodypart/chest/slime
	limb_id = SPECIES_SLIMEPERSON
	is_dimorphic = TRUE
	bodypart_flags = parent_type::bodypart_flags & ~(BP_HAS_BLOOD|BP_HAS_BONES|BP_HAS_TENDON|BP_HAS_ARTERY)

/obj/item/bodypart/arm/left/slime
	limb_id = SPECIES_SLIMEPERSON
	bodypart_flags = parent_type::bodypart_flags & ~(BP_HAS_BLOOD|BP_HAS_BONES|BP_HAS_TENDON|BP_HAS_ARTERY)

/obj/item/bodypart/arm/right/slime
	limb_id = SPECIES_SLIMEPERSON
	bodypart_flags = parent_type::bodypart_flags & ~(BP_HAS_BLOOD|BP_HAS_BONES|BP_HAS_TENDON|BP_HAS_ARTERY)

/obj/item/bodypart/leg/left/slime
	limb_id = SPECIES_SLIMEPERSON
	bodypart_flags = parent_type::bodypart_flags & ~(BP_HAS_BLOOD|BP_HAS_BONES|BP_HAS_TENDON|BP_HAS_ARTERY)

/obj/item/bodypart/leg/right/slime
	limb_id = SPECIES_SLIMEPERSON
	bodypart_flags = parent_type::bodypart_flags & ~(BP_HAS_BLOOD|BP_HAS_BONES|BP_HAS_TENDON|BP_HAS_ARTERY)

///LUMINESCENT
/obj/item/bodypart/head/luminescent
	limb_id = SPECIES_LUMINESCENT
	is_dimorphic = TRUE

/obj/item/bodypart/chest/luminescent
	limb_id = SPECIES_LUMINESCENT
	is_dimorphic = TRUE

/obj/item/bodypart/arm/left/luminescent
	limb_id = SPECIES_LUMINESCENT

/obj/item/bodypart/arm/right/luminescent
	limb_id = SPECIES_LUMINESCENT

/obj/item/bodypart/leg/left/luminescent
	limb_id = SPECIES_LUMINESCENT

/obj/item/bodypart/leg/right/luminescent
	limb_id = SPECIES_LUMINESCENT

///ZOMBIE
/obj/item/bodypart/head/zombie
	limb_id = SPECIES_ZOMBIE
	is_dimorphic = FALSE
	should_draw_greyscale = FALSE

/obj/item/bodypart/chest/zombie
	limb_id = SPECIES_ZOMBIE
	is_dimorphic = FALSE
	should_draw_greyscale = FALSE

/obj/item/bodypart/arm/left/zombie
	limb_id = SPECIES_ZOMBIE
	should_draw_greyscale = FALSE

/obj/item/bodypart/arm/right/zombie
	limb_id = SPECIES_ZOMBIE
	should_draw_greyscale = FALSE

/obj/item/bodypart/leg/left/zombie
	limb_id = SPECIES_ZOMBIE
	should_draw_greyscale = FALSE

/obj/item/bodypart/leg/right/zombie
	limb_id = SPECIES_ZOMBIE
	should_draw_greyscale = FALSE

///PODPEOPLE
/obj/item/bodypart/head/pod
	limb_id = SPECIES_PODPERSON
	is_dimorphic = TRUE

/obj/item/bodypart/chest/pod
	limb_id = SPECIES_PODPERSON
	is_dimorphic = TRUE

/obj/item/bodypart/arm/left/pod
	limb_id = SPECIES_PODPERSON
	unarmed_attack_verb = "slash"
	unarmed_attack_effect = ATTACK_EFFECT_CLAW
	unarmed_attack_sound = 'sound/weapons/slice.ogg'
	unarmed_miss_sound = 'sound/weapons/slashmiss.ogg'

/obj/item/bodypart/arm/right/pod
	limb_id = SPECIES_PODPERSON
	unarmed_attack_verb = "slash"
	unarmed_attack_effect = ATTACK_EFFECT_CLAW
	unarmed_attack_sound = 'sound/weapons/slice.ogg'
	unarmed_miss_sound = 'sound/weapons/slashmiss.ogg'

/obj/item/bodypart/leg/left/pod
	limb_id = SPECIES_PODPERSON

/obj/item/bodypart/leg/right/pod
	limb_id = SPECIES_PODPERSON

///FLY
/obj/item/bodypart/head/fly
	limb_id = SPECIES_FLYPERSON
	is_dimorphic = FALSE
	should_draw_greyscale = FALSE

/obj/item/bodypart/chest/fly
	limb_id = SPECIES_FLYPERSON
	is_dimorphic = TRUE
	should_draw_greyscale = FALSE

/obj/item/bodypart/arm/left/fly
	limb_id = SPECIES_FLYPERSON
	should_draw_greyscale = FALSE

/obj/item/bodypart/arm/right/fly
	limb_id = SPECIES_FLYPERSON
	should_draw_greyscale = FALSE

/obj/item/bodypart/leg/left/fly
	limb_id = SPECIES_FLYPERSON
	should_draw_greyscale = FALSE

/obj/item/bodypart/leg/right/fly
	limb_id = SPECIES_FLYPERSON
	should_draw_greyscale = FALSE

///SHADOW
/obj/item/bodypart/head/shadow
	limb_id = SPECIES_SHADOW
	is_dimorphic = FALSE
	should_draw_greyscale = FALSE

/obj/item/bodypart/chest/shadow
	limb_id = SPECIES_SHADOW
	is_dimorphic = FALSE
	should_draw_greyscale = FALSE

/obj/item/bodypart/arm/left/shadow
	limb_id = SPECIES_SHADOW
	should_draw_greyscale = FALSE

/obj/item/bodypart/arm/right/shadow
	limb_id = SPECIES_SHADOW
	should_draw_greyscale = FALSE

/obj/item/bodypart/leg/left/shadow
	limb_id = SPECIES_SHADOW
	should_draw_greyscale = FALSE

/obj/item/bodypart/leg/right/shadow
	limb_id = SPECIES_SHADOW
	should_draw_greyscale = FALSE

/obj/item/bodypart/arm/left/shadow/nightmare
	bodypart_traits = list(TRAIT_CHUNKYFINGERS)

/obj/item/bodypart/arm/right/shadow/nightmare
	bodypart_traits = list(TRAIT_CHUNKYFINGERS)

///SKELETON
/obj/item/bodypart/head/skeleton
	limb_id = SPECIES_SKELETON
	is_dimorphic = FALSE
	should_draw_greyscale = FALSE
	icon_dmg_overlay = null

	bodypart_flags = parent_type::bodypart_flags & ~(BP_HAS_BLOOD)

/obj/item/bodypart/chest/skeleton
	limb_id = SPECIES_SKELETON
	is_dimorphic = FALSE
	should_draw_greyscale = FALSE
	icon_dmg_overlay = null

	bodypart_flags = parent_type::bodypart_flags & ~(BP_HAS_BLOOD)

/obj/item/bodypart/arm/left/skeleton
	limb_id = SPECIES_SKELETON
	should_draw_greyscale = FALSE
	icon_dmg_overlay = null

	bodypart_flags = parent_type::bodypart_flags & ~(BP_HAS_BLOOD)

/obj/item/bodypart/arm/right/skeleton
	limb_id = SPECIES_SKELETON
	should_draw_greyscale = FALSE
	icon_dmg_overlay = null

	bodypart_flags = parent_type::bodypart_flags & ~(BP_HAS_BLOOD)

/obj/item/bodypart/leg/left/skeleton
	limb_id = SPECIES_SKELETON
	should_draw_greyscale = FALSE
	icon_dmg_overlay = null

	bodypart_flags = parent_type::bodypart_flags & ~(BP_HAS_BLOOD)

/obj/item/bodypart/leg/right/skeleton
	limb_id = SPECIES_SKELETON
	should_draw_greyscale = FALSE
	icon_dmg_overlay = null

	bodypart_flags = parent_type::bodypart_flags & ~(BP_HAS_BLOOD)

///MUSHROOM
/obj/item/bodypart/head/mushroom
	limb_id = SPECIES_MUSHROOM
	is_dimorphic = TRUE

/obj/item/bodypart/chest/mushroom
	limb_id = SPECIES_MUSHROOM
	is_dimorphic = TRUE

/obj/item/bodypart/arm/left/mushroom
	limb_id = SPECIES_MUSHROOM
	unarmed_damage_low = 6
	unarmed_damage_high = 14
	unarmed_stun_threshold = 14

/obj/item/bodypart/arm/right/mushroom
	limb_id = SPECIES_MUSHROOM
	unarmed_damage_low = 6
	unarmed_damage_high = 14
	unarmed_stun_threshold = 14

/obj/item/bodypart/leg/left/mushroom
	limb_id = SPECIES_MUSHROOM
	unarmed_damage_low = 9
	unarmed_damage_high = 21
	unarmed_stun_threshold = 14

/obj/item/bodypart/leg/right/mushroom
	limb_id = SPECIES_MUSHROOM
	unarmed_damage_low = 9
	unarmed_damage_high = 21
	unarmed_stun_threshold = 14
