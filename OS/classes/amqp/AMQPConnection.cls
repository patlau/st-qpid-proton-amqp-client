Object subclass: #AMQPConnection
instanceVariableNames: '
	address
	messenger
	subscription
	timeout
	windowSize
	incomingQueue
	outgoingQueue
	track
'
classVariableNames: '
	instances
	guidGenerator
'
poolDictionaries: '
' !


! AMQPConnection class methods!


connectAddress: aString
	| obj |
	obj := self new.
	obj connect: aString.
	^obj.

!"end connectAddress: "


connectAddress: aString timeout: anInteger
	| obj |
	obj := self new.
	obj connect: aString.
	obj timeout: anInteger.
	^obj.
!"end connectAddress:timeout: "


connectToReply: aMessage
	| obj |
	obj := self new.
	obj connect: (self getReplyAddressFor: aMessage).
	^obj.

!"end connectToReply: "


copyDLL
	(ExternalLibrary respondsTo: #copyDLL:) ifTrue: [
		^ExternalLibrary copyDLL: (Array with: 'qpid-proton').
	].
!"end copyDLL "


getReplyAddressFor: aMessage
"
	Must replace port to match our port. 
	
	Problem:
	- Qpid can not handle WebSocket and TCP transports on the same port.
	
	Current resoluation:
	- Hardcoded replace 5673 with 5672. Should be configured using a lookup Dictionary or something similar.
"
	| replyTo |
	
	replyTo := aMessage replyTo.
	replyTo ifNil: [^nil].
	^replyTo asString copyReplaceAll: '5673' with: '5672'.

!"end getReplyAddressFor: "


guidGenerator
	^guidGenerator

!"end guidGenerator "


guidGenerator: anObject
	guidGenerator := anObject.

!"end guidGenerator: "


initialize
	instances := WeakIdentitySet new.
	self copyDLL.
	
	System isInVW ifTrue:[
		 self guidGenerator: [OS.GUIDSystemSupport new newGUIDString].
	].
!"end initialize "


new
	| obj |
	obj := super new initialize.
	
	"For finalize"
	instances add: obj.
	
	^obj.
!"end new "


newGUID
	guidGenerator ifNotNil: [
		^guidGenerator value.
	].
	
	"Return pseudo GUID. You need to replace this with your own implementation"
	^	(Integer newRandom asHexStringSize: 8) + '-' +
		(Integer newRandom asHexStringSize: 4) + '-' +
		(Integer newRandom asHexStringSize: 4) + '-' +
		(Integer newRandom asHexStringSize: 4) + '-' +
		(Integer newRandom asHexStringSize: 12).
!"end newGUID "


