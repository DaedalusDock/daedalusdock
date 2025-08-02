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

// wx , wy and angle are pointer outputs.
/datum/hitbox/proc/getPointOfCollision(datum/line/incoming, wx, wy, angle)
	var/atom/parent = parentRef.resolve()
	if(parent == null)
		return 0
	var/xTranslation = (parent.x - 1) * 32
	var/yTranslation = (parent.y - 1) * 32
	var/list/collisions = list()

	for (var/datum/line/line in hitboxLines)
		line.startX += xTranslation
		line.endX += xTranslation
		line.startY += yTranslation
		line.endY += yTranslation

		/*---------------------------------------
		* 1.  Intersection test                *
		*--------------------------------------*/

		var/denominator = ((incoming.endY - incoming.startY) * (line.endX - line.startX) \
			             - (incoming.endX - incoming.startX) * (line.endY - line.startY))

		if (!denominator) // lines are parallel or degenerate
			goto resetLine

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
			collisions += 0
			collisions[length(collisions)] = list(lx,ly,relativeangle,(incoming.startX - lx)**2 + (incoming.startY - ly)**2)

		resetLine:
		line.startX -= xTranslation
		line.endX -= xTranslation
		line.startY -= yTranslation
		line.endY -= yTranslation

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

/turf
	var/wallIntegrity = 100

/turf/closed/wall/New()
	. = ..()
	atomHitbox = new /datum/hitbox/standardWall(src)

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

/// BulletTipType defines
// Rifle grade sharp
#define BULLET_SHARP 1>>0
// Riot control
#define BULLET_ROUNDED 1>>1
// Very sharp. Tank Ammunition grade
#define BULLET_ULTRASHARP 1>>2
// Fragmented bullet tip, unpredictable performance.
#define BULLET_FRAGMENTED 1>>3
// A flat bullet head
#define BULLET_FLAT 1>>4

GLOBAL_LIST_INIT(bulletStandardRicochetAngles, list(
	"[BULLET_SHARP]" = 18,
	"[BULLET_ROUNDED]" = 35,
	"[BULLET_ULTRASHARP]" = 9,
	"[BULLET_FRAGMENTED]" = 20,
	"[BULLET_FLAT]" = 10 // much more likely to fragment instead.
))
// This is taken from the bullet Speed var. The differenc su sed to apply maluses/modifications to ricochet angle
#define BULLET_SPEED_BASELINE 1
// Minimum bullet speed , anything above this gets deleted
#define BULLET_SPEED_MINIMUM 0.3
// A increase/decrease in ricochet/fragment angles wheter the bullet is going slower/faster than the baseline. This is applied for every 0.1 unit of speed
GLOBAL_LIST_INIT(bulletSpeedAngleMalus, list(
	"[BULLET_SHARP]" = 2,
	"[BULLET_ROUNDED]" = 1,
	"[BULLET_ULTRASHARP]" = 3,
	"[BULLET_FRAGMENTED]" = 5,
	"[BULLET_FLAT]" = 5
))

// left-value is minimum , right angle is maximum
GLOBAL_LIST_INIT(bulletStandardFragmentAngles, list(
	"[BULLET_SHARP]" = list(60, 90),
	"[BULLET_ROUNDED]" = list(50, 90),
	"[BULLET_ULTRASHARP]" = list(80, 90),
	// no fragmentation of the fragmentation pls
	"[BULLET_FRAGMENTED]" = list(180, 180),
	"[BULLET_FLAT]" = list(50, 90)
))
// increases or decreases how much bullet integrity is lost
#define BULLET_INTEGRITYLOSSMULT 1
#define BULLET_INTEGRITYLOSS_RICOCHET 20 * BULLET_INTEGRITYLOSSMULT
#define BULLET_INTEGRITYLOSS_FRAMGNET 50 * BULLET_INTEGRITYLOSSMULT
/// Bullet Malus defines for fragmenting or expanding


#define BULLET_FRAGMENT_MAXANGLEVARIATION  10
#define BULLET_FRAGMENT_SPEEDMALUS 0.1
#define BULLET_FRAGMENT_SPAWNCOUNT 8

#define BULLET_EXPAND_SPEEDMALUS 0.05

#define BULLET_SPEED_BOOSTED -0.1
#define BLLET_SPEED_FAST -0.3
#define BULLET_SPEED_INSANE -0.5
#define BULLET_SPEED_SLOWED 0.1
#define BULLET_SPEED_SNAIL 0.4

// threshold at which bullet is too SLOW and should be deleted
#define BULLET_THRESHOLD_TOOSLOW 2

/obj/item/gun
	var/speedValueMod = BULLET_SPEED_INSANE

TYPEINFO_DEF(/obj/projectile)
	default_armor = list(BLUNT = 0, PUNCTURE = 50, SLASH = 0, LASER = 0, ENERGY = 0 , BOMB = 0, BIO = 0, FIRE = 0, ACID = 0)


/obj/projectile
	var/integrity = 100
	var/speedLossPerTile = 0.1
	var/bulletTipType = BULLET_SHARP

// returns a exponential multiplier for calculations.
/obj/projectile/proc/getRelativeArmorRatingMultiplier(obj/projectile/target, datum/armor/targetArmor, datum/armor/bulletArmor)
	if(targetArmor == null || bulletArmor == null || damage_type == "")
		return 0
	var/ratingDiff = bulletArmor.vars[damage_type] * wallIntegrity / initial(wallIntegrity) - targetArmor.vars[damage_type] * target.integrity / initial(target.integrity)
	//message_admins("relative armor returning [ratingDiff / bulletArmor.vars[damage_type]]")
	return (ratingDiff+0.001) / bulletArmor.vars[damage_type]

/obj/projectile/proc/fragmentTowards(turf/wall,fragmentCount, fragmentAngle, maxDeviation, fullLoopPossible)
	for(var/i = 0 to fragmentCount)
		var/obj/projectile/projectile = new /obj/projectile/bullet(get_turf(wall))
		projectile.firer = src
		projectile.fired_from = wall
		projectile.impacted = list(wall)
		projectile.preparePixelProjectile(get_turf_in_angle(fragmentAngle, wall, 2), src)
		projectile.adjustSpeed(-speed * 0.3)
		projectile.adjustIntegrity(-integrity * 0.2)
		projectile.damage = damage * 0.2
		projectile.damage_type = damage_type
		projectile.fire(fragmentAngle + rand(0, maxDeviation) * sign(rand(-1,1)) + (fullLoopPossible ? rand(-1,1) > 0 : 0) * 180)

/obj/projectile/proc/adjustIntegrity(value)
	integrity = max(integrity + value, 0)
	if(integrity == 0)
		qdel(src)

/obj/projectile/proc/adjustSpeed(value)
	speed = max(speed - value, 0.1)
	if(speed > BULLET_THRESHOLD_TOOSLOW)
		qdel(src)
