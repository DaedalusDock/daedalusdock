/// The subsystem used to tick [/datum/component/acid] instances.
PROCESSING_SUBSYSTEM_DEF(acid)
	name = "Acid"
	priority = FIRE_PRIORITY_ACID
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME
