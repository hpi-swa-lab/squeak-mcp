running
run: aTestSuite seconds: timeout
	"Run the tests in a background process, so that a hanging test cannot block the server. Answer the report."
	| result done process startTime milliseconds timeoutReport capture start log |
	result := SBMCPTestResult new tool: self; yourself.
	done := Semaphore new.
	capture := SBMCPEvaluateTool beginCapture.
	start := capture position.
	[self withMCPAuthorInitials: [
		startTime := Time millisecondClockValue.
		process := [[aTestSuite run: result] ensure: [done signal]]
			forkAt: Processor activeProcess priority - 1. "Below the request process: processes of equal priority do not preempt each other, so a busy test would never let the request process stop the run."
		(done waitTimeoutSeconds: timeout) ifTrue: [
			timeoutReport := self timeoutReportOf: process in: result after: timeout.
			process terminate].
		milliseconds := Time millisecondClockValue - startTime]]
		ensure: [
			log := capture contentsFrom: start.
			SBMCPEvaluateTool endCapture.
			aTestSuite resources do: [:each | each reset]].
	^ self report: result of: aTestSuite milliseconds: milliseconds timeout: timeoutReport log: log