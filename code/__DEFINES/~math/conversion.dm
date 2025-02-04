/// Converts kelvin to farenheit
#define FAHRENHEIT(kelvin) (kelvin * 1.8) - 459.67

/// Converts a 0-100 value to a percentage.
#define PERCENT(val) (round((val)*100, 0.1))

/// Converts radians to degrees
#define TODEGREES(radians) ((radians) * 57.2957795)
/// Converts degrees to radians
#define TORADIANS(degrees) ((degrees) * 0.0174532925)

/// Gets shift x that would be required the bitflag (1<<x)
#define TOBITSHIFT(bit) (round(log(2, bit), 1))

