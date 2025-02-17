/// Evalutes TRUE if given a non-INFINITY number.
#define IS_FINITE(a) (isnum(a) && !isinf(a))
/// Evaluates TRUE if given a value that is NaN or INF
#define IS_INF_OR_NAN(a) (isnan(a) || isinf(a))

/// Checks if A and B are within Deviation of eachother.
#define ISABOUTEQUAL(a, b, deviation) (deviation ? abs((a) - (b)) <= deviation : abs((a) - (b)) <= 0.1)

/// Evaluates TRUE if the input is an even number.
#define ISEVEN(x) (x % 2 == 0)
/// Evaluates FALSE if the input is an even number.
#define ISODD(x) (x % 2 != 0)

// Evaluates true if val is from min to max, inclusive.
#define ISINRANGE(val, min, max) (min <= val && val <= max)
// Same as above, exclusive.
#define ISINRANGE_EX(val, min, max) (min < val && val < max)

/// Evaluates TRUE if the input is an integer
#define ISINTEGER(x) (floor(x) == x)

/// Evaluates TRUE if X is a multiple of Y
#define ISMULTIPLE(x, y) ((x) %% (y) == 0)
