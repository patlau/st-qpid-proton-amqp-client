TestCase subclass: #AMQPConnectionTest
instanceVariableNames: '
'
classVariableNames: '
'
poolDictionaries: '
' !


! AMQPConnectionTest class methods!


serverAddress
	^'amqp://192.168.88.33:5672'
!"end serverAddress "


!"End of class methods block"


! AMQPConnectionTest methods!


testDirect
"
	Qpid Broker Setup:
	- Queue 'test' with no exchange binding 
		(will be forwarded to default binding which is a direct binding with queue names as binding key)
	
	This test will only run successfull if the Queue is empty!
"	
	| address msgReceive msgSend exReceive exSend thread threadResult |
	
	address := self class serverAddress + '/test'.
	
	thread := 
		[	| conn msg |
			[
				conn := AMQPConnection new.
				[
					conn timeout: 5000.
					conn connect: address.
					msg := conn receive first.
					msgReceive := (Dictionary new)
						at: #id put: msg id;
						at: #message put: msg body getString;
						yourself.
				] ensure: [
					conn disconnect.
				].
			] on: Error do: [:ex | 
				exReceive := ex out.
			].
		] fork.
	
	thread waitUntilReady.
	
	[	| conn msg |
			[
				conn := AMQPConnection new.
				[
					conn connect: address.
					msg := conn sendString: 'AAA'.
					msgSend := (Dictionary new)
						at: #id put: msg id;
						at: #message put: msg body getString;
						yourself.
				] ensure: [
					conn disconnect.
				].
			] on: Error do: [:ex | 
				exSend := ex out.
			].
		] fork.
	
	threadResult := thread waitForThreadExitMilliseconds: 5000.
	
	threadResult ~= #Exit ifTrue: [
		thread terminate.
		self assert: false description: threadResult.
	].
	
	self assert: exReceive isNil description: exReceive print.
	
	self assert: (msgSend at: #id) = (msgReceive at: #id)
		description: 'ID does not match: ' + (msgSend at: #id) + '<>' + (msgReceive at: #id).
	self assert: (msgSend at: #message) = (msgReceive at: #message)
		description: 'Message does not match: ' + (msgSend at: #message) + '<>' + (msgReceive at: #message).
	
	
!"end testDirect "


!"End of methods block"

