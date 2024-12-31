/mob/living/carbon
	maxHealth = 200
	blood_volume = BLOOD_VOLUME_NORMAL
	gender = MALE

	//pressure_resistance = 15
	hud_possible = list(
		HEALTH_HUD = 'icons/mob/huds/med_hud.dmi',
		STATUS_HUD = 'icons/mob/huds/hud.dmi',
		GLAND_HUD = 'icons/mob/huds/hud.dmi',
	)

	has_limbs = TRUE
	held_items = list(null, null)
	num_legs = 0 //Populated on init through list/bodyparts
	usable_legs = 0 //Populated on init through list/bodyparts
	num_hands = 0 //Populated on init through list/bodyparts
	usable_hands = 0 //Populated on init through list/bodyparts

	mobility_flags = MOBILITY_FLAGS_CARBON_DEFAULT
	rotate_on_lying = TRUE
	blocks_emissive = NONE
	zmm_flags = ZMM_MANGLE_PLANES //Emissive eyes :holding_back_tears:

	///List of [/obj/item/organ] in the mob.
	var/list/obj/item/organ/organs = list()
	///List of [/obj/item/organ] in the mob.
	var/list/obj/item/organ/cosmetic_organs = list()
	///Stores "slot ID" - "organ" pairs for easy access. Contains both functional and cosmetic organs
	var/list/organs_by_slot = list()
	///A list of organs that process, used to keep life() fast!
	var/list/obj/item/organ/processing_organs = list()

	/// Bloodstream reagents
	var/datum/reagents/bloodstream = null
	/// Surface level reagents
	var/datum/reagents/touching = null
	///Can't talk. Value goes down every life proc. NOTE TO FUTURE CODERS: DO NOT INITIALIZE NUMERICAL VARS AS NULL OR I WILL MURDER YOU.
	var/silent = 0

	///Whether or not the mob is handcuffed
	var/obj/item/handcuffed = null
	///Same as handcuffs but for legs. Bear traps use this.
	var/obj/item/legcuffed = null

	/// Measure of how disgusted we are. See DISGUST_LEVEL_GROSS and friends
	var/disgust = 0
	/// How disgusted we were LAST time we processed disgust. Helps prevent unneeded work
	var/old_disgust = 0

	//inventory slots
	var/obj/item/back = null
	var/obj/item/clothing/mask/wear_mask = null
	var/obj/item/clothing/neck/wear_neck = null
	var/obj/item/tank/internal = null
	/// "External" air tank. Never set this manually. Not required to stay directly equipped on the mob (i.e. could be a machine or MOD suit module).
	var/obj/item/tank/external = null
	var/obj/item/clothing/head = null

	///only used by humans
	var/obj/item/clothing/gloves = null
	///only used by humans.
	var/obj/item/clothing/shoes/shoes = null
	///only used by humans.
	var/obj/item/clothing/glasses/glasses = null
	///only used by humans.
	var/obj/item/clothing/ears = null

	/// A compilation of all equipped items 'flags_inv' vars.
	var/obscured_slots = NONE

	/// Carbon
	var/datum/dna/dna = null
	///last mind to control this mob, for blood-based cloning
	var/datum/mind/last_mind = null

	///This is used to determine if the mob failed a breath. If they did fail a brath, they will attempt to breathe each tick, otherwise just once per 4 ticks.
	var/failed_last_breath = FALSE

	var/co2overloadtime = null
	var/obj/item/food/meat/slab/type_of_meat = /obj/item/food/meat/slab

	var/gib_type = /obj/effect/decal/cleanable/blood/gibs

	/// Total level of visualy impairing items
	var/tinttotal = 0

	///Gets filled up in [create_bodyparts()][/mob/living/carbon/proc/create_bodyparts]
	var/list/bodyparts = list(
		/obj/item/bodypart/chest,
		/obj/item/bodypart/head,
		/obj/item/bodypart/arm/left,
		/obj/item/bodypart/arm/right,
		/obj/item/bodypart/leg/right,
		/obj/item/bodypart/leg/left,
	)

	/// A collection of arms (or actually whatever the fug /bodyparts you monsters use to wreck my systems)
	var/list/hand_bodyparts = list()

	///A cache of bodypart = icon to prevent excessive icon creation.
	var/list/icon_render_keys = list()

	//halucination vars
	var/hal_screwyhud = SCREWYHUD_NONE
	var/next_hallucination = 0
	var/damageoverlaytemp = 0

	/// Protection (insulation) from the heat, Value 0-1 corresponding to the percentage of protection
	var/heat_protection = 0 // No heat protection
	/// Protection (insulation) from the cold, Value 0-1 corresponding to the percentage of protection
	var/cold_protection = 0 // No cold protection

	/// Timer id of any transformation
	var/transformation_timer

	/// Simple modifier for whether this mob can handle greater or lesser skillchip complexity. See /datum/mutation/human/biotechcompat/ for example.
	var/skillchip_complexity_modifier = 0

	/// Can other carbons be shoved into this one to make it fall?
	var/can_be_shoved_into = FALSE

	/// Only load in visual organs
	var/visual_only_organs = FALSE

	///Is this carbon trying to sprint?
	var/sprint_key_down = FALSE
	var/sprinting = FALSE
	///How many tiles we have continuously moved in the same direction
	var/sustained_moves = 0
	//stores flavor text here.
	var/examine_text = ""

	COOLDOWN_DECLARE(bleeding_message_cd)
	COOLDOWN_DECLARE(blood_spray_cd)
	COOLDOWN_DECLARE(breath_sound_cd)
