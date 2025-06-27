/*PARENT ITEMS FOR REFERENCE PURPOSES. DO NOT UNCOMMENT

/obj/item/clothing/head
	name = BODY_ZONE_HEAD
	icon = 'modular_fallout/master_files/icons/obj/clothing/hats.dmi'
	icon_state = "top_hat"
	inhand_icon_state = "that"
	body_parts_covered = HEAD
	slot_flags = ITEM_SLOT_HEAD
	var/blockTracking = 0 //For AI tracking
	var/can_toggle = null
	dynamic_hair_suffix = "+generic"
	var/datum/beepsky_fashion/beepsky_fashion //the associated datum for applying this to a secbot
	var/list/speechspan = null

/obj/item/clothing/head/Initialize()
	. = ..()
	if(ishuman(loc) && dynamic_hair_suffix)
		var/mob/living/carbon/human/H = loc
		H.update_hair()

/obj/item/clothing/head/get_head_speechspans(mob/living/carbon/user)
	if(speechspan)
		return speechspan
	else
		return

/obj/item/clothing/head/helmet
	name = "helmet"
	desc = "Standard Security gear. Protects the head from impacts."
	icon_state = "helmet"
	inhand_icon_state = "helmet"
	armor = list("tier" = 4, ENERGY = 10, BOMB = 25, BIO = 0, RAD = 0, FIRE = 50, ACID = 50)
	flags_inv = HIDEEARS
	cold_protection = HEAD
	min_cold_protection_temperature = HELMET_MIN_TEMP_PROTECT
	heat_protection = HEAD
	max_heat_protection_temperature = HELMET_MAX_TEMP_PROTECT
	strip_delay = 60
	resistance_flags = NONE
	flags_cover = HEADCOVERSEYES
	flags_inv = HIDEHAIR

	dog_fashion = /datum/dog_fashion/head/helmet

/obj/item/clothing/head/helmet/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/wearertargeting/earprotection, list(SLOT_HEAD))*/

//Combat Armor FACTION SPECIFIC COMBAT ARMOR IN f13factionhead.dm

/obj/item/clothing/head/helmet/f13/combat
	name = "combat helmet"
	desc = "(V) An old military grade pre-war combat helmet."
	icon_state = "combat_helmet"
	inhand_icon_state = "combat_helmet"
	armor = list("tier" = 5, ENERGY = 40, BOMB = 50, BIO = 60, RAD = 10, FIRE = 60, ACID = 20)
	strip_delay = 50
	flags_inv = HIDEEARS|HIDEEYES|HIDEHAIR
	flags_cover = HEADCOVERSEYES
	resistance_flags = LAVA_PROOF | FIRE_PROOF

/obj/item/clothing/head/helmet/f13/combat/dark
	color = "#302E2E" // Dark Grey

/obj/item/clothing/head/helmet/f13/combat/Initialize()
	. = ..()
	AddComponent(/datum/component/spraycan_paintable)
	START_PROCESSING(SSobj, src)

/obj/item/clothing/head/helmet/f13/combat/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/clothing/head/helmet/f13/combat/mk2
	name = "reinforced combat helmet"
	desc = "(VI) An advanced pre-war titanium plated, ceramic coated, kevlar, padded helmet designed to withstand extreme punishment of all forms."
	icon_state = "combat_helmet_mk2"
	inhand_icon_state = "combat_helmet_mk2"
	armor = list("tier" = 6, ENERGY = 45, BOMB = 55, BIO = 60, RAD = 15, FIRE = 60, ACID = 30)

/obj/item/clothing/head/helmet/f13/combat/mk2/dark
	name = "reinforced combat helmet"
	color = "#302E2E" // Dark Grey

/obj/item/clothing/head/helmet/f13/combat/mk2/raider
	name = "customized raider combat helmet"
	desc = "(VI) A reinforced combat helmet painted black with the laser designator removed."
	icon_state = "combat_helmet_raider"
	inhand_icon_state = "combat_helmet_raider"

/obj/item/clothing/head/helmet/f13/rangerbroken
	name = "broken riot helmet"
	icon_state = "ranger_broken"
	desc = "(VII) An old riot police helmet, out of use around the time of the war."
	armor = list("tier" = 7, ENERGY = 50, BOMB = 39, BIO = 20, RAD = 20, FIRE = 30, ACID = 0)
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEHAIR|HIDEFACIALHAIR|HIDEFACE
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	resistance_flags = LAVA_PROOF | FIRE_PROOF
	flash_protect = 1

/obj/item/clothing/head/helmet/f13/combat/swat
	name = "SWAT combat helmet"
	desc = "A prewar combat helmet issued to S.W.A.T. personnel."
	icon_state = "swatsyndie"
	inhand_icon_state = "swatsyndie"

/obj/item/clothing/head/helmet/f13/combat/environmental
	name = "environmental armor helmet"
	desc = "(V) A full head helmet and gas mask, developed for use in heavily contaminated environments."
	icon_state = "env_helmet"
	inhand_icon_state = "env_helmet"
	armor = list("tier" = 5,ENERGY = 45, BOMB = 55, BIO = 70, RAD = 100, FIRE = 60, ACID = 50)
	strip_delay = 60
	equip_delay_other = 60
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH

/obj/item/clothing/head/helmet/f13/combat/environmental/Initialize()
	. = ..()
	AddComponent(/datum/component/rad_insulation, RAD_NO_INSULATION, TRUE, FALSE)

//Sulphite Helm

/obj/item/clothing/head/helmet/f13/sulphitehelm
	name = "sulphite helmet"
	desc = "(VI) A sulphite raider helmet, affixed with thick anti-ballistic glass over the eyes."
	icon_state = "sulphite_helm"
	inhand_icon_state = "sulphite_helm"
	armor = list("tier" = 6, ENERGY = 40, BOMB = 50, BIO = 60, RAD = 10, FIRE = 60, ACID = 20)
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH

//Metal

