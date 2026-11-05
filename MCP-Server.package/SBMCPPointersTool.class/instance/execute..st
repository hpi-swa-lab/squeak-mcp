executing
execute: arguments
	| expression maxReferrers evaluator syntaxError outcome |
	expression := self from: arguments get: 'expression' ifAbsent: [''].
	expression isEmpty ifTrue: [^ self errorResult: 'expression parameter is required'].
	maxReferrers := self integerFrom: arguments get: 'maxReferrers' ifAbsent: [self class defaultMaxReferrers].
	evaluator := SBMCPEvaluateTool new.
	outcome := evaluator
		runBlock: [
			self
				pointersOf: expression
				with: evaluator
				maxReferrers: maxReferrers
				ifSyntaxError: [:message | syntaxError := message]]
		seconds: (self integerFrom: arguments get: 'timeout' ifAbsent: [self class defaultTimeout]).
	syntaxError ifNotNil: [^ self errorResult: syntaxError].
	(outcome at: 'success') ifFalse: [^ self addSystemChangesTo: outcome].
	^ self successResult: (outcome at: #value)