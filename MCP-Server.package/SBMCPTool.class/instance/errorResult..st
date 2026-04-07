results
errorResult: aString
	"Wrap an error result with optional system activities"
	| dict activities |
	dict := Dictionary new
		at: 'success' put: false;
		at: 'error' put: aString;
		yourself.
	activities := self getAndClearSystemActivities.
	activities ifNotNil: [dict at: 'systemChanges' put: activities].
	^ dict