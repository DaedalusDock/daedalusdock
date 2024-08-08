/obj/item/organ/cyberimp/fluff
	cosmetic_only = TRUE
	icon_state = "chest_implant"
	relative_size = 0 //to prevent fluff organs from affecting combat at all

/obj/item/organ/cyberimp/fluff/circadian_conditioner
	name = "circadian conditioner"
	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_FLUFF_HEAD
	icon_state = "brain_implant"
	desc = "A small brain implant that carefully regulates the output of certain hormones to assist in controlling the sleep-wake cycle of its owner. May be an effective counter to insomnia, jet lag, and late-night work shifts."


/obj/item/organ/cyberimp/fluff/genetic_backup
	name = "genetic backup"
	zone = BODY_ZONE_CHEST
	slot = ORGAN_SLOT_FLUFF_CHEST
	icon_state = "brain_implant"
	desc = "This implant is a compact and resilient solid-state drive. It does nothing on its own, but contains the complete DNA sequence of its owner - whether it be to aid in medical treatment, serve for research purposes, or even be used as a template for vat-grown humans in the future."


/obj/item/organ/cyberimp/fluff/emergency_battery
	name = "emergency battery"
	zone = BODY_ZONE_CHEST
	slot = ORGAN_SLOT_FLUFF_CHEST
	icon_state = "cell"
	desc = "A small emergency power supply. It provides no protection from power loss on its own, but might help keep your brain ticking through an otherwise critical failure."

/obj/item/organ/cyberimp/fluff/skeletal_bracing
	name = "skeletal bracing"
	zone = BODY_ZONE_CHEST
	slot = ORGAN_SLOT_FLUFF_CHEST
	icon_state = "implant-reinforcers"
	desc = "Mechanical hinges and springs made from titanium or some other bio-compatible metal reinforce your joints, generally making strenuous activity less painful for you and allowing you to carry weight that would normally be unbearable. It provides no increase on strength on its own, unless you have weak bones to begin with."


/obj/item/organ/cyberimp/fluff/ultraviolet_shielding
	name = "ultraviolet shielding"
	zone = BODY_ZONE_CHEST
	slot = ORGAN_SLOT_FLUFF_CHEST
	icon_state = "implant-reinforcers2"
	desc = "Some parts of your epidermis have been replaced with a bio-engineered substitute that's resistant to harmful solar radiation - a common factor in the lives of spacers or inhabitants of planets with a weak magnetosphere."

/obj/item/organ/cyberimp/fluff/recycler_suite
	name = "recycler suite"
	zone = BODY_ZONE_PRECISE_GROIN
	slot = ORGAN_SLOT_FLUFF_GROIN
	food_reagents = list(/datum/reagent/consumable/nutraslop = 5, /datum/reagent/iron = 3) //do you really want to eat this?
	icon_state = "random_fly_5"
	desc = "In extreme environments where natural resources are limited or even nonexistent, it may be prudent to recycle nutrients and fluids the body would usually discard. This system reclaims any usable material in the digestive tract that would otherwise be lost to waste."
	organ_flags = ORGAN_EDIBLE | ORGAN_SYNTHETIC
