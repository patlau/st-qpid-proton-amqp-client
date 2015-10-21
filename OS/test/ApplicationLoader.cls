Object subclass: #ApplicationLoader
instanceVariableNames: '
'
classVariableNames: '
'
poolDictionaries: '
' !


! ApplicationLoader class methods!

initialize
	System isInVW ifTrue: [
		self initializeOS8.
	] ifFalse: [
		self initializeOS7.
	].
!

initializeOS7
"
	This class is here because the standard class loading mechanism in
	ObjectStudio 7 can only load class files. So I do all extended loading stuff
	here.
"
	'Loading Test Environment...' out.
	(File exists: FileStream defaultPath + '\OS7-Messaging.txt') ifTrue: [
		ApplicationDefinitionStream loadFilename: FileStream defaultPath + '\OS7-Messaging.txt'.
	].
	ApplicationDefinitionStream loadFilename: 'SUnit\Sunit.txt'.
	ApplicationDefinitionStream loadFilename: 'SUnit\SunitUI.txt'.
	(File exists: FileStream defaultPath + '\Test.txt') ifTrue: [
		ApplicationDefinitionStream loadFilename: FileStream defaultPath + '\Test.txt'.
	].
	SystemTranscript open.
	TestRunner open.
!

initializeOS8
"
	
"
	'Loading Test Environment...' out.
	(File exists: FileStream defaultPath + '\OS7-Messaging.txt') ifTrue: [
		ApplicationDefinitionStream loadFilename: FileStream defaultPath + '\OS7-Messaging.txt'.
	].
	(File exists: FileStream defaultPath + '\Test.txt') ifTrue: [
		ApplicationDefinitionStream loadFilename: FileStream defaultPath + '\Test.txt'.
	].
	SystemTranscript open.
"	TestRunner open."
	System whenIdleSend: #recompileMethods to: QpidProtonDLL.
!

!"End of class methods block"


! ApplicationLoader methods!


!"End of methods block"

