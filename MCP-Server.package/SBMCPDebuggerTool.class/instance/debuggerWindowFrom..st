debuggers
debuggerWindowFrom: arguments
	"The window of the debugger to work with, or an error message."
	| windows id |
	windows := self debuggerWindows.
	windows isEmpty ifTrue: [^ 'No debugger is open'].
	id := (self from: arguments get: 'debugger' ifAbsent: ['']) asString.
	id isEmpty ifTrue: [
		^ windows size = 1
			ifTrue: [windows first]
			ifFalse: ['Several debuggers are open; pass debugger with one of their ids: ', (windows collect: [:each | (self idOf: each), ' (', each label asString, ')']) asArray printString]].
	^ windows
		detect: [:each | (self idOf: each) = id]
		ifNone: ['No debugger with id ', id, ' is open']