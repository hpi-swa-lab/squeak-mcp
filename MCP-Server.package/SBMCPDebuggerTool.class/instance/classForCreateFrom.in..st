actions
classForCreateFrom: arguments in: aDebugger
	"The class to create a missing method in, or an error message."
	| name class |
	name := (self from: arguments get: 'class' ifAbsent: ['']) withBlanksTrimmed.
	name isEmpty ifTrue: [^ aDebugger interruptedContext receiver class].
	class := Smalltalk classNamed: (name copyUpTo: Character space).
	class ifNil: [^ 'No class named ', name].
	(name endsWith: ' class') ifTrue: [class := class class].
	(aDebugger interruptedContext receiver class includesBehavior: class) ifFalse: [
		^ 'The receiver ', (self printValue: [aDebugger interruptedContext receiver]), ' is not a ', class name].
	^ class