GLOBAL_LIST_INIT(loadout_toys, generate_loadout_items(/datum/loadout_item/toys))

/datum/loadout_item/toys
	category = LOADOUT_ITEM_TOYS
	can_be_named = TRUE

/datum/loadout_item/toys/bee
	name = "Bee Plush"
	item_path = /obj/item/toy/plush/beeplushie

/datum/loadout_item/toys/carp
	name = "Carp Plush"
	item_path = /obj/item/toy/plush/carpplushie

/datum/loadout_item/toys/lizard_greyscale
	name = "Greyscale Lizard Plush"
	item_path = /obj/item/toy/plush/lizard_plushie

/datum/loadout_item/toys/lizard_random
	name = "Random Lizard Plush"
	item_path = /obj/item/toy/plush/lizard_plushie
	additional_tooltip_contents = list(TOOLTIP_RANDOM_COLOR)

/datum/loadout_item/toys/moth
	name = "Moth Plush"
	item_path = /obj/item/toy/plush/moth

/datum/loadout_item/toys/narsie
	name = "Nar'sie Plush"
	item_path = /obj/item/toy/plush/narplush
	restricted_roles = list(JOB_CHAPLAIN)

/datum/loadout_item/toys/nukie
	name = "Nukie Plush"
	item_path = /obj/item/toy/plush/nukeplushie

/datum/loadout_item/toys/peacekeeper
	name = "Peacekeeper Plush"
	item_path = /obj/item/toy/plush/pkplush

/datum/loadout_item/toys/plasmaman
	name = "Plasmaman Plush"
	item_path = /obj/item/toy/plush/plasmamanplushie

/datum/loadout_item/toys/ratvar
	name = "Ratvar Plush"
	item_path = /obj/item/toy/plush/ratplush
	restricted_roles = list(JOB_CHAPLAIN)

/datum/loadout_item/toys/rouny
	name = "Rouny Plush"
	item_path = /obj/item/toy/plush/rouny

/datum/loadout_item/toys/snake
	name = "Snake Plush"
	item_path = /obj/item/toy/plush/snakeplushie

/datum/loadout_item/toys/slime
	name = "Slime plushie"
	item_path = /obj/item/toy/plush/slimeplushie

/datum/loadout_item/toys/bubble
	name = "Bubblegum plushie"
	item_path = /obj/item/toy/plush/bubbleplush

/datum/loadout_item/toys/goat
	name = "Strange Goat plushie"
	item_path = /obj/item/toy/plush/goatplushie

/datum/loadout_item/toys/card_binder
	name = "Card Binder"
	item_path = /obj/item/storage/card_binder

/datum/loadout_item/toys/card_deck
	name = "Playing Card Deck"
	item_path = /obj/item/toy/cards/deck

/datum/loadout_item/toys/kotahi_deck
	name = "Kotahi Deck"
	item_path = /obj/item/toy/cards/deck/kotahi

/datum/loadout_item/toys/wizoff_deck
	name = "Wizoff Deck"
	item_path = /obj/item/toy/cards/deck/wizoff

/datum/loadout_item/toys/tarot
	name = "Tarot Card Deck"
	item_path = /obj/item/toy/cards/deck/tarot

/datum/loadout_item/toys/d1
	name = "D1"
	item_path = /obj/item/dice/d1

/datum/loadout_item/toys/d2
	name = "D2"
	item_path = /obj/item/dice/d2

/datum/loadout_item/toys/d4
	name = "D4"
	item_path = /obj/item/dice/d4

/datum/loadout_item/toys/d6
	name = "D6"
	item_path = /obj/item/dice/d6

/datum/loadout_item/toys/d6_ebony
	name = "D6 (Ebony)"
	item_path = /obj/item/dice/d6/ebony

/datum/loadout_item/toys/d6_space
	name = "D6 (Space)"
	item_path = /obj/item/dice/d6/space

/datum/loadout_item/toys/d8
	name = "D8"
	item_path = /obj/item/dice/d8

/datum/loadout_item/toys/d10
	name = "D10"
	item_path = /obj/item/dice/d10

/datum/loadout_item/toys/d12
	name = "D12"
	item_path = /obj/item/dice/d12

/datum/loadout_item/toys/d20
	name = "D20"
	item_path = /obj/item/dice/d20

/datum/loadout_item/toys/d100
	name = "D100"
	item_path = /obj/item/dice/d100

/datum/loadout_item/toys/d00
	name = "D00"
	item_path = /obj/item/dice/d00

/datum/loadout_item/toys/dice
	name = "Dice bag"
	item_path = /obj/item/storage/dice

/datum/loadout_item/toys/eightball
	name = "Magic eightball"
	item_path = /obj/item/toy/eightball

/datum/loadout_item/toys/toykatana
	name = "Toy Katana"
	item_path = /obj/item/toy/katana

/datum/loadout_item/toys/crayons
	name = "Box of crayons"
	item_path = /obj/item/storage/crayons
