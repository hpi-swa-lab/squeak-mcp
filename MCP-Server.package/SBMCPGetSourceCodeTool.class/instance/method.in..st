private
method: methodName in: theClass
	"Return the method or an error string"
	methodName isEmpty ifTrue: [^ 'method parameter is required'].
	
	^ (theClass methodDict at: methodName asSymbol ifAbsent: [nil])
		ifNil: ['Method not found: ', methodName]