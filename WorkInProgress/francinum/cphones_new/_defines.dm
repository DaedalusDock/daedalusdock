#define NETCLASS_EXCHANGE "PNET_TELEX"
#define NETCLASS_SIPPHONE "PNET_TELSUB"

/// Ping Reply staple for telephone office identification
#define PACKET_FIELD_OFFICE_CODE "office_code"

/// data[command] 2.0
#define PACKET_FIELD_VERB "verb"

/// A high level 'group' of verbs
#define PACKET_FIELD_PROTOCOL "proto"
	#define PACKET_PROTOCOL_SIP "sip"
		// ----GENERAL----
		#define PACKET_SIP_FIELD_STATUS_CODE "status" //! SIP Response Code.
		#define PACKET_SIP_FIELD_REASON "reason" //! General reason, see RFC 3326
		#define PACKET_SIP_SEQUENCE_KEY "cseq"
		// ----REGISTRATION----
		#define PACKET_SIP_VERB_REGISTER "REGISTER"
			#define PACKET_SIP_FIELD_USER "user"
			#define PACKET_SIP_FIELD_REGISTER_SECRET "auth"
		#define PACKET_SIP_VERB_REAUTH "reauth"
			#define PACKET_SIP_FIELD_AUTH_TOKEN "auth_token"
		#define PACKET_SIP_VERB_ACKNOWLEDGE "ACK"
			//shares PACKET_SIP_FIELD_AUTH_TOKEN

		// ----CALL CONTROL----
		#define PACKET_SIP_FIELD_CALLID "call-id"
		#define PACKET_SIP_VERB_INVITE "invite"
			/// Sender
			#define PACKET_SIP_INVITE_FIELD_FROM "from"
			/// Invite recipient number.
			#define PACKET_SIP_INVITE_FIELD_TO "to"
		#define PACKET_SIP_VERB_SESSION "session"
			#define PACKET_SIP_SESSION_
	#define PACKET_PROTOCOL_RTP "rtp"

// SIP Response Codes
// 100 - Provisional
#define SIP_STATUS_TRYING 100
#define SIP_STATUS_RINGING 180
// 200 - Success
#define SIP_STATUS_OK 200
// 300 - Redirection
// (Maybe someday)
// 400 - Client Failure
#define SIP_STATUS_CLIENT_UNAUTHORIZED 401

#define SIP_STATUS_CLIENT_UNKNOWN_SESSION 481
#define SIP_STATUS_BUSY_HERE 486
// 500 - Server Failure
#define SIP_STATUS_UNAVAILABLE 503
	//#define PACKET_SIP_FIELD_REASON
// 600 - Global Failure


// SIP State values
#define SIP_STATE_CODE 1 //List Index
	#define SIP_STATE_CODE_START_RINGING 1 //No data
	#define SIP_STATE_CODE_STOP_RINGING 2 //No data
	#define SIP_STATE_TERMINATE 3 // data: Cause Code
	#define SIP_STATE_REG_FAILURE 4 //No data
#define SIP_STATE_DATA 2 //List Index

// Sip handler sequence keys
#define SEQ_KEY_ADDR 1
#define SEQ_KEY_VERB 2
