executing
execute: arguments
	| expression outcome result varName |
	expression := self from: arguments get: 'expression' ifAbsent: [''].
	expression isEmpty ifTrue: [^ self errorResult: 'expression parameter is required'].

	outcome := self run: expression.
	(outcome at: 'success') ifFalse: [^ self addSystemChangesTo: outcome].

	result := outcome removeKey: #value.
	varName := self class generateVariableName.
	self class sessionResults at: varName put: result.
	outcome at: 'result' put: (Dictionary new
		at: 'value' put: result printString;
		at: 'class' put: result class name;
		at: 'variable' put: varName;
		yourself).
	^ self addSystemChangesTo: outcome