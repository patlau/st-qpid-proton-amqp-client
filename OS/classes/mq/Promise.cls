Object subclass: #Promise
instanceVariableNames: '
	exception
	hasValue
	sync
	value
'
classVariableNames: '
'
poolDictionaries: '
' !


! Promise class methods!


new
	^super new initialize
!"end new "


terminateSignal
	" Answer the Signal that indicates that a Promise computation terminated prematurely. "

	^PromiseTerminateException
!"end terminateSignal "


test1
	"Promise example1"
	" This is an example of a successful
	Promise evaluation. "
	
	| prom |
	prom := [3 + 4] promise.
	^prom value
!"end test1 "


test2
	"Promise example2"
	" This is an example of an unsuccessful
	Promise evaluation. "
	| prom |
	prom := [(Error new) raise] promise.
	^prom value
!"end test2 "


test3
	"Promise example3"
	" This is an example of an unsuccessful
	Promise evaluation, where the child process
	terminates prematurely. "
	| prom |
	prom := [Thread currentThread terminate] promise.
	^prom value
!"end test3 "


!"End of class methods block"


! Promise methods!


exception: anException
	" Record that the child
	terminated with an exception,
	and answer true.  If the exception
	has already been recorded,
	do nothing and answer false.
	Only BlockClosure>>promise
	should send this message. "
	^exception isNil
		ifTrue:
			[exception := anException.
			hasValue := true.
			sync signal.
			true]
		ifFalse:
			[false]
!"end exception: "


hasValue

	^hasValue
!"end hasValue "


initialize
	" Initialize the instance. "

	sync := Mutex new.
	hasValue := false
!"end initialize "


value
	" Answer the value computed by the child process.  If the child terminated 	with an exception,	
	raise that exception in the parent instead of answering a value. " 

	sync wait.
	sync signal.  " Permit multiple requests for the value. "
	exception == nil
		ifTrue: [ ^value ]
		ifFalse: [ exception copyForReraise
					raise
				]
!"end value "


value: resultValue
	" Set the resulting value.
	Only BlockClosure>>promise
	should send this message. "

	value := resultValue.
	hasValue := true.
	sync signal
!"end value: "


!"End of methods block"

