/*ALL MOB-RELATED DEFINES THAT DON'T BELONG IN ANOTHER FILE GO HERE*/

//Misc mob defines

//Ready states at roundstart for mob/dead/new_player
#define PLAYER_NOT_READY 0
#define PLAYER_READY_TO_PLAY 1
#define PLAYER_READY_TO_OBSERVE 2

//movement intent defines for the m_intent var
#define MOVE_INTENT_WALK "walk"
#define MOVE_INTENT_RUN  "run"
#define MOVE_INTENT_SPRINT "sprint"

//Blood levels
#define BLOOD_VOLUME_ABSOLUTE_MAX 2150
#define BLOOD_VOLUME_MAX_LETHAL BLOOD_VOLUME_ABSOLUTE_MAX
#define BLOOD_VOLUME_EXCESS 2100
#define BLOOD_VOLUME_MAXIMUM 2000
#define BLOOD_VOLUME_SLIME_SPLIT 1120
#define BLOOD_VOLUME_NORMAL 560
#define BLOOD_VOLUME_SAFE 475
#define BLOOD_VOLUME_OKAY 336
#define BLOOD_VOLUME_BAD 224
#define BLOOD_VOLUME_SURVIVE 122

// Blood circulation levels
#define BLOOD_CIRC_FULL 100
#define BLOOD_CIRC_SAFE 85
#define BLOOD_CIRC_OKAY 70
#define BLOOD_CIRC_BAD 60
#define BLOOD_CIRC_SURVIVE 30

// Mood levels
#define MOOD_LEVEL_HAPPY4 20
#define MOOD_LEVEL_HAPPY3 15
#define MOOD_LEVEL_HAPPY2 10
#define MOOD_LEVEL_HAPPY1 5
#define MOOD_LEVEL_NEUTRAL 0
#define MOOD_LEVEL_SAD1 -5
#define MOOD_LEVEL_SAD2 -10
#define MOOD_LEVEL_SAD3 -15
#define MOOD_LEVEL_SAD4 -20

// Values for flash_pain()
#define PAIN_SMALL "weakest_pain"
#define PAIN_MEDIUM "weak_pain"
#define PAIN_LARGE "pain"

//Germs and infections.
#define GERM_LEVEL_AMBIENT  275 // Maximum germ level you can reach by standing still.
#define GERM_LEVEL_MOVE_CAP 300 // Maximum germ level you can reach by running around.

#define INFECTION_LEVEL_ONE   250
#define INFECTION_LEVEL_TWO   500  // infections grow from ambient to two in ~5 minutes
#define INFECTION_LEVEL_THREE 1000 // infections grow from two to three in ~10 minutes

//Sizes of mobs, used by mob/living/var/mob_size
#define MOB_SIZE_TINY 1
#define MOB_SIZE_SMALL 5
#define MOB_SIZE_HUMAN 10
#define MOB_SIZE_LARGE 20
#define MOB_SIZE_HUGE 40 // Use this for things you don't want bluespace body-bagged

//Ventcrawling defines
#define VENTCRAWLER_NONE   0
#define VENTCRAWLER_NUDE   1
#define VENTCRAWLER_ALWAYS 2

//Mob bio-types flags
#define MOB_ORGANIC (1 << 0)
#define MOB_MINERAL (1 << 1)
#define MOB_ROBOTIC (1 << 2)
#define MOB_UNDEAD (1 << 3)
#define MOB_HUMANOID (1 << 4)
#define MOB_BUG (1 << 5)
#define MOB_BEAST (1 << 6)
#define MOB_EPIC (1 << 7) //megafauna
#define MOB_REPTILE (1 << 8)
#define MOB_SPIRIT (1 << 9)
#define MOB_PLANT (1 << 10)

#define DEFAULT_BODYPART_ICON_ORGANIC 'icons/mob/human_parts_greyscale.dmi'
#define DEFAULT_BODYPART_ICON_ROBOTIC 'icons/mob/augmentation/augments.dmi'

#define MONKEY_BODYPART "monkey"
#define ALIEN_BODYPART "alien"
#define LARVA_BODYPART "larva"

//Bodypart change blocking flags
///Bodypart does not get replaced during set_species()
#define BP_BLOCK_CHANGE_SPECIES (1<<0)

//Bodytype defines for how things can be worn, surgery, and other misc things.
///The limb is organic.
#define BODYTYPE_ORGANIC (1<<0)
///The limb is robotic.
#define BODYTYPE_ROBOTIC (1<<1)
///The limb fits the human mold. This is not meant to be literal, if the sprite "fits" on a human, it is "humanoid", regardless of origin.
#define BODYTYPE_HUMANOID (1<<2)
///The limb is digitigrade.
#define BODYTYPE_DIGITIGRADE (1<<3)
///The limb fits the monkey mold.
#define BODYTYPE_MONKEY (1<<4)
///The limb is snouted.
#define BODYTYPE_SNOUTED (1<<5)
///The limb is voxed
#define BODYTYPE_VOX_BEAK (1<<6)
///The limb is in the shape of a vox leg.
#define BODYTYPE_VOX_LEGS (1<<7)
///Vox limb that isnt a head or legs.
#define BODYTYPE_VOX_OTHER (1<<8)
///The limb is small and feathery
#define BODYTYPE_TESHARI (1<<9)
/// IPC heads.
#define BODYTYPE_BOXHEAD (1<<10)

