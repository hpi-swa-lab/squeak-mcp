executing
run: expression seconds: timeout in: aContextOrNil
	"Evaluate expression, see runBlock:seconds:. With a context, as the debugger does: with its receiver as self and access to its temporaries."
	| syntaxError outcome |
	outcome := self
		runBlock: [
			[self evaluate: expression in: aContextOrNil]
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