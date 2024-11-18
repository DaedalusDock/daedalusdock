#define DECK_SHUFFLE_TIME (5 SECONDS)
#define DECK_SYNDIE_SHUFFLE_TIME (3 SECONDS)

/obj/item/toy/cards/deck
	name = "deck of cards"
	desc = "A deck of space-grade playing cards."
	icon = 'icons/obj/playing_cards.dmi'
	icon_state = "deck_nanotrasen_full"
	w_class = WEIGHT_CLASS_SMALL
	worn_icon_state = "card"

	hitsound = null
	wielded_hitsound = 'sound/items/cardflip.ogg'

	attack_verb_continuous = list("attacks")
	attack_verb_simple = list("attack")

	/// The amount of time it takes to shuffle
	var/shuffle_time = DECK_SHUFFLE_TIME
	/// Deck shuffling cooldown.
	COOLDOWN_DECLARE(shuffle_cooldown)
	/// If the deck is the standard 52 playing card deck (used for poker and blackjack)
	var/is_standard_deck = TRUE
	/// The amount of cards to spawn in the deck (optional)
	var/decksize = INFINITY
	/// The description of the cardgame that is played with this deck (used for memories)
	var/cardgame_desc = "card game"
	/// The holodeck computer used to spawn a holographic deck (see /obj/item/toy/cards/deck/syndicate/holographic)
	var/obj/machinery/computer/holodeck/holodeck
	/// If the cards in the deck have different card faces icons (blank and CAS decks do not)
	var/has_unique_card_icons = TRUE
	/// The art style of deck used (determines both deck and card icons used)
	var/deckstyle = "nanotrasen"

/obj/item/toy/cards/deck/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/drag_pickup)
	register_context()

	if(!is_standard_deck)
		return

	// generate a normal playing card deck
	cards += new /obj/item/toy/singlecard(src, "Joker Clown", src)
	cards += new /obj/item/toy/singlecard(src, "Joker Mime", src)
	for(var/suit in list("Hearts", "Spades", "Clubs", "Diamonds"))
		cards += new /obj/item/toy/singlecard(src, "Ace of [suit]", src)
		for(var/i in 2 to 10)
			cards += new /obj/item/toy/singlecard(src, "[i] of [suit]", src)
		for(var/person in list("Jack", "Queen", "King"))
			cards += new /obj/item/toy/singlecard(src, "[person] of [suit]", src)

/// triggered on wield of two handed item
/obj/item/toy/cards/deck/proc/on_wield(obj/item/source, mob/user)
	SIGNAL_HANDLER

	wielded = TRUE

/// triggered on unwield of two handed item
/obj/item/toy/cards/deck/proc/on_unwield(obj/item/source, mob/user)
	SIGNAL_HANDLER

	wielded = FALSE

/obj/item/toy/cards/deck/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user] is slitting [user.p_their()] wrists with \the [src]! It looks like their luck ran out!"))
	playsound(src, 'sound/items/cardshuffle.ogg', 50, TRUE)
	return BRUTELOSS

/obj/item/toy/cards/deck/examine(mob/user)
	. = ..()

	if(cards.len > 0)
		var/obj/item/toy/singlecard/card = cards[1]
		if(HAS_TRAIT(user, TRAIT_XRAY_VISION))
			. += span_notice("You scan the deck with your x-ray vision and the top card reads: [card.cardname].")
		var/marked_color = card.getMarkedColor(user)
		if(marked_color)
			. += span_notice("The top card of the deck has a [marked_color] mark on the corner!")
	. += span_notice("Click and drag the deck to yourself to pickup.") // This should be a context screentip

/obj/item/toy/cards/deck/add_context(atom/source, list/context, obj/item/held_item, mob/living/user)
	if(src == held_item)
		var/obj/item/toy/cards/deck/dealer_deck = held_item
		context[SCREENTIP_CONTEXT_LMB] = dealer_deck.wielded ? "Recycle mode" : "Dealer mode"
		context[SCREENTIP_CONTEXT_ALT_LMB] = "Shuffle"
		return CONTEXTUAL_SCREENTIP_SET

	if(isnull(held_item))
		context[SCREENTIP_CONTEXT_LMB] = "Draw card"
		context[SCREENTIP_CONTEXT_RMB] = "Draw card faceup"
		// add drag & drop screentip here in the future
		return CONTEXTUAL_SCREENTIP_SET

	if(istype(held_item, /obj/item/toy/singlecard))
		context[SCREENTIP_CONTEXT_LMB] = "Recycle card"
		return CONTEXTUAL_SCREENTIP_SET

	if(istype(held_item, /obj/item/toy/cards/cardhand))
		context[SCREENTIP_CONTEXT_LMB] = "Recycle cards"
		return CONTEXTUAL_SCREENTIP_SET

	return NONE