//Defines for Species IDs
///A placeholder bodytype for xeno larva, so their limbs cannot be attached to anything.
#define BODYTYPE_LARVA_PLACEHOLDER (1<<11)
///The limb is from a xenomorph.
#define BODYTYPE_ALIEN (1<<12)

// Defines for Species IDs. Used to refer to the name of a species, for things like bodypart names or species preferences.
#define SPECIES_ABDUCTOR "abductor"
#define SPECIES_ANDROID "android"
#define SPECIES_DULLAHAN "dullahan"
#define SPECIES_ETHEREAL "ethereal"
#define SPECIES_FELINE "felinid"
#define SPECIES_FLYPERSON "fly"
#define SPECIES_HUMAN "human"
#define SPECIES_IPC "ipc"
#define SPECIES_JELLYPERSON "jelly"
#define SPECIES_SLIMEPERSON "slime"
#define SPECIES_LUMINESCENT "luminescent"
#define SPECIES_STARGAZER "stargazer"
#define SPECIES_LIZARD "lizard"
#define SPECIES_LIZARD_ASH "ashwalker"
#define SPECIES_LIZARD_SILVER "silverscale"
#define SPECIES_NIGHTMARE "nightmare"
#define SPECIES_MONKEY "monkey"
#define SPECIES_MOTH "moth"
#define SPECIES_MUSHROOM "mush"
#define SPECIES_PODPERSON "pod"
#define SPECIES_SAURIAN "saurian"
#define SPECIES_SHADOW "shadow"
#define SPECIES_SKELETON "skeleton"
#define SPECIES_SNAIL "snail"
#define SPECIES_TESHARI "teshari"
#define SPECIES_VAMPIRE "vampire"
#define SPECIES_VOX "vox"
#define SPECIES_ZOMBIE "zombie"
#define SPECIES_ZOMBIE_INFECTIOUS "memezombie"
#define SPECIES_ZOMBIE_KROKODIL "krokodil_zombie"

// Like species IDs, but not specifically attached a species.
#define BODYPART_ID_ALIEN "alien"
#define BODYPART_ID_ROBOTIC "robotic"
#define BODYPART_ID_DIGITIGRADE "digitigrade"
#define BODYPART_ID_LARVA "larva"

//See: datum/species/var/digitigrade_customization
///The species does not have digitigrade legs in generation.
#define DIGITIGRADE_NEVER 0
///The species can have digitigrade legs in generation
#define DIGITIGRADE_OPTIONAL 1
///The species is forced to have digitigrade legs in generation.
#define DIGITIGRADE_FORCED 2

///Digitigrade's prefs, used in features for legs if you're meant to be a Digitigrade.
#define DIGITIGRADE_LEGS "Digitigrade Legs"

// Health/damage defines
#define MAX_LIVING_HEALTH 100

//for determining which type of heartbeat sound is playing
///Heartbeat is beating fast for hard crit
#define BEAT_FAST 1
///Heartbeat is beating slow for soft crit
#define BEAT_SLOW 2
///Heartbeat is gone... He's dead Jim :(
#define BEAT_NONE 0

#define HUMAN_FAILBREATH_OXYLOSS 1

#define HEAT_DAMAGE_LEVEL_1 1 //Amount of damage applied when your body temperature just passes the 360.15k safety point
#define HEAT_DAMAGE_LEVEL_2 1.5 //Amount of damage applied when your body temperature passes the 400K point
#define HEAT_DAMAGE_LEVEL_3 4 //Amount of damage applied when your body temperature passes the 460K point and you are on fire

#define COLD_DAMAGE_LEVEL_1 0.25 //Amount of damage applied when your body temperature just passes the 260.15k safety point
#define COLD_DAMAGE_LEVEL_2 0.75 //Amount of damage applied when your body temperature passes the 200K point
#define COLD_DAMAGE_LEVEL_3 1.5 //Amount of damage applied when your body temperature passes the 120K point

//Note that gas heat damage is only applied once every FOUR ticks.
#define HEAT_GAS_DAMAGE_LEVEL_1 2 //Amount of damage applied when the current breath's temperature just passes the 360.15k safety point
#define HEAT_GAS_DAMAGE_LEVEL_2 4 //Amount of damage applied when the current breath's temperature passes the 400K point
#define HEAT_GAS_DAMAGE_LEVEL_3 8 //Amount of damage applied when the current breath's temperature passes the 1000K point

#define COLD_GAS_DAMAGE_LEVEL_1 0.5 //Amount of damage applied when the current breath's temperature just passes the 260.15k safety point
#define COLD_GAS_DAMAGE_LEVEL_2 1.5 //Amount of damage applied when the current breath's temperature passes the 200K point
#define COLD_GAS_DAMAGE_LEVEL_3 3 //Amount of damage applied when the current breath's temperature passes the 120K point

//Brain Damage defines
#define BRAIN_DAMAGE_MILD 20
#define BRAIN_DAMAGE_SEVERE 100
#define BRAIN_DAMAGE_CRITICAL 150
#define BRAIN_DAMAGE_DEATH 200

