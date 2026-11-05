executing
run: expression seconds: timeout
	"Evaluate expression in a process of its own with the MCP author initials, capturing the Transcript; stop it after timeout seconds. Answer a Dictionary with 'success', 'log', and either #value (the result object, not sent to the client) or 'error' and 'stack'."
	| result capture start error stack log done process outcome |
	capture := self class beginCapture.
	start := capture position.
	done := Semaphore new.
	[self withMCPAuthorInitials: [
		"Below the request process's priority: processes of equal priority do not preempt each other, so a busy evaluation would never let the request process stop it."
		process := [
			[[[result := self evaluate: expression]
				on: SyntaxErrorNotification do: [:ex |
					error := self syntaxErrorMessage: ex in: expression]]
				on: Error, Halt, Warning do: [:ex |
					"Unhandled, these would open a debugger, and the request would never be answered."
					"Take the log first: building the trace parses the expression again, which repeats compiler warnings."
					log := capture contentsFrom: start.
					error := self errorMessageOf: ex.
					stack := self stackTraceOf: ex]]
				ensure: [done signal]]
			forkAt: Processor activeProcess priority - 1.
		(done waitTimeoutSeconds: timeout) ifTrue: [
			log := capture contentsFrom: start.
			error := 'Timeout: stopped after ', timeout printString, ' seconds'.
			stack := self stackToDoItFrom: process suspendedContext.
			process terminate].
		log ifNil: [log := capture contentsFrom: start]]]
		ensure: [self class endCapture].

	outcome := Dictionary new
		at: 'success' put: error isNil;
		at: 'log' put: log;
		yourself.
	error
		ifNil: [outcome at: #value put: result]
		ifNotNil: [outcome at: 'error' put: error; at: 'stack' put: stack].
	^ outcome