TYPEINFO_DEF(/obj/item/clothing/under/rank/medical)
	default_armor = list(BLUNT = 0, PUNCTURE = 0, SLASH = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 10, FIRE = 0, ACID = 0)

/obj/item/clothing/under/rank/medical
	icon = 'icons/obj/clothing/under/medical.dmi'
	worn_icon = 'icons/mob/clothing/under/medical.dmi'
	permeability_coefficient = 0.5

/obj/item/clothing/under/rank/medical/doctor
	desc = "It's made of a special fiber that provides minor protection against biohazards. It has a cross on the chest denoting that the wearer is trained medical personnel."
	name = "medical doctor's jumpsuit"
	icon_state = "medical"
	inhand_icon_state = "w_suit"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION | CLOTHING_TESHARI_VARIATION | CLOTHING_VOX_VARIATION

/obj/item/clothing/under/rank/medical/doctor/skirt
	name = "medical doctor's jumpskirt"
	desc = "It's made of a special fiber that provides minor protection against biohazards. It has a cross on the chest denoting that the wearer is trained medical personnel."
	icon_state = "medical_skirt"
	inhand_icon_state = "w_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON | CLOTHING_TESHARI_VARIATION | CLOTHING_VOX_VARIATION

/obj/item/clothing/under/rank/medical/chief_medical_officer
	desc = "It's a jumpsuit worn by those with the experience to be \"Medical Director\". It provides minor biological protection."
	name = "medical director's jumpsuit"
	icon_state = "cmo"
	inhand_icon_state = "w_suit"

/obj/item/clothing/under/rank/medical/chief_medical_officer/skirt
	name = "medical director's jumpskirt"
	desc = "It's a jumpskirt worn by those with the experience to be \"Medical Director\". It provides minor biological protection."
	icon_state = "cmo_skirt"
	inhand_icon_state = "w_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON | CLOTHING_TESHARI_VARIATION | CLOTHING_VOX_VARIATION

/obj/item/clothing/under/rank/medical/chief_medical_officer/turtleneck
	name = "medical director's turtleneck"
	desc = "A light blue turtleneck and tan khakis, for a medical director with a superior sense of style."
	icon_state = "cmoturtle"
	inhand_icon_state = "b_suit"
	can_adjust = TRUE
	alt_covers_chest = TRUE
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY

/obj/item/clothing/under/rank/medical/chief_medical_officer/turtleneck/skirt
	name = "medical director's turtleneck skirt"
	desc = "A light blue turtleneck and tan khaki skirt, for a medical director with a superior sense of style."
	icon_state = "cmoturtle_skirt"
	inhand_icon_state = "b_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	supports_variations_flags =  CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON | CLOTHING_TESHARI_VARIATION | CLOTHING_VOX_VARIATION

/obj/item/clothing/under/rank/medical/virologist
	desc = "It's made of a special fiber that gives special protection against biohazards. It has a virologist rank stripe on it."
	name = "virologist's jumpsuit"
	icon_state = "virology"
	inhand_icon_state = "w_suit"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION | CLOTHING_TESHARI_VARIATION | CLOTHING_VOX_VARIATION

/obj/item/clothing/under/rank/medical/virologist/skirt
	name = "virologist's jumpskirt"
	desc = "It's made of a special fiber that gives special protection against biohazards. It has a virologist rank stripe on it."
	icon_state = "virologywhite_skirt"
	inhand_icon_state = "w_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON | CLOTHING_TESHARI_VARIATION | CLOTHING_VOX_VARIATION

/obj/item/clothing/under/rank/medical/scrubs
	name = "medical scrubs"
	can_adjust = FALSE

/obj/item/clothing/under/rank/medical/scrubs/blue
	desc = "It's made of a special fiber that provides minor protection against biohazards. This one is in baby blue."
	icon_state = "scrubsblue"

/obj/item/clothing/under/rank/medical/scrubs/green
	desc = "It's made of a special fiber that provides minor protection against biohazards. This one is in dark green."
	icon_state = "scrubsgreen"

/obj/item/clothing/under/rank/medical/scrubs/purple
	desc = "It's made of a special fiber that provides minor protection against biohazards. This one is in deep purple."
	icon_state = "scrubspurple"

TYPEINFO_DEF(/obj/item/clothing/under/rank/medical/chemist)
	default_armor = list(BLUNT = 0, PUNCTURE = 0, SLASH = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 10, FIRE = 50, ACID = 65)

/obj/item/clothing/under/rank/medical/chemist
	desc = "It's made of a special fiber that gives special protection against biohazards. It has a chemist rank stripe on it."
	name = "chemist's jumpsuit"
	icon_state = "chemistry"
	inhand_icon_state = "w_suit"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION | CLOTHING_TESHARI_VARIATION | CLOTHING_VOX_VARIATION

/obj/item/clothing/under/rank/medical/chemist/skirt
	name = "chemist's jumpskirt"
	desc = "It's made of a special fiber that gives special protection against biohazards. It has a chemist rank stripe on it."
	icon_state = "chemistrywhite_skirt"
	inhand_icon_state = "w_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON | CLOTHING_TESHARI_VARIATION | CLOTHING_VOX_VARIATION

/obj/item/clothing/under/rank/medical/paramedic
	desc = "It's made of a special fiber that provides minor protection against biohazards. It has a dark blue cross on the chest denoting that the wearer is a trained paramedic."
	name = "paramedic jumpsuit"
	icon_state = "paramedic"
	inhand_icon_state = "w_suit"
	alt_covers_chest = TRUE
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION | CLOTHING_TESHARI_VARIATION | CLOTHING_VOX_VARIATION

/obj/item/clothing/under/rank/medical/paramedic/skirt
	name = "paramedic jumpskirt"
	desc = "It's made of a special fiber that provides minor protection against biohazards. It has a dark blue cross on the chest denoting that the wearer is a trained paramedic."
	icon_state = "paramedic_skirt"
	inhand_icon_state = "w_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON | CLOTHING_TESHARI_VARIATION | CLOTHING_VOX_VARIATION

/obj/item/clothing/under/rank/medical/doctor/nurse
	desc = "It's a jumpsuit commonly worn by nursing staff in the medical department."
	name = "nurse's suit"
	icon_state = "nursesuit"
	inhand_icon_state = "w_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	female_sprite_flags = NO_FEMALE_UNIFORM
	can_adjust = FALSE
