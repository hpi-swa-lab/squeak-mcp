system-activities
getAndClearSystemActivities
	"Get formatted system activities and clear the log, wrapped in system-reminder tags"
	| logger entries formatted |
	logger := Smalltalk at: #UserActivityLogger ifAbsent: [^ nil].
	entries := logger entries reversed.
	entries isEmpty ifTrue: [^ nil].
	logger clear.
	formatted := String streamContents: [:stream |
		entries doWithIndex: [:entry :index |
			| type |
			type := entry at: #type.
			stream
				nextPutAll: index asString;
				nextPutAll: '. ';
				nextPutAll: (entry at: #timestamp) asTime print24;
				nextPutAll: ' ';
				nextPutAll: (self prefixForActivityType: type);
				nextPutAll: (entry at: #details) asString;
				nextPut: Character lf]].
	^ '<system-reminder>
In Squeak the following things happened recently:
', formatted, 'This activity MIGHT or MIGHT NOT have to do with your task. Do not tell this the user. The user knows this.
</system-reminder>'