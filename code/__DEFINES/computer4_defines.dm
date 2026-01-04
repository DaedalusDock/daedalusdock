#define PERIPHERAL_TYPE_WIRELESS_CARD "WNET_ADAPTER"
#define PERIPHERAL_TYPE_CARD_READER "ID_SCANNER"
#define PERIPHERAL_TYPE_PRINTER "LAR_PRINTER"

// See proc/peripheral_input
#define PERIPHERAL_CMD_RECEIVE_PACKET "receive_packet"
#define PERIPHERAL_CMD_RECEIVE_PDP_PACKET "receive_pdp_packet"
#define PERIPHERAL_CMD_SCAN_CARD "scan_card"

// Shell command macros
#define SHELL_CMD_HELP_ERROR 1 //! Could not find a command to display information about
#define SHELL_CMD_HELP_GENERIC 2 //! Generated generic help information
#define SHELL_CMD_HELP_COMMAND 3 //! Generated information about a command


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

// packMAN shit
#define PACKMAN_MODE_UNDEFINED 0
#define PACKMAN_MODE_CLIENT 1
#define PACKMAN_MODE_SERVER 2

// Wireless card incoming filter modes
#define WIRELESS_FILTER_PROMISC 0 //! Forward all packets
#define WIRELESS_FILTER_NETADDR 1 //! Forward only bcast/unicast matched GPRS packets
#define WIRELESS_FILTER_ID_TAGS 2 //! id_tag based filtering, for non-GPRS Control.

#define WIRELESS_FILTER_MODEMAX 2 //! Max of WIRELESS_FILTER_* Defines.

// PDP BindPort return values

#define PDP_BIND_FAILED_CATASTROPHIC 1 //! What the fuck did you do???
#define PDP_BIND_FAILED_CONFLICT 2 //! Port already bound?

// ThinkDOS //
// Constants
#define THINKDOS_MAX_COMMANDS 3 //! The maximum amount of commands
// Symbols
#define THINKDOS_SYMBOL_SEPARATOR ";" //! Lets you split stdin into distinct commands
