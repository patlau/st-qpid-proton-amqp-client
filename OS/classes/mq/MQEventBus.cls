Object subclass: #MQEventBus
instanceVariableNames: '
	sender
	receiver
'
classVariableNames: '
	global
'
poolDictionaries: '
' !


! MQEventBus class methods!


current
	^global.
!"end current "


initialize
	VE2000Auto when: #afterLogon send: #start to: self.
	VE2000Auto when: #logoff send: #stop to: self.
!"end initialize "


start
	System isInVW ifTrue: [^self].
	
	"LPC zum Testen"
	BatchJobSchedulerConfig current enableEB ifFalse: [^self].
	
	('MQEventBus>>start') out.
	global ifNotNil: [^self].
	global := self new.
	global start.
	
!"end start "


stop
	('MQEventBus>>stop') out.
	System isInVW ifTrue: [^self].
	global ifNil: [^self].
	global stop.
	global := nil.
	
!"end stop "


test
MQEventBus start.

MQEventBus current sendNotification: #TRANSCRIPT with: ((SimpleObject new) message: 'Test').

MQEventBus stop.

!"end test "


!"End of class methods block"


! MQEventBus methods!


sendNotification: aSymbol with: anObject
	sender queue nextPut: 
		((AMQPMessage new)
			subject: aSymbol;
			id: VE2000 nextFreeKey asString;
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