#define BRAIN_TRAUMA_MILD /datum/brain_trauma/mild
#define BRAIN_TRAUMA_SEVERE /datum/brain_trauma/severe
#define BRAIN_TRAUMA_SPECIAL /datum/brain_trauma/special
#define BRAIN_TRAUMA_MAGIC /datum/brain_trauma/magic

#define TRAUMA_RESILIENCE_BASIC 1      //Curable with chems
#define TRAUMA_RESILIENCE_SURGERY 2    //Curable with brain surgery
#define TRAUMA_RESILIENCE_LOBOTOMY 3   //Curable with lobotomy
#define TRAUMA_RESILIENCE_WOUND 4    //Curable by healing the head wound
#define TRAUMA_RESILIENCE_MAGIC 5      //Curable only with magic
#define TRAUMA_RESILIENCE_ABSOLUTE 6   //This is here to stay

//Limit of traumas for each resilience tier
#define TRAUMA_LIMIT_BASIC 3
#define TRAUMA_LIMIT_SURGERY 2
#define TRAUMA_LIMIT_WOUND 2
#define TRAUMA_LIMIT_LOBOTOMY 3
#define TRAUMA_LIMIT_MAGIC 3
#define TRAUMA_LIMIT_ABSOLUTE INFINITY

#define BRAIN_DAMAGE_INTEGRITY_MULTIPLIER 0.5

//Surgery Defines
#define BIOWARE_GENERIC "generic"
#define BIOWARE_NERVES "nerves"
#define BIOWARE_CIRCULATION "circulation"
#define BIOWARE_LIGAMENTS "ligaments"
#define BIOWARE_CORTEX "cortex"

#define SURGERY_CLOSED 0
#define SURGERY_OPEN 1
#define SURGERY_RETRACTED 2
#define SURGERY_DEENCASED 3

//Health hud screws for carbon mobs
#define SCREWYHUD_NONE 0
#define SCREWYHUD_CRIT 1
#define SCREWYHUD_DEAD 2
#define SCREWYHUD_HEALTHY 3

//Health doll screws for human mobs
#define SCREWYDOLL_HEAD /obj/item/bodypart/head
#define SCREWYDOLL_CHEST /obj/item/bodypart/chest
#define SCREWYDOLL_L_ARM /obj/item/bodypart/arm/left
#define SCREWYDOLL_R_ARM /obj/item/bodypart/arm/right
#define SCREWYDOLL_L_LEG /obj/item/bodypart/leg/left
#define SCREWYDOLL_R_LEG /obj/item/bodypart/leg/right

//Threshold levels for beauty for humans
#define BEAUTY_LEVEL_HORRID -66
#define BEAUTY_LEVEL_BAD -33
#define BEAUTY_LEVEL_DECENT 33
#define BEAUTY_LEVEL_GOOD 66
#define BEAUTY_LEVEL_GREAT 100

//Nutrition levels for humans
#define NUTRITION_LEVEL_FAT 600
#define NUTRITION_LEVEL_FULL 550
#define NUTRITION_LEVEL_WELL_FED 450
#define NUTRITION_LEVEL_FED 350
#define NUTRITION_LEVEL_HUNGRY 250
#define NUTRITION_LEVEL_STARVING 150

#define NUTRITION_LEVEL_START_MIN 250
#define NUTRITION_LEVEL_START_MAX 400

//Disgust levels for humans
#define DISGUST_LEVEL_MAXEDOUT 150
#define DISGUST_LEVEL_DISGUSTED 75
#define DISGUST_LEVEL_VERYGROSS 50
#define DISGUST_LEVEL_GROSS 25

//Used as an upper limit for species that continuously gain nutriment
#define NUTRITION_LEVEL_ALMOST_FULL 535

//Charge levels for Ethereals
#define ETHEREAL_CHARGE_NONE 0
#define ETHEREAL_CHARGE_LOWPOWER 400
#define ETHEREAL_CHARGE_NORMAL 1000
#define ETHEREAL_CHARGE_ALMOSTFULL 1500
#define ETHEREAL_CHARGE_FULL 2000
#define ETHEREAL_CHARGE_OVERLOAD 2500
#define ETHEREAL_CHARGE_DANGEROUS 3000


#define CRYSTALIZE_COOLDOWN_LENGTH 120 SECONDS
#define CRYSTALIZE_PRE_WAIT_TIME 40 SECONDS
#define CRYSTALIZE_DISARM_WAIT_TIME 120 SECONDS
#define CRYSTALIZE_HEAL_TIME 60 SECONDS

#define BRUTE_DAMAGE_REQUIRED_TO_STOP_CRYSTALIZATION 30

#define CRYSTALIZE_STAGE_ENGULFING 100 //Cant use second defines
#define CRYSTALIZE_STAGE_ENCROACHING 300 //In switches
#define CRYSTALIZE_STAGE_SMALL 600 //Because they're not static

//Slime evolution threshold. Controls how fast slimes can split/grow
#define SLIME_EVOLUTION_THRESHOLD 10

