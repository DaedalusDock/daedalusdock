// heat2color functions. Adapted from: http://www.tannerhelland.com/4435/convert-temperature-rgb-algorithm-code/
/proc/heat2color(temp)
	return rgb(heat2color_r(temp), heat2color_g(temp), heat2color_b(temp))

/proc/heat2color_r(temp)
	temp /= 100
	if(temp <= 66)
		. = 255
	else
		. = max(0, min(255, 329.698727446 * (temp - 60) ** -0.1332047592))

/proc/heat2color_g(temp)
	temp /= 100
	if(temp <= 66)
		. = max(0, min(255, 99.4708025861 * log(temp) - 161.1195681661))
	else
		. = max(0, min(255, 288.1221695283 * ((temp - 60) ** -0.0755148492)))

/proc/heat2color_b(temp)
	temp /= 100
	if(temp >= 66)
		. = 255
	else
		if(temp <= 16)
			. = 0
		else
			. = max(0, min(255, 138.5177312231 * log(temp - 10) - 305.0447927307))

//Divide your temp by 100 before passing to this macro!
#define HEAT2COLOR(temp) \
	rgb( \
		(temp) <= 66 ? 255 : clamp(329.698727446 * (temp - 60) ** -0.1332047592, 0, 255), \
		(temp) <= 66 ? clamp(99.4708025861 * log(temp) - 161.1195681661, 0, 255) : clamp(288.1221695283 * ((temp - 60) ** -0.0755148492), 0, 255), \
		(temp) >= 66 ? 255 : (temp <= 16 ? 0 : clamp(138.5177312231 * log(temp - 10) - 305.0447927307, 0, 255)) \
	)\

#define FIRECOLOR(temp) (HEAT2COLOR(max(4000*sqrt(firelevel/zas_settings.fire_firelevel_multiplier), temp) / 100))
