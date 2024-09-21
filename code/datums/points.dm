/// Completely generic resource handler
/datum/point_holder
	VAR_PRIVATE/points

/datum/point_holder/proc/has_points(atleast)
	if(points >= atleast)
		return points

/datum/point_holder/proc/add_points(num)
	points += num
	return TRUE

/datum/point_holder/proc/remove_points(num, check_enough)
	if(check_enough && (points < num))
		return FALSE

	points = max(0, points - num)
	return TRUE
