/datum/universal_state
	var/name = "Normal"
	var/desc = "All clear here!"

	var/list/affecting_ztraits = list()
	var/list/affecting_zlevels = list()

/datum/universal_state/New(list/ztraits, list/zlevels)
	affecting_ztraits = ztraits
	affecting_zlevels = SSmapping.levels_by_any_trait(ztraits)

///Apply changes when entering this state
/datum/universal_state/proc/OnEnter()
	set waitfor = FALSE

///Apply changes when exitting this state
/datum/universal_state/proc/OnExit()
	set waitfor = FALSE
