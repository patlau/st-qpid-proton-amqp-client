Object subclass: #QpidProtonGenerator
instanceVariableNames: '
	content
	element
	includes
	currentHeaderFile
	state
	modelClasses
	destDir
	srcDir
'
classVariableNames: '
'
poolDictionaries: '
' !


! QpidProtonGenerator class methods!


modelClasses
	^{
		{#'QpidProtonMessage' #'pn_message'}
		{#'QpidProtonMessenger' #'pn_messenger'}
		{#'QpidProtonData' #'pn_data'}
		{#'QpidProtonSubscription' #'pn_subscription'}
		{#'QpidProtonError' #'pn_error'}
	}
!"end modelClasses "


parseFiles
	^(self new)
		srcDir: 'C:\Projekte\git\st-qpid-proton-amqp-client\qpid-proton\0.10.1\includes\';
		destDir: 'C:\Projekte\git\st-qpid-proton-amqp-client\OS\classes\qpid-proton\';
		generate: {#error #messenger #message #types #codec}. 
!"end parseFiles "


test
	QpidProtonGenerator parseFiles.
!"end test "


!"End of class methods block"


! QpidProtonGenerator methods!


addHardcoded
"
	For the momement.
"

	^self.

	content add: ((CObject new)
		name: #pn_bytes_t;
		type: #typedef;
		subtype: #struct;
		elements: ((OrderedCollection new)
			add: ((CObject new)
				name: #size;
				type: 'int';
				yourself);
			add: ((CObject new)
				name: #start;
				type: 'char*';
				yourself);
			yourself);
		yourself).
		
	content add: ((CObject new)
		name: #pn_bytes;
		type: #function;
		subtype: #pn_bytes_t;
		params: ((OrderedCollection new)
			add: ((CObject new)
				name: #size;
				type: 'size_t';
				yourself);
			add: ((CObject new)
				name: #start;
				type: 'const char*';
				yourself);
			yourself);
		yourself).
!"end addHardcoded "


destDir
	^destDir.
!"end destDir "


destDir: aString
	destDir := aString.
!"end destDir: "


generate: headerFiles
	
	content := OrderedCollection new.
	includes := IdentityDictionary new.
	
	headerFiles do: [:headerFile |
		self parseHeaderFile: headerFile.
	].
	
	self addHardcoded.
	self prepare.
	
	"Now the Model classes"
	
	self initModel.
	self prepareModel.
	
	self writeOS7.
"	self writeOS8."
!"end generate: "


initModel
	modelClasses := self class modelClasses.

!"end initModel "


srcDir: aValue
	srcDir := aValue.
":Section Category
accessing
:End"
!"end new method selector: "


srcDir
	^ srcDir.
":Section Category
accessing
:End"
!"end new method selector: "


loadFilesAfterGen
	^false.

!"end loadFilesAfterGen "


parseFunction: element

	| i words func |

	element type: #function.
		
	func := (element function asString copyReplaceAll: CrLf with: ' ') trimBlanks.
	(func indexOf: 'PN_EXTERN') = 1 ifTrue: [
		func := func copyFrom: 10.
	].
	words := self parseTypeNameList: (func copyTo: (func indexOf: '(') - 1).
	element subtype: (words type).
	element name: (words name).
	
	element name isNilOrBlank ifTrue: [element inspect. self halt: 'Name isNilOrBlank'].
	
	element params: OrderedCollection new.
	words := (func copyFrom: (func indexOf: '(') + 1 to: (func indexOf: ')') - 1) asArrayOfSubstringsDelimiter: $,.
	(words size = 1 and: [words first = #void]) ifFalse: [
		words do: [:param |
			| p |
			p := (self parseTypeNameList: param).
			p ifNotNil: [element params add: p].
		].
	].
	
	(includes at: currentHeaderFile) add: element.
	
	^element.
!"end parseFunction: "


parseHeaderFile: headerFile
	| stream |
	currentHeaderFile := headerFile asSymbol.
	includes at: currentHeaderFile put: OrderedCollection new.
	
	stream := NewFileStream file: self srcDir + headerFile + '.h'.
	[
		[stream atEnd] whileFalse: [
			self parseLine: stream nextString.
		].
	] ensure: [
		stream close.
	].
!"end parseHeaderFile: "


parseLine: aString
	| words |
	
	aString isBlank ifTrue: [^self].
	
	(aString trimBlanks indexOf: '/*') = 1 ifTrue: [
		state := #comment.
		element ifNotNil: [content add: element. element := nil. ].
		(aString trimBlanks indexOf: '/**') = 1 ifTrue: [
			element := CObject new.
			element comment: StreamString new.
		].
		^self.
	].
	
	(state ~= #comment and: [element isNil or: [element comment isNil or: [element type notNil]]]) ifTrue: [
		words := (aString trimBlanks asArrayOfSubstringsDelimiter: $ ) collect: [:each | each trimBlanks ].
		({#PN_EXTERN #typedef} includes: words first asSymbol) ifTrue: [
			"Elemente Ohne Kommentar"
			element ifNotNil: [content add: element. element := nil.].
			element := CObject new.
			state := nil.
		].
	].
	
	state = #comment ifTrue: [
		aString trimBlanks = '*/' ifTrue: [
			state := nil.
		] ifFalse: [
			element ifNotNil: [
				element comment append: aString.
				element comment append: CrLf.
			].
		].
		^self.
	].
	
	element ifNil: [^self].
	
	state = #enum ifTrue: [
		(aString trimBlanks indexOf: '}') = 1 ifTrue: [
			state := nil.
			element name: (aString copyFrom: 3 to: aString size - 1).
		] ifFalse: [
			element enumeration add: aString trimBlanks.
		].
		^self.
	].
	
	state = #struct_union ifTrue: [
		(aString indexOf: '}') > 0 ifTrue: [
			element elements last name: (aString copyFrom: (aString indexOf: '}') + 1 to: (aString indexOf: ';') - 1) trimBlanks.
			state := #struct.
		].
		^self.
	].
	
	state = #struct ifTrue: [
		(aString trimBlanks indexOf: '}') = 1 ifTrue: [
			state := nil.
			element name: (aString copyFrom: (aString indexOf: '}') + 1 to: (aString indexOf: ';') - 1) trimBlanks.
		] ifFalse: [
			
			(aString indexOf: #union) > 0 ifTrue: [
				state := #struct_union.
				element elements add: ((CObject new)
					name: nil;
					type: #union;
					yourself).
			] ifFalse: [
				element elements add: (self parseTypeNameList: (aString copyTo: (aString indexOf: ';') - 1) trimBlanks).
			].
		].
		^self.
	].
	
	state = #function ifTrue: [
		aString isBlank ifTrue: [
			state := nil.
		] ifFalse: [
			element function append: ' '.
			element function append: aString trimBlanks.
			(aString includes: $;) ifTrue: [
				state := nil.
				self parseFunction: element.
			].
		].
		^self.
	].
	
	words := (aString trimBlanks asArrayOfSubstringsDelimiter: $ ) collect: [:each | each trimBlanks ].
	
	(words first = 'typedef') ifTrue: [
		element type: #typedef.
		element subtype:  (words at: 2) asSymbol.
		element name: (words at: 3) asSymbol.
		
		element subtype = #enum ifTrue: [
			state := #enum.
			element enumeration: OrderedCollection new.
		].
		
		element subtype = #struct ifTrue: [
			state := #struct.
			element elements: OrderedCollection new.
		].
		
		(aString indexOf: ';') > 0 ifTrue: [
			state = #struct ifTrue: [
				"Ignore. Possibly a typedef struct without elements."
			].
			state := nil.
		].
		
	] ifFalse: [
		(words first = 'PN_EXTERN') ifTrue: [
			state := #function.
			element function: StreamString new.
			element function append: aString trimBlanks.
			(aString includes: $;) ifTrue: [
				state := nil.
				self parseFunction: element.
			].
		].
	].
	
	
