```json
{
	"PKT_VERSION": 2,
	"PKT_HEAD_SOURCE_ADDR": 00000001, // We are being sent by device 1
	"PKT_HEAD_DEST_ADDR": 00000002, // intended for device 2.
	"PKT_HEAD_SOURCE_PORT": 1, // The port the packet was broadcast from.
	"PKT_HEAD_DEST_PORT": 320, // The port the packet is destined for. This is often a fixed number based on the usage.
	"PKT_HEAD_NETCLASS": "NETCLASS_ADAPTER", // The type of device describing the source.
	"PKT_HEAD_PROTOCOL": "PKT_PROTOCOL_PDP", // The protocol describing the exchange format.
	"PKT_PAYLOAD": {
		"PKT_ARG_CMD": "keepalive", // A command to give to the recieving machine, using payload as parameters.
		// Any misc. data not specified by the format.
		"impl. specific value": "true",
		"impl. specific value 2": 27
	}
}
```
