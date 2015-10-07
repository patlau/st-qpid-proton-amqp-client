QpidProton subclass: #QpidProtonData
instanceVariableNames: '
	pn_data_t
'
classVariableNames: '
'
poolDictionaries: '
' !


! QpidProtonData class methods!


new: pn_data_t
	| obj |
	obj := super new.
	obj varAt: #pn_data_t put: pn_data_t.
	^obj.
!"end new: "


newCapacity: capacity
"
"
	^self new: (QpidProtonLibrary 
		pn_data: capacity "size_t").
!"end new "


!"End of class methods block"


! QpidProtonData methods!


pn_data_t
	^pn_data_t.
!"end pn_data_t "


destroy
	pn_data_t ifNil: [^self].
	super destroy.
	pn_data_t := nil.

!"end pn_data_t "


free
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_free: pn_data_t "pn_data_t*".
!"end free "


errno
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_errno: pn_data_t "pn_data_t*".
!"end errno "


error
"
"
	^QpidProtonError new: (self private_error).
!"end error "


private_error
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_error: pn_data_t "pn_data_t*".
!"end private_error "


vfill: fmt ap: ap
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_vfill: pn_data_t "pn_data_t*"
		with: fmt "const char*"
		with: ap "va_list".
!"end vfill "


fill: fmt list: list
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_fill: pn_data_t "pn_data_t*"
		with: fmt "const char*"
		with: list "array".
!"end fill "


vscan: fmt ap: ap
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_vscan: pn_data_t "pn_data_t*"
		with: fmt "const char*"
		with: ap "va_list".
!"end vscan "


scan: fmt list: list
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_scan: pn_data_t "pn_data_t*"
		with: fmt "const char*"
		with: list "array".
!"end scan "


clear
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_clear: pn_data_t "pn_data_t*".
!"end clear "


size
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_size: pn_data_t "pn_data_t*".
!"end size "


rewind
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_rewind: pn_data_t "pn_data_t*".
!"end rewind "


next
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_next: pn_data_t "pn_data_t*".
!"end next "


prev
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_prev: pn_data_t "pn_data_t*".
!"end prev "


enter
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_enter: pn_data_t "pn_data_t*".
!"end enter "


exit
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_exit: pn_data_t "pn_data_t*".
!"end exit "


lookup: name
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_lookup: pn_data_t "pn_data_t*"
		with: name "const char*".
!"end lookup "


type
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_type: pn_data_t "pn_data_t*".
!"end type "


print
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_print: pn_data_t "pn_data_t*".
!"end print "


format: bytes size: size
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_format: pn_data_t "pn_data_t*"
		with: bytes "char*"
		with: size "size_t*".
!"end format "


encode: bytes size: size
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_encode: pn_data_t "pn_data_t*"
		with: bytes "char*"
		with: size "size_t".
!"end encode "


decode: bytes size: size
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_decode: pn_data_t "pn_data_t*"
		with: bytes "const char*"
		with: size "size_t".
!"end decode "


putList
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_put_list: pn_data_t "pn_data_t*".
!"end putList "


putMap
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_put_map: pn_data_t "pn_data_t*".
!"end putMap "


putArray: described type: type
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_put_array: pn_data_t "pn_data_t*"
		with: described "bool"
		with: type "pn_type_t".
!"end putArray "


putDescribed
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_put_described: pn_data_t "pn_data_t*".
!"end putDescribed "


putNull
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_put_null: pn_data_t "pn_data_t*".
!"end putNull "


putBool: b
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_put_bool: pn_data_t "pn_data_t*"
		with: b "bool".
!"end putBool "


putUbyte: ub
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_put_ubyte: pn_data_t "pn_data_t*"
		with: ub "uint8_t".
!"end putUbyte "


putByte: b
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_put_byte: pn_data_t "pn_data_t*"
		with: b "int8_t".
!"end putByte "


putUshort: us
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_put_ushort: pn_data_t "pn_data_t*"
		with: us "uint16_t".
!"end putUshort "


putShort: s
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_put_short: pn_data_t "pn_data_t*"
		with: s "int16_t".
!"end putShort "


putUint: ui
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_put_uint: pn_data_t "pn_data_t*"
		with: ui "uint32_t".
!"end putUint "


putInt: i
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_put_int: pn_data_t "pn_data_t*"
		with: i "int32_t".
!"end putInt "


putChar: c
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_put_char: pn_data_t "pn_data_t*"
		with: c "pn_char_t".
!"end putChar "


putUlong: ul
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_put_ulong: pn_data_t "pn_data_t*"
		with: ul "uint64_t".
!"end putUlong "


putLong: l
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_put_long: pn_data_t "pn_data_t*"
		with: l "int64_t".
!"end putLong "


putTimestamp: t
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_put_timestamp: pn_data_t "pn_data_t*"
		with: t "pn_timestamp_t".
!"end putTimestamp "


putFloat: f
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_put_float: pn_data_t "pn_data_t*"
		with: f "float".
!"end putFloat "


putDouble: d
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_put_double: pn_data_t "pn_data_t*"
		with: d "double".
!"end putDouble "


putDecimal32: d
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_put_decimal32: pn_data_t "pn_data_t*"
		with: d "pn_decimal32_t".
!"end putDecimal32 "


putDecimal64: d
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_put_decimal64: pn_data_t "pn_data_t*"
		with: d "pn_decimal64_t".
!"end putDecimal64 "


putDecimal128: d
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_put_decimal128: pn_data_t "pn_data_t*"
		with: d "pn_decimal128_t".
!"end putDecimal128 "


putUuid: u
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_put_uuid: pn_data_t "pn_data_t*"
		with: u "pn_uuid_t".
!"end putUuid "


putBinary: bytes
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_put_binary: pn_data_t "pn_data_t*"
		with: bytes "pn_bytes_t".
!"end putBinary "


putString: string
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_put_string: pn_data_t "pn_data_t*"
		with: string "pn_bytes_t".
!"end putString "


putSymbol: symbol
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_put_symbol: pn_data_t "pn_data_t*"
		with: symbol "pn_bytes_t".
!"end putSymbol "


putAtom: atom
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_put_atom: pn_data_t "pn_data_t*"
		with: atom "pn_atom_t".
!"end putAtom "


list
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_get_list: pn_data_t "pn_data_t*".
!"end list "


map
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_get_map: pn_data_t "pn_data_t*".
!"end map "


array
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_get_array: pn_data_t "pn_data_t*".
!"end array "


arrayDescribed
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_is_array_described: pn_data_t "pn_data_t*".
!"end arrayDescribed "


arrayType
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_get_array_type: pn_data_t "pn_data_t*".
!"end arrayType "


described
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_is_described: pn_data_t "pn_data_t*".
!"end described "


null
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_is_null: pn_data_t "pn_data_t*".
!"end null "


bool
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_get_bool: pn_data_t "pn_data_t*".
!"end bool "


ubyte
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_get_ubyte: pn_data_t "pn_data_t*".
!"end ubyte "


byte
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_get_byte: pn_data_t "pn_data_t*".
!"end byte "


ushort
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_get_ushort: pn_data_t "pn_data_t*".
!"end ushort "


short
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_get_short: pn_data_t "pn_data_t*".
!"end short "


uint
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_get_uint: pn_data_t "pn_data_t*".
!"end uint "


int
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_get_int: pn_data_t "pn_data_t*".
!"end int "


char
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_get_char: pn_data_t "pn_data_t*".
!"end char "


ulong
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_get_ulong: pn_data_t "pn_data_t*".
!"end ulong "


long
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_get_long: pn_data_t "pn_data_t*".
!"end long "


timestamp
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_get_timestamp: pn_data_t "pn_data_t*".
!"end timestamp "


float
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_get_float: pn_data_t "pn_data_t*".
!"end float "


double
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_get_double: pn_data_t "pn_data_t*".
!"end double "


decimal32
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_get_decimal32: pn_data_t "pn_data_t*".
!"end decimal32 "


decimal64
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_get_decimal64: pn_data_t "pn_data_t*".
!"end decimal64 "


decimal128
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_get_decimal128: pn_data_t "pn_data_t*".
!"end decimal128 "


uuid
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_get_uuid: pn_data_t "pn_data_t*".
!"end uuid "


binary
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_get_binary: pn_data_t "pn_data_t*".
!"end binary "


string
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_get_string: pn_data_t "pn_data_t*".
!"end string "


symbol
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_get_symbol: pn_data_t "pn_data_t*".
!"end symbol "


bytes
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_get_bytes: pn_data_t "pn_data_t*".
!"end bytes "


atom
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_get_atom: pn_data_t "pn_data_t*".
!"end atom "


copy
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_copy: pn_data_t "pn_data_t*"
		with: pn_data_t "pn_data_t*".
!"end copy "


append
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_append: pn_data_t "pn_data_t*"
		with: pn_data_t "pn_data_t*".
!"end append "


appendn: limit
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_appendn: pn_data_t "pn_data_t*"
		with: pn_data_t "pn_data_t*"
		with: limit "int".
!"end appendn "


narrow
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_narrow: pn_data_t "pn_data_t*".
!"end narrow "


widen
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_widen: pn_data_t "pn_data_t*".
!"end widen "


point
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_point: pn_data_t "pn_data_t*".
!"end point "


restore: point
"
"
	pn_data_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_data_restore: pn_data_t "pn_data_t*"
		with: point "pn_handle_t".
!"end restore "


!"End of methods block"

