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
	var/datum/weakref/parentRef

/datum/hitbox/New(atom/parent)
	parentRef = parent.create_weakref()

#define DIST(l) sqrt(((l.startX+ l.endX)/2 - incoming.startX)**2 + \
                      ((l.startY+ l.endY)/2 - incoming.startY)**2)

// wx , wy and angle are pointer outputs.
/datum/hitbox/proc/getPointOfCollision(datum/line/incoming, wx, wy, angle)
	var/atom/parent = parentRef.resolve()
	if(parent == null)
		return 0
	var/list/collisions = list()

	for (var/datum/line/line in hitboxLines)


		/*---------------------------------------
		* 1.  Intersection test                *
		*--------------------------------------*/

		var/denominator = ((incoming.endY - incoming.startY) * (line.endX - line.startX) \
			             - (incoming.endX - incoming.startX) * (line.endY - line.startY))

		if (!denominator) // lines are parallel or degenerate
			message_admins("Invalid line for [src], at hitbox coords BulletLine ([line.startX] | [line.startY]) ([line.endX] | [line.endY])  HitboxLine ([incoming.startX] | [incoming.startY]) ([incoming.endX] | [incoming.endY])")
			continue		// keep checking other edges instead of immediate FALSE

		var/firstRatio  = ((incoming.endX - incoming.startX) * (line.startY - incoming.startY) \
			             - (incoming.endY - incoming.startY) * (line.startX - incoming.startX)) / denominator
		var/secondRatio = ((line.endX   - line.startX)       * (line.startY - incoming.startY) \
			             - (line.endY   - line.startY)       * (line.startX - incoming.startX)) / denominator

		if (firstRatio >= 0 && firstRatio <= 1 && secondRatio >= 0 && secondRatio <= 1)
			// --- Collision point ---
			*wx = line.startX + firstRatio * (line.endX - line.startX)
			*wy = line.startY + firstRatio * (line.endY - line.startY)
			var/lx = *wx
			var/ly = *wy

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
			var/langle = *angle
			collisions += 0
			collisions[length(collisions)] = list(lx,ly,langle,sqrt((incoming.startX - lx)**2 + (incoming.startY - ly)**2) )

	message_admins("Recorded [length(collisions)] collisions!")
	for(var/i = 1 to length(collisions)-1)
		if(collisions[i][4] > collisions[i+1][4])
			var/temp = collisions[i+1]
			collisions[i+1] = collisions[i]
			collisions[i] = temp
			if(i > 1) i--

	//  No edge intersected the incoming line
	if(length(collisions))
		*wx = collisions[1][1]
		*wy = collisions[1][2]
		*angle = collisions[1][3]
	return length(collisions) == 0


/atom
	var/datum/hitbox/atomHitbox = null

/turf/closed/wall/New()
	. = ..()
	atomHitbox = new /datum/hitbox/standardWall(src)

	for (var/datum/line/line in atomHitbox.hitboxLines)
		line.startX += (x-1) * 32;
		line.startY += (y-1) * 32;
		line.endX += (x-1) * 32;
		line.endY += (y-1) * 32;

/datum/hitbox/standardWall/New(atom/owner)
	. = ..(owner)
	hitboxLines += new /datum/line(0, 0, 0, 32)
	hitboxLines += new /datum/line(0,32, 32, 32)
	hitboxLines += new /datum/line(32,32, 32, 0)
	hitboxLines += new /datum/line(32,0, 0, 0)


