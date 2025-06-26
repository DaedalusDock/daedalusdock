/obj/item/clothing/under/f13
	armor = list(BLUNT = 0, PUNCTURE = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 0, ACID = 0) //Base type has no armor as well
	body_parts_covered = CHEST|GROIN|ARMS|LEGS
	fitted = FEMALE_UNIFORM_FULL
	can_adjust = FALSE
	resistance_flags = NONE
	has_sensor = NO_SENSORS //kek

/obj/item/clothing/under/f13/female
	fitted = FEMALE_UNIFORM_TOP

//ENCLAVE PEACEKEEPERS

/obj/item/clothing/under/f13/enclave/science
	name = "science officer uniform"
	desc = "(I)Off-white military style uniform for scientists."
	icon_state = "uniform_enclave_science"
	inhand_icon_state = "uniform_enclave_science"
	armor = list("tier" = 1, BIO = 50, RAD = 50, FIRE = 50, ACID = 50)

/obj/item/clothing/under/f13/enclave/peacekeeper
	name = "peacekeeper uniform"
	desc = "(II)Khaki standard issue uniform over a black turtleneck."
	icon_state = "uniform_enclave_peacekeeper"
	inhand_icon_state = "uniform_enclave_peacekeeper"
	armor = list("tier" = 2)

/obj/item/clothing/under/f13/enclave/officer
	name = "officer uniform"
	desc = "(II)Khaki officers uniform with gold trimming over a black turtleneck."
	icon_state = "uniform_enclave_officer"
	inhand_icon_state = "uniform_enclave_officer"
	armor = list("tier" = 2)

/obj/item/clothing/under/f13/enclave/intel
	name = "intel officer uniform"
	desc = "(III)Dark pants and turtleneck with hidden kevlar layers, since intel officers often wear no proper armor."
	icon_state = "uniform_enclave_intel"
	inhand_icon_state = "uniform_enclave_intel"
	armor = list("tier" = 3)

//Vault

/obj/item/clothing/under/f13/housewifedress50s
	name = "50s style dress"
	desc = "Fancy checkered yellow dress with small shoulder puffs."
	icon_state = "dress50s"
	inhand_icon_state = "dress50s"

/obj/item/clothing/under/f13/picnicdress50s
	name = "50s style dress"
	desc = "Cheery polkadot casual dress."
	icon_state = "dresspicnic50s"
	inhand_icon_state = "dresspicnic50s"

/obj/item/clothing/under/f13/vault
	name = "vault jumpsuit"
	desc = "A blue jumpsuit with a yellow vault pattern printed on it."
	icon_state = "vault"
	inhand_icon_state = "vault"
	//item_color = "vault"
	can_adjust = TRUE
	has_sensor = LOCKED_SENSORS
	sensor_mode = SENSOR_COORDS
	random_sensor = FALSE
	armor = list(BLUNT = 0, PUNCTURE = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 30, FIRE = 20, ACID = 50)

/obj/item/clothing/under/f13/vault13
	name = "vault 113 jumpsuit"
	desc = "A blue jumpsuit with a yellow vault pattern and the number 113 printed on it."
	icon_state = "vault13"
	inhand_icon_state = "vault13"
	//item_color = "vault13"
	can_adjust = TRUE
	has_sensor = LOCKED_SENSORS
	sensor_mode = SENSOR_COORDS
	random_sensor = FALSE
	armor = list(BLUNT = 0, PUNCTURE = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 30, FIRE = 20, ACID = 50)


//NCR

/obj/item/clothing/under/f13/ncr
	name = "NCR desert fatigues"
	desc = "A set of standard issue New California Republic trooper fatigues."
	icon_state = "ncr_uniform"
	can_adjust = TRUE
	inhand_icon_state = "ncr_uniform"
	//item_color = "ncr_uniform"
	armor = list(BLUNT = 0, PUNCTURE = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 30, FIRE = 20, ACID = 50)

/obj/item/clothing/under/f13/ncr/ncr_officer
	name = "NCR officer fatigues"
	desc = "A standard service uniform for commissioned officers of the New California Republic."
	can_adjust = TRUE
	icon_state = "ncr_officer"
	inhand_icon_state = "ncr_officer"
	//item_color = "ncr_officer"

/obj/item/clothing/under/f13/ncr/scout
	name = "NCR scout fatigues"
	desc = "A standard duty uniform for scouts of the New California Republic."
	icon_state = "scoutclothes"
	inhand_icon_state = "scoutclothes"
	//item_color = "scoutclothes"

/obj/item/clothing/under/f13/ncr/sniper
	name = "NCR sniper fatigues"
	desc = "A standard duty uniform for snipers of the New California Republic."
	can_adjust = FALSE
	icon_state = "ncr_snipermgs"
	inhand_icon_state = "ncr_snipermgs"
	//item_color = "ncr_snipermgs"

/obj/item/clothing/under/f13/ncr/pants
	name = "NCR fatigue pants"
	desc = "A set of standard issue fatigue pants without the upper overcoat. For when you really need to show off your guns."
	can_adjust = FALSE
	icon_state = "ncr_fatigue_pants"
	inhand_icon_state = "ncr_fatigue_pants"
	//item_color = "ncr_fatigue_pants"

/obj/item/clothing/under/f13/ncr/ncr_shorts
	name = "NCR fatigue shorts"
	desc = "A set of uniform shorts and lightweight shirt for NCR troopers deployed in hot climates."
	can_adjust = TRUE
	icon_state = "ncr_shorts"
	inhand_icon_state = "ncr_shorts"
	//item_color = "ncr_shorts"

/obj/item/clothing/under/f13/ncrcaravan
	name = "NCR caravaneer outfit"
	desc = "A soft outfit commonly worn by NCR caravaneers."
	icon_state = "caravaneer"
	inhand_icon_state = "caravaneer"
	//item_color = "caravaneer"

/obj/item/clothing/under/f13/ncr/ncr_dress
	name = "NCR dress uniform"
	desc = "A crisp tan NCRA dress uniform, complete with tie."
	can_adjust = TRUE
	icon_state = "ncr_dress"
	inhand_icon_state = "ncr_dress"
	//item_color = "ncr_dress"

/obj/item/clothing/under/f13/ncrcf
	name = "caravaneer outfit"
	desc = "A cheap blue shirt and slacks, the letters 'NCRCF' emblazened on the back. A meek reminder of who owns you."
	can_adjust = TRUE
	icon_state = "ncrcf"
	inhand_icon_state = "ncrcf"
	//item_color = "ncrcf"

//Settlers

/obj/item/clothing/under/f13/brahminm
	name = "brahmin skin outfit"
	desc = "A basic outfit consisting of a white shirt and patched trousers with Y-shaped suspenders"
	icon_state = "brahmin_m"
	inhand_icon_state = "brahmin_m"
	//item_color = "brahmin_m"

/obj/item/clothing/under/f13/brahminf
	name = "brahmin skin outfit"
	desc = "A basic outfit consisting of a white shirt and patched trousers with Y-shaped suspenders"
	icon_state = "brahmin_f"
	inhand_icon_state = "brahmin_f_s"
	//item_color = "brahmin_f"

/obj/item/clothing/under/f13/doctorm
	name = "doctor fatigues"
	desc = "It's a white t-shirt with brown trousers made for those who treasure life."
	icon_state = "doctor_m"
	inhand_icon_state = "doctor_m"
	//item_color = "doctor_m"
	armor = list(BLUNT = 0, PUNCTURE = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 30, FIRE = 20, ACID = 50)

/obj/item/clothing/under/f13/doctorf
	name = "doctor fatigues"
	desc = "It's a white t-shirt with brown trousers made for those who treasure life."
	icon_state = "doctor_f"
	inhand_icon_state = "doctor_f"
	//item_color = "doctor_f"
	armor = list(BLUNT = 0, PUNCTURE = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 30, FIRE = 20, ACID = 50)

/obj/item/clothing/under/f13/caravan
	name = "caravan pants"
	desc = "Brown thick caravaneer pants."
	icon_state = "caravan"
	inhand_icon_state = "caravan"
	//item_color = "caravan"

/obj/item/clothing/under/f13/settler
	name = "settler outfit"
	desc = "A crudely made cloth robe with a belt worn over grey pants."
	icon_state = "settler"
	inhand_icon_state = "settler"
	//item_color = "settler"

//The City

//Ranger
/obj/item/clothing/under/f13/ranger
	name = "ranger outfit"
	desc = "Simple rustic clothes for a big iron packin' lawman."
	icon_state = "ranger"
	inhand_icon_state = "ranger"
	//item_color = "ranger"
	armor = list(BLUNT = 0, PUNCTURE = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 30, FIRE = 20, ACID = 50)

