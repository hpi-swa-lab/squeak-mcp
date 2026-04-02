executing
execute: arguments
	| className methodName theClass method |
	className := self from: arguments get: 'class' ifAbsent: ''.
	methodName := self from: arguments get: 'method' ifAbsent: ''.

	theClass := self classFor: className.
	theClass isString ifTrue: [^ self errorResult: theClass].

	method := self method: methodName in: theClass.
	method isString ifTrue: [^ self errorResult: method].
	
	^ self successResult: method getSource