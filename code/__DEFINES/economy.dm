/// How much mail the Economy SS will create per minute, regardless of firing time.
#define MAX_MAIL_PER_MINUTE 0.05
/// Probability of using letters of envelope sprites on all letters.
#define FULL_CRATE_LETTER_ODDS 70


/// The baseline cost for basically everything in the game
#define PAYCHECK_ASSISTANT 10

#define PAYCHECK_MINIMAL (PAYCHECK_ASSISTANT * 2)
#define PAYCHECK_EASY (PAYCHECK_ASSISTANT * 2.5)
#define PAYCHECK_MEDIUM (PAYCHECK_ASSISTANT * 4)
#define PAYCHECK_HARD (PAYCHECK_ASSISTANT * 7)
#define PAYCHECK_COMMAND (PAYCHECK_ASSISTANT * 20)

#define PAYCHECK_ZERO 0

//A multiplier for when you buy from your department.
#define VENDING_DISCOUNT 0

#define ACCOUNT_ENG "ENG"
#define ACCOUNT_ENG_NAME "Daedalus Industries Funds"
#define ACCOUNT_MED "MED"
#define ACCOUNT_MED_NAME "Aether Pharmaceuticals Funds"
#define ACCOUNT_SRV "SRV"
#define ACCOUNT_CAR "CAR"
#define ACCOUNT_CAR_NAME "Hermes Galactic Freight Funds"
#define ACCOUNT_SEC "SEC"
#define ACCOUNT_SEC_NAME "Mars People's Coalition Budget"

#define ACCOUNT_STATION_MASTER "STA"
#define ACCOUNT_STATION_MASTER_NAME "Station Budget"

#define ACCOUNT_GOV "GOV"
#define ACCOUNT_GOV_NAME "Special Order Budget"

#define NO_FREEBIES "commies go home"

//By how much should the station's inflation value be multiplied by when dividing the civilian bounty's reward?
#define BOUNTY_MULTIPLIER 10

//These defines are to be used to with the payment component, determines which lines will be used during a transaction. If in doubt, go with clinical.
#define PAYMENT_CLINICAL "clinical"
#define PAYMENT_FRIENDLY "friendly"
#define PAYMENT_ANGRY "angry"
