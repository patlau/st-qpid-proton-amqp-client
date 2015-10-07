QpidProton subclass: #QpidProtonSubscription
instanceVariableNames: '
	pn_subscription_t
'
classVariableNames: '
'
poolDictionaries: '
' !


! QpidProtonSubscription class methods!


new: pn_subscription_t
	| obj |
	obj := super new.
	obj varAt: #pn_subscription_t put: pn_subscription_t.
	^obj.
!"end new: "


!"End of class methods block"


! QpidProtonSubscription methods!


pn_subscription_t
	^pn_subscription_t.
!"end pn_subscription_t "


destroy
	pn_subscription_t ifNil: [^self].
	super destroy.
	pn_subscription_t := nil.

!"end pn_subscription_t "


context
"
 Get a subscription's application context.

 See ::pn_subscription_set_context().

 @param[in] sub a subscription object
 @return the subscription's application context
"
	pn_subscription_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_subscription_get_context: pn_subscription_t "pn_subscription_t*".
!"end context "


context: context
"
 Set an application context for a subscription.

 @param[in] sub a subscription object
 @param[in] context the application context for the subscription
"
	pn_subscription_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_subscription_set_context: pn_subscription_t "pn_subscription_t*"
		with: context "void*".
!"end context "


address
"
 Get the source address of a subscription.

 @param[in] sub a subscription object
 @return the subscription's source address
"
	pn_subscription_t ifNil: [^nil].
	^QpidProtonLibrary 
		pn_subscription_address: pn_subscription_t "pn_subscription_t*".
!"end address "


!"End of methods block"

