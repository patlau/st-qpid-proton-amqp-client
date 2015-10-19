Error subclass: #AMQPError
instanceVariableNames: '
	code
'
classVariableNames: '
'
poolDictionaries: '
' !


! AMQPError class methods!


newCode: anInteger
	^self
		newCode: anInteger
		description: (QpidProton errorMessageForCode: anInteger).
!"end newCode: "


newCode: anInteger description: aString
	| obj |
	obj := self new.
	obj varAt: #code put: anInteger.
	obj varAt: #exString put: aString.
	^obj.
!"end newCode:description: "


newError: aQpidProtonError
	^self newCode: aQpidProtonError code description: aQpidProtonError text.
	
!"end newError: "


!"End of class methods block"


! AMQPError methods!


code
	^code.
!"end code "


exString
	^exString.
!"end exString "


text
	^self exString.
!"end text "


!"End of methods block"

