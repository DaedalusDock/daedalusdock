#define THIRST_STAGE_BLOODLUST 1
#define THIRST_STAGE_SATED 2
#define THIRST_STAGE_HUNGRY 3
#define THIRST_STAGE_STARVING 4
#define THIRST_STAGE_WASTING 5

// Point thresholds to change stages. 1 point = 1 second
#define THIRST_THRESHOLD_BLOODLUST 0
#define THIRST_THRESHOLD_SATED 240
#define THIRST_THRESHOLD_HUNGRY (THIRST_THRESHOLD_SATED + 900)
#define THIRST_THRESHOLD_STARVING (THIRST_THRESHOLD_HUNGRY + 420)
#define THIRST_THRESHOLD_WASTING (THIRST_THRESHOLD_STARVING + 420)
#define THIRST_THRESHOLD_DEAD (THIRST_THRESHOLD_WASTING + 420)

/// How much blood we can siphon from a target per VAMPIRE_BLOOD_SAME_TARGET_COOLDOWN
#define VAMPIRE_BLOOD_DRAIN_PER_TARGET 100
/// Drain per second
#define VAMPIRE_BLOOD_DRAIN_RATE 5
/// Coeff for calculating thirst satiation per unit of blood.
#define VAMPIRE_BLOOD_THIRST_EXCHANGE_COEFF 15 // A full drain is equivalent to 25 minutes of life. (100 * 15 / 60 = 25)
/// The amount of time before a victim can be fully drained again.
#define VAMPIRE_BLOOD_SAME_TARGET_COOLDOWN (10 MINUTES)
/// Calculate how much of a mob's blood budget will have been regenerated over a given time.
#define VAMPIRE_BLOOD_BUDGET_REGEN_FOR_DELTA(time_delta) (time_delta * (VAMPIRE_BLOOD_DRAIN_PER_TARGET / VAMPIRE_BLOOD_SAME_TARGET_COOLDOWN))
