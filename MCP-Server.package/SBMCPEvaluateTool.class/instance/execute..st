executing
execute: arguments
	| expression result varName oldAuthor oldTranscript capturingTranscript error log |
	expression := self from: arguments get: 'expression' ifAbsent: ''.
	expression isEmpty ifTrue: [^ self errorResult: 'expression parameter is required'].

	oldAuthor := Utilities authorInitials.
	oldTranscript := Smalltalk at: #Transcript.

	capturingTranscript := CapturingTranscript new.
	capturingTranscript originalTranscript: oldTranscript.
	error := nil.
	[
		Smalltalk at: #Transcript put: capturingTranscript.
		Utilities authorInitials: 'MCPServer'.
		[result := Compiler evaluate: expression]
			 on: Error do: [:ex |
				error := ex class name asString, ': ',
					(ex messageText ifEmpty: [ex description])]
		] ensure: [
			Smalltalk at: #Transcript put: oldTranscript.
			Utilities authorInitials: oldAuthor
		].

	log := capturingTranscript contents.
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