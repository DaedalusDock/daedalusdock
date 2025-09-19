// This file contains all the math + data structures used for realistic ricochets and any procs / overrides needed

#define BM_LINE(sx,sy,ex,ey) list(sx,sy,ex,ey)
#define INDICE_STARTX 1
#define INDICE_STARTY 2
#define INDICE_ENDX 3
#define INDICE_ENDY 4
#define DIR_N "1"
#define DIR_E "2"
#define DIR_S "4"
#define DIR_W "8"

/datum/hitbox
	var/list/hitboxLines = list()
	var/datum/weakref/parentRef

/datum/hitbox/New(atom/parent)
	parentRef = parent.create_weakref()

/datum/hitbox/proc/getRelevantLines(atom/parent, list/incoming)
	return hitboxLines

// wx , wy and angle are pointer outputs.
/datum/hitbox/proc/getPointOfCollision(list/incoming, wx, wy, angle)
	var/atom/parent = parentRef.resolve()
	if(parent == null)
		return 0
	var/xTranslation = (parent.x - 1) * 32
	var/yTranslation = (parent.y - 1) * 32
	var/list/collisions = list()
	for (var/list/line in getRelevantLines(parent, incoming))
		line[INDICE_STARTX] += xTranslation
		line[INDICE_ENDX] += xTranslation
		line[INDICE_STARTY] += yTranslation
		line[INDICE_ENDY] += yTranslation

		/*---------------------------------------
		* 1.  Intersection test                *
		*--------------------------------------*/

		var/denominator = ((incoming[INDICE_ENDY] - incoming[INDICE_STARTY]) * (line[INDICE_ENDX] - line[INDICE_STARTX]) \
			             - (incoming[INDICE_ENDX] - incoming[INDICE_STARTX]) * (line[INDICE_ENDY] - line[INDICE_STARTY]))

		if (!denominator) // lines are parallel or degenerate
			goto resetLine

		var/firstRatio  = ((incoming[INDICE_ENDX] - incoming[INDICE_STARTX]) * (line[INDICE_STARTY] - incoming[INDICE_STARTY]) \
			             - (incoming[INDICE_ENDY] - incoming[INDICE_STARTY]) * (line[INDICE_STARTX] - incoming[INDICE_STARTX])) / denominator
		var/secondRatio = ((line[INDICE_ENDX]   - line[INDICE_STARTX])       * (line[INDICE_STARTY] - incoming[INDICE_STARTY]) \
			             - (line[INDICE_ENDY]   - line[INDICE_STARTY])       * (line[INDICE_STARTX] - incoming[INDICE_STARTX])) / denominator

		// ensure bullet is actually in our segment.
		if (firstRatio >= 0 && firstRatio <= 1 && secondRatio >= 0 && secondRatio <= 1)
			var/lx = line[INDICE_STARTX] + firstRatio * (line[INDICE_ENDX] - line[INDICE_STARTX])
			var/ly = line[INDICE_STARTY] + firstRatio * (line[INDICE_ENDY] - line[INDICE_STARTY])
			var/deltaLineX = (incoming[INDICE_ENDX] - incoming[INDICE_STARTX])
			var/deltaLineY = (incoming[INDICE_ENDY] - incoming[INDICE_STARTY])
			var/deltaWallX = (line[INDICE_ENDX] - line[INDICE_STARTX])
			var/deltaWallY = (line[INDICE_ENDY] - line[INDICE_STARTY])
			var/dot = deltaLineX * deltaWallX + deltaLineY* deltaWallY
			var/relativeangle = -arctan(dot, deltaLineX * deltaWallY - deltaLineY * deltaWallX) * sign(dot)
			if(relativeangle > 90)
				relativeangle = 180 - relativeangle
			collisions += 0
			collisions[length(collisions)] = list(lx,ly,relativeangle,(incoming[INDICE_STARTX] - lx)**2 + (incoming[INDICE_STARTY] - ly)**2)

		resetLine:
		line[INDICE_STARTX] -= xTranslation
		line[INDICE_ENDX] -= xTranslation
		line[INDICE_STARTY] -= yTranslation
		line[INDICE_ENDY] -= yTranslation

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

/datum/hitbox/directional
	hitboxLines = list(
		DIR_N = list(
			BM_LINE(0,0,0,32),
			BM_LINE(0,32,32,32),
			BM_LINE(32,32,32,0),
			BM_LINE(32,0,0,0),
		),
		DIR_E = list(
			BM_LINE(0,0,0,32),
			BM_LINE(0,32,32,32),
			BM_LINE(32,32,32,0),
			BM_LINE(32,0,0,0),
		),
		DIR_S = list(
			BM_LINE(0,0,0,32),
			BM_LINE(0,32,32,32),
			BM_LINE(32,32,32,0),
			BM_LINE(32,0,0,0),
		),
		DIR_W = list(
			BM_LINE(0,0,0,32),
			BM_LINE(0,32,32,32),
			BM_LINE(32,32,32,0),
			BM_LINE(32,0,0,0),
		),
	)

