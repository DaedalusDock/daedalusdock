/obj/item/clothing/suit/ghost_sheet
	name = "ghost sheet"
	desc = "The hands float by themselves, so it's extra spooky."
	icon_state = "ghost_sheet"
	inhand_icon_state = "ghost_sheet"
	throwforce = 0
	throw_speed = 1
	throw_range = 2
	w_class = WEIGHT_CLASS_TINY
	flags_inv = HIDEGLOVES|HIDEEARS|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR

//Fallout 13 various suits directory
/obj/item/clothing/suit/f13/robe_liz
	name = "tan robe"
	desc = "(I) Only a monk would find this robe nice and comfortable."
	icon_state = "robe_liz"
	inhand_icon_state = "brownjsuit"
	armor = list("tier" = 1)

/obj/item/clothing/suit/f13/mantle_liz
	name = "hide mantle"
	desc = "(I) A rather grisly selection of cured hides and skin, sewn together to form a ragged mantle."
	icon_state = "mantle_liz"
	inhand_icon_state = "det_suit"
	armor = list("tier" = 1)

/obj/item/clothing/suit/f13/mfp //Mad Max 1 1979 babe!
	name = "MFP jacket"
	desc = "(II) A Main Force Patrol leather jacket.<br>Offbeat."
	icon_state = "mfp"
	inhand_icon_state = "hostrench"
	armor = list("tier" = 2, ENERGY = 0, BOMB = 10, BIO = 0, RAD = 0, FIRE = 20, ACID = 0)

/obj/item/clothing/suit/f13/mfp/raider
	name = "offbeat jacket"
	desc = "(II) A black leather jacket with a single metal shoulder pad on the right side.<br>The right sleeve was obviously ripped or cut away.<br>It looks like it was originally a piece of a Main Force Patrol uniform."
	icon_state = "mfp_raider"

/obj/item/clothing/suit/f13/duster
	name = "duster"
	desc = "A long brown leather overcoat.<br>A powerful accessory of fearsome bounty hunter."
	icon_state = "duster"
	inhand_icon_state = "det_suit"
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS

/obj/item/clothing/suit/f13/banker
	name = "bankers tailcoat"
	desc = "(I) A long black jacket, finely crafted black leather and smooth finishings make this an extremely fancy piece of rich-mans apparel."
	icon_state = "banker"
	inhand_icon_state = "banker"
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS

/obj/item/clothing/suit/f13/autumn //Based of Colonel Autumn's uniform.
	name = "tan trenchcoat"
	desc = "A heavy-duty tan trenchcoat typically worn by pre-War generals."
	icon_state = "autumn"
	inhand_icon_state = "autumn"
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS

/obj/item/clothing/suit/f13/hubologist
	name = "hubologist robe"
	desc = "(I) A black robe worn by Adepts of Hubology Studies.<br>Beware - the spirits of the dead are all around us!"
	icon_state = "hubologist"
	inhand_icon_state = "wcoat"
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEHAIR|HIDEFACIALHAIR
	armor = list("tier" = 1)

/obj/item/clothing/suit/f13/sexymaid
	name = "sexy maid outfit"
	desc = "A maid outfit that shows just a little more skin than needed for cleaning duties."
	icon_state = "sexymaid_s"
	inhand_icon_state = "sexymaid_s"
	body_parts_covered = CHEST

/obj/item/clothing/suit/f13/blacksmith_apron
	name = "blacksmith apron"
	desc = "A heavy leather apron designed for protecting the user when metalforging."
	icon_state = "opifex_apron"
	inhand_icon_state = "opifex_apron"
	blood_overlay_type = "armor"
	allowed = list(/obj/item/crowbar,
		/obj/item/screwdriver,
		/obj/item/weldingtool,
		/obj/item/wirecutters,
		/obj/item/wrench,
		/obj/item/multitool,
		/obj/item/flashlight,
		/obj/item/stack/cable_coil,
		/obj/item/t_scanner,
		/obj/item/analyzer,
		/obj/item/geiger_counter,
		/obj/item/extinguisher/mini,
		/obj/item/radio,
		/obj/item/clothing/gloves,
		/obj/item/holosign_creator,
		/obj/item/assembly/signaler
	) //robust storage options!! -superballs

//Special Biosuit

/obj/item/clothing/suit/bio_suit/f13/hazmat
	name = "hazmat suit"
	desc = "(II) Yellow Level A , hazmat protective suit.<br>You can see some numbers on the tag: 35 56."
	icon = 'modular_fallout/master_files/icons/fallout/clothing/suits_utility.dmi'
	mob_overlay_icon = 'modular_fallout/master_files/icons/fallout/onmob/clothes/suit_utility.dmi'
	icon_state = "hazmat"
	inhand_icon_state = "hazmat"

/obj/item/clothing/head/bio_hood/f13/hazmat
	name = "hazmat hood"
	desc = "(II) My star, my perfect silence."
	icon = 'modular_fallout/master_files/icons/fallout/clothing/hats.dmi'
	icon_state = "hazmat"
	inhand_icon_state = "hazmat_helmet"
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR

