executing
execute: arguments
	| evaluator variable expression root outcome path |
	evaluator := SBMCPEvaluateTool new.
	variable := self from: arguments get: 'variable' ifAbsent: [''].
	expression := self from: arguments get: 'expression' ifAbsent: [''].
	variable isEmpty
		ifFalse: [
			root := SBMCPEvaluateTool sessionResults at: variable ifAbsent: [
				^ self errorResult: 'No result with variable ', variable, '; results are cleared when the image is saved or the server stops']]
		ifTrue: [
			expression isEmpty ifTrue: [^ self errorResult: 'expression or variable parameter is required'].
			outcome := evaluator run: expression seconds: SBMCPEvaluateTool defaultTimeout.
			(outcome at: 'success') ifFalse: [^ self addSystemChangesTo: outcome].
			root := outcome at: #value.
			variable := SBMCPEvaluateTool remember: root].
	path := self pathFrom: arguments.
	outcome := evaluator
		runBlock: [self inspectionOf: root path: path]
		seconds: SBMCPEvaluateTool defaultTimeout.
	(outcome at: 'success') ifFalse: [^ self addSystemChangesTo: outcome].
	((outcome at: #value) includesKey: 'error') ifTrue: [^ self errorResult: ((outcome at: #value) at: 'error')].
	^ self successResult: ((outcome at: #value)
		at: 'variable' put: variable;
		yourself)