helpers
parameterNamed: aString type: aType description: aDescription
	"Helper to build a parameter schema entry"
	^ Dictionary new
		at: 'type' put: aType;
		at: 'description' put: aDescription;
		yourself