GLOBAL_REAL(immortals, /list) = list(
	"ArcLumin",
	"OrdoDictionary",
	"DrSingh",
	"Desolane900",
	"Honkertron"
)

/*

At 7:30 AM on March 8th, 2017, ArcLumin died in a fatal car crash on impact.
Rest in peace, man. You did good work.
When a contributor for SS13 dies, all codebases feel it and suffer.
We may disagree on whether farts should be a thing, or what color to paint the bikeshed,
but we are all contributors together.

Goodbye, man. We'll miss you.

This memorial has been designed for him and any future coders to perish.
*/

/obj/structure/fluff/arc
	name = "Tomb of the Unknown Employee"
	desc = "Here rests an unknown employee\nUnknown by name or rank\nWhose acts will not be forgotten"
	icon = 'icons/obj/tomb.dmi'
	icon_state = "memorial"
	density = TRUE
	anchored = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF


/*

In Memoriam 26th August, 2020
Our friend, fellow admin, and champion of the "short" reply, OrdoDictionary passed away recently.
While this news was not unexpected - Ordo had been fighting bravely against prion disease for some time - it remains as heartbreaking as it is unfair.
Ordo was sharp as a razor, with wit to match. During the time we knew him he was pursuing a PhD, yet he still found time to volunteer here and help his fellow spessman.
In admin channels you were as likely to find Ordo pontificating on history or food or ham radio as you were anything related to the game. But you knew -
no matter the topic - that his opinion was informed and valuable, and that he would deliver it with nuance, class and charm.

This community - and the world - is worse off without him in it.
He will be missed.

So should you read this and should you get the chance, raise a glass in his memory.
…but be sure to break out the good stuff.
That’s how he would have wanted it.
*/
/obj/item/clothing/accessory/medal/gold/ordom
	name = "\proper The OrdoM Memorial Medal For Excellence in Paperwork"
	desc = "Awarded for outstanding excellence in paperwork, administration, and bureaucracy."
	icon_state = "medal_paperwork"
	medaltype = "medal-gold"
	custom_materials = list(/datum/material/gold=1000)

/*

On September 5th, 2022 Dr Singh, also known as Delari, passed away under unknown circumstances.
Singh's contributions cannot be understated, in both code and community. Joining the Goonstation community in 2010 under the ckey magicmountain,
Singh went on to be an incredible person with incredible contributions, from aiding the creation of the Goon Process Scheduler, the creation of qdel(),
and going as far as to spread his knowledge to other servers, such as helping the creation of Fast Explosions on TG. An incredibly friendly and bright
mind is no longer with us, but his passing has once more brought us together, with users from all corners of SS13 grieving.

Also, he was gay.

Rest easy, space doctor.
*/

/datum/emote/living/sigh/select_message_type(mob/user, msg, intentional)
	. = ..()
	if(!muzzle_ignore && user.is_muzzled() && emote_type == EMOTE_AUDIBLE)
		return .

	return prob(1) ? "singhs" : .
