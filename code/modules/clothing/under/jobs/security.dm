/*
 * Contains:
 * Security
 * Detective
 * Navy uniforms
 */

/*
 * Security
 */

/obj/item/clothing/under/rank/security
	icon = 'icons/obj/clothing/under/security.dmi'
	worn_icon = 'icons/mob/clothing/under/security.dmi'
	sensor_mode = SENSOR_COORDS
	random_sensor = FALSE

//these two are for Mars Executive Outcomes
/obj/item/clothing/under/rank/security/officer
	name = "mars security uniform"
	desc = "A freshly ironed security uniform with Mars-Red slacks. Wearing this almost makes you look professional."
	icon_state = "security"
	inhand_icon_state = "suitsec"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION | CLOTHING_TESHARI_VARIATION | CLOTHING_VOX_VARIATION //need to do these

/obj/item/clothing/under/rank/security/officer/garrison
	name = "mars garrison uniform"
	desc = "An old military outfit, based on the uniforms of the now defunct Martian republic. A bold fashion statement, and a political one!"
	icon_state = "security_garrison"
	inhand_icon_state = "r_suit"
	can_adjust = FALSE
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION | CLOTHING_TESHARI_VARIATION | CLOTHING_VOX_VARIATION //need to do these

//these are old, could be used for non-station roles
/obj/item/clothing/under/rank/security/oldred
	name = "security jumpsuit"
	desc = "A tactical-looking red jumpsuit for corporate security."
	icon_state = "rsecurity"
	inhand_icon_state = "r_suit"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION | CLOTHING_TESHARI_VARIATION | CLOTHING_VOX_VARIATION

/obj/item/clothing/under/rank/security/officer/skirt
	name = "security jumpskirt"
	desc = "A \"tactical\" security jumpsuit with the legs replaced by a skirt."
	icon_state = "secskirt"
	inhand_icon_state = "r_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON | CLOTHING_TESHARI_VARIATION | CLOTHING_VOX_VARIATION

/obj/item/clothing/under/rank/security/officer/blueshirt
	name = "blue shirt and tie"
	desc = "I'm a little busy right now, Calhoun."
	icon_state = "blueshift"
	inhand_icon_state = "blueshift"
	can_adjust = FALSE
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION | CLOTHING_TESHARI_VARIATION | CLOTHING_VOX_VARIATION

/obj/item/clothing/under/rank/security/officer/formal
	name = "security officer's formal uniform"
	desc = "The latest in fashionable security outfits."
	icon_state = "officerblueclothes"
	inhand_icon_state = "officerblueclothes"
	alt_covers_chest = TRUE
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION | CLOTHING_TESHARI_VARIATION | CLOTHING_VOX_VARIATION

/obj/item/clothing/under/rank/security/constable
	name = "constable outfit"
	desc = "A british looking outfit."
	icon_state = "constable"
	inhand_icon_state = "constable"
	can_adjust = FALSE
	custom_price = PAYCHECK_ASSISTANT * 5.6


/obj/item/clothing/under/rank/security/warden
	name = "security suit"
	desc = "A formal security suit for officers complete with Mars belt buckle."
	icon_state = "rwarden"
	inhand_icon_state = "r_suit"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION | CLOTHING_TESHARI_VARIATION | CLOTHING_VOX_VARIATION

/obj/item/clothing/under/rank/security/warden/grey
	name = "grey security suit"
	desc = "A uniform older than the colonization of Mars."
	icon_state = "warden"
	inhand_icon_state = "gy_suit"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION | CLOTHING_TESHARI_VARIATION | CLOTHING_VOX_VARIATION

/obj/item/clothing/under/rank/security/warden/skirt
	name = "warden's suitskirt"
	desc = "A formal security suitskirt for officers complete with Mars belt buckle."
	icon_state = "rwarden_skirt"
	inhand_icon_state = "r_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON | CLOTHING_TESHARI_VARIATION | CLOTHING_VOX_VARIATION

