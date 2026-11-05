actions
act: action on: aDebuggerWindow frame: frameOrNil arguments: arguments
	"Do action in the UI process, as if the user had clicked the button, and answer the new state."
	| debugger process source class category syntaxError done window |
	debugger := aDebuggerWindow model.
	process := debugger interruptedProcess.
	action = 'accept' ifTrue: [
		source := self from: arguments get: 'source' ifAbsent: [''].
		source isEmpty ifTrue: [^ self errorResult: 'source parameter is required for accept']].
	action = 'create' ifTrue: [
		debugger interruptedContext selector == #doesNotUnderstand: ifFalse: [
			^ self errorResult: 'create is for debuggers on doesNotUnderstand: (the top frame)'].
		class := self classForCreateFrom: arguments in: debugger.
		class isString ifTrue: [^ self errorResult: class].
		category := self from: arguments get: 'category' ifAbsent: ['as yet unclassified']].
	(action = 'select' and: [frameOrNil isNil]) ifTrue: [^ self errorResult: 'frame parameter is required for select'].

	done := self withMCPAuthorInitials: [
		self
			inUIProcess: [
				frameOrNil ifNotNil: [self select: frameOrNil in: debugger].
				action = 'stepOver' ifTrue: [debugger stepOver].
				action = 'stepInto' ifTrue: [debugger stepInto].
				action = 'stepThrough' ifTrue: [debugger stepThrough].
				action = 'restart' ifTrue: [debugger restart].
				action = 'accept' ifTrue: [
					[debugger contents: source withSqueakLineEndings notifying: nil]
						on: SyntaxErrorNotification do: [:ex |
							syntaxError := self syntaxErrorMessage: ex in: source withSqueakLineEndings]].
				action = 'create' ifTrue: [
					self select: 1 in: debugger.
					debugger
						implementMissingMethod: debugger interruptedContext exceptionMessage
						inClass: class
						inCategory: category asSymbol].
				action = 'proceed' ifTrue: [debugger proceed].
				action = 'abandon' ifTrue: [debugger abandon].
				true]
			seconds: self class uiTimeoutSeconds
			ifTimedOut: [false]].
	done ifFalse: [
		^ self errorResult: 'The UI process did not finish ', action, ' within ', self class uiTimeoutSeconds printString, ' seconds; it may be waiting for the user, e.g. in a dialog'].
	syntaxError ifNotNil: [^ self errorResult: syntaxError].
	"Some actions replace the debugger window, e.g. create opens a new debugger on the same process."
	window := self debuggerWindows
		detect: [:each | each model interruptedProcess == process]
		ifNone: [
			^ self successResult: (Dictionary new
				at: 'action' put: action;
				at: 'debuggerOpen' put: false;
				yourself)].
	^ self successResult: (self stateOf: window frame: nil)