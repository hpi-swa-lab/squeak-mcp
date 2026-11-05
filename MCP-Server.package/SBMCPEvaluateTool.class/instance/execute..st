executing
execute: arguments
	| expression result varName capture start error stack log |
	expression := self from: arguments get: 'expression' ifAbsent: [''].
	expression isEmpty ifTrue: [^ self errorResult: 'expression parameter is required'].

	capture := self class beginCapture.
	start := capture position.
	error := nil.
	[self withMCPAuthorInitials: [
		[[result := self evaluate: expression]
			on: SyntaxErrorNotification do: [:ex |
				error := self syntaxErrorMessage: ex in: expression]]
			on: Error, Halt, Warning do: [:ex |
				"Unhandled, these would open a debugger in the request process, which then never answers."
				"Take the log first: building the trace parses the expression again, which repeats compiler warnings."
				log := capture contentsFrom: start.
				error := self errorMessageOf: ex.
				stack := self stackTraceOf: ex]].
	log ifNil: [log := capture contentsFrom: start]]
		ensure: [self class endCapture].

	error ifNotNil: [
		^ self addSystemChangesTo: (Dictionary new
			at: 'success' put: false;
			at: 'error' put: error;
			at: 'stack' put: stack;
			at: 'log' put: log;
			yourself)].
	
	varName := self class generateVariableName.
	self class sessionResults at: varName put: result.

	^ self addSystemChangesTo: (Dictionary new
		at: 'success' put: true;
		at: 'result' put: (Dictionary new
			at: 'value' put: result printString;
			at: 'class' put: result class name;
			at: 'variable' put: varName;
			yourself);
		at: 'log' put: log;
		yourself)