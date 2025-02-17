/// Clamps a value between 0 and 1
#define CLAMP01(x) (clamp(x, 0, 1))

/// Like round()), but always rounds up.
#define CEILING2(x, y) ( -round(-(x) / (y)) * (y) )

// Like round()), but always rounds down.
#define FLOOR2(x, y) ( round((x) / (y)) * (y) )

/// Exists purely to avoid the footgun of round(x)) being floor(x)
#define ROUND(x, y) (round(x, y))

/// If you have found this in the code, congratulations! Be horrified.
/// This is in places where single-argument round(x)) was used.
/// If you know if it should be round(x, 1) or floor(x), please substitute the correct proc!
#define QUESTIONABLE_FLOOR(x) (floor(x))
