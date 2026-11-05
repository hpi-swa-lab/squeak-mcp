executing
run: expression seconds: timeout
	"Evaluate expression, see runBlock:seconds:."
	| syntaxError outcome |
	outcome := self
		runBlock: [
			[self evaluate: expression]
				on: SyntaxErrorNotification do: [:ex |
					syntaxError := self syntaxErrorMessage: ex in: expression.
					nil]]
		seconds: timeout.
	syntaxError ifNotNil: [
		outcome
			removeKey: #value ifAbsent: [];
			at: 'success' put: false;
			at: 'error' put: syntaxError].
	^ outcome