//Slime extract crossing. Controls how many extracts is required to feed to a slime to core-cross.
#define SLIME_EXTRACT_CROSSING_REQUIRED 10

//Slime commands defines
#define SLIME_FRIENDSHIP_FOLLOW 3 //Min friendship to order it to follow
#define SLIME_FRIENDSHIP_STOPEAT 5 //Min friendship to order it to stop eating someone
#define SLIME_FRIENDSHIP_STOPEAT_NOANGRY 7 //Min friendship to order it to stop eating someone without it losing friendship
#define SLIME_FRIENDSHIP_STOPCHASE 4 //Min friendship to order it to stop chasing someone (their target)
#define SLIME_FRIENDSHIP_STOPCHASE_NOANGRY 6 //Min friendship to order it to stop chasing someone (their target) without it losing friendship
#define SLIME_FRIENDSHIP_STAY 3 //Min friendship to order it to stay
#define SLIME_FRIENDSHIP_ATTACK 8 //Min friendship to order it to attack

//Sentience types, to prevent things like sentience potions from giving bosses sentience
#define SENTIENCE_ORGANIC 1
#define SENTIENCE_ARTIFICIAL 2
#define SENTIENCE_HUMANOID 3
#define SENTIENCE_BOSS 4

//Mob AI Status
#define POWER_RESTORATION_OFF 0
#define POWER_RESTORATION_START 1
#define POWER_RESTORATION_SEARCH_APC 2
#define POWER_RESTORATION_APC_FOUND 3

//Hostile simple animals
//If you add a new status, be sure to add a list for it to the simple_animals global in _globalvars/lists/mobs.dm
#define AI_ON 1
#define AI_IDLE 2
#define AI_OFF 3
#define AI_Z_OFF 4

//The range at which a mob should wake up if you spawn into the z level near it
#define MAX_SIMPLEMOB_WAKEUP_RANGE 5

//determines if a mob can smash through it
#define ENVIRONMENT_SMASH_NONE 0
#define ENVIRONMENT_SMASH_STRUCTURES (1<<0) //crates, lockers, ect
#define ENVIRONMENT_SMASH_WALLS (1<<1)  //walls
#define ENVIRONMENT_SMASH_RWALLS (1<<2) //rwalls

// Slip flags, also known as lube flags
/// The mob will not slip if they're walking intent
#define NO_SLIP_WHEN_WALKING (1<<0)
/// Slipping on this will send them sliding a few tiles down
#define SLIDE (1<<1)
/// Ice slides only go one tile and don't knock you over, they're intended to cause a "slip chain"
/// where you slip on ice until you reach a non-slippable tile (ice puzzles)
#define SLIDE_ICE (1<<2)
/// [TRAIT_NO_SLIP_WATER] does not work on this slip. ONLY [TRAIT_NO_SLIP_ALL] will
#define GALOSHES_DONT_HELP (1<<3)
/// Slip works even if you're already on the ground
#define SLIP_WHEN_CRAWLING (1<<4)

#define MAX_CHICKENS 50

///Flags used by the flags parameter of electrocute act.

/// The shock is applied by hands, check gloves siemen coeff
#define SHOCK_HANDS (1 << 0)
/// Shock damage is reduced by the average siemen's coeff
#define SHOCK_USE_AVG_SIEMENS (1 << 4)
///Used when an illusion shocks something. Makes the shock deal stamina damage and not trigger certain secondary effects.
#define SHOCK_ILLUSION (1 << 2)
///The shock doesn't stun.
#define SHOCK_NOSTUN (1 << 3)

#define INCORPOREAL_MOVE_BASIC 1 /// normal movement, see: [/mob/living/var/incorporeal_move]
#define INCORPOREAL_MOVE_SHADOW 2 /// leaves a trail of shadows
#define INCORPOREAL_MOVE_JAUNT 3 /// is blocked by holy water/salt

//Secbot and ED209 judgement criteria bitflag values
#define JUDGE_EMAGGED (1<<0)
#define JUDGE_IDCHECK (1<<1)
#define JUDGE_WEAPONCHECK (1<<2)
#define JUDGE_RECORDCHECK (1<<3)
//ED209's ignore monkeys
#define JUDGE_IGNOREMONKEYS (1<<4)

#define SHADOW_SPECIES_LIGHT_THRESHOLD 0.2

#define COOLDOWN_UPDATE_SET_MELEE "set_melee"
#define COOLDOWN_UPDATE_ADD_MELEE "add_melee"
#define COOLDOWN_UPDATE_SET_RANGED "set_ranged"
#define COOLDOWN_UPDATE_ADD_RANGED "add_ranged"
#define COOLDOWN_UPDATE_SET_ENRAGE "set_enrage"
#define COOLDOWN_UPDATE_ADD_ENRAGE "add_enrage"
#define COOLDOWN_UPDATE_SET_SPAWN "set_spawn"
#define COOLDOWN_UPDATE_ADD_SPAWN "add_spawn"
#define COOLDOWN_UPDATE_SET_HELP "set_help"
#define COOLDOWN_UPDATE_ADD_HELP "add_help"
#define COOLDOWN_UPDATE_SET_DASH "set_dash"
#define COOLDOWN_UPDATE_ADD_DASH "add_dash"
#define COOLDOWN_UPDATE_SET_TRANSFORM "set_transform"
#define COOLDOWN_UPDATE_ADD_TRANSFORM "add_transform"
#define COOLDOWN_UPDATE_SET_CHASER "set_chaser"
#define COOLDOWN_UPDATE_ADD_CHASER "add_chaser"
#define COOLDOWN_UPDATE_SET_ARENA "set_arena"
#define COOLDOWN_UPDATE_ADD_ARENA "add_arena"