/**
 * Shuffles the cards in the deck
 *
 * Arguments:
 * * user - The person shuffling the cards.
 */
/obj/item/toy/cards/deck/proc/shuffle_cards(mob/living/user)
	if(!COOLDOWN_FINISHED(src, shuffle_cooldown))
		return
	COOLDOWN_START(src, shuffle_cooldown, shuffle_time)
	cards = shuffle(cards)
	playsound(src, 'sound/items/cardshuffle.ogg', 50, TRUE)
	user.balloon_alert_to_viewers("shuffles the deck")

/obj/item/toy/cards/deck/attack_hand(mob/living/user, list/modifiers, flip_card = FALSE)
	if(!ishuman(user) || !user.canUseTopic(src, USE_CLOSE|USE_IGNORE_TK|USE_DEXTERITY))
		return

	var/obj/item/toy/singlecard/card = draw(user)
	if(!card)
		return
	if(flip_card)
		card.Flip()

	user.pickup_item(card)
	user.balloon_alert_to_viewers("draws a card")

/obj/item/toy/cards/deck/attack_hand_secondary(mob/living/user, list/modifiers)
	attack_hand(user, modifiers, flip_card = TRUE)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/toy/cards/deck/AltClick(mob/living/user)
	if(user.canUseTopic(src, USE_CLOSE|USE_IGNORE_TK|USE_DEXTERITY))
		if(wielded)
			shuffle_cards(user)
		else
			to_chat(user, span_warning("You must hold [src] with both hands to shuffle!"))
	return ..()

/obj/item/toy/cards/deck/update_icon_state()
	switch(cards.len)
		if(27 to INFINITY)
			icon_state = "deck_[deckstyle]_full"
		if(11 to 27)
			icon_state = "deck_[deckstyle]_half"
		if(1 to 11)
			icon_state = "deck_[deckstyle]_low"
		else
			icon_state = "deck_[deckstyle]_empty"
	return ..()

/obj/item/toy/cards/deck/insert(obj/item/toy/card_item)
	// any card inserted into the deck is always facedown
	if(istype(card_item, /obj/item/toy/singlecard))
		var/obj/item/toy/singlecard/card = card_item
		card.Flip(CARD_FACEDOWN)
	if(istype(card_item, /obj/item/toy/cards/cardhand))
		var/obj/item/toy/cards/cardhand/cardhand = card_item
		for(var/obj/item/toy/singlecard/card in cardhand.cards)
			card.Flip(CARD_FACEDOWN)
	. = ..()

/obj/item/toy/cards/deck/attackby(obj/item/item, mob/living/user, params)
	if(istype(item, /obj/item/toy/singlecard) || istype(item, /obj/item/toy/cards/cardhand))
		insert(item)
		var/card_grammar = istype(item, /obj/item/toy/singlecard) ? "card" : "cards"
		user.balloon_alert_to_viewers("puts [card_grammar] in deck")
		return
	return ..()

/// This is how we play 52 card pickup
/obj/item/toy/cards/deck/throw_impact(mob/living/target, datum/thrownthing/throwingdatum)
	. = ..()
	if(. || !istype(target)) // was it caught or is the target not a living mob
		return .

	if(!throwingdatum?.thrower) // if a mob didn't throw it (need two people to play 52 pickup)
		return

	target.visible_message(span_warning("[target] is forced to play 52 card pickup!"), span_warning("You are forced to play 52 card pickup."))

/*
|| Syndicate playing cards, for pretending you're Gambit and playing poker for the nuke disk. ||
*/
/obj/item/toy/cards/deck/syndicate
	name = "suspicious looking deck of cards"
	desc = "A deck of space-grade playing cards. They seem unusually rigid."
	cardgame_desc = "suspicious card game"
	icon_state = "deck_syndicate_full"
	deckstyle = "syndicate"
	hitsound = 'sound/weapons/bladeslice.ogg'
	force = 5
	throwforce = 10
	attack_verb_continuous = list("attacks", "slices", "dices", "slashes", "cuts")
	attack_verb_simple = list("attack", "slice", "dice", "slash", "cut")
	resistance_flags = NONE
	shuffle_time = DECK_SYNDIE_SHUFFLE_TIME

#undef DECK_SHUFFLE_TIME
#undef DECK_SYNDIE_SHUFFLE_TIME
