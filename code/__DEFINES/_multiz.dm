
#define HasBelow(Z) (((Z) > world.maxz || (Z) < 2 || ((Z)-1) > length(SSmapping.multiz_levels)) ? 0 : SSmapping.multiz_levels[(Z)-1])
#define HasAbove(Z) (((Z) >= world.maxz || (Z) < 1 || (Z) > length(SSmapping.multiz_levels)) ? 0 : SSmapping.multiz_levels[(Z)])
//So below

#define GetAbove(A) (HasAbove(A:z) ? get_step(A, UP) : null)
#define GetBelow(A) (HasBelow(A:z) ? get_step(A, DOWN) : null)
