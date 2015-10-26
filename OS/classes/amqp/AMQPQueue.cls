Object subclass: #AMQPQueue
instanceVariableNames: '
	messenger
	type
	tracker
	track
'
classVariableNames: '
'
poolDictionaries: '
' !


! AMQPQueue class methods!


new: anAMQPConnection type: aSymbol track: aBoolean
	| obj |
	obj := super new.
	obj varAt: #messenger put: anAMQPConnection.
	obj varAt: #type put: aSymbol.
	obj varAt: #track put: aBoolean.
	^obj.

!"end new:type:track: "


!"End of class methods block"


! AMQPQueue methods!


accept
	self log: #trace key: #amqp msg: 'Accept:' ++ self tracker.
	^messenger accept: self tracker flags: 0.
!"end accept "


acceptAll
	self log: #trace key: #amqp msg: 'AcceptAll:' ++ self tracker.
	^messenger accept: self tracker flags: 1.
!"end acceptAll "


buffered
	^messenger perform: #buffered: with: self tracker.
	
!"end buffered "


get: aMessage
	| result |
	type = #in ifFalse: [self error: #InvalidState].
	result := messenger get: aMessage.
	result ifNotNil: [
		track ifTrue: [self newTracker].
	].
	^result.
!"end get: "


log: traceSymbol key: keySymbol msg: msgStringOrSymbol
	(self class name asString + '>>' + msgStringOrSymbol) out.

!"end log:key:msg: "


newTracker
	tracker := messenger perform: self privatePrefixSymbol + #Tracker.
	self log: #trace key: #amqp msg: 'Tracker:' ++ self tracker.
	^tracker.
!"end newTracker "


privatePrefixSymbol
	^self type = #in ifTrue: [#incoming] ifFalse: [#outgoing].

!"end privatePrefixSymbol "


privateWrappedObject
	^nil.

!"end privateWrappedObject "


put: aMessage
	| result |
	type = #out ifFalse: [self error: #InvalidState].
	result := messenger put: aMessage.
	result ifNotNil: [
		track ifTrue: [self newTracker].
	].
	^result.
!"end put: "


receive: anInteger
	type = #in ifFalse: [self error: #InvalidState].
	^messenger receive: anInteger.

!"end receive: "


reject
	self log: #trace key: #amqp msg: 'Reject:' ++ self tracker.
	^messenger reject: self tracker flags: 0.
!"end reject "


send: anInteger
	type = #out ifFalse: [self error: #InvalidState].
	^messenger send: anInteger.
!"end send: "


sendAll
	^self send: -1.

!"end sendAll "


size
	^messenger perform: self privatePrefixSymbol.
!"end size "


status
	track ~= true ifTrue: [^nil].
	^messenger perform: #status: with: self tracker.
!"end status "


statusSymbol
	track ~= true ifTrue: [^'TRACKING_DISABLED'].
	^QpidProtonDLL pn_status_t keyAtValue: self status.
!"end statusSymbol "


subscription
	type = #in ifFalse: [self error: #InvalidState].
	^messenger perform: self privatePrefixSymbol + #Subscription.
!"end subscription "


tracker
	tracker ifNil: [
		self newTracker.
	].
	^tracker.
!"end tracker "


type
	^type.

!"end type "


window
	^messenger perform: self privatePrefixSymbol + #Window.

!"end window "


window: anInteger
	^messenger perform: self privatePrefixSymbol + #Window: with: anInteger.

!"end window: "


!"End of methods block"

