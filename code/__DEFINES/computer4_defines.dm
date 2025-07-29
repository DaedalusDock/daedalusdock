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
