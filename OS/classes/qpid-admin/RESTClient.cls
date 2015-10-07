Object subclass: #RESTClient
instanceVariableNames: '
	httpClient
	config
	session
'
classVariableNames: '
'
poolDictionaries: '
' !


! RESTClient class methods!


new
	^super new initialize.
!"end new "


new: urlString user: userString password: passwordString
	| obj |
	obj := self new.
	
	obj config url: urlString.
	obj config credentials: (Association key: userString value: passwordString).
	obj config api: '/api/'.
	obj config version: 'latest'.
		
	^obj.
!"end new:user:password: "


newHttpClient
	^(WinHttpRequest new)
		autoLogon: true;
		yourself.
!"end newHttpClient "


!"End of class methods block"


! RESTClient methods!


close
"
	Sicherstellen, dass alle Verbindungen geschlossen sind.
"
	httpClient ifNotNil: [
		httpClient removeDependent: self.
	].

	(httpClient isKindOf: WinHttpRequest) ifTrue: [
		httpClient release.
		httpClient := nil.
	].
	
!"end close "


config
	^config.
!"end config "


initialize
	httpClient := self class newHttpClient.
	httpClient addDependent: self.
	config := SimpleObject new.
	session := IdentityDictionary new.
!"end initialize "


send: httpVerb request: aString path: urlPath

	| headers reply result url cookie contentType |
	
	config url isNilOrBlank ifTrue: [
		(VEError newCode: #VENoLicense) signal.
	].
	
	(JobServerProtocol logSymbols includes: #'soap-msg') ifTrue: [
		JobServerProtocol log: aString as: #'soap-msg'.
	].
	
	headers := Dictionary new.
	headers at: 'Content-Type' put: 'application/json'.
	
	"httpClient authentication: 'Basic'."
	headers at: 'Authorization' put: 'Basic ' + (HTTPClient encodeUser: config credentials key password: config credentials value).
	session isNilOrEmpty ifFalse: [
		headers at: 'Cookie' put: (HTTPCookie getRequestString: session values).
	].
	
	"Construct URL from hostname (uri) and path"
	url := config url.
	(url last ~= $/ and: [urlPath first ~= $/]) ifTrue: [
		url := url + '/'.
	].
	url := url + urlPath.
	
	reply := httpClient send: httpVerb to: url out header: headers content: 
		(aString isNil ifTrue: [nil] ifFalse: [(aString asByteArrayEncoding: #UTF8)]).
	
	(httpClient reply isSuccessful or: ([httpClient reply returnCode = '204'])) ifTrue: [
		httpClient reply returnCode = '204' ifTrue: [^IdentityDictionary new].
		result := reply contentsAsStream contents asStringEncoding: #UTF8.
	] ifFalse: [
		(result := reply contentsAsStream contents asStringEncoding: #UTF8) isNilOrBlank ifTrue: [
			(VEError newCode: #ERROR description: (self getLabelFor: #ERROR with: (Array with: (reply returnText)))) signal.
		].
	].
	
	(httpClient reply contentType last indexOf: 'json') > 0 ifTrue: [
		contentType := #json.
	].

	(cookie := HTTPCookie fromReply: httpClient reply) isNilOrEmpty ifFalse: [
		cookie do: [:each |
			session at: each key put: each.
		].
	].
	
	contentType = #json ifTrue: [
		result := (Json readFrom: result readStream).
	] ifFalse: [
		result := reply returnText asSymbol.
	].
	
	^result.
!"end send:request:path: "


send: operationSymbol to: resourceString args: jsonObject
"
	Angelehnt an Thread>>send:to:args:
"

	^self sendApi: operationSymbol
			request: ((jsonObject isNil or: [jsonObject isString]) 
				ifTrue: [jsonObject]
				ifFalse: [Json render: jsonObject])
			path: resourceString.
!"end send:to:args: "


sendApi: httpVerb request: aString path: urlPath
	| url |
	
	url := urlPath.
	(url indexOf: self config api) = 0 ifTrue: [
		url := config api + config version + url.
		url := url copyReplaceAll: '//' with: '/'.
	].
	
	^self send: httpVerb request: aString path: url.
!"end sendApi:request:path: "


!"End of methods block"

