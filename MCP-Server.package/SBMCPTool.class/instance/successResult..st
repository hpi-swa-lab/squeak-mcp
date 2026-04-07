results
successResult: anObject
	"Wrap a successful result with optional system activities"
	| dict activities |
	dict := Dictionary new
		at: 'success' put: true;
		at: 'result' put: anObject;
		yourself.
	activities := self getAndClearSystemActivities.
	activities ifNotNil: [dict at: 'systemChanges' put: activities].
	^ dict