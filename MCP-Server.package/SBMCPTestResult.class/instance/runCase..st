running
runCase: aTestCase
	"Like TestResult>>runCase:, but also report each failure and error while its frames still exist."
	| testCasePassed timeToRun |
	currentCase := aTestCase.
	testCasePassed := true.
	[timeToRun := [aTestCase runCase] timeToRunWithoutGC]
		on: self class failure
		do: [:exception |
			failures add: aTestCase.
			testCasePassed := false.
			exception isTimeout ifTrue: [timeouts add: aTestCase].
			self report: exception of: aTestCase.
			exception return: false]
		on: self class allErrors
		do: [:exception |
			errors add: aTestCase.
			testCasePassed := false.
			self report: exception of: aTestCase.
			exception return: false].
	testCasePassed ifTrue: [passed add: aTestCase].
	self durations at: aTestCase put: timeToRun.
	currentCase := nil