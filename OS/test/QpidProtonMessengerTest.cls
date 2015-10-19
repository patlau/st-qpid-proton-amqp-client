TestCase subclass: #QpidProtonMessengerTest
instanceVariableNames: '
	messenger
'
classVariableNames: '
'
poolDictionaries: '
' !


! QpidProtonMessengerTest class methods!


!"End of class methods block"


! QpidProtonMessengerTest methods!


setUp
	messenger := QpidProtonMessenger new.

!"end setUp "


tearDown
	messenger destroy.
	messenger := nil.

!"end tearDown "


!"End of methods block"

