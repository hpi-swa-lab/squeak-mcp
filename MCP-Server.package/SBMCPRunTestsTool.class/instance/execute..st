executing
execute: arguments
	| names suite unavailable |
	names := self from: arguments get: 'tests' ifAbsent: [''].
	suite := TestSuite named: names.
	(names findTokens: ' ,') do: [:name |
		suite addTests: ((self testsNamed: name)
			ifNil: [^ self errorResult: 'No test class, test or class category named ', name])].
	suite tests isEmpty ifTrue: [^ self errorResult: 'No tests in ', names printString].
	unavailable := suite resources reject: [:each | each isAvailable].
	unavailable isEmpty ifFalse: [
		^ self errorResult: 'Test resources not available: ', (unavailable collect: [:each | each name]) asArray printString].
	^ self successResult: (self run: suite seconds: (self integerFrom: arguments get: 'timeout' ifAbsent: [self class defaultTimeout]))