/obj/item/clothing/under/f13/ranger/trail
	name = "ranger outfit"
	desc = "Simple rustic clothes for a big iron packin' lawman. Worn often by NCR rangers."
	icon_state = "cowboyrang"
	inhand_icon_state = "cowboyrang"
	//item_color = "cowboyrang"

/obj/item/clothing/under/f13/ranger/patrol
	name = "patrol ranger outfit"
	desc = "A pair of brown slacks and a breathable shirt, meant to be worn under NCR patrol ranger armour."
	icon_state = "patrolranger"
	inhand_icon_state = "patrolranger"
	//item_color = "patrolranger"

/obj/item/clothing/under/f13/ranger/vet
	name = "ranger flannel outfit"
	desc = "Simple rustic clothes for any big iron packin' ranger."
	icon_state = "vetranger"
	inhand_icon_state = "vetranger"
	//item_color = "vetranger"

/obj/item/clothing/under/f13/ranger/vet/foxflannel
	name = "black ranger flannel outfit"
	desc = "A black flannel ontop of a pair of slim-fitting pre-war jeans that were kept in excellent condition. The back leather panel is worn out but you can barely make out: '512'."
	icon_state = "foxflannel"
	inhand_icon_state = "foxflannel"
	//item_color = "foxflannel"

/obj/item/clothing/under/f13/ranger/vet/thaxflannel
	name = "Thaxton's ranger flannel outfit"
	desc = "A simple outfit for a burly, big iron packin' lawman. A golden belt-buckle in the rough shape of a medallion is proudly presented atop a leather gunbelt."
	icon_state = "thaxflannel"
	inhand_icon_state = "thaxflannel"
	//item_color = "thaxflannel"

/obj/item/clothing/under/f13/ranger/erin
	name = "desert pants"
	desc = "An old pair of beat up, Pre-War BDUs. These ones are emblazoned with desert patterns, and it has been reinforced around the left knee."
	icon_state = "erin_pants"
	inhand_icon_state = "erin_pants"

/obj/item/clothing/under/f13/ranger/blue
	name = "blue ranger outfit"
	desc = "Simple rustic clothes for a big iron packin' lawman. A blue collar shirt with tan slacks."
	icon_state = "blueranger"
	inhand_icon_state = "blueranger"
	//item_color = "blueranger"

/obj/item/clothing/under/f13/ncr_formal_uniform/majzirilli
	name = "Major Zirilli's service uniform"
	desc = "An immaculately maintained NCRA service uniform, weighted down with golden embellishments signifying their authority."
	icon_state = "majzirilli"
	inhand_icon_state = "majzirilli"
	//item_color = "majzirilli"

/obj/item/clothing/under/f13/ranger/modif_ranger
	name = "green ranger outfit"
	desc = "A ranger outfit with a green cotton longshirt and dark grey jeans along with a black bandana around the neck."
	icon_state = "modif_ranger"
	inhand_icon_state = "modif_ranger"
	//item_color = "modif_ranger"

/obj/item/clothing/under/f13/rustic
	name = "rustic outfit"
	desc = "Simple rustic clothes for your day to day life in the wastes."
	icon_state = "vetranger"
	inhand_icon_state = "rustictown"
	//item_color = "rustictown"
	armor = list(BLUNT = 0, PUNCTURE = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 30, FIRE = 20, ACID = 50)

/obj/item/clothing/under/f13/sheriff
	name = "sheriff outfit"
	desc = "The symbol of law and civilization, a black vest over a well starched white shirt."
	icon_state = "vest_and_slacks"
	inhand_icon_state = "vest_and_slacks"
	//item_color = "vest_and_slacks"
	armor = list(BLUNT = 0, PUNCTURE = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 30, FIRE = 20, ACID = 50)

/obj/item/clothing/under/f13/sleazeball
	name = "loanshark outfit"
	desc = "The symbol of profit and corruption, a black vest over a well starched white shirt."
	icon_state = "vest_and_slacks"
	inhand_icon_state = "vest_and_slacks"
	//item_color = "vest_and_slacks"
	armor = list(BLUNT = 0, PUNCTURE = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 30, FIRE = 20, ACID = 50)

/obj/item/clothing/under/f13/follower
	name = "citzen outfit"
	desc = "A civilized well cared for outfit that good citzens wear."
	icon_state = "follower"
	inhand_icon_state = "follower"
	//item_color = "follower"
	armor = list(BLUNT = 0, PUNCTURE = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 50, FIRE = 20, ACID = 50)

/obj/item/clothing/under/f13/medic
	name = "doctor outfit"
	desc = "A completly white outfit deserving of a doctor."
	icon_state = "chef"
	inhand_icon_state = "chef"
	//item_color = "chef"
	armor = list(BLUNT = 0, PUNCTURE = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 30, FIRE = 20, ACID = 50)

//Brotherhood of Steel

/obj/item/clothing/under/f13/recon
	name = "recon bodysuit"
	desc = "A vacuum-sealed asbestos jumpsuit covering the entire body."
	icon_state = "recon"
	inhand_icon_state = "recon"
	//item_color = "recon"
	armor = list(BLUNT = 0, PUNCTURE = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 40, FIRE = 30, ACID = 80)

/obj/item/clothing/under/f13/recon/outcast
	name = "recon bodysuit"
	desc = "A vacuum-sealed asbestos jumpsuit covering the entire body, dyed and painted black with red markings."
	icon_state = "recon_outcast"
	inhand_icon_state = "recon_outcast"
	//item_color = "recon"
	armor = list(BLUNT = 0, PUNCTURE = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 40, FIRE = 30, ACID = 80)

//Legion

/obj/item/clothing/under/f13/campfollowermale
	name = "camp follower male robe"
	desc = "Olive colored cloth with a red belt."
	icon_state = "legcamp"
	inhand_icon_state = "brownjsuit"

/obj/item/clothing/under/f13/campfollowerfemale
	name = "camp follower female robe"
	desc = "Olive colored cloth with a red sash."
	icon_state = "legcamp_f"
	inhand_icon_state = "legcamp_f"

/obj/item/clothing/under/f13/legskirt
	name = "legionary fatigues"
	desc = "A black learthery skirt and a thick long sleeve cotton shirt."
	icon_state = "legskirt"
	inhand_icon_state = "legskirt"
	//item_color = "legskirt"
	var/sleeves_adjusted = 0
	lefthand_file = 'modular_fallout/master_files/icons/mob/inhands/clothing_lefthand.dmi'
	righthand_file = 'modular_fallout/master_files/icons/mob/inhands/clothing_righthand.dmi'
	alt_covers_chest = TRUE
	can_adjust = TRUE

/obj/item/clothing/under/f13/legskirt/tac
	name = "\improper ''tactical'' combat skirt"
	desc = "A leathery skirt below a thick, black, long-sleeve cotton shirt. Perfect for operatives favoring wardrobe malfunctions."
	icon_state = "tacskirt"
	inhand_icon_state = "tacskirt"
	//item_color = "tacskirt"

/obj/item/clothing/under/f13/priestess
	name = "priestess robes"
	desc = "The robes worn by a Priestess of Mars."
	icon_state = "priestess"
	inhand_icon_state = "priestess"
	//item_color = "priestess"

/obj/item/clothing/under/f13/pmarsrobe
	name = "priestess of mars robe"
	desc = "A red robe decorated with bird feathers for the Priestess of Mars."
	icon_state = "pmars_robe"
	inhand_icon_state = "pmars_robe"
	armor = list(melee = 0, bullet = 0, laser = 20, energy = 20, bomb = 5, bio = 0, rad = 0, fire = 100, acid = 0)
	resistance_flags = LAVA_PROOF | FIRE_PROOF
	body_parts_covered = CHEST|GROIN|ARMS|LEGS
	flags_inv = HIDEGLOVES|HIDESHOES

/obj/item/clothing/under/f13/legauxilia
	name = "male auxilia robes"
	desc = "Thin cotton robe for males, short sleeved with a leather belt, ends just above the knees."
	icon_state = "legaux"
	inhand_icon_state = "legaux"
	//item_color = "legskirt"
	lefthand_file = 'modular_fallout/master_files/icons/mob/inhands/clothing_lefthand.dmi'
	righthand_file = 'modular_fallout/master_files/icons/mob/inhands/clothing_righthand.dmi'

/obj/item/clothing/under/f13/legauxiliaf
	name = "female auxilia robes"
	desc = "Thin cotton robe for females, kneelength and held together by a black sash."
	icon_state = "legauxf"
	inhand_icon_state = "legauxf"
	//item_color = "legskirt"
	lefthand_file = 'modular_fallout/master_files/icons/mob/inhands/clothing_lefthand.dmi'
	righthand_file = 'modular_fallout/master_files/icons/mob/inhands/clothing_righthand.dmi'

