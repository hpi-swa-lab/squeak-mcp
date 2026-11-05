searching
methodsFor: kind query: query arguments: arguments
	"The MethodReferences found, or an error message."
	| navigation |
	navigation := SystemNavigation default.
	kind = 'senders' ifTrue: [^ navigation allCallsOn: query asSymbol].
	kind = 'implementors' ifTrue: [^ navigation allImplementorsOf: query asSymbol].
	kind = 'source' ifTrue: [^ navigation allMethodsWithSourceString: query matchCase: false].
	kind = 'references' ifTrue: [
		^ (Smalltalk bindingOf: query asSymbol)
			ifNil: ['No class or global named ', query]
			ifNotNil: [:binding | navigation allCallsOn: binding]].
	kind = 'instVarReferences' ifTrue: [ | class |
		class := Smalltalk classNamed: (self from: arguments get: 'class' ifAbsent: ['']).
		class ifNil: [^ 'instVarReferences needs the class parameter: the class that defines the variable'].
		(class allInstVarNames includes: query) ifFalse: [^ class name, ' has no instance variable ', query].
		^ navigation allAccessesTo: query from: class].
	^ 'Unknown kind ', kind