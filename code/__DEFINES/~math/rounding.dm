/// Clamps a value between 0 and 1
#define CLAMP01(x) (clamp(x, 0, 1))

/// Like round(), but always rounds up.
#define CEILING2(x, y) ( -round(-(x) / (y)) * (y) )

// Like round(), but always rounds down.
#define FLOOR2(x, y) ( round((x) / (y)) * (y) )
