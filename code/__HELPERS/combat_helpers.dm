/// Returns an angle between 0 and 180, where 0 is the attacker is directly infront of the defender, 180 for directly behind.
/proc/get_relative_attack_angle(mob/living/carbon/human/defender, atom/movable/hitby)
	/// Null is the value that will consider angles to match the defender's dir
	var/attack_angle = null

	var/turf/defender_turf = get_turf(defender)
	var/turf/attack_turf = get_turf(hitby)
	var/attack_dir = get_dir(defender_turf, attack_turf)

	if(isprojectile(hitby))
		var/obj/projectile/P = hitby
		if(P.starting != defender_turf)
			attack_angle = REVERSE_ANGLE(P.Angle)

	else if(isitem(hitby))
		if(ismob(hitby.loc))
			attack_angle = dir2angle(get_dir(defender, get_turf(hitby.loc)))
		else
			attack_angle = dir2angle(attack_dir)

	else
		attack_angle = dir2angle(attack_dir)

	if(attack_angle == null)
		return 0

	var/facing_angle = dir2angle(defender.dir) || 0
	var/delta = abs(attack_angle - facing_angle)
	if(delta > 180)
		delta = 360 - delta

	return delta
