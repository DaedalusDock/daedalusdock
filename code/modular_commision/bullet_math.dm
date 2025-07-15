// This file contains all the math + data structures used for realistic ricochets and any procs / overrides needed

/datum/line
	var/startX
	var/startY
	var/endX
	var/endY

/datum/line/New(sX,sY,eX,eY)
	. = ..()
	startX = sX
	startY = sY
	endX = eX
	endY = eY


/datum/hitbox
	var/list/datum/line/hitboxLines = list()

/datum/hitbox/getPointOfCollision(datum/line/incoming, *wx, *wy, *angle)
	//  Iterate over every edge of this hit‑box
	for (var/line in hitboxLines)

		/*---------------------------------------
		* 1.  Intersection test                *
		*--------------------------------------*/

		var/denominator = ((incoming.endY - incoming.startY) * (line.endX - line.startX) \
			             - (incoming.endX - incoming.startX) * (line.endY - line.startY))

		if (!denominator) // lines are parallel or degenerate
			message_admins("Invalid line for [src], at hitbox coords "
			                "BulletLine ([line.startX] | [line.startY]) ([line.endX] | [line.endY])  "
			                "HitboxLine ([incoming.startX] | [incoming.startY]) ([incoming.endX] | [incoming.endY])")
			continue		// keep checking other edges instead of immediate FALSE

		var/firstRatio  = ((incoming.endX - incoming.startX) * (line.startY - incoming.startY) \
			             - (incoming.endY - incoming.startY) * (line.startX - incoming.startX)) / denominator
		var/secondRatio = ((line.endX   - line.startX)       * (line.startY - incoming.startY) \
			             - (line.endY   - line.startY)       * (line.startX - incoming.startX)) / denominator

		if (firstRatio >= 0 && firstRatio <= 1 && secondRatio >= 0 && secondRatio <= 1)
			// --- Collision point ---
			*wx = line.startX + firstRatio * (line.endX - line.startX)
			*wy = line.startY + firstRatio * (line.endY - line.startY)

			/*---------------------------------------
			* 2.  Acute angle between segments      *
			*--------------------------------------*/

			// Direction vectors (B - A)
			var/ux = incoming.endX - incoming.startX
			var/uy = incoming.endY - incoming.startY

			var/vx = line.endX     - line.startX
			var/vy = line.endY     - line.startY

			// Dot‑product & magnitudes
			var/dot   = ux * vx + uy * vy
			var/len_u = sqrt(ux * ux + uy * uy)
			var/len_v = sqrt(vx * vx + vy * vy)

			if(len_u && len_v)
				var/cosTheta = dot / (len_u * len_v)

				// Numerical‑safety clamp
				if (cosTheta >  1) cosTheta =  1
				if (cosTheta < -1) cosTheta = -1

				var/theta = arccos(cosTheta)	// BYOND trig fns use *degrees*
				if (theta > 90)					// convert to acute angle
					theta = 180 - theta

				*angle = theta
			else
				*angle = 0	// one of the segments has zero length; pick a default

			return TRUE

	//  No edge intersected the incoming line
	return FALSE


/atom
	var/datum/hitbox/atomHitbox = null

/turf/closed/wall
	atomHitbox = new /datum/hitbox/standardWall()

/datum/hitbox/standardWall/New()
	hitboxLines += new /datum/line(-16,-16, -16, 16)
	hitboxLines += new /datum/line(-16,16, 16, 16)
	hitboxLines += new /datum/line(16,16, 16, -16)
	hitboxLines += new /datum/line(16,-16, -16, -16)