/obj/item/clothing/head/helmet/knight/f13/metal
	name = "metal helmet"
	desc = "(III) An iron helmet forged by tribal warriors, with a unique design to protect the face from arrows and axes."
	icon_state = "metalhelmet"
	inhand_icon_state = "metalhelmet"
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR
	armor = list("tier" = 3, ENERGY = 20, BOMB = 16, BIO = 0, RAD = 0)

/obj/item/clothing/head/helmet/knight/f13/metal/reinforced
	name = "reinforced metal helmet"
	desc = "(IV) An iron helmet forged by tribal warriors, with a unique design to protect the face from arrows and axes."
	icon_state = "metalhelmet_r"
	inhand_icon_state = "metalhelmet_r"
	armor = list("tier" = 4, ENERGY = 25, BOMB = 16, BIO = 0, RAD = 0)

/obj/item/clothing/head/helmet/knight/f13/rider
	name = "rider helmet" //Not raider. Rider.
	desc = "(III) It's a fancy dark metal helmet with orange spray painted flames."
	icon_state = "rider"
	inhand_icon_state = "rider"

/obj/item/clothing/head/helmet/f13/metalmask
	name = "metal mask"
	desc = "(IV) A crudely formed metal hockey mask."
	icon_state = "metal_mask"
	inhand_icon_state = "metal_mask"
	toggle_message = "You lower"
	alt_toggle_message = "You raise"
	can_toggle = 1
	armor = list("tier" = 4, ENERGY = 40, BOMB = 40, BIO = 30, RAD = 15, FIRE = 60, ACID = 0)
	flags_inv = HIDEMASK|HIDEEYES|HIDEFACE
	strip_delay = 80
	actions_types = list(/datum/action/item_action/toggle)
	toggle_cooldown = 0
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	visor_flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	visor_flags_inv = HIDEMASK|HIDEEYES|HIDEFACE

/obj/item/clothing/head/helmet/f13/metalmask/Initialize()
	. = ..()
	AddComponent(/datum/component/spraycan_paintable)
	START_PROCESSING(SSobj, src)

/obj/item/clothing/head/helmet/f13/metalmask/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/clothing/head/helmet/f13/metalmask/mk2
	name = "reinforced metal mask"
	desc = "(V) A reinforced metal hockey mask."
	icon_state = "metal_mask2"
	inhand_icon_state = "metal_mask2"
	armor = list("tier" = 5, ENERGY = 50, BOMB = 40, BIO = 30, RAD = 20, FIRE = 60, ACID = 0)

/obj/item/clothing/head/helmet/f13/tesla
	name = "tesla helmet"
	desc = "(V) A prewar armor design by Nikola Tesla before being confiscated by the U.S. government. Provides high energy weapons resistance."
	icon_state = "tesla_helmet"
	inhand_icon_state = "tesla_helmet"
	armor = list("tier" = 5, ENERGY = 60, BOMB = 40, BIO = 30, RAD = 20, FIRE = 60, ACID = 0)
	strip_delay = 10
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR
	var/hit_reflect_chance = 50

/obj/item/clothing/head/helmet/f13/tesla/IsReflect(def_zone)
	if(def_zone != BODY_ZONE_HEAD) //If not shot where ablative is covering you, you don't get the reflection bonus!
		return FALSE
	if (prob(hit_reflect_chance))
		return TRUE

//Power Armour

/obj/item/clothing/head/helmet/f13/power_armor
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELM_MIN_TEMP_PROTECT
	heat_protection = HEAD
	max_heat_protection_temperature = SPACE_HELM_MAX_TEMP_PROTECT
	strip_delay = 200
	equip_delay_self = 20
	slowdown = 0.1
	flags_inv = HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDEMASK|HIDEJUMPSUIT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	clothing_flags = THICKMATERIAL
	resistance_flags = LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	item_flags = SLOWS_WHILE_IN_HAND
	flash_protect = 2
	speechspan = SPAN_ROBOT //makes you sound like a robot
	heat_protection = HEAD
	max_heat_protection_temperature = FIRE_HELM_MAX_TEMP_PROTECT
	cold_protection = HEAD
	min_cold_protection_temperature = FIRE_HELM_MIN_TEMP_PROTECT
	light_system = MOVABLE_LIGHT_DIRECTIONAL
	light_outer_range = 5
	light_on = FALSE
//	darkness_view = 128
//	lighting_alpha = LIGHTING_PLANE_ALPHA_NV_TRAIT
	var/emped = 0
	var/requires_training = TRUE
	var/armor_block_chance = 0
	protected_zones = list(BODY_ZONE_HEAD)
	var/deflection_chance = 0
	var/armor_block_threshold = 0.2 //projectiles below this will deflect
	var/melee_block_threshold = 30
	var/dmg_block_threshold = 42
	var/powerLevel = 7000
	var/powerMode = 3
	var/powered = TRUE

/obj/item/clothing/head/helmet/f13/power_armor/attackby(obj/item/I, mob/user, params)
	. = ..()
	if(istype(I,/obj/item/fusion_fuel)&& powered)
		var/obj/item/fusion_fuel/fuel = I
		if(src.powerLevel>=50000)
			to_chat(user, "The fusion core is full.")
			return
		if(fuel.fuel >= 5000)
			src.powerLevel += 5000
			fuel.fuel -= 5000
			to_chat(user, "You charge the fusion core to [src.powerLevel] units of fuel. [fuel.fuel]/20000 left in the fuel cell.")
			return
		to_chat(user, "The fuel cell is empty.")

/obj/item/clothing/head/helmet/f13/power_armor/proc/processPower()
	if(powerLevel>0)//drain charge
		powerLevel -= 1
	if(powerLevel > 20000)//switch to 3 power mode
		if(powerMode <= 2)
			powerUp()
		return
	if(powerLevel > 10000)//switch to 2 power
		if(powerMode <= 1)
			powerUp()
		if(powerMode > 2)
			powerDown()
		return
	if(powerLevel > 5000)//switch to 1 power
		if(powerMode <= 0)
			powerUp()
		if(powerMode > 1)
			powerDown()
		return
	if(powerLevel >= 1)//switch to 0 power
		if(powerMode >= 0)
			powerDown()

