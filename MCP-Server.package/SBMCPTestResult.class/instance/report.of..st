running
report: anException of: aTestCase
	"Only for unexpected defects; the expected ones are just counted. A test can fail twice, e.g. time out and then fail in tearDown; the first report is the important one, a later one is added to it."
	| report |
	aTestCase shouldPass ifFalse: [^ self].
	report := Dictionary new
		at: 'error' put: (tool errorMessageOf: anException);
		at: 'stack' put: (tool stackFrom: anException signalerContext upTo: [:context | self isTestFrame: context of: aTestCase]);
		yourself.
	(self defectReports includesKey: aTestCase)
		ifTrue: [(self defectReports at: aTestCase) at: 'followedBy' put: report]
		ifFalse: [self defectReports at: aTestCase put: (report at: 'test' put: aTestCase printString; yourself)]