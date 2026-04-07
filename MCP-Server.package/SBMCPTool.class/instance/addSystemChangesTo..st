system-activities
addSystemChangesTo: aDictionary
	"Add system activities to the response dictionary if any exist"
	| activities |
	activities := self getAndClearSystemActivities.
	activities ifNotNil: [aDictionary at: 'systemChanges' put: activities].
	^ aDictionary