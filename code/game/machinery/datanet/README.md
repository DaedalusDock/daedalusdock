# Data Networks, or: Why the OSI Model is for Pussies


## Important Variables

### Data
These are the basic entries in a signal's data list, which are required for standard network transport.

`s_addr` - Source Address, the ID of the machine that transmitted the packet.
`d_addr` - Destination Address, who are we sending this to, `PING` has special behaviour.
`command` - Command, a general purpose field that is usually the 'type' of data being transmitted.

Example:

```json
{
	"s_addr":00000001, // We are being sent by device 1 
	"d_addr":00000002, // intended for device 2
	"command":"do_thing", // and we want them to "do_thing"
	"other_fields":"Are implimentation specific."
}