/obj/item/clothing/under/f13/legslave
	name = "simple male slave clothing"
	desc = "A roughly made long tunic, held in place by a rope, its marked with a big red X signaling its wearer is property of the Legion."
	icon_state = "legslave"
	inhand_icon_state = "legslave"
	//item_color = "rag"

/obj/item/clothing/under/f13/legslavef
	name = "simple female slave clothing"
	desc = "A roughly made long tunic, held in place by a rope, its marked with a big red X signaling its wearer is property of the Legion."
	icon_state = "legslavef"
	inhand_icon_state = "legslavef"
	//item_color = "rag"


//Roma Legion Legacy delete?

/obj/item/clothing/under/f13/romaskirt
	name = "roma legionary fatigues"
	desc = "A worn and abused pair of fatigues, leftover from the legionary's service to Caesar."
	icon_state = "roma_legion"
	inhand_icon_state = "roma_legion"
	//item_color = "roma_legion"

/obj/item/clothing/under/f13/romaskirt/auxilia
	name = "roma auxilia fatigues"
	desc = "A black skirt and a thick long sleeve cotton shirt."
	icon_state = "roma_auxilia"
	inhand_icon_state = "roma_auxilia"
	//item_color = "roma_auxilia"
	var/sleeves_adjusted = 0
	lefthand_file = 'modular_fallout/master_files/icons/mob/inhands/clothing_lefthand.dmi'
	righthand_file = 'modular_fallout/master_files/icons/mob/inhands/clothing_righthand.dmi'
	alt_covers_chest = TRUE
	can_adjust = TRUE

// Generic

/obj/item/clothing/under/f13/chaplain
	name = "Chaplain outfit"
	desc = "Apparel of a religious priest, or minister of sorts."
	icon_state = "chapblack"
	inhand_icon_state = "chapblack"
	//item_color = "chapblack"

/obj/item/clothing/under/f13/machinist
	name = "machinist bodysuit"
	desc = "Apparel of an old-time machinist."
	icon_state = "machinist"
	inhand_icon_state = "machinist"
	//item_color = "machinist"
	armor = list(BLUNT = 0, PUNCTURE = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 30, FIRE = 20, ACID = 50)

/obj/item/clothing/under/f13/lumberjack
	name = "lumberjack outfit"
	desc = "Apparel of an old-time lumberjack."
	icon_state = "lumberjack"
	inhand_icon_state = "lumberjack"
	//item_color = "lumberjack"

/obj/item/clothing/under/f13/shiny
	name = "shiny outfit"
	desc = "Perfect outfit for a brave and reckless cowboy. Shiny!"
	icon_state = "shiny"
	inhand_icon_state = "shiny"
	//item_color = "shiny"

/obj/item/clothing/under/f13/merca
	name = "merc outfit"
	desc = "A mercenary ragtag outfit."
	icon_state = "merca"
	inhand_icon_state = "merca"
	//item_color = "merca"
	armor = list(BLUNT = 0, PUNCTURE = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 20, FIRE = 20, ACID = 40)

/obj/item/clothing/under/f13/mercc
	name = "merc outfit"
	desc = "A mercenary ragtag outfit."
	icon_state = "mercc"
	inhand_icon_state = "mercc"
	//item_color = "mercc"
	armor = list(BLUNT = 0, PUNCTURE = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 20, FIRE = 20, ACID = 40)

/obj/item/clothing/under/f13/cowboyb
	name = "cowboy outfit"
	desc = "A dirt brown cowboy outfit. Specially usefull for herding brahmins."
	icon_state = "cowboyb"
	inhand_icon_state = "cowboyb"
	//item_color = "cowboyb"

/obj/item/clothing/under/f13/cowboyg
	name = "cowboy outfit"
	desc = "A dirt grey cowboy outfit. Specially usefull for herding brahmins."
	icon_state = "cowboyg"
	inhand_icon_state = "cowboyg"
	//item_color = "cowboyg"

/obj/item/clothing/under/f13/combat_shirt
	name = "combat uniform"
	desc = "An old combat uniform, out of use around the time of the war."
	icon_state = "combat_shirt"
	inhand_icon_state = "combat_shirt"
	//item_color = "combat_shirt"

/obj/item/clothing/under/f13/Retro_Biker_Vest
	name = "future vest"
	desc = "A Pink Vest with Black Pants. Quite futuristic looking."
	icon_state = "Biker"
	inhand_icon_state = "Biker"

/obj/item/clothing/under/f13/chinasuitcosmetic
	name = "dysfunctional chinese stealth suit"
	desc = "(II) A matte grey set of ultralight composite above a carefully padded noise-absorbant suit. This unit, used by Chinese special forces during the great war, looks to have had it's fusion matrix removed, and is all but a fashion statement now."
	icon_state = "stealthsuit"
	inhand_icon_state = "stealthsuit"

/obj/item/clothing/under/f13/bearvest //This is being used as Donator gear, check as to whether MidgetDragon still donating before using for anything else.
	name = "Great Bear Vest"
	desc = "A casual set of ripped jeans and a duster. The duster seems to have a familiar symbol spray painted on the back. The inside of the duster seems to have the letters MEB sewn on."
	icon_state = "bearvest"
	inhand_icon_state = "bearvest"

/* //slave rags, crafted from 2 cloth- uncomment when sprites available
/obj/item/clothing/under/f13/slaverags
	name = "slave rags"
	desc = "Rags made for only the most basic and unworthy of slaves."
	icon_state = "slaverags"
	inhand_icon_state = "slaverags"
*/

/obj/item/clothing/under/f13/erpdress
	name = "bandage dress"
	desc = "Made by the famous pre-war fashion designer Marie Calluna, this dress was made to hug your every curve and show off some deep cleavage."
	icon_state = "bandagedress"
	inhand_icon_state = "bandagedress"

/obj/item/clothing/under/f13/classdress
	name = "classy dress"
	desc = "A dress that shows off all of your assets in the best ways, while remaining quite formal and tasteful."
	icon_state = "societydress"
	inhand_icon_state = "societydress"

/obj/item/clothing/under/f13/bluedress
	name = "blue dress"
	desc = "A cute, but plain, common pre-war dress."
	icon_state = "blue_dress"
	inhand_icon_state = "blue_dress"

/obj/item/clothing/under/f13/pinkdress
	name = "pink dress"
	desc = "A cute, but plain, common pre-war dress."
	icon_state = "pink_dress"
	inhand_icon_state = "pink_dress"

/obj/item/clothing/under/f13/greendress
	name = "green dress"
	desc = "A cute, but plain, common pre-war dress."
	icon_state = "green_dress"
	inhand_icon_state = "green_dress"

/obj/item/clothing/under/f13/blackdress
	name = "black dress"
	desc = "A dark and revealing dress that mixes formality and seduction."
	icon_state = "blackdress"
	inhand_icon_state = "blackdress"

/obj/item/clothing/under/f13/xenon
	name = "flashy jumpsuit"
	desc = "A jumpsuit that seems to come from another time."
	icon_state = "xenon"
	inhand_icon_state = "xenon"

/obj/item/clothing/under/f13/roving
	name = "roving trader outfit "
	desc = "It's an outfit commonly worn by the roving traders."
	icon_state = "roving"
	inhand_icon_state = "roving"
	//item_color = "roving"
	armor = list(BLUNT = 0, PUNCTURE = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 20, FIRE = 20, ACID = 40)

/obj/item/clothing/under/f13/follower
	name = "follower volunteer uniform"
	desc = "The uniform of the volunteers in the followers of the apocalypse retinue."
	icon_state = "follower"
	inhand_icon_state = "follower"
	//item_color = "follower"
	armor = list(BLUNT = 0, PUNCTURE = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 20, FIRE = 20, ACID = 40)

/obj/item/clothing/under/f13/raider_leather
	name = "raider leathers"
	desc = "Scraps of material thrown together and typically worn by raiders."
	icon_state = "raider_leather"
	inhand_icon_state = "raider_leather"
	//item_color = "raider_leather"

/obj/item/clothing/under/f13/raiderrags
	name = "raider rags"
	desc = "Fragments of clothing crudely stitched together, worn unanimously by raiders."
	icon_state = "raiderrags"
	inhand_icon_state = "raiderrags"
	//item_color = "raiderrags"

/obj/item/clothing/under/f13/khan
	name = "great khan uniform"
	desc = "The uniform of the the Great Khans."
	icon_state = "khan"
	inhand_icon_state = "khan"
	//item_color = "khan"
	armor = list(BLUNT = 0, PUNCTURE = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 10, FIRE = 10, ACID = 40)

//WAYFARER TRIBAL
/obj/item/clothing/under/f13/tribe
	name = "tribal rags"
	desc = "Dusty rags decorated with strips of leather and small pieces of turquoise."
	icon_state = "tribalrags"
	inhand_icon_state = "tribalrags"

