executing
runBlock: aBlock seconds: timeout
	"Evaluate aBlock in a process of its own with the MCP author initials, capturing the Transcript; stop it after timeout seconds. Answer a Dictionary with 'success', 'log', and either #value (the result object, not sent to the client) or 'error' and 'stack'."
	| result capture start error stack log done process outcome |
	capture := self class beginCapture.
	start := capture position.
	done := Semaphore new.
	[self withMCPAuthorInitials: [self aboveEvaluationsDo: [
		process := [
			[[result := aBlock value]
				on: Error, Halt, Warning do: [:ex |
					"Unhandled, these would open a debugger, and the request would never be answered."
					"Take the log first: building the trace parses the expression again, which repeats compiler warnings."
					log := capture contentsFrom: start.
					error := self errorMessageOf: ex.
					stack := self stackFrom: ex signalerContext within: aBlock]]
				ensure: [done signal]]
			forkAt: self class evaluationPriority.
		(done waitTimeoutSeconds: timeout) ifTrue: [
			log := capture contentsFrom: start.
			error := 'Timeout: stopped after ', timeout printString, ' seconds'.
			stack := self stackFrom: process suspendedContext within: aBlock.
			process terminate].
		log ifNil: [log := capture contentsFrom: start]]]]
		ensure: [self class endCapture].

	outcome := Dictionary new
		at: 'success' put: error isNil;
		at: 'log' put: log;
		yourself.
	error
		ifNil: [outcome at: #value put: result]
		ifNotNil: [outcome at: 'error' put: error; at: 'stack' put: stack].
	^ outcome