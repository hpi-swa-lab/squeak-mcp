private
syntaxErrorMessage: aSyntaxError in: expression
	"Mark the error in the source like a Squeak editor does. SyntaxErrorNotification>>messageText cannot be used: it needs a cue, which Compiler evaluate: does not set."
	| position |
	position := (aSyntaxError location ifNil: [1]) min: expression size + 1 max: 1.
	^ 'SyntaxError: ', aSyntaxError errorMessage, ' at position ', position printString, ': ',
		(expression first: position - 1), aSyntaxError errorMessage, ' ->', (expression allButFirst: position - 1)