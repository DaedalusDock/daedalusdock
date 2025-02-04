/// Converts a whole number divisor to it's equivalent decimal multiplier. Idk how else to word this.
#define INVERSE(x) ( 1/(x) )

// Used for calculating the radioactive strength falloff
#define INVERSE_SQUARE(initial_strength,cur_distance,initial_distance) ( (initial_strength)*((initial_distance)**2/(cur_distance)**2) )

// Performs a linear interpolation between a and b.
// Note that amount=0 returns a, amount=1 returns b, and
// amount=0.5 returns the mean of a and b.
#define LERP(a, b, amount) ( amount ? ((a) + ((b) - (a)) * (amount)) : a )

// Least Common Multiple
#define Lcm(a, b) (abs(a) / Gcd(a, b) * abs(b))

// A neat little helper to convert the value X, that's between imin and imax, into a value
// that's proportionally scaled and in range of omin and omax.
#define MAP(x, imin, imax, omin, omax) ((x - imin) * (omax - omin) / (imax - imin) + omin)

/// See above, but clamps the resulting value between omin and omax
#define MAPCLAMP(x, imin, imax, omin, omax) clamp(MAP(x, imin, imax, omin, omax), omin, omax)

// Real modulus that handles decimals
#define MODULUS(x, y) ( (x) - FLOOR2(x, y))

// Returns the nth root of x.
#define ROOT(n, x) ((x) ** (1 / (n)))

#define RULE_OF_THREE(a, b, x) ((a*x)/b)

/// Gets the sign of x, returns -1 if negative, 0 if 0, 1 if positive
#define SIGN(x) ( ((x) > 0) - ((x) < 0) )

//A logarithm that converts an integer to a number scaled between 0 and 1.
//Currently, this is used for hydroponics-produce sprite transforming, but could be useful for other transform functions.
#define TRANSFORM_USING_VARIABLE(input, max) ( sin((90*(input))/(max))**2 )

// Similar to clamp but the bottom rolls around to the top and vice versa. min is inclusive, max is exclusive
#define WRAP(val, min, max) clamp(( min == max ? min : (val) - (round(((val) - (min))/((max) - (min))) * ((max) - (min))) ),min,max)

/// Increments a value and wraps it if it exceeds some value. Can be used to circularly iterate through a list through `idx = WRAP_UP(idx, length_of_list)`.
#define WRAP_UP(val, max) (((val) % (max)) + 1)

// Greatest Common Divisor - Euclid's algorithm
/proc/Gcd(a, b)
	return b ? Gcd(b, (a) % (b)) : a

/*
	This proc makes the input taper off above cap. But there's no absolute cutoff.
	Chunks of the input value above cap, are reduced more and more with each successive one and added to the output
	A higher input value always makes a higher output value. but the rate of growth slows
*/
/proc/soft_cap(input, cap = 0, groupsize = 1, groupmult = 0.9)

	//The cap is a ringfenced amount. If we're below that, just return the input
	if (input <= cap)
		return input

	var/output = 0
	var/buffer = 0
	var/power = 1//We increment this after each group, then apply it to the groupmult as a power

	//Ok its above, so the cap is a safe amount, we move that to the output
	input -= cap
	output += cap

	//Now we start moving groups from input to buffer


	while (input > 0)
		buffer = min(input, groupsize)	//We take the groupsize, or all the input has left if its less
		input -= buffer

		buffer *= groupmult**power //This reduces the group by the groupmult to the power of which index we're on.
		//This ensures that each successive group is reduced more than the previous one

		output += buffer
		power++ //Transfer to output, increment power, repeat until the input pile is all used

	return output
