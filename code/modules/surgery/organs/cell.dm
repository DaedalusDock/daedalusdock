/obj/item/organ/cell
	name = "microcell"
	desc = "A small, powerful cell for use in fully prosthetic bodies."
	icon_state = "cell"

	organ_flags = ORGAN_SYNTHETIC | ORGAN_VITAL
	zone = BODY_ZONE_CHEST
	slot = ORGAN_SLOT_CELL

	/// Is the cell housing open?
	var/open
	/// The internal cell that actually holds power.
	var/obj/item/stock_parts/cell/high/cell = /obj/item/stock_parts/cell/high
	//at 2.6 completely depleted after 60ish minutes of constant walking or 130 minutes of standing still
	var/servo_cost = 2.6

/obj/item/organ/cell/Initialize(mapload, mob_sprite)
	. = ..()
	cell = new cell(src)

/obj/item/organ/cell/proc/percent()
	if(!cell)
		return 0
	return get_charge()/cell.maxcharge * 100

/obj/item/organ/cell/proc/get_charge()
	if(!cell)
		return 0
	if(organ_flags & ORGAN_DEAD)
		return 0
	return round(cell.charge*(1 - damage/maxHealth))

/obj/item/organ/cell/use(amount)
	if(organ_flags & ORGAN_DEAD)
		return FALSE
	return cell && cell.use(amount)

/obj/item/organ/cell/proc/get_power_drain()
	var/damage_factor = 1 + 10 * damage/maxHealth
	return servo_cost * damage_factor