// Offsets defines

#define OFFSET_UNIFORM "uniform"
#define OFFSET_ID "id"
#define OFFSET_GLOVES "gloves"
#define OFFSET_GLASSES "glasses"
#define OFFSET_EARS "ears"
#define OFFSET_SHOES "shoes"
#define OFFSET_S_STORE "s_store"
#define OFFSET_FACEMASK "mask"
#define OFFSET_HEAD "head"
#define OFFSET_FACE "face"
#define OFFSET_BELT "belt"
#define OFFSET_BACK "back"
#define OFFSET_SUIT "suit"
#define OFFSET_NECK "neck"
#define OFFSET_ACCESSORY "accessory"

//MINOR TWEAKS/MISC
#define AGE_MIN 18 //youngest a character can be
#define AGE_MAX 85 //oldest a character can be
#define AGE_MINOR 20  //legal age of space drinking and smoking
#define WIZARD_AGE_MIN 30 //youngest a wizard can be
#define APPRENTICE_AGE_MIN 29 //youngest an apprentice can be
#define POCKET_STRIP_DELAY (4 SECONDS) //time taken to search somebody's pockets
#define DOOR_CRUSH_DAMAGE 15 //the amount of damage that airlocks deal when they crush you

/// Applies a Chemical Effect with the given magnitude to the mob
#define APPLY_CHEM_EFFECT(mob, effect, magnitude) \
	if(effect in mob.chem_effects) { \
		mob.chem_effects[effect] += magnitude; \
	} \
	else { \
		mob.chem_effects[effect] = magnitude; \
	}

#define SET_CHEM_EFFECT_IF_LOWER(mob, effect, magnitude) \
	if(effect in mob.chem_effects) { \
		mob.chem_effects[effect] = max(magnitude , mob.chem_effects[effect]); \
	} \
	else { \
		mob.chem_effects[effect] = magnitude; \
	}

///Check chem effect presence in a mob
#define CHEM_EFFECT_MAGNITUDE(mob, effect) (mob.chem_effects[effect] || 0)

//CHEMICAL EFFECTS
/// Prevents damage from freezing. Boolean.
#define CE_CRYO "cryo"
/// Inaprovaline
#define CE_STABLE "stable"
/// Breathing depression, makes you need more air
#define CE_BREATHLOSS "breathloss"
/// Fights off necrosis in bodyparts and organs
#define CE_ANTIBIOTIC "antibiotic"
/// Iron/nutriment
#define CE_BLOODRESTORE "bloodrestore"
#define CE_PAINKILLER "painkiller"
/// Liver filtering
#define CE_ALCOHOL       "alcohol"
/// Liver damage
#define CE_ALCOHOL_TOXIC "alcotoxic"
/// Increases or decreases heart rate
#define CE_PULSE "xcardic"
/// Reduces incoming toxin damage and helps with liver filtering
#define CE_ANTITOX "antitox"
/// Dexalin.
#define CE_OXYGENATED "oxygen"
/// Anti-virus effect.
#define CE_ANTIVIRAL "antiviral"
// Generic toxins, stops autoheal.
#define CE_TOXIN "toxins"
/// Gets in the way of blood circulation, higher the worse
#define CE_BLOCKAGE "blockage"
/// Lowers the subject's voice to a whisper
#define	CE_VOICELOSS "whispers"
/// Makes it harder to disarm someone
#define CE_STIMULANT "stimulants"
/// Multiplier for bloodloss
#define CE_ANTICOAGULANT "anticoagulant"
/// Enables brain regeneration even in poor circumstances
#define CE_BRAIN_REGEN "brainregen"

// Pulse levels, very simplified.
#define PULSE_NONE 0 // So !M.pulse checks would be possible.
#define PULSE_SLOW 1 // <60 bpm
#define PULSE_NORM 2 //  60-90 bpm
#define PULSE_FAST 3 //  90-120 bpm
#define PULSE_2FAST 4 // >120 bpm
#define PULSE_THREADY 5 // Occurs during hypovolemic shock
#define GETPULSE_HAND 0 // Less accurate. (hand)
#define GETPULSE_TOOL 1 // More accurate. (med scanner, sleeper, etc.)
#define PULSE_MAX_BPM 250 // Highest, readable BPM by machines and humans.

// Partial stasis sources
#define STASIS_CRYOGENIC_FREEZING "cryo"

// Eye protection
#define FLASH_PROTECTION_SENSITIVE -1
#define FLASH_PROTECTION_NONE 0
#define FLASH_PROTECTION_FLASH 1
#define FLASH_PROTECTION_WELDER 2

// If a mob has a higher threshold than this, the icon shown will be increased to the big fire icon.
#define MOB_BIG_FIRE_STACK_THRESHOLD 3

