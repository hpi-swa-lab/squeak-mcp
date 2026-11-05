running
timeoutReportOf: aProcess in: aTestResult after: seconds
	"Where the run is, before it gets terminated."
	| test |
	test := aTestResult currentCase.
	^ Dictionary new
		at: 'afterSeconds' put: seconds;
		at: 'test' put: test printString;
		at: 'stack' put: (self
			stackFrom: aProcess suspendedContext
			upTo: [:context | test notNil and: [aTestResult isTestFrame: context of: test]]);
		yourself