//Fallout 13 toggle apparel directory
/obj/item/clothing/suit/toggle/labcoat/f13/emergency
	name = "first responder jacket"
	desc = "(I) A high-visibility jacket worn by medical first responders."
	icon_state = "fr_jacket"
	inhand_icon_state = "fr_jacket"

/obj/item/clothing/suit/toggle/labcoat/f13/warriors
	name = "warriors jacket"
	desc = "(II) A red leather jacket, with the word \"Warriors\" sewn above the white wings on the back."
	icon_state = "warriors"
	inhand_icon_state = "owl"
	armor = list("tier" = 2, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 0, ACID = 0)

/obj/item/clothing/suit/toggle/labcoat/f13/wanderer
	name = "wanderer jacket"
	desc = "A zipped-up hoodie made of tanned leather."
	icon_state = "wanderer"
	inhand_icon_state = "owl"
	armor = list("tier" = 2, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 0, ACID = 0)

/obj/item/clothing/suit/toggle/labcoat/f13/khan_jacket
	name = "Great Khan jacket"
	desc = "(IV) A black leather jacket. <br>There is an illustration on the back - an aggressive, red-eyed skull wearing a fur hat with horns.<br>The skull has a mongoloid moustache - it's obviously a Great Khans emblem."
	icon_state = "khan_jacket"
	inhand_icon_state = "jensencoat"
	armor = list("tier" = 4, ENERGY = 25, BOMB = 30, BIO = 0, RAD = 0, FIRE = 25, ACID = 25)

/obj/item/clothing/suit/toggle/labcoat/f13/khan_jacket_armored
	name = "Great Khan armored jacket"
	desc = "(V) A black leather jacket. <br>There is an illustration on the back - an aggressive, red-eyed skull wearing a fur hat with horns.<br>The skull has a mongoloid moustache - it's obviously a Great Khans emblem.<br>Protective plates have been sewn into the jacket."
	icon_state = "khan_jacket"
	inhand_icon_state = "jensencoat"
	armor = list("tier" = 5, ENERGY = 35, BOMB = 30, BIO = 0, RAD = 0, FIRE = 25, ACID = 25)

/obj/item/clothing/suit/toggle/labcoat/f13/khan/battlecoat
	name = "Great Khan battle coat"
	desc = "(V) A dark red leather coat lined with a patchwork of metal plates and padding on the inside. The back is dominated by a burning skull adorned with a horned helmet; the symbol of the Khans."
	icon_state = "khan_battlecoat"
	inhand_icon_state = "khan_battlecoat"
	armor = list("tier" = 5, ENERGY = 35, BOMB = 30, BIO = 0, RAD = 0, FIRE = 25, ACID = 25)

/obj/item/clothing/suit/toggle/labcoat/f13/followers
	name = "followers lab coat"
	desc = "(II) A worn-down white labcoat with some wiring hanging from the right side.<br>Upon closer inspection, you can see an ancient bloodstains that could tell an entire story about thrilling adventures of a previous owner."
	icon_state = "followers"
	inhand_icon_state = "labcoat"
	armor = list("tier" = 2, ENERGY = 10, BOMB = 0, BIO = 10, RAD = 10, FIRE = 10, ACID = 10)

/obj/item/clothing/suit/armor/f13/generaluniform
	name = "Yuma 1st Irregular General Uniform"
	desc = "(III) A uniform created by Kaleb alongside the laser muskets. On the breast is a patch of the Yuma 1st Irregulars, a sun over a wasteland desert, a cactus standing lonely in the middle. It denotes him as the Leader of the militia company."
	icon_state = "gen_uniform"
	inhand_icon_state = "gen_uniform"
	armor = list("tier" = 3, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 0, ACID = 0) //change those values

/obj/item/clothing/suit/hooded/cloak/desert
	name = "desert cloak"
	icon_state = "desertcloak"
	desc = "(II) A practical cloak made out of animal hide."
	hoodtype = /obj/item/clothing/head/hooded/cloakhood/desert
	armor = list("tier" = 2, ENERGY = 15, BOMB = 25, BIO = 0, RAD = 0, FIRE = 10, ACID = 0)
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS


/obj/item/clothing/head/hooded/cloakhood/desert
	name = "desert cloak hood"
	icon_state = "desertcloak"
	desc = "(II) A protective and concealing hood."
	flags_inv = HIDEEARS|HIDEEYES|HIDEHAIR|HIDEFACIALHAIR
	armor = list("tier" = 2, ENERGY = 15, BOMB = 25, BIO = 0, RAD = 0, FIRE = 10, ACID = 0)

/obj/item/clothing/suit/hooded/cloak/desert/raven_cloak
	name = "Raven cloak"
	desc = "(II) A huge cloak made out of hundreds of knife-like black bird feathers. It glitters in the light, ranging from blue to dark green and purple."
	icon_state = "raven_cloak"
	inhand_icon_state = "raven_cloak"
	hoodtype = /obj/item/clothing/head/hooded/cloakhood/desert/raven_hood

/obj/item/clothing/head/hooded/cloakhood/desert/raven_hood
	name = "Raven cloak hood"
	desc = "(II) A hood fashioned out of patchwork and feathers"
	icon_state = "raven_hood"
	inhand_icon_state = "raven_hood"
