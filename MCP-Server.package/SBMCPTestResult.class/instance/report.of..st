running
report: anException of: aTestCase
	"Only for unexpected defects; the expected ones are just counted."
	aTestCase shouldPass ifFalse: [^ self].
	self defectReports at: aTestCase put: (Dictionary new
		at: 'test' put: aTestCase printString;
		at: 'error' put: (tool errorMessageOf: anException);
		at: 'stack' put: (tool stackFrom: anException signalerContext upTo: [:context | self isTestFrame: context of: aTestCase]);
		yourself)