// Cotangent
#define COT(x) (1 / tan(x))

// Secant
#define SEC(x) (1 / cos(x))

// Cosecant
#define CSC(x) (1 / sin(x))

#define ATAN2(x, y) ( !(x) && !(y) ? 0 : (y) >= 0 ? arccos((x) / sqrt((x)*(x) + (y)*(y))) : -arccos((x) / sqrt((x)*(x) + (y)*(y))) )

/// The number of cells in a taxicab circle (rasterized diamond) of radius X.
#define DIAMOND_AREA(X) (1 + 2*(X)*((X)+1))

/// Reverse an angle. 45 -> 225, 0 -> 180, etc
#define REVERSE_ANGLE(angle) (floor((angle) + 180) % 360)

// Will filter out extra rotations and negative rotations
// E.g: 540 becomes 180. -180 becomes 180.
#define SIMPLIFY_DEGREES(degrees) (degrees %% 360)

#define GET_ANGLE_OF_INCIDENCE(face, input) (MODULUS((face) - (input), 360))

//Finds the shortest angle that angle A has to change to get to angle B. Aka, whether to move clock or counterclockwise.
/proc/closer_angle_difference(a, b)
	if(!isnum(a) || !isnum(b))
		return
	a = SIMPLIFY_DEGREES(a)
	b = SIMPLIFY_DEGREES(b)
	var/inc = b - a
	if(inc < 0)
		inc += 360
	var/dec = a - b
	if(dec < 0)
		dec += 360
	. = inc > dec? -dec : inc
