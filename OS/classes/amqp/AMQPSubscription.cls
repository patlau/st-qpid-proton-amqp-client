AMQPWrapper subclass: #AMQPSubscription
instanceVariableNames: '
	subscription
'
classVariableNames: '
'
poolDictionaries: '
' !


! AMQPSubscription class methods!


new: anObject
	| obj |
	obj := super new.
	obj varAt: #subscription put: anObject.
	^obj.
!"end new: "


!"End of class methods block"


! AMQPSubscription methods!


destroy
	super destroy.
	subscription := nil.
!"end destroy "


privateWrappedObject
	^subscription.
!"end privateWrappedObject "


!"End of methods block"

