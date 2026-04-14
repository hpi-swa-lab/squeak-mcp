logging
createEntryFrom: aDictionary
	| entry |
	entry := Dictionary new
		at: #timestamp put: DateAndTime now;
		at: #type put: (aDictionary at: #type ifAbsent: [#unknown]);
		at: #details put: (aDictionary at: #details ifAbsent: ['']);
		yourself.
	aDictionary keysAndValuesDo: [:key :value |
		entry at: key ifAbsentPut: [value]].
	^ entry