/datum/hitbox/directiona/getRelevantLines(atom/parent, list/incoming)
	return hitboxLines["[parent.dir]"]

/atom
	var/datum/hitbox/atomHitbox = null
	// the lower clamp for bullet damage. This is reached when the bullet
	// has a lot of penetration power against this
	var/minimumBulletOverpenThreshold = 0.1
	// The threshold reached when the bullet has little penetration power
	// against this
	var/maximumBulletOverpenThreshld = 1
	var/bIntegrity = 100

/turf
	var/wallIntegrity = 100

/turf/closed/wall/New()
	. = ..()
	atomHitbox = new /datum/hitbox/standardWall(src)

/datum/hitbox/standardWall
	hitboxLines = list(
		BM_LINE(0,0,0,32),
		BM_LINE(0,32,32,32),
		BM_LINE(32,32,32,0),
		BM_LINE(32,0,0,0),
	)
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
#define BULLET_INTEGRITYLOSS_FRAGMENT 50 * BULLET_INTEGRITYLOSSMULT
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
	var/speedLossPerTile = 0.1
	var/bulletTipType = BULLET_SHARP
	var/bulletArmorType = PUNCTURE
	var/canRicochet = TRUE
	var/canFragment = TRUE

// returns a exponential multiplier for calculations. ONLY FOR WALLS
/obj/projectile/proc/getRelativeArmorRatingMultiplier(turf/closed/wall/target, datum/armor/targetArmor, datum/armor/bulletArmor)
	if(targetArmor == null || bulletArmor == null || bulletArmorType == "")
		return 0
	var/ratingDiff = (bulletArmor.vars[bulletArmorType] * bIntegrity / initial(bIntegrity)) * initial(speed) / speed - targetArmor.vars[bulletArmorType] * target.bIntegrity / initial(target.bIntegrity)
//message_admins("relative armor returning [ratingDiff / bulletArmor.vars[damage_type]]")
	return (ratingDiff+0.001) / bulletArmor.vars[bulletArmorType]

/obj/projectile/proc/fragmentTowards(atom/lastHit,fragmentCount, fragmentAngle, maxDeviation, fullLoopPossible)
	for(var/i = 0 to fragmentCount)
		var/obj/projectile/projectile = new /obj/projectile/bullet(get_turf(lastHit))
		projectile.bIntegrity = bIntegrity
		projectile.speed = speed
		projectile.firer = src
		projectile.fired_from = lastHit
		projectile.impacted = list(lastHit)
		projectile.preparePixelProjectile(get_turf_in_angle(fragmentAngle, lastHit, 2), src)
		projectile.adjustSpeed(-BULLET_FRAGMENT_SPEEDMALUS)
		projectile.adjustIntegrity(-BULLET_INTEGRITYLOSS_FRAGMENT	)
		projectile.damage = damage * 0.2
		projectile.damage_type = damage_type
		projectile.fire(fragmentAngle + rand(0, maxDeviation) * sign(rand(-1,1)) + (fullLoopPossible ? rand(-1,1) > 0 : 0) * 180)

/obj/projectile/proc/adjustIntegrity(value)
	bIntegrity = max(bIntegrity + value, 0)
	if(bIntegrity == 0)
		qdel(src)

/obj/projectile/proc/adjustSpeed(value)
	speed = max(speed - value, 0.1)
	if(speed > BULLET_THRESHOLD_TOOSLOW)
		qdel(src)


// You can balance these by going to their wikipedia page and checking how much kinetic energy they have for the bullet(for how much the should pen)

// enough to go through 3-4 walls.
TYPEINFO_DEF(/obj/projectile/bullet/bmg50)
	default_armor = list(BLUNT = 0, PUNCTURE = 350, SLASH = 0, LASER = 0, ENERGY = 0 , BOMB = 0, BIO = 0, FIRE = 0, ACID = 0)

/obj/projectile/bullet/bmg50
	name = ".50 BMG"
	damage = 60
	armor_penetration = 50

// very small bullet, unlikely to pen anything
TYPEINFO_DEF(/obj/projectile/bullet/lr22)
	default_armor = list(BLUNT = 0, PUNCTURE = 15, SLASH = 0, LASER = 0, ENERGY = 0 , BOMB = 0, BIO = 0, FIRE = 0, ACID = 0)

/obj/projectile/bullet/bmg50
	name = ".50 BMG"
	damage = 20
