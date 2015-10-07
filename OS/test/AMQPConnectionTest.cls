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


testSendReceive
	
	| address msgReceive msgSend thread threadResult |
	
	address := self class serverAddress + '/test'.
	
	thread := 
		[	| conn msg |
			conn := AMQPConnection new.
			[
				conn connect: address.
				msg := conn sendString: 'AAA'.
				msgSend := (SimpleObject new)
					id: msg id;
					message: msg body getString;
					yourself.
			] ensure: [
				msg destroy.
				conn disconnect.
			].
		] fork.
	
	thread := 
		[	| conn msg |
			conn := AMQPConnection new.
			[
				conn connect: address.
				msg := conn receive.
				msgReceive := (SimpleObject new)
					id: msg id;
					message: msg body getString;
					yourself.
			] ensure: [
				msg destroy.
				conn disconnect.
			].
		] fork.
	
	threadResult := thread waitForThreadExitMilliseconds: 5000.
	
	threadResult ~= #Exit ifTrue: [
		thread terminate.
		self assert: false description: threadResult.
	].
	
	[
		self assert: msgSend id equals: msgReceive id.
		self assert: msgReceive message equals: 'AAA'.
	] ensure: [
		msgSend destroy.
		msgReceive destroy.
	].
	
	
!"end testSendReceive "


!"End of methods block"