/obj/item/clothing/head/helmet/f13/power_armor/proc/powerUp()
	powerMode += 1
	slowdown -= 0.2
	var/mob/living/L = loc
	if(istype(L))
		L.update_equipment_speed_mods()
	armor = armor.modifyRating(linemelee = 75, linebullet = 75, linelaser = 75)

/obj/item/clothing/head/helmet/f13/power_armor/proc/powerDown()
	powerMode -= 1
	slowdown += 0.2
	var/mob/living/L = loc
	if(istype(L))
		L.update_equipment_speed_mods()
	armor = armor.modifyRating(linemelee = -75, linebullet = -75, linelaser = -75)

/obj/item/clothing/head/helmet/f13/power_armor/Initialize()
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)

/obj/item/clothing/head/helmet/f13/power_armor/attack_self(mob/living/user)
	toggle_helmet_light(user)

/obj/item/clothing/head/helmet/f13/power_armor/proc/toggle_helmet_light(mob/living/user)
	set_light_on(!light_on)
	update_icon()


/obj/item/clothing/head/helmet/f13/power_armor/mob_can_equip(mob/user, mob/equipper, slot, disable_warning = 1)
	var/mob/living/carbon/human/H = user
	if(src == H.head) //Suit is already equipped
		return ..()
	if(slot == ITEM_SLOT_HEAD)
		return ..()
	return

