executing
execute: arguments
	| expression result varName capture start error log |
	expression := self from: arguments get: 'expression' ifAbsent: [''].
	expression isEmpty ifTrue: [^ self errorResult: 'expression parameter is required'].

	capture := self class beginCapture.
	start := capture position.
	error := nil.
	[self withMCPAuthorInitials: [
		[result := Compiler evaluate: expression]
			on: Error do: [:ex |
				error := ex class name asString, ': ',
					(ex messageText ifEmpty: [ex description])]].
	log := capture contentsFrom: start]
		ensure: [self class endCapture].

	error ifNotNil: [
		^ self addSystemChangesTo: (Dictionary new
			at: 'success' put: false;
			at: 'error' put: error;
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