/obj/item/clothing/under/f13/tribe_chief
	name = "tribal chief robes"
	desc = "Well maintained robes adorned with fine leather and polished turquoise."
	icon_state = "chiefrags"
	inhand_icon_state = "chiefrags"

/obj/item/clothing/under/f13/tribe_Hhunter
	name = "Razorclaw robes"
	desc = "Tanned leather robes, decorated with bones of deathclaws and marked with the great machine spirit of earth."
	icon_state = "hhunterrags"
	inhand_icon_state = "hhunterrags"

/obj/item/clothing/under/f13/tribe_shaman
	name = "tribal shaman robes"
	desc = "Carefully hand wozen cloth robes with heavy turqoise jewelry drapped over top."
	icon_state = "shamanrags"
	inhand_icon_state = "shamanrags"

/obj/item/clothing/under/f13/wayfarer
	name = "loincloth"
	desc = "Hand-woven cotton ornated with pieces of turquoise form covering the groin, which can also be adjusted to cover the breasts as well. Well suited for a simpler life lived by the Wayfarer tribe."
	icon_state = "gatherer"
	inhand_icon_state = "gatherer"
	//item_color = "gatherer"
	can_adjust = TRUE

/obj/item/clothing/under/f13/wayfarer/shamanblue
	name = "blue shaman garbs"
	desc = "Finely crafted cotton clothing, dyed blue with anil. The care and craftsmanship put into such an outfit indicates high status in the Wayfarer tribe. Can be adjusted to suit the wearer's preferences."
	icon_state = "shamanblue"
	inhand_icon_state = "shamanblue"
	//item_color = "shamanblue"
	can_adjust = TRUE

/obj/item/clothing/under/f13/wayfarer/shamanred
	name = "red shaman garbs"
	desc = "Finely crafted cotton clothing, dyed red with madder root. The care and craftsmanship put into such an outfit indicates high status in the Wayfarer tribe. Can be adjusted to suit the wearer's preferences."
	icon_state = "shamanred"
	inhand_icon_state = "shamanred"
	//item_color = "shamanred"
	can_adjust = TRUE

/obj/item/clothing/under/f13/wayfarer/acolyte
	name = "acolyte's garbs"
	desc = "Hand-woven cotton ornated with pieces of turquoise form little more than loincloth, which can be adjusted depending on the wearer's preferences. Well suited for a simpler life lived by the Wayfarer tribe."
	icon_state = "acolyte"
	inhand_icon_state = "acolyte"
	//item_color = "acolyte"
	can_adjust = TRUE

/obj/item/clothing/under/f13/wayfarer/hunter
	name = "rugged loincloth"
	desc = "Minimal yet hardy clothing padded in places by leather which can be taken off if need be, covering no more than it needs to. Ideal for those of the Wayfarer tribe who spend their time away from the tribe in pursuit of the hunt."
	icon_state = "hunter"
	inhand_icon_state = "hunter"
	//item_color = "hunter"
	can_adjust = TRUE

//OUTLAW DESERTERS
/obj/item/clothing/under/f13/exile
	name = "disheveled NCR fatigues"
	desc = "A disheveled and modified duty uniform resembling NCR fatigues."
	icon_state = "ncr_uniformexile"
	inhand_icon_state = "ncr_uniformexile"
	//item_color = "ncr_uniformexile"
	armor = list(BLUNT = 0, PUNCTURE = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 30, FIRE = 20, ACID = 50)

/obj/item/clothing/under/f13/exile/legion
	name = "disheveled Legion fatigues"
	desc = "A disheveled and modified uniform resembling Legion standard fatigues."
	icon_state = "legion_uniformexile"
	inhand_icon_state = "legion_uniformexile"
	//item_color = "legion_uniformexile"

/obj/item/clothing/under/f13/exile/vault
	name = "disheveled Dweller jumpsuit"
	desc = "A disheveled and torn uniform resembling a Vault-Tech standard Jumpsuit."
	icon_state = "vault_exile"
	inhand_icon_state = "vault_exile"
	//item_color = "vault_exile"

/obj/item/clothing/under/f13/exile/tribal
	name = "disheveled loincloth"
	desc = "Fine handcrafted tribal clothing, now torn and faded. A simple lointcloth that comes with a piece of cloth to cover the chest with as well."
	icon = 'modular_fallout/master_files/icons/fallout/clothing/uniforms.dmi'
	icon_state = "clothing_tribalout"
	mob_overlay_icon = 'modular_fallout/master_files/icons/fallout/onmob/clothes/uniform.dmi'
	inhand_icon_state = "clothing_tribalout"
	can_adjust = TRUE

/obj/item/clothing/under/f13/exile/enclave
	name = "disheveled peacekeeper uniform"
	desc = "Khaki standard issue uniform over a black turtleneck. This one seems to be damaged."
	icon_state = "enclave_uniformexile"
	inhand_icon_state = "enclave_uniformexile"

//stuff ported from WW2
/obj/item/clothing/under/f13/ncr_formal_uniform
	name = "NCR pre-war uniform"
	desc = "An old pre-war uniform repurposed for the NCR armed forces"
	icon_state = "us_uniform"
	inhand_icon_state = "us_uniform"
	//item_color = "us_uniform"

/obj/item/clothing/under/f13/ncr_camo
	name = "NCR pre-war camo"
	desc = "Old pre-war camo repurposed for the NCR armed forces"
	icon_state = "nato_uniform"
	inhand_icon_state = "nato_uniform"
	//item_color = "nato_uniform"

//chinesearmy
/obj/item/clothing/under/f13/chinese
	name = "Chinese Army uniform"
	desc = "An pre-war People's Liberation Army uniform, worn by enlisted and NCOs."
	icon_state = "chinese_solder"
	inhand_icon_state = "bl_suit"
	//item_color = "chinese_soldier"
	armor = list(BLUNT = 0, PUNCTURE = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 20, FIRE = 20, ACID = 40)

/obj/item/clothing/under/f13/chinese/officer
	name = "Chinese Army officer's uniform"
	desc = "An pre-war People's Liberation Army uniform, worn by officers."
	icon_state = "chinese_officer"
	inhand_icon_state = "bl_suit"
	//item_color = "chinese_officer"
	armor = list(BLUNT = 0, PUNCTURE = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 20, FIRE = 20, ACID = 40)

/obj/item/clothing/under/f13/chinese/general
	name = "Chinese Army general's uniform"
	desc = "An pre-war People's Liberation Army uniform, worn by generals."
	icon_state = "chinese_general"
	inhand_icon_state = "bl_suit"
	//item_color = "chinese_general"
	armor = list(BLUNT = 0, PUNCTURE = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 20, FIRE = 20, ACID = 40)

//Prom Dress

/obj/item/clothing/under/f13/prom_dress
	name = "purple prom dress"
	desc = "This purple dress has miraculously survived the war, and seems mostly undamaged, except for a few loose ends from wear and tear. The dress is made from a soft fabric, likely a marbled velvet."
	icon_state = "promdress"
	inhand_icon_state = "promdress"
	//item_color = "promdress"

//Dust Devils

//Boomers

//Bright Brotherhood

//Nightkin Gang

//The Chairmen

//Greasers

//Maud's Muggers

//Jackals

//Powder Gangers

//White Legs

//Dead Horses

//The Kings

//Mutant Band

//Remnants

/obj/item/clothing/under/f13/enclave_officer
	name = "enclave officer uniform"
	desc = "A standard Enclave officer uniform.<br>The outer layer is made of a sturdy material designed to withstand the harsh conditions of the wasteland."
	icon_state = "enclave_o"
	inhand_icon_state = "bl_suit"
	//item_color = "enclave_o"
	armor = list(BLUNT = 0, PUNCTURE = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 20, FIRE = 20, ACID = 40)

/obj/item/clothing/under/f13/navy
	name = "navy jumpsuit"
	desc = "Pre-War standard naval uniform."
	icon_state = "navy"
	inhand_icon_state = "bl_suit"
	//item_color = "navy"

/obj/item/clothing/under/f13/navyofficer
	name = "navy officer jumpsuit"
	desc = "Pre-War standard naval uniform for ranked officers."
	icon_state = "navyofficer"
	inhand_icon_state = "bl_suit"
	//item_color = "navyofficer"

/obj/item/clothing/under/f13/machinist
	name = "workman outfit"
	desc = "The apparel of an old-time machinist."
	icon_state = "machinist"
	inhand_icon_state = "lb_suit"
	//item_color = "machinist"
	armor = list(BLUNT = 0, PUNCTURE = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 20, FIRE = 20, ACID = 40)

