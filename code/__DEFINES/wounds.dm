// Injury types for wounds
#define WOUND_CUT "cut"
#define WOUND_BRUISE "bruise"
#define WOUND_BURN "burn"
#define WOUND_PIERCE "pierce"
#define WOUND_LASER "laser"

// These control the amount of blood lost from burns. The loss is calculated so
// that dealing just enough burn damage to kill the player will cause the given
// proportion of their max blood volume to be lost
// (e.g. 0.6 == 60% lost if 200 burn damage is taken).

///For burns from heat applied over a wider area, like from fire
#define FLUIDLOSS_BURN_WIDE 0.15
///For concentrated burns, like from lasers
#define FLUIDLOSS_BURN_CONCENTRATED 0.1
///The amount of burn damage needed to cause fluid loss.
#define FLUIDLOSS_BURN_REQUIRED 5

//CONFIG STUFF
///A modifier applied to wound auto healing
#define WOUND_REGENERATION_MODIFIER 0.25

// ~wound damage/rolling defines
/// the cornerstone of the wound threshold system, your base wound roll for any attack is rand(1, damage^this), after armor reduces said damage. See [/obj/item/bodypart/proc/check_wounding]
#define WOUND_DAMAGE_EXPONENT 1.4
/// any damage dealt over this is ignored for damage rolls unless the target has the frail quirk (35^1.4=145, for reference)
#define WOUND_MAX_CONSIDERED_DAMAGE 35
/// an attack must do this much damage after armor in order to roll for being a wound (so pressure damage/being on fire doesn't proc it)
#define WOUND_MINIMUM_DAMAGE 5
/// If an attack rolls this high with their wound (including mods), we try to outright dismember the limb. Note 250 is high enough that with a perfect max roll of 145 (see max cons'd damage), you'd need +100 in mods to do this
#define WOUND_DISMEMBER_OUTRIGHT_THRESH 250


/// While someone has determination in their system, their bleed rate is slightly reduced
#define WOUND_DETERMINATION_BLEED_MOD 0.85

/// How often can we annoy the player about their bleeding? This duration is extended if it's not serious bleeding
#define BLEEDING_MESSAGE_BASE_CD 10 SECONDS

///The percentage of damage at which a bodypart can start to be dismembered.
#define LIMB_DISMEMBERMENT_PERCENT 0.6