// Roundstart trait system

#define MAX_QUIRKS 6 //The maximum amount of quirks one character can have at roundstart

// AI Toggles
#define AI_CAMERA_LUMINOSITY 5
#define AI_VOX // Comment out if you don't want VOX to be enabled and have players download the voice sounds.

// /obj/item/bodypart on_mob_life() retval flag
#define BODYPART_LIFE_UPDATE_HEALTH (1<<0)
#define BODYPART_LIFE_UPDATE_HEALTH_HUD (1<<1)
#define BODYPART_LIFE_UPDATE_DAMAGE_OVERLAYS (1<<2)

#define MAX_REVIVE_FIRE_DAMAGE 180
#define MAX_REVIVE_BRUTE_DAMAGE 180

#define HUMAN_FIRE_STACK_ICON_NUM 3

#define GRAB_PIXEL_SHIFT_PASSIVE 6
#define GRAB_PIXEL_SHIFT_AGGRESSIVE 12
#define GRAB_PIXEL_SHIFT_NECK 16

#define PULL_PRONE_SLOWDOWN 1.5
#define HUMAN_CARRY_SLOWDOWN 0.35

//Flags that control what things can spawn species (whitelist) (changesource_flagx)
//Badmin magic mirror
#define MIRROR_BADMIN (1<<0)
//Standard magic mirror (wizard)
#define MIRROR_MAGIC (1<<1)
//Pride ruin mirror
#define MIRROR_PRIDE (1<<2)
//Race swap wizard event
#define RACE_SWAP (1<<3)
//ERT spawn template (avoid races that don't function without correct gear)
#define ERT_SPAWN (1<<4)
//xenobio black crossbreed
#define SLIME_EXTRACT (1<<5)
//Wabbacjack staff projectiles
#define WABBAJACK (1<<6)

// Reasons a defibrilation might fail
#define DEFIB_POSSIBLE (1<<0)
#define DEFIB_FAIL_SUICIDE (1<<1)
#define DEFIB_FAIL_HUSK (1<<2)
#define DEFIB_FAIL_TISSUE_DAMAGE (1<<3)
#define DEFIB_FAIL_FAILING_HEART (1<<4)
#define DEFIB_FAIL_NO_HEART (1<<5)
#define DEFIB_FAIL_FAILING_BRAIN (1<<6)
#define DEFIB_FAIL_NO_BRAIN (1<<7)
#define DEFIB_FAIL_NO_INTELLIGENCE (1<<8)
#define DEFIB_FAIL_BLACKLISTED (1<<9)
#define DEFIB_NOGRAB_AGHOST (1<<10)

// Bit mask of possible return values by can_defib that would result in a revivable patient
#define DEFIB_REVIVABLE_STATES (DEFIB_FAIL_NO_HEART | DEFIB_FAIL_FAILING_HEART | DEFIB_FAIL_HUSK | DEFIB_FAIL_TISSUE_DAMAGE | DEFIB_FAIL_FAILING_BRAIN | DEFIB_POSSIBLE)

#define SLEEP_CHECK_DEATH(X, A) \
	sleep(X); \
	if(QDELETED(A)) return; \
	if(ismob(A)) { \
		var/mob/sleep_check_death_mob = A; \
		if(sleep_check_death_mob.stat == DEAD) return; \
	}


#define DOING_INTERACTION(user, interaction_key) (LAZYACCESS(user.do_afters, interaction_key))
#define DOING_INTERACTION_LIMIT(user, interaction_key, max_interaction_count) ((LAZYACCESS(user.do_afters, interaction_key) || 0) >= max_interaction_count)
#define DOING_INTERACTION_WITH_TARGET(user, target) (LAZYACCESS(user.do_afters, target))
#define DOING_INTERACTION_WITH_TARGET_LIMIT(user, target, max_interaction_count) ((LAZYACCESS(user.do_afters, target) || 0) >= max_interaction_count)

// recent examine defines
/// How long it takes for an examined atom to be removed from recent_examines. Should be the max of the below time windows
#define RECENT_EXAMINE_MAX_WINDOW 2 SECONDS
/// If you examine the same atom twice in this timeframe, we call examine_more() instead of examine()
#define EXAMINE_MORE_WINDOW 1 SECONDS
/// If you examine another mob who's successfully examined you during this duration of time, you two try to make eye contact. Cute!
#define EYE_CONTACT_WINDOW 2 SECONDS
/// If you yawn while someone nearby has examined you within this time frame, it will force them to yawn as well. Tradecraft!
#define YAWN_PROPAGATION_EXAMINE_WINDOW 2 SECONDS

/// How far away you can be to make eye contact with someone while examining
#define EYE_CONTACT_RANGE 5


#define SILENCE_RANGED_MESSAGE (1<<0)

// Body position defines.
/// Mob is standing up, usually associated with lying_angle value of 0.
#define STANDING_UP 0
/// Mob is lying down, usually associated with lying_angle values of 90 or 270.
#define LYING_DOWN 1

///How much a mob's sprite should be moved when they're lying down
#define PIXEL_Y_OFFSET_LYING -6

///Squash flags. For squashable element