processNotifications
	| conn |
	
	[
		self threadGlobalsAt: #AMQPCONNECTION put: 
			(conn := AMQPConnection connectAddress: 'amqp://192.168.88.33:5672/amq.fanout' timeout: 2000).
		
		conn subscribe.
		
		[(conn := self threadGlobalsAt: #AMQPCONNECTION) notNil] whileTrue: [
			conn receiveLoop: 10 callback: [:message |
				(message body format) out.
			].
		].
	
	] ensure: [
		conn ifNotNil: [conn disconnect].
	].
!"end processNotifications "


test
"
	Beispiel Connection Strings:
	- artemis/jms: amqp://test:less@192.168.88.178:5672/jms.queue.Test
	- qpid: amqp://192.168.88.33:5672/test
"

	CS := 'amqp://192.168.88.33:5672/test'.
	
	[	| conn msg |
		conn := AMQPConnection new.
		conn connect: CS.
		msg := conn receive: 1.
		msg do: [:each | each print out.].
		conn disconnect.
	] fork.

	CS := 'amqp://192.168.88.33:5672/test'.
	
	SS := AMQPConnection new.
	SS connect: CS.
	SS sendString: 'AAA'.
	SS disconnect.
	SS := nil.
!"end test "


testPublishSubscribe
"
	Client is sending a message to a server queue, server responds on a temporary client queue.
	https://www.rabbitmq.com/tutorials/tutorial-six-python.html
	
	QPID: 
	Need to bind a queue to amq.fanout first, I guess...
	PLUS: Subject must match binding key.
	
"

	"Start a new client Queue"
	[
		| conn serverConn |
		conn := AMQPConnection connectAddress: 'amqp://192.168.88.33:5672/amq.fanout' timeout: 15000.
		conn subscribe.
		('CLIENT: Queue = ' + conn subscription address) out.
		
		conn receiveLoop: 10 callback: [:message |
			('CLIENT: Received:' ++ message id ++ message subject ++ message body format) out.
		].
		conn disconnect.
	] fork waitUntilReady.
	
	[
		| conn serverConn |
		conn := AMQPConnection connectAddress: 'amqp://192.168.88.33:5672/amq.fanout' timeout: 15000.
		conn subscribe.
		('CLIENT2: Queue = ' + conn subscription address) out.
		
		conn receiveLoop: 10 callback: [:message |
			('CLIENT2: Received:' ++ message id ++ message subject ++ message body format) out.
		].
		conn disconnect.
	] fork waitUntilReady.
	
	[
		| conn |
		conn := AMQPConnection connectAddress: 'amqp://192.168.88.33:5672/amq.fanout' timeout: 15000.
		
		Thread currentThread sleep: 500.
		
		('SERVER: Publish') out.
		conn send: ((AMQPMessage new)
				subject: '*';
				id: self newGUID asString;
				durable: false;
				bodySet: 'RES' ++ Timestamp now;
				yourself).
		conn disconnect.

	] fork waitUntilReady.
	
!"end testPublishSubscribe "


testRPC
"
	Client is sending a message to a server queue, server responds on a temporary client queue.
	https://www.rabbitmq.com/tutorials/tutorial-six-python.html
	
	QPID: 
	Client can send to Queue directly (/test), or to exchange (if exchange is mapped to queue).
	subject must match binding key of exchange-queue-binding.
	Server must subscribe to queue directly, I guess... (did not work otherwise)
	
"

	[
		| conn serverConn |
		"Subscribe to new temporary client Queue"
		conn := AMQPConnection connectAddress: 'amqp://192.168.88.33:5672/#' timeout: 5000.
		conn subscribe.
		('CLIENT: Queue = ' + conn subscription address) out.
		
		Thread currentThread sleep: 500.
		
		"Send to named server queue"
		serverConn := AMQPConnection connectAddress: 'amqp://192.168.88.33:5672/amq.topic' timeout: 1000.
		('CLIENT: Send Request') out.
		serverConn send: ((AMQPMessage new)
			subject: '*';
			replyTo: conn subscription address;
			id: self newGUID asString;
			durable: true;
			bodySet: 'REQ' ++ Timestamp now;
			yourself).
		serverConn disconnect.
		
		conn receiveLoop: 10 callback: [:message |
			('CLIENT: Received Response:' ++ message id ++ message subject ++ message body format) out.
		].
		conn disconnect.
	] fork waitUntilReady.
	
	[
		| conn |
		"Subscribe to named server queue"
		conn := AMQPConnection connectAddress: 'amqp://192.168.88.33:5672/amq.topic' timeout: 5000.
		conn subscribe.
		('SERVER: Queue = ' + conn subscription address) out.
		conn receiveLoop: 10 callback: [:message |
			| clientConn |
			('SERVER: Received Request:' ++ message id ++ message subject ++ message body format) out.
			clientConn := AMQPConnection connectAddress: message replyTo timeout: 1000.
			('SERVER: Send Response to' ++ message replyTo) out.
			clientConn send: ((AMQPMessage new)
				subject: '*';
				id: self newGUID asString;
				durable: false;
				bodySet: 'RES' ++ Timestamp now;
				yourself).
			clientConn disconnect.
		].
		conn disconnect.
	] fork waitUntilReady.
	
!"end testRPC "


testServerWeb
"
	'nothing' Test fuer Performance Messung.
"
(TT := [
		| conn |
		"Subscribe to named server queue"
		conn := AMQPConnection connectAddress: 'amqp://192.168.88.33:5672/amq.topic' timeout: 30000.
		Thread currentThread attributeAt: #'AMQP_CONNECTION' put: conn.
		conn receiveForEverCallback: [:message |
			| clientConn |
			('SERVER: Received Request:' ++ message id ++ message subject ++ message body format) out.
			clientConn := AMQPConnection connectToReply: message.
			('SERVER: Send Response to' ++ message replyTo) out.
			clientConn send: ((AMQPMessage new)
				subject: message subject;
				durable: false;
				bodySet:  '{ "ts": "' + Timestamp now asString + '"}';
				yourself).
			clientConn disconnect.
		].
		conn disconnect.
	] fork) waitUntilReady.

"
(TT attributeAt: #'AMQP_CONNECTION') interrupt.
TT attributeAt: #'AMQP_TERMINATE' put: true.
"
!"end testServerWeb "


!"End of class methods block"


! AMQPConnection methods!


checkError: message
	| result |
	result := messenger errno.
	result > 0 ifTrue: [
		message destroy.
		Exception raiseErrorString: ('Messenger Error' ++ result) out.
	].
	

!"end checkError: "


connect: aString
	
	messenger ifNotNil: [
		self disconnnect.
	].
	
	address := aString.
	
	messenger := AMQPMessenger newName: nil.
	
	messenger start.
	messenger check.
	
!"end connect: "


disconnect
	self log: #trace key: #amqp msg: 'Disconnect'.
	messenger ifNotNil: [messenger stop].
	messenger := nil.
	subscription := nil.
!"end disconnect "


finalize
	self log: #trace key: #amqp msg: 'Finalize'.
	messenger ifNotNil: [
		self disconnect.
	].
!"end finalize "


incomingQueue
	incomingQueue ifNil: [
		incomingQueue := AMQPQueue new: messenger type: #in track: track.
	].
	^incomingQueue.
!"end incomingQueue "


initialize
	windowSize := 1. "Could be separate for incomming/outgoing, but currently use same size for both"
	timeout := 5000.
	track := false.
	
!"end initialize "


interrupt
	self log: #trace key: #amqp msg: 'Interrupt'.
	messenger ifNil: [^self].
	^messenger interrupt.
!"end interrupt "


log: traceSymbol key: keySymbol msg: msgStringOrSymbol
	(self class name asString + '>>' + msgStringOrSymbol) out.
!"end log:key:msg: "


outgoingQueue
	outgoingQueue ifNil: [
		outgoingQueue := AMQPQueue new: messenger type: #out track: track.
	].
	^outgoingQueue.
!"end outgoingQueue "


receive
	|  messages |
	messages := self receive: -1.
	^messages.
!"end receive "


receive: anInteger
	|  messages |

	self log: #trace key: #amqp msg: 'Receive: ' + anInteger.
	
	self incomingQueue window: anInteger. "Must be before subscribe for auto accept ?"
	self subscribe.
	
"	('Messenger>>receive: ' + anInteger + ' (wait for 5000 ms)') out."
	messages := OrderedCollection new.
	self receiveLoop: anInteger callback: [:msg | messages add: msg ].
	^messages.
	
!"end receive: "


receiveForEverCallback: aBlock
"
	Only for tests.
"
	self incomingQueue window: self windowSize. "Must be before subscribe for auto accept ?"
	self subscribe.
	
	[(Thread currentThread attributeAt: #'AMQP_TERMINATE') ~= true] whileTrue: [
		[
			self receiveLoopDo: aBlock.
		] on: AMQPError do: [:ex | ex out ].
	].
!"end receiveForEverCallback: "


receiveLoop: anInteger callback: aBlock
"
	Must first subscribe to something, before calling receive Loop!
"
	|  result message result |
	
	self log: #trace key: #amqp msg: 'Receive Loop'.
	messenger timeout: self timeout.
	
	result := self incomingQueue receive: anInteger.
	result < 0 ifTrue: [(AMQPError newCode: result) signal].
	
	self log: #trace key: #amqp msg: 'Incoming:' ++ messenger incoming.
	[self incomingQueue size > 0] whileTrue: [
		self log: #trace key: #amqp msg: 'Get Message'.
		message := AMQPMessage new.
		result := self incomingQueue get: message.
		aBlock isNil ifTrue: [
			(message print ++ message printBody) out.
		] ifFalse: [
			self log: #trace key: #amqp msg: 'Evaluate Callback block'.
			aBlock value: message.
		].
	].
	
	
!"end receiveLoop:callback: "


receiveLoopDo: aBlock
	^self receiveLoop: self windowSize callback: aBlock.
!"end receiveLoopDo: "


send: aMessage
	|   t1 result |
	
	self log: #trace key: #amqp msg: 'Send message'.
	
	messenger ifNil: [Exception raiseErrorString: 'NotConnected'].
	self outgoingQueue window: self windowSize. "Only track 1 message"
	
	aMessage address isNilOrBlank ifTrue: [
		self log: #trace key: #amqp msg: 'Set address to ' + address.
		aMessage address: address.
	].

	self log: #trace key: #amqp msg: 'Put message'.
	result := self outgoingQueue put: aMessage.
	messenger check.
	
	self log: #trace key: #amqp msg: 'Send'.
	result := self outgoingQueue sendAll.
	messenger check.

	result := self outgoingQueue statusSymbol.
	self log: #trace key: #amqp msg: 'Status:' ++ result.
	
	^result.
!"end send: "


sendString: aString
	|  message body result |

	message := AMQPMessage new.

	message address: address.
	message id: self class newGUID asString.
	message durable: true.

	body := message body.
	body putString: aString.

	result := self send: message.
	
	^message.
!"end sendString: "


subscribe

	(messenger) ifNil: [Exception raiseErrorString: 'NotConnected'].	
	messenger timeout: self timeout.
	
	self log: #trace key: #amqp msg: 'Subscribe to ' ++ address.
	(subscription := messenger subscribe: address).
	
	^subscription.
!"end subscribe "


subscription
	^subscription.
!"end subscription "


timeout
	^timeout.
!"end timeout "


timeout: anInteger
	timeout := anInteger.
	messenger ifNotNil: [
		messenger timeout: anInteger.
	].
!"end timeout: "


track
	^track.

!"end track "


track: aBoolean
	track := aBoolean.

!"end track: "


windowSize
	^windowSize.

!"end windowSize "


windowSize: anInteger
	windowSize := anInteger.

!"end windowSize: "


!"End of methods block"

