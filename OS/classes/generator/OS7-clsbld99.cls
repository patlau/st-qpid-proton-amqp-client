ClassBuilder SecondaryFile!

!ClassBuilder methods!


createNewClass
	| class stream |
	class := self compileStream: self asClassSourceStreamHeader.
	self privateSetPrimaryFileFor: class.
	^class
!

createOrLoadNewClass
	| class |
	class := Class compiler compileStream: self asClassSourceStreamHeader init: false reload: false.
	self privateSetPrimaryFileFor: class.
	^class
!

name: className 
 superclass: aSuperclass
 instanceVariableNames: instVarString
 classVariableNames: classVarString
 poolDictionaries: poolVarString

	name := className.
	superclass := aSuperclass.
	instanceVariableNames := instVarString.
	classVariableNames := classVarString.
	poolDictionaries := poolVarString.

!

privateSetPrimaryFileFor: class
" Set correct primary file info "
	| stream |
	class isClass ifTrue: [
		FileInContext notNil ifTrue: [
			stream := FileInContext at: #stream ifAbsent: [ ^self ].
			(stream respondsTo: #fileName) ifTrue: [
				class setPrimaryFileTo: (File fullPathOf: stream fileName).
			].
			(FileInContext at: #classes ifAbsentPut: [ IdentitySet new ]) add: class.
		].
	].

!

recreateAs: anOldClass
" Recreate as existing class. Replace class header and adopt class methods "
	oldClass := anOldClass.
	^self recreateExistingClass.

! !
