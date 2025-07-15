// This file contains all the math + data structures used for realistic ricochets and any procs / overrides needed

/datum/shape

/datum/shape/proc/collidesWithLine(startX,startY,endX,endY)
	return FALSE

/datum/shape/proc/collisionAngleLine(startX,startY,endX,endY)
	return 0

/datum/shape/box
	var/topX // top-right
	var/topY
	var/bottomX // bottom - left
	var/bottomY

/datum/shape/box/collidesWithLine(startX,startY,endX,endY)




/datum/hitbox
	var/list/
/atom
	var