///Whether or not the squashing requires the squashed mob to be lying down
#define SQUASHED_SHOULD_BE_DOWN (1<<0)
///Whether or not to gib when the squashed mob is moved over
#define SQUASHED_SHOULD_BE_GIBBED (1<<0)

/*
 * Defines for "AI emotions", allowing the AI to expression emotions
 * with status displays via emotes.
 */

#define AI_EMOTION_VERY_HAPPY "Very Happy"
#define AI_EMOTION_HAPPY "Happy"
#define AI_EMOTION_NEUTRAL "Neutral"
#define AI_EMOTION_UNSURE "Unsure"
#define AI_EMOTION_CONFUSED "Confused"
#define AI_EMOTION_SAD "Sad"
#define AI_EMOTION_BSOD "BSOD"
#define AI_EMOTION_BLANK "Blank"
#define AI_EMOTION_PROBLEMS "Problems?"
#define AI_EMOTION_AWESOME "Awesome"
#define AI_EMOTION_FACEPALM "Facepalm"
#define AI_EMOTION_THINKING "Thinking"
#define AI_EMOTION_FRIEND_COMPUTER "Friend Computer"
#define AI_EMOTION_DORFY "Dorfy"
#define AI_EMOTION_BLUE_GLOW "Blue Glow"
#define AI_EMOTION_RED_GLOW "Red Glow"

/// Icon state to use for ai displays that just turns them off
#define AI_DISPLAY_DONT_GLOW "ai_off"

/// Throw modes, defines whether or not to turn off throw mode after
#define THROW_MODE_DISABLED 0
#define THROW_MODE_TOGGLE 1
#define THROW_MODE_HOLD 2

//Saves a proc call, life is suffering. If who has no targets_from var, we assume it's just who
#define GET_TARGETS_FROM(who) (who.targets_from ? who.get_targets_from() : who)

//defines for grad_color and grad_styles list access keys
#define GRADIENT_HAIR_KEY 1
#define GRADIENT_FACIAL_HAIR_KEY 2
//Keep up to date with the highest key value
#define GRADIENTS_LEN 2

// /datum/sprite_accessory/gradient defines
#define GRADIENT_APPLIES_TO_HAIR (1<<0)
#define GRADIENT_APPLIES_TO_FACIAL_HAIR (1<<1)

/// Sign Language defines
#define SIGN_ONE_HAND 0
#define SIGN_HANDS_FULL 1
#define SIGN_ARMLESS 2
#define SIGN_TRAIT_BLOCKED 3
#define SIGN_CUFFED 4

// Mob Overlays Indexes
/// Total number of layers for mob overlays
#define TOTAL_LAYERS 34 //KEEP THIS UP-TO-DATE OR SHIT WILL BREAK ;_;
/// Mutations layer - Tk headglows, cold resistance glow, etc
#define MUTATIONS_LAYER 34
/// Mutantrace features (tail when looking south) that must appear behind the body parts
#define BODY_BEHIND_LAYER 33
/// Layer for bodyparts that should appear behind every other bodypart - Mostly, legs when facing WEST or EAST
#define BODYPARTS_LOW_LAYER 32
/// Layer for most bodyparts, appears above BODYPARTS_LOW_LAYER and below BODYPARTS_HIGH_LAYER
#define BODYPARTS_LAYER 31
/// Mutantrace features (snout, body markings) that must appear above the body parts
#define BODY_ADJ_LAYER 30
/// Eyes!
#define EYE_LAYER 29
/// Underwear, undershirts, socks, eyes, lips(makeup)
#define BODY_LAYER 28
/// Mutations that should appear above body, body_adj and bodyparts layer (e.g. laser eyes)
#define FRONT_MUTATIONS_LAYER 27
/// Damage indicators (cuts and burns)
#define DAMAGE_LAYER 26
/// Jumpsuit clothing layer
#define UNIFORM_LAYER 25
/// ID card layer (might be deprecated)
#define ID_LAYER 24
/// ID card layer
#define ID_CARD_LAYER 23
/// Layer for bodyparts that should appear above every other bodypart - Currently only used for hands
#define BODYPARTS_HIGH_LAYER 22
/// Gloves layer
#define GLOVES_LAYER 21
/// Shoes layer
#define SHOES_LAYER 20
/// Ears layer (Spessmen have ears? Wow)
#define EARS_LAYER 19
/// Suit layer (armor, hardsuits, etc.)
#define SUIT_LAYER 18
/// Glasses layer
#define GLASSES_LAYER 17
/// Belt layer
#define BELT_LAYER 16 //Possible make this an overlay of somethign required to wear a belt?
/// Suit storage layer (tucking a gun or baton underneath your armor)
#define SUIT_STORE_LAYER 15
/// Neck layer (for wearing ties and bedsheets)
#define NECK_LAYER 14
/// Back layer (for backpacks and equipment on your back)
#define BACK_LAYER 13
/// Hair layer (mess with the fro and you got to go!)
#define HAIR_LAYER 12 //TODO: make part of head layer?
/// Facemask layer (gas masks, breath masks, etc.)
#define FACEMASK_LAYER 11
/// Head layer (hats, helmets, etc.)
#define HEAD_LAYER 10
/// Handcuff layer (when your hands are cuffed)
#define HANDCUFF_LAYER 9
/// Legcuff layer (when your feet are cuffed)
#define LEGCUFF_LAYER 8
/// Hands layer (for the actual hand, not the arm... I think?)
#define HANDS_LAYER 7
/// Body front layer. Usually used for mutant bodyparts that need to be in front of stuff (e.g. cat ears)
#define BODY_FRONT_LAYER 6
/// Special body layer that actually require to be above the hair (e.g. lifted welding goggles)
#define ABOVE_BODY_FRONT_GLASSES_LAYER 5
/// Special body layer for the rare cases where something on the head needs to be above everything else (e.g. flowers)
#define ABOVE_BODY_FRONT_HEAD_LAYER 4
/// Bleeding wound icons
#define WOUND_LAYER 3
/// Blood cult ascended halo layer, because there's currently no better solution for adding/removing
#define HALO_LAYER 2
/// Fire layer when you're on fire
#define FIRE_LAYER 1