/obj/item/clothing/under/rank/security/warden/formal
	desc = "The insignia on this uniform tells you that this uniform belongs to the Warden."
	name = "warden's formal uniform"
	icon_state = "wardenblueclothes"
	inhand_icon_state = "wardenblueclothes"
	alt_covers_chest = TRUE
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION | CLOTHING_TESHARI_VARIATION | CLOTHING_VOX_VARIATION

/*
 * Detective
 */
/obj/item/clothing/under/rank/security/detective
	name = "hard-worn suit"
	desc = "Someone who wears this means business."
	icon_state = "detective"
	inhand_icon_state = "det"
	alt_covers_chest = TRUE

/obj/item/clothing/under/rank/security/detective/skirt
	name = "private investigator's suitskirt"
	desc = "Someone who wears this means business."
	icon_state = "detective_skirt"
	inhand_icon_state = "det"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	alt_covers_chest = TRUE
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON | CLOTHING_TESHARI_VARIATION | CLOTHING_VOX_VARIATION

/obj/item/clothing/under/rank/security/detective/noir
	name = "noir suit"
	desc = "A hard-boiled private investigator's dark suit, complete with tie clip."
	icon_state = "noirdet"
	inhand_icon_state = "greydet"
	alt_covers_chest = TRUE

/obj/item/clothing/under/rank/security/detective/noir/skirt
	name = "noir suitskirt"
	desc = "A hard-boiled private investigator's grey suitskirt, complete with tie clip."
	icon_state = "noirdet_skirt"
	inhand_icon_state = "greydet"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	alt_covers_chest = TRUE
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/*
 * security marshal
 */
/obj/item/clothing/under/rank/security/marshal
	name = "security marshal's uniform"
	desc = "A crisp mars-red marshal's uniform. Comes with gold trimmed sholder pads and a massive belt buckle to show everyone who's in charge."
	icon_state = "marshal"
	inhand_icon_state = "r_suit"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION | CLOTHING_TESHARI_VARIATION | CLOTHING_VOX_VARIATION //need to do these

//old hos stuff
/obj/item/clothing/under/rank/security/head_of_security
	name = "security marshal's jumpsuit"
	desc = "A security jumpsuit decorated for those few with the dedication to achieve the position of Security Marshal."
	icon_state = "rhos"
	inhand_icon_state = "r_suit"
	strip_delay = 60
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION | CLOTHING_TESHARI_VARIATION | CLOTHING_VOX_VARIATION

/obj/item/clothing/under/rank/security/head_of_security/skirt
	name = "security marshal's jumpskirt"
	desc = "A security jumpskirt decorated for those few with the dedication to achieve the position of Security Marshal."
	icon_state = "rhos_skirt"
	inhand_icon_state = "r_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON | CLOTHING_TESHARI_VARIATION | CLOTHING_VOX_VARIATION

/obj/item/clothing/under/rank/security/head_of_security/grey
	name = "security marshal's grey jumpsuit"
	desc = "There are old men, and there are bold men, but there are very few old, bold men."
	icon_state = "hos"
	inhand_icon_state = "gy_suit"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION | CLOTHING_TESHARI_VARIATION | CLOTHING_VOX_VARIATION

/obj/item/clothing/under/rank/security/head_of_security/alt
	name = "security marshal's turtleneck"
	desc = "A stylish alternative to the normal Security Marshal jumpsuit, complete with tactical pants."
	icon_state = "hosalt"
	inhand_icon_state = "bl_suit"
	alt_covers_chest = TRUE

/obj/item/clothing/under/rank/security/head_of_security/alt/skirt
	name = "security marshal's turtleneck skirt"
	desc = "A stylish alternative to the normal Security Marshal jumpsuit, complete with a tactical skirt."
	icon_state = "hosalt_skirt"
	inhand_icon_state = "bl_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	alt_covers_chest = TRUE
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON | CLOTHING_TESHARI_VARIATION | CLOTHING_VOX_VARIATION

/obj/item/clothing/under/rank/security/head_of_security/parade
	name = "security marshal's parade uniform"
	desc = "A male Security Marshal's luxury-wear, for special occasions."
	icon_state = "hos_parade_male"
	inhand_icon_state = "r_suit"
	can_adjust = FALSE
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION | CLOTHING_TESHARI_VARIATION | CLOTHING_VOX_VARIATION

