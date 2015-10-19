Object subclass: #ClassBuilder
instanceVariableNames: '
	classVariableNames
	instanceVariableNames
	name
	oldClass
	poolDictionaries
	superclass
'
classVariableNames: '
'
poolDictionaries: '
' !
! ClassBuilder class methods!


!"End of class methods block"


! ClassBuilder methods!


asClassSourceStreamForExistingClass

	self oldClass isFileBased ifTrue: [
		^ClassSourceStream 
			rewriteClassHeader:	(FileStream file: self oldClassFileName)
			className:				self name
			super:					self superString
			instanceVariables:	self instanceVariablesArray
			classVariables:		self classVariablesArray
			poolDictionaries:		self poolDictionariesArray
			oldClassName:			self oldClassName.
	].
	^self asClassSourceStreamHeader
		writeAllClassMethods: self oldClass class methodSourceDict;
		writeAllInstanceMethods: self oldClass methodSourceDict.
!"end asClassSourceStreamForExistingClass "


asClassSourceStreamHeader

	^(ClassSourceStream newClassName: self name)
		writeClassDeclarationSuper:	self superString
		instanceVariables:				self instanceVariablesArray
		classVariables:					self classVariablesArray
		poolDictionaries:					self poolDictionariesArray
!"end asClassSourceStreamHeader "


classExists

	^self oldClass notNil or: [ self name asClass isClass ]
!"end classExists "


classVariableNames: cvarString
	classVariableNames := cvarString.
	
!"end classVariableNames: "




classVariablesArray
	"convert cvar string to an array of cvar names"
	^classVariableNames asArrayOfSubstrings
!"end classVariablesArray "


compileStream: aStream
	^Class compiler compileStream: aStream init: false reload: true
!"end compileStream: "


create

	self classExists ifTrue: [
		^self recreateExistingClass.
	] ifFalse: [
		^self createNewClass.
	].

!"end create "


createNewClass
	| aStream |
	aStream := self asClassSourceStreamHeader.
	^self compileStream: aStream
!"end createNewClass "


definition

	^self asClassSourceStreamHeader asString removeAll: '!'
!"end definition "


instanceVariableNames: ivarString
	instanceVariableNames := ivarString.
	
!"end instanceVariableNames: "




instanceVariablesArray
	"convert ivar string to an array of ivar names"
	^instanceVariableNames asArrayOfSubstrings
!"end instanceVariablesArray "


name
	^name
!"end name "


name: aNameString
	name := aNameString asSymbol.
!"end name: "


oldClass
	^oldClass
!"end oldClass "


oldClass: aClass
	oldClass := aClass

!"end oldClass: "


oldClassFileName
	^self oldClass primaryFile
!"end oldClassFileName "


oldClassName
	^oldClass name
!"end oldClassName "


poolDictionaries: poolDictString
	poolDictionaries := poolDictString.

!"end poolDictionaries: "


poolDictionariesArray
	^poolDictionaries asArrayOfSubstrings

!"end poolDictionariesArray "


recreateExistingClass
	| aStream descriptors ans repShadowClass repBased |

	self setOldClass.	
	(repBased := self oldClass isRepositoryBased) ifTrue: [
		repShadowClass := self oldClass repShadowClass.
	].
	
	aStream := self asClassSourceStreamForExistingClass.
	descriptors := self oldClass destroyAllSubclasses.
	self oldClass destroy.

	ans := self compileStream: aStream.
	(self oldClass ~= self name ) ifTrue: [
		self oldClass subclasses do: [ :ea |
			ea asClass superclass: ans 
		].
	].
	
	repBased ifTrue: [
		ans isClass ifTrue: [
			repShadowClass uninstall.
			repShadowClass := repShadowClass asWorkingVersion.
			repShadowClass name: ans name.
			repShadowClass updateDefinition install.
		].
	].
	
	ans isClass ifTrue: [
		ans reloadSubclasses: descriptors.
	].
	^ans

!"end recreateExistingClass "


setOldClass

	self oldClass isNil ifTrue: [ 
		self oldClass: self name asClass.
	].
!"end setOldClass "


superclass: aClass
	superclass := aClass.
!"end superclass: "


superString
	"answer a string representing new superclass ('nil' or 'ClassName')"

	^superclass isNil 
		ifTrue:	[ 'nil' ]
		ifFalse:	[ superclass name asString ]
!"end superString "


!"End of methods block"