/obj/item/clothing/head/helmet/f13/power_armor/emp_act(mob/living/carbon/human/owner, severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	emped++
	var/curremp = emped
	if(ismob(loc))
		to_chat(loc, "<span class='warning'>Warning: electromagnetic surge detected in helmet. Rerouting power to emergency systems.</span>")
		addtimer(CALLBACK(src, .proc/end_emp_effect, curremp), 5 SECONDS)

/obj/item/clothing/head/helmet/f13/power_armor/proc/end_emp_effect(curremp)
	if(emped != curremp) //Don't fix it if it's been EMP'd again
		return FALSE
	if(ismob(loc))
		var/mob/living/L = loc
		emped = FALSE
		to_chat(loc, "<span class='warning'>Helmet power reroute successful. All systems operational.</span>")
		if(istype(L))
			L.update_equipment_speed_mods()
	return TRUE

/obj/item/clothing/head/helmet/f13/power_armor/t45b
	name = "salvaged T-45b helmet"
	desc = "(VIII) It's a salvaged T-45b power armor helmet."
	icon_state = "t45bhelmet"
	inhand_icon_state = "t45bhelmet"
	armor = list("tier" = 8, ENERGY = 50, BOMB = 48, BIO = 60, RAD = 50, FIRE = 80, ACID = 0, "wound" = 40)
//	darkness_view = 0
	armor_block_chance = 25
	deflection_chance = 10 //10% chance to block damage from blockable bullets and redirect the bullet at a random angle. Not nearly as effective as true power armor
	requires_training = FALSE
	powered = FALSE

/obj/item/clothing/head/helmet/f13/power_armor/ncr_t45b
	name = "ncr salvaged T-45b helmet"
	desc = "(VIII) It's an NCR salvaged T-45b power armor helmet, better repaired than regular salvaged PA, and decorated with the NCR flag and other markings for an NCR Heavy Trooper."
	icon_state = "t45bhelmet_ncr"
	inhand_icon_state = "t45bhelmet_ncr"
	armor = list("tier" = 8, ENERGY = 50, BOMB = 48, BIO = 60, RAD = 50, FIRE = 80, ACID = 0, "wound" = 40)
//	darkness_view = 0
	armor_block_chance = 40
	deflection_chance = 10 //10% chance to block damage from blockable bullets and redirect the bullet at a random angle. Not nearly as effective as true power armor
	requires_training = FALSE
	powered = FALSE

/obj/item/clothing/head/helmet/f13/power_armor/t45b/restored
	name = "restored T-45b helmet"
	desc = "(VIII) It's a restored T-45b power armor helmet."
	armor_block_chance = 60
	deflection_chance = 10 //20% chance to block damage from blockable bullets and redirect the bullet at a random angle
	requires_training = TRUE
	powered = TRUE

/obj/item/clothing/head/helmet/f13/power_armor/raiderpa_helm
	name = "raider T-45b power helmet"
	desc = "(VIII) This power armor helmet is so decrepit and battle-worn that it have lost most of its capability to protect the wearer from harm. This helmet seems to be heavily modified, heavy metal banding fused to the helmet"
	icon_state = "raiderpa_helm"
	inhand_icon_state = "raiderpa_helm"
	armor = list("tier" = 8, ENERGY = 50, BOMB = 48, BIO = 60, RAD = 50, FIRE = 80, ACID = 0, "wound" = 40)
	requires_training = FALSE
	armor_block_chance = 20
	deflection_chance = 10
	powered = FALSE


/obj/item/clothing/head/helmet/f13/power_armor/hotrod
	name = "hotrod T-45b power helmet"
	desc = "(VIII) This power armor helmet is so decrepit and battle-worn that it have lost most of its capability to protect the wearer from harm."
	icon_state = "t45hotrod_helm"
	inhand_icon_state = "t45hotrod_helm"
	armor = list("tier" = 8, ENERGY = 50, BOMB = 48, BIO = 60, RAD = 50, FIRE = 80, ACID = 0, "wound" = 40)
	requires_training = FALSE
	armor_block_chance = 20
	powered = FALSE
	deflection_chance = 10 //5% chance to block damage from blockable bullets and redirect the bullet at a random angle. Stripped down version of an already stripped down version

/obj/item/clothing/head/helmet/f13/power_armor/vaulttec
	name = "Vault-Tec power helmet"
	desc = "(VIII) A refined suit of power armour, purpose-built by the residents of Vault-115 in order to better keep the peace in their new settlement."
	icon_state = "vaultpahelm"
	inhand_icon_state = "vaultpahelm"
	armor = list("tier" = 8, ENERGY = 50, BOMB = 48, BIO = 60, RAD = 50, FIRE = 80, ACID = 0, "wound" = 40)
	armor_block_chance = 40
	deflection_chance = 10 //10% chance to block damage from blockable bullets and redirect the bullet at a random angle. Not a heavy combat model

/obj/item/clothing/head/helmet/f13/power_armor/vaulttecta
	name = "Vault-Tec power helmet"
	desc = "(VIII) A refined suit of power armour, purpose-built by the residents of Vault-115 in order to better keep the peace in their new settlement."
	icon_state = "vaulttahelm"
	inhand_icon_state = "vaulttahelm"
	armor = list("tier" = 8, ENERGY = 50, BOMB = 48, BIO = 60, RAD = 50, FIRE = 80, ACID = 0, "wound" = 40)
	slowdown = 0.1

/obj/item/clothing/head/helmet/f13/power_armor/t45d
	name = "T-45d power helmet"
	desc = "(IX) It's an old pre-War power armor helmet. It's pretty hot inside of it."
	icon_state = "t45dhelmet0"
	inhand_icon_state = "t45dhelmet0"
	actions_types = list(/datum/action/item_action/toggle_helmet_light)
	armor = list("tier" = 9, ENERGY = 60, BOMB = 62, BIO = 100, RAD = 90, FIRE = 90, ACID = 0, "wound" = 60)
	armor_block_chance = 60
	deflection_chance = 10 //20% chance to block damage from blockable bullets and redirect the bullet at a random angle

/obj/item/clothing/head/helmet/f13/power_armor/t45d/update_icon_state()
	icon_state = "t45dhelmet[light_on]"
	inhand_icon_state = "t45dhelmet[light_on]"

/obj/item/clothing/head/helmet/f13/power_armor/t45d/gunslinger
	name = "Gunslinger T-51b Helm"
	desc = "(IX) With most of the external plating stripped to allow for internal thermal and night vision scanners, as well as aided targeting assist via onboard systems, this helm provides much more utility then protection. To support these systems, secondary power cells were installed into the helm, and covered with a stylish hat."
	icon_state = "t51bgs"
	inhand_icon_state = "t51bgs"
	slowdown = -0.2
	flags_inv = HIDEEARS|HIDEEYES|HIDEFACE|HIDEFACIALHAIR
	actions_types = list()

/obj/item/clothing/head/helmet/f13/power_armor/t45d/sierra
	name = "sierra power helmet"
	desc = "(IX) A pre-war power armor helmet, issued to special NCR officers.."
	icon_state = "sierra"
	inhand_icon_state = "sierra"
	actions_types = list()

/obj/item/clothing/head/helmet/f13/power_armor/midwest
	name = "midwestern power helmet"
	desc = "(IX) This helmet once belonged to the Midwestern branch of the Brotherhood of Steel, and now resides here."
	icon_state = "midwestgrey_helm"
	inhand_icon_state = "midwestgrey_helm"
	armor = list("tier" = 9, ENERGY = 60, BOMB = 62, BIO = 100, RAD = 90, FIRE = 90, ACID = 0, "wound" = 60)
	armor_block_chance = 60
	deflection_chance = 10 //20% chance to block damage from blockable bullets and redirect the bullet at a random angle

/obj/item/clothing/head/helmet/f13/power_armor/t51b
	name = "T-51b power helmet"
	desc = "(X) It's a T-51b power helmet, typically used by the Brotherhood. It looks somewhat charming."
	icon_state = "t51bhelmet0"
	inhand_icon_state = "t51bhelmet0"
	armor = list("tier" = 10, ENERGY = 65, BOMB = 62, BIO = 100, RAD = 99, FIRE = 90, ACID = 0, "wound" = 70)
	actions_types = list(/datum/action/item_action/toggle_helmet_light)
	armor_block_chance = 70
	deflection_chance = 10 //35% chance to block damage from blockable bullets and redirect the bullet at a random angle. Less overall armor compared to T-60, but higher deflection.
	armor_block_threshold = 0.25
	melee_block_threshold = 35

/obj/item/clothing/head/helmet/f13/power_armor/t51b/update_icon_state()
	icon_state = "t51bhelmet[light_on]"
	inhand_icon_state = "t51bhelmet[light_on]"

/obj/item/clothing/head/helmet/f13/power_armor/t51b/wbos
	name = "Washington power helmet"
	desc = "(X) It's a Washington Brotherhood power helmet. It looks somewhat terrifying."
	icon_state = "t51wboshelmet"
	inhand_icon_state = "t51wboshelmet"
	actions_types = list()

/obj/item/clothing/head/helmet/f13/power_armor/t51b/reforgedwbos
	name = "reforged Washington power helmet"
	desc = "(X) It's a reforged Washington Brotherhood power helmet, designed to induce fear in a target."
	icon_state = "t51matthelmet"
	inhand_icon_state = "t51matthelmet"
	actions_types = list()

/obj/item/clothing/head/helmet/f13/power_armor/t51b/ultra
	name = "Ultracite power helmet"
	desc = "(X) It's a T-51b power helmet, typically used by the Brotherhood. It looks somewhat charming. Now enhanced with ultracite."
	icon_state = "ultracitepa_helm"
	inhand_icon_state = "ultracitepa_helm"
	slowdown = 0
	actions_types = list()

/obj/item/clothing/head/helmet/f13/power_armor/t60
	name = "T-60a power helmet"
	desc = "(XI) The T-60 powered helmet, equipped with targetting software suite, Friend-or-Foe identifiers, dynamic HuD, and an internal music player."
	icon_state = "t60helmet0"
	inhand_icon_state = "t60helmet0"
	armor = list("tier" = 11, ENERGY = 70, BOMB = 82, BIO = 100, RAD = 100, FIRE = 95, ACID = 0, "wound" = 80)
	actions_types = list(/datum/action/item_action/toggle_helmet_light)
	armor_block_chance = 80
	deflection_chance = 15 //20% chance to block damage from blockable bullets and redirect the bullet at a random angle. Same deflection as T-45 due to it having the same general shape.
	melee_block_threshold = 40
	armor_block_threshold = 0.3

/obj/item/clothing/head/helmet/f13/power_armor/t60/update_icon_state()
	icon_state = "t60helmet[light_on]"
	inhand_icon_state = "t60helmet[light_on]"

/obj/item/clothing/head/helmet/f13/power_armor/excavator
	name = "excavator power helmet"
	desc = "(VIII) The helmet of the excavator power armor suit."
	icon_state = "excavator"
	inhand_icon_state = "excavator"
	armor = list("tier" = 8, ENERGY = 60, BOMB = 62, BIO = 100, RAD = 90, FIRE = 90, ACID = 0)
	armor_block_chance = 40
	deflection_chance = 10 //10% chance to block damage from blockable bullets and redirect the bullet at a random angle. Not a heavy combat model

/obj/item/clothing/head/helmet/f13/power_armor/advanced
	name = "advanced power helmet"
	desc = "(XII) It's an advanced power armor MK1 helmet, typically used by the Enclave. It looks somewhat threatening."
	icon_state = "advhelmet1"
	inhand_icon_state = "advhelmet1"
	armor = list("tier" = 12, ENERGY = 75, BOMB = 72, BIO = 100, RAD = 100, FIRE = 90, ACID = 0, "wound" = 90)
	armor_block_threshold = 0.45
	melee_block_threshold = 45
	armor_block_chance = 80 //Enclave. 'nuff said
	deflection_chance = 15 //40% chance to block damage from blockable bullets and redirect the bullet at a random angle. Your ride's over mutie, time to die.

/obj/item/clothing/head/helmet/f13/power_armor/advanced/hellfire
	name = "hellfire power armor"
	desc = "(XIII) A deep black helmet of Enclave-manufactured heavy power armor with yellow ballistic glass, based on pre-war designs such as the T-51 and improving off of data gathered by post-war designs such as the X-01. Most commonly fielded on the East Coast, no other helmet rivals it's strength."
	icon_state = "hellfirehelm"
	inhand_icon_state = "hellfirehelm"
	melee_block_threshold = 70
	armor_block_threshold = 0.8
	armor_block_chance = 99
	deflection_chance = 70
	armor = list("tier" = 13, ENERGY = 90, BOMB = 72, BIO = 100, RAD = 100, FIRE = 90, ACID = 0, "wound" = 100)

/obj/item/clothing/head/helmet/f13/power_armor/advanced/hellfire/wbos
	name = "advanced Washington power helmet"
	desc = "It's an improved model of the power armor helmet used exclusively by the Washington Brotherhood, designed to induce fear in a target."
	icon_state = "t51wboshelmet"
	inhand_icon_state = "t51wboshelmet"

/obj/item/clothing/head/helmet/f13/power_armor/tesla
	name = "tesla power helmet"
	desc = "A helmet typically used by Enclave special forces.<br>There are three orange energy capacitors on the side."
	icon_state = "tesla"
	inhand_icon_state = "tesla"
	armor = list("linemelee" = 200, "linebullet" = 200, "linelaser" = 300, ENERGY = 95, BOMB = 62, BIO = 100, RAD = 100, FIRE = 90, ACID = 0, "wound" = 80)
	var/hit_reflect_chance = 75

/obj/item/clothing/head/helmet/f13/power_armor/tesla/IsReflect(def_zone)
	if(def_zone != BODY_ZONE_HEAD) //If not shot where ablative is covering you, you don't get the reflection bonus!
		return FALSE
	if (prob(hit_reflect_chance))
		return TRUE


//Part of the peacekeeper enclave stuff, adjust values as needed.
/obj/item/clothing/head/helmet/f13/power_armor/x02helmet
	name = "Enclave power armor helmet"
	desc = "(XI) The Enclave Mark II Powered Combat Armor helmet."
	icon_state = "advanced"
	inhand_icon_state = "advanced"
	slowdown = 0.1
	armor = list("tier" = 11, ENERGY = 65, BOMB = 62, BIO = 100, RAD = 99, FIRE = 90, ACID = 0, "wound" = 70)
	actions_types = list(/datum/action/item_action/toggle_helmet_light)
	armor_block_threshold = 0.45
	melee_block_threshold = 45
	armor_block_chance = 80
	deflection_chance = 15


//Generic Tribal - For Wayfarer specific, see f13factionhead.dm

/obj/item/clothing/head/helmet/f13/tribal
	name = "tribal power helmet"
	desc = "(IV) This power armor helmet was salvaged by savages from the battlefield.<br>They believe that these helmets capture the spirits of their fallen wearers, so they painted some runes on to give it a more sacred meaning."
	icon_state = "tribal"
	inhand_icon_state = "tribal"
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	armor = list("tier" = 4, ENERGY = 0, BOMB = 10, BIO = 0, RAD = 10, FIRE = 0, ACID = 0)
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR
	strip_delay = 30

/obj/item/clothing/head/f13
	flags_inv = HIDEHAIR

/obj/item/clothing/head/f13/rastacap
	name = "rastacap"
	desc = "(I) <font color='#157206'>Him haffi drop him fork and run,</font><br><font color='green'>Him can't stand up to Jah Jah son,</font><br><font color='#fd680e'>Him haffi lef' ya with him gun,</font><br><font color='red'>Dig off with him bomb.</font>"
	icon_state = "rastacap"
	inhand_icon_state = "fedora"
	cold_protection = HEAD //This tam brings the warm reggae and Jamaican sun with it.
	min_cold_protection_temperature = FIRE_HELM_MIN_TEMP_PROTECT

/obj/item/clothing/head/f13/hairband
	name = "hairband"
	desc = "Pretty yellow hairband"
	icon_state = "50shairband"
	inhand_icon_state = "50shairband"

/obj/item/clothing/head/f13/nursehat
	name = "nursehat"
	desc = "White cloth headdress for nurses"
	icon_state = "nursehat"
	inhand_icon_state = "nursehat"

/obj/item/clothing/head/f13/beaver
	name = "beaverkin"
	desc = "(I) A hat made from felted beaver fur which makes the wearer feel both comfortable and elegant."
	icon_state = "beaver"
	inhand_icon_state = "that"

/obj/item/clothing/head/f13/purple
	name = "purple top hat"
	desc = "(I) You may not own the best jail in the observed Universe, or the best chocolate factory in the entire world, but at least you can try to have that purple top hat."
	icon_state = "ptophat"
	inhand_icon_state = "that"

/obj/item/clothing/head/f13/trilby
	name = "feather trilby"
	desc = "(I) A sharp, stylish blue hat with a feather."
	icon_state = "trilby"
	inhand_icon_state = "fedora"

//chinesearmy
/obj/item/clothing/head/f13/chinese_soldier
	name = "chinese side cap"
	desc = "(I) A People's Liberation Army side cap, worn by enlisted and non-commissioned officers."
	icon_state = "chinese_s"
	inhand_icon_state = "secsoft"

/obj/item/clothing/head/f13/chinese_officer
	name = "chinese officer cap"
	desc = "(I) A People's Liberation Army cap, worn by low ranking officers."
	icon_state = "chinese_o"
	inhand_icon_state = "secsoft"

/obj/item/clothing/head/f13/chinese_general
	name = "chinese peaked cap"
	desc = "(I) A People's Liberation Army peaked cap, worn by high ranking officers and commanders."
	icon_state = "chinese_c"
	inhand_icon_state = "fedora"

/obj/item/clothing/head/f13/stormchaser
	name = "stormchaser hat"
	desc = "(I) Home, home on the wastes,<br>Where the mole rat and the fire gecko play.<br>Where seldom is heard a discouraging word,<br>And my skin is not glowing all day."
	icon_state = "stormchaser"
	inhand_icon_state = "fedora"
	flags_inv = HIDEEARS|HIDEHAIR

/obj/item/clothing/head/f13/headscarf
	name = "headscarf"
	desc = "(I) A piece of cloth worn on head for a variety of purposes, such as protection of the head or hair from rain, wind, dirt, cold, warmth, for sanitation, for fashion, recognition or social distinction - with religious significance, to hide baldness, out of modesty, or other forms of social convention."
	icon_state = "headscarf"
	inhand_icon_state = "dethat"
	flags_inv = HIDEMASK|HIDEEARS|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR

/obj/item/clothing/head/f13/headscarf/Initialize()
	. = ..()
	AddComponent(/datum/component/armor_plate)

/obj/item/clothing/head/f13/pot
	name = "metal cooking pot"
	desc = "(III) Step one: Start with the sauce.<br>Step two: Add the noodles.<br>Step three: Stir the pasta.<br>Step four: Turn up the heat.<br>Step five: Burn the house."
	icon_state = "pot"
	inhand_icon_state = "fedora"
	force = 20
	hitsound = 'sound/items/trayhit1.ogg'
	flags_inv = HIDEHAIR
	armor = list("tier" = 3)

/obj/item/clothing/head/f13/cowboy
	name = "cowboy hat"
	desc = "(II) I've never seen so many men wasted so badly."
	icon_state = "cowboy"
	inhand_icon_state = "dethat"
	flags_inv = HIDEHAIR
	armor = list("tier" = 2)

/obj/item/clothing/head/f13/bandit
	name = "bandit hat"
	desc = "(I) A black cowboy hat with a large brim that's curved to the sides.<br>A silver eagle pin is attached to the front."
	icon_state = "bandit"
	inhand_icon_state = "fedora"
	flags_inv = HIDEHAIR
	armor = list("tier" = 2)

/obj/item/clothing/head/f13/gambler
	name = "gambler hat"
	desc = "(I) A perfect hat for a ramblin' gamblin' man." //But I got to ramble (ramblin' man) //Oh I got to gamble (gamblin' man) //Got to got to ramble (ramblin' man) //I was born a ramblin' gamblin' man
	icon_state = "gambler"
	inhand_icon_state = "dethat"
	flags_inv = HIDEHAIR

/obj/item/clothing/head/helmet/f13/motorcycle
	name = "motorcycle helmet"
	desc = "(II) A type of helmet used by motorcycle riders.<br>The primary goal of a motorcycle helmet is motorcycle safety - to protect the rider's head during impact, thus preventing or reducing head injury and saving the rider's life."
	icon_state = "motorcycle"
	inhand_icon_state = "motorcycle"
	flags_cover = HEADCOVERSEYES
	armor = list("tier" = 2, "linemelee" = 30, ENERGY = 0, BOMB = 10, BIO = 0, RAD = 0, FIRE = 0, ACID = 0)
	flags_inv = HIDEMASK|HIDEEARS|HIDEHAIR
	strip_delay = 10

/obj/item/clothing/head/helmet/f13/firefighter
	name = "firefighter helmet"
	desc = "(III) A firefighter's helmet worn on top of a fire-retardant covering and broken gas mask.<br>It smells heavily of sweat."
	icon_state = "firefighter"
	inhand_icon_state = "firefighter"
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	armor = list("tier" = 3, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 90, ACID = 0)
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELM_MIN_TEMP_PROTECT
	heat_protection = HEAD
	max_heat_protection_temperature = SPACE_HELM_MAX_TEMP_PROTECT
	strip_delay = 30
	resistance_flags = FIRE_PROOF

/obj/item/clothing/head/helmet/f13/vaquerohat
	name = "vaquero hat"
	desc = "(III) An old sombrero worn by Vaqueros to keep off the harsh sun."
	icon_state = "vaquerohat"
	inhand_icon_state = "vaquerohat"
	armor = list("tier" = 3, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 20, ACID = 0)
	flags_inv = HIDEEARS|HIDEHAIR

/obj/item/clothing/head/helmet/f13/wastewarhat
	name = "warrior helmet"
	desc = "(III) It might have been a cooking pot once, now its a helmet, with a piece of cloth covering the neck from the sun."
	icon = 'modular_fallout/master_files/icons/fallout/clothing/helmets.dmi'
	mob_overlay_icon = 'modular_fallout/master_files/icons/fallout/onmob/clothes/helmet.dmi'
	icon_state = "wastewar"
	inhand_icon_state = "wastewar"
	armor = list("tier" = 3, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 20, ACID = 0)
	flags_inv = HIDEEARS|HIDEHAIR

/obj/item/clothing/head/helmet/f13/hoodedmask
	name = "hooded mask"
	desc = "(III) A gask mask with the addition of a hood."
	icon_state = "Hooded_Gas_Mask"
	inhand_icon_state = "Hooded_Gas_Mask"
	armor = list("tier" = 3, ENERGY = 20, BOMB = 70, BIO = 70, RAD = 70, FIRE = 65, ACID = 30)
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR

/obj/item/clothing/head/helmet/f13/brahmincowboyhat
	name = "brahmin leather cowboy hat"
	desc = "(II) A cowboy hat made from brahmin hides."
	icon_state = "brahmin_leather_cowboy_hat"
	inhand_icon_state = "brahmin_leather_cowboy_hat"
	armor = list("tier" = 2, ENERGY = 15, BOMB = 70, BIO = 70, RAD = 70, FIRE = 70, ACID = 15)
	flags_inv = HIDEEARS|HIDEHAIR

/obj/item/clothing/head/helmet/f13/rustedcowboyhat
	name = "Rusted Cowboy Hat"
	desc = "(II) A hat made from tanned leather hide."
	icon_state = "rusted_cowboy"
	inhand_icon_state = "rusted_cowboy"
	armor = list("tier" = 2, ENERGY = 15, BOMB = 70, BIO = 70, RAD = 70, FIRE = 70, ACID = 15)
	flags_inv = HIDEEARS|HIDEHAIR

/obj/item/clothing/head/f13/police
	name = "police hat"
	desc = "(I) The wasteland's finest."
	icon_state = "retropolice"
	inhand_icon_state = "fedora"
	armor = list("tier" = 1, ENERGY = 0, BOMB = 25, BIO = 0, RAD = 0)
	flags_inv = HIDEEARS|HIDEHAIR

/obj/item/clothing/head/simplekitty
	name = "kitty headband"
	desc = "A headband with a pair of cute kitty ears."
	icon_state = "kittyb"
	color = "#999999"
	armor = list("tier" = 0)

/obj/item/clothing/head/f13/riderw
	name = "Reinforced Rider Helmet" //Not raider. Rider. //Count up your sins
	desc = "(IV) It's a fancy two-tone metal helmet. It's been lined with additional plating and given a fresh coat of paint."
	icon_state = "riderw"
	inhand_icon_state = "riderw"
	armor = list("tier" = 4)

//Soft caps
/obj/item/clothing/head/soft/f13
	flags_inv = HIDEEARS|HIDEHAIR

/obj/item/clothing/head/soft/f13/baseball
	name = "baseball cap"
	desc = "(I) A type of soft cap with a rounded crown and a stiff peak projecting out the front."
	icon_state = "baseballsoft"
	soft_type = "baseball"

/obj/item/clothing/head/soft/f13/utility
	name = "grey utility cover"
	desc = "(I) An eight-pointed hat, with a visor similar to a baseball cap, known as utility cover, also called the utility cap or eight-pointed cover."
	icon_state = "utility_g"
	//item_color = "utility_g"

/obj/item/clothing/head/soft/f13/utility/navy
	name = "navy utility cover"
	icon_state = "utility_n"
	//item_color = "utility_n"

/obj/item/clothing/head/soft/f13/utility/olive
	name = "olive utility cover"
	icon_state = "utility_o"
	//item_color = "utility_o"

/obj/item/clothing/head/soft/f13/utility/tan
	name = "tan utility cover"
	icon_state = "utility_t"
	//item_color = "utility_t"


//DONOR, PATREON AND CUSTOM

/obj/item/clothing/head/donor/macarthur
	name = "Peaked Cap"
	desc = "(II) A resistant, tan peaked cap, typically worn by pre-War Generals."
	icon_state = "macarthur"
	inhand_icon_state = "macarthur"
	armor = list("tier" = 2, ENERGY = 20, BOMB = 0, BIO = 0, RAD = 0, FIRE = 20, ACID = 20)

/obj/item/clothing/head/helmet/f13/ncr/rangercombat/rigscustom
	name = "11th armored calvary helmet"
	desc = "An advanced combat helmet used by the 11th Armored Calvary Regiment before the war. There is a worn and faded 11th Armored Calvary Regiment's insignia just above the visor. The helmet itself has some scratches and dents sustained from battle."
	icon_state = "rigscustom_helmet"
	inhand_icon_state = "rigscustom_helmet"
	icon = 'modular_fallout/master_files/icons/fallout/clothing/hats.dmi'

/obj/item/clothing/head/helmet/f13/ncr/rangercombat/pricecustom
	name = "spider riot helmet"
	desc = "A customised riot helmet reminiscient of the more advanced riot helmets found in the Divide, sporting purple lenses over the traditional red or green and a pair of red fangs painted over the respirator. The back of the helmet has a the face of an albino spider painted over it."
	icon_state = "price_ranger"
	inhand_icon_state = "price_ranger"

/obj/item/clothing/head/helmet/f13/ncr/rangercombat/foxcustom
	name = "reclaimed ranger-hunter combat helmet"
	desc = "A reclaimed Ranger-Hunter centurion helmet, carefully and lovingly restored to working condition with a sniper's veil wrapped around the neck. 'DE OPPRESSO LIBER' is stenciled on the front."
	icon_state = "foxranger"
	inhand_icon_state = "foxranger"
	actions_types = list(/datum/action/item_action/toggle)
	toggle_message = "You put the sniper's veil on"
	alt_toggle_message = "You take the sniper's veil off"
	can_toggle = 1
	toggle_cooldown = 0

/obj/item/clothing/head/helmet/f13/ncr/rangercombat/degancustom
	name = "reclaimed ranger-hunter combat helmet"
	desc = "A reclaimed Ranger-Hunter centurion helmet, carefully and lovingly restored to working condition with a sniper's veil wrapped around the neck. 'DE OPPRESSO LIBER' is stenciled on the front."
	icon_state = "elite_riot"
	inhand_icon_state = "elite_riot"
	actions_types = list(/datum/action/item_action/toggle)
	toggle_message = "You put the sniper's veil on"
	alt_toggle_message = "You take the sniper's veil off"
	can_toggle = 1
	toggle_cooldown = 0
	armor = list("tier" = 2, ENERGY = 20, BOMB = 20, BIO = 20, RAD = 20, FIRE = 20, ACID = 20)

/obj/item/clothing/head/helmet/f13/ncr/rangercombat/mosshelmet
	name = "veteran patrol stetson"
	desc = "A weathered campaign hat tightly fitted over the viscera of a ranger combat helmet. The old stetson is faded with age and heavy use, having seen the green shores of California to the white peaks of the rockies."
	icon_state = "mosshelmet"
	inhand_icon_state = "mosshelmet"
	flags_inv = HIDEEARS|HIDEEYES|HIDEHAIR|HIDEFACE
	flags_cover = HEADCOVERSEYES

/obj/item/clothing/head/helmet/f13/power_armor/midwest/hardened
	name = "hardened midwestern power helmet"
	desc = "This helmet once belonged to the Midwestern branch of the Brotherhood of Steel, and now resides here. This particular one has gone through a chemical hardening process, increasing its armor capabilities."
	icon_state = "midwestpa_helm"
	inhand_icon_state = "midwestpa_helm"

/obj/item/clothing/head/helmet/f13/jasonmask
	name = "jasons mask"
	desc = "(II) A metal mask made specifically for jason."
	icon_state = "jasonmask"
	inhand_icon_state = "jasonmask"
	armor = list("tier" = 2, ENERGY = 20, BOMB = 70, BIO = 70, RAD = 70, FIRE = 65, ACID = 30)

/obj/item/clothing/head/welding/f13/fire
	name = "cremator welding helmet"
	desc = "(III) A welding helmet with flames painted on it.<br>It sure is creepy but also badass."
	icon_state = "welding_fire"
	inhand_icon_state = "welding"
	tint = 1
	armor = list("tier" = 3, ENERGY = 5, BOMB = 5, BIO = 0, RAD = 0, FIRE = 30, ACID = 0)

/obj/item/clothing/head/helmet/f13/atombeliever
	name = "believer headdress"
	desc = "(II) The headwear of the true faith."
	icon_state = "atombeliever"
	inhand_icon_state = "atombeliever"
	armor = list("tier" = 2, ENERGY = 45, BOMB = 55, BIO = 65, RAD = 100, FIRE = 60, ACID = 20)

/obj/item/clothing/head/f13/flatranger
	name = "NCR gambler ranger hat"
	desc = "(IV) A rustic, homely style gambler hat adorning an NCR Ranger patch. Yeehaw!"
	icon_state = "gamblerrang"
	inhand_icon_state = "gamblerrang"
	armor = list("tier" = 4, ENERGY = 30, BOMB = 25, BIO = 40, RAD = 40, FIRE = 80, ACID = 0)

/obj/item/clothing/head/helmet/f13/legion/venator/diohelmet
	name = "galerum lacertarex"
	desc = "(VI) The hide of a deadly green gecko affixed over a reinforced legion helmet. Its ghastly appearance serves as an intimidating gesture to those who do not yet fear the Lizard King."
	icon_state = "diohelmet"
	inhand_icon_state = "diohelmet"
	armor = list("tier" = 6, ENERGY = 15, BOMB = 25, BIO = 50, RAD = 20, FIRE = 70, ACID = 0)

/obj/item/clothing/head/helmet/f13/herbertranger
	name = "weathered desert ranger helmet"
	icon_state = "modified_usmc_riot"
	inhand_icon_state = "modified_usmc_riot"
	desc = "(IV) An ancient USMC riot helmet. This paticular piece retains the classic colouration of the legendary Desert Rangers, and looks as if it has been worn for decades; its night vision no longer seems to be functional. Scratched into the helmet is the sentence: 'Death to the Devils that simulate our freedom.'"
	armor = list("tier" = 4, ENERGY = 25, BOMB = 30, BIO = 20, RAD = 0, FIRE = 50, ACID = 0)
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEHAIR|HIDEFACIALHAIR|HIDEFACE
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	resistance_flags = LAVA_PROOF | FIRE_PROOF

/obj/item/clothing/head/helmet/f13/marlowhat
	name = "boss of the plains hat"
	desc = "(IV) A thick undyed felt cowboy hat, bleached from excessive sun exposure and creased from heavy usage."
	icon_state = "marlowhat"
	inhand_icon_state = "marlowhat"
	armor = list("tier" = 4, ENERGY = 25, BOMB = 30, BIO = 20, RAD = 0, FIRE = 50, ACID = 0)
	flags_inv = HIDEEARS|HIDEHAIR

/obj/item/clothing/head/helmet/f13/marlowhat/Initialize()
	. = ..()
	AddComponent(/datum/component/armor_plate)

/obj/item/clothing/head/f13/ranger_hat
	name = "grey cowboy hat"
	desc = "(II) A simple grey cowboy hat."
	icon_state = "ranger_grey_hat"
	inhand_icon_state = "ranger_grey_hat"
	armor = list("tier" = 2, ENERGY = 15, BOMB = 0, BIO = 0, RAD = 70, FIRE = 70, ACID = 15)
	flags_inv = HIDEEARS|HIDEHAIR

/obj/item/clothing/head/f13/ranger_hat/banded
	name = "banded cowboy hat"
	desc = "(II) A grey cowboy hat with a hat band decorated with brassen rings."
	icon = 'modular_fallout/master_files/icons/mob/clothing/head.dmi'
	icon_state = "ranger_hat_grey_banded"
	inhand_icon_state = "ranger_hat_grey_banded"

/obj/item/clothing/head/f13/ranger_hat/tan
	name = "tan cowboy hat"
	desc = "(II) A thick tanned leather hat, with a Montana Peak crease."
	icon_state = "ranger_tan_hat"
	inhand_icon_state = "ranger_tan_hat"

/obj/item/clothing/head/f13/chinahelmetcosmetic
	name = "dysfunctional chinese stealth helmet"
	desc = "(II) A bright yellow visor in a timelessly infamous shape makes this helmet immediately recognizable. It's non-ballistic, and it's power unit for the HUD has been long since removed."
	icon_state = "stealthhelmet"
	inhand_icon_state = "stealthhelmet"
