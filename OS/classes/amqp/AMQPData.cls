AMQPWrapper subclass: #AMQPData
instanceVariableNames: '
	data
'
classVariableNames: '
'
poolDictionaries: '
' !


! AMQPData class methods!


new: aQpidProtonData
	| obj |
	obj := super new.
	obj varAt: #data put: aQpidProtonData.
	^obj.
!"end new: "


!"End of class methods block"


! AMQPData methods!


destroy
	super destroy.
	data := nil.
!"end destroy "


format
	| buffer length str |
	
	self log: #trace key: #amqpdata msg: 'Format'.
	
	buffer := (VString passedBy: #reference)
		initializeFrom: (String new: 2048);
		yourself.
	
	length := (VPointer pointsTo: (VDWord new))
		initializeFrom: 2048;
		yourself.
	
	self log: #trace key: #amqpdata msg: 'Format>>call:' ++ buffer address ++ length address.
	data format: buffer address size: length address.
	
	self log: #trace key: #amqpdata msg: 'Format>>marshal'.
	str := buffer marshal.
	
	"Not shure how to marshal length"
	
	self log: #trace key: #amqpdata msg: 'Format>>unInitialize'.
	buffer unInitialize.
	length unInitialize.
	
	
	self log: #trace key: #amqpdata msg: 'Format>>result:' ++ str.
	^str.

!"end format "


getString
	| formatted |
	self log: #trace key: #amqpdata msg: 'GetString'.
	formatted := self format.
	formatted := formatted copyFrom: (formatted indexOf: '"')+1.
	formatted := formatted copyTo: (formatted size - (formatted reversed indexOf: '"')).
	self log: #trace key: #amqpdata msg: 'GetString:' ++ formatted.
	^formatted.
"
	| byteStruct |
	byteStruct := QpidProtonLibrary call: #pn_data_get_string with: (Array with: pn_data_t).
	self halt.
	(byteStruct at: #size) <= 0 ifTrue: [^''].
	^(byteStruct at: #start).
"	
!"end getString "


privateWrappedObject
	^data.
!"end privateWrappedObject "


putString: aString
	| bytes |
	
	self log: #trace key: #amqpdata msg: 'PutString:' ++ aString.
	
	bytes := QpidProtonLibrary struct_pn_bytes_t new.
	bytes
		memberAt: #size put: aString size;
		memberAt: #start put: aString "asByteArray";
		yourself.

	^data putString: bytes.
!"end putString: "


!"End of methods block"

