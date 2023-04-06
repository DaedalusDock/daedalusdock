
#define HasBelow(Z) (((z) > world.maxz || (Z) < 2 || ((Z)-1) > (SSmapping.z_levels)) ? 0 : SSmapping.z_levels[(Z)-1])
#define HasAbove(Z) (((Z) >= world.maxz || (Z) < 1 || (Z) > (SSmapping.z_levels)) ? 0 : SSmapping.z_levels[(Z)])
//So below

#define GetAbove(T) (HasAbove(T.z) ? get_step(T, UP) : null)
#define GetBelow(T) (HasBelow(T.z) ? get_step(T, DOWN) : null)
