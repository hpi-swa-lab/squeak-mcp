running
report: aTestResult of: aTestSuite milliseconds: milliseconds timeout: timeoutReport log: log
	| report |
	report := Dictionary new
		at: 'summary' put: aTestResult printString;
		at: 'seconds' put: (milliseconds / 100) rounded / 10.0;
		at: 'passed' put: aTestResult expectedPassCount;
		at: 'expectedDefects' put: aTestResult expectedDefectCount;
		at: 'failures' put: (self defectReportsOf: aTestResult unexpectedFailures in: aTestResult);
		at: 'errors' put: (self defectReportsOf: aTestResult unexpectedErrors in: aTestResult);
		at: 'unexpectedPasses' put: (aTestResult unexpectedPasses collect: [:each | each printString]) asArray;
		at: 'log' put: (log size > self class maxLogSize
			ifTrue: ['...', (log last: self class maxLogSize)]
			ifFalse: [log]);
		yourself.
	timeoutReport ifNotNil: [
		report
			at: 'timedOut' put: timeoutReport;
			at: 'notRun' put: aTestSuite tests size - aTestResult runCount].
	^ report