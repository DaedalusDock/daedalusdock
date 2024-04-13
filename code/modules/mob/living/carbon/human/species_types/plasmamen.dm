/datum/species/plasmaman
	name = "\improper Plasmaman"
	plural_form = "Plasmamen"
	id = SPECIES_PLASMAMAN
	say_mod = "rattles"
	sexes = 0
	meat = /obj/item/stack/sheet/mineral/plasma
	species_traits = list(NOBLOOD, NOTRANSSTING, BODY_RESIZABLE)
	// plasmemes get hard to wound since they only need a severe bone wound to dismember, but unlike skellies, they can't pop their bones back into place
	inherent_traits = list(
		TRAIT_ADVANCEDTOOLUSER,
		TRAIT_CAN_STRIP,
		TRAIT_RESISTCOLD,
		TRAIT_RADIMMUNE,
		TRAIT_GENELESS,
		TRAIT_NOHUNGER,
		TRAIT_HARDLY_WOUNDED,
	)

	inherent_biotypes = MOB_HUMANOID|MOB_MINERAL

	burnmod = 1.5
	heatmod = 1.5
	brutemod = 1.5

	breathid = GAS_PLASMA
	disliked_food = FRUIT | CLOTH
	liked_food = VEGETABLES
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_PRIDE | MIRROR_MAGIC
	species_cookie = /obj/item/reagent_containers/food/condiment/milk
	outfit_important_for_life = /datum/outfit/plasmaman

	bodypart_overrides = list(
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/plasmaman,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/plasmaman,
		BODY_ZONE_HEAD = /obj/item/bodypart/head/plasmaman,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/plasmaman,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/plasmaman,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/plasmaman,
	)

	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain,
		ORGAN_SLOT_HEART = null,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs/plasmaman,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes,
		ORGAN_SLOT_EARS =  /obj/item/organ/ears,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue/bone/plasmaman,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach/bone/plasmaman,
		ORGAN_SLOT_APPENDIX = null,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver/plasmaman,
		ORGAN_SLOT_KIDNEYS = /obj/item/organ/kidneys,
	)

	//* BODY TEMPERATURE THINGS *//
	cold_level_3 = 80
	cold_level_2 = 130
	cold_level_1 = (BODYTEMP_COLD_DAMAGE_LIMIT - 50) // about -50c
	cold_discomfort_level = 255

	bodytemp_normal = BODYTEMP_NORMAL - 40
	// The minimum amount they stabilize per tick is reduced making hot areas harder to deal with
	bodytemp_autorecovery_min = 2

	heat_discomfort_level = 300
	heat_level_1 = (BODYTEMP_HEAT_DAMAGE_LIMIT - 20) // about 40C
	heat_level_2 = 400
	heat_level_3 = 1000

	ass_image = 'icons/ass/assplasma.png'

	/// If the bones themselves are burning clothes won't help you much
	var/internal_fire = FALSE

/datum/species/plasmaman/on_species_gain(mob/living/carbon/C, datum/species/old_species, pref_load)
	. = ..()
	C.set_safe_hunger_level()

/datum/species/plasmaman/spec_life(mob/living/carbon/human/H, delta_time, times_fired)
	var/atmos_sealed = HAS_TRAIT(src, TRAIT_NOFIRE) && (isclothing(H.wear_suit) && H.wear_suit.clothing_flags & STOPSPRESSUREDAMAGE) && (isclothing(H.head) && H.head.clothing_flags & STOPSPRESSUREDAMAGE)
	var/flammable_limb = FALSE
	for(var/obj/item/bodypart/found_bodypart as anything in H.bodyparts)//If any plasma based limb is found the plasmaman will attempt to autoignite
		if(IS_ORGANIC_LIMB(found_bodypart) && (found_bodypart.limb_id == SPECIES_PLASMAMAN || HAS_TRAIT(found_bodypart, TRAIT_PLASMABURNT))) //Allows for "donated" limbs and augmented limbs to prevent autoignition
			flammable_limb = TRUE
			break
	if(!flammable_limb && !H.on_fire) //Allows their suit to attempt to autoextinguish if augged and on fire
		return
	if(!atmos_sealed && (!istype(H.w_uniform, /obj/item/clothing/under/plasmaman) || !istype(H.head, /obj/item/clothing/head/helmet/space/plasmaman) || !istype(H.gloves, /obj/item/clothing/gloves)))
		var/datum/gas_mixture/environment = H.loc.return_air()
		if(environment?.total_moles)
			/*if(environment.gases[/datum/gas/hypernoblium] && (environment.gases[/datum/gas/hypernoblium][MOLES]) >= 5)
				if(H.on_fire && H.fire_stacks > 0)
					H.adjust_fire_stacks(-10 * delta_time)*/
			if(!HAS_TRAIT(H, TRAIT_NOFIRE) && !HAS_TRAIT(H, TRAIT_NOSELFIGNITION))
				if(environment.hasGas(GAS_OXYGEN, 1)) //Same threshhold that extinguishes fire
					H.adjust_fire_stacks(0.25 * delta_time)
					if(!H.on_fire && H.fire_stacks > 0)
						H.visible_message(span_danger("[H]'s body reacts with the atmosphere and bursts into flames!"),span_userdanger("Your body reacts with the atmosphere and bursts into flame!"))
					H.ignite_mob()
					internal_fire = TRUE
	else if(H.fire_stacks)
		var/obj/item/clothing/under/plasmaman/P = H.w_uniform
		if(istype(P))
			P.Extinguish(H)
			internal_fire = FALSE
	else
		internal_fire = FALSE
	H.update_fire()

