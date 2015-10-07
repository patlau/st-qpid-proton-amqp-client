Object subclass: #QpidBroker
instanceVariableNames: '
	restClient
	virtualHost
	node
'
classVariableNames: '
'
poolDictionaries: '
' !


! QpidBroker class methods!


new
	^super new initialize.
!"end new "


newDefault
	| obj |
	obj := self new.
	obj varAt: #restClient put: (RESTClient new: 'http://192.168.88.33:8080' user: 'webadmin' password: 'webadmin').
	^obj.
!"end newDefault "


restApi
"
http://qpid.apache.org/releases/qpid-0.32/java-broker/book/Java-Broker-Management-Channel-REST-API.html
"
!"end restApi "


test
XX := QpidBroker newDefault.
XX isRunning out.
XX getQueue: #test.
XX clearQueue: #test.
XX close.
!"end test "


!"End of class methods block"


! QpidBroker methods!


broker
	^restClient send: #GET to: '/broker' args: nil.
!"end broker "


clearQueue: queuenameString
	^restClient send: #DELETE request: nil path: '/service/message/' + virtualHost + '/test?clear=true'.
!"end clearQueue: "


close
	restClient ifNotNil: [
		self logout.
		restClient close.
	].
!"end close "


getQueue: queueNameString
	^restClient send: #GET to: '/queue/' + virtualHost + '/' + node + '/' + queueNameString args: nil.
!"end getQueue: "


initialize
	virtualHost := #default.
	node := #default.
!"end initialize "


isRunning
	^[
		self broker isNilOrBlank not.
	] on: Error do: [:ex | ex out. false ].
!"end isRunning "


logout
	^restClient send: #GET request: nil path: '/service/logout'.
!"end logout "


!"End of methods block"

