Object subclass: #AMQPConnection
instanceVariableNames: '
	address
	window
	messenger
	subscription
	timeout
'
classVariableNames: '
	instances
'
poolDictionaries: '
' !


! AMQPConnection class methods!


connectAddress: aString timeout: anInteger
	| obj |
	obj := self new.
	obj connect: aString.
	obj timeout: anInteger.
	^obj.
!"end connectAddress:timeout: "


copyDLL
	^ExternalLibrary copyDLL: (Array with: 'qpid-proton').
!"end copyDLL "


initialize
	instances := WeakIdentitySet new.
	self copyDLL.
	

!"end initialize "


new
	| obj |
	obj := super new.
	
	"For finalize"
	instances add: obj.
	
	^obj.
!"end new "


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

	SS := AMQPConnection new.
	SS connect: CS.
	SS sendString: 'AAA'.
	SS disconnect.
	SS := nil.
	
	[	| conn msg |
		conn := AMQPConnection new.
		conn connect: CS.
		msg := conn receive.
		msg out.
		conn disconnect.
	] fork.
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
				id: VE2000 nextFreeKey asString;
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
			id: VE2000 nextFreeKey asString;
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
				id: VE2000 nextFreeKey asString;
				durable: false;
				bodySet: 'RES' ++ Timestamp now;
				yourself).
			clientConn disconnect.
		].
		conn disconnect.
	] fork waitUntilReady.
	
!"end testRPC "


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


interrupt
	self log: #trace key: #amqp msg: 'Interrupt'.
	messenger ifNil: [^self].
	^messenger interrupt.
!"end interrupt "


log: traceSymbol key: keySymbol msg: msgStringOrSymbol
	(self class name asString + '>>' + msgStringOrSymbol) out.
!"end log:key:msg: "


receive
	|  messages |
	messages := self receive: self window.
	^messages first.
!"end receive "


receive: anInteger
	|  messages |

	self log: #trace key: #amqp msg: 'Receive: ' + anInteger.
	
	self subscribe.
	
"	('Messenger>>receive: ' + anInteger + ' (wait for 5000 ms)') out."
	messages := OrderedCollection new.
	self receiveLoop: anInteger callback: [:msg | messages add: msg ].
	^messages.
	
!"end receive: "


receiveLoop: anInteger callback: aBlock
"
	Must first subscribe to something, before calling receive Loop!
"
	|  result message result |
	
	self log: #trace key: #amqp msg: 'Receive Loop'.
	messenger timeout: self timeout.
	result := messenger receive: anInteger.
	result < 0 ifTrue: [(AMQPError newCode: result) signal].
	
	self log: #trace key: #amqp msg: 'Incoming:' ++ messenger incoming.
	[messenger incoming > 0] whileTrue: [
		self log: #trace key: #amqp msg: 'Get Message'.
		message := AMQPMessage new.
		result := messenger get: message.
		aBlock isNil ifTrue: [
			('Message Received [ID=' + message id + ', SUBJECT=' + message subject + ', ADDRESS=' ++ message address ++ ' , BODY=' ++ message body format + ']') out.
		] ifFalse: [
			self log: #trace key: #amqp msg: 'Evaluate Callback block'.
			aBlock value: message.
		].
	].
	
	
!"end receiveLoop:callback: "


receiveLoopDo: aBlock
	^self receiveLoop: self window callback: aBlock.
!"end receiveLoopDo: "


send: aMessage
	|   t1 result |
	
	self log: #trace key: #amqp msg: 'Send message'.
	
	messenger ifNil: [Exception raiseErrorString: 'NotConnected'].
	messenger outgoingWindow: 1.
	
	aMessage address isNilOrBlank ifTrue: [
		self log: #trace key: #amqp msg: 'Set address to ' + address.
		aMessage address: address.
	].

	self log: #trace key: #amqp msg: 'Put message'.
	result := messenger put: aMessage.
	messenger check.
	
	t1 := messenger outgoingTracker.
	
	self log: #trace key: #amqp msg: 'Send'.
	result := messenger send: -1.
	messenger check.

	result := messenger status: t1.	
	result := (QpidProtonLibrary class pn_status_t keyAtValue: result).
	
	self log: #trace key: #amqp msg: 'Result:' ++ result.
	
	^result.
!"end send: "


sendString: aString
	|  message body result |

	message := AMQPMessage new.

	message address: address.
	message subject: 'TEST'.
	message id: VE2000 nextFreeKey asString.
	message durable: true.

	body := message body.
	body putString: aString.

	result := self send: message.
	
	^message.
!"end sendString: "


setWindow: anInteger
	window := anInteger.
!"end setWindow: "


subscribe

	(messenger) ifNil: [Exception raiseErrorString: 'NotConnected'].
	
	messenger incomingWindow: self window.
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


window
	^window ifNil: [1].
!"end window "


!"End of methods block"

