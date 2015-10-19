ExternalLibrary subclass: #QpidProtonDLL
instanceVariableNames: '
	struct_pn_decimal128_t
struct_pn_uuid_t
struct_pn_bytes_t
struct_pn_atom_t
'
classVariableNames: '
'
poolDictionaries: '
' !


! QpidProtonDLL class methods!


initialize
	QpidProtonLibrary := self new.
!"end initialize "


new
	| obj |
	obj := self newName: 'qpid-proton.dll'.
	(obj isKindOf: ExternalLibrary) ifFalse: [
		^ 'could not initialize qpid-proton.dll.' asMessage.
	]."endif"
	obj initialize.
	^ obj.
!"end new "


pn_status_t
" Describes all the possible states for a message associated with a
 given tracker.
"
	^(IdentityDictionary new)
		at: #PN_STATUS_UNKNOWN put: 0 "< The tracker is unknown.";
		at: #PN_STATUS_PENDING put: 1 "< The message is in flight. For outgoing messages, use ::pn_messenger_buffered to see if it has been sent or not.";
		at: #PN_STATUS_ACCEPTED put: 2 "< The message was accepted.";
		at: #PN_STATUS_REJECTED put: 3 "< The message was rejected.";
		at: #PN_STATUS_RELEASED put: 4 "< The message was released.";
		at: #PN_STATUS_MODIFIED put: 5 "< The message was modified.";
		at: #PN_STATUS_ABORTED put: 6 "< The message was aborted.";
		at: #PN_STATUS_SETTLED put: 7 "< The remote party has settled the message.";
		yourself.
!"end pn_status_t "


pn_format_t
" Encoding format for message content.
"
	^(IdentityDictionary new)
		at: #PN_DATA put: 0 "< Raw binary data. Not all messages can be encoded this way";
		at: #PN_TEXT put: 1 "< Raw text. Not all messages can be encoded this way";
		at: #PN_AMQP put: 2 "< AMQP formatted data. All messages can be encoded this way";
		at: #PN_JSON put: 3 "< JSON formatted data. Not all messages can be encoded with full fidelity way";
		yourself.
!"end pn_format_t "


pn_type_t
""
	^(IdentityDictionary new)
		at: #PN_NULL put: 1 "";
		at: #PN_BOOL put: 2 "";
		at: #PN_UBYTE put: 3 "";
		at: #PN_BYTE put: 4 "";
		at: #PN_USHORT put: 5 "";
		at: #PN_SHORT put: 6 "";
		at: #PN_UINT put: 7 "";
		at: #PN_INT put: 8 "";
		at: #PN_CHAR put: 9 "";
		at: #PN_ULONG put: 10 "";
		at: #PN_LONG put: 11 "";
		at: #PN_TIMESTAMP put: 12 "";
		at: #PN_FLOAT put: 13 "";
		at: #PN_DOUBLE put: 14 "";
		at: #PN_DECIMAL32 put: 15 "";
		at: #PN_DECIMAL64 put: 16 "";
		at: #PN_DECIMAL128 put: 17 "";
		at: #PN_UUID put: 18 "";
		at: #PN_BINARY put: 19 "";
		at: #PN_STRING put: 20 "";
		at: #PN_SYMBOL put: 21 "";
		at: #PN_DESCRIBED put: 22 "";
		at: #PN_ARRAY put: 23 "";
		at: #PN_LIST put: 24 "";
		at: #PN_MAP put: 25 "";
		yourself.
!"end pn_type_t "


!"End of class methods block"


! QpidProtonDLL methods!


initialize
	self initializeStructs.
	self initializeCodec.
	self initializeError.
	self initializeMessage.
	self initializeMessenger.
	self initializeTypes.
!"end initialize "


