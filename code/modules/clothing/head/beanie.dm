
//BeanieStation13 Redux

//Plus a bobble hat, lets be inclusive!!

/obj/item/clothing/head/beanie //Default is white, this is meant to be seen
	name = "white beanie"
	desc = "A stylish beanie. The perfect winter accessory for those with a keen fashion sense, and those who just can't handle a cold breeze on their heads."
	icon_state = "beanie" //Default white
	custom_price = PAYCHECK_ASSISTANT * 1.2

/obj/item/clothing/head/beanie/black
	name = "black beanie"
	icon_state = "beanie"
	color = "#4A4A4B" //Grey but it looks black

/obj/item/clothing/head/beanie/red
	name = "red beanie"
	icon_state = "beanie"
	color = "#D91414" //Red

/obj/item/clothing/head/beanie/green
	name = "green beanie"
	icon_state = "beanie"
	color = "#5C9E54" //Green

/obj/item/clothing/head/beanie/darkblue
	name = "dark blue beanie"
	icon_state = "beanie"
	color = "#1E85BC" //Blue

/obj/item/clothing/head/beanie/purple
	name = "purple beanie"
	icon_state = "beanie"
	color = "#9557C5" //purple

/obj/item/clothing/head/beanie/yellow
	name = "yellow beanie"
	icon_state = "beanie"
	color = "#E0C14F" //Yellow

/obj/item/clothing/head/beanie/orange
	name = "orange beanie"
	icon_state = "beanie"
	color = "#C67A4B" //orange

/obj/item/clothing/head/beanie/cyan
	name = "cyan beanie"
	icon_state = "beanie"
	color = "#54A3CE" //Cyan (Or close to it)

//Striped Beanies have unique sprites

/obj/item/clothing/head/beanie/christmas
	name = "christmas beanie"
	icon_state = "beaniechristmas"

/obj/item/clothing/head/beanie/striped
	name = "striped beanie"
	icon_state = "beaniestriped"

/obj/item/clothing/head/beanie/stripedred
	name = "red striped beanie"
	icon_state = "beaniestripedred"

/obj/item/clothing/head/beanie/stripedblue
	name = "blue striped beanie"
	icon_state = "beaniestripedblue"

/obj/item/clothing/head/beanie/stripedgreen
	name = "green striped beanie"
	icon_state = "beaniestripedgreen"

TYPEINFO_DEF(/obj/item/clothing/head/beanie/durathread)
	default_armor = list(BLUNT = 15, PUNCTURE = 5, SLASH = 0, LASER = 15, ENERGY = 25, BOMB = 10, BIO = 0, FIRE = 30, ACID = 5)

/obj/item/clothing/head/beanie/durathread
	name = "durathread beanie"
	desc = "A beanie made from durathread, its resilient fibres provide some protection to the wearer."
	icon_state = "beaniedurathread"

/obj/item/clothing/head/beanie/waldo
	name = "red striped bobble hat"
	desc = "If you're going on a worldwide hike, you'll need some cold protection."
	icon_state = "waldo_hat"

/obj/item/clothing/head/beanie/rasta
	name = "rastacap"
	desc = "Perfect for tucking in those dreadlocks."
	icon_state = "beanierasta"

//No dog fashion sprites yet :(  poor Ian can't be dope like the rest of us yet

/obj/item/clothing/head/beanie/black/dboy
	name = "test subject beanie"
	desc = "A dingy and torn black beanie. Is that slime or grease?"
	/// Used for the extra flavor text the d-boy himself sees
	var/datum/weakref/beanie_owner = null

/obj/item/clothing/head/beanie/black/dboy/equipped(mob/user, slot)
	. = ..()
	if(iscarbon(user) && !beanie_owner)
		beanie_owner = WEAKREF(user)

/obj/item/clothing/head/beanie/black/dboy/examine(mob/user)
	. = ..()
	if(IS_WEAKREF_OF(user, beanie_owner))
		. += span_purple("It's covered in otherworldly debris only your eyes have been ruined enough to see.")
