//Returns the world time in english
/proc/worldtime2text()
	return gameTimestamp("hh:mm:ss", world.time)

/proc/time_stamp(format = "hh:mm:ss", show_ds)
	var/time_string = time2text(world.timeofday, format)
	return show_ds ? "[time_string]:[world.timeofday % 10]" : time_string

/proc/gameTimestamp(format = "hh:mm:ss", wtime=null)
	if(!wtime)
		wtime = world.time
	return time2text(wtime - GLOB.timezoneOffset, format)

/// Generate a game-world time value in deciseconds.
/proc/station_time(reference_time = world.time)
	return (((reference_time - SSticker.round_start_time) + SSticker.gametime_offset) % (24 HOURS))

/proc/stationtime2text(format = "hh:mm:ss", reference_time = world.time)
	return time2text(station_time(reference_time), format, 0)

/proc/stationdate2text()
	var/static/next_station_date_change = 1 DAY
	var/static/station_date = ""
	var/update_time = FALSE
	if(STATION_TIME_TICKS > next_station_date_change)
		next_station_date_change += 1 DAY
		update_time = TRUE
	if(!station_date || update_time)
		var/extra_days = round(STATION_TIME_TICKS / (1 DAY)) DAYS
		var/timeofday = world.timeofday + extra_days
		station_date = time2text(timeofday, "DD-MM") + "-" + num2text(CURRENT_STATION_YEAR)
	return station_date

/// Returns the round duration in real time.
/proc/round_timeofday()
	return REALTIMEOFDAY - SSticker.round_start_timeofday

//returns timestamp in a sql and a not-quite-compliant ISO 8601 friendly format
/proc/SQLtime(timevar)
	return time2text(timevar || world.timeofday, "YYYY-MM-DD hh:mm:ss")


GLOBAL_VAR_INIT(midnight_rollovers, 0)
GLOBAL_VAR_INIT(rollovercheck_last_timeofday, 0)
/proc/update_midnight_rollover()
	if (world.timeofday < GLOB.rollovercheck_last_timeofday) //TIME IS GOING BACKWARDS!
		GLOB.midnight_rollovers++
	GLOB.rollovercheck_last_timeofday = world.timeofday
	return GLOB.midnight_rollovers


///Returns a string day as an integer in ISO format 1 (Monday) - 7 (Sunday)
/proc/weekday_to_iso(ddd)
	switch (ddd)
		if (MONDAY)
			return 1
		if (TUESDAY)
			return 2
		if (WEDNESDAY)
			return 3
		if (THURSDAY)
			return 4
		if (FRIDAY)
			return 5
		if (SATURDAY)
			return 6
		if (SUNDAY)
			return 7

///Returns the first day of the given year and month in number format, from 1 (monday) - 7 (sunday).
/proc/first_day_of_month(year, month)
	// https://en.wikipedia.org/wiki/Zeller%27s_congruence
	var/m = month < 3 ? month + 12 : month // month (march = 3, april = 4...february = 14)
	var/K = year % 100 // year of century
	var/J = round(year / 100) // zero-based century
	// day 0-6 saturday to sunday:
	var/h = (1 + round(13 * (m + 1) / 5) + K + round(K / 4) + round(J / 4) - 2 * J) % 7
	//convert to ISO 1-7 monday first format
	return ((h + 5) % 7) + 1


//Takes a value of time in deciseconds.
//Returns a text value of that number in hours, minutes, or seconds.
/proc/DisplayTimeText(time_value, round_seconds_to = 0.1)
	var/second = FLOOR(time_value * 0.1, round_seconds_to)
	if(!second)
		return "right now"
	if(second < 60)
		return "[second] second[(second != 1)? "s":""]"
	var/minute = FLOOR(second / 60, 1)
	second = FLOOR(MODULUS(second, 60), round_seconds_to)
	var/secondT
	if(second)
		secondT = " and [second] second[(second != 1)? "s":""]"
	if(minute < 60)
		return "[minute] minute[(minute != 1)? "s":""][secondT]"
	var/hour = FLOOR(minute / 60, 1)
	minute = MODULUS(minute, 60)
	var/minuteT
	if(minute)
		minuteT = " and [minute] minute[(minute != 1)? "s":""]"
	if(hour < 24)
		return "[hour] hour[(hour != 1)? "s":""][minuteT][secondT]"
	var/day = FLOOR(hour / 24, 1)
	hour = MODULUS(hour, 24)
	var/hourT
	if(hour)
		hourT = " and [hour] hour[(hour != 1)? "s":""]"
	return "[day] day[(day != 1)? "s":""][hourT][minuteT][secondT]"


/proc/daysSince(realtimev)
	return round((world.realtime - realtimev) / (24 HOURS))

/**
 * Converts a time expressed in deciseconds (like world.time) to the 12-hour time format.
 * the format arg is the format passed down to time2text() (e.g. "hh:mm" is hours and minutes but not seconds).
 */
/proc/time_to_twelve_hour(time, format = "hh:mm:ss")
	if(time > 1 DAY)
		time = time % (24 HOURS)
	var/am_pm = "AM"
	if(time > 12 HOURS)
		am_pm = "PM"
		if(time > 13 HOURS)
			time -= 12 HOURS // e.g. 4:16 PM but not 00:42 PM
	else if (time < 1 HOURS)
		time += 12 HOURS // e.g. 12.23 AM
	return "[time2text(time, format, 0)] [am_pm]"
