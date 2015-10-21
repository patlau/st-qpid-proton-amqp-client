Structure SecondaryFile !


!Structure class methods!


!"End of class methods block"


!Structure methods!


memberAt: aSymbol 
	^self at: aSymbol 

!"end elementAt: "


memberAt: aSymbol put: anObject
	^self at: aSymbol put: anObject.
!"end elementAt:put: "


new
	^Structure newLike: self.

!"end new "


!"End of methods block"