/obj/item/clothing/under/f13/lumberjack
	name = "lumberjack outfit"
	desc = "The apparel of an old-time lumberjack."
	icon_state = "lumberjack"
	inhand_icon_state = "r_suit"
	//item_color = "lumberjack"

/obj/item/clothing/under/f13/police
	name = "police uniform"
	desc = "You have the right to remain violent."
	icon_state = "retro_police"
	inhand_icon_state = "b_suit"
	//item_color = "retro_police"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	armor = list(BLUNT = 0, PUNCTURE = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 10, FIRE = 10, ACID = 40)

/obj/item/clothing/under/f13/cowboyt //Originally cowboy and mafia stuff by Nienhaus
	name = "dusty prospector outfit"
	desc = "A white shirt with shiny brass buttons and a pair of tan trousers, commonly worn by prospectors."
	icon_state = "cowboyt"
	inhand_icon_state = "det"
	//item_color = "cowboyt"
	armor = list(BLUNT = 0, PUNCTURE = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 20, FIRE = 20, ACID = 40)

/obj/item/clothing/under/f13/cowboyb
	name = "sleek prospector outfit"
	desc = "A white shirt with brass buttons and a pair of brown trousers, commonly worn by prospectors."
	icon_state = "cowboyb"
	inhand_icon_state = "det"
	armor = list(BLUNT = 0, PUNCTURE = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 20, FIRE = 20, ACID = 40)

/obj/item/clothing/under/f13/cowboyg
	name = "well-heeled prospector outfit"
	desc = "A white shirt with black buttons and a pair of gray trousers, commonly worn by prospectors."
	icon_state = "cowboyg"
	inhand_icon_state = "sl_suit"
	//item_color = "cowboyg"
	armor = list(BLUNT = 0, PUNCTURE = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 20, FIRE = 20, ACID = 40)

/obj/item/clothing/under/f13/female/flapper
	name = "flapper dress"
	desc = "An outfit commonly worn by old-time prostitutes from around New Reno, but can be seen all over the wasteland."
	icon_state = "flapper"
	inhand_icon_state = "gy_suit"
	//item_color = "flapper"

/obj/item/clothing/under/f13/bdu //WalterJe military standarts.
	name = "battle dress uniform"
	desc = "A standard military Battle Dress Uniform."
	icon_state = "bdu"
	inhand_icon_state = "xenos_suit"
	//item_color = "bdu"
	can_adjust = TRUE

/obj/item/clothing/under/f13/dbdu
	name = "desert battle dress uniform"
	desc = "A military Desert Battle Dress Uniform."
	icon_state = "dbdu"
	inhand_icon_state = "brownjsuit"
	//item_color = "dbdu"
	armor = list(BLUNT = 0, PUNCTURE = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 20, FIRE = 20, ACID = 40)
	can_adjust = TRUE

/obj/item/clothing/under/f13/shiny //Firefly, yay!
	name = "shiny outfit"
	desc = "The perfect outfit for a brave and reckless space cowboy. Shiny!"
	icon_state = "shiny"
	inhand_icon_state = "owl"
	//item_color = "shiny"

/obj/item/clothing/under/f13/batter //I guess we're going OFF limits.
	name = "worn baseball uniform"
	desc = "<b>Purification in progress...</b>"
	icon_state = "batter"
	inhand_icon_state = "w_suit"
	//item_color = "batter"

/obj/item/clothing/under/f13/bennys //Benny's suit from Fallout: New Vegas. But Benny was just a kid back in 2255, so it's just a fancy suit for you.
	name = "fancy suit"
	desc = "A black and white buffalo plaid suit. Fancy!"
	icon_state = "benny"
	inhand_icon_state = "white_suit"
	//item_color = "benny"

/obj/item/clothing/under/f13/relaxedwear
	name = "pre-war male relaxedwear"
	desc = "A dirty long-sleeve blue shirt with a greenish brown sweater-vest and slacks."
	icon_state = "relaxedwear_m"
	inhand_icon_state = "g_suit"
	//item_color = "relaxedwear_m"

/obj/item/clothing/under/f13/spring
	name = "pre-war male spring outfit"
	desc = "A dirty long-sleeve beige shirt with a red sweater-vest and brown trousers."
	icon_state = "spring_m"
	inhand_icon_state = "brownjsuit"
	//item_color = "spring_m"

/obj/item/clothing/under/f13/formal
	name = "pre-war male formal wear"
	desc = "A black jacket with an old white shirt and dirty dark purple trousers.<br>Traditionally worn by the richest of the post-War world."
	icon_state = "formal_m"
	inhand_icon_state = "judge"
	//item_color = "formal_m"

/obj/item/clothing/under/f13/bodyguard
	name = "bodyguard outfit"
	desc = "A grimy pair of pre-War slacks, tie, and a dress shirt with some makeshift pauldrons made of scrap metal attached with leather straps."
	icon_state = "bodyguard"
	inhand_icon_state = "sl_suit"
	//item_color = "bodyguard"

/obj/item/clothing/under/f13/westender
	name = "classic tender outfit"
	desc = "A refined bartenders suit, adorned with a classic frontiersmen western tie."
	icon_state = "westender"
	inhand_icon_state = "sl_suit"
	//item_color = "westender"

/obj/item/clothing/under/f13/rag
	name = "torn rags"
	desc = "Keeps the sand outta yer crack, and not much else."
	icon_state = "rag"
	inhand_icon_state = "lgloves"
	//item_color = "rag"
	can_adjust = 0

/obj/item/clothing/under/f13/tribal
	name = "male tribal outfit"
	desc = "Clothes made from gecko hide. Oh, so like, this is what that Darwin guy meant by, like, survival of the fittest?"
	icon_state = "tribal_m"
	inhand_icon_state = "lgloves"
	//item_color = "tribal_m"
	can_adjust = TRUE

/obj/item/clothing/under/f13/female/tribal
	name = "female tribal outfit"
	desc = "Clothes made from gecko hide. Oh, so like, this is what that Darwin guy meant by, like, survival of the fittest?"
	icon_state = "tribal_f"
	inhand_icon_state = "lgloves"
	//item_color = "tribal_f"
	can_adjust = TRUE
	fitted = NO_FEMALE_UNIFORM

/obj/item/clothing/under/f13/settler
	name = "settler outfit"
	desc = "A more or less a crudely made tan robe with a makeshift belt made from cloth.<br>Paired with worn grey pants."
	icon_state = "settler"
	inhand_icon_state = "brownjsuit"
	//item_color = "settler"
	armor = list(BLUNT = 0, PUNCTURE = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 20, FIRE = 20, ACID = 40)

/obj/item/clothing/under/f13/brahmin //Male version
	name = "male brahmin-skin outfit"
	desc = "A basic male outfit consisting of a white shirt and patched trousers with Y-shaped suspenders."
	icon_state = "brahmin_m"
	inhand_icon_state = "brownjsuit"
	//item_color = "brahmin_m"

/obj/item/clothing/under/f13/female/brahmin //Female version
	name = "female brahmin-skin outfit"
	desc = "A basic female outfit consisting of a rolled-up long-sleeve shirt and patched trousers with Y-shaped suspenders.<br>Fitted for female wastelanders."
	icon_state = "brahmin_f"
	inhand_icon_state = "brownjsuit"
	//item_color = "brahmin_f"

/obj/item/clothing/under/f13/doctor //Male version
	name = "male doctor fatigues"
	desc = "A white t-shirt, a small brown satchel bag and brown trousers with pouches attached to the belt.<br>Fitted for male wastelanders."
	icon_state = "doctor_m"
	inhand_icon_state = "brownjsuit"
	//item_color = "doctor_m"
	armor = list(BLUNT = 0, PUNCTURE = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 20, FIRE = 20, ACID = 40)

/obj/item/clothing/under/f13/female/doctor //Female version
	name = "female doctor fatigues"
	desc = "A white t-shirt with brown trousers, and a small brown satchel bag attached to it.<br>Fitted for female wastelanders."
	icon_state = "doctor_f"
	inhand_icon_state = "brownjsuit"
	//item_color = "doctor_f"
	fitted = NO_FEMALE_UNIFORM

/obj/item/clothing/under/f13/mercadv //Male version
	name = "male merc adventurer outfit"
	desc = "A large leather jacket with torn-off sleeves, paired with a red sweater, a necklace with three teeth of unknown origin strung on, and a pair of brown leather pants.<br>There is also a rough leather bandolier for additional storage capacity.<br>Fitted for male wastelanders."
	icon_state = "merca_m"
	inhand_icon_state = "bl_suit"
	//item_color = "merca_m"
	armor = list(BLUNT = 0, PUNCTURE = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 20, FIRE = 20, ACID = 40)

