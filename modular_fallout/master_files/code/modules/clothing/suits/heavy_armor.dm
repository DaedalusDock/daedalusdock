// In this document: Heavy armor (not powerarmor)


///////////////
// WASTELAND //
///////////////

// Recipe Firesuit + metal chestplate + 50 welding fuel + 1 HQ + 1 plasteel
/obj/item/clothing/suit/armored/heavy/sulphite
	name = "sulphite raider suit"
	desc = "There are still some old asbestos fireman suits laying around from before the war. How about adding a ton of metal, plasteel and a combustion engine to one? The resulting armor is surprisingly effective at dissipating energy."
	icon_state = "sulphite"
	inhand_icon_state = "sulphite"
	armor = list(BLUNT = 55, PUNCTURE = 40, SLASH = 65, LASER = 50, ENERGY = 50, BOMB = 30, BIO = 25, RAD = 30, FIRE = 95, ACID = 15)
	resistance_flags = FIRE_PROOF

/obj/item/clothing/suit/armored/heavy/metal
	name = "metal armor suit"
	desc = "A suit of welded, fused metal plates. Bulky, but with great protection."
	icon_state = "raider_metal"
	inhand_icon_state = "raider_metal"
	armor = list(BLUNT = 60, PUNCTURE = 45, SLASH = 70, LASER = 30, ENERGY = 20, BOMB = 30, BIO = 10, RAD = 25, FIRE = 20, ACID = 20)

/obj/item/clothing/suit/armored/heavy/recycled_power
	name = "recycled power armor"
	desc = "Taking pieces off from a wrecked power armor will at least give you thick plating, but don't expect too much of this shot up, piecemeal armor.."
	icon_state = "recycled_power"
	armor = list(BLUNT = 50, PUNCTURE = 45, SLASH = 60, LASER = 30, ENERGY = 25, BOMB = 35, BIO = 5, RAD = 15, FIRE = 15, ACID = 5)

/obj/item/clothing/suit/armored/heavy/raidermetal
	name = "iron raider suit"
	desc = "More rust than metal, with gaping holes in it, this armor looks like a pile of junk. Under the rust some quality steel still remains however."
	icon_state = "raider_metal"
	inhand_icon_state = "raider_metal"
	armor = list(BLUNT = 55, PUNCTURE = 40, SLASH = 65, LASER = 15, ENERGY = 10, BOMB = 25, BIO = 0, RAD = 15, FIRE = 20, ACID = 0)

/obj/item/clothing/suit/armored/heavy/wardenplate
	name = "warden plates"
	desc = "Thick metal breastplate with a decorative skull on the shoulder."
	icon_state = "wardenplate"
	armor = list(BLUNT = 55, PUNCTURE = 50, SLASH = 65, LASER = 35, ENERGY = 25, BOMB = 30, BIO = 0, RAD = 15, FIRE = 10, ACID = 10)

/obj/item/clothing/suit/armored/heavy/bosexile
	name = "modified Brotherhood armor"
	desc = "A modified detoriated armor kit consisting of brotherhood combat armor and lots of scrap metal."
	icon_state = "exile_bos"
	inhand_icon_state = "exile_bos"
	armor = list(BLUNT = 30, PUNCTURE = 40, SLASH = 50, LASER = 40, ENERGY = 20, BOMB = 25, BIO = 10, RAD = 10, FIRE = 20, ACID = 10)

/obj/item/clothing/suit/armored/heavy/riotpolice
	name = "riot police armor"
	icon_state = "bulletproof_heavy"
	inhand_icon_state = "bulletproof_heavy"
	desc = "Heavy armor with ballistic inserts, sewn into a padded riot police coat."
	armor = list(BLUNT = 70, PUNCTURE = 45, SLASH = 80, LASER = 20, ENERGY = 20, BOMB = 45, BIO = 35, RAD = 10, FIRE = 50, ACID = 10)

/obj/item/clothing/suit/armored/heavy/salvaged_raider
	name = "raider salvaged power armor"
	desc = "A destroyed T-45b power armor has been brought back to life with the help of a welder and lots of scrap metal."
	icon_state = "raider_salvaged"
	inhand_icon_state = "raider_salvaged"
	armor = list(BLUNT = 60, PUNCTURE = 65, SLASH = 75, LASER = 50, ENERGY = 40, BOMB = 40, BIO = 55, RAD = 25, FIRE = 55, ACID = 15, "wound" = 25)
	slowdown = 0.8

