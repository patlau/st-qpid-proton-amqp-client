Object subclass: #MQWorker
instanceVariableNames: '
	connection
	queue
	thread
'
classVariableNames: '
'
poolDictionaries: '
' !


! MQWorker class methods!


logException: ex
	^MQEventBus logException: ex.
!"end logException: "


new
	^super new initialize.
!"end new "


newAddress: addressString timeout: timeoutInteger
	| obj |
	
	obj := self new.
	obj varAt: #connection put: (AMQPConnection connectAddress: addressString timeout: timeoutInteger).
	^obj.
!"end newAddress:timeout: "


!"End of class methods block"


! MQWorker methods!


initialize
	queue := SafeSharedQueue new.
!"end initialize "


privateReceive
	| result time |
	
	(self class name asString ++ 'Start Listening') out.
	
	connection subscribe.
	time := Timestamp now.
	
	[
		Thread currentThread description: #Waiting.
		[
			connection receiveLoopDo: [:message |
				self processMessage: message.
			].	
			('Loop Time:' ++ ((Timestamp now)-time) asDiffTime asEuroString) out.
			time := Timestamp now.
		] on: Error do: [:ex |
			"Do Qpid Error Handling"
			self class logException: ex out.
			Thread currentThread attributeAt: #requestTerminate put: true.
		].
	] doWhile: [ connection notNil and: [(Thread currentThread attributeAt: #requestTerminate) ~= true] ].
	
	(self class name asString ++ 'Stop Listening') out.
	connection disconnect.
!"end privateReceive "


privateSend
	| result |
	
	(self class name asString ++ 'Start Sending') out.
	
	[
		| next |
		
		Thread currentThread description: #Waiting.
		next := queue next.
		
		next = #terminate ifFalse: [
			Thread currentThread description: #Send.
			[
				connection send: next.
			] on: Error do: [:ex | self class logException: ex out ].
		].
		
	] doWhile: [ connection notNil and: [(Thread currentThread attributeAt: #requestTerminate) ~= true] ].
	
	(self class name asString ++ 'Stop Sending') out.
	connection disconnect.
!"end privateSend "


processMessage: message
"
	Check Message type and send to receiving thread. This thread should not process the message contents itself.
	It should get all needed data from message and pass this data to another working thread.
"
	message subject = #TRANSCRIPT ifTrue: [
		^MainAppThread send: #out to: message bodyGet args: nil.
	].
	
	message out.
!"end processMessage: "


queue
	^queue.
!"end queue "


start: aSymbol
	
	| block |
	
	thread ifNotNil: [^self].
	
	aSymbol = #Send ifTrue: [ block := [self privateSend] ].
	aSymbol = #Receive ifTrue: [ block := [self privateReceive] ].
	
	block ifNil: [^self].

	thread := Thread new: block copyForReentry
		autoTerminate: true 
		priority: Thread ThreadPriorityNormal 
		named: #MQWorker + aSymbol.
	
	thread waitUntilReady.
!"end start: "


stop
	thread ifNotNil: [thread attributeAt: #requestTerminate put: true.].
	queue ifNotNil: [queue nextPut: #terminate. "Should be some kind of interrupt"].
	connection ifNotNil: [connection interrupt].
	
!"end stop "


terminateWaitForMilliseconds: ms
	thread ifNotNil: [
		(thread waitForThreadExitMilliseconds: ms) ~= #Exit ifTrue: [
			('Terminate thread...') out.
			thread terminate.
		].
	].
!"end terminateWaitForMilliseconds: "


!"End of methods block"

