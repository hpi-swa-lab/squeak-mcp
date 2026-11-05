executing
run: expression
	"Evaluate expression with the MCP author initials, capturing the Transcript. Answer a Dictionary with 'success', 'log', and either #value (the result object, not sent to the client) or 'error' and 'stack'."
	| result capture start error stack log outcome |
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

	outcome := Dictionary new
		at: 'success' put: error isNil;
		at: 'log' put: log;
		yourself.
	error
		ifNil: [outcome at: #value put: result]
		ifNotNil: [outcome at: 'error' put: error; at: 'stack' put: stack].
	^ outcome