/obj/item/clothing/suit/armored/heavy/salvaged_t45
	name = "salvaged T-45b power armor"
	desc = "It's a set of early-model T-45 power armor with a custom air conditioning module and stripped out servomotors. Bulky and slow, but almost as good as the real thing."
	icon_state = "t45b_salvaged"
	inhand_icon_state = "t45b_salvaged"
	armor = list(BLUNT = 65, PUNCTURE = 70, SLASH = 80, LASER = 55, ENERGY = 45, BOMB = 45, BIO = 60, RAD = 30, FIRE = 60, ACID = 20, "wound" = 30)
	slowdown = 1


//Recipe bone armor + metal and leather
/obj/item/clothing/suit/armored/heavy/tribal
	name = "tribal heavy carapace"
	desc = "Thick layers of leather and bone, with metal reinforcements, surely this will make the wearer tough and uncaring for claws and blades."
	icon_state = "tribal_heavy"
	inhand_icon_state = "tribal_heavy"
	armor = list(BLUNT = 55, PUNCTURE = 20, SLASH = 65, LASER = 25, ENERGY = 20, BOMB = 45, BIO = 5, RAD = 10, FIRE = 30, ACID = 10)
	allowed = list(/obj/item/twohanded, /obj/item/melee/onehanded, /obj/item/melee/smith, /obj/item/melee/smith/twohand)


/////////
// NCR //
/////////

/obj/item/clothing/suit/armored/heavy/salvaged_NCR
	name = "salvaged NCR power armor"
	desc = "It's a set of T-45b power armor with a air conditioning module installed, sadly it lacks servomotors to enhance the users strength. The paintjob and the two headed bear painted onto the chestplate shows it belongs to the NCR."
	icon_state = "ncr_salvaged"
	inhand_icon_state = "ncr_salvaged"
	armor = list(BLUNT = 65, PUNCTURE = 60, SLASH = 75, LASER = 55, ENERGY = 45, BOMB = 45, BIO = 60, RAD = 30, FIRE = 60, ACID = 20, "wound" = 30)
	slowdown = 1



////////////
// LEGION //
////////////

// Recipe combine veteran armor with a kevlar vest
/obj/item/clothing/suit/armored/heavy/legion/breacher
	name = "legion breacher armor"
	desc = "A suit with the standard metal reinforcements of a veteran and a patched bulletproof vest worn over it."
	icon_state = "legion_heavy"
	inhand_icon_state = "legion_heavy"
	armor = list(BLUNT = 65, PUNCTURE = 45, SLASH = 75, LASER = 30, ENERGY = 20, BOMB = 30, BIO = 20, RAD = 25, FIRE = 30, ACID = 5)

/obj/item/clothing/suit/armored/heavy/legion/centurion
	name = "legion centurion armor"
	desc = "The Legion centurion armor is by far the strongest suit of armor available to Caesar's Legion. The armor is composed from other pieces of armor taken from that of the wearer's defeated opponents in combat."
	icon_state = "legion_centurion"
	armor = list(BLUNT = 70, PUNCTURE = 50, SLASH = 80, LASER = 35, ENERGY = 35, BOMB = 40, BIO = 30, RAD = 25, FIRE = 40, ACID = 10)

/obj/item/clothing/suit/armored/heavy/legion/palacent
	name = "paladin-slayer centurion armor"
	desc = "The armor of a Centurion who has bested one or more Brotherhood Paladins, adding pieces of his prizes to his own defense. The symbol of the Legion is crudely painted on this once-marvelous suit of armor."
	icon_state = "legion_palacent"
	armor = list(BLUNT = 70, PUNCTURE = 60, SLASH = 80, LASER = 50, ENERGY = 40, BOMB = 45, BIO = 30, RAD = 30, FIRE = 50, ACID = 20)

/obj/item/clothing/suit/armored/heavy/legion/rangercent
	name = "ranger-hunter centurion armor"
	desc = "A suit of armor collected over the years by the deaths of countless NCR rangers."
	icon_state = "legion_rangercent"
	inhand_icon_state = "legion_rangercent"
	armor = list(BLUNT = 65, PUNCTURE = 50, SLASH = 75, LASER = 30, ENERGY = 30, BOMB = 35, BIO = 30, RAD = 25, FIRE = 50, ACID = 10)
	slowdown = 0.05

