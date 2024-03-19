/// Chance to drop your held item passed here
#define PAIN_THRESHOLD_DROP_ITEM 50
/// Chance to reduce paralysis duration passed here
#define PAIN_THRESHOLD_REDUCE_PARALYSIS 10
/// Stage at
#define SHOCK_MIN_PAIN_TO_BEGIN 30

/// Maximum shock stage value
#define SHOCK_MAXIMUM 160

#define SHOCK_TIER_1 10
#define SHOCK_TIER_2 30
#define SHOCK_TIER_3 40
#define SHOCK_TIER_4 60
#define SHOCK_TIER_5 80
#define SHOCK_TIER_6 120
#define SHOCK_TIER_7 150

/// The amount of shock required for someone to be elligible for shock-induced fibrillation
#define SHOCK_AMT_FOR_FIBRILLATION 120

/// The amount of pain where the mob is rendered unconscious
#define PAIN_AMT_PASSOUT (200)

/// The amount of pain where movement slowdown beings
#define PAIN_AMT_BEGIN_SLOWDOWN (PAIN_AMT_PASSOUT * 0.075)
#define PAIN_MAX_SLOWDOWN 5

#define PAIN_AMT_LOW (PAIN_AMT_PASSOUT * 0.05)
#define PAIN_AMT_MEDIUM (PAIN_AMT_PASSOUT * 0.35)
#define PAIN_AMT_AGONIZING (PAIN_AMT_PASSOUT * 0.85)

/// max_damage * this value is the amount of pain constantly applied when the limb bone is broken
#define BROKEN_BONE_PAIN_FACTOR 0.1
/// max_damage * this value is the amount of pain constantly applied when the limb is dislocated
#define DISLOCATED_LIMB_PAIN_FACTOR 0.05
/// The amount of pain applied immediately when a bone breaks
#define BONE_BREAK_APPLICATION_PAIN 60