/obj/item/clothing/under/f13/female/mercadv //Female version
	name = "female merc adventurer outfit"
	desc = "A large leather jacket with torn-off sleeves, paired with a midriff-revealing red and black top and a pair of brown leather pants.<br>There is also a rough leather bandolier and belt for additional storage capacity.<br>Fitted for female wastelanders."
	icon_state = "merca_f"
	inhand_icon_state = "bl_suit"
	//item_color = "merca_f"
	fitted = NO_FEMALE_UNIFORM

/obj/item/clothing/under/f13/merccharm //Male version
	name = "male merc charmer outfit"
	desc = "A blue and gray outfit resembling a three piece suit, heavily stitched and reinforced with a small metal cup on the groin area.<br>Fitted for male wastelanders."
	icon_state = "mercc_m"
	inhand_icon_state = "mercc_f"
	//item_color = "mercc_m"
	armor = list(BLUNT = 0, PUNCTURE = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 20, FIRE = 20, ACID = 40)

/obj/item/clothing/under/f13/mechanic
	name = "worn blue jumpsuit"
	desc = "A worn jumpsuit, made of soft-blue colored cloth, with old machine oil stains on it.<br>Long time ago it could have belonged to a repair mechanic."
	icon_state = "mechanic"
	inhand_icon_state = "syndicate-blue"
	//item_color = "mechanic"
	armor = list(BLUNT = 0, PUNCTURE = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 20, FIRE = 20, ACID = 40)

/obj/item/clothing/under/f13/petrochico
	name = "worn green jumpsuit"
	desc = "A dark green colored jumpsuit, with white lines on its sleeves and a Petro-Chico patch sewn on the right breast."
	icon_state = "petrochico"
	inhand_icon_state = "centcom"
	//item_color = "petrochico"
	armor = list(BLUNT = 0, PUNCTURE = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 20, FIRE = 20, ACID = 40)

/obj/item/clothing/under/f13/caravaneer
	name = "caravaneer outift"
	desc = "A striped brown shirt, with a pair of dark blue pants on suspenders.<br>That type of outfit is commonly worn by caravaneers and travelers."
	icon_state = "caravaneer"
	inhand_icon_state = "syndicate-blue"
	//item_color = "caravaneer"
	armor = list(BLUNT = 0, PUNCTURE = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 10, FIRE = 10, ACID = 40)

/obj/item/clothing/under/f13/merchant
	name = "merchant outfit "
	desc = "An outfit commonly worn by various wastelanders - mostly wandering traders and merchants on the market.<br>So what do you say if I buy it from you with 10% discount?"
	icon_state = "merchant"
	inhand_icon_state = "brownjsuit"
	//item_color = "merchant"
	armor = list(BLUNT = 0, PUNCTURE = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 20, FIRE = 20, ACID = 40)

/obj/item/clothing/under/f13/worn
	name = "worn outfit "
	desc = "A worn khaki shirt without any buttons left, and a ragged pair of jeans.<br>It may seem a bad outfit choice at first, yet there are wastelanders out there who can't afford even that."
	icon_state = "worn"
	inhand_icon_state = "brownjsuit"
	//item_color = "worn"

/obj/item/clothing/under/f13/vault
	name = "vault jumpsuit"
	desc = "The regulation clothing worn by the vault dwellers of Vault-Tec vaults. It's made of sturdy leather.<br>This particular jumpsuit has no number on the back."
	icon_state = "vault"
	inhand_icon_state = "b_suit"
	//item_color = "vault"
	can_adjust = TRUE
	armor = list(BLUNT = 0, PUNCTURE = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 10, RAD = 30, FIRE = 30, ACID = 40)

/obj/item/clothing/under/f13/vault/v13 //The Legend is here.
	name = "Vault 13 jumpsuit"
	desc = "The regulation clothing worn by the vault dwellers of Vault-Tec vaults. It's made of sturdy leather.<br>This jumpsuit has number 13 on the back."
	icon_state = "vault13"
	//item_color = "vault13"

/obj/item/clothing/under/f13/vault/v113
	name = "Vault 113 jumpsuit"
	desc = "The regulation clothing worn by the vault dwellers of Vault-Tec vaults. It's made of sturdy leather.<br>This jumpsuit has number 113 on the back."
	icon_state = "vault113"
	//item_color = "vault113"

/obj/item/clothing/under/f13/vault/v21
	name = "Vault 21 jumpsuit"
	desc = "The regulation clothing worn by the vault dwellers of Vault-Tec vaults. It's made of sturdy leather.<br>This jumpsuit has number 21 on the back."
	icon_state = "vault21"
	//item_color = "vault21"

/obj/item/clothing/under/f13/vault/v42
	name = "Vault 42 jumpsuit"
	desc = "The regulation clothing worn by the vault dwellers, of Vault-Tec vaults built to solve the Ultimate Question of life, Universe, and everything. It's made of sturdy leather.<br>This jumpsuit has number 42 on the back."
	icon_state = "vault42"
	//item_color = "vault42"

/obj/item/clothing/under/f13/vault/vcity
	name = "VTCC jumpsuit"
	desc = "The regulation clothing worn by the vault dwellers, of Vault-Tec vaults. It's made of sturdy leather. <br>This jumpsuit bears the symbol of the Vault-Tec City Coalition on the back."
	icon_state = "vaultcity"
	inhand_icon_state = "vaultcity"

/obj/item/clothing/under/f13/vault/vcity/skirt
	name = "VTCC jumpskirt"
	icon_state = "vaultcity_skirt"
	inhand_icon_state = "vaultcity_skirt"

/obj/item/clothing/under/f13/followers
	name = "followers outfit"
	desc = "A white shirt with a pair of dark brown cargo pants - an outfit commonly worn by Followers of the Apocalypse.<br><i>Nihil boni sine labore.</i>"
	icon_state = "followers"
	inhand_icon_state = "bar_suit"
	//item_color = "followers"
	armor = list(BLUNT = 0, PUNCTURE = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 20, FIRE = 20, ACID = 40)

/obj/item/clothing/under/f13/combat
	name = "combat uniform"
	desc = "An ancient combat uniform, that went out of use around the time of the Great War."
	icon_state = "combat"
	inhand_icon_state = "bl_suit"
	//item_color = "combat"
	armor = list(BLUNT = 0, PUNCTURE = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 20, FIRE = 20, ACID = 40)

/obj/item/clothing/under/f13/gunner
	name = "gunner combat uniform"
	desc = "An ancient combat uniform, that went out of use around the time of the Great War. it has scratch marks and a skull painted on it to symbolize that its part of the gunners"
	icon_state = "GunnerPlates"
	inhand_icon_state = "GunnerPlates"
	//item_color = "GunnerPlates"
	armor = list(BLUNT = 0, PUNCTURE = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 20, FIRE = 20, ACID = 40)

/obj/item/clothing/under/f13/combat/militia
	name = "ODF fatigues"
	desc = "An olive-green combat uniform, issued to members of the Oasis Defense Force."

/obj/item/clothing/under/f13/enclave_officer
	name = "officer uniform"
	desc = "A standard Enclave officer uniform.<br>The outer layer is made of a sturdy material designed to withstand the harsh conditions of the wasteland."
	icon_state = "enclave_o"
	inhand_icon_state = "bl_suit"
	//item_color = "enclave_o"
	armor = list(BLUNT = 0, PUNCTURE = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 20, FIRE = 20, ACID = 40)

/obj/item/clothing/under/f13/ncr/torn
	name = "torn overcoat"
	desc = "Some time ago it looked like a regular NCR uniform, but now it looks like a total mess of ripped cloth."
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0, fire = 0, acid = 0)
	icon_state = "tornovercoat"
	//item_color = "tornovercoat"

/obj/item/clothing/under/f13/general
	name = "general overcoat"
	desc = "A grim looking overcoat - preferable standard for General commander of New California Republic.<br>It's decorated with golden stars, and an insignia plaque that adorns the left side."
	icon_state = "general"
	inhand_icon_state = "lb_suit"
	//item_color = "general"
	armor = list(BLUNT = 0, PUNCTURE = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 20, FIRE = 40, ACID = 40)

/obj/item/clothing/under/f13/recon
	name = "recon armor"
	desc = "Intended to serve as the under-armor of the T-45d power armor, the recon armor is a vacuum-sealed asbestos jumpsuit covering the entire body.<br>Attached to it is the interface and mounts for the power armor.<br>Its purpose is twofold - it allows the user to actually operate the armor and protect soft tissue from moving parts inside the suit and heat."
	icon_state = "recon"
	inhand_icon_state = "rig_suit"
	//item_color = "recon"
	flags_inv = HIDEHAIR
	armor = list(BLUNT = 0, PUNCTURE = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 30, FIRE = 30, ACID = 40)
	cold_protection = CHEST|GROIN|LEGS|FEET|ARMS|HEAD
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HEAD

//Fluff

