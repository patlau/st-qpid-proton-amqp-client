TestResource subclass: #QpidBrokerTestResource
instanceVariableNames: '
	broker
'
classVariableNames: '
'
poolDictionaries: '
' !


! QpidBrokerTestResource class methods!


!"End of class methods block"


! QpidBrokerTestResource methods!


name
	^#QpidBrokerTestResource.
!"end name "


setUp
"
	Unpack and start Qpid Java Broker.
	You can find binaries here: http://www.apache.org/dyn/closer.lua/qpid/0.32/binaries/qpid-broker-0.32-bin.tar.gz 
"
	| qpidBrokerDir workDir |
	
	qpidBrokerDir := (System environmentAt: #'QPID_HOME') ifNil: [
		System tempFilePath + '\QpidBroker'.
	].
	
	workDir := (System environmentAt: #'QPID_WORK') ifNil: [
		System tempFilePath + '\QpidBrokerWork'.
	].
	
	
!"end setUp "


!"End of methods block"