/obj/item/clothing/suit/armored/heavy/legion/legate
	name = "legion legate armor"
	desc = "The armor appears to be a full suit of heavy gauge steel and offers full body protection. It also has a cloak in excellent condition, but the armor itself bears numerous battle scars and the helmet is missing half of the left horn. The Legate's suit appears originally crafted, in contrast to other Legion armor which consists of repurposed pre-War sports equipment."
	icon_state = "legion_legate"
	armor = list(BLUNT = 70, PUNCTURE = 60, SLASH = 80, LASER = 45, ENERGY = 45, BOMB = 45, BIO = 50, RAD = 30, FIRE = 70, ACID = 20)


/*

/obj/item/clothing/suit/armored/heavy/eliteriot
	name = "elite riot gear"
	desc = "A heavily reinforced set of military grade armor, commonly seen in the Divide now repurposed and reissued to Chief Rangers."
	icon_state = "elite_riot"
	inhand_icon_state = "elite_riot"
	armor = list(BLUNT = 70, PUNCTURE = 60, LASER = 40, ENERGY = 35, BOMB = 45, BIO = 40, RAD = 30, FIRE = 50, ACID = 0)

/obj/item/clothing/suit/armored/heavy/tesla
	name = "tesla armor"
	desc = "A prewar armor design by Nikola Tesla before being confinscated by the U.S. government. Has a chance to deflect energy projectiles."
	icon_state = "tesla_armor"
	inhand_icon_state = "tesla_armor"
	blood_overlay_type = "armor"
	armor = list(BLUNT = 35, PUNCTURE = 35, LASER = 60, ENERGY = 60, BOMB = 35, BIO = 0, RAD = 0, FIRE = 100, ACID = 90)
	resistance_flags = FIRE_PROOF
	var/hit_reflect_chance = 40
	protected_zones = list(BODY_ZONE_CHEST, BODY_ZONE_PRECISE_GROIN, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)

/obj/item/clothing/suit/armored/heavy/tesla/run_block(mob/living/owner, atom/object, damage, attack_text, attack_type, armour_penetration, mob/attacker, def_zone, final_block_chance, list/block_return)
	if(is_energy_reflectable_projectile(object) && (attack_type == ATTACK_TYPE_PROJECTILE) && (def_zone in protected_zones))
		if(prob(hit_reflect_chance))
			block_return[BLOCK_RETURN_REDIRECT_METHOD] = REDIRECT_METHOD_DEFLECT
			return BLOCK_SHOULD_REDIRECT | BLOCK_REDIRECTED | BLOCK_SUCCESS | BLOCK_PHYSICAL_INTERNAL
	return ..()

/obj/item/clothing/suit/armored/heavy/salvagedpowerarmor
	name = "tribal full plate armor"
	desc = "(VI) A set of power armor, now reborn in the paints of the Wayfarers, it serves its new owners as an idol to Kwer, as well as being a piece of heavy covering, with removed parts to allow for quick nimble speed, its hardly what it used to be long ago."
	icon_state = "tribal_power_armor"
	inhand_icon_state = "tribal_power_armor"
	armor = list(BLUNT = 65, PUNCTURE = 65, LASER = 45, ENERGY = 40, BOMB = 45, BIO = 30, RAD = 30, FIRE = 60, ACID = 10)
	allowed = list(/obj/item/twohanded, /obj/item/melee/onehanded, /obj/item/melee/smith, /obj/item/melee/smith/twohand)


/obj/item/clothing/suit/armored/heavy/environmental
	name = "environmental armor"
	desc = "Developed for use in heavily contaminated environments, this suit is prized in the Wasteland for its ability to protect against biological threats."
	icon_state = "environmental_armor"
	inhand_icon_state = "environmental_armor"
	w_class = WEIGHT_CLASS_BULKY
	gas_transfer_coefficient = 0.9
	permeability_coefficient = 0.5
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	armor = list(BLUNT = 35, PUNCTURE = 30, LASER = 20, ENERGY = 15, ENERGY = 45, BOMB = 55, BIO = 70, RAD = 100, FIRE = 60, ACID = 50)
	equip_delay_other = 60
	flags_inv = HIDEJUMPSUIT

/obj/item/clothing/suit/armored/medium/environmental/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/rad_insulation, RAD_NO_INSULATION, TRUE, FALSE)
*/
