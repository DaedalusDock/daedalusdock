///The standard amount of bodyparts a carbon has. Currently 6, HEAD/arm/left/arm/right/CHEST/leg/left/R_LEG
#define BODYPARTS_DEFAULT_MAXIMUM 6

///A modifier applied to the chance to break bones on a given instance of damage
#define BODYPART_BONES_BREAK_CHANCE_MOD 1
///The minimum amount of brute damage for an attack to roll for bone jostle
#define BODYPART_MINIMUM_DAMAGE_TO_JIGGLEBONES 8

// Droplimb types.
#define DROPLIMB_EDGE 1
#define DROPLIMB_BLUNT 2
#define DROPLIMB_BURN 3

/// an attack must do this much damage after armor in order to be eliigible to dismember a suitably mushed bodypart
#define DROPLIMB_MINIMUM_DAMAGE 10

#define DROPLIMB_THRESHOLD_EDGE 0.2
#define DROPLIMB_THRESHOLD_TEAROFF 0.5
#define DROPLIMB_THRESHOLD_DESTROY 1

//Bodypart flags
#define BP_BLEEDING (1<<0)
#define BP_HAS_BLOOD (1<<1)
#define BP_HAS_BONES (1<<2)
#define BP_BROKEN_BONES (1<<3)
/// This limb has a tendon
#define BP_HAS_TENDON (1<<4)
/// This limb's tendon is cut, and is disabled.
#define BP_TENDON_CUT (1<<5)
/// This limb has an artery.
#define BP_HAS_ARTERY (1<<6)
/// This limb's artery is cut, causing massive bleeding.
#define BP_ARTERY_CUT (1<<7)
/// This limb has a "hand" and contributes to usable_arms
#define BP_IS_GRABBY_LIMB (1<<8)
/// This limb is able to be used for movement and contributes to usable_legs
#define BP_IS_MOVEMENT_LIMB (1<<9)
/// Limb is not connected to the nervous system and is not usable.
#define BP_CUT_AWAY (1<<10)
/// Limb cannot feel pain
#define BP_NO_PAIN (1<<11)

#define HATCH_CLOSED 1
#define HATCH_UNSCREWED 2
#define HATCH_OPENED 3

#define STOCK_BP_FLAGS_CHEST (BP_HAS_BLOOD | BP_HAS_BONES | BP_HAS_ARTERY)
#define STOCK_BP_FLAGS_HEAD (BP_HAS_BLOOD | BP_HAS_BONES | BP_HAS_ARTERY)
#define STOCK_BP_FLAGS_ARMS (BP_IS_GRABBY_LIMB | BP_HAS_BLOOD | BP_HAS_BONES | BP_HAS_TENDON | BP_HAS_ARTERY)
#define STOCK_BP_FLAGS_LEGS (BP_IS_MOVEMENT_LIMB | BP_HAS_BLOOD | BP_HAS_BONES | BP_HAS_TENDON | BP_HAS_ARTERY)

//check_bones() return values
#define CHECKBONES_NONE (1<<0)
#define CHECKBONES_OK (1<<1)
#define CHECKBONES_BROKEN (1<<2)

//check_tendon() return values
#define CHECKTENDON_NONE (1<<0)
#define CHECKTENDON_OK (1<<1)
#define CHECKTENDON_SEVERED (1<<2)

//check_artery() return values
#define CHECKARTERY_NONE (1<<0)
#define CHECKARTERY_OK (1<<1)
#define CHECKARTERY_SEVERED (1<<2)
