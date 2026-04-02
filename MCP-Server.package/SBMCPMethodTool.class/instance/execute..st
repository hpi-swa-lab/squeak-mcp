executing
execute: arguments
	| action className methodName theClass |
	action := self from: arguments get: 'action' ifAbsent: ''.
	className := self from: arguments get: 'class' ifAbsent: ''.
	methodName := self from: arguments get: 'method' ifAbsent: ''.

	action isEmpty ifTrue: [^ self errorResult: 'action parameter is required'].

	theClass := self classFor: className.
	theClass isString ifTrue: [^ self errorResult: theClass].

	methodName isEmpty ifTrue: [^ self errorResult: 'method parameter is required'].

	action = 'add' ifTrue: [^ self addMethod: arguments class: theClass className: className].
	action = 'modify' ifTrue: [^ self modifyMethod: arguments class: theClass className: 		className methodName: methodName].
	action = 'delete' ifTrue: [^ self deleteMethod: theClass className: className methodName: 		methodName].

	^ self errorResult: 'Invalid action: ', action, '. Use add, modify, or delete.'