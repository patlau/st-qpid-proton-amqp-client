Object subclass: #ApplicationLoader
instanceVariableNames: '
'
classVariableNames: '
'
poolDictionaries: '
' !


! ApplicationLoader class methods!

initialize
"
	This class is here because the standard class loading mechanism in
	ObjectStudio 7 can only load class files. So I do all extended loading stuff
	here.
"
	'Loading Test Environment...' out.
	(File exists: FileStream defaultPath + '\AMQP.txt') ifTrue: [
		ApplicationDefinitionStream loadFilename: FileStream defaultPath + '\AMQP.txt'.
	].
	ApplicationDefinitionStream loadFilename: 'SUnit\Sunit.txt'.
	ApplicationDefinitionStream loadFilename: 'SUnit\SunitUI.txt'.
	(File exists: FileStream defaultPath + '\Test.txt') ifTrue: [
		ApplicationDefinitionStream loadFilename: FileStream defaultPath + '\Test.txt'.
	].
	SystemTranscript open.
	TestRunner open.
!

!"End of class methods block"


! ApplicationLoader methods!


!"End of methods block"