/obj/item/clothing/under/rank/security/head_of_security/parade/female
	name = "security marshal's parade uniform"
	desc = "A female Security Marshal's luxury-wear, for special occasions."
	icon_state = "hos_parade_fem"
	inhand_icon_state = "r_suit"
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	can_adjust = FALSE

/obj/item/clothing/under/rank/security/head_of_security/formal
	desc = "The insignia on this uniform tells you that this uniform belongs to the Security Marshal."
	name = "security marshal's formal uniform"
	icon_state = "hosblueclothes"
	inhand_icon_state = "hosblueclothes"
	alt_covers_chest = TRUE
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION | CLOTHING_TESHARI_VARIATION | CLOTHING_VOX_VARIATION

/*
 *Spacepol
 */

/obj/item/clothing/under/rank/security/officer/spacepol
	name = "police uniform"
	desc = "Space not controlled by megacorporations, planets, or pirates is under the jurisdiction of Spacepol."
	icon_state = "spacepol"
	inhand_icon_state = "spacepol"
	can_adjust = FALSE
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION | CLOTHING_TESHARI_VARIATION | CLOTHING_VOX_VARIATION

/obj/item/clothing/under/rank/prisoner
	name = "prison jumpsuit"
	desc = "It's standardised prisoner-wear. Its suit sensors are stuck in the \"Fully On\" position."
	icon_state = "jumpsuit"
	inhand_icon_state = "jumpsuit"
	greyscale_colors = "#ff8300"
	greyscale_config = /datum/greyscale_config/jumpsuit_prison
	greyscale_config_inhand_left = /datum/greyscale_config/jumpsuit_prison_inhand_left
	greyscale_config_inhand_right = /datum/greyscale_config/jumpsuit_prison_inhand_right
	greyscale_config_worn = /datum/greyscale_config/jumpsuit_prison_worn
	greyscale_config_worn_digitigrade = /datum/greyscale_config/jumpsuit_prison_worn/digitigrade //PARIAH EDIT ADDITION
	has_sensor = LOCKED_SENSORS
	sensor_mode = SENSOR_COORDS
	random_sensor = FALSE

/obj/item/clothing/under/rank/prisoner/skirt
	name = "prison jumpskirt"
	desc = "It's standardised prisoner-wear. Its suit sensors are stuck in the \"Fully On\" position."
	icon_state = "jumpskirt"
	greyscale_colors = "#ff8300"
	greyscale_config = /datum/greyscale_config/jumpsuit_prison
	greyscale_config_inhand_left = /datum/greyscale_config/jumpsuit_prison_inhand_left
	greyscale_config_inhand_right = /datum/greyscale_config/jumpsuit_prison_inhand_right
	greyscale_config_worn = /datum/greyscale_config/jumpsuit_prison_worn
	greyscale_config_worn_digitigrade = null //PARIAH EDIT ADDITION
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON | CLOTHING_TESHARI_VARIATION | CLOTHING_VOX_VARIATION

/obj/item/clothing/under/rank/security/officer/beatcop
	name = "space police uniform"
	desc = "A police uniform often found in the lines at donut shops."
	icon_state = "spacepolice_families"
	inhand_icon_state = "spacepolice_families"
	can_adjust = FALSE
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION | CLOTHING_TESHARI_VARIATION | CLOTHING_VOX_VARIATION

/obj/item/clothing/under/rank/security/detective/disco
	name = "superstar cop uniform"
	desc = "Flare cut trousers and a dirty shirt that might have been classy before someone took a piss in the armpits. It's the dress of a superstar."
	icon_state = "jamrock_suit"
	inhand_icon_state = "jamrock_suit"
	can_adjust = FALSE

/obj/item/clothing/under/rank/security/detective/kim
	name = "aerostatic suit"
	desc = "A crisp and well-pressed suit; professional, comfortable and curiously authoritative."
	icon_state = "aerostatic_suit"
	inhand_icon_state = "aerostatic_suit"
	can_adjust = FALSE
