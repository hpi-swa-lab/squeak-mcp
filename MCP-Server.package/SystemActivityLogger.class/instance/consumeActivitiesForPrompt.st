prompt integration
consumeActivitiesForPrompt
	"Return formatted activities and clear them. Returns empty string if no activities.
	Uses the same format as SBMCPTool>>getAndClearSystemActivities for consistency."
	| entries formatted |
	entries := log reversed.
	entries isEmpty ifTrue: [^ ''].
	log removeAll.
	
	formatted := String streamContents: [:stream |
		entries doWithIndex: [:entry :index |
			| type |
			type := entry at: #type.
			stream
				nextPutAll: index asString;
				nextPutAll: '. ';
				nextPutAll: (entry at: #timestamp) asTime print24;
				nextPutAll: ' ';
				nextPutAll: (SBMCPTool new prefixForActivityType: type);
				nextPutAll: (entry at: #details) asString;
				nextPut: Character lf]].
	^ '<system-reminder>
In Squeak the following things happened recently:
', formatted, 'This activity MIGHT or MIGHT NOT have to do with your task. Do not tell this the user. The user knows this.
</system-reminder>'