initializeStructs
| variables |
	struct_pn_decimal128_t := Structure new.
	variables := Array new: 1.
	variables at: 1 put: VDWord new "Uknown". "char"
	struct_pn_decimal128_t addElements:
		{#'bytes[16]'}
		variables: variables startingAt: 0.

	struct_pn_uuid_t := Structure new.
	variables := Array new: 1.
	variables at: 1 put: VDWord new "Uknown". "char"
	struct_pn_uuid_t addElements:
		{#'bytes[16]'}
		variables: variables startingAt: 0.

	struct_pn_bytes_t := Structure new.
	variables := Array new: 2.
	variables at: 1 put: VDWord new "Uknown". "size_t"
	variables at: 2 put: (VString "concreteClass" passedBy: #reference). "const char*"
	struct_pn_bytes_t addElements:
		{#size #start}
		variables: variables startingAt: 0.

	struct_pn_atom_t := Structure new.
	variables := Array new: 2.
	variables at: 1 put: VDWord new "Uknown". "pn_type_t"
	variables at: 2 put: VDWord new "Uknown". "union"
	struct_pn_atom_t addElements:
		{#type #u}
		variables: variables startingAt: 0.


!"end initializeStructs "


initializeMessenger
	| variables params |

	"PN_EXTERN pn_messenger_t *pn_messenger(const char *name);"
	params := Array new: 1.
	params at: 1 put: (VString "concreteClass" passedBy: #reference). "const char*"

	self
		newProcedureNamed: #'pn_messenger'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Pointer").

	"PN_EXTERN const char *pn_messenger_name(pn_messenger_t *messenger);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_messenger_t*"

	self
		newProcedureNamed: #'pn_messenger_name'
		paramVars: params	
		callingConvention: #C 
		returns: ((VString "concreteClass" passedBy: #reference)).

	"PN_EXTERN int pn_messenger_set_certificate(pn_messenger_t *messenger, const char *certificate);"
	params := Array new: 2.
	params at: 1 put: VDWord new "Pointer". "pn_messenger_t*"
	params at: 2 put: (VString "concreteClass" passedBy: #reference). "const char*"

	self
		newProcedureNamed: #'pn_messenger_set_certificate'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN const char *pn_messenger_get_certificate(pn_messenger_t *messenger);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_messenger_t*"

	self
		newProcedureNamed: #'pn_messenger_get_certificate'
		paramVars: params	
		callingConvention: #C 
		returns: ((VString "concreteClass" passedBy: #reference)).

	"PN_EXTERN int pn_messenger_set_private_key(pn_messenger_t *messenger, const char *private_key);"
	params := Array new: 2.
	params at: 1 put: VDWord new "Pointer". "pn_messenger_t*"
	params at: 2 put: (VString "concreteClass" passedBy: #reference). "const char*"

	self
		newProcedureNamed: #'pn_messenger_set_private_key'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN const char *pn_messenger_get_private_key(pn_messenger_t *messenger);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_messenger_t*"

	self
		newProcedureNamed: #'pn_messenger_get_private_key'
		paramVars: params	
		callingConvention: #C 
		returns: ((VString "concreteClass" passedBy: #reference)).

	"PN_EXTERN int pn_messenger_set_password(pn_messenger_t *messenger, const char *password);"
	params := Array new: 2.
	params at: 1 put: VDWord new "Pointer". "pn_messenger_t*"
	params at: 2 put: (VString "concreteClass" passedBy: #reference). "const char*"

	self
		newProcedureNamed: #'pn_messenger_set_password'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN const char *pn_messenger_get_password(pn_messenger_t *messenger);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_messenger_t*"

	self
		newProcedureNamed: #'pn_messenger_get_password'
		paramVars: params	
		callingConvention: #C 
		returns: ((VString "concreteClass" passedBy: #reference)).

	"PN_EXTERN int pn_messenger_set_trusted_certificates(pn_messenger_t *messenger, const char *cert_db);"
	params := Array new: 2.
	params at: 1 put: VDWord new "Pointer". "pn_messenger_t*"
	params at: 2 put: (VString "concreteClass" passedBy: #reference). "const char*"

	self
		newProcedureNamed: #'pn_messenger_set_trusted_certificates'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN const char *pn_messenger_get_trusted_certificates(pn_messenger_t *messenger);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_messenger_t*"

	self
		newProcedureNamed: #'pn_messenger_get_trusted_certificates'
		paramVars: params	
		callingConvention: #C 
		returns: ((VString "concreteClass" passedBy: #reference)).

	"PN_EXTERN int pn_messenger_set_timeout(pn_messenger_t *messenger, int timeout);"
	params := Array new: 2.
	params at: 1 put: VDWord new "Pointer". "pn_messenger_t*"
	params at: 2 put: VDWord new "Uknown". "int"

	self
		newProcedureNamed: #'pn_messenger_set_timeout'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int pn_messenger_get_timeout(pn_messenger_t *messenger);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_messenger_t*"

	self
		newProcedureNamed: #'pn_messenger_get_timeout'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN bool pn_messenger_is_blocking(pn_messenger_t *messenger);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_messenger_t*"

	self
		newProcedureNamed: #'pn_messenger_is_blocking'
		paramVars: params	
		callingConvention: #C 
		returns: (VBoolean new).

	"PN_EXTERN int pn_messenger_set_blocking(pn_messenger_t *messenger, bool blocking);"
	params := Array new: 2.
	params at: 1 put: VDWord new "Pointer". "pn_messenger_t*"
	params at: 2 put: VBoolean new. "bool"

	self
		newProcedureNamed: #'pn_messenger_set_blocking'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN bool pn_messenger_is_passive(pn_messenger_t *messenger);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_messenger_t*"

	self
		newProcedureNamed: #'pn_messenger_is_passive'
		paramVars: params	
		callingConvention: #C 
		returns: (VBoolean new).

	"PN_EXTERN int pn_messenger_set_passive(pn_messenger_t *messenger, bool passive);"
	params := Array new: 2.
	params at: 1 put: VDWord new "Pointer". "pn_messenger_t*"
	params at: 2 put: VBoolean new. "bool"

	self
		newProcedureNamed: #'pn_messenger_set_passive'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN void pn_messenger_free(pn_messenger_t *messenger);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_messenger_t*"

	self
		newProcedureNamed: #'pn_messenger_free'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int pn_messenger_errno(pn_messenger_t *messenger);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_messenger_t*"

	self
		newProcedureNamed: #'pn_messenger_errno'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN pn_error_t *pn_messenger_error(pn_messenger_t *messenger);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_messenger_t*"

	self
		newProcedureNamed: #'pn_messenger_error'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Pointer").

	"PN_EXTERN int pn_messenger_get_outgoing_window(pn_messenger_t *messenger);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_messenger_t*"

	self
		newProcedureNamed: #'pn_messenger_get_outgoing_window'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int pn_messenger_set_outgoing_window(pn_messenger_t *messenger, int window);"
	params := Array new: 2.
	params at: 1 put: VDWord new "Pointer". "pn_messenger_t*"
	params at: 2 put: VDWord new "Uknown". "int"

	self
		newProcedureNamed: #'pn_messenger_set_outgoing_window'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int pn_messenger_get_incoming_window(pn_messenger_t *messenger);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_messenger_t*"

	self
		newProcedureNamed: #'pn_messenger_get_incoming_window'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int pn_messenger_set_incoming_window(pn_messenger_t *messenger, int window);"
	params := Array new: 2.
	params at: 1 put: VDWord new "Pointer". "pn_messenger_t*"
	params at: 2 put: VDWord new "Uknown". "int"

	self
		newProcedureNamed: #'pn_messenger_set_incoming_window'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int pn_messenger_start(pn_messenger_t *messenger);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_messenger_t*"

	self
		newProcedureNamed: #'pn_messenger_start'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int pn_messenger_stop(pn_messenger_t *messenger);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_messenger_t*"

	self
		newProcedureNamed: #'pn_messenger_stop'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN bool pn_messenger_stopped(pn_messenger_t *messenger);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_messenger_t*"

	self
		newProcedureNamed: #'pn_messenger_stopped'
		paramVars: params	
		callingConvention: #C 
		returns: (VBoolean new).

	"PN_EXTERN pn_subscription_t *pn_messenger_subscribe(pn_messenger_t *messenger, const char *source);"
	params := Array new: 2.
	params at: 1 put: VDWord new "Pointer". "pn_messenger_t*"
	params at: 2 put: (VString "concreteClass" passedBy: #reference). "const char*"

	self
		newProcedureNamed: #'pn_messenger_subscribe'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Pointer").

	"PN_EXTERN pn_subscription_t * pn_messenger_subscribe_ttl(pn_messenger_t *messenger, const char *source, pn_seconds_t timeout);"
	params := Array new: 3.
	params at: 1 put: VDWord new "Pointer". "pn_messenger_t*"
	params at: 2 put: (VString "concreteClass" passedBy: #reference). "const char*"
	params at: 3 put: VDWord new "Uknown". "pn_seconds_t"

	self
		newProcedureNamed: #'pn_messenger_subscribe_ttl'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Pointer").

	"PN_EXTERN pn_link_t *pn_messenger_get_link(pn_messenger_t *messenger, const char *address, bool sender);"
	params := Array new: 3.
	params at: 1 put: VDWord new "Pointer". "pn_messenger_t*"
	params at: 2 put: (VString "concreteClass" passedBy: #reference). "const char*"
	params at: 3 put: VBoolean new. "bool"

	self
		newProcedureNamed: #'pn_messenger_get_link'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Pointer").

	"PN_EXTERN void *pn_subscription_get_context(pn_subscription_t *sub);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_subscription_t*"

	self
		newProcedureNamed: #'pn_subscription_get_context'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Pointer").

	"PN_EXTERN void pn_subscription_set_context(pn_subscription_t *sub, void *context);"
	params := Array new: 2.
	params at: 1 put: VDWord new "Pointer". "pn_subscription_t*"
	params at: 2 put: VDWord new "Pointer". "void*"

	self
		newProcedureNamed: #'pn_subscription_set_context'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN const char *pn_subscription_address(pn_subscription_t *sub);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_subscription_t*"

	self
		newProcedureNamed: #'pn_subscription_address'
		paramVars: params	
		callingConvention: #C 
		returns: ((VString "concreteClass" passedBy: #reference)).

	"PN_EXTERN int pn_messenger_put(pn_messenger_t *messenger, pn_message_t *msg);"
	params := Array new: 2.
	params at: 1 put: VDWord new "Pointer". "pn_messenger_t*"
	params at: 2 put: VDWord new "Pointer". "pn_message_t*"

	self
		newProcedureNamed: #'pn_messenger_put'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN pn_status_t pn_messenger_status(pn_messenger_t *messenger, pn_tracker_t tracker);"
	params := Array new: 2.
	params at: 1 put: VDWord new "Pointer". "pn_messenger_t*"
	params at: 2 put: VDWord new "Uknown". "pn_tracker_t"

	self
		newProcedureNamed: #'pn_messenger_status'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN pn_delivery_t *pn_messenger_delivery(pn_messenger_t *messenger, pn_tracker_t tracker);"
	params := Array new: 2.
	params at: 1 put: VDWord new "Pointer". "pn_messenger_t*"
	params at: 2 put: VDWord new "Uknown". "pn_tracker_t"

	self
		newProcedureNamed: #'pn_messenger_delivery'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Pointer").

	"PN_EXTERN bool pn_messenger_buffered(pn_messenger_t *messenger, pn_tracker_t tracker);"
	params := Array new: 2.
	params at: 1 put: VDWord new "Pointer". "pn_messenger_t*"
	params at: 2 put: VDWord new "Uknown". "pn_tracker_t"

	self
		newProcedureNamed: #'pn_messenger_buffered'
		paramVars: params	
		callingConvention: #C 
		returns: (VBoolean new).

	"PN_EXTERN int pn_messenger_settle(pn_messenger_t *messenger, pn_tracker_t tracker, int flags);"
	params := Array new: 3.
	params at: 1 put: VDWord new "Pointer". "pn_messenger_t*"
	params at: 2 put: VDWord new "Uknown". "pn_tracker_t"
	params at: 3 put: VDWord new "Uknown". "int"

	self
		newProcedureNamed: #'pn_messenger_settle'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN pn_tracker_t pn_messenger_outgoing_tracker(pn_messenger_t *messenger);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_messenger_t*"

	self
		newProcedureNamed: #'pn_messenger_outgoing_tracker'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int pn_messenger_work(pn_messenger_t *messenger, int timeout);"
	params := Array new: 2.
	params at: 1 put: VDWord new "Pointer". "pn_messenger_t*"
	params at: 2 put: VDWord new "Uknown". "int"

	self
		newProcedureNamed: #'pn_messenger_work'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int pn_messenger_interrupt(pn_messenger_t *messenger);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_messenger_t*"

	self
		newProcedureNamed: #'pn_messenger_interrupt'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int pn_messenger_send(pn_messenger_t *messenger, int n);"
	params := Array new: 2.
	params at: 1 put: VDWord new "Pointer". "pn_messenger_t*"
	params at: 2 put: VDWord new "Uknown". "int"

	self
		newProcedureNamed: #'pn_messenger_send'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int pn_messenger_recv(pn_messenger_t *messenger, int limit);"
	params := Array new: 2.
	params at: 1 put: VDWord new "Pointer". "pn_messenger_t*"
	params at: 2 put: VDWord new "Uknown". "int"

	self
		newProcedureNamed: #'pn_messenger_recv'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int pn_messenger_receiving(pn_messenger_t *messenger);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_messenger_t*"

	self
		newProcedureNamed: #'pn_messenger_receiving'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int pn_messenger_get(pn_messenger_t *messenger, pn_message_t *message);"
	params := Array new: 2.
	params at: 1 put: VDWord new "Pointer". "pn_messenger_t*"
	params at: 2 put: VDWord new "Pointer". "pn_message_t*"

	self
		newProcedureNamed: #'pn_messenger_get'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN pn_tracker_t pn_messenger_incoming_tracker(pn_messenger_t *messenger);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_messenger_t*"

	self
		newProcedureNamed: #'pn_messenger_incoming_tracker'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN pn_subscription_t *pn_messenger_incoming_subscription(pn_messenger_t *messenger);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_messenger_t*"

	self
		newProcedureNamed: #'pn_messenger_incoming_subscription'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Pointer").

	"PN_EXTERN int pn_messenger_accept(pn_messenger_t *messenger, pn_tracker_t tracker, int flags);"
	params := Array new: 3.
	params at: 1 put: VDWord new "Pointer". "pn_messenger_t*"
	params at: 2 put: VDWord new "Uknown". "pn_tracker_t"
	params at: 3 put: VDWord new "Uknown". "int"

	self
		newProcedureNamed: #'pn_messenger_accept'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int pn_messenger_reject(pn_messenger_t *messenger, pn_tracker_t tracker, int flags);"
	params := Array new: 3.
	params at: 1 put: VDWord new "Pointer". "pn_messenger_t*"
	params at: 2 put: VDWord new "Uknown". "pn_tracker_t"
	params at: 3 put: VDWord new "Uknown". "int"

	self
		newProcedureNamed: #'pn_messenger_reject'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN pn_link_t *pn_messenger_tracker_link(pn_messenger_t *messenger, pn_tracker_t tracker);"
	params := Array new: 2.
	params at: 1 put: VDWord new "Pointer". "pn_messenger_t*"
	params at: 2 put: VDWord new "Uknown". "pn_tracker_t"

	self
		newProcedureNamed: #'pn_messenger_tracker_link'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Pointer").

	"PN_EXTERN int pn_messenger_outgoing(pn_messenger_t *messenger);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_messenger_t*"

	self
		newProcedureNamed: #'pn_messenger_outgoing'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int pn_messenger_incoming(pn_messenger_t *messenger);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_messenger_t*"

	self
		newProcedureNamed: #'pn_messenger_incoming'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int pn_messenger_route(pn_messenger_t *messenger, const char *pattern, const char *address);"
	params := Array new: 3.
	params at: 1 put: VDWord new "Pointer". "pn_messenger_t*"
	params at: 2 put: (VString "concreteClass" passedBy: #reference). "const char*"
	params at: 3 put: (VString "concreteClass" passedBy: #reference). "const char*"

	self
		newProcedureNamed: #'pn_messenger_route'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int pn_messenger_rewrite(pn_messenger_t *messenger, const char *pattern, const char *address);"
	params := Array new: 3.
	params at: 1 put: VDWord new "Pointer". "pn_messenger_t*"
	params at: 2 put: (VString "concreteClass" passedBy: #reference). "const char*"
	params at: 3 put: (VString "concreteClass" passedBy: #reference). "const char*"

	self
		newProcedureNamed: #'pn_messenger_rewrite'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN pn_selectable_t *pn_messenger_selectable(pn_messenger_t *messenger);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_messenger_t*"

	self
		newProcedureNamed: #'pn_messenger_selectable'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Pointer").

	"PN_EXTERN pn_timestamp_t pn_messenger_deadline(pn_messenger_t *messenger);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_messenger_t*"

	self
		newProcedureNamed: #'pn_messenger_deadline'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int pn_messenger_set_flags(pn_messenger_t *messenger, const int flags);"
	params := Array new: 2.
	params at: 1 put: VDWord new "Pointer". "pn_messenger_t*"
	params at: 2 put: VDWord new "Uknown". "const int"

	self
		newProcedureNamed: #'pn_messenger_set_flags'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int pn_messenger_get_flags(pn_messenger_t *messenger);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_messenger_t*"

	self
		newProcedureNamed: #'pn_messenger_get_flags'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int pn_messenger_set_snd_settle_mode(pn_messenger_t *messenger, const pn_snd_settle_mode_t mode);"
	params := Array new: 2.
	params at: 1 put: VDWord new "Pointer". "pn_messenger_t*"
	params at: 2 put: VDWord new "Uknown". "const pn_snd_settle_mode_t"

	self
		newProcedureNamed: #'pn_messenger_set_snd_settle_mode'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int pn_messenger_set_rcv_settle_mode(pn_messenger_t *messenger, const pn_rcv_settle_mode_t mode);"
	params := Array new: 2.
	params at: 1 put: VDWord new "Pointer". "pn_messenger_t*"
	params at: 2 put: VDWord new "Uknown". "const pn_rcv_settle_mode_t"

	self
		newProcedureNamed: #'pn_messenger_set_rcv_settle_mode'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN void pn_messenger_set_tracer(pn_messenger_t *messenger, pn_tracer_t tracer);"
	params := Array new: 2.
	params at: 1 put: VDWord new "Pointer". "pn_messenger_t*"
	params at: 2 put: VDWord new "Uknown". "pn_tracer_t"

	self
		newProcedureNamed: #'pn_messenger_set_tracer'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN pn_millis_t pn_messenger_get_remote_idle_timeout(pn_messenger_t *messenger, const char *address);"
	params := Array new: 2.
	params at: 1 put: VDWord new "Pointer". "pn_messenger_t*"
	params at: 2 put: (VString "concreteClass" passedBy: #reference). "const char*"

	self
		newProcedureNamed: #'pn_messenger_get_remote_idle_timeout'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int pn_messenger_set_ssl_peer_authentication_mode(pn_messenger_t *messenger, const pn_ssl_verify_mode_t mode);"
	params := Array new: 2.
	params at: 1 put: VDWord new "Pointer". "pn_messenger_t*"
	params at: 2 put: VDWord new "Uknown". "const pn_ssl_verify_mode_t"

	self
		newProcedureNamed: #'pn_messenger_set_ssl_peer_authentication_mode'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").


!"end initializeMessenger "


initializeMessage
	| variables params |

	"PN_EXTERN pn_message_t * pn_message(void);"
	params := Array new: 0.

	self
		newProcedureNamed: #'pn_message'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Pointer").

	"PN_EXTERN void           pn_message_free(pn_message_t *msg);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_message_t*"

	self
		newProcedureNamed: #'pn_message_free'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN void           pn_message_clear(pn_message_t *msg);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_message_t*"

	self
		newProcedureNamed: #'pn_message_clear'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int            pn_message_errno(pn_message_t *msg);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_message_t*"

	self
		newProcedureNamed: #'pn_message_errno'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN pn_error_t    *pn_message_error(pn_message_t *msg);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_message_t*"

	self
		newProcedureNamed: #'pn_message_error'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Pointer").

	"PN_EXTERN bool           pn_message_is_inferred(pn_message_t *msg);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_message_t*"

	self
		newProcedureNamed: #'pn_message_is_inferred'
		paramVars: params	
		callingConvention: #C 
		returns: (VBoolean new).

	"PN_EXTERN int            pn_message_set_inferred(pn_message_t *msg, bool inferred);"
	params := Array new: 2.
	params at: 1 put: VDWord new "Pointer". "pn_message_t*"
	params at: 2 put: VBoolean new. "bool"

	self
		newProcedureNamed: #'pn_message_set_inferred'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN bool           pn_message_is_durable            (pn_message_t *msg);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_message_t*"

	self
		newProcedureNamed: #'pn_message_is_durable'
		paramVars: params	
		callingConvention: #C 
		returns: (VBoolean new).

	"PN_EXTERN int            pn_message_set_durable           (pn_message_t *msg, bool durable);"
	params := Array new: 2.
	params at: 1 put: VDWord new "Pointer". "pn_message_t*"
	params at: 2 put: VBoolean new. "bool"

	self
		newProcedureNamed: #'pn_message_set_durable'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN uint8_t        pn_message_get_priority          (pn_message_t *msg);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_message_t*"

	self
		newProcedureNamed: #'pn_message_get_priority'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int            pn_message_set_priority          (pn_message_t *msg, uint8_t priority);"
	params := Array new: 2.
	params at: 1 put: VDWord new "Pointer". "pn_message_t*"
	params at: 2 put: VDWord new "Uknown". "uint8_t"

	self
		newProcedureNamed: #'pn_message_set_priority'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN pn_millis_t    pn_message_get_ttl               (pn_message_t *msg);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_message_t*"

	self
		newProcedureNamed: #'pn_message_get_ttl'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int            pn_message_set_ttl               (pn_message_t *msg, pn_millis_t ttl);"
	params := Array new: 2.
	params at: 1 put: VDWord new "Pointer". "pn_message_t*"
	params at: 2 put: VDWord new "Uknown". "pn_millis_t"

	self
		newProcedureNamed: #'pn_message_set_ttl'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN bool           pn_message_is_first_acquirer     (pn_message_t *msg);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_message_t*"

	self
		newProcedureNamed: #'pn_message_is_first_acquirer'
		paramVars: params	
		callingConvention: #C 
		returns: (VBoolean new).

	"PN_EXTERN int            pn_message_set_first_acquirer    (pn_message_t *msg, bool first);"
	params := Array new: 2.
	params at: 1 put: VDWord new "Pointer". "pn_message_t*"
	params at: 2 put: VBoolean new. "bool"

	self
		newProcedureNamed: #'pn_message_set_first_acquirer'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN uint32_t       pn_message_get_delivery_count    (pn_message_t *msg);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_message_t*"

	self
		newProcedureNamed: #'pn_message_get_delivery_count'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int            pn_message_set_delivery_count    (pn_message_t *msg, uint32_t count);"
	params := Array new: 2.
	params at: 1 put: VDWord new "Pointer". "pn_message_t*"
	params at: 2 put: VDWord new "Uknown". "uint32_t"

	self
		newProcedureNamed: #'pn_message_set_delivery_count'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN pn_data_t *    pn_message_id                    (pn_message_t *msg);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_message_t*"

	self
		newProcedureNamed: #'pn_message_id'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Pointer").

	"PN_EXTERN pn_atom_t      pn_message_get_id                (pn_message_t *msg);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_message_t*"

	self
		newProcedureNamed: #'pn_message_get_id'
		paramVars: params	
		callingConvention: #C 
		returns: (((VStructure structObj: struct_pn_atom_t) passedBy: #value)).

	"PN_EXTERN int            pn_message_set_id                (pn_message_t *msg, pn_atom_t id);"
	params := Array new: 2.
	params at: 1 put: VDWord new "Pointer". "pn_message_t*"
	params at: 2 put: ((VStructure structObj: struct_pn_atom_t) passedBy: #value). "pn_atom_t"

	self
		newProcedureNamed: #'pn_message_set_id'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN pn_bytes_t     pn_message_get_user_id           (pn_message_t *msg);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_message_t*"

	self
		newProcedureNamed: #'pn_message_get_user_id'
		paramVars: params	
		callingConvention: #C 
		returns: (((VStructure structObj: struct_pn_bytes_t) passedBy: #value)).

	"PN_EXTERN int            pn_message_set_user_id           (pn_message_t *msg, pn_bytes_t user_id);"
	params := Array new: 2.
	params at: 1 put: VDWord new "Pointer". "pn_message_t*"
	params at: 2 put: ((VStructure structObj: struct_pn_bytes_t) passedBy: #value). "pn_bytes_t"

	self
		newProcedureNamed: #'pn_message_set_user_id'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN const char *   pn_message_get_address           (pn_message_t *msg);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_message_t*"

	self
		newProcedureNamed: #'pn_message_get_address'
		paramVars: params	
		callingConvention: #C 
		returns: ((VString "concreteClass" passedBy: #reference)).

	"PN_EXTERN int            pn_message_set_address           (pn_message_t *msg, const char *address);"
	params := Array new: 2.
	params at: 1 put: VDWord new "Pointer". "pn_message_t*"
	params at: 2 put: (VString "concreteClass" passedBy: #reference). "const char*"

	self
		newProcedureNamed: #'pn_message_set_address'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN const char *   pn_message_get_subject           (pn_message_t *msg);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_message_t*"

	self
		newProcedureNamed: #'pn_message_get_subject'
		paramVars: params	
		callingConvention: #C 
		returns: ((VString "concreteClass" passedBy: #reference)).

	"PN_EXTERN int            pn_message_set_subject           (pn_message_t *msg, const char *subject);"
	params := Array new: 2.
	params at: 1 put: VDWord new "Pointer". "pn_message_t*"
	params at: 2 put: (VString "concreteClass" passedBy: #reference). "const char*"

	self
		newProcedureNamed: #'pn_message_set_subject'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN const char *   pn_message_get_reply_to          (pn_message_t *msg);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_message_t*"

	self
		newProcedureNamed: #'pn_message_get_reply_to'
		paramVars: params	
		callingConvention: #C 
		returns: ((VString "concreteClass" passedBy: #reference)).

	"PN_EXTERN int            pn_message_set_reply_to          (pn_message_t *msg, const char *reply_to);"
	params := Array new: 2.
	params at: 1 put: VDWord new "Pointer". "pn_message_t*"
	params at: 2 put: (VString "concreteClass" passedBy: #reference). "const char*"

	self
		newProcedureNamed: #'pn_message_set_reply_to'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN pn_data_t *    pn_message_correlation_id        (pn_message_t *msg);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_message_t*"

	self
		newProcedureNamed: #'pn_message_correlation_id'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Pointer").

	"PN_EXTERN pn_atom_t      pn_message_get_correlation_id    (pn_message_t *msg);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_message_t*"

	self
		newProcedureNamed: #'pn_message_get_correlation_id'
		paramVars: params	
		callingConvention: #C 
		returns: (((VStructure structObj: struct_pn_atom_t) passedBy: #value)).

	"PN_EXTERN int            pn_message_set_correlation_id    (pn_message_t *msg, pn_atom_t id);"
	params := Array new: 2.
	params at: 1 put: VDWord new "Pointer". "pn_message_t*"
	params at: 2 put: ((VStructure structObj: struct_pn_atom_t) passedBy: #value). "pn_atom_t"

	self
		newProcedureNamed: #'pn_message_set_correlation_id'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN const char *   pn_message_get_content_type      (pn_message_t *msg);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_message_t*"

	self
		newProcedureNamed: #'pn_message_get_content_type'
		paramVars: params	
		callingConvention: #C 
		returns: ((VString "concreteClass" passedBy: #reference)).

	"PN_EXTERN int            pn_message_set_content_type      (pn_message_t *msg, const char *type);"
	params := Array new: 2.
	params at: 1 put: VDWord new "Pointer". "pn_message_t*"
	params at: 2 put: (VString "concreteClass" passedBy: #reference). "const char*"

	self
		newProcedureNamed: #'pn_message_set_content_type'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN const char *   pn_message_get_content_encoding  (pn_message_t *msg);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_message_t*"

	self
		newProcedureNamed: #'pn_message_get_content_encoding'
		paramVars: params	
		callingConvention: #C 
		returns: ((VString "concreteClass" passedBy: #reference)).

	"PN_EXTERN int            pn_message_set_content_encoding  (pn_message_t *msg, const char *encoding);"
	params := Array new: 2.
	params at: 1 put: VDWord new "Pointer". "pn_message_t*"
	params at: 2 put: (VString "concreteClass" passedBy: #reference). "const char*"

	self
		newProcedureNamed: #'pn_message_set_content_encoding'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN pn_timestamp_t pn_message_get_expiry_time       (pn_message_t *msg);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_message_t*"

	self
		newProcedureNamed: #'pn_message_get_expiry_time'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int            pn_message_set_expiry_time       (pn_message_t *msg, pn_timestamp_t time);"
	params := Array new: 2.
	params at: 1 put: VDWord new "Pointer". "pn_message_t*"
	params at: 2 put: VDWord new "Uknown". "pn_timestamp_t"

	self
		newProcedureNamed: #'pn_message_set_expiry_time'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN pn_timestamp_t pn_message_get_creation_time     (pn_message_t *msg);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_message_t*"

	self
		newProcedureNamed: #'pn_message_get_creation_time'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int            pn_message_set_creation_time     (pn_message_t *msg, pn_timestamp_t time);"
	params := Array new: 2.
	params at: 1 put: VDWord new "Pointer". "pn_message_t*"
	params at: 2 put: VDWord new "Uknown". "pn_timestamp_t"

	self
		newProcedureNamed: #'pn_message_set_creation_time'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN const char *   pn_message_get_group_id          (pn_message_t *msg);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_message_t*"

	self
		newProcedureNamed: #'pn_message_get_group_id'
		paramVars: params	
		callingConvention: #C 
		returns: ((VString "concreteClass" passedBy: #reference)).

	"PN_EXTERN int            pn_message_set_group_id          (pn_message_t *msg, const char *group_id);"
	params := Array new: 2.
	params at: 1 put: VDWord new "Pointer". "pn_message_t*"
	params at: 2 put: (VString "concreteClass" passedBy: #reference). "const char*"

	self
		newProcedureNamed: #'pn_message_set_group_id'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN pn_sequence_t  pn_message_get_group_sequence    (pn_message_t *msg);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_message_t*"

	self
		newProcedureNamed: #'pn_message_get_group_sequence'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int            pn_message_set_group_sequence    (pn_message_t *msg, pn_sequence_t n);"
	params := Array new: 2.
	params at: 1 put: VDWord new "Pointer". "pn_message_t*"
	params at: 2 put: VDWord new "Uknown". "pn_sequence_t"

	self
		newProcedureNamed: #'pn_message_set_group_sequence'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN const char *   pn_message_get_reply_to_group_id (pn_message_t *msg);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_message_t*"

	self
		newProcedureNamed: #'pn_message_get_reply_to_group_id'
		paramVars: params	
		callingConvention: #C 
		returns: ((VString "concreteClass" passedBy: #reference)).

	"PN_EXTERN int            pn_message_set_reply_to_group_id (pn_message_t *msg, const char *reply_to_group_id);"
	params := Array new: 2.
	params at: 1 put: VDWord new "Pointer". "pn_message_t*"
	params at: 2 put: (VString "concreteClass" passedBy: #reference). "const char*"

	self
		newProcedureNamed: #'pn_message_set_reply_to_group_id'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN pn_format_t pn_message_get_format(pn_message_t *message);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_message_t*"

	self
		newProcedureNamed: #'pn_message_get_format'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int pn_message_set_format(pn_message_t *message, pn_format_t format);"
	params := Array new: 2.
	params at: 1 put: VDWord new "Pointer". "pn_message_t*"
	params at: 2 put: VDWord new "Uknown". "pn_format_t"

	self
		newProcedureNamed: #'pn_message_set_format'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int pn_message_load(pn_message_t *message, const char *data, size_t size);"
	params := Array new: 3.
	params at: 1 put: VDWord new "Pointer". "pn_message_t*"
	params at: 2 put: (VString "concreteClass" passedBy: #reference). "const char*"
	params at: 3 put: VDWord new "Uknown". "size_t"

	self
		newProcedureNamed: #'pn_message_load'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int pn_message_load_data(pn_message_t *message, const char *data, size_t size);"
	params := Array new: 3.
	params at: 1 put: VDWord new "Pointer". "pn_message_t*"
	params at: 2 put: (VString "concreteClass" passedBy: #reference). "const char*"
	params at: 3 put: VDWord new "Uknown". "size_t"

	self
		newProcedureNamed: #'pn_message_load_data'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int pn_message_load_text(pn_message_t *message, const char *data, size_t size);"
	params := Array new: 3.
	params at: 1 put: VDWord new "Pointer". "pn_message_t*"
	params at: 2 put: (VString "concreteClass" passedBy: #reference). "const char*"
	params at: 3 put: VDWord new "Uknown". "size_t"

	self
		newProcedureNamed: #'pn_message_load_text'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int pn_message_load_amqp(pn_message_t *message, const char *data, size_t size);"
	params := Array new: 3.
	params at: 1 put: VDWord new "Pointer". "pn_message_t*"
	params at: 2 put: (VString "concreteClass" passedBy: #reference). "const char*"
	params at: 3 put: VDWord new "Uknown". "size_t"

	self
		newProcedureNamed: #'pn_message_load_amqp'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int pn_message_load_json(pn_message_t *message, const char *data, size_t size);"
	params := Array new: 3.
	params at: 1 put: VDWord new "Pointer". "pn_message_t*"
	params at: 2 put: (VString "concreteClass" passedBy: #reference). "const char*"
	params at: 3 put: VDWord new "Uknown". "size_t"

	self
		newProcedureNamed: #'pn_message_load_json'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int pn_message_save(pn_message_t *message, char *data, size_t *size);"
	params := Array new: 3.
	params at: 1 put: VDWord new "Pointer". "pn_message_t*"
	params at: 2 put: VDWord new "String by reference". "char*"
	params at: 3 put: VDWord new "Pointer". "size_t*"

	self
		newProcedureNamed: #'pn_message_save'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int pn_message_save_data(pn_message_t *message, char *data, size_t *size);"
	params := Array new: 3.
	params at: 1 put: VDWord new "Pointer". "pn_message_t*"
	params at: 2 put: VDWord new "String by reference". "char*"
	params at: 3 put: VDWord new "Pointer". "size_t*"

	self
		newProcedureNamed: #'pn_message_save_data'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int pn_message_save_text(pn_message_t *message, char *data, size_t *size);"
	params := Array new: 3.
	params at: 1 put: VDWord new "Pointer". "pn_message_t*"
	params at: 2 put: VDWord new "String by reference". "char*"
	params at: 3 put: VDWord new "Pointer". "size_t*"

	self
		newProcedureNamed: #'pn_message_save_text'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int pn_message_save_amqp(pn_message_t *message, char *data, size_t *size);"
	params := Array new: 3.
	params at: 1 put: VDWord new "Pointer". "pn_message_t*"
	params at: 2 put: VDWord new "String by reference". "char*"
	params at: 3 put: VDWord new "Pointer". "size_t*"

	self
		newProcedureNamed: #'pn_message_save_amqp'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int pn_message_save_json(pn_message_t *message, char *data, size_t *size);"
	params := Array new: 3.
	params at: 1 put: VDWord new "Pointer". "pn_message_t*"
	params at: 2 put: VDWord new "String by reference". "char*"
	params at: 3 put: VDWord new "Pointer". "size_t*"

	self
		newProcedureNamed: #'pn_message_save_json'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN pn_data_t *pn_message_instructions(pn_message_t *msg);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_message_t*"

	self
		newProcedureNamed: #'pn_message_instructions'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Pointer").

	"PN_EXTERN pn_data_t *pn_message_annotations(pn_message_t *msg);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_message_t*"

	self
		newProcedureNamed: #'pn_message_annotations'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Pointer").

	"PN_EXTERN pn_data_t *pn_message_properties(pn_message_t *msg);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_message_t*"

	self
		newProcedureNamed: #'pn_message_properties'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Pointer").

	"PN_EXTERN pn_data_t *pn_message_body(pn_message_t *msg);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_message_t*"

	self
		newProcedureNamed: #'pn_message_body'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Pointer").

	"PN_EXTERN int pn_message_decode(pn_message_t *msg, const char *bytes, size_t size);"
	params := Array new: 3.
	params at: 1 put: VDWord new "Pointer". "pn_message_t*"
	params at: 2 put: (VString "concreteClass" passedBy: #reference). "const char*"
	params at: 3 put: VDWord new "Uknown". "size_t"

	self
		newProcedureNamed: #'pn_message_decode'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int pn_message_encode(pn_message_t *msg, char *bytes, size_t *size);"
	params := Array new: 3.
	params at: 1 put: VDWord new "Pointer". "pn_message_t*"
	params at: 2 put: VDWord new "String by reference". "char*"
	params at: 3 put: VDWord new "Pointer". "size_t*"

	self
		newProcedureNamed: #'pn_message_encode'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN ssize_t pn_message_data(char *dst, size_t available, const char *src, size_t size);"
	params := Array new: 4.
	params at: 1 put: VDWord new "String by reference". "char*"
	params at: 2 put: VDWord new "Uknown". "size_t"
	params at: 3 put: (VString "concreteClass" passedBy: #reference). "const char*"
	params at: 4 put: VDWord new "Uknown". "size_t"

	self
		newProcedureNamed: #'pn_message_data'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").


!"end initializeMessage "


initializeError
	| variables params |

	"PN_EXTERN const char *pn_code(int code);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Uknown". "int"

	self
		newProcedureNamed: #'pn_code'
		paramVars: params	
		callingConvention: #C 
		returns: ((VString "concreteClass" passedBy: #reference)).

	"PN_EXTERN pn_error_t *pn_error(void);"
	params := Array new: 0.

	self
		newProcedureNamed: #'pn_error'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Pointer").

	"PN_EXTERN void pn_error_free(pn_error_t *error);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_error_t*"

	self
		newProcedureNamed: #'pn_error_free'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN void pn_error_clear(pn_error_t *error);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_error_t*"

	self
		newProcedureNamed: #'pn_error_clear'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int pn_error_set(pn_error_t *error, int code, const char *text);"
	params := Array new: 3.
	params at: 1 put: VDWord new "Pointer". "pn_error_t*"
	params at: 2 put: VDWord new "Uknown". "int"
	params at: 3 put: (VString "concreteClass" passedBy: #reference). "const char*"

	self
		newProcedureNamed: #'pn_error_set'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int pn_error_vformat(pn_error_t *error, int code, const char *fmt, va_list ap);"
	params := Array new: 4.
	params at: 1 put: VDWord new "Pointer". "pn_error_t*"
	params at: 2 put: VDWord new "Uknown". "int"
	params at: 3 put: (VString "concreteClass" passedBy: #reference). "const char*"
	params at: 4 put: VDWord new "Uknown". "va_list"

	self
		newProcedureNamed: #'pn_error_vformat'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int pn_error_format(pn_error_t *error, int code, const char *fmt, ...);"
	params := Array new: 4.
	params at: 1 put: VDWord new "Pointer". "pn_error_t*"
	params at: 2 put: VDWord new "Uknown". "int"
	params at: 3 put: (VString "concreteClass" passedBy: #reference). "const char*"
	params at: 4 put: VDWord new "Uknown". "array"

	self
		newProcedureNamed: #'pn_error_format'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int pn_error_code(pn_error_t *error);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_error_t*"

	self
		newProcedureNamed: #'pn_error_code'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN const char *pn_error_text(pn_error_t *error);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_error_t*"

	self
		newProcedureNamed: #'pn_error_text'
		paramVars: params	
		callingConvention: #C 
		returns: ((VString "concreteClass" passedBy: #reference)).

	"PN_EXTERN int pn_error_copy(pn_error_t *error, pn_error_t *src);"
	params := Array new: 2.
	params at: 1 put: VDWord new "Pointer". "pn_error_t*"
	params at: 2 put: VDWord new "Pointer". "pn_error_t*"

	self
		newProcedureNamed: #'pn_error_copy'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").


!"end initializeError "


initializeTypes
	| variables params |

	"PN_EXTERN pn_bytes_t pn_bytes(size_t size, const char *start);"
	params := Array new: 2.
	params at: 1 put: VDWord new "Uknown". "size_t"
	params at: 2 put: (VString "concreteClass" passedBy: #reference). "const char*"

	self
		newProcedureNamed: #'pn_bytes'
		paramVars: params	
		callingConvention: #C 
		returns: (((VStructure structObj: struct_pn_bytes_t) passedBy: #value)).


!"end initializeTypes "


initializeCodec
	| variables params |

	"PN_EXTERN const char *pn_type_name(pn_type_t type);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Uknown". "pn_type_t"

	self
		newProcedureNamed: #'pn_type_name'
		paramVars: params	
		callingConvention: #C 
		returns: ((VString "concreteClass" passedBy: #reference)).

	"PN_EXTERN pn_data_t *pn_data(size_t capacity);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Uknown". "size_t"

	self
		newProcedureNamed: #'pn_data'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Pointer").

	"PN_EXTERN void pn_data_free(pn_data_t *data);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"

	self
		newProcedureNamed: #'pn_data_free'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int pn_data_errno(pn_data_t *data);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"

	self
		newProcedureNamed: #'pn_data_errno'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN pn_error_t *pn_data_error(pn_data_t *data);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"

	self
		newProcedureNamed: #'pn_data_error'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Pointer").

	"PN_EXTERN int pn_data_vfill(pn_data_t *data, const char *fmt, va_list ap);"
	params := Array new: 3.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"
	params at: 2 put: (VString "concreteClass" passedBy: #reference). "const char*"
	params at: 3 put: VDWord new "Uknown". "va_list"

	self
		newProcedureNamed: #'pn_data_vfill'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int pn_data_fill(pn_data_t *data, const char *fmt, ...);"
	params := Array new: 3.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"
	params at: 2 put: (VString "concreteClass" passedBy: #reference). "const char*"
	params at: 3 put: VDWord new "Uknown". "array"

	self
		newProcedureNamed: #'pn_data_fill'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int pn_data_vscan(pn_data_t *data, const char *fmt, va_list ap);"
	params := Array new: 3.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"
	params at: 2 put: (VString "concreteClass" passedBy: #reference). "const char*"
	params at: 3 put: VDWord new "Uknown". "va_list"

	self
		newProcedureNamed: #'pn_data_vscan'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int pn_data_scan(pn_data_t *data, const char *fmt, ...);"
	params := Array new: 3.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"
	params at: 2 put: (VString "concreteClass" passedBy: #reference). "const char*"
	params at: 3 put: VDWord new "Uknown". "array"

	self
		newProcedureNamed: #'pn_data_scan'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN void pn_data_clear(pn_data_t *data);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"

	self
		newProcedureNamed: #'pn_data_clear'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN size_t pn_data_size(pn_data_t *data);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"

	self
		newProcedureNamed: #'pn_data_size'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN void pn_data_rewind(pn_data_t *data);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"

	self
		newProcedureNamed: #'pn_data_rewind'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN bool pn_data_next(pn_data_t *data);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"

	self
		newProcedureNamed: #'pn_data_next'
		paramVars: params	
		callingConvention: #C 
		returns: (VBoolean new).

	"PN_EXTERN bool pn_data_prev(pn_data_t *data);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"

	self
		newProcedureNamed: #'pn_data_prev'
		paramVars: params	
		callingConvention: #C 
		returns: (VBoolean new).

	"PN_EXTERN bool pn_data_enter(pn_data_t *data);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"

	self
		newProcedureNamed: #'pn_data_enter'
		paramVars: params	
		callingConvention: #C 
		returns: (VBoolean new).

	"PN_EXTERN bool pn_data_exit(pn_data_t *data);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"

	self
		newProcedureNamed: #'pn_data_exit'
		paramVars: params	
		callingConvention: #C 
		returns: (VBoolean new).

	"PN_EXTERN bool pn_data_lookup(pn_data_t *data, const char *name);"
	params := Array new: 2.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"
	params at: 2 put: (VString "concreteClass" passedBy: #reference). "const char*"

	self
		newProcedureNamed: #'pn_data_lookup'
		paramVars: params	
		callingConvention: #C 
		returns: (VBoolean new).

	"PN_EXTERN pn_type_t pn_data_type(pn_data_t *data);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"

	self
		newProcedureNamed: #'pn_data_type'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int pn_data_print(pn_data_t *data);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"

	self
		newProcedureNamed: #'pn_data_print'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int pn_data_format(pn_data_t *data, char *bytes, size_t *size);"
	params := Array new: 3.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"
	params at: 2 put: VDWord new "String by reference". "char*"
	params at: 3 put: VDWord new "Pointer". "size_t*"

	self
		newProcedureNamed: #'pn_data_format'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN ssize_t pn_data_encode(pn_data_t *data, char *bytes, size_t size);"
	params := Array new: 3.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"
	params at: 2 put: VDWord new "String by reference". "char*"
	params at: 3 put: VDWord new "Uknown". "size_t"

	self
		newProcedureNamed: #'pn_data_encode'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN ssize_t pn_data_decode(pn_data_t *data, const char *bytes, size_t size);"
	params := Array new: 3.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"
	params at: 2 put: (VString "concreteClass" passedBy: #reference). "const char*"
	params at: 3 put: VDWord new "Uknown". "size_t"

	self
		newProcedureNamed: #'pn_data_decode'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int pn_data_put_list(pn_data_t *data);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"

	self
		newProcedureNamed: #'pn_data_put_list'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int pn_data_put_map(pn_data_t *data);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"

	self
		newProcedureNamed: #'pn_data_put_map'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int pn_data_put_array(pn_data_t *data, bool described, pn_type_t type);"
	params := Array new: 3.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"
	params at: 2 put: VBoolean new. "bool"
	params at: 3 put: VDWord new "Uknown". "pn_type_t"

	self
		newProcedureNamed: #'pn_data_put_array'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int pn_data_put_described(pn_data_t *data);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"

	self
		newProcedureNamed: #'pn_data_put_described'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int pn_data_put_null(pn_data_t *data);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"

	self
		newProcedureNamed: #'pn_data_put_null'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int pn_data_put_bool(pn_data_t *data, bool b);"
	params := Array new: 2.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"
	params at: 2 put: VBoolean new. "bool"

	self
		newProcedureNamed: #'pn_data_put_bool'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int pn_data_put_ubyte(pn_data_t *data, uint8_t ub);"
	params := Array new: 2.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"
	params at: 2 put: VDWord new "Uknown". "uint8_t"

	self
		newProcedureNamed: #'pn_data_put_ubyte'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int pn_data_put_byte(pn_data_t *data, int8_t b);"
	params := Array new: 2.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"
	params at: 2 put: VDWord new "Uknown". "int8_t"

	self
		newProcedureNamed: #'pn_data_put_byte'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int pn_data_put_ushort(pn_data_t *data, uint16_t us);"
	params := Array new: 2.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"
	params at: 2 put: VDWord new "Uknown". "uint16_t"

	self
		newProcedureNamed: #'pn_data_put_ushort'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int pn_data_put_short(pn_data_t *data, int16_t s);"
	params := Array new: 2.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"
	params at: 2 put: VDWord new "Uknown". "int16_t"

	self
		newProcedureNamed: #'pn_data_put_short'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int pn_data_put_uint(pn_data_t *data, uint32_t ui);"
	params := Array new: 2.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"
	params at: 2 put: VDWord new "Uknown". "uint32_t"

	self
		newProcedureNamed: #'pn_data_put_uint'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int pn_data_put_int(pn_data_t *data, int32_t i);"
	params := Array new: 2.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"
	params at: 2 put: VDWord new "Uknown". "int32_t"

	self
		newProcedureNamed: #'pn_data_put_int'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int pn_data_put_char(pn_data_t *data, pn_char_t c);"
	params := Array new: 2.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"
	params at: 2 put: VDWord new "Uknown". "pn_char_t"

	self
		newProcedureNamed: #'pn_data_put_char'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int pn_data_put_ulong(pn_data_t *data, uint64_t ul);"
	params := Array new: 2.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"
	params at: 2 put: VDWord new "Uknown". "uint64_t"

	self
		newProcedureNamed: #'pn_data_put_ulong'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int pn_data_put_long(pn_data_t *data, int64_t l);"
	params := Array new: 2.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"
	params at: 2 put: VDWord new "Uknown". "int64_t"

	self
		newProcedureNamed: #'pn_data_put_long'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int pn_data_put_timestamp(pn_data_t *data, pn_timestamp_t t);"
	params := Array new: 2.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"
	params at: 2 put: VDWord new "Uknown". "pn_timestamp_t"

	self
		newProcedureNamed: #'pn_data_put_timestamp'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int pn_data_put_float(pn_data_t *data, float f);"
	params := Array new: 2.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"
	params at: 2 put: VDWord new "Uknown". "float"

	self
		newProcedureNamed: #'pn_data_put_float'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int pn_data_put_double(pn_data_t *data, double d);"
	params := Array new: 2.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"
	params at: 2 put: VDWord new "Uknown". "double"

	self
		newProcedureNamed: #'pn_data_put_double'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int pn_data_put_decimal32(pn_data_t *data, pn_decimal32_t d);"
	params := Array new: 2.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"
	params at: 2 put: VDWord new "Uknown". "pn_decimal32_t"

	self
		newProcedureNamed: #'pn_data_put_decimal32'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int pn_data_put_decimal64(pn_data_t *data, pn_decimal64_t d);"
	params := Array new: 2.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"
	params at: 2 put: VDWord new "Uknown". "pn_decimal64_t"

	self
		newProcedureNamed: #'pn_data_put_decimal64'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int pn_data_put_decimal128(pn_data_t *data, pn_decimal128_t d);"
	params := Array new: 2.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"
	params at: 2 put: ((VStructure structObj: struct_pn_decimal128_t) passedBy: #value). "pn_decimal128_t"

	self
		newProcedureNamed: #'pn_data_put_decimal128'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int pn_data_put_uuid(pn_data_t *data, pn_uuid_t u);"
	params := Array new: 2.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"
	params at: 2 put: ((VStructure structObj: struct_pn_uuid_t) passedBy: #value). "pn_uuid_t"

	self
		newProcedureNamed: #'pn_data_put_uuid'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int pn_data_put_binary(pn_data_t *data, pn_bytes_t bytes);"
	params := Array new: 2.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"
	params at: 2 put: ((VStructure structObj: struct_pn_bytes_t) passedBy: #value). "pn_bytes_t"

	self
		newProcedureNamed: #'pn_data_put_binary'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int pn_data_put_string(pn_data_t *data, pn_bytes_t string);"
	params := Array new: 2.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"
	params at: 2 put: ((VStructure structObj: struct_pn_bytes_t) passedBy: #value). "pn_bytes_t"

	self
		newProcedureNamed: #'pn_data_put_string'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int pn_data_put_symbol(pn_data_t *data, pn_bytes_t symbol);"
	params := Array new: 2.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"
	params at: 2 put: ((VStructure structObj: struct_pn_bytes_t) passedBy: #value). "pn_bytes_t"

	self
		newProcedureNamed: #'pn_data_put_symbol'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int pn_data_put_atom(pn_data_t *data, pn_atom_t atom);"
	params := Array new: 2.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"
	params at: 2 put: ((VStructure structObj: struct_pn_atom_t) passedBy: #value). "pn_atom_t"

	self
		newProcedureNamed: #'pn_data_put_atom'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN size_t pn_data_get_list(pn_data_t *data);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"

	self
		newProcedureNamed: #'pn_data_get_list'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN size_t pn_data_get_map(pn_data_t *data);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"

	self
		newProcedureNamed: #'pn_data_get_map'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN size_t pn_data_get_array(pn_data_t *data);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"

	self
		newProcedureNamed: #'pn_data_get_array'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN bool pn_data_is_array_described(pn_data_t *data);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"

	self
		newProcedureNamed: #'pn_data_is_array_described'
		paramVars: params	
		callingConvention: #C 
		returns: (VBoolean new).

	"PN_EXTERN pn_type_t pn_data_get_array_type(pn_data_t *data);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"

	self
		newProcedureNamed: #'pn_data_get_array_type'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN bool pn_data_is_described(pn_data_t *data);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"

	self
		newProcedureNamed: #'pn_data_is_described'
		paramVars: params	
		callingConvention: #C 
		returns: (VBoolean new).

	"PN_EXTERN bool pn_data_is_null(pn_data_t *data);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"

	self
		newProcedureNamed: #'pn_data_is_null'
		paramVars: params	
		callingConvention: #C 
		returns: (VBoolean new).

	"PN_EXTERN bool pn_data_get_bool(pn_data_t *data);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"

	self
		newProcedureNamed: #'pn_data_get_bool'
		paramVars: params	
		callingConvention: #C 
		returns: (VBoolean new).

	"PN_EXTERN uint8_t pn_data_get_ubyte(pn_data_t *data);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"

	self
		newProcedureNamed: #'pn_data_get_ubyte'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int8_t pn_data_get_byte(pn_data_t *data);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"

	self
		newProcedureNamed: #'pn_data_get_byte'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN uint16_t pn_data_get_ushort(pn_data_t *data);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"

	self
		newProcedureNamed: #'pn_data_get_ushort'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int16_t pn_data_get_short(pn_data_t *data);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"

	self
		newProcedureNamed: #'pn_data_get_short'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN uint32_t pn_data_get_uint(pn_data_t *data);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"

	self
		newProcedureNamed: #'pn_data_get_uint'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int32_t pn_data_get_int(pn_data_t *data);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"

	self
		newProcedureNamed: #'pn_data_get_int'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN pn_char_t pn_data_get_char(pn_data_t *data);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"

	self
		newProcedureNamed: #'pn_data_get_char'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN uint64_t pn_data_get_ulong(pn_data_t *data);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"

	self
		newProcedureNamed: #'pn_data_get_ulong'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int64_t pn_data_get_long(pn_data_t *data);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"

	self
		newProcedureNamed: #'pn_data_get_long'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN pn_timestamp_t pn_data_get_timestamp(pn_data_t *data);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"

	self
		newProcedureNamed: #'pn_data_get_timestamp'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN float pn_data_get_float(pn_data_t *data);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"

	self
		newProcedureNamed: #'pn_data_get_float'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN double pn_data_get_double(pn_data_t *data);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"

	self
		newProcedureNamed: #'pn_data_get_double'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN pn_decimal32_t pn_data_get_decimal32(pn_data_t *data);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"

	self
		newProcedureNamed: #'pn_data_get_decimal32'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN pn_decimal64_t pn_data_get_decimal64(pn_data_t *data);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"

	self
		newProcedureNamed: #'pn_data_get_decimal64'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN pn_decimal128_t pn_data_get_decimal128(pn_data_t *data);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"

	self
		newProcedureNamed: #'pn_data_get_decimal128'
		paramVars: params	
		callingConvention: #C 
		returns: (((VStructure structObj: struct_pn_decimal128_t) passedBy: #value)).

	"PN_EXTERN pn_uuid_t pn_data_get_uuid(pn_data_t *data);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"

	self
		newProcedureNamed: #'pn_data_get_uuid'
		paramVars: params	
		callingConvention: #C 
		returns: (((VStructure structObj: struct_pn_uuid_t) passedBy: #value)).

	"PN_EXTERN pn_bytes_t pn_data_get_binary(pn_data_t *data);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"

	self
		newProcedureNamed: #'pn_data_get_binary'
		paramVars: params	
		callingConvention: #C 
		returns: (((VStructure structObj: struct_pn_bytes_t) passedBy: #value)).

	"PN_EXTERN pn_bytes_t pn_data_get_string(pn_data_t *data);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"

	self
		newProcedureNamed: #'pn_data_get_string'
		paramVars: params	
		callingConvention: #C 
		returns: (((VStructure structObj: struct_pn_bytes_t) passedBy: #value)).

	"PN_EXTERN pn_bytes_t pn_data_get_symbol(pn_data_t *data);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"

	self
		newProcedureNamed: #'pn_data_get_symbol'
		paramVars: params	
		callingConvention: #C 
		returns: (((VStructure structObj: struct_pn_bytes_t) passedBy: #value)).

	"PN_EXTERN pn_bytes_t pn_data_get_bytes(pn_data_t *data);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"

	self
		newProcedureNamed: #'pn_data_get_bytes'
		paramVars: params	
		callingConvention: #C 
		returns: (((VStructure structObj: struct_pn_bytes_t) passedBy: #value)).

	"PN_EXTERN pn_atom_t pn_data_get_atom(pn_data_t *data);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"

	self
		newProcedureNamed: #'pn_data_get_atom'
		paramVars: params	
		callingConvention: #C 
		returns: (((VStructure structObj: struct_pn_atom_t) passedBy: #value)).

	"PN_EXTERN int pn_data_copy(pn_data_t *data, pn_data_t *src);"
	params := Array new: 2.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"
	params at: 2 put: VDWord new "Pointer". "pn_data_t*"

	self
		newProcedureNamed: #'pn_data_copy'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int pn_data_append(pn_data_t *data, pn_data_t *src);"
	params := Array new: 2.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"
	params at: 2 put: VDWord new "Pointer". "pn_data_t*"

	self
		newProcedureNamed: #'pn_data_append'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN int pn_data_appendn(pn_data_t *data, pn_data_t *src, int limit);"
	params := Array new: 3.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"
	params at: 2 put: VDWord new "Pointer". "pn_data_t*"
	params at: 3 put: VDWord new "Uknown". "int"

	self
		newProcedureNamed: #'pn_data_appendn'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN void pn_data_narrow(pn_data_t *data);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"

	self
		newProcedureNamed: #'pn_data_narrow'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN void pn_data_widen(pn_data_t *data);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"

	self
		newProcedureNamed: #'pn_data_widen'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN pn_handle_t pn_data_point(pn_data_t *data);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"

	self
		newProcedureNamed: #'pn_data_point'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").

	"PN_EXTERN bool pn_data_restore(pn_data_t *data, pn_handle_t point);"
	params := Array new: 2.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"
	params at: 2 put: VDWord new "Uknown". "pn_handle_t"

	self
		newProcedureNamed: #'pn_data_restore'
		paramVars: params	
		callingConvention: #C 
		returns: (VBoolean new).

	"PN_EXTERN void pn_data_dump(pn_data_t *data);"
	params := Array new: 1.
	params at: 1 put: VDWord new "Pointer". "pn_data_t*"

	self
		newProcedureNamed: #'pn_data_dump'
		paramVars: params	
		callingConvention: #C 
		returns: (VDWord new "Uknown").


!"end initializeCodec "


struct_pn_decimal128_t
	^struct_pn_decimal128_t.
!"end struct_pn_decimal128_t "


struct_pn_uuid_t
	^struct_pn_uuid_t.
!"end struct_pn_uuid_t "


struct_pn_bytes_t
	^struct_pn_bytes_t.
!"end struct_pn_bytes_t "


struct_pn_atom_t
	^struct_pn_atom_t.
!"end struct_pn_atom_t "


pn_code: code 
"
PN_EXTERN const char *pn_code(int code);
"
	^self call: #pn_code with: (Array with: code).
!"end pn_code: code  "


pn_error
"
PN_EXTERN pn_error_t *pn_error(void);
"
	^self call: #pn_error with: Array new.
!"end pn_error "


pn_error_free: error 
"
PN_EXTERN void pn_error_free(pn_error_t *error);
"
	^self call: #pn_error_free with: (Array with: error).
!"end pn_error_free: error  "


pn_error_clear: error 
"
PN_EXTERN void pn_error_clear(pn_error_t *error);
"
	^self call: #pn_error_clear with: (Array with: error).
!"end pn_error_clear: error  "


pn_error_set: error with: code with: text 
"
PN_EXTERN int pn_error_set(pn_error_t *error, int code, const char *text);
"
	^self call: #pn_error_set with: (Array with: error with: code with: text).
!"end pn_error_set: error with: code with: text  "


pn_error_vformat: error with: code with: fmt with: ap 
"
PN_EXTERN int pn_error_vformat(pn_error_t *error, int code, const char *fmt, va_list ap);
"
	^self call: #pn_error_vformat with: (Array with: error with: code with: fmt with: ap).
!"end pn_error_vformat: error with: code with: fmt with: ap  "


pn_error_format: error with: code with: fmt with: list 
"
PN_EXTERN int pn_error_format(pn_error_t *error, int code, const char *fmt, ...);
"
	^self call: #pn_error_format with: (Array with: error with: code with: fmt with: list).
!"end pn_error_format: error with: code with: fmt with: list  "


pn_error_code: error 
"
PN_EXTERN int pn_error_code(pn_error_t *error);
"
	^self call: #pn_error_code with: (Array with: error).
!"end pn_error_code: error  "


pn_error_text: error 
"
PN_EXTERN const char *pn_error_text(pn_error_t *error);
"
	^self call: #pn_error_text with: (Array with: error).
!"end pn_error_text: error  "


pn_error_copy: error with: src 
"
PN_EXTERN int pn_error_copy(pn_error_t *error, pn_error_t *src);
"
	^self call: #pn_error_copy with: (Array with: error with: src).
!"end pn_error_copy: error with: src  "


pn_messenger: name 
" Construct a new ::pn_messenger_t with the given name. The name is
 global. If a NULL name is supplied, a UUID based name will be
 chosen.

 @param[in] name the name of the messenger or NULL

 @return pointer to a new ::pn_messenger_t

PN_EXTERN pn_messenger_t *pn_messenger(const char *name);
"
	^self call: #pn_messenger with: (Array with: name).
!"end pn_messenger: name  "


pn_messenger_name: messenger 
" Get the name of a messenger.

 @param[in] messenger a messenger object
 @return the name of the messenger

PN_EXTERN const char *pn_messenger_name(pn_messenger_t *messenger);
"
	^self call: #pn_messenger_name with: (Array with: messenger).
!"end pn_messenger_name: messenger  "


pn_messenger_set_certificate: messenger with: certificate 
" Sets the path that will be used to get the certificate that will be
 used to identify this messenger to its peers. The validity of the
 path is not checked by this function.

 @param[in] messenger the messenger
 @param[in] certificate a path to a certificate file
 @return an error code of zero if there is no error

PN_EXTERN int pn_messenger_set_certificate(pn_messenger_t *messenger, const char *certificate);
"
	^self call: #pn_messenger_set_certificate with: (Array with: messenger with: certificate).
!"end pn_messenger_set_certificate: messenger with: certificate  "


pn_messenger_get_certificate: messenger 
" Get the certificate path. This value may be set by
 pn_messenger_set_certificate. The default certificate path is null.

 @param[in] messenger the messenger
 @return the certificate file path

PN_EXTERN const char *pn_messenger_get_certificate(pn_messenger_t *messenger);
"
	^self call: #pn_messenger_get_certificate with: (Array with: messenger).
!"end pn_messenger_get_certificate: messenger  "


pn_messenger_set_private_key: messenger with: private_key 
" Set path to the private key that was used to sign the certificate.
 See ::pn_messenger_set_certificate

 @param[in] messenger a messenger object
 @param[in] private_key a path to a private key file
 @return an error code of zero if there is no error

PN_EXTERN int pn_messenger_set_private_key(pn_messenger_t *messenger, const char *private_key);
"
	^self call: #pn_messenger_set_private_key with: (Array with: messenger with: private_key).
!"end pn_messenger_set_private_key: messenger with: private_key  "


pn_messenger_get_private_key: messenger 
" Gets the private key file for a messenger.

 @param[in] messenger a messenger object
 @return the messenger's private key file path

PN_EXTERN const char *pn_messenger_get_private_key(pn_messenger_t *messenger);
"
	^self call: #pn_messenger_get_private_key with: (Array with: messenger).
!"end pn_messenger_get_private_key: messenger  "


pn_messenger_set_password: messenger with: password 
" Sets the private key password for a messenger.

 @param[in] messenger a messenger object
 @param[in] password the password for the private key file

 @return an error code of zero if there is no error

PN_EXTERN int pn_messenger_set_password(pn_messenger_t *messenger, const char *password);
"
	^self call: #pn_messenger_set_password with: (Array with: messenger with: password).
!"end pn_messenger_set_password: messenger with: password  "


pn_messenger_get_password: messenger 
" Gets the private key file password for a messenger.

 @param[in] messenger a messenger object
 @return password for the private key file

PN_EXTERN const char *pn_messenger_get_password(pn_messenger_t *messenger);
"
	^self call: #pn_messenger_get_password with: (Array with: messenger).
!"end pn_messenger_get_password: messenger  "


pn_messenger_set_trusted_certificates: messenger with: cert_db 
" Sets the trusted certificates database for a messenger.

 The messenger will use this database to validate the certificate
 provided by the peer.

 @param[in] messenger a messenger object
 @param[in] cert_db a path to the certificates database

 @return an error code of zero if there is no error

PN_EXTERN int pn_messenger_set_trusted_certificates(pn_messenger_t *messenger, const char *cert_db);
"
	^self call: #pn_messenger_set_trusted_certificates with: (Array with: messenger with: cert_db).
!"end pn_messenger_set_trusted_certificates: messenger with: cert_db  "


pn_messenger_get_trusted_certificates: messenger 
" Gets the trusted certificates database for a messenger.

 @param[in] messenger a messenger object
 @return path to the trusted certificates database

PN_EXTERN const char *pn_messenger_get_trusted_certificates(pn_messenger_t *messenger);
"
	^self call: #pn_messenger_get_trusted_certificates with: (Array with: messenger).
!"end pn_messenger_get_trusted_certificates: messenger  "


pn_messenger_set_timeout: messenger with: timeout 
" Set the default timeout for a messenger.

 Any messenger call that blocks during execution will stop blocking
 and return control when this timeout is reached, if you have set it
 to a value greater than zero. The timeout is expressed in
 milliseconds.

 @param[in] messenger a messenger object
 @param[in] timeout a new timeout for the messenger, in milliseconds
 @return an error code or zero if there is no error

PN_EXTERN int pn_messenger_set_timeout(pn_messenger_t *messenger, int timeout);
"
	^self call: #pn_messenger_set_timeout with: (Array with: messenger with: timeout).
!"end pn_messenger_set_timeout: messenger with: timeout  "


pn_messenger_get_timeout: messenger 
" Gets the timeout for a messenger object.

 See ::pn_messenger_set_timeout() for details.

 @param[in] messenger a messenger object
 @return the timeout for the messenger, in milliseconds

PN_EXTERN int pn_messenger_get_timeout(pn_messenger_t *messenger);
"
	^self call: #pn_messenger_get_timeout with: (Array with: messenger).
!"end pn_messenger_get_timeout: messenger  "


pn_messenger_is_blocking: messenger 
" Check if a messenger is in blocking mode.

 @param[in] messenger a messenger object
 @return true if blocking has been enabled, false otherwise

PN_EXTERN bool pn_messenger_is_blocking(pn_messenger_t *messenger);
"
	^self call: #pn_messenger_is_blocking with: (Array with: messenger).
!"end pn_messenger_is_blocking: messenger  "


pn_messenger_set_blocking: messenger with: blocking 
" Enable or disable blocking behavior for a messenger during calls to
 ::pn_messenger_send and ::pn_messenger_recv.

 @param[in] messenger a messenger object
 @param[in] blocking the value of the blocking flag
 @return an error code or zero if there is no error

PN_EXTERN int pn_messenger_set_blocking(pn_messenger_t *messenger, bool blocking);
"
	^self call: #pn_messenger_set_blocking with: (Array with: messenger with: blocking).
!"end pn_messenger_set_blocking: messenger with: blocking  "


pn_messenger_is_passive: messenger 
" Check if a messenger is in passive mode.

 A messenger that is in passive mode will never attempt to perform
 I/O internally, but instead will make all internal file descriptors
 accessible through ::pn_messenger_selectable() to be serviced
 externally. This can be useful for integrating messenger into an
 external event loop.

 @param[in] messenger a messenger object
 @return true if the messenger is in passive mode, false otherwise

PN_EXTERN bool pn_messenger_is_passive(pn_messenger_t *messenger);
"
	^self call: #pn_messenger_is_passive with: (Array with: messenger).
!"end pn_messenger_is_passive: messenger  "


pn_messenger_set_passive: messenger with: passive 
" Set the passive mode for a messenger.

 See ::pn_messenger_is_passive() for details on passive mode.

 @param[in] messenger a messenger object
 @param[in] passive true to enable passive mode, false to disable
 passive mode
 @return an error code or zero on success

PN_EXTERN int pn_messenger_set_passive(pn_messenger_t *messenger, bool passive);
"
	^self call: #pn_messenger_set_passive with: (Array with: messenger with: passive).
!"end pn_messenger_set_passive: messenger with: passive  "


pn_messenger_free: messenger 
"
 @param[in] messenger the messenger to free (or NULL), no longer
                      valid on return

PN_EXTERN void pn_messenger_free(pn_messenger_t *messenger);
"
	^self call: #pn_messenger_free with: (Array with: messenger).
!"end pn_messenger_free: messenger  "


pn_messenger_errno: messenger 
" Get the code for a messenger's most recent error.

 The error code is initialized to zero at messenger creation. The
 error number is 'sticky' i.e. error codes are not reset to 0 at the
 end of successful API calls. You can use ::pn_messenger_error to
 access the messenger's error object and clear explicitly if
 desired.

 @param[in] messenger the messenger to check for errors
 @return an error code or zero if there is no error
 @see error.h

PN_EXTERN int pn_messenger_errno(pn_messenger_t *messenger);
"
	^self call: #pn_messenger_errno with: (Array with: messenger).
!"end pn_messenger_errno: messenger  "


pn_messenger_error: messenger 
" Get a messenger's error object.

 Returns a pointer to a pn_error_t that is valid until the messenger
 is freed. The pn_error_* API allows you to access the text, error
 number, and lets you set or clear the error code explicitly.

 @param[in] messenger the messenger to check for errors
 @return a pointer to the messenger's error descriptor
 @see error.h

PN_EXTERN pn_error_t *pn_messenger_error(pn_messenger_t *messenger);
"
	^self call: #pn_messenger_error with: (Array with: messenger).
!"end pn_messenger_error: messenger  "


pn_messenger_get_outgoing_window: messenger 
" Get the size of a messenger's outgoing window.

 The size of the outgoing window limits the number of messages whose
 status you can check with a tracker. A message enters this window
 when you call pn_messenger_put on the message. For example, if your
 outgoing window size is 10, and you call pn_messenger_put 12 times,
 new status information will no longer be available for the first 2
 messages.

 The default outgoing window size is 0.

 @param[in] messenger a messenger object
 @return the outgoing window for the messenger

PN_EXTERN int pn_messenger_get_outgoing_window(pn_messenger_t *messenger);
"
	^self call: #pn_messenger_get_outgoing_window with: (Array with: messenger).
!"end pn_messenger_get_outgoing_window: messenger  "


pn_messenger_set_outgoing_window: messenger with: window 
" Set the size of a messenger's outgoing window.

 See ::pn_messenger_get_outgoing_window() for details.

 @param[in] messenger a messenger object
 @param[in] window the number of deliveries to track
 @return an error or zero on success
 @see error.h

PN_EXTERN int pn_messenger_set_outgoing_window(pn_messenger_t *messenger, int window);
"
	^self call: #pn_messenger_set_outgoing_window with: (Array with: messenger with: window).
!"end pn_messenger_set_outgoing_window: messenger with: window  "


pn_messenger_get_incoming_window: messenger 
" Get the size of a messenger's incoming window.

 The size of a messenger's incoming window limits the number of
 messages that can be accepted or rejected using trackers. Messages
do not* enter this window when they have been received
 (::pn_messenger_recv) onto you incoming queue. Messages only enter
 this window only when you access them using pn_messenger_get. If
 your incoming window size is N, and you get N+1 messages without
 explicitly accepting or rejecting the oldest message, then it will
 be implicitly accepted when it falls off the edge of the incoming
 window.

 The default incoming window size is 0.

 @param[in] messenger a messenger object
 @return the incoming window for the messenger

PN_EXTERN int pn_messenger_get_incoming_window(pn_messenger_t *messenger);
"
	^self call: #pn_messenger_get_incoming_window with: (Array with: messenger).
!"end pn_messenger_get_incoming_window: messenger  "


pn_messenger_set_incoming_window: messenger with: window 
" Set the size of a messenger's incoming window.

 See ::pn_messenger_get_incoming_window() for details.

 @param[in] messenger a messenger object
 @param[in] window the number of deliveries to track
 @return an error or zero on success
 @see error.h

PN_EXTERN int pn_messenger_set_incoming_window(pn_messenger_t *messenger, int window);
"
	^self call: #pn_messenger_set_incoming_window with: (Array with: messenger with: window).
!"end pn_messenger_set_incoming_window: messenger with: window  "


pn_messenger_start: messenger 
" Currently a no-op placeholder. For future compatibility, do not
 send or receive messages before starting the messenger.

 @param[in] messenger the messenger to start
 @return an error code or zero on success
 @see error.h

PN_EXTERN int pn_messenger_start(pn_messenger_t *messenger);
"
	^self call: #pn_messenger_start with: (Array with: messenger).
!"end pn_messenger_start: messenger  "


pn_messenger_stop: messenger 
" Stops a messenger.

 Stopping a messenger will perform an orderly shutdown of all
 underlying connections. This may require some time. If the
 messenger is in non blocking mode (see ::pn_messenger_is_blocking),
 this operation will return PN_INPROGRESS if it cannot finish
 immediately. In that case, you can use ::pn_messenger_stopped() to
 determine when the messenger has finished stopping.

 @param[in] messenger the messenger to stop
 @return an error code or zero on success
 @see error.h

PN_EXTERN int pn_messenger_stop(pn_messenger_t *messenger);
"
	^self call: #pn_messenger_stop with: (Array with: messenger).
!"end pn_messenger_stop: messenger  "


pn_messenger_stopped: messenger 
" Returns true if a messenger is in the stopped state. This function
 does not block.

 @param[in] messenger the messenger to stop


PN_EXTERN bool pn_messenger_stopped(pn_messenger_t *messenger);
"
	^self call: #pn_messenger_stopped with: (Array with: messenger).
!"end pn_messenger_stopped: messenger  "


pn_messenger_subscribe: messenger with: source 
" Subscribes a messenger to messages from the specified source.

 @param[in] messenger the messenger to subscribe
 @param[in] source
 @return a subscription

PN_EXTERN pn_subscription_t *pn_messenger_subscribe(pn_messenger_t *messenger, const char *source);
"
	^self call: #pn_messenger_subscribe with: (Array with: messenger with: source).
!"end pn_messenger_subscribe: messenger with: source  "


pn_messenger_subscribe_ttl: messenger with: source with: timeout 
" Subscribes a messenger to messages from the specified source with the given
 timeout for the subscription's lifetime.

 @param[in] messenger the messenger to subscribe
 @param[in] source
 @param[in] timeout the maximum time to keep the subscription alive once the
            link is closed.
 @return a subscription

PN_EXTERN pn_subscription_t * pn_messenger_subscribe_ttl(pn_messenger_t *messenger, const char *source, pn_seconds_t timeout);
"
	^self call: #pn_messenger_subscribe_ttl with: (Array with: messenger with: source with: timeout).
!"end pn_messenger_subscribe_ttl: messenger with: source with: timeout  "


pn_messenger_get_link: messenger with: address with: sender 
" Get a link based on link name and whether the link is a sender or receiver

 @param[in] messenger the messenger to get the link from
 @param[in] address the link address that identifies the link to receive
 @param[in] sender true if the link is a sender, false if the link is a
            receiver
 @return a link, or NULL if no link matches the address / sender parameters

PN_EXTERN pn_link_t *pn_messenger_get_link(pn_messenger_t *messenger, const char *address, bool sender);
"
	^self call: #pn_messenger_get_link with: (Array with: messenger with: address with: sender).
!"end pn_messenger_get_link: messenger with: address with: sender  "


pn_subscription_get_context: sub 
" Get a subscription's application context.

 See ::pn_subscription_set_context().

 @param[in] sub a subscription object
 @return the subscription's application context

PN_EXTERN void *pn_subscription_get_context(pn_subscription_t *sub);
"
	^self call: #pn_subscription_get_context with: (Array with: sub).
!"end pn_subscription_get_context: sub  "


pn_subscription_set_context: sub with: context 
" Set an application context for a subscription.

 @param[in] sub a subscription object
 @param[in] context the application context for the subscription

PN_EXTERN void pn_subscription_set_context(pn_subscription_t *sub, void *context);
"
	^self call: #pn_subscription_set_context with: (Array with: sub with: context).
!"end pn_subscription_set_context: sub with: context  "


pn_subscription_address: sub 
" Get the source address of a subscription.

 @param[in] sub a subscription object
 @return the subscription's source address

PN_EXTERN const char *pn_subscription_address(pn_subscription_t *sub);
"
	^self call: #pn_subscription_address with: (Array with: sub).
!"end pn_subscription_address: sub  "


pn_messenger_put: messenger with: msg 
" Puts a message onto the messenger's outgoing queue. The message may
 also be sent if transmission would not cause blocking. This call
 will not block.

 @param[in] messenger a messenger object
 @param[in] msg a message to put on the messenger's outgoing queue
 @return an error code or zero on success
 @see error.h

PN_EXTERN int pn_messenger_put(pn_messenger_t *messenger, pn_message_t *msg);
"
	^self call: #pn_messenger_put with: (Array with: messenger with: msg).
!"end pn_messenger_put: messenger with: msg  "


pn_messenger_status: messenger with: tracker 
" Track the status of a delivery.

 Get the current status of the delivery associated with the supplied
 tracker. This may return PN_STATUS_UNKOWN if the tracker has fallen
 outside the incoming/outgoing tracking windows of the messenger.

 @param[in] messenger the messenger
 @param[in] tracker the tracker identifying the delivery
 @return a status code for the delivery

PN_EXTERN pn_status_t pn_messenger_status(pn_messenger_t *messenger, pn_tracker_t tracker);
"
	^self call: #pn_messenger_status with: (Array with: messenger with: tracker).
!"end pn_messenger_status: messenger with: tracker  "


pn_messenger_delivery: messenger with: tracker 
" Get delivery information about a delivery.

 Returns the delivery information associated with the supplied tracker.
 This may return NULL if the tracker has fallen outside the
 incoming/outgoing tracking windows of the messenger.

 @param[in] messenger the messenger
 @param[in] tracker the tracker identifying the delivery
 @return a pn_delivery_t representing the delivery.

PN_EXTERN pn_delivery_t *pn_messenger_delivery(pn_messenger_t *messenger, pn_tracker_t tracker);
"
	^self call: #pn_messenger_delivery with: (Array with: messenger with: tracker).
!"end pn_messenger_delivery: messenger with: tracker  "


pn_messenger_buffered: messenger with: tracker 
" Check if the delivery associated with a given tracker is still
 waiting to be sent.

 Note that returning false does not imply that the delivery was
 actually sent over the wire.

 @param[in] messenger the messenger
 @param[in] tracker the tracker identifying the delivery

 @return true if the delivery is still buffered

PN_EXTERN bool pn_messenger_buffered(pn_messenger_t *messenger, pn_tracker_t tracker);
"
	^self call: #pn_messenger_buffered with: (Array with: messenger with: tracker).
!"end pn_messenger_buffered: messenger with: tracker  "


pn_messenger_settle: messenger with: tracker with: flags 
" Frees a Messenger from tracking the status associated with a given
 tracker. Use the PN_CUMULATIVE flag to indicate everything up to
 (and including) the given tracker.

 @param[in] messenger the Messenger
 @param[in] tracker identifies a delivery
 @param[in] flags 0 or PN_CUMULATIVE

 @return an error code or zero on success
 @see error.h

PN_EXTERN int pn_messenger_settle(pn_messenger_t *messenger, pn_tracker_t tracker, int flags);
"
	^self call: #pn_messenger_settle with: (Array with: messenger with: tracker with: flags).
!"end pn_messenger_settle: messenger with: tracker with: flags  "


pn_messenger_outgoing_tracker: messenger 
" Get a tracker for the outgoing message most recently given to
 pn_messenger_put.

 This tracker may be used with pn_messenger_status to determine the
 delivery status of the message, as long as the message is still
 within your outgoing window.

 @param[in] messenger the messenger

 @return a pn_tracker_t or an undefined value if pn_messenger_get
         has never been called for the given messenger

PN_EXTERN pn_tracker_t pn_messenger_outgoing_tracker(pn_messenger_t *messenger);
"
	^self call: #pn_messenger_outgoing_tracker with: (Array with: messenger).
!"end pn_messenger_outgoing_tracker: messenger  "


pn_messenger_work: messenger with: timeout 
" Sends or receives any outstanding messages queued for a messenger.
 This will block for the indicated timeout.

 @param[in] messenger the Messenger
 @param[in] timeout the maximum time to block in milliseconds, -1 ==
 forever, 0 == do not block

 @return 0 if no work to do, < 0 if error, or 1 if work was done.

PN_EXTERN int pn_messenger_work(pn_messenger_t *messenger, int timeout);
"
	^self call: #pn_messenger_work with: (Array with: messenger with: timeout).
!"end pn_messenger_work: messenger with: timeout  "


pn_messenger_interrupt: messenger 
" Interrupt a messenger object that may be blocking in another
 thread.

 The messenger interface is single-threaded. This is the only
 messenger function intended to be concurrently called from another
 thread. It will interrupt any messenger function which is currently
 blocking and cause it to return with a status of ::PN_INTR.

 @param[in] messenger the Messenger to interrupt

PN_EXTERN int pn_messenger_interrupt(pn_messenger_t *messenger);
"
	^self call: #pn_messenger_interrupt with: (Array with: messenger).
!"end pn_messenger_interrupt: messenger  "


pn_messenger_send: messenger with: n 
" Send messages from a messenger's outgoing queue.

 If a messenger is in blocking mode (see
 ::pn_messenger_is_blocking()), this operation will block until N
 messages have been sent from the outgoing queue. A value of -1 for
 N means 'all messages in the outgoing queue'. See below for a full
 definition of what sent from the outgoing queue means.

 Any blocking will end once the messenger's configured timeout (if
 any) has been reached. When this happens an error code of
 ::PN_TIMEOUT is returned.

 If the messenger is in non blocking mode, this call will return an
 error code of ::PN_INPROGRESS if it is unable to send the requested
 number of messages without blocking.

 A message is considered to be sent from the outgoing queue when its
 status has been fully determined. This does not necessarily mean
 the message was successfully sent to the final recipient though,
 for example of the receiver rejects the message, the final status
 will be ::PN_STATUS_REJECTED. Similarly, if a message is sent to an
 invalid address, it may be removed from the outgoing queue without
 ever even being transmitted. In this case the final status will be
 ::PN_STATUS_ABORTED.

 @param[in] messenger a messenger object
 @param[in] n the number of messages to send

 @return an error code or zero on success
 @see error.h

PN_EXTERN int pn_messenger_send(pn_messenger_t *messenger, int n);
"
	^self call: #pn_messenger_send with: (Array with: messenger with: n).
!"end pn_messenger_send: messenger with: n  "


pn_messenger_recv: messenger with: limit 
" Retrieve messages into a messenger's incoming queue.

 Instructs a messenger to receive up to @c limit messages into the
 incoming message queue of a messenger. If @c limit is -1, the
 messenger will receive as many messages as it can buffer
 internally. If the messenger is in blocking mode, this call will
 block until at least one message is available in the incoming
 queue.

 Each call to pn_messenger_recv replaces the previous receive
 operation, so pn_messenger_recv(messenger, 0) will cancel any
 outstanding receive.

 After receiving messages onto your incoming queue use
 ::pn_messenger_get() to access message content.

 @param[in] messenger the messenger
 @param[in] limit the maximum number of messages to receive or -1 to
                  to receive as many messages as it can buffer
                  internally.
 @return an error code or zero on success
 @see error.h

PN_EXTERN int pn_messenger_recv(pn_messenger_t *messenger, int limit);
"
	^self call: #pn_messenger_recv with: (Array with: messenger with: limit).
!"end pn_messenger_recv: messenger with: limit  "


pn_messenger_receiving: messenger 
" Get the capacity of the incoming message queue of a messenger.

 Note this count does not include those messages already available
 on the incoming queue (@see pn_messenger_incoming()). Rather it
 returns the number of incoming queue entries available for
 receiving messages.

 @param[in] messenger the messenger

PN_EXTERN int pn_messenger_receiving(pn_messenger_t *messenger);
"
	^self call: #pn_messenger_receiving with: (Array with: messenger).
!"end pn_messenger_receiving: messenger  "


pn_messenger_get: messenger with: message 
" Get the next message from the head of a messenger's incoming queue.

 The get operation copies the message data from the head of the
 messenger's incoming queue into the provided ::pn_message_t object.
 If provided ::pn_message_t pointer is NULL, the head essage will be
 discarded. This operation will return ::PN_EOS if there are no
 messages left on the incoming queue.

 @param[in] messenger a messenger object
 @param[out] message upon return contains the message from the head of the queue
 @return an error code or zero on success
 @see error.h

PN_EXTERN int pn_messenger_get(pn_messenger_t *messenger, pn_message_t *message);
"
	^self call: #pn_messenger_get with: (Array with: messenger with: message).
!"end pn_messenger_get: messenger with: message  "


pn_messenger_incoming_tracker: messenger 
" Get a tracker for the message most recently retrieved by
 ::pn_messenger_get().

 A tracker for an incoming message allows you to accept or reject
 the associated message. It can also be used for cumulative
 accept/reject operations for the associated message and all prior
 messages as well.

 @param[in] messenger a messenger object
 @return a pn_tracker_t or an undefined value if pn_messenger_get
         has never been called for the given messenger

PN_EXTERN pn_tracker_t pn_messenger_incoming_tracker(pn_messenger_t *messenger);
"
	^self call: #pn_messenger_incoming_tracker with: (Array with: messenger).
!"end pn_messenger_incoming_tracker: messenger  "


pn_messenger_incoming_subscription: messenger 
" Get the subscription of the message most recently retrieved by ::pn_messenger_get().

 This operation will return NULL if ::pn_messenger_get() has never
 been succesfully called.

 @param[in] messenger a messenger object
 @return a pn_subscription_t or NULL

PN_EXTERN pn_subscription_t *pn_messenger_incoming_subscription(pn_messenger_t *messenger);
"
	^self call: #pn_messenger_incoming_subscription with: (Array with: messenger).
!"end pn_messenger_incoming_subscription: messenger  "


pn_messenger_accept: messenger with: tracker with: flags 
" Signal successful processing of message(s).

 With no flags this operation will signal the sender that the
 message referenced by the tracker was accepted. If the
 PN_CUMULATIVE flag is set, this operation will also reject all
 pending messages prior to the message indicated by the tracker.

 Note that when a message is accepted or rejected multiple times,
 either explicitly, or implicitly through use of the ::PN_CUMULATIVE
 flag, only the first outcome applies. For example if a sequence of
 three messages are received: M1, M2, M3, and M2 is rejected, and M3
 is cumulatively accepted, M2 will remain rejected and only M1 and
 M3 will be considered accepted.

 @param[in] messenger a messenger object
 @param[in] tracker an incoming tracker
 @param[in] flags 0 or PN_CUMULATIVE
 @return an error code or zero on success
 @see error.h

PN_EXTERN int pn_messenger_accept(pn_messenger_t *messenger, pn_tracker_t tracker, int flags);
"
	^self call: #pn_messenger_accept with: (Array with: messenger with: tracker with: flags).
!"end pn_messenger_accept: messenger with: tracker with: flags  "


pn_messenger_reject: messenger with: tracker with: flags 
" Signal unsuccessful processing of message(s).

 With no flags this operation will signal the sender that the
 message indicated by the tracker was rejected. If the PN_CUMULATIVE
 flag is used this operation will also reject all pending messages
 prior to the message indicated by the tracker.

 Note that when a message is accepted or rejected multiple times,
 either explicitly, or implicitly through use of the ::PN_CUMULATIVE
 flag, only the first outcome applies. For example if a sequence of
 three messages are received: M1, M2, M3, and M2 is accepted, and M3
 is cumulatively rejected, M2 will remain accepted and only M1 and
 M3 will be considered rejected.

 @param[in] messenger a messenger object
 @param[in] tracker an incoming tracker
 @param[in] flags 0 or PN_CUMULATIVE
 @return an error code or zero on success
 @see error.h

PN_EXTERN int pn_messenger_reject(pn_messenger_t *messenger, pn_tracker_t tracker, int flags);
"
	^self call: #pn_messenger_reject with: (Array with: messenger with: tracker with: flags).
!"end pn_messenger_reject: messenger with: tracker with: flags  "


pn_messenger_tracker_link: messenger with: tracker 
" Get  link for the message referenced by the given tracker.

 @param[in] messenger a messenger object
 @param[in] tracker a tracker object
 @return a pn_link_t or NULL if the link could not be determined.

PN_EXTERN pn_link_t *pn_messenger_tracker_link(pn_messenger_t *messenger, pn_tracker_t tracker);
"
	^self call: #pn_messenger_tracker_link with: (Array with: messenger with: tracker).
!"end pn_messenger_tracker_link: messenger with: tracker  "


pn_messenger_outgoing: messenger 
" Get the number of messages in the outgoing message queue of a
 messenger.

 @param[in] messenger a messenger object
 @return the outgoing queue depth

PN_EXTERN int pn_messenger_outgoing(pn_messenger_t *messenger);
"
	^self call: #pn_messenger_outgoing with: (Array with: messenger).
!"end pn_messenger_outgoing: messenger  "


pn_messenger_incoming: messenger 
" Get the number of messages in the incoming message queue of a messenger.

 @param[in] messenger a messenger object
 @return the incoming queue depth

PN_EXTERN int pn_messenger_incoming(pn_messenger_t *messenger);
"
	^self call: #pn_messenger_incoming with: (Array with: messenger).
!"end pn_messenger_incoming: messenger  "


pn_messenger_route: messenger with: pattern with: address 
"
PN_EXTERN int pn_messenger_route(pn_messenger_t *messenger, const char *pattern, const char *address);
"
	^self call: #pn_messenger_route with: (Array with: messenger with: pattern with: address).
!"end pn_messenger_route: messenger with: pattern with: address  "


pn_messenger_rewrite: messenger with: pattern with: address 
" Rewrite message addresses prior to transmission.

 This operation is similar to pn_messenger_route, except that the
 destination of the message is determined before the message address
 is rewritten.

 The outgoing address is only rewritten after routing has been
 finalized.  If a message has an outgoing address of
 'amqp://0.0.0.0:5678', and a rewriting rule that changes its
 outgoing address to 'foo', it will still arrive at the peer that
 is listening on 'amqp://0.0.0.0:5678', but when it arrives there,
 the receiver will see its outgoing address as 'foo'.

 The default rewrite rule removes username and password from
 addresses before they are transmitted.

 @param[in] messenger a messenger object
 @param[in] pattern a glob pattern to select messages
 @param[in] address an address indicating outgoing address rewrite
 @return an error code or zero on success

PN_EXTERN int pn_messenger_rewrite(pn_messenger_t *messenger, const char *pattern, const char *address);
"
	^self call: #pn_messenger_rewrite with: (Array with: messenger with: pattern with: address).
!"end pn_messenger_rewrite: messenger with: pattern with: address  "


pn_messenger_selectable: messenger 
" Extract @link pn_selectable_t selectables @endlink from a passive
 messenger.

 A messenger that is in passive mode (see
 ::pn_messenger_is_passive()) will never attempt to perform any I/O
 internally, but instead make its internal file descriptors
 available for external processing via the
 ::pn_messenger_selectable() operation.

 An application wishing to perform I/O on behalf of a passive
 messenger must extract all available selectables by calling this
 operation until it returns NULL. The ::pn_selectable_t interface
 may then be used by the application to perform I/O outside the
 messenger.

 All selectables returned by this operation must be serviced until
 they reach a terminal state and then freed. See
 ::pn_selectable_is_terminal() for more details.

 By default any given selectable will only ever be returned once by
 this operation, however if the selectable's registered flag is set
 to true (see ::pn_selectable_set_registered()), then the selectable
 will be returned whenever its interest set may have changed.

 @param[in] messenger a messenger object
 @return the next selectable, or NULL if there are none left

PN_EXTERN pn_selectable_t *pn_messenger_selectable(pn_messenger_t *messenger);
"
	^self call: #pn_messenger_selectable with: (Array with: messenger).
!"end pn_messenger_selectable: messenger  "


pn_messenger_deadline: messenger 
" Get the nearest deadline for selectables associated with a messenger.

 @param[in] messenger a messenger object
 @return the nearest deadline

PN_EXTERN pn_timestamp_t pn_messenger_deadline(pn_messenger_t *messenger);
"
	^self call: #pn_messenger_deadline with: (Array with: messenger).
!"end pn_messenger_deadline: messenger  "


pn_messenger_set_flags: messenger with: flags 
"
 @param[in] messenger the messenger
 @param[in] flags 0 or PN_FLAGS_CHECK_ROUTES

 @return an error code of zero if there is no error

PN_EXTERN int pn_messenger_set_flags(pn_messenger_t *messenger, const int flags);
"
	^self call: #pn_messenger_set_flags with: (Array with: messenger with: flags).
!"end pn_messenger_set_flags: messenger with: flags  "


pn_messenger_get_flags: messenger 
"
 @param[in] messenger the messenger
 @return The flags set for the messenger

PN_EXTERN int pn_messenger_get_flags(pn_messenger_t *messenger);
"
	^self call: #pn_messenger_get_flags with: (Array with: messenger).
!"end pn_messenger_get_flags: messenger  "


pn_messenger_set_snd_settle_mode: messenger with: mode 
" Set the local sender settle mode for the underlying link.

 @param[in] messenger the messenger
 @param[in] mode the sender settle mode

PN_EXTERN int pn_messenger_set_snd_settle_mode(pn_messenger_t *messenger, const pn_snd_settle_mode_t mode);
"
	^self call: #pn_messenger_set_snd_settle_mode with: (Array with: messenger with: mode).
!"end pn_messenger_set_snd_settle_mode: messenger with: mode  "


pn_messenger_set_rcv_settle_mode: messenger with: mode 
" Set the local receiver settle mode for the underlying link.

 @param[in] messenger the messenger
 @param[in] mode the receiver settle mode

PN_EXTERN int pn_messenger_set_rcv_settle_mode(pn_messenger_t *messenger, const pn_rcv_settle_mode_t mode);
"
	^self call: #pn_messenger_set_rcv_settle_mode with: (Array with: messenger with: mode).
!"end pn_messenger_set_rcv_settle_mode: messenger with: mode  "


pn_messenger_set_tracer: messenger with: tracer 
" Set the tracer associated with a messenger.

 @param[in] messenger a messenger object
 @param[in] tracer the tracer callback

PN_EXTERN void pn_messenger_set_tracer(pn_messenger_t *messenger, pn_tracer_t tracer);
"
	^self call: #pn_messenger_set_tracer with: (Array with: messenger with: tracer).
!"end pn_messenger_set_tracer: messenger with: tracer  "


pn_messenger_get_remote_idle_timeout: messenger with: address 
" Gets the remote idle timeout for the specified remote service address

 @param[in] messenger a messenger object
 @param[in] address of remote service whose idle timeout is required
 @return the timeout in milliseconds or -1 if an error occurs

PN_EXTERN pn_millis_t pn_messenger_get_remote_idle_timeout(pn_messenger_t *messenger, const char *address);
"
	^self call: #pn_messenger_get_remote_idle_timeout with: (Array with: messenger with: address).
!"end pn_messenger_get_remote_idle_timeout: messenger with: address  "


pn_messenger_set_ssl_peer_authentication_mode: messenger with: mode 
" Sets the SSL peer authentiacation mode required when a trust
 certificate is used.

 @param[in] messenger a messenger object
 @param[in] mode the mode required (see pn_ssl_verify_mode_t
             enum for valid values)
 @return 0 if successful or -1 if an error occurs

PN_EXTERN int pn_messenger_set_ssl_peer_authentication_mode(pn_messenger_t *messenger, const pn_ssl_verify_mode_t mode);
"
	^self call: #pn_messenger_set_ssl_peer_authentication_mode with: (Array with: messenger with: mode).
!"end pn_messenger_set_ssl_peer_authentication_mode: messenger with: mode  "


pn_message
" Construct a new ::pn_message_t.

 Every message that is constructed must be freed using
 ::pn_message_free().

 @return pointer to a new ::pn_message_t

PN_EXTERN pn_message_t * pn_message(void);
"
	^self call: #pn_message with: Array new.
!"end pn_message "


pn_message_free: msg 
" Free a previously constructed ::pn_message_t.

 @param[in] msg pointer to a ::pn_message_t or NULL

PN_EXTERN void           pn_message_free(pn_message_t *msg);
"
	^self call: #pn_message_free with: (Array with: msg).
!"end pn_message_free: msg  "


pn_message_clear: msg 
" Clears the content of a ::pn_message_t.

 When pn_message_clear returns, the supplied ::pn_message_t will be
 emptied of all content and effectively returned to the same state
 as if it was just created.

 @param[in] msg pointer to the ::pn_message_t to be cleared

PN_EXTERN void           pn_message_clear(pn_message_t *msg);
"
	^self call: #pn_message_clear with: (Array with: msg).
!"end pn_message_clear: msg  "


pn_message_errno: msg 
" Access the error code of a message.

 Every operation on a message that can result in an error will set
 the message's error code in case of error. The pn_message_errno()
 call will access the error code of the most recent failed
 operation.

 @param[in] msg a message
 @return the message's error code

PN_EXTERN int            pn_message_errno(pn_message_t *msg);
"
	^self call: #pn_message_errno with: (Array with: msg).
!"end pn_message_errno: msg  "


pn_message_error: msg 
" Access the error information for a message.

 Every operation on a message that can result in an error will
 update the error information held by its error descriptor should
 that operation fail. The pn_message_error() call will access the
 error information of the most recent failed operation. The pointer
 returned by this call is valid until the message is freed.

 @param[in] msg a message
 @return the message's error descriptor

PN_EXTERN pn_error_t    *pn_message_error(pn_message_t *msg);
"
	^self call: #pn_message_error with: (Array with: msg).
!"end pn_message_error: msg  "


pn_message_is_inferred: msg 
" Get the inferred flag for a message.

 The inferred flag for a message indicates how the message content
 is encoded into AMQP sections. If inferred is true then binary and
 list values in the body of the message will be encoded as AMQP DATA
 and AMQP SEQUENCE sections, respectively. If inferred is false,
 then all values in the body of the message will be encoded as AMQP
 VALUE sections regardless of their type. Use
 ::pn_message_set_inferred to set the value.

 @param[in] msg a message object
 @return the value of the inferred flag for the message

PN_EXTERN bool           pn_message_is_inferred(pn_message_t *msg);
"
	^self call: #pn_message_is_inferred with: (Array with: msg).
!"end pn_message_is_inferred: msg  "


pn_message_set_inferred: msg with: inferred 
" Set the inferred flag for a message.

 See ::pn_message_is_inferred() for a description of what the
 inferred flag is.

 @param[in] msg a message object
 @param[in] inferred the new value of the inferred flag
 @return zero on success or an error code on failure

PN_EXTERN int            pn_message_set_inferred(pn_message_t *msg, bool inferred);
"
	^self call: #pn_message_set_inferred with: (Array with: msg with: inferred).
!"end pn_message_set_inferred: msg with: inferred  "


pn_message_is_durable: msg 
" Get the durable flag for a message.

 The durable flag indicates that any parties taking responsibility
 for the message must durably store the content.

 @param[in] msg a message object
 @return the value of the durable flag

PN_EXTERN bool           pn_message_is_durable            (pn_message_t *msg);
"
	^self call: #pn_message_is_durable with: (Array with: msg).
!"end pn_message_is_durable: msg  "


pn_message_set_durable: msg with: durable 
" Set the durable flag for a message.

 See ::pn_message_is_durable() for a description of the durable
 flag.

 @param[in] msg a message object
 @param[in] durable the new value of the durable flag
 @return zero on success or an error code on failure

PN_EXTERN int            pn_message_set_durable           (pn_message_t *msg, bool durable);
"
	^self call: #pn_message_set_durable with: (Array with: msg with: durable).
!"end pn_message_set_durable: msg with: durable  "


pn_message_get_priority: msg 
" Get the priority for a message.

 The priority of a message impacts ordering guarantees. Within a
 given ordered context, higher priority messages may jump ahead of
 lower priority messages.

 @param[in] msg a message object
 @return the message priority

PN_EXTERN uint8_t        pn_message_get_priority          (pn_message_t *msg);
"
	^self call: #pn_message_get_priority with: (Array with: msg).
!"end pn_message_get_priority: msg  "


pn_message_set_priority: msg with: priority 
" Set the priority for a message.

 See ::pn_message_get_priority() for details on message priority.

 @param[in] msg a message object
 @param[in] priority the new priority for the message
 @return zero on success or an error code on failure

PN_EXTERN int            pn_message_set_priority          (pn_message_t *msg, uint8_t priority);
"
	^self call: #pn_message_set_priority with: (Array with: msg with: priority).
!"end pn_message_set_priority: msg with: priority  "


pn_message_get_ttl: msg 
" Get the ttl for a message.

 The ttl for a message determines how long a message is considered
 live. When a message is held for retransmit, the ttl is
 decremented. Once the ttl reaches zero, the message is considered
 dead. Once a message is considered dead it may be dropped. Use
 ::pn_message_set_ttl() to set the ttl for a message.

 @param[in] msg a message object
 @return the ttl in milliseconds

PN_EXTERN pn_millis_t    pn_message_get_ttl               (pn_message_t *msg);
"
	^self call: #pn_message_get_ttl with: (Array with: msg).
!"end pn_message_get_ttl: msg  "


pn_message_set_ttl: msg with: ttl 
" Set the ttl for a message.

 See ::pn_message_get_ttl() for a detailed description of message ttl.

 @param[in] msg a message object
 @param[in] ttl the new value for the message ttl
 @return zero on success or an error code on failure

PN_EXTERN int            pn_message_set_ttl               (pn_message_t *msg, pn_millis_t ttl);
"
	^self call: #pn_message_set_ttl with: (Array with: msg with: ttl).
!"end pn_message_set_ttl: msg with: ttl  "


pn_message_is_first_acquirer: msg 
" Get the first acquirer flag for a message.

 When set to true, the first acquirer flag for a message indicates
 that the recipient of the message is the first recipient to acquire
 the message, i.e. there have been no failed delivery attempts to
 other acquirers. Note that this does not mean the message has not
 been delivered to, but not acquired, by other recipients.

 @param[in] msg a message object
 @return the first acquirer flag for the message

PN_EXTERN bool           pn_message_is_first_acquirer     (pn_message_t *msg);
"
	^self call: #pn_message_is_first_acquirer with: (Array with: msg).
!"end pn_message_is_first_acquirer: msg  "


pn_message_set_first_acquirer: msg with: first 
" Set the first acquirer flag for a message.

 See ::pn_message_is_first_acquirer() for details on the first
 acquirer flag.

 @param[in] msg a message object
 @param[in] first the new value for the first acquirer flag
 @return zero on success or an error code on failure

PN_EXTERN int            pn_message_set_first_acquirer    (pn_message_t *msg, bool first);
"
	^self call: #pn_message_set_first_acquirer with: (Array with: msg with: first).
!"end pn_message_set_first_acquirer: msg with: first  "


pn_message_get_delivery_count: msg 
" Get the delivery count for a message.

 The delivery count field tracks how many attempts have been made to
 delivery a message. Use ::pn_message_set_delivery_count() to set
 the delivery count for a message.

 @param[in] msg a message object
 @return the delivery count for the message

PN_EXTERN uint32_t       pn_message_get_delivery_count    (pn_message_t *msg);
"
	^self call: #pn_message_get_delivery_count with: (Array with: msg).
!"end pn_message_get_delivery_count: msg  "


pn_message_set_delivery_count: msg with: count 
" Set the delivery count for a message.

 See ::pn_message_get_delivery_count() for details on what the
 delivery count means.

 @param[in] msg a message object
 @param[in] count the new delivery count
 @return zero on success or an error code on failure

PN_EXTERN int            pn_message_set_delivery_count    (pn_message_t *msg, uint32_t count);
"
	^self call: #pn_message_set_delivery_count with: (Array with: msg with: count).
!"end pn_message_set_delivery_count: msg with: count  "


pn_message_id: msg 
" Get/set the id for a message.

 The message id provides a globally unique identifier for a message.
 A message id can be an a string, an unsigned long, a uuid or a
 binary value. This operation returns a pointer to a ::pn_data_t
 that can be used to access and/or modify the value of the message
 id. The pointer is valid until the message is freed. See
 ::pn_data_t for details on how to get/set the value.

 @param[in] msg a message object
 @return pointer to a ::pn_data_t holding the id

PN_EXTERN pn_data_t *    pn_message_id                    (pn_message_t *msg);
"
	^self call: #pn_message_id with: (Array with: msg).
!"end pn_message_id: msg  "


pn_message_get_id: msg 
" Get the id for a message.

 The message id provides a globally unique identifier for a message.
 A message id can be an a string, an unsigned long, a uuid or a
 binary value. This operation returns the value of the id using the
 ::pn_atom_t descriminated union. See ::pn_atom_t for details on how
 to access the value.

 @param[in] msg a message object
 @return the message id

PN_EXTERN pn_atom_t      pn_message_get_id                (pn_message_t *msg);
"
	^self call: #pn_message_get_id with: (Array with: msg).
!"end pn_message_get_id: msg  "


pn_message_set_id: msg with: id 
" Set the id for a message.

 See ::pn_message_get_id() for more details on the meaning of the
 message id. Note that only string, unsigned long, uuid, or binary
 values are permitted.

 @param[in] msg a message object
 @param[in] id the new value of the message id
 @return zero on success or an error code on failure

PN_EXTERN int            pn_message_set_id                (pn_message_t *msg, pn_atom_t id);
"
	^self call: #pn_message_set_id with: (Array with: msg with: id).
!"end pn_message_set_id: msg with: id  "


pn_message_get_user_id: msg 
" Get the user id for a message.

 The pointer referenced by the ::pn_bytes_t struct will be valid
 until any one of the following operations occur:

  - ::pn_message_free()
  - ::pn_message_clear()
  - ::pn_message_set_user_id()

 @param[in] msg a message object
 @return a pn_bytes_t referencing the message's user_id

PN_EXTERN pn_bytes_t     pn_message_get_user_id           (pn_message_t *msg);
"
	^self call: #pn_message_get_user_id with: (Array with: msg).
!"end pn_message_get_user_id: msg  "


pn_message_set_user_id: msg with: user_id 
" Set the user id for a message.

 This operation copies the bytes referenced by the provided
 ::pn_bytes_t struct.

 @param[in] msg a message object
 @param[in] user_id the new user_id for the message
 @return zero on success or an error code on failure

PN_EXTERN int            pn_message_set_user_id           (pn_message_t *msg, pn_bytes_t user_id);
"
	^self call: #pn_message_set_user_id with: (Array with: msg with: user_id).
!"end pn_message_set_user_id: msg with: user_id  "


pn_message_get_address: msg 
" Get the address for a message.

 This operation will return NULL if no address has been set or if
 the address has been set to NULL. The pointer returned by this
 operation is valid until any one of the following operations occur:

  - ::pn_message_free()
  - ::pn_message_clear()
  - ::pn_message_set_address()

 @param[in] msg a message object
 @return a pointer to the address of the message (or NULL)

PN_EXTERN const char *   pn_message_get_address           (pn_message_t *msg);
"
	^self call: #pn_message_get_address with: (Array with: msg).
!"end pn_message_get_address: msg  "


pn_message_set_address: msg with: address 
" Set the address for a message.

 The supplied address pointer must either be NULL or reference a NUL
 terminated string. When the pointer is NULL, the address of the
 message is set to NULL. When the pointer is non NULL, the contents
 are copied into the message.

 @param[in] msg a message object
 @param[in] address a pointer to the new address (or NULL)
 @return zero on success or an error code on failure

PN_EXTERN int            pn_message_set_address           (pn_message_t *msg, const char *address);
"
	^self call: #pn_message_set_address with: (Array with: msg with: address).
!"end pn_message_set_address: msg with: address  "


pn_message_get_subject: msg 
" Get the subject for a message.

 This operation will return NULL if no subject has been set or if
 the subject has been set to NULL. The pointer returned by this
 operation is valid until any one of the following operations occur:

  - ::pn_message_free()
  - ::pn_message_clear()
  - ::pn_message_set_subject()

 @param[in] msg a message object
 @return a pointer to the subject of the message (or NULL)

PN_EXTERN const char *   pn_message_get_subject           (pn_message_t *msg);
"
	^self call: #pn_message_get_subject with: (Array with: msg).
!"end pn_message_get_subject: msg  "


pn_message_set_subject: msg with: subject 
" Set the subject for a message.

 The supplied subject pointer must either be NULL or reference a NUL
 terminated string. When the pointer is NULL, the subject is set to
 NULL. When the pointer is non NULL, the contents are copied into
 the message.

 @param[in] msg a message object
 @param[in] subject a pointer to the new subject (or NULL)
 @return zero on success or an error code on failure

PN_EXTERN int            pn_message_set_subject           (pn_message_t *msg, const char *subject);
"
	^self call: #pn_message_set_subject with: (Array with: msg with: subject).
!"end pn_message_set_subject: msg with: subject  "


pn_message_get_reply_to: msg 
" Get the reply_to for a message.

 This operation will return NULL if no reply_to has been set or if
 the reply_to has been set to NULL. The pointer returned by this
 operation is valid until any one of the following operations occur:

  - ::pn_message_free()
  - ::pn_message_clear()
  - ::pn_message_set_reply_to()

 @param[in] msg a message object
 @return a pointer to the reply_to of the message (or NULL)

PN_EXTERN const char *   pn_message_get_reply_to          (pn_message_t *msg);
"
	^self call: #pn_message_get_reply_to with: (Array with: msg).
!"end pn_message_get_reply_to: msg  "


pn_message_set_reply_to: msg with: reply_to 
" Set the reply_to for a message.

 The supplied reply_to pointer must either be NULL or reference a NUL
 terminated string. When the pointer is NULL, the reply_to is set to
 NULL. When the pointer is non NULL, the contents are copied into
 the message.

 @param[in] msg a message object
 @param[in] reply_to a pointer to the new reply_to (or NULL)
 @return zero on success or an error code on failure

PN_EXTERN int            pn_message_set_reply_to          (pn_message_t *msg, const char *reply_to);
"
	^self call: #pn_message_set_reply_to with: (Array with: msg with: reply_to).
!"end pn_message_set_reply_to: msg with: reply_to  "


pn_message_correlation_id: msg 
" Get/set the correlation id for a message.

 A correlation id can be an a string, an unsigned long, a uuid or a
 binary value. This operation returns a pointer to a ::pn_data_t
 that can be used to access and/or modify the value of the
 correlation id. The pointer is valid until the message is freed.
 See ::pn_data_t for details on how to get/set the value.

 @param[in] msg a message object
 @return pointer to a ::pn_data_t holding the correlation id

PN_EXTERN pn_data_t *    pn_message_correlation_id        (pn_message_t *msg);
"
	^self call: #pn_message_correlation_id with: (Array with: msg).
!"end pn_message_correlation_id: msg  "


pn_message_get_correlation_id: msg 
" Get the correlation id for a message.

 A correlation id can be an a string, an unsigned long, a uuid or a
 binary value. This operation returns the value of the id using the
 ::pn_atom_t descriminated union. See ::pn_atom_t for details on how
 to access the value.

 @param[in] msg a message object
 @return the message id

PN_EXTERN pn_atom_t      pn_message_get_correlation_id    (pn_message_t *msg);
"
	^self call: #pn_message_get_correlation_id with: (Array with: msg).
!"end pn_message_get_correlation_id: msg  "


pn_message_set_correlation_id: msg with: id 
" Set the correlation id for a message.

 See ::pn_message_get_correlation_id() for more details on the
 meaning of the correlation id. Note that only string, unsigned
 long, uuid, or binary values are permitted.

 @param[in] msg a message object
 @param[in] id the new value of the message id
 @return zero on success or an error code on failure

PN_EXTERN int            pn_message_set_correlation_id    (pn_message_t *msg, pn_atom_t id);
"
	^self call: #pn_message_set_correlation_id with: (Array with: msg with: id).
!"end pn_message_set_correlation_id: msg with: id  "


pn_message_get_content_type: msg 
" Get the content_type for a message.

 This operation will return NULL if no content_type has been set or if
 the content_type has been set to NULL. The pointer returned by this
 operation is valid until any one of the following operations occur:

  - ::pn_message_free()
  - ::pn_message_clear()
  - ::pn_message_set_content_type()

 @param[in] msg a message object
 @return a pointer to the content_type of the message (or NULL)

PN_EXTERN const char *   pn_message_get_content_type      (pn_message_t *msg);
"
	^self call: #pn_message_get_content_type with: (Array with: msg).
!"end pn_message_get_content_type: msg  "


pn_message_set_content_type: msg with: type 
" Set the content_type for a message.

 The supplied content_type pointer must either be NULL or reference a NUL
 terminated string. When the pointer is NULL, the content_type is set to
 NULL. When the pointer is non NULL, the contents are copied into
 the message.

 @param[in] msg a message object
 @param[in] type a pointer to the new content_type (or NULL)
 @return zero on success or an error code on failure

PN_EXTERN int            pn_message_set_content_type      (pn_message_t *msg, const char *type);
"
	^self call: #pn_message_set_content_type with: (Array with: msg with: type).
!"end pn_message_set_content_type: msg with: type  "


pn_message_get_content_encoding: msg 
" Get the content_encoding for a message.

 This operation will return NULL if no content_encoding has been set or if
 the content_encoding has been set to NULL. The pointer returned by this
 operation is valid until any one of the following operations occur:

  - ::pn_message_free()
  - ::pn_message_clear()
  - ::pn_message_set_content_encoding()

 @param[in] msg a message object
 @return a pointer to the content_encoding of the message (or NULL)

PN_EXTERN const char *   pn_message_get_content_encoding  (pn_message_t *msg);
"
	^self call: #pn_message_get_content_encoding with: (Array with: msg).
!"end pn_message_get_content_encoding: msg  "


pn_message_set_content_encoding: msg with: encoding 
" Set the content_encoding for a message.

 The supplied content_encoding pointer must either be NULL or reference a NUL
 terminated string. When the pointer is NULL, the content_encoding is set to
 NULL. When the pointer is non NULL, the contents are copied into
 the message.

 @param[in] msg a message object
 @param[in] encoding a pointer to the new content_encoding (or NULL)
 @return zero on success or an error code on failure

PN_EXTERN int            pn_message_set_content_encoding  (pn_message_t *msg, const char *encoding);
"
	^self call: #pn_message_set_content_encoding with: (Array with: msg with: encoding).
!"end pn_message_set_content_encoding: msg with: encoding  "


pn_message_get_expiry_time: msg 
" Get the expiry time for a message.

 A zero value for the expiry time indicates that the message will
 never expire. This is the default value.

 @param[in] msg a message object
 @return the expiry time for the message

PN_EXTERN pn_timestamp_t pn_message_get_expiry_time       (pn_message_t *msg);
"
	^self call: #pn_message_get_expiry_time with: (Array with: msg).
!"end pn_message_get_expiry_time: msg  "


pn_message_set_expiry_time: msg with: time 
" Set the expiry time for a message.

 See ::pn_message_get_expiry_time() for more details.

 @param[in] msg a message object
 @param[in] time the new expiry time for the message
 @return zero on success or an error code on failure

PN_EXTERN int            pn_message_set_expiry_time       (pn_message_t *msg, pn_timestamp_t time);
"
	^self call: #pn_message_set_expiry_time with: (Array with: msg with: time).
!"end pn_message_set_expiry_time: msg with: time  "


pn_message_get_creation_time: msg 
" Get the creation time for a message.

 A zero value for the creation time indicates that the creation time
 has not been set. This is the default value.

 @param[in] msg a message object
 @return the creation time for the message

PN_EXTERN pn_timestamp_t pn_message_get_creation_time     (pn_message_t *msg);
"
	^self call: #pn_message_get_creation_time with: (Array with: msg).
!"end pn_message_get_creation_time: msg  "


pn_message_set_creation_time: msg with: time 
" Set the creation time for a message.

 See ::pn_message_get_creation_time() for more details.

 @param[in] msg a message object
 @param[in] time the new creation time for the message
 @return zero on success or an error code on failure

PN_EXTERN int            pn_message_set_creation_time     (pn_message_t *msg, pn_timestamp_t time);
"
	^self call: #pn_message_set_creation_time with: (Array with: msg with: time).
!"end pn_message_set_creation_time: msg with: time  "


pn_message_get_group_id: msg 
" Get the group_id for a message.

 This operation will return NULL if no group_id has been set or if
 the group_id has been set to NULL. The pointer returned by this
 operation is valid until any one of the following operations occur:

  - ::pn_message_free()
  - ::pn_message_clear()
  - ::pn_message_set_group_id()

 @param[in] msg a message object
 @return a pointer to the group_id of the message (or NULL)

PN_EXTERN const char *   pn_message_get_group_id          (pn_message_t *msg);
"
	^self call: #pn_message_get_group_id with: (Array with: msg).
!"end pn_message_get_group_id: msg  "


pn_message_set_group_id: msg with: group_id 
" Set the group_id for a message.

 The supplied group_id pointer must either be NULL or reference a NUL
 terminated string. When the pointer is NULL, the group_id is set to
 NULL. When the pointer is non NULL, the contents are copied into
 the message.

 @param[in] msg a message object
 @param[in] group_id a pointer to the new group_id (or NULL)
 @return zero on success or an error code on failure

PN_EXTERN int            pn_message_set_group_id          (pn_message_t *msg, const char *group_id);
"
	^self call: #pn_message_set_group_id with: (Array with: msg with: group_id).
!"end pn_message_set_group_id: msg with: group_id  "


pn_message_get_group_sequence: msg 
" Get the group sequence for a message.

 The group sequence of a message identifies the relative ordering of
 messages within a group. The default value for the group sequence
 of a message is zero.

 @param[in] msg a message object
 @return the group sequence for the message

PN_EXTERN pn_sequence_t  pn_message_get_group_sequence    (pn_message_t *msg);
"
	^self call: #pn_message_get_group_sequence with: (Array with: msg).
!"end pn_message_get_group_sequence: msg  "


pn_message_set_group_sequence: msg with: n 
" Set the group sequence for a message.

 See ::pn_message_get_group_sequence() for details on what the group
 sequence means.

 @param[in] msg a message object
 @param[in] n the new group sequence for the message
 @return zero on success or an error code on failure

PN_EXTERN int            pn_message_set_group_sequence    (pn_message_t *msg, pn_sequence_t n);
"
	^self call: #pn_message_set_group_sequence with: (Array with: msg with: n).
!"end pn_message_set_group_sequence: msg with: n  "


pn_message_get_reply_to_group_id: msg 
" Get the reply_to_group_id for a message.

 This operation will return NULL if no reply_to_group_id has been set or if
 the reply_to_group_id has been set to NULL. The pointer returned by this
 operation is valid until any one of the following operations occur:

  - ::pn_message_free()
  - ::pn_message_clear()
  - ::pn_message_set_reply_to_group_id()

 @param[in] msg a message object
 @return a pointer to the reply_to_group_id of the message (or NULL)

PN_EXTERN const char *   pn_message_get_reply_to_group_id (pn_message_t *msg);
"
	^self call: #pn_message_get_reply_to_group_id with: (Array with: msg).
!"end pn_message_get_reply_to_group_id: msg  "


pn_message_set_reply_to_group_id: msg with: reply_to_group_id 
" Set the reply_to_group_id for a message.

 The supplied reply_to_group_id pointer must either be NULL or reference a NUL
 terminated string. When the pointer is NULL, the reply_to_group_id is set to
 NULL. When the pointer is non NULL, the contents are copied into
 the message.

 @param[in] msg a message object
 @param[in] reply_to_group_id a pointer to the new reply_to_group_id (or NULL)
 @return zero on success or an error code on failure

PN_EXTERN int            pn_message_set_reply_to_group_id (pn_message_t *msg, const char *reply_to_group_id);
"
	^self call: #pn_message_set_reply_to_group_id with: (Array with: msg with: reply_to_group_id).
!"end pn_message_set_reply_to_group_id: msg with: reply_to_group_id  "


pn_message_get_format: message 
" @deprecated

PN_EXTERN pn_format_t pn_message_get_format(pn_message_t *message);
"
	^self call: #pn_message_get_format with: (Array with: message).
!"end pn_message_get_format: message  "


pn_message_set_format: message with: format 
" @deprecated

PN_EXTERN int pn_message_set_format(pn_message_t *message, pn_format_t format);
"
	^self call: #pn_message_set_format with: (Array with: message with: format).
!"end pn_message_set_format: message with: format  "


pn_message_load: message with: data with: size 
" @deprecated Use ::pn_message_body() instead.

PN_EXTERN int pn_message_load(pn_message_t *message, const char *data, size_t size);
"
	^self call: #pn_message_load with: (Array with: message with: data with: size).
!"end pn_message_load: message with: data with: size  "


pn_message_load_data: message with: data with: size 
" @deprecated Use ::pn_message_body() instead.

PN_EXTERN int pn_message_load_data(pn_message_t *message, const char *data, size_t size);
"
	^self call: #pn_message_load_data with: (Array with: message with: data with: size).
!"end pn_message_load_data: message with: data with: size  "


pn_message_load_text: message with: data with: size 
" @deprecated Use ::pn_message_body() instead.

PN_EXTERN int pn_message_load_text(pn_message_t *message, const char *data, size_t size);
"
	^self call: #pn_message_load_text with: (Array with: message with: data with: size).
!"end pn_message_load_text: message with: data with: size  "


pn_message_load_amqp: message with: data with: size 
" @deprecated Use ::pn_message_body() instead.

PN_EXTERN int pn_message_load_amqp(pn_message_t *message, const char *data, size_t size);
"
	^self call: #pn_message_load_amqp with: (Array with: message with: data with: size).
!"end pn_message_load_amqp: message with: data with: size  "


pn_message_load_json: message with: data with: size 
" @deprecated Use ::pn_message_body() instead.

PN_EXTERN int pn_message_load_json(pn_message_t *message, const char *data, size_t size);
"
	^self call: #pn_message_load_json with: (Array with: message with: data with: size).
!"end pn_message_load_json: message with: data with: size  "


pn_message_save: message with: data with: size 
" @deprecated Use ::pn_message_body() instead.

PN_EXTERN int pn_message_save(pn_message_t *message, char *data, size_t *size);
"
	^self call: #pn_message_save with: (Array with: message with: data with: size).
!"end pn_message_save: message with: data with: size  "


pn_message_save_data: message with: data with: size 
" @deprecated Use ::pn_message_body() instead.

PN_EXTERN int pn_message_save_data(pn_message_t *message, char *data, size_t *size);
"
	^self call: #pn_message_save_data with: (Array with: message with: data with: size).
!"end pn_message_save_data: message with: data with: size  "


pn_message_save_text: message with: data with: size 
" @deprecated Use ::pn_message_body() instead.

PN_EXTERN int pn_message_save_text(pn_message_t *message, char *data, size_t *size);
"
	^self call: #pn_message_save_text with: (Array with: message with: data with: size).
!"end pn_message_save_text: message with: data with: size  "


pn_message_save_amqp: message with: data with: size 
" @deprecated Use ::pn_message_body() instead.

PN_EXTERN int pn_message_save_amqp(pn_message_t *message, char *data, size_t *size);
"
	^self call: #pn_message_save_amqp with: (Array with: message with: data with: size).
!"end pn_message_save_amqp: message with: data with: size  "


pn_message_save_json: message with: data with: size 
" @deprecated Use ::pn_message_body() instead.

PN_EXTERN int pn_message_save_json(pn_message_t *message, char *data, size_t *size);
"
	^self call: #pn_message_save_json with: (Array with: message with: data with: size).
!"end pn_message_save_json: message with: data with: size  "


pn_message_instructions: msg 
" Get/set the delivery instructions for a message.

 This operation returns a pointer to a ::pn_data_t representing the
 content of the delivery instructions section of a message. The
 pointer is valid until the message is freed and may be used to both
 access and modify the content of the delivery instructions section
 of a message.

 The ::pn_data_t must either be empty or consist of a symbol keyed
 map in order to be considered valid delivery instructions.

 @param[in] msg a message object
 @return a pointer to the delivery instructions

PN_EXTERN pn_data_t *pn_message_instructions(pn_message_t *msg);
"
	^self call: #pn_message_instructions with: (Array with: msg).
!"end pn_message_instructions: msg  "


pn_message_annotations: msg 
" Get/set the annotations for a message.

 This operation returns a pointer to a ::pn_data_t representing the
 content of the annotations section of a message. The pointer is
 valid until the message is freed and may be used to both access and
 modify the content of the annotations section of a message.

 The ::pn_data_t must either be empty or consist of a symbol keyed
 map in order to be considered valid message annotations.

 @param[in] msg a message object
 @return a pointer to the message annotations

PN_EXTERN pn_data_t *pn_message_annotations(pn_message_t *msg);
"
	^self call: #pn_message_annotations with: (Array with: msg).
!"end pn_message_annotations: msg  "


pn_message_properties: msg 
" Get/set the properties for a message.

 This operation returns a pointer to a ::pn_data_t representing the
 content of the properties section of a message. The pointer is
 valid until the message is freed and may be used to both access and
 modify the content of the properties section of a message.

 The ::pn_data_t must either be empty or consist of a string keyed
 map in order to be considered valid message properties.

 @param[in] msg a message object
 @return a pointer to the message properties

PN_EXTERN pn_data_t *pn_message_properties(pn_message_t *msg);
"
	^self call: #pn_message_properties with: (Array with: msg).
!"end pn_message_properties: msg  "


pn_message_body: msg 
" Get/set the body of a message.

 This operation returns a pointer to a ::pn_data_t representing the
 body of a message. The pointer is valid until the message is freed
 and may be used to both access and modify the content of the
 message body.

 @param[in] msg a message object
 @return a pointer to the message body

PN_EXTERN pn_data_t *pn_message_body(pn_message_t *msg);
"
	^self call: #pn_message_body with: (Array with: msg).
!"end pn_message_body: msg  "


pn_message_decode: msg with: bytes with: size 
" Decode/load message content from AMQP formatted binary data.

 Upon invoking this operation, any existing message content will be
 cleared and replaced with the content from the provided binary
 data.

 @param[in] msg a message object
 @param[in] bytes the start of the encoded AMQP data
 @param[in] size the size of the encoded AMQP data
 @return zero on success or an error code on failure

PN_EXTERN int pn_message_decode(pn_message_t *msg, const char *bytes, size_t size);
"
	^self call: #pn_message_decode with: (Array with: msg with: bytes with: size).
!"end pn_message_decode: msg with: bytes with: size  "


pn_message_encode: msg with: bytes with: size 
" Encode/save message content as AMQP formatted binary data.

 If the buffer space provided is insufficient to store the content
 held in the message, the operation will fail and return a
 ::PN_OVERFLOW error code.

 @param[in] msg a message object
 @param[in] bytes the start of empty buffer space
 @param[in] size the amount of empty buffer space
 @param[out] size the amount of data written
 @return zero on success or an error code on failure

PN_EXTERN int pn_message_encode(pn_message_t *msg, char *bytes, size_t *size);
"
	^self call: #pn_message_encode with: (Array with: msg with: bytes with: size).
!"end pn_message_encode: msg with: bytes with: size  "


pn_message_data: dst with: available with: src with: size 
" @deprecated

PN_EXTERN ssize_t pn_message_data(char *dst, size_t available, const char *src, size_t size);
"
	^self call: #pn_message_data with: (Array with: dst with: available with: src with: size).
!"end pn_message_data: dst with: available with: src with: size  "


pn_bytes: size with: start 
"
PN_EXTERN pn_bytes_t pn_bytes(size_t size, const char *start);
"
	^self call: #pn_bytes with: (Array with: size with: start).
!"end pn_bytes: size with: start  "


pn_type_name: type 
"
PN_EXTERN const char *pn_type_name(pn_type_t type);
"
	^self call: #pn_type_name with: (Array with: type).
!"end pn_type_name: type  "


pn_data: capacity 
"
PN_EXTERN pn_data_t *pn_data(size_t capacity);
"
	^self call: #pn_data with: (Array with: capacity).
!"end pn_data: capacity  "


pn_data_free: data 
"
PN_EXTERN void pn_data_free(pn_data_t *data);
"
	^self call: #pn_data_free with: (Array with: data).
!"end pn_data_free: data  "


pn_data_errno: data 
"
PN_EXTERN int pn_data_errno(pn_data_t *data);
"
	^self call: #pn_data_errno with: (Array with: data).
!"end pn_data_errno: data  "


pn_data_error: data 
"
PN_EXTERN pn_error_t *pn_data_error(pn_data_t *data);
"
	^self call: #pn_data_error with: (Array with: data).
!"end pn_data_error: data  "


pn_data_vfill: data with: fmt with: ap 
"
PN_EXTERN int pn_data_vfill(pn_data_t *data, const char *fmt, va_list ap);
"
	^self call: #pn_data_vfill with: (Array with: data with: fmt with: ap).
!"end pn_data_vfill: data with: fmt with: ap  "


pn_data_fill: data with: fmt with: list 
"
PN_EXTERN int pn_data_fill(pn_data_t *data, const char *fmt, ...);
"
	^self call: #pn_data_fill with: (Array with: data with: fmt with: list).
!"end pn_data_fill: data with: fmt with: list  "


pn_data_vscan: data with: fmt with: ap 
"
PN_EXTERN int pn_data_vscan(pn_data_t *data, const char *fmt, va_list ap);
"
	^self call: #pn_data_vscan with: (Array with: data with: fmt with: ap).
!"end pn_data_vscan: data with: fmt with: ap  "


pn_data_scan: data with: fmt with: list 
"
PN_EXTERN int pn_data_scan(pn_data_t *data, const char *fmt, ...);
"
	^self call: #pn_data_scan with: (Array with: data with: fmt with: list).
!"end pn_data_scan: data with: fmt with: list  "


pn_data_clear: data 
"
PN_EXTERN void pn_data_clear(pn_data_t *data);
"
	^self call: #pn_data_clear with: (Array with: data).
!"end pn_data_clear: data  "


pn_data_size: data 
"
PN_EXTERN size_t pn_data_size(pn_data_t *data);
"
	^self call: #pn_data_size with: (Array with: data).
!"end pn_data_size: data  "


pn_data_rewind: data 
"
PN_EXTERN void pn_data_rewind(pn_data_t *data);
"
	^self call: #pn_data_rewind with: (Array with: data).
!"end pn_data_rewind: data  "


pn_data_next: data 
"
PN_EXTERN bool pn_data_next(pn_data_t *data);
"
	^self call: #pn_data_next with: (Array with: data).
!"end pn_data_next: data  "


pn_data_prev: data 
"
PN_EXTERN bool pn_data_prev(pn_data_t *data);
"
	^self call: #pn_data_prev with: (Array with: data).
!"end pn_data_prev: data  "


pn_data_enter: data 
"
PN_EXTERN bool pn_data_enter(pn_data_t *data);
"
	^self call: #pn_data_enter with: (Array with: data).
!"end pn_data_enter: data  "


pn_data_exit: data 
"
PN_EXTERN bool pn_data_exit(pn_data_t *data);
"
	^self call: #pn_data_exit with: (Array with: data).
!"end pn_data_exit: data  "


pn_data_lookup: data with: name 
"
PN_EXTERN bool pn_data_lookup(pn_data_t *data, const char *name);
"
	^self call: #pn_data_lookup with: (Array with: data with: name).
!"end pn_data_lookup: data with: name  "


pn_data_type: data 
"
PN_EXTERN pn_type_t pn_data_type(pn_data_t *data);
"
	^self call: #pn_data_type with: (Array with: data).
!"end pn_data_type: data  "


pn_data_print: data 
"
PN_EXTERN int pn_data_print(pn_data_t *data);
"
	^self call: #pn_data_print with: (Array with: data).
!"end pn_data_print: data  "


pn_data_format: data with: bytes with: size 
"
PN_EXTERN int pn_data_format(pn_data_t *data, char *bytes, size_t *size);
"
	^self call: #pn_data_format with: (Array with: data with: bytes with: size).
!"end pn_data_format: data with: bytes with: size  "


pn_data_encode: data with: bytes with: size 
"
PN_EXTERN ssize_t pn_data_encode(pn_data_t *data, char *bytes, size_t size);
"
	^self call: #pn_data_encode with: (Array with: data with: bytes with: size).
!"end pn_data_encode: data with: bytes with: size  "


pn_data_decode: data with: bytes with: size 
"
PN_EXTERN ssize_t pn_data_decode(pn_data_t *data, const char *bytes, size_t size);
"
	^self call: #pn_data_decode with: (Array with: data with: bytes with: size).
!"end pn_data_decode: data with: bytes with: size  "


pn_data_put_list: data 
"
PN_EXTERN int pn_data_put_list(pn_data_t *data);
"
	^self call: #pn_data_put_list with: (Array with: data).
!"end pn_data_put_list: data  "


pn_data_put_map: data 
"
PN_EXTERN int pn_data_put_map(pn_data_t *data);
"
	^self call: #pn_data_put_map with: (Array with: data).
!"end pn_data_put_map: data  "


pn_data_put_array: data with: described with: type 
"
PN_EXTERN int pn_data_put_array(pn_data_t *data, bool described, pn_type_t type);
"
	^self call: #pn_data_put_array with: (Array with: data with: described with: type).
!"end pn_data_put_array: data with: described with: type  "


pn_data_put_described: data 
"
PN_EXTERN int pn_data_put_described(pn_data_t *data);
"
	^self call: #pn_data_put_described with: (Array with: data).
!"end pn_data_put_described: data  "


pn_data_put_null: data 
"
PN_EXTERN int pn_data_put_null(pn_data_t *data);
"
	^self call: #pn_data_put_null with: (Array with: data).
!"end pn_data_put_null: data  "


pn_data_put_bool: data with: b 
"
PN_EXTERN int pn_data_put_bool(pn_data_t *data, bool b);
"
	^self call: #pn_data_put_bool with: (Array with: data with: b).
!"end pn_data_put_bool: data with: b  "


pn_data_put_ubyte: data with: ub 
"
PN_EXTERN int pn_data_put_ubyte(pn_data_t *data, uint8_t ub);
"
	^self call: #pn_data_put_ubyte with: (Array with: data with: ub).
!"end pn_data_put_ubyte: data with: ub  "


pn_data_put_byte: data with: b 
"
PN_EXTERN int pn_data_put_byte(pn_data_t *data, int8_t b);
"
	^self call: #pn_data_put_byte with: (Array with: data with: b).
!"end pn_data_put_byte: data with: b  "


pn_data_put_ushort: data with: us 
"
PN_EXTERN int pn_data_put_ushort(pn_data_t *data, uint16_t us);
"
	^self call: #pn_data_put_ushort with: (Array with: data with: us).
!"end pn_data_put_ushort: data with: us  "


pn_data_put_short: data with: s 
"
PN_EXTERN int pn_data_put_short(pn_data_t *data, int16_t s);
"
	^self call: #pn_data_put_short with: (Array with: data with: s).
!"end pn_data_put_short: data with: s  "


pn_data_put_uint: data with: ui 
"
PN_EXTERN int pn_data_put_uint(pn_data_t *data, uint32_t ui);
"
	^self call: #pn_data_put_uint with: (Array with: data with: ui).
!"end pn_data_put_uint: data with: ui  "


pn_data_put_int: data with: i 
"
PN_EXTERN int pn_data_put_int(pn_data_t *data, int32_t i);
"
	^self call: #pn_data_put_int with: (Array with: data with: i).
!"end pn_data_put_int: data with: i  "


pn_data_put_char: data with: c 
"
PN_EXTERN int pn_data_put_char(pn_data_t *data, pn_char_t c);
"
	^self call: #pn_data_put_char with: (Array with: data with: c).
!"end pn_data_put_char: data with: c  "


pn_data_put_ulong: data with: ul 
"
PN_EXTERN int pn_data_put_ulong(pn_data_t *data, uint64_t ul);
"
	^self call: #pn_data_put_ulong with: (Array with: data with: ul).
!"end pn_data_put_ulong: data with: ul  "


pn_data_put_long: data with: l 
"
PN_EXTERN int pn_data_put_long(pn_data_t *data, int64_t l);
"
	^self call: #pn_data_put_long with: (Array with: data with: l).
!"end pn_data_put_long: data with: l  "


pn_data_put_timestamp: data with: t 
"
PN_EXTERN int pn_data_put_timestamp(pn_data_t *data, pn_timestamp_t t);
"
	^self call: #pn_data_put_timestamp with: (Array with: data with: t).
!"end pn_data_put_timestamp: data with: t  "


pn_data_put_float: data with: f 
"
PN_EXTERN int pn_data_put_float(pn_data_t *data, float f);
"
	^self call: #pn_data_put_float with: (Array with: data with: f).
!"end pn_data_put_float: data with: f  "


pn_data_put_double: data with: d 
"
PN_EXTERN int pn_data_put_double(pn_data_t *data, double d);
"
	^self call: #pn_data_put_double with: (Array with: data with: d).
!"end pn_data_put_double: data with: d  "


pn_data_put_decimal32: data with: d 
"
PN_EXTERN int pn_data_put_decimal32(pn_data_t *data, pn_decimal32_t d);
"
	^self call: #pn_data_put_decimal32 with: (Array with: data with: d).
!"end pn_data_put_decimal32: data with: d  "


pn_data_put_decimal64: data with: d 
"
PN_EXTERN int pn_data_put_decimal64(pn_data_t *data, pn_decimal64_t d);
"
	^self call: #pn_data_put_decimal64 with: (Array with: data with: d).
!"end pn_data_put_decimal64: data with: d  "


pn_data_put_decimal128: data with: d 
"
PN_EXTERN int pn_data_put_decimal128(pn_data_t *data, pn_decimal128_t d);
"
	^self call: #pn_data_put_decimal128 with: (Array with: data with: d).
!"end pn_data_put_decimal128: data with: d  "


pn_data_put_uuid: data with: u 
"
PN_EXTERN int pn_data_put_uuid(pn_data_t *data, pn_uuid_t u);
"
	^self call: #pn_data_put_uuid with: (Array with: data with: u).
!"end pn_data_put_uuid: data with: u  "


pn_data_put_binary: data with: bytes 
"
PN_EXTERN int pn_data_put_binary(pn_data_t *data, pn_bytes_t bytes);
"
	^self call: #pn_data_put_binary with: (Array with: data with: bytes).
!"end pn_data_put_binary: data with: bytes  "


pn_data_put_string: data with: string 
"
PN_EXTERN int pn_data_put_string(pn_data_t *data, pn_bytes_t string);
"
	^self call: #pn_data_put_string with: (Array with: data with: string).
!"end pn_data_put_string: data with: string  "


pn_data_put_symbol: data with: symbol 
"
PN_EXTERN int pn_data_put_symbol(pn_data_t *data, pn_bytes_t symbol);
"
	^self call: #pn_data_put_symbol with: (Array with: data with: symbol).
!"end pn_data_put_symbol: data with: symbol  "


pn_data_put_atom: data with: atom 
"
PN_EXTERN int pn_data_put_atom(pn_data_t *data, pn_atom_t atom);
"
	^self call: #pn_data_put_atom with: (Array with: data with: atom).
!"end pn_data_put_atom: data with: atom  "


pn_data_get_list: data 
"
PN_EXTERN size_t pn_data_get_list(pn_data_t *data);
"
	^self call: #pn_data_get_list with: (Array with: data).
!"end pn_data_get_list: data  "


pn_data_get_map: data 
"
PN_EXTERN size_t pn_data_get_map(pn_data_t *data);
"
	^self call: #pn_data_get_map with: (Array with: data).
!"end pn_data_get_map: data  "


pn_data_get_array: data 
"
PN_EXTERN size_t pn_data_get_array(pn_data_t *data);
"
	^self call: #pn_data_get_array with: (Array with: data).
!"end pn_data_get_array: data  "


pn_data_is_array_described: data 
"
PN_EXTERN bool pn_data_is_array_described(pn_data_t *data);
"
	^self call: #pn_data_is_array_described with: (Array with: data).
!"end pn_data_is_array_described: data  "


pn_data_get_array_type: data 
"
PN_EXTERN pn_type_t pn_data_get_array_type(pn_data_t *data);
"
	^self call: #pn_data_get_array_type with: (Array with: data).
!"end pn_data_get_array_type: data  "


pn_data_is_described: data 
"
PN_EXTERN bool pn_data_is_described(pn_data_t *data);
"
	^self call: #pn_data_is_described with: (Array with: data).
!"end pn_data_is_described: data  "


pn_data_is_null: data 
"
PN_EXTERN bool pn_data_is_null(pn_data_t *data);
"
	^self call: #pn_data_is_null with: (Array with: data).
!"end pn_data_is_null: data  "


pn_data_get_bool: data 
"
PN_EXTERN bool pn_data_get_bool(pn_data_t *data);
"
	^self call: #pn_data_get_bool with: (Array with: data).
!"end pn_data_get_bool: data  "


pn_data_get_ubyte: data 
"
PN_EXTERN uint8_t pn_data_get_ubyte(pn_data_t *data);
"
	^self call: #pn_data_get_ubyte with: (Array with: data).
!"end pn_data_get_ubyte: data  "


pn_data_get_byte: data 
"
PN_EXTERN int8_t pn_data_get_byte(pn_data_t *data);
"
	^self call: #pn_data_get_byte with: (Array with: data).
!"end pn_data_get_byte: data  "


pn_data_get_ushort: data 
"
PN_EXTERN uint16_t pn_data_get_ushort(pn_data_t *data);
"
	^self call: #pn_data_get_ushort with: (Array with: data).
!"end pn_data_get_ushort: data  "


pn_data_get_short: data 
"
PN_EXTERN int16_t pn_data_get_short(pn_data_t *data);
"
	^self call: #pn_data_get_short with: (Array with: data).
!"end pn_data_get_short: data  "


pn_data_get_uint: data 
"
PN_EXTERN uint32_t pn_data_get_uint(pn_data_t *data);
"
	^self call: #pn_data_get_uint with: (Array with: data).
!"end pn_data_get_uint: data  "


pn_data_get_int: data 
"
PN_EXTERN int32_t pn_data_get_int(pn_data_t *data);
"
	^self call: #pn_data_get_int with: (Array with: data).
!"end pn_data_get_int: data  "


pn_data_get_char: data 
"
PN_EXTERN pn_char_t pn_data_get_char(pn_data_t *data);
"
	^self call: #pn_data_get_char with: (Array with: data).
!"end pn_data_get_char: data  "


pn_data_get_ulong: data 
"
PN_EXTERN uint64_t pn_data_get_ulong(pn_data_t *data);
"
	^self call: #pn_data_get_ulong with: (Array with: data).
!"end pn_data_get_ulong: data  "


pn_data_get_long: data 
"
PN_EXTERN int64_t pn_data_get_long(pn_data_t *data);
"
	^self call: #pn_data_get_long with: (Array with: data).
!"end pn_data_get_long: data  "


pn_data_get_timestamp: data 
"
PN_EXTERN pn_timestamp_t pn_data_get_timestamp(pn_data_t *data);
"
	^self call: #pn_data_get_timestamp with: (Array with: data).
!"end pn_data_get_timestamp: data  "


pn_data_get_float: data 
"
PN_EXTERN float pn_data_get_float(pn_data_t *data);
"
	^self call: #pn_data_get_float with: (Array with: data).
!"end pn_data_get_float: data  "


pn_data_get_double: data 
"
PN_EXTERN double pn_data_get_double(pn_data_t *data);
"
	^self call: #pn_data_get_double with: (Array with: data).
!"end pn_data_get_double: data  "


pn_data_get_decimal32: data 
"
PN_EXTERN pn_decimal32_t pn_data_get_decimal32(pn_data_t *data);
"
	^self call: #pn_data_get_decimal32 with: (Array with: data).
!"end pn_data_get_decimal32: data  "


pn_data_get_decimal64: data 
"
PN_EXTERN pn_decimal64_t pn_data_get_decimal64(pn_data_t *data);
"
	^self call: #pn_data_get_decimal64 with: (Array with: data).
!"end pn_data_get_decimal64: data  "


pn_data_get_decimal128: data 
"
PN_EXTERN pn_decimal128_t pn_data_get_decimal128(pn_data_t *data);
"
	^self call: #pn_data_get_decimal128 with: (Array with: data).
!"end pn_data_get_decimal128: data  "


pn_data_get_uuid: data 
"
PN_EXTERN pn_uuid_t pn_data_get_uuid(pn_data_t *data);
"
	^self call: #pn_data_get_uuid with: (Array with: data).
!"end pn_data_get_uuid: data  "


pn_data_get_binary: data 
"
PN_EXTERN pn_bytes_t pn_data_get_binary(pn_data_t *data);
"
	^self call: #pn_data_get_binary with: (Array with: data).
!"end pn_data_get_binary: data  "


pn_data_get_string: data 
"
PN_EXTERN pn_bytes_t pn_data_get_string(pn_data_t *data);
"
	^self call: #pn_data_get_string with: (Array with: data).
!"end pn_data_get_string: data  "


pn_data_get_symbol: data 
"
PN_EXTERN pn_bytes_t pn_data_get_symbol(pn_data_t *data);
"
	^self call: #pn_data_get_symbol with: (Array with: data).
!"end pn_data_get_symbol: data  "


pn_data_get_bytes: data 
"
PN_EXTERN pn_bytes_t pn_data_get_bytes(pn_data_t *data);
"
	^self call: #pn_data_get_bytes with: (Array with: data).
!"end pn_data_get_bytes: data  "


pn_data_get_atom: data 
"
PN_EXTERN pn_atom_t pn_data_get_atom(pn_data_t *data);
"
	^self call: #pn_data_get_atom with: (Array with: data).
!"end pn_data_get_atom: data  "


pn_data_copy: data with: src 
"
PN_EXTERN int pn_data_copy(pn_data_t *data, pn_data_t *src);
"
	^self call: #pn_data_copy with: (Array with: data with: src).
!"end pn_data_copy: data with: src  "


pn_data_append: data with: src 
"
PN_EXTERN int pn_data_append(pn_data_t *data, pn_data_t *src);
"
	^self call: #pn_data_append with: (Array with: data with: src).
!"end pn_data_append: data with: src  "


pn_data_appendn: data with: src with: limit 
"
PN_EXTERN int pn_data_appendn(pn_data_t *data, pn_data_t *src, int limit);
"
	^self call: #pn_data_appendn with: (Array with: data with: src with: limit).
!"end pn_data_appendn: data with: src with: limit  "


pn_data_narrow: data 
"
PN_EXTERN void pn_data_narrow(pn_data_t *data);
"
	^self call: #pn_data_narrow with: (Array with: data).
!"end pn_data_narrow: data  "


pn_data_widen: data 
"
PN_EXTERN void pn_data_widen(pn_data_t *data);
"
	^self call: #pn_data_widen with: (Array with: data).
!"end pn_data_widen: data  "


pn_data_point: data 
"
PN_EXTERN pn_handle_t pn_data_point(pn_data_t *data);
"
	^self call: #pn_data_point with: (Array with: data).
!"end pn_data_point: data  "


pn_data_restore: data with: point 
"
PN_EXTERN bool pn_data_restore(pn_data_t *data, pn_handle_t point);
"
	^self call: #pn_data_restore with: (Array with: data with: point).
!"end pn_data_restore: data with: point  "


!"End of methods block"

