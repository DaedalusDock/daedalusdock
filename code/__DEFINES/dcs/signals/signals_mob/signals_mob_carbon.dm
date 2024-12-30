///Called from /mob/living/carbon/help_shake_act, before any hugs have ocurred. (mob/living/helper)
#define COMSIG_CARBON_PRE_HELP_ACT "carbon_pre_help"
	/// Stops the rest of help act (hugging, etc) from occuring
	#define COMPONENT_BLOCK_HELP_ACT (1<<0)

///Called from /mob/living/carbon/help_shake_act on the person being helped, after any hugs have ocurred. (mob/living/helper)
#define COMSIG_CARBON_HELP_ACT "carbon_help"
///Called from /mob/living/carbon/help_shake_act on the helper, after any hugs have ocurred. (mob/living/helped)
#define COMSIG_CARBON_HELPED "carbon_helped_someone"

///When a carbon mob is disarmed, this is sent to the turf we're trying to shove onto (mob/living/carbon/shover, mob/living/carbon/target, shove_blocked)
#define COMSIG_CARBON_DISARM_COLLIDE "carbon_disarm_collision"
	#define COMSIG_CARBON_SHOVE_HANDLED (1<<0)

///When a carbon slips. Called on /turf/open/handle_slip()
#define COMSIG_ON_CARBON_SLIP "carbon_slip"
///When a carbon gets a vending machine tilted on them
#define COMSIG_ON_VENDOR_CRUSH "carbon_vendor_crush"
// /mob/living/carbon physiology signals
#define COMSIG_CARBON_BREAK_BONE "carbon_break_bone"
#define COMSIG_CARBON_HEAL_BONE "carbon_heal_bone"
///from base of /obj/item/bodypart/proc/attach_limb(): (new_limb, special) allows you to fail limb attachment
#define COMSIG_CARBON_ATTACH_LIMB "carbon_attach_limb"
	#define COMPONENT_NO_ATTACH (1<<0)
#define COMSIG_CARBON_REMOVED_LIMB "carbon_remove_limb" //from base of /obj/item/bodypart/proc/drop_limb(lost_limb, dismembered)

/// From /obj/item/bodypart/proc/attach_limb(/mob/living/carbon/C, special)
#define COMSIG_LIMB_ATTACH "limb_attach"
/// From /obj/item/bodypart/proc/drop_limb(/mob/living/carbon/C, special)
#define COMSIG_LIMB_REMOVE "limb_remove"
/// From /obj/item/bodypart/proc/apply_splint()
#define COMSIG_LIMB_SPLINTED "limb_splinted"
/// From /obj/item/bodypart/proc/remove_splint()
#define COMSIG_LIMB_UNSPLINTED "limb_unsplinted"

#define COMSIG_LIMB_UPDATE_INTERACTION_SPEED "limb_interact_speed_change"
#define COMSIG_LIMB_EMBED_RIP "limb_embed_rip"

///from base of mob/living/carbon/soundbang_act(): (list(intensity))
#define COMSIG_CARBON_SOUNDBANG "carbon_soundbang"
///from /item/organ/proc/Insert() (/obj/item/organ/)
#define COMSIG_CARBON_GAIN_ORGAN "carbon_gain_organ"
///from /item/organ/proc/Remove() (/obj/item/organ/)
#define COMSIG_CARBON_LOSE_ORGAN "carbon_lose_organ"
///from /mob/living/carbon/tryUnequipItem(obj/item/I, force, newloc, no_move, invdrop, silent)
#define COMSIG_CARBON_UNEQUIP_SHOECOVER "carbon_unequip_shoecover"
#define COMSIG_CARBON_EQUIP_SHOECOVER "carbon_equip_shoecover"
///called when removing a given item from a mob, from mob/living/carbon/remove_embedded_object(mob/living/carbon/target, /obj/item)
#define COMSIG_CARBON_EMBED_REMOVAL "item_embed_remove_safe"
///Called when someone attempts to cuff a carbon
#define COMSIG_CARBON_CUFF_ATTEMPTED "carbon_attempt_cuff"
///Called when a carbon mutates (source = dna, mutation = mutation added)
#define COMSIG_CARBON_GAIN_MUTATION "carbon_gain_mutation"
///Called when a carbon loses a mutation (source = dna, mutation = mutation lose)
#define COMSIG_CARBON_LOSE_MUTATION "carbon_lose_mutation"
///Called when a carbon becomes addicted (source = what addiction datum, addicted_mind = mind of the addicted carbon)
#define COMSIG_CARBON_GAIN_ADDICTION "carbon_gain_addiction"
///Called when a carbon is no longer addicted (source = what addiction datum was lost, addicted_mind = mind of the freed carbon)
#define COMSIG_CARBON_LOSE_ADDICTION "carbon_lose_addiction"
///Called when a carbon gets a brain trauma (source = carbon, trauma = what trauma was added) - this is before on_gain()
#define COMSIG_CARBON_GAIN_TRAUMA "carbon_gain_trauma"
///Called when a carbon loses a brain trauma (source = carbon, trauma = what trauma was removed)
#define COMSIG_CARBON_LOSE_TRAUMA "carbon_lose_trauma"
///Called when a carbon updates their health (source = carbon)
#define COMSIG_CARBON_HEALTH_UPDATE "carbon_health_update"
///Called when a carbon updates their sanity (source = carbon)
#define COMSIG_CARBON_SANITY_UPDATE "carbon_sanity_update"
///Called when a carbon breathes, before the breath has actually occured
#define COMSIG_CARBON_PRE_BREATHE "carbon_pre_breathe"
///Called from apply_overlay(cache_index, overlay)
#define COMSIG_CARBON_APPLY_OVERLAY "carbon_apply_overlay"
///Called from remove_overlay(cache_index, overlay)
#define COMSIG_CARBON_REMOVE_OVERLAY "carbon_remove_overlay"

// /mob/living/carbon/human signals

///Hit by successful disarm attack (mob/living/carbon/human/attacker,zone_targeted)
#define COMSIG_HUMAN_DISARM_HIT "human_disarm_hit"
///Whenever EquipRanked is called, called after job is set
#define COMSIG_JOB_RECEIVED "job_received"
///from /mob/living/carbon/human/proc/set_coretemperature(): (oldvalue, newvalue)
#define COMSIG_HUMAN_CORETEMP_CHANGE "human_coretemp_change"
///from /datum/species/handle_fire. Called when the human is set on fire and burning clothes and stuff
#define COMSIG_HUMAN_BURNING "human_burning"

// Mob transformation signals
///Called when a human turns into a monkey, from /mob/living/carbon/proc/finish_monkeyize()
#define COMSIG_HUMAN_MONKEYIZE "human_monkeyize"
///Called when a monkey turns into a human, from /mob/living/carbon/proc/finish_humanize(species)
#define COMSIG_MONKEY_HUMANIZE "monkey_humanize"

///From mob/living/carbon/human/suicide()
#define COMSIG_HUMAN_SUICIDE_ACT "human_suicide_act"

#define COMSIG_CARBON_PRE_SPRINT "carbon_pre_sprint"
	#define INTERRUPT_SPRINT (1<<0)
