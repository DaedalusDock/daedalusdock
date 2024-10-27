/// Completely generic resource handler
/datum/point_holder
	VAR_PRIVATE/max_points = INFINITY
	VAR_PRIVATE/points = 0

/datum/point_holder/proc/has_points(atleast)
	if(points >= atleast)
		return points

/datum/point_holder/proc/adjust_points(num, check_enough)
	if(num > 0)
		return add_points(num)

	else if(num < 0)
		return remove_points(num, check_enough)

	return TRUE

/datum/point_holder/proc/add_points(num)
	if(points == max_points)
		return FALSE

	points = min(max_points, points + num)
	return TRUE

/datum/point_holder/proc/remove_points(num, check_enough)
	if(check_enough && (points < num))
		return FALSE

	if(points == 0)
		return FALSE

	points = max(0, points - num)
	return TRUE

/datum/point_holder/proc/set_max_points(new_max)
	max_points = new_max
	points = min(max_points, points)
