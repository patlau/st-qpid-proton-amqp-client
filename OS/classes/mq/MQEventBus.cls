Object subclass: #MQEventBus
instanceVariableNames: '
	sender
	receiver
'
classVariableNames: '
	global
	logger
'
poolDictionaries: '
' !


! MQEventBus class methods!


current
	^global.
!"end current "


initialize
!"end initialize "


logException: ex
	(logger respondsTo: #logException:) ifTrue: [
		^logger logException: ex.
	].
	ex out.

!"end logException: "


logger
	^logger.
!"end logger "


logger: anObject
	logger := anObject.
!"end logger: "


start
	('MQEventBus>>start') out.
	global ifNotNil: [^self].
	global := self new.
	global start.
	
!"end start "


stop
	('MQEventBus>>stop') out.
	global ifNil: [^self].
	global stop.
	global := nil.
	
!"end stop "


test
	MQEventBus start.
	MQEventBus current sendNotification: #TRANSCRIPT with: ((Dictionary new) at: #message put: 'Test'; yourself).
	MQEventBus stop.
!"end test "


!"End of class methods block"


! MQEventBus methods!


sendNotification: aSymbol with: anObject
	sender queue nextPut: 
		((AMQPMessage new)
			subject: aSymbol;
			id: AMQPConnection newGUID asString;
			durable: false;
			bodySet: anObject;
			yourself).
!"end sendNotification:with: "


start
	
	| address timeout |
	
	address := 'amqp://192.168.88.33:5672/amq.fanout'.
	timeout := 20000.

	sender := MQWorker newAddress: address timeout: timeout.
	sender start: #Send.
	
	receiver := MQWorker newAddress: address timeout: timeout.
	receiver start: #Receive.
!"end start "


stop
	sender ifNotNil: [sender stop].
	receiver ifNotNil: [receiver stop].
	
	sender ifNotNil: [sender terminateWaitForMilliseconds: 5000].
	receiver ifNotNil: [receiver terminateWaitForMilliseconds: 5000].
	
	
!"end stop "


!"End of methods block"

