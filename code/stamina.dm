///Time before regen starts when in stam crit
#define STAMINA_CRIT_TIME (5 SECONDS)
///Time before regen starts when hit with stam damage
#define STAMINA_REGEN_TIME (2 SECONDS)
///The amount of stamina a carbon recovers every 2 seconds
#define STAMINA_REGEN 20

#define ATTACK_DO_NOTHING (0<<0)
#define ATTACK_HANDLED (1<<1)
#define ATTACK_CONSUME_STAMINA (1<<2)

////
/// STATS
////

///The maximum stamina a human has, after adding up all bodyparts.
#define STAMINA_HUMAN_MAX 250
///Carbons enter a "weakened" state over [maximum_stamina_loss] plus this value, opening them up to Disorient stuns.
#define STAMINA_EXHAUSTION_THRESHOLD_MODIFIER (-50)
///The slowdown when a mob is exhausted
#define STAMINA_EXHAUSTION_MOVESPEED_SLOWDOWN 3
///Carbons will become stamina stunned upon reaching or exceeding [maximum_stamina_loss] plus this value
#define STAMINA_STUN_THRESHOLD_MODIFIER 0



////
/// COMBAT
////

///The default swing cost of an item.
#define STAMINA_SWING_COST_ITEM 25
///The default stamina damage of an item
#define STAMINA_DAMAGE_ITEM 15
///The default stamina damage of unarmed attacks
#define STAMINA_DAMAGE_UNARMED 30
///The default stamina consumption of unarmed attacks
#define STAMINA_SWING_COST_UNARMED 15
///The default critical hit chance of an item
#define STAMINA_CRITICAL_RATE_ITEM 25
///The multiplier applied to damage on a critical
#define STAMINA_CRITICAL_MODIFIER 2
///The amount of stamina at which point swinging is free.
#define STAMINA_MAXIMUM_TO_SWING 150
///The time a mob is stunned when stamina stunned
#define STAMINA_STUN_TIME 5 SECONDS