!"end parseLine: "


parseTypeNameList: aString
	| words i el |
	
	el := CObject new.
	
	aString trimBlanks = '...' ifTrue: [
		el type: 'array'.
		el name: 'list'.
		^el.
	].
	
	words := (aString trimBlanks asArrayOfSubstringsDelimiter: $ ) collect: [:each | each trimBlanks ].
	
	el type: (words at: 1) asSymbol.
	i := 1.
	el type = #const ifTrue: [
		el type: el type ++ (words at: 2) asSymbol.
		i := 2.
	].
	
	(words size > i) ifTrue: [
		i := i + 1.
		(words at: i) first = $* ifTrue: [
			el type: el type + '*'.
			el name: ((words at: i) copyFrom: 2).
		] ifFalse: [
			el name: ((words at: i)).
		].
	].
	
	el name isNilOrBlank ifTrue: [
		words size > i ifTrue: [
			el name: (words at: i + 1).
		].
	].
	
	el name = #har ifTrue: [self halt].
	
	^el.
!"end parseTypeNameList: "


prepare
	
	"Enumerations werden erst hier angepasst"
	(content select: [:each | each type = #typedef and: [each subtype = #enum]]) do: [:each |
		self prepareEnum: each.
	].
	
	
	content do: [:each |
		each comment ifNotNil: [
			each comment: (each comment asString copyReplaceAll: '"' with: '''').
			each comment: (each comment asString copyReplaceAll: ' */' with: '').
			each comment: (each comment asString copyReplaceAll: ' *' with: '').
		].
	].
	
	(content select: [:each | each type = #typedef and: [each subtype = #struct]]) do: [:each |
		each elements ifNotNil: [
			each var: #'struct_' + each name.
		].
	].
	

!"end prepare "


prepareEnum: each
	| lines el result buffer counter |
		
	lines := each enumeration asOrderedCollection.
	(lines first isKindOf: CObject) ifTrue: [^self].
	
	result := OrderedCollection new.
	counter := 0.
	
	lines do:[:line |
		
		buffer ifNotNil: [buffer := buffer ++ line].
		
		buffer ifNil: [
			| name value |
			buffer := line.
			
			name := (buffer copyTo: (buffer indexOf: '=') - 1) trimBlanks asSymbol.
			value := (buffer copyFrom: (buffer indexOf: '=') + 1 to: (buffer indexOf: ',') - 1) trimBlanks.
			value isNilOrBlank ifTrue: [
				value := (buffer copyFrom: (buffer indexOf: '=') + 1 to: ((buffer indexOf: '/*') - 1)) trimBlanks.
				value isNilOrBlank ifTrue: [
					value := (buffer copyFrom: (buffer indexOf: '=') + 1) trimBlanks.
				].	
			].	
			
			name isNilOrBlank ifTrue: [
				name := value asSymbol.
				value := counter asString.
				counter := counter + 1.
			].
			
			el := CObject new.
			el name: name.
			el value: value.
		].
		
				
		"Wir gehen davon aus, dass immer ein Kommentar existiert"
		(buffer indexOf: '/*') > 0 ifTrue: [
			(buffer indexOf: '*/') > 0 ifTrue: [
				el comment: (buffer copyFrom: (buffer indexOf: '/*') + 3 to: (buffer indexOf: '*/') - 2) trimBlanks.
				buffer := nil.
				result add: el.
			].
		] ifFalse: [
			buffer := nil.
			result add: el.
		].
	].
	
	each enumeration: result.
!"end prepareEnum: "


prepareModel

	modelClasses do: [:model |
		| mType mClass |
			
		mType := model last + '_t'.
		mClass := self privateModelClassForType: mType.
		
		(self privateFunctionsFor: model last) do: [:function |
			| params callParams |
			
			params := StreamString new.
			callParams := OrderedCollection new.
			
			function isClassMethod: (function name = model last).
			
			function params do: [:param |
				| paramClass |
				
				(param type indexOf: mType) = 1 ifTrue: [
					function checkCall: mType ++ 'ifNil: [^nil].'.
					callParams add: mType ++ '"' + param type + '"'.
				] ifFalse: [
					(params size = 0) ifTrue: [
						function isClassMethod ifTrue: [
							params append: (param name setFirstChar: #asUpperCase) + ':'.
						] ifFalse: [
							params append: ':'. "For instance methods we do not name the first parameter"
						].
					] ifFalse: [
						params append: ' ' + (param name setFirstChar: #asLowerCase) + ':'.
					].
					params append: ' ' + param name.
					
					paramClass := self privateModelClassForType: (param type copyReplaceAll: '*' with: '').
					paramClass isNil ifTrue: [
						callParams add: param name ++ '"' + param type + '"'.
					] ifFalse: [
						callParams add: '((' + param name ++ 'respondsTo: #' + (param type copyReplaceAll: '*' with: '') + ') ifTrue: [' + param name ++ (param type copyReplaceAll: '*' with: '') +
							'] ifFalse: [' + param name + '])' ++ '"' + param type + '"'.
					].
					
				].
			].
			
			function selectorParams: params asString.
			function callParams: callParams.
			
		].
	].
!"end prepareModel "


privateClassFunctionsFor: classType
	^(self privateFunctionsFor: classType) select: [:each | each isClassMethod ].
!"end privateClassFunctionsFor: "


privateFunctionsFor: classType
	^(content select: [:each | 
		each type = #function  
		and: [(each name indexOf: classType) = 1]])
!"end privateFunctionsFor: "


privateInstanceFunctionsFor: classType
	^(self privateFunctionsFor: classType) reject: [:each | each isClassMethod ].
!"end privateInstanceFunctionsFor: "


privateModelClassForType: aSymbol
	| result |
	^(result := modelClasses detect: [:each | (each last + '_t') = aSymbol ]) ifNotNil: [result first].
!"end privateModelClassForType: "


privateSelectorFor: function prefix: prefixSymbol

		| name |
		
		name := (function name copyReplaceAll: prefixSymbol + '_' with: '').
		(name matchAllRegularExpression: '\_[a-z]' flags: {#regex}) do: [:each |
			name replaceFrom: each first first to: each first last with: (name copyFrom: each first first to: each first last) asUpperCase.
		].
		name := name copyReplaceAll: '_' with: ''.
		
		"Some classes have a #id and a #get_id method, so we always set #id as getID"
		name = #id ifTrue: [
			name := #privateGetID.
		].
		name = #get ifTrue: [
			name := #privateGet.
		].
		
		(name indexOf: #is) = 1 ifTrue: [
			name := ((name copyFrom: 3) setFirstChar: #asLowerCase).
		].
		
		(name indexOf: #get) = 1 ifTrue: [
			name := ((name copyFrom: 4) setFirstChar: #asLowerCase).
		].
		
		(name indexOf: #set) = 1 ifTrue: [
			name := ((name copyFrom: 4) setFirstChar: #asLowerCase).
			name isNilOrBlank ifTrue: [
				"Use first param name"
				name := function params first name.
			].
		].
		
		name = #privateGetID ifTrue: [
			name := #getID.
		].
		name = #privateGet ifTrue: [
			name := #get.
		].
		
		^name.
!"end privateSelectorFor:prefix: "


writeClassMethodName: nameString function: function to: out
	| selector selectorParams callParams source |
	
	selector := nameString.
	selectorParams := function selectorParams.
	callParams := function callParams.
			
	source := selector + selectorParams asString + CrLf 
			+ '"' + CrLf + (function comment) + '"' + CrLf
			+ Tab + '^self new: (QpidProtonLibrary ' 
				+ CrLf + Tab + Tab + function name + (callParams isEmpty ifTrue: [''] ifFalse: [': '])
				+ (callParams asArray asStringSeparator: CrLf + Tab + Tab + 'with: ') 
				+ ').'.
	
	out writeMethodName: selector source: source.
!"end writeClassMethodName:function:to: "


writeMethodName: nameString function: function to: out
	| selector selectorParams callParams source mType |
	
	selector := nameString.
	selectorParams := function selectorParams.
	callParams := function callParams.
	
	"If we have a wrapper model class, return an instance of this class"
	mType := self privateModelClassForType: (function subtype copyReplaceAll: '*' with: '').
	
	mType ifNotNil: [
		source := selector + selectorParams asString + CrLf 
			+ '"' + CrLf + (function comment) + '"' + CrLf
			+ Tab + '^' + mType ++ 'new: (self private_' + selector + selectorParams asString + ').'.
		out writeMethodName: selector source: source.	
		selector := #'private_' + selector.
	].
	
	source := selector + selectorParams asString + CrLf 
			+ '"' + CrLf + (function comment) + '"' + CrLf
			+ (function checkCall ifNotNil: [Tab + function checkCall + CrLf]) asString
			+ Tab + '^QpidProtonLibrary ' 
				+ CrLf + Tab + Tab + function name + (callParams isEmpty ifTrue: [''] ifFalse: [': '])
				+ (callParams asArray asStringSeparator: CrLf + Tab + Tab + 'with: ') 
				+ '.'.
	
	out writeMethodName: selector source: source.
!"end writeMethodName:function:to: "


writeOS7
	self writeOS7DLLClass.
	
	modelClasses do: [:each |
		self writeOS7Class: each first prefix: each last.
	].
	
!"end writeOS7 "


writeOS7Class: className prefix: prefixSymbol
	| f classBuilder newClass out method instanceType mType |
	
	(System at: className) ifNotNil: [(System at: className) destroy].
	
	instanceType := (prefixSymbol + '_t') asSymbol.
	
	classBuilder := ClassBuilder new.
	classBuilder 
		superclass: QpidProton;
		name: className;
		instanceVariableNames: ((Array with: instanceType) asStringSeparator: CrLf);
		classVariableNames: '';
		poolDictionaries: ''.

	out := classBuilder asClassSourceStreamHeader.
	
	out beginClassMethods.
	
	method := 'new: ' + prefixSymbol + '_t' + CrLf 
		+ Tab + '| obj |' + CrLf 
		+ Tab + 'obj := super new.' + CrLf
		+ Tab + 'obj varAt: #' + instanceType + ' put: ' + instanceType + '.' + CrLf
		+ Tab + '^obj.'.
	out writeMethodName: #new: source: method.
	
	(self privateClassFunctionsFor: prefixSymbol) do: [:function |
		self writeClassMethodName: #new function: function to: out.
	].	
	
	out endClassMethods.
	
	out beginInstanceMethods.
	
	method := instanceType + CrLf 
		+ Tab + '^' + instanceType + '.'.
	out writeMethodName: instanceType source: method.
	
	method := 'destroy' + CrLf 
		+ Tab + instanceType + ' ifNil: [^self].' + CrLf
		+ Tab + 'super destroy.' + CrLf 
		+ Tab + instanceType + ' := nil.' + CrLf.
	out writeMethodName: instanceType source: method.
	
	(self privateInstanceFunctionsFor: prefixSymbol) do: [:function |
		| name |
		
		name := self privateSelectorFor: function prefix: prefixSymbol.
		
		(function name indexOf: #is) = 1 ifTrue: [
			"Write isXxx Accessor method"
			method := name + CrLf 
				+ Tab + '^self ' + name + '.'.
			out writeMethodName: name source: method.
		].
		
		self writeMethodName: name function: function to: out.
	].	
	
	out endInstanceMethods.
	
	(out writeToFileName: (f := self destDir + className + '.cls') out) close.
	out close.

	self loadFilesAfterGen ifTrue: [	
		(f := f asFilename readStreamOnError: [ nil ]) notNil ifTrue: [
			f fileInInit: true.
		].
	].
!"end writeOS7Class:prefix: "


writeOS7DLLClass
	| f out classBuilder source |
	
	classBuilder := ClassBuilder new.
	classBuilder 
		superclass: ExternalLibrary;
		name: #QpidProtonDLL;
		instanceVariableNames: (((content select: [:each | each type = #typedef and: [each subtype = #struct and: [each elements isEmpty not]]]) collect: [:each | each var ]) asArray asStringSeparator: CrLf);
		classVariableNames: '';
		poolDictionaries: ''.

	out := classBuilder asClassSourceStreamHeader.
	
	out beginClassMethods.

	source := 'initialize' + CrLf + Tab + 'QpidProtonLibrary := self new.'.
	out writeMethodName: #initialize source: source.

	source := 'new
	| obj |
	obj := self newName: ''qpid-proton.dll''.
	(obj isKindOf: ExternalLibrary) ifFalse: [
		^ ''could not initialize qpid-proton.dll.'' asMessage.
	]."endif"
	obj initialize.
	^ obj.'.
	out writeMethodName: #new source: source.

	(content select: [:each | each type = #typedef and: [each subtype = #enum]]) do: [:each |
		source := StreamString new.
		source append: (each name).
		source append: CrLf.
		source append: '"' + (each comment) + '"'.
		source append: CrLf.
		source append: (Tab + '^(IdentityDictionary new)').
		source append: CrLf.
		source append: ((each enumeration collect: [:enum |
			Tab + Tab + 'at: ' + enum name store + ' put: ' + (enum value isNumeric ifTrue: [enum value] ifFalse: ['#''' + enum value + '''']) + ' "' + (enum comment) + '"'
		]) asArray asStringSeparator: ';' + CrLf).
		source append: ';' + CrLf + Tab + Tab + 'yourself.'.
		out writeMethodName: each name source: source asString.
	].
	
	out endClassMethods.
	out beginInstanceMethods.

	source := StreamString new.
	source append: #initialize.
	source append: CrLf.
	source append: Tab + 'self initializeStructs.' + CrLf.
	source append: ((includes keys sort collect: [:each | Tab + 'self initialize' + each capitalize + '.'])
		asArray asStringSeparator: CrLf).
	out writeMethodName: each name source: source asString.
	
	source := StreamString new.
	source append: #initializeStructs.
	source append: CrLf.
	source append: '| variables |'.
	source append: CrLf.
	(content select: [:each | each type = #typedef and: [each subtype = #struct and: [each elements isEmpty not]]]) do: [:each |
		self writeOS7Struct: (each) to: source.
	].
	out writeMethodName: #initializeStructs source: source asString.
	
	includes keys do: [:each |
		source := StreamString new.
		source append: #initialize + each capitalize.
		source append: CrLf.
		self writeOS7Initialize: (includes at: each) to: source.
		out writeMethodName: #initialize + each capitalize source: source asString.
	].
	
	"Struct Accesser Methoden"
	(content select: [:each | each type = #typedef and: [each subtype = #struct and: [each elements isEmpty not]]]) do: [:each | 
		source := StreamString new.
		source append: each var.
		source append: CrLf.
		source append: Tab + '^' + each var + '.'.
		out writeMethodName: each var source: source asString.
	].

	"Methodenaufrufe"
	(content select: [:each | each type = #function]) do: [:each |
		| selector |
		
		selector := each name.
		selector isNilOrEmpty ifTrue: [each inspect. self halt: 'Selector isNilOrEmpty'].
		each params isEmpty not ifTrue: [
			selector := selector + ':'.
		].
		selector := selector + ((each params collect: [:each | ' ' + each name + ' ']) asArray asStringSeparator: 'with:').
		
		source := StreamString new.
		source append: selector.
		source append: CrLf.
		source append: '"' + (each comment) + ''.
		source append: CrLf.
		source append: (each function).
		source append: CrLf.
		source append: '"'.
		source append: CrLf.
		source append: Tab + '^self call: #' + each name + (each params isEmpty ifTrue: [' with: Array new.'] ifFalse: [
			 ' with: (Array with: ' + ((each params collect: [:each | each name]) asArray asStringSeparator: ' with: ') + ').']).
		out writeMethodName: selector source: source asString.
	].

	out endInstanceMethods.
	(out writeToFileName: (f := self destDir + 'QpidProtonDLL.cls') out) close.
	out close.
	
	self loadFilesAfterGen ifTrue: [
		(f := f asFilename readStreamOnError: [ nil ]) notNil ifTrue: [
			f fileInInit: true.
		].
	].
!"end writeOS7DLLClass "


writeOS7GetParamType: typeString

	| type |

	(typeString indexOf: 'const char*') > 0 ifTrue: [
		^'(VString "concreteClass" passedBy: #reference)'.
	].

	(typeString indexOf: 'char*') > 0 ifTrue: [
		^'VDWord new "String by reference"'.
	].
	({'int' 'size_t'} includes: typeString trimBlanks) ifTrue: [
		^'VDWord new'.
	].
	(typeString trimBlanks = 'bool') ifTrue: [
		^'VBoolean new'.
	].
	
	type := (content detect: [:each | each type = #typedef and: [ each name = typeString ]]).
	type ifNotNil: [
		type subtype = #struct ifTrue: [
			^'((VStructure structObj: ' + type var + ') passedBy: #value)'.
		].
	].
	
	(typeString indexOf: '*') > 0 ifTrue: [
		^'VDWord new "Pointer"'.
	].
	
	^'VDWord new "Uknown"'.
!"end writeOS7GetParamType: "


writeOS7Initialize: elements to: out7

	out7 append: Tab + '| variables params |' + CrLf + CrLf.
	elements do: [:each |
		out7 append: Tab + '"' + each function + '"' + CrLf.
		
		out7 append: Tab + 'params := Array new: ' + (each params size) + '.' + CrLf.
		
		1 to: each params size do: [:i |
			| param |
			param := (each params at: i).
			out7 append: Tab + 'params at: ' + i + ' put: ' + (self writeOS7GetParamType: param type) + '. "' + param type +'"'.
			out7 append: CrLf.
		].
		
		out7 append: '
	self
		newProcedureNamed: #''' + each name + '''
		paramVars: params	
		callingConvention: #C 
		returns: (' + (self writeOS7GetParamType: each subtype) + ').

'.
	].
!"end writeOS7Initialize:to: "


writeOS7Struct: el to: out7

	el var ifNil: [^self].
	(el elements isEmpty or: [el elements first = #'']) ifTrue: [^self].

	out7 append: Tab + el var + ' := Structure new.'.
	out7 append: CrLf.
	
	out7 append: Tab + 'variables := Array new: ' + (el elements size) + '.'.
	out7 append: CrLf.
	
	1 to: el elements size do: [:idx |
		out7 append: Tab + 'variables at: ' + idx + ' put: ' + (self writeOS7GetParamType: (el elements at: idx) type) + '. "' + (el elements at: idx) type + '"'.
		out7 append: CrLf.
	].
	
	out7 append: Tab + el var + ' addElements:'.
	out7 append: CrLf.
	out7 append: Tab + Tab + (el elements collect: [:each | each name asSymbol]) asArray store.
	out7 append: CrLf.
	out7 append: Tab + Tab + 'variables: variables startingAt: 0.'.
	out7 append: CrLf.
	out7 append: CrLf.
!"end writeOS7Struct:to: "


writeOS8
	
	| out |
	
	out := VWXMLSAXCrLfWriter new.
	out output: (NewFileStream createFile: self destDir + 'qpid-proton.st').
	out startDocument.
	out processingInstruction: #xml data: 'version="1.0"'.
	out output nextPutString: ''.
	
	out 
		startElement: 'st-source';
		startElement: 'time-stamp';
		characters: 'From LESS';
		endElement: 'time-stamp';
		startElement: 'component-created';
		startElement: 'name';
		characters: 'Qpid-Proton';
		endElement: 'name';
		startElement: 'type';
		characters: 'package';
		endElement: 'type';
		endElement: 'component-created';
		yourself.
		
	out output nextPutString: CrLf.
		
	(IdentityDictionary new)
		at: #'@XML_TAG_ORDER' put: {#name #environment #private #imports #category #attributes};
		at: #name put: #Qpid;
		at: #environment put: #OS;
		at: #private put: false;
		at: #imports put: CrLf + Tab + ({'Core.*' 'External.*' 'OS.*'} asStringSeparator: CrLf + Tab) + CrLf;
		at: #category put: '';
		at: #attributes put: ((IdentityDictionary new)
			at: #package put: 'Qpid-Proton';
			yourself);
		xmlPrintOn: out output as: #'name-space'.
		
	out output nextPutString: CrLf.
	
	self writeOS8DLLClass: out.
	
	modelClasses do: [:each |
"		self writeOS8Class: each first prefix: each last."
	].
	
	
	out endElement: 'st-source'.
	
	out output close.
!"end writeOS8 "


writeOS8DLLClass: out
	| source |
	
	(Dictionary new)
		at: #'@XML_TAG_ORDER' put: {#name #environment #super #private #'indexed-type' #'inst-vars' #'class-inst-vars' #imports #category #attributes};
		at: #name put: #QpidProtonDLL;
		at: #environment put: #'OS.Qpid';
		at: #private put: false;
		at: #'indexed-type' put: #none;
		at: 'super' put: 'External.ExternalInterface';
		at: #imports put: '';
		at: #category put: '';
		at: #attributes put: ((IdentityDictionary new)
			at: #'@XML_TAG_ORDER' put: {#includeFiles #includeDirectories #libraryFiles #libraryDirectories #beVirtual #optimizationLevel #package};
			at: #libraryFiles put: ((IdentityDictionary new)
				at: #item put: 'qpid-proton.dll';
				yourself);
			at: #beVirtual put: false;
			at: #optimizationLevel put: #debug;
			at: #package put: 'Qpid-Proton';
			yourself);
		xmlPrintOn: out output as: #'class'.
	
	out output nextPutString: CrLf.
	
	out startElement: #methods.
	out startElement: 'class-id'.
	out characters: 'OS.Qpid.QpidProtonDLL'.
	out endElement: 'class-id'.
	out startElement: 'category'.
	out characters: 'structs'.
	out endElement: 'category'.
	
	(content select: [:each | each type = #typedef and: [each subtype = #struct]]) do: [:each | 

		out startElement: 'body' attributes: ((IdentityDictionary new)
			at: #package put: 'Qpid-Proton';
			at: #selector put: '__' + each name;
			yourself).
		
		source := StreamString new.
		
		out characters: '__' + each name.
		out output nextPutAll: CrLf + Tab.
		out characters: ('<C: struct __' + each name + '>').
		
		out endElement: 'body'.
	].
	
	out endElement: #methods.
!"end writeOS8DLLClass: "


!"End of methods block"

