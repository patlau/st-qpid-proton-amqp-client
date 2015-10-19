AMQPWrapper subclass: #AMQPMessage
instanceVariableNames: '
	id
	message
	body
'
classVariableNames: '
'
poolDictionaries: '
' !


! AMQPMessage class methods!


new
	^self new: QpidProtonMessage new.
!"end new "


new: aQpidProtonMessage
	| obj |
	obj := super new.
	obj varAt: #message put: aQpidProtonMessage.
	^obj.
!"end new: "


!"End of class methods block"


! AMQPMessage methods!


body
	body ifNil: [
		self log: #trace key: #amqpmessage msg: 'Get Body'.
		body := AMQPData new: super body.
	].
	^body.
!"end body "


bodyGet

	| body |
	
	self log: #trace key: #amqpmessage msg: 'BodyGet'.
	
	body := self body.

	self contentType = 'application/json' ifTrue: [
		^(Json readFrom: (ReadStream on: body getString)).
	].
	
	self contentType = 'text/plain' ifTrue: [
		^body getString.
	].
	
	^nil.
!"end bodyGet "


bodySet: anObject
"
	Momentan werden nur Strings unterstuetzt.
"

	| body |
	
	self log: #trace key: #amqpmessage msg: 'BodySet'.
	
	body := self body.

	(anObject isKindOf: Dictionary) ifTrue: [
		self contentType: 'application/json'. "Vendor specific: 'application/vnd+xxx'"
		body putString: (Json render: anObject) asString.
	].
	
	(anObject isString) ifTrue: [
		self contentType: 'text/plain'.
		body putString: anObject asString.
	].
	
	^self.
!"end bodySet: "


destroy
	super destroy.
	message := nil.
	id := nil.
	body := nil.
!"end destroy "


id
	self log: #trace key: #amqpmessage msg: 'Get ID'.
	id ifNil: [ id := AMQPData new: message getID].
	^id getString.
	
!"end id "


id: anObject
	self log: #trace key: #amqpmessage msg: 'Set ID:' ++ anObject.
	id ifNil: [ id := AMQPData new: message getID].
	id putString: anObject asString.

!"end id: "


privateWrappedObject
	^message.
!"end privateWrappedObject "


!"End of methods block"

