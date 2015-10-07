AMQPWrapper subclass: #AMQPMessenger
instanceVariableNames: '
	subscription
	messenger
'
classVariableNames: '
'
poolDictionaries: '
' !


! AMQPMessenger class methods!


new
	^super new initialize.
!"end new "


newName: aString
	| obj |
	obj := self new.
	obj varAt: #messenger put: (QpidProtonMessenger newName: aString).
	^obj.
!"end newName: "


!"End of class methods block"


! AMQPMessenger methods!


check
	| errno |
	errno := self errno.
	errno > 0 ifTrue: [
		Exception raiseErrorString: ('Messenger Error' ++ errno).
	].
	

!"end check "


destroy
	super destroy.
	messenger := nil.
!"end destroy "


initialize
	subscription := OrderedCollection new.
!"end initialize "


privateWrappedObject
	^messenger.
!"end privateWrappedObject "


receive: anInteger
	^messenger recv: anInteger.
!"end receive: "


subscribe: source
	| obj |
	obj := AMQPSubscription new: (super subscribe: source).
	subscription add: obj.
	^obj.
!"end subscribe: "


subscribe: source ttl: timeout
	| obj |
	obj := AMQPSubscription new: 
		(super subscribeTtl: source timeout: timeout).
	subscription add: obj.
	^obj.
!"end subscribe:ttl: "


!"End of methods block"

