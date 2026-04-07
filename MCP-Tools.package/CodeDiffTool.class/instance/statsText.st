accessing
statsText
	| classChanges methodChanges addedMethods modifiedMethods |
	classChanges := changes select: [:c | (c at: #type) = #class].
	methodChanges := changes select: [:c | (c at: #type) = #method].
	addedMethods := methodChanges select: [:c | (c at: #changeKind) = #Added].
	modifiedMethods := methodChanges select: [:c | (c at: #changeKind) = #Modified].

	^ String streamContents: [:stream |
		stream nextPutAll: '=== Statistics ==='; cr; cr.
		stream nextPutAll: 'Total changes: '; nextPutAll: changes size asString; cr; cr.
		stream nextPutAll: 'Class changes: '; nextPutAll: classChanges size asString; cr.
		stream nextPutAll: 'Method changes: '; nextPutAll: methodChanges size asString; cr.
		stream nextPutAll: '  - Added: '; nextPutAll: addedMethods size asString; cr.
		stream nextPutAll: '  - Modified: '; nextPutAll: modifiedMethods size asString; cr; cr.
		stream nextPutAll: 'Tracking: ';
		nextPutAll: (isTracking ifTrue: ['ON'] ifFalse: ['OFF'])]