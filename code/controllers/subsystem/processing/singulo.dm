/// Very rare subsystem, provides any active singularities with the timings and seclusion they need to succeed
PROCESSING_SUBSYSTEM_DEF(singuloprocess)
	name = "Singularity"
	wait = 0.5
	priority = FIRE_PRIORITY_DEFAULT
	flags = SS_HIBERNATE
	stat_tag = "SIN"
