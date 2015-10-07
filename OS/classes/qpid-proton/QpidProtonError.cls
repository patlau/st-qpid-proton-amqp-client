QpidProton subclass: #QpidProtonError
instanceVariableNames: '
	pn_error_t
'
classVariableNames: '
'
poolDictionaries: '
' !


! QpidProtonError class methods!


new: pn_error_t
	| obj |
	obj := super new.
	obj varAt: #pn_error_t put: pn_error_t.
	^obj.
!"end new: "


new
"
"
	^self new: (QpidProtonLibrary 
		pn_error).
!"end new "


!"End of class methods block"


! QpidProtonError methods!


pn_error_t
	^pn_error_t.
!"end pn_error_t "


destroy
	pn_error_t ifNil: [^self].
	super destroy.
	pn_error_t := nil.

!"end pn_error_t "


free
"
"
	pn_error_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_error_free: pn_error_t "pn_error_t*".
!"end free "


clear
"
"
	pn_error_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_error_clear: pn_error_t "pn_error_t*".
!"end clear "


error: code text: text
"
"
	pn_error_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_error_set: pn_error_t "pn_error_t*"
		with: code "int"
		with: text "const char*".
!"end error "


vformat: code fmt: fmt ap: ap
"
"
	pn_error_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_error_vformat: pn_error_t "pn_error_t*"
		with: code "int"
		with: fmt "const char*"
		with: ap "va_list".
!"end vformat "


format: code fmt: fmt list: list
"
"
	pn_error_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_error_format: pn_error_t "pn_error_t*"
		with: code "int"
		with: fmt "const char*"
		with: list "array".
!"end format "


code
"
"
	pn_error_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_error_code: pn_error_t "pn_error_t*".
!"end code "


text
"
"
	pn_error_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_error_text: pn_error_t "pn_error_t*".
!"end text "


copy
"
"
	pn_error_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_error_copy: pn_error_t "pn_error_t*"
		with: pn_error_t "pn_error_t*".
!"end copy "


!"End of methods block"

