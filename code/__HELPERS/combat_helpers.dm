/// Returns an angle between 0 and 180, where 0 is the attacker is directly infront of the defender, 180 for directly behind.
/proc/get_relative_attack_angle(mob/living/carbon/human/defender, atom/movable/hitby)
	var/attack_dir = defender.dir // Default to the defender's dir so that the attack angle is 0 by default
	var/turf/defender_turf = get_turf(defender)

	if(isprojectile(hitby))
		var/obj/projectile/P = hitby
		if(P.starting != defender_turf)
			attack_dir = REVERSE_DIR(angle2dir(P.Angle))

	else if(isitem(hitby))
		if(ismob(hitby.loc))
			attack_dir = get_dir(defender, hitby.loc)
		else
			attack_dir = get_dir(defender, hitby)

	else
		attack_dir = get_dir(defender, hitby)

	var/attack_angle = dir2angle(attack_dir) || 0 // If attack_dir == 0, dir2angle returns null
	var/facing_angle = dir2angle(defender.dir) || 0
	var/delta = abs(attack_angle - facing_angle)
	if(delta > 180)
		delta = 360 - delta

	return delta
