Object subclass: #AMQPWrapper
instanceVariableNames: '
'
classVariableNames: '
'
poolDictionaries: '
' !


! AMQPWrapper class methods!


!"End of class methods block"


! AMQPWrapper methods!


destroy
	self privateWrappedObject ifNotNil: [self privateWrappedObject destroy].
!"end destroy "


doesNotUnderstand: selector args: args
"
	OS8: I dont know how to convert Booleans to ints automatically.
"
	(self privateWrappedObject respondsTo: selector) ifTrue: [
		^self privateWrappedObject perform: selector withArguments: (args
			collect: [:each | each isBoolean ifTrue: [each asParameter] ifFalse: [each]]).
	].
	^super doesNotUnderstand: selector args: args.
!"end doesNotUnderstand:args: "


log: traceSymbol key: keySymbol msg: msgStringOrSymbol
"	(self class name asString + '>>' + msgStringOrSymbol) out."
!"end log:key:msg: "


privateWrappedObject
	^self implementedBySubclass.
!"end privateWrappedObject "


respondsTo: aSymbol
	(super respondsTo: aSymbol) ifTrue: [^true].
	^self privateWrappedObject respondsTo: aSymbol.
!"end respondsTo: "


!"End of methods block"

