ExternalLibrary subclass: #OLE32DLL
instanceVariableNames: ''
classVariableNames: ''
poolDictionaries: '' !


!OLE32DLL class methods!


initialize
	System at: #OLE32Library put: self new.
!


new
	| obj |
	obj := self newName: 'ole32.dll'.
	(obj isKindOf: ExternalLibrary) ifFalse: [
		^ 'could not initialize ole32.dll.' asMessage.
	]."endif"
	obj initialize.
	^ obj.
!


!


!OLE32DLL methods!


initialize
	| params temp |
	params := Array with: ((VStructure structObj: OLEGuid new) passedBy: #reference).
	self newProcedureNamed: #CoCreateGuid
			paramVars: params	callingConvention: #C returns: VDWord new.
	params := Array with: ((VStructure structObj: OLEGuid new) passedBy: #reference)
			with: ((VStructure structObj: OLEGuid new) passedBy: #reference).
	self newProcedureNamed: #IsEqualGUID
			paramVars: params	callingConvention: #C returns: VBoolean new.
"
	params := Array with: ((VStructure structObj: OLEGuid new) passedBy: #reference)
			with: ((VStructure structObj: OLEGuid new) passedBy: #reference).
	self newProcedureNamed: #IsEqualIID
			paramVars: params	callingConvention: #C returns: VBoolean new.
"
	params := Array with: (VUnicodeString passedBy: #reference)
			with: ((VStructure structObj: OLEGuid new) passedBy: #reference).
	self newProcedureNamed: #CLSIDFromString
			paramVars: params	callingConvention: #C returns: VBoolean new.

"	StgCreateDocfile"
	"
	const WCHAR * pwcsName;
   DWORD mode;
   DWORD reserved;
   IStorage FAR * FAR *ppStgOpen;
	"
	params := Array new: 4.
	params at: 1 put: (VUnicodeString passedBy: #reference).
	params at: 2 put: VDWord new.
	params at: 3 put: VDWord new.
	params at: 4 put: (VAddress passedBy: #referenceOut).
	self newProcedureNamed: #StgCreateDocfile
			paramVars: params	callingConvention: #C returns: VDWord new.

"	StgCreateDocfileOnILockBytes"
	"
	ILockBytes FAR *plkbyt;
   DWORD mode;
   DWORD reserved;
   IStorage FAR * FAR *ppStgOpen;
	"
	params := Array new: 4.
	params at: 1 put: (VInterface interfaceClass: ILockBytes).
	params at: 2 put: VDWord new.
	params at: 3 put: VDWord new.
	params at: 4 put: (VAddress passedBy: #referenceOut).
	self newProcedureNamed: #StgCreateDocfileOnILockBytes
			paramVars: params	callingConvention: #C returns: VDWord new.

"	StgOpenStorage"
	"
	const WCHAR* pwcsName;
   IStorage  *pStgPriority;
   DWORD mode;
   SNB snbExclude;
   DWORD reserved;
   IStorage  * *ppStgOpen;
	"
	params := Array new: 6.
	params at: 1 put: (VUnicodeString passedBy: #reference).
	params at: 2 put: (VInterface interfaceClass: IStorage).
	params at: 3 put: VDWord new.
	params at: 4 put: (VPointer pointsTo: (VPointer pointsTo: VUnicodeString new)).
	params at: 5 put: VDWord new.
	params at: 6 put: (VAddress passedBy: #referenceOut).
	self newProcedureNamed: #StgOpenStorage
			paramVars: params	callingConvention: #C returns: VDWord new.

 "	StgOpenStorageOnILockBytes"
	"
	ILockBytes  *plkbyt;
   IStorage *pStgPriority;
   DWORD mode;
   SNB snbExclude;
   DWORD reserved;
   IStorage  * *ppStgOpen;
	"
	params := Array new: 6.
	params at: 1 put: (VInterface interfaceClass: ILockBytes).
	params at: 2 put: (VInterface interfaceClass: IStorage).
	params at: 3 put: VDWord new.
	params at: 4 put: (VPointer pointsTo: (VPointer pointsTo: VUnicodeString new)).
	params at: 5 put: VDWord new.
	params at: 6 put: (VAddress passedBy: #referenceOut).
	self newProcedureNamed: #StgOpenStorageOnILockBytes
			paramVars: params	callingConvention: #C returns: VDWord new.

"	StgIsStorageFile"
	"
	WCHAR* 	pwcsName;
	"
	params := Array new: 1.
	params at: 1 put: (VUnicodeString  passedBy: #reference).
	self newProcedureNamed: #StgIsStorageFile
			paramVars: params callingConvention: #C returns: VDWord new.

"StgIsStorageILockBytes"
	"
	ILockBytes * plkbyt;
	"
	params := Array new: 1.
	params at: 1 put: (VInterface interfaceClass: ILockBytes).
	self newProcedureNamed: #StgIsStorageILockBytes
			paramVars: params	callingConvention: #C returns: VDWord new.

"	StgSetTimes"
	"
	char WCHAR* lpszName;
   FILETIME const * pctime;
   FILETIME const * patime;
   FILETIME const * pmtime;
	"
	params := Array new: 4.
	params at: 1 put: (VUnicodeString passedBy: #reference).
	params at: 2 put:
			((VStructure structObj: OLEFileTime new) passedBy: #reference).
	params at: 3 put:
			((VStructure structObj: OLEFileTime new) passedBy: #reference).
	params at: 4 put:
			((VStructure structObj: OLEFileTime new) passedBy: #reference).
	self newProcedureNamed: #StgSetTimes
			paramVars: params	callingConvention: #C returns: VDWord new.
!


createGuidString
" create a new guid, and return its string representation "
	| result guid aParam |
	aParam := Parameter new.
	result := self coCreateGuid: aParam.
	result succeeded ifTrue: [
		^ aParam value guidString.
	] ifFalse: [
		^ self error: result.
	].
!


clsidFromString: aParam
	| params result |

	params := Array with: aParam with: nil.
	result := self call: #CLSIDFromString with: params.
	^ result ifTrue: [
		params at: 2.
	] ifFalse: [
		nil
	]

!"end clsidFromString: "


coCreateGuid: aParam
	| params result |
	params := Array with: nil.
	result := self call: #CoCreateGuid with: params.
	result := OLEHResult newCode: result.
	result succeeded ifTrue: [
		aParam value: (params at: 1).
	].
	^ result.
!


createDocfile: name mode: mode reserved: reserved storage: storage
	| params result |
	params := Array new: 4.
	params at: 1 put: name.
	params at: 2 put: mode.
	params at: 3 put: reserved.
	params at: 4 put: nil.
	result := self call: #StgCreateDocfile with: params.
	result := OLEHResult newCode: result.
	result succeeded ifTrue: [
		storage value: (IStorage withInterface: (params at: 4)).
	].
	^ result.
!


createDocfileOnILockBytes: iLockBytes mode: mode reserved: reserved storage: storage
	| params result |
	params := Array new: 4.
	params at: 1 put: iLockBytes.
	params at: 2 put: mode.
	params at: 3 put: reserved.
	params at: 4 put: nil.
	result := self call: #StgCreateDocfileOnILockBytes with: params.
	result := OLEHResult newCode: result.
	result succeeded ifTrue: [
		storage value: (IStorage withInterface: (params at: 4)).
	].
	^ result.
!


openStorage: name priority: priority mode: mode
		snbExclusive: snbExclusive reserved: reserved storage: storage
 	| params result |
	params := Array new: 6.
	params at: 1 put: name.
	params at: 2 put: priority.
	params at: 3 put: mode.
	params at: 4 put: snbExclusive.
	params at: 5 put: reserved.
	params at: 6 put: nil.
	result := self call: #StgOpenStorage with: params.
	result := OLEHResult newCode: result.
	result succeeded ifTrue: [
		storage value: (IStorage withInterface: (params at: 6)).
	].
	^ result.
!


openStorageOnILockBytes: iLockBytes priority: priority mode: mode
		snbExclusive: snbExclusive reserved: reserved storage: storage
	| params result |
	params := Array new: 6.
	params at: 1 put: iLockBytes.
	params at: 2 put: priority.
	params at: 3 put: mode.
	params at: 4 put: snbExclusive.
	params at: 5 put: reserved.
	params at: 6 put: nil.
	result := self call: #StgOpenStorageOnILockBytes with: params.
	result := OLEHResult newCode: result.
	result succeeded ifTrue: [
		storage value: (IStorage withInterface: (params at: 6)).
	].
	^ result.
!


isStorageFile: name
	| params result |
	params := Array new: 1.
	params at: 1 put: name.
	result := self call: #StgIsStorageFile with: params.
	^ OLEHResult newCode: result.
!


isStorageILockBytes: iLockBytes
 	| params result |
	params := Array new: 1.
	params at: 1 put: iLockBytes.
	result := self call: #StgIsStorageILockBytes with: params.
	^ OLEHResult newCode: result.
!


stgSetTimes: name pcTime: pcTime paTime: paTime pmTime: pmTime
 	| params result |
	params := Array new: 4.
	params at: 1 put: name.
	params at: 2 put: pcTime.
	params at: 3 put: paTime.
	params at: 4 put: pmTime.
	result := self call: #StgSetTimes with: params.
	^ OLEHResult newCode: result.
!


loadTypeLib: name
   ^ OLEAutomationLibrary loadTypeLib: name
!


!