/datum/species/plasmaman/handle_fire(mob/living/carbon/human/H, delta_time, times_fired, no_protection = FALSE)
	if(internal_fire)
		no_protection = TRUE
	. = ..()

/datum/species/plasmaman/pre_equip_species_outfit(datum/outfit/O, mob/living/carbon/human/equipping, visuals_only = FALSE)
	if(!O)
		give_important_for_life(equipping)
		return

	var/obj/item/clothing/mask = O.mask
	if(!(mask && (initial(mask.clothing_flags) & MASKINTERNALS)))
		equipping.equip_to_slot(new /obj/item/clothing/mask/breath, ITEM_SLOT_MASK, TRUE, FALSE)

	if(!ispath(O.uniform, /obj/item/clothing/under/plasmaman))
		equipping.equip_to_slot(new /obj/item/clothing/under/plasmaman, ITEM_SLOT_ICLOTHING, TRUE, FALSE)

	if(!ispath(O.head, /obj/item/clothing/head/helmet/space/plasmaman))
		equipping.equip_to_slot(new /obj/item/clothing/head/helmet/space/plasmaman, ITEM_SLOT_HEAD, TRUE, FALSE)

	if(!ispath(O.gloves, /obj/item/clothing/gloves/color/plasmaman))
		equipping.equip_to_slot(new /obj/item/clothing/gloves/color/plasmaman, ITEM_SLOT_GLOVES, TRUE, FALSE)

	if(!ispath(O.r_hand, /obj/item/tank/internals/plasmaman) && !ispath(ispath(O.l_hand, /obj/item/tank/internals/plasmaman)))
		var/obj/item/tank/internals/plasmaman/belt/full/tank = new
		if(!O.r_hand)
			equipping.put_in_r_hand(tank)
		else if(!O.l_hand)
			equipping.put_in_l_hand(tank)
		else
			equipping.put_in_r_hand(tank)
		equipping.open_internals(tank)

/datum/species/plasmaman/give_important_for_life(mob/living/carbon/human/human_to_equip)
	. = ..()
	var/obj/item/I = human_to_equip.get_item_for_held_index(2)
	if(I)
		human_to_equip.open_internals(I)
	else
		var/obj/item/tank/internals/plasmaman/belt/new_tank = new(null)
		if(human_to_equip.equip_to_slot_or_del(new_tank, ITEM_SLOT_BELT))
			human_to_equip.open_internals(human_to_equip.belt)
		else
			stack_trace("Plasmaman going without internals. Uhoh.")

/datum/species/plasmaman/random_name(gender,unique,lastname)
	if(unique)
		return random_unique_plasmaman_name()

	var/randname = plasmaman_name()

	if(lastname)
		randname += " [lastname]"

	return randname

/datum/species/plasmaman/get_species_description()
	return "Found on the Icemoon of Freyja, plasmamen consist of colonial \
		fungal organisms which together form a sentient being. In human space, \
		they're usually attached to skeletons to afford a human touch."

/datum/species/plasmaman/get_species_lore()
	return list(
		"A confusing species, plasmamen are truly \"a fungus among us\". \
		What appears to be a singular being is actually a colony of millions of organisms \
		surrounding a found (or provided) skeletal structure.",

		"Originally discovered by NT when a researcher \
		fell into an open tank of liquid plasma, the previously unnoticed fungal colony overtook the body creating \
		the first \"true\" plasmaman. The process has since been streamlined via generous donations of convict corpses and plasmamen \
		have been deployed en masse throughout NT to bolster the workforce.",

		"New to the galactic stage, plasmamen are a blank slate. \
		Their appearance, generally regarded as \"ghoulish\", inspires a lot of apprehension in their crewmates. \
		It might be the whole \"flammable purple skeleton\" thing.",

		"The colonids that make up plasmamen require the plasma-rich atmosphere they evolved in. \
		Their psuedo-nervous system runs with externalized electrical impulses that immediately ignite their plasma-based bodies when oxygen is present.",
	)

/datum/species/plasmaman/create_pref_unique_perks()
	var/list/to_add = list()

	to_add += list(
		list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "user-shield",
			SPECIES_PERK_NAME = "Protected",
			SPECIES_PERK_DESC = "Plasmamen are immune to radiation, poisons, and most diseases.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "bone",
			SPECIES_PERK_NAME = "Wound Resistance",
			SPECIES_PERK_DESC = "Plasmamen have higher tolerance for damage that would wound others.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "wind",
			SPECIES_PERK_NAME = "Plasma Healing",
			SPECIES_PERK_DESC = "Plasmamen can heal wounds by consuming plasma.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "hard-hat",
			SPECIES_PERK_NAME = "Protective Helmet",
			SPECIES_PERK_DESC = "Plasmamen's helmets provide them shielding from the flashes of welding, as well as an inbuilt flashlight.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = "fire",
			SPECIES_PERK_NAME = "Living Torch",
			SPECIES_PERK_DESC = "Plasmamen instantly ignite when their body makes contact with oxygen.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = "wind",
			SPECIES_PERK_NAME = "Plasma Breathing",
			SPECIES_PERK_DESC = "Plasmamen must breathe plasma to survive. You receive a tank when you arrive.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = "briefcase-medical",
			SPECIES_PERK_NAME = "Complex Biology",
			SPECIES_PERK_DESC = "Plasmamen take specialized medical knowledge to be \
				treated. Do not expect speedy revival, if you are lucky enough to get \
				one at all.",
		),
	)

	return to_add