/obj/item/clothing/under/f13/agent47
	name = "mysterious suit"
	desc = "This dark suit was made by a blind man named Tommy, who ran a tailor shop in the ruins of Old Chicago.<br>It seems to be reinforced with an unknown material."
	icon_state = "agent47"
	inhand_icon_state = "lawyer_black"
	//item_color = "agent47"

/obj/item/clothing/under/f13/psychologist
	name = "psychologist's turtleneck"
	desc = "A turqouise turtleneck and a pair of dark blue slacks, belonging to a psychologist."
	icon_state = "psychturtle"
	inhand_icon_state = "b_suit"
	//item_color = "psychturtle"
/obj/item/clothing/under/f13/villain //Doubles as Gang Leader primary uniform for extra villainy
	name = "green and black suit"
	desc = "There is something evil in this suit, only a villain would wear something like that."
	icon_state = "villain"
	inhand_icon_state = "syndicate-green"
	//item_color = "villain"

/obj/item/clothing/under/f13/gentlesuit
	name = "gentlemans suit"
	desc = "A silk black shirt with a white tie and a matching gray vest and slacks. Feels proper."
	icon_state = "gentlesuit"
	inhand_icon_state = "gy_suit"
	//item_color = "gentlesuit"

/obj/item/clothing/under/f13/detectivealt
	name = "fancy detective suit"
	desc = "An immaculate white dress shirt, paired with a pair of fancy black dress pants, a red tie, and a charcoal vest."
	icon_state = "detectivealt"
	inhand_icon_state = "bl_suit"
	//item_color = "detectivealt"
	can_adjust = TRUE

/obj/item/clothing/under/f13/hopalt
	name = "head of personnel's suit"
	desc = "A blue jacket and red tie, with matching red cuffs! Snazzy. Wearing this makes you feel more important than your job title does."
	icon_state = "hopalt"
	inhand_icon_state = "b_suit"
	//item_color = "hopalt"

/obj/item/clothing/under/f13/roboticistalt
	name = "roboticist's jumpsuit"
	desc = "A slimming black with bright reinforced orange seams; great for industrial work."
	icon_state = "roboticsalt"
	inhand_icon_state = "jensensuit"
	//item_color = "roboticsalt"
	can_adjust = TRUE

/obj/item/clothing/under/f13/bartenderalt
	name = "fancy bartender's uniform"
	desc = "A rather fancy uniform for a real professional."
	icon_state = "barmanalt"
	inhand_icon_state = "bl_suit"
	//item_color = "barmanalt"

/obj/item/clothing/under/f13/spaceship
	name = "crewman uniform"
	desc = "The insignia on this uniform tells you that this uniform belongs to some sort of crewman."
	icon_state = "spaceship_crewman"
	inhand_icon_state = "syndicate-black-red"
	//item_color = "spaceship_crewman"

/obj/item/clothing/under/f13/spaceship/officer
	name = "officer uniform"
	desc = "The insignia on this uniform tells you that this uniform belongs to some sort of officer."
	icon_state = "spaceship_officer"
	//item_color = "spaceship_officer"

/obj/item/clothing/under/f13/spaceship/captain
	name = "captain uniform"
	desc = "The insignia on this uniform tells you that this uniform belongs to some sort of captain."
	icon_state = "spaceship_captain"
	//item_color = "spaceship_captain"

//Female clothing! It's not misogyny, yet dresses shall be separate from /f13/ as Fallout build has its own female subtype.

/obj/item/clothing/under/pants/f13/ghoul
	name = "ripped pants"
	desc = "A pair of ripped pants that were not washed for over a hundred years.<br>Thanks to these you don't get to see ghouls genitals too often.<br><i>You can also wear these, to pretend you are a feral ghoul, just saying...</i>"
	icon_state = "ghoul"
	//item_color = "ghoul"

/obj/item/clothing/under/pants/f13/cloth
	name = "cloth pants"
	desc = "A pair of worn dusty cloth pants made of various textile pieces.<br>Commonly found all over the wasteland."
	icon_state = "cloth"
	//item_color = "cloth"

/obj/item/clothing/under/pants/f13/caravan //Caravanner - someone who travels with caravan. Caravaneer - caravan leader.
	name = "caravanner pants"
	desc = "A pair of wide dusty cargo pants.<br>Commonly worn by caravanners or caravan robbers."
	icon_state = "caravan"
	//item_color = "caravan"

/obj/item/clothing/under/pants/f13/khan
	name = "Great Khan pants"
	desc = "A cloth pants with leather armor pads attached on sides.<br>These are commonly worn by the Great Khans raiders."
	icon_state = "khan"
	//item_color = "khan"
	body_parts_covered = LEGS

/obj/item/clothing/under/pants/f13/warboy //Mad Max 4 2015 babe!
	name = "war boy pants"
	desc = "A pair of dark brown pants, perfect for the one who grabs the sun, riding to Valhalla."
	icon_state = "warboy"
	//item_color = "warboy"
	body_parts_covered = LEGS

/obj/item/clothing/under/pants/f13/doom
	name = "green pants"
	desc = "An odd green pants made of synthetic material."
	icon_state = "green"
	//item_color = "green"
	resistance_flags = UNACIDABLE
	body_parts_covered = LEGS

/obj/item/clothing/under/f13/bos/fatigues
	name = "Brotherhood fatigues"
	desc = "A dry cleaned set of grey fatigues with a brown belt, commonly worn by the off-duty members of the Brotherhood of Steel."
	icon_state = "bos_fatigues"
	inhand_icon_state = "bos_fatigues"

/obj/item/clothing/under/f13/bos/bodysuit
	name = "Brotherhood Knight fatigues"
	desc = "A bodysuit worn by members of the Brotherhood of steel."
	icon_state = "bos_bodysuit"
	inhand_icon_state = "bos_bodysuit"

/obj/item/clothing/under/f13/bos/f/bodysuit
	name = "Brotherhood bodysuit"
	desc = "A bodysuit worn by members of the Brotherhood of steel."
	icon_state = "bos_bodysuit_f"
	inhand_icon_state = "bos_bodysuit_f"
	body_parts_covered = CHEST

/obj/item/clothing/under/f13/bos/bodysuit/knight
	name = "Brotherhood Knight bodysuit"
	desc = "A bodysuit worn by the Knights of the Brotherhood of steel."
	icon_state = "bos_bodysuit_navy"
	inhand_icon_state = "bos_bodysuit_navy"

/obj/item/clothing/under/f13/bos/f/bodysuit/knight
	name = "Brotherhood Knight bodysuit"
	desc = "A bodysuit worn by the Knights of the Brotherhood of steel."
	icon_state = "bos_bodysuit_navy_f"
	inhand_icon_state = "bos_bodysuit_navy_f"

/obj/item/clothing/under/f13/bos/bodysuit/scribe
	name = "Brotherhood Scribe bodysuit"
	desc = "A bodysuit worn by the Scribes of the Brotherhood of steel."
	icon_state = "bos_bodysuit_red"
	inhand_icon_state = "bos_bodysuit_red"

/obj/item/clothing/under/f13/bos/f/bodysuit/scribe
	name = "Brotherhood Scribe bodysuit"
	desc = "A bodysuit worn by the Scribes of the Brotherhood of steel."
	icon_state = "bos_bodysuit_red_f"
	inhand_icon_state = "bos_bodysuit_red_f"

/obj/item/clothing/under/f13/bos/bodysuit/paladin
	name = "Brotherhood Paladin bodysuit"
	desc = "A bodysuit worn by the Paladins of the Brotherhood of steel."
	icon_state = "bos_bodysuit_grey"
	inhand_icon_state = "bos_bodysuit_grey"

/obj/item/clothing/under/f13/bos/f/bodysuit/paladin
	name = "Brotherhood Scribe bodysuit"
	desc = "A bodysuit worn by the Paladins of the Brotherhood of steel."
	icon_state = "bos_bodysuit_grey_f"
	inhand_icon_state = "bos_bodysuit_grey_f"

/obj/item/clothing/under/f13/bosform_f
	name = "female initiate service uniform"
	desc = "A dry-cleaned and fitted formal uniform of the Brotherhood of Steel, for special occasions. This one has no markings, and looks to be for a feminine person."
	icon_state = "bosform_f"
	inhand_icon_state = "bosform_f"
	//item_color = "bosform_f"

/obj/item/clothing/under/f13/bosform_m
	name = "male initiate service uniform"
	desc = "A dry-cleaned and fitted formal uniform of the Brotherhood of Steel, for special occasions. This one has no markings, and looks to be for a masculine person."
	icon_state = "bosform_m"
	inhand_icon_state = "bosform_m"
	//item_color = "bosform_m"

