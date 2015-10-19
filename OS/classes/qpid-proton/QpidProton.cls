Object subclass: #QpidProton
instanceVariableNames: '
	freeOnFinalize
'
classVariableNames: '
	instances
'
poolDictionaries: '
' !


! QpidProton class methods!


errorCodes
"
	#defines are currently not generated. So we define this here.
"
	^(IdentityDictionary new)
		at: #PN_OK put: (0);
		at: #PN_EOS put: (-1);
		at: #PN_ERR put: (-2);
		at: #PN_OVERFLOW put: (-3);
		at: #PN_UNDERFLOW put: (-4);
		at: #PN_STATE_ERR put: (-5);
		at: #PN_ARG_ERR put: (-6);
		at: #PN_TIMEOUT put: (-7);
		at: #PN_INTR put: (-8);
		at: #PN_INPROGRESS put: (-9);
		at: #PN_OUT_OF_MEMORY put: (-10);
		yourself.
!"end errorCodes "


errorMessageForCode: anInteger
	^QpidProtonLibrary pn_code: anInteger.
!"end errorMessageForCode: "


errorSymbolForCode: anInteger
	^self errorCodes keyAt: anInteger.
!"end errorSymbolForCode: "


initialize
	instances := WeakIdentitySet new.
!"end initialize "


new
	| obj |
	
	(self name asString + '>>new') out.
	
	obj := super new.
	
	"Do not free Data objects, because they are normally freed by the message object"
	self name = #QpidProtonData ifTrue: [
		obj freeOnFinalize: false.
	].
	
	instances add: obj.
	
	^obj.
!"end new "


!"End of class methods block"


! QpidProton methods!


destroy
	self log: #trace key: self class name msg: 'Destroy (freeOnFinalize=' + (freeOnFinalize ~= false) + ')'.
	freeOnFinalize ~= false ifTrue: [
		(self respondsTo: #free) ifTrue: [self free].
	].
	instances remove: self.
!"end destroy "


finalize
	self log: #trace key: self class name msg: 'Finalize'.
	self destroy.
!"end finalize "


freeOnFinalize: aBoolean
	self log: #trace key: self class name msg: 'FreeOnFinalize:' ++ aBoolean.
	freeOnFinalize := aBoolean.
!"end freeOnFinalize: "


log: traceSymbol key: keySymbol msg: msgStringOrSymbol
"	(keySymbol asString + '>>' + msgStringOrSymbol) out."
!"end log:key:msg: "


!"End of methods block"

