#define SURGERY_NO_ROBOTIC (1<<0)
#define SURGERY_NO_STUMP (1<<1)
#define SURGERY_NO_FLESH (1<<2)
/// Bodypart needs an incision or small cut
#define SURGERY_NEEDS_INCISION (1<<3)
/// Bodypart needs retracted incision or large cut
#define SURGERY_NEEDS_RETRACTED (1<<4)
/// Bodypart needs a broken bone AND retracted incision or large cut
#define SURGERY_NEEDS_DEENCASEMENT (1<<5)
/// Surgery step bloodies gloves when necessary.
#define SURGERY_BLOODY_GLOVES (1<<6)
/// Surgery step bloodies gloves + suit when necessary.
#define SURGERY_BLOODY_BODY (1<<7)
/// Surgery does not use RNG.
#define SURGERY_CANNOT_FAIL (1<<8)

/// Only one of this type of implant may be in a target
#define IMPLANT_HIGHLANDER (1<<0)
/// Shows implant name in body scanner
#define IMPLANT_KNOWN (1<<1)
/// Hides the implant from the body scanner completely
#define IMPLANT_HIDDEN (1<<2)

