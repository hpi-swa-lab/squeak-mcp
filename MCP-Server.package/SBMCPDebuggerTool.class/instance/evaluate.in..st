executing
evaluate: expression in: aContext
	"Like the evaluate tool, with self and the temporaries of aContext."
	| outcome value |
	expression isEmpty ifTrue: [^ self errorResult: 'expression parameter is required for evaluate'].
	outcome := SBMCPEvaluateTool new
		run: expression
		seconds: SBMCPEvaluateTool defaultTimeout
		in: aContext.
	(outcome at: 'success') ifFalse: [^ self addSystemChangesTo: outcome].
	value := outcome removeKey: #value.
	outcome at: 'result' put: (Dictionary new
		at: 'value' put: (self printValue: [value]);
		at: 'class' put: value class name;
		at: 'variable' put: (SBMCPEvaluateTool remember: value);
		yourself).
	^ self addSystemChangesTo: outcome