running
defectReportsOf: testCases in: aTestResult
	"Message and stack for the first ones, only the name for the rest."
	^ testCases asArray withIndexCollect: [:each :index |
		index <= self class maxDetailedDefects
			ifTrue: [aTestResult defectReports at: each]
			ifFalse: [Dictionary new at: 'test' put: each printString; yourself]]