//Contains hay crafts, file replaced from hay.dm
//Thanks to Gomble for keeping hay in a relatively sane place, hay has been moved to be with the rest of the stacks at sheet_types.dm.

//Wicker Basket (Crate)
/obj/structure/closet/crate/wicker
	name = "basket"
	desc = "A handmade wicker basket."
	icon = 'modular_fallout/master_files/icons/obj/crates.dmi'
	icon_state = "basket"
	resistance_flags = FLAMMABLE

/*
* Old deathclaw hay crafts are as follows with encountered obstacles porting, watch this space.
* html: https://github.com/BadDeathclaw/bad-deathclaw/blob/64ba57582479059dd91819603d9ccba356842ca8/code/game/objects/items/stacks/hay.dm

* Rope - Ties, DMI's missing
* Bedroll - Broken DMI sprites when in use, needs bandaid code for overlays to stop the sprite vanishing and improvements because of its parent bed-type
* Broom - Has outdated code compared to parent type, would be more suitable as soap (?)
*/
