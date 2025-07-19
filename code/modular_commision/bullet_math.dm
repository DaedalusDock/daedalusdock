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

/proc/arctan2(y, x)
	if (x == 0)
		if (y > 0)
			return 90
		else if (y < 0)
			return -90
		else
			return 0 // undefined, but return 0 for safety
	var/angle = arctan(y / x)
	if (x < 0)
		angle += (y >= 0) ? 180 : -180
	return angle

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
			var/lx = line.startX + firstRatio * (line.endX - line.startX)
			var/ly = line.startY + firstRatio * (line.endY - line.startY)
			var/deltaLineX = (incoming.endX - incoming.startX)
			var/deltaLineY = (incoming.endY - incoming.startY)
			var/deltaWallX = (line.endX - line.startX)
			var/deltaWallY = (line.endY - line.startY)
			var/dot = deltaLineX * deltaWallX + deltaLineY* deltaWallY
			var/relativeangle = -arctan(dot, deltaLineX * deltaWallY - deltaLineY * deltaWallX) * sign(dot)
			if(relativeangle > 90)
				relativeangle = 180 - relativeangle
			/*
			if(relativeangle > 90)
				relativeangle = 180 - relativeangle
			else if(relativeangle < 90)
				relativeangle = relativeangle - 180
				*/
			collisions += 0
			collisions[length(collisions)] = list(lx,ly,relativeangle,(incoming.startX - lx)**2 + (incoming.startY - ly)**2)

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
		message_admins("Got relative angle of [collisions[1][3]]")
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

// stores a angle in simple 0 - 360 for maths
// always counter clockwise!!
/datum/worldAngle
	var/angle = 0

/datum/worldAngle/proc/reduce()
	angle = angle % 360

/datum/worldAngle/proc/fromAny(originalAngle)
	var/tempAngle = originalAngle%360
	if(originalAngle < 0)
		angle = -originalAngle
	else
		angle = (360 - originalAngle)
