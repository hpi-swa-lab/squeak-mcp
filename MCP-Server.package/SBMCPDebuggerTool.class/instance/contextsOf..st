frames
contextsOf: aDebugger
	"All frames, from the top; frame n is at index n, as in the debugger's list."
	| contexts context |
	contexts := OrderedCollection new.
	context := aDebugger interruptedContext.
	[context notNil] whileTrue: [
		contexts add: context.
		context := context sender].
	^ contexts