///Calculate the angle between two points and the west|east coordinate
/proc/get_angle(atom/movable/start, atom/movable/end)//For beams.
	if(!start || !end)
		return 0
	var/dy
	var/dx
	dy=(32 * end.y + end.pixel_y) - (32 * start.y + start.pixel_y)
	dx=(32 * end.x + end.pixel_x) - (32 * start.x + start.pixel_x)
	if(!dy)
		return (dx >= 0) ? 90 : 270
	. = arctan(dx/dy)
	if(dy < 0)
		. += 180
	else if(dx < 0)
		. += 360

///for getting the angle when animating something's pixel_x and pixel_y
/proc/get_pixel_angle(y, x)
	if(!y)
		return (x >= 0) ? 90 : 270
	. = arctan(x/y)
	if(y < 0)
		. += 180
	else if(x < 0)
		. += 360

/**
 * Get a list of turfs in a line from `starting_atom` to `ending_atom`.
 *
 * Uses the ultra-fast [Bresenham Line-Drawing Algorithm](https://en.wikipedia.org/wiki/Bresenham%27s_line_algorithm).
 */
/proc/get_line(atom/starting_atom, atom/ending_atom)
	var/current_x_step = starting_atom.x//start at x and y, then add 1 or -1 to these to get every turf from starting_atom to ending_atom
	var/current_y_step = starting_atom.y
	var/starting_z = starting_atom.z

	var/list/line = list(get_turf(starting_atom))//get_turf(atom) is faster than locate(x, y, z)

	var/x_distance = ending_atom.x - current_x_step //x distance
	var/y_distance = ending_atom.y - current_y_step

	var/abs_x_distance = abs(x_distance)//Absolute value of x distance
	var/abs_y_distance = abs(y_distance)

	var/x_distance_sign = SIGN(x_distance) //Sign of x distance (+ or -)
	var/y_distance_sign = SIGN(y_distance)

	var/x = abs_x_distance >> 1 //Counters for steps taken, setting to distance/2
	var/y = abs_y_distance >> 1 //Bit-shifting makes me l33t.  It also makes get_line() unnessecarrily fast.

	if(abs_x_distance >= abs_y_distance) //x distance is greater than y
		for(var/distance_counter in 0 to (abs_x_distance - 1))//It'll take abs_x_distance steps to get there
			y += abs_y_distance

			if(y >= abs_x_distance) //Every abs_y_distance steps, step once in y direction
				y -= abs_x_distance
				current_y_step += y_distance_sign

			current_x_step += x_distance_sign //Step on in x direction
			line += locate(current_x_step, current_y_step, starting_z)//Add the turf to the list
	else
		for(var/distance_counter in 0 to (abs_y_distance - 1))
			x += abs_x_distance

			if(x >= abs_y_distance)
				x -= abs_y_distance
				current_x_step += x_distance_sign

			current_y_step += y_distance_sign
			line += locate(current_x_step, current_y_step, starting_z)
	return line

///Format a power value in W, kW, MW, or GW.
/proc/display_power(powerused)
	if(powerused < 1000) //Less than a kW
		return "[powerused] W"
	else if(powerused < 1000000) //Less than a MW
		return "[round((powerused * 0.001),0.01)] kW"
	else if(powerused < 1000000000) //Less than a GW
		return "[round((powerused * 0.000001),0.001)] MW"
	return "[round((powerused * 0.000000001),0.0001)] GW"

///Format an energy value in J, kJ, MJ, or GJ. 1W = 1J/s.
/proc/display_joules(units)
	if (units < 1000) // Less than a kJ
		return "[round(units, 0.1)] J"
	else if (units < 1000000) // Less than a MJ
		return "[round(units * 0.001, 0.01)] kJ"
	else if (units < 1000000000) // Less than a GJ
		return "[round(units * 0.000001, 0.001)] MJ"
	return "[round(units * 0.000000001, 0.0001)] GJ"

/proc/joules_to_energy(joules)
	return joules * (1 SECONDS) / SSmachines.wait

/proc/energy_to_joules(energy_units)
	return energy_units * SSmachines.wait / (1 SECONDS)

///Format an energy value measured in Power Cell units.
/proc/display_energy(units)
	// APCs process every (SSmachines.wait * 0.1) seconds, and turn 1 W of
	// excess power into watts when charging cells.
	// With the current configuration of wait=20 and CELLRATE=0.002, this
	// means that one unit is 1 kJ.
	return display_joules(energy_to_joules(units) WATTS)

///chances are 1:value. anyprob(1) will always return true
/proc/anyprob(value)
	return (rand(1,value)==value)

///counts the number of bits in Byond's 16-bit width field, in constant time and memory!
/proc/bit_count(bit_field)
	var/temp = bit_field - ((bit_field >> 1) & 46811) - ((bit_field >> 2) & 37449) //0133333 and 0111111 respectively
	temp = ((temp + (temp >> 3)) & 29127) % 63 //070707
	return temp

/// Returns the name of the mathematical tuple of same length as the number arg (rounded down).
/proc/make_tuple(number)
	var/static/list/units_prefix = list("", "un", "duo", "tre", "quattuor", "quin", "sex", "septen", "octo", "novem")
	var/static/list/tens_prefix = list("", "decem", "vigin", "trigin", "quadragin", "quinquagin", "sexagin", "septuagin", "octogin", "nongen")
	var/static/list/one_to_nine = list("monuple", "double", "triple", "quadruple", "quintuple", "sextuple", "septuple", "octuple", "nonuple")
	number = round(number)
	switch(number)
		if(0)
			return "empty tuple"
		if(1 to 9)
			return one_to_nine[number]
		if(10 to 19)
			return "[units_prefix[(number%10)+1]]decuple"
		if(20 to 99)
			return "[units_prefix[(number%10)+1]][tens_prefix[round((number % 100)/10)+1]]tuple"
		if(100)
			return "centuple"
		else //It gets too tedious to use latin prefixes from here.
			return "[number]-tuple"

/// Multiplier for converting degrees to radians
#define DEG_TO_RAD 0.0174532925


/// Multiplier for converting radians to degrees
#define RAD_TO_DEG 57.2957795


/// A random real number between low and high inclusive
#define Frand(low, high) ( rand() * ((high) - (low)) + (low) )


/// Value or the next integer in a positive direction: Ceil(-1.5) = -1 , Ceil(1.5) = 2
#define Ceil(value) ( -round(-(value)) )


/// Value or the next multiple of divisor in a positive direction. Ceilm(-1.5, 0.3) = -1.5 , Ceilm(-1.5, 0.4) = -1.2
#define Ceilm(value, divisor) ( -round(-(value) / (divisor)) * (divisor) )


/// Value or the nearest power of power in a positive direction: Ceilp(3, 2) = 4 , Ceilp(5, 3) = 9
#define Ceilp(value, power) ( (power) ** -round(-log((power), (value))) )


/// Value or the next integer in a negative direction: Floor(-1.5) = -2 , Floor(1.5) = 1
#define Floor(value) round(value)


/// Value or the next multiple of divisor in a negative direction: Floorm(-1.5, 0.3) = -1.5 , Floorm(-1.5, 0.4) = -1.6
#define Floorm(value, divisor) ( round((value) / (divisor)) * (divisor) )


/// Value or the nearest integer in either direction
#define Round(value) round((value), 1)


/// Value or the nearest multiple of divisor in either direction
#define Roundm(value, divisor) round((value), (divisor))


/// The percentage of value in max, rounded to places: 1 = nearest 0.1 , 0 = nearest 1 , -1 = nearest 10, etc
#define Percent(value, max, places) round((value) / (max) * 100, !(places) || 10 ** -(places))


/// True if value is an integer number.
#define IsInteger(value) (round(value) == (value))


//NB: Not actually truly all powers of 2 but this behavior is currently expected
/// True if value is a non-negative integer that is 0 or has a single bit set. 0, 1, 2, 4, 8 ...
#define IsPowerOfTwo(value) ( IsInteger(value) && !((value) & ((value) - 1)) )


/// True if value is an integer that is not zero and does not have the 1 bit set
#define IsEven(value) ( (value) && IsPowerOfTwo(value) )


/// True if value is an integer that has the 1 bit set.
#define IsOdd(value) ( IsInteger(value) && ((value) & 0x1) )


/// True if value is a multiple of divisor
#define IsMultiple(value, divisor) ((value) % (divisor) == 0)


/// True if value is between low and high inclusive
#define IsInRange(value, low, high) ( (value) >= (low) && (value) <= (high) )


/// The cosecant of degrees
#define Csc(degrees) (1 / sin(degrees))


/// The secant of degrees
#define Sec(degrees) (1 / cos(degrees))


/// The cotangent of degrees
#define Cot(degrees) (1 / tan(degrees))


/// The 2-argument arctangent of x and y
/proc/Atan2(x, y)
	if (!x && !y)
		return 0
	var/a = arccos(x / sqrt(x * x + y * y))
	return y >= 0 ? a : -a


/// Returns a linear interpolation from a to b according to weight. weight 0 is a, weight 1 is b, weight 0.5 is half-way between the two.
/proc/Interpolate(a, b, weight = 0.5)
	return a + (b - a) * weight


/// Returns the mean of either a list or variadic arguments: Mean(list(1, 2, 3)) = 2 , Mean(1, 2, 3) = 2
/proc/Mean(...)
	var/list/values = args
	if (islist(values[1]))
		values = values[1]
	var/sum = 0
	if (values.len)
		for (var/value in values)
			sum += value
		sum /= values.len
	return sum


/// Returns the euclidian square magnitude of a vector of either a list or variadic arguments: VecSquareMag(list(1, 2, 3)) = 14 , VecSquareMag(1, 2, 3) = 14
/proc/VecSquareMag(...)
	var/list/parts = args
	if (islist(parts[1]))
		parts = parts[1]
	var/sum = 0
	for (var/part in parts)
		sum += part * part
	return sum


/// Returns the euclidian magnitude of a vector of either a list or variadic arguments: VecMag(list(3, 4)) = 5 , VecMag(3, 4) = 5
/proc/VecMag(...)
	var/squareMag = VecSquareMag(arglist(args))
	return sqrt(squareMag)


/// Returns the angle of the matrix according to atan2 on the b, a parts
/matrix/proc/get_angle()
	return Atan2(b, a)

/// Converts kelvin to farenheit
#define FAHRENHEIT(kelvin) (kelvin * 1.8) - 459.67

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
