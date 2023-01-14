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

//CONFIG STUFF
///A modifier applied to wound auto healing
#define WOUND_REGENERATION_MODIFIER 0.25
