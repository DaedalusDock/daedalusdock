#define PERIPHERAL_TYPE_WIRELESS_CARD "WNET_ADAPTER"
#define PERIPHERAL_TYPE_CARD_READER "ID_SCANNER"
#define PERIPHERAL_TYPE_PRINTER "LAR_PRINTER"

// See proc/peripheral_input
#define PERIPHERAL_CMD_RECEIVE_PACKET "receive_packet"
#define PERIPHERAL_CMD_SCAN_CARD "scan_card"

// MedTrak menus
#define MEDTRAK_MENU_HOME 1
#define MEDTRAK_MENU_INDEX 2
#define MEDTRAK_MENU_RECORD 3
#define MEDTRAK_MENU_COMMENTS 4

// directMAN menus
#define DIRECTMAN_MENU_HOME 1
#define DIRECTMAN_MENU_CURRENT 2
#define DIRECTMAN_MENU_ACTIVE_DIRECTIVE 3
#define DIRECTMAN_MENU_NEW_DIRECTIVES 4
// ITS THREE IN THE MOOOOORNIN' AND YOOUUU'RE EATING ALONE
#define DIRECTMAN_MENU_NEW_DIRECTIVE 5

// Wireless card incoming filter modes
#define WIRELESS_FILTER_PROMISC 0 //! Forward all packets
#define WIRELESS_FILTER_NETADDR 1 //! Forward only bcast/unicast matched GPRS packets
#define WIRELESS_FILTER_ID_TAGS 2 //! id_tag based filtering, for non-GPRS Control.

#define WIRELESS_FILTER_MODEMAX 2 //! Max of WIRELESS_FILTER_* Defines.

// ThinkDOS //
// Well-Known Directories
#define THINKDOS_BIN_DIRECTORY "/bin"
// Constants
#define THINKDOS_MAX_COMMANDS 10 //! The maximum amount of commands
// Symbols
#define THINKDOS_SYMBOL_SEPARATOR ";" //! Lets you split stdin into distinct commands

//ANSI color helpers.

/// ANSI CSI seq `ESC [`
#define ANSI_CSI "\x1b\x5B"

/// Generate an ANSI SGR escape code dynamically.
#define ANSI_SGR(ID) "[ANSI_CSI][ID]m"
/// Internal only, Variant of `ANSI_SGR` that can const fold and stringifies literally.
#define _ANSI_SGR_CONSTFOLD(ID) (ANSI_CSI + #ID + "m")

#define ANSI_FULL_RESET _ANSI_SGR_CONSTFOLD(0)

#define ANSI_BOLD _ANSI_SGR_CONSTFOLD(1)
#define ANSI_UNBOLD _ANSI_SGR_CONSTFOLD(22)


#define ANSI_FG_RED _ANSI_SGR_CONSTFOLD(31)
#define ANSI_FG_GREEN _ANSI_SGR_CONSTFOLD(32)
#define ANSI_FG_YELLOW _ANSI_SGR_CONSTFOLD(33)
#define ANSI_FG_BLUE _ANSI_SGR_CONSTFOLD(34)
#define ANSI_FG_MAGENTA _ANSI_SGR_CONSTFOLD(35)
#define ANSI_FG_CYAN _ANSI_SGR_CONSTFOLD(36)
#define ANSI_FG_WHITE _ANSI_SGR_CONSTFOLD(37)

#define ANSI_FG_RESET _ANSI_SGR_CONSTFOLD(39)

// ANSI wrapper helpers.

// Please understand that these might have unexpected styling side effects, as ANSI isn't inherently closed like HTML.

#define ANSI_WRAP_BOLD(bolded_text) (ANSI_BOLD+bolded_text+ANSI_UNBOLD)
