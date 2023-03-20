/datum/component/mclinker
	var/obj/item/mcobject/target = null

/datum/component/mclinker/Initialize(obj/item/mcobject/_target)
	target = _target
	RegisterSignal(target, COMSIG_PARENT_QDELETING, PROC_REF(target_del))
	RegisterSignal(parent, COMSIG_ITEM_ATTACK_SELF, PROC_REF(target_del)) //Reuse this proc because why not

/datum/component/mclinker/Destroy(force, silent)
	target = null
	return ..()

/datum/component/mclinker/proc/target_del()
	SIGNAL_HANDLER
	qdel(src)