/obj/item/clothing/under/f13/bosformsilver_f
	name = "female brotherhood service uniform"
	desc = "A dry-cleaned and fitted formal uniform of the Brotherhood of Steel, for special occasions. This one bears a silver chain, and looks to be for a feminine person."
	icon_state = "bosformsilver_f"
	inhand_icon_state = "bosformsilver_f"
	//item_color = "bosformsilver_f"

/obj/item/clothing/under/f13/bosformsilver_m
	name = "male brotherhood service uniform"
	desc = "A dry-cleaned and fitted formal uniform of the Brotherhood of Steel, for special occasions. This one bears a silver chain, and looks to be for a masculine person."
	icon_state = "bosformsilver_m"
	inhand_icon_state = "bosformsilver_m"
	//item_color = "bosformsilver_m"

/obj/item/clothing/under/f13/bosformgold_f
	name = "female ranking service uniform"
	desc = "A dry-cleaned and fitted formal uniform of the Brotherhood of Steel, for special occasions. This one bears a gold chain; denoting authority, and looks to be for a feminine person."
	icon_state = "bosformgold_f"
	inhand_icon_state = "bosformgold_f"
	//item_color = "bosformgold_f"

/obj/item/clothing/under/f13/bosformgold_m
	name = "male ranking service uniform"
	desc = "A dry-cleaned and fitted formal uniform of the Brotherhood of Steel, for special occasions. This one bears a gold chain; denoting authority, and looks to be for a masculine person."
	icon_state = "bosformgold_m"
	inhand_icon_state = "bosformgold_m"
	//item_color = "bosformgold_m"

/obj/item/clothing/under/f13/atomfaithful
	name = "faithful attire"
	desc = "The attire worn by those Faithful to the Division."
	icon_state = "atomfaithful"
	inhand_icon_state = "atomfaithful"
	//item_color = "atomfaithful"
	armor = list(BLUNT = 0, PUNCTURE = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 100, FIRE = 20, ACID = 40)


/obj/item/clothing/under/f13/atomwitchunder
	name = "seers underclothes"
	desc = "The underclothes of the female seers of the Division."
	icon_state = "atomwitchunder"
	inhand_icon_state = "atomwitchunder"
	//item_color = "atomwitchunder"
	armor = list(BLUNT = 0, PUNCTURE = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 100, FIRE = 20, ACID = 40)


/obj/item/clothing/under/f13/atombeliever
	name = "believer clothes"
	desc = "The clothes of a true Believer in the Division."
	icon_state = "atombeliever"
	inhand_icon_state = "atombeliever"
	//item_color = "atombeliever"
	armor = list(BLUNT = 0, PUNCTURE = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 100, FIRE = 20, ACID = 40)


/obj/item/clothing/under/f13/raiderharness
	name = "raider harness"
	desc = "A leather harness that barely covered the essentials."
	icon_state = "raiderharness"
	inhand_icon_state = "raiderharness"
	//item_color = "raiderharness"

/obj/item/clothing/under/f13/fprostitute
	name = "feminine prostitute outfit"
	desc = "A latex outfit for someone who sells their companionship. Or really likes the breeze."
	icon_state = "fprostitute"
	inhand_icon_state = "fprostitute"
	//item_color = "fprostitute"

/obj/item/clothing/under/f13/mprostitute
	name = "masculine prostitute outfit"
	desc = "A latex outfit for someone who sells their companionship. Or really likes the breeze."
	icon_state = "mprostitute"
	inhand_icon_state = "mprostitute"
	//item_color = "mprostitute"

/obj/item/clothing/under/f13/ravenharness
	name = "raven harness"
	desc = "A harness made out of a number of black belts sewn together end on end to form a coiling piece of clothing. A symbol in red has been painted on the front, and a pair of hide pants go with it."
	icon_state = "raven_harness"
	inhand_icon_state = "raven_harness"

/obj/item/clothing/under/f13/ravenharness
	name = "raven harness"
	desc = "A harness made out of a number of black belts sewn together end on end to form a coiling piece of clothing. A symbol in red has been painted on the front, and a pair of hide pants go with it."
	icon_state = "raven_harness"
	inhand_icon_state = "raven_harness"

/obj/item/clothing/under/f13/jamrock
	name = "Disco-Ass Shirt and Pants"
	desc = "This white satin shirt used to be fancy. It used to really catch the light. Now it smells like someone took a piss in the armpits while the golden brown trousers are flare-cut. Normal bell-bottom trousers would be boot-cut, but these are far from normal. They are someone's piss-soaked, cum-stained party pants."
	icon_state = "jamrock_uniform"
	inhand_icon_state = "jamrock_uniform"

/obj/item/clothing/under/f13/keksweater
	name = "Red Sweater"
	desc = "A dark red-sweater with some cargo-pants. Perfect for when it just gets too cold down in local air-conditioned areas."
	icon_state = "brahminsss"
	inhand_icon_state = "brahminsss"

/obj/item/clothing/under/f13/locust
	name = "locust uniform"
	desc = "An ancient pre-war army combat uniform. In use by the locust mercenaries."
	icon_state = "locust"
	inhand_icon_state = "locust"
	armor = list(BLUNT = 0, PUNCTURE = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 20, FIRE = 20, ACID = 40)

/obj/item/clothing/under/f13/gunner
	name = "gunner combat uniform"
	desc = "An ancient combat uniform, that went out of use around the time of the Great War. it has scratch marks and a skull painted on it to symbolize that its part of the gunners"
	icon_state = "GunnerPlates"
	inhand_icon_state = "GunnerPlates"
	armor = list(BLUNT = 0, PUNCTURE = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 20, FIRE = 20, ACID = 40)

/obj/item/clothing/under/f13/marlowduds
	name = "Marlow gang attire"
	desc = "A washed out crimson overshirt with blue neckerchief and suspended black slacks. The attire is synonymous with the colors of the criminal Marlow gang."
	icon_state = "marlowduds"
	inhand_icon_state = "marlowduds"
	can_adjust = TRUE

/obj/item/clothing/under/f13/ikeduds
	name = "gunfighter's gang attire"
	desc = "A washed out crimson overshirt with blue neckerchief and raw buckskin trousers. The attire is synonymous with the colors of the criminal Marlow gang."
	icon_state = "ikeduds"
	inhand_icon_state = "ikeduds"
	can_adjust = TRUE

/obj/item/clothing/under/f13/helenduds
	name = "gambler's gang attire"
	desc = "A worn black dress shirt under a deep crimson vest with blue neckerchief and suspended black slacks. The attire is synonymous with the colors of the criminal Marlow gang."
	icon_state = "helenduds"
	inhand_icon_state = "helenduds"
	can_adjust = TRUE

/obj/item/clothing/under/f13/masonduds
	name = "vagabond's gang attire"
	desc = "A pair of worn buckskin trousers held up by a heavy pistol belt. The attire is synonymous with the colors of the criminal Marlow gang."
	icon_state = "masonduds"
	inhand_icon_state = "masonduds"

//Super Mutants

/obj/item/clothing/under/f13/mutieshorts
	name = "large torn shorts"
	desc = "An incredibly damaged pair of shorts, large enough to fit a super mutant."
	icon_state = "mutie_shorts"
	inhand_icon_state = "mutie_shorts"

/obj/item/clothing/under/f13/mutiesanta
	name = "red and white jumspuit"
	desc = "A fairly damaged red and white shirt with matching shorts, large enough to fit a super mutant."
	icon_state = "mutie_santa"
	inhand_icon_state = "mutie_santa"

/obj/item/clothing/under/f13/vaultmutie
	name = "torn vault 113 jumpsuit"
	desc = "Once, it was a blue jumpsuit with a yellow vault pattern and the number 11 printed on it, now torn and ripped."
	icon_state = "mutie_vault_jumspuit"
	inhand_icon_state = "mutie_vault_jumspuit"

/obj/item/clothing/under/f13/mutieranger
	name = "mutant ranger clothing"
	desc = "Specially made for Super Mutants living in the NCR, this large piece of clothing is well pressed and suited for any NCR Super Mutant personnel"
	icon_state = "mutie_ranger_under"
	inhand_icon_state = "mutie_ranger_under"

/obj/item/clothing/under/f13/desert_ranger_scout
	name = "desert ranger scouting uniform"
	desc = "A set of clothing worn by desert ranger scouts."
	icon_state = "scoutclothes"
	can_adjust = FALSE
	inhand_icon_state = "scoutclothes"
	//item_color = "scoutclothes"
	armor = list(BLUNT = 0, PUNCTURE = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 30, FIRE = 20, ACID = 50)

/obj/item/clothing/under/f13/densuit
	name = "the den outfit"
	desc = "A dark grey, and finely pressed suit, complete with kneepads and a suspiciously golden silk shirt, only the best."
	icon_state = "den_suit"
	inhand_icon_state = "den_suit"
