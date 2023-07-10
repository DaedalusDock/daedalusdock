#define SURGERY_NO_ROBOTIC (1<<0)
#define SURGERY_NO_CRYSTAL (1<<1)
#define SURGERY_NO_STUMP (1<<2)
#define SURGERY_NO_FLESH (1<<3)
/// Bodypart needs an incision or small cut
#define SURGERY_NEEDS_INCISION (1<<4)
/// Bodypart needs retracted incision or large cut
#define SURGERY_NEEDS_RETRACTED (1<<5)
/// Bodypart needs a broken bone AND retracted incision or large cut
#define SURGERY_NEEDS_DEENCASEMENT (1<<6)
