// Flags for the organ_flags var on /obj/item/organ
#define ORGAN_SYNTHETIC (1<<0) //Synthetic organs, or cybernetic organs. Reacts to EMPs and don't deteriorate or heal
#define ORGAN_FROZEN (1<<1) //Frozen organs, don't deteriorate
#define ORGAN_DEAD (1<<2) //Failing organs perform damaging effects until replaced or fixed
#define ORGAN_EXTERNAL (1<<3) //Was this organ implanted/inserted/etc, if true will not be removed during species change.
#define ORGAN_VITAL (1<<4) //Currently only the brain
#define ORGAN_EDIBLE (1<<5) //is a snack? :D
#define ORGAN_SYNTHETIC_EMP (1<<6) //Synthetic organ affected by an EMP. Deteriorates over time.
#define ORGAN_UNREMOVABLE (1<<7) //Can't be removed using surgery
#define ORGAN_CUT_AWAY (1<<8) //! The organ is not attached to the parent.

// check_damage_threshold return values
#define ORGAN_NOW_FAILING 6
#define ORGAN_HIGH_THRESHOLD_PASSED 5
#define ORGAN_LOW_THRESHOLD_PASSED 4
#define ORGAN_LOW_THRESHOLD_CLEARED 3
#define ORGAN_HIGH_THRESHOLD_CLEARED 2
#define ORGAN_NOW_FIXED 1