//Mob Overlay Index Shortcuts for alternate_worn_layer, layers
//Because I *KNOW* somebody will think layer+1 means "above"
//IT DOESN'T OK, IT MEANS "UNDER"
/// The layer underneath the suit
#define UNDER_SUIT_LAYER (SUIT_LAYER+1)
/// The layer underneath the head (for hats)
#define UNDER_HEAD_LAYER (HEAD_LAYER+1)

//AND -1 MEANS "ABOVE", OK?, OK!?!
/// The layer above shoes
#define ABOVE_SHOES_LAYER (SHOES_LAYER-1)
/// The layer above mutant body parts
#define ABOVE_BODY_FRONT_LAYER (BODY_FRONT_LAYER-1)

//used by canUseTopic()
/// Needs to be Adjacent() to target.
#define USE_CLOSE (1<<0)
/// Needs to be an AdvancedToolUser
#define USE_DEXTERITY (1<<1)
// Forbid TK overriding USE_CLOSE
#define USE_IGNORE_TK (1<<2)
/// The mob needs to have hands (Does not need EMPTY hands)
#define USE_NEED_HANDS (1<<3)
/// Allows the mob to be resting
#define USE_RESTING (1<<4)
/// Ignore USE_CLOSE if they have silicon reach
#define USE_SILICON_REACH (1<<5)
/// Needs to be literate
#define USE_LITERACY (1<<6)


/// The default mob sprite size (used for shrinking or enlarging the mob sprite to regular size)
#define RESIZE_DEFAULT_SIZE 1

//Lying angles, which way your head points
#define LYING_ANGLE_EAST 90
#define LYING_ANGLE_WEST 270

/// Get the client from the var
#define CLIENT_FROM_VAR(I) (ismob(I) ? I:client : (istype(I, /client) ? I : (istype(I, /datum/mind) ? I:current?:client : null)))

/// The mob will vomit a green color
#define VOMIT_TOXIC 1
/// The mob will vomit a purple color
#define VOMIT_PURPLE 2

/// Possible value of [/atom/movable/buckle_lying]. If set to a different (positive-or-zero) value than this, the buckling thing will force a lying angle on the buckled.
#define NO_BUCKLE_LYING -1

GLOBAL_REAL_VAR(list/voice_type2sound) = list(
	"1" = list(
		"1" = sound('goon/sounds/speak_1.ogg'),
		"!" = sound('goon/sounds/speak_1_exclaim.ogg'),
		"?" = sound('goon/sounds/speak_1_ask.ogg')
	),
	"2" = list(
		"2" = sound('goon/sounds/speak_2.ogg'),
		"!" = sound('goon/sounds/speak_2_exclaim.ogg'),
		"?" = sound('goon/sounds/speak_2_ask.ogg')
	),
	"3" = list(
		"3" = sound('goon/sounds/speak_3.ogg'),
		"!" = sound('goon/sounds/speak_3_exclaim.ogg'),
		"?" = sound('goon/sounds/speak_3_ask.ogg')
	),
	"4" = list(
		"4" = sound('goon/sounds/speak_4.ogg'),
		"!" = sound('goon/sounds/speak_4_exclaim.ogg'),
		"?" = sound('goon/sounds/speak_4_ask.ogg')
	),
)

///Managed global that is a reference to the real global
GLOBAL_LIST_INIT(voice_type2sound_ref, voice_type2sound)

/// Breath succeeded completely
#define BREATH_OKAY 1
/// Breath caused damage, but should not be obvious
#define BREATH_SILENT_DAMAGING 0
/// Breath succeeded but is damaging.
#define BREATH_DAMAGING -1
/// Breath completely failed. chokies!!
#define BREATH_FAILED -2

/// Attack missed.
#define MOB_ATTACKEDBY_MISS 3
/// Attack completely failed (missing user, etc)
#define MOB_ATTACKEDBY_FAIL 0
/// Attack hit and dealt damage.
#define MOB_ATTACKEDBY_SUCCESS 1
/// Attack hit but did no damage.
#define MOB_ATTACKEDBY_NO_DAMAGE 2

#define BLIND_NOT_BLIND 0
#define BLIND_PHYSICAL 1
#define BLIND_SLEEPING 2
