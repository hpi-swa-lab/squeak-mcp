accessing
statsText
	| totalCalls toolCounts successCount errorCount |
	totalCalls := entries size.
	totalCalls = 0 ifTrue: [^ 'No tool calls yet'].

	toolCounts := Dictionary new.
	successCount := 0.
	errorCount := 0.

	entries do: [:entry |
		| toolName result |
		toolName := entry at: #tool.
		toolCounts at: toolName put: (toolCounts at: toolName ifAbsent: [0]) + 1.
		result := entry at: #result ifAbsent: [Dictionary new].
		(result isKindOf: Dictionary) ifTrue: [
			(result at: 'success' ifAbsent: [false])
				ifTrue: [successCount := successCount + 1]
				ifFalse: [errorCount := errorCount + 1]]].

	^ String streamContents: [:stream |
		stream nextPutAll: '=== STATISTICS ==='; cr; cr.
		stream nextPutAll: 'Total calls: '; nextPutAll: totalCalls printString; cr.
		stream nextPutAll: 'Successful: '; nextPutAll: successCount printString; cr.
		stream nextPutAll: 'Errors: '; nextPutAll: errorCount printString; cr; cr.
		stream nextPutAll: '--- Calls per Tool ---'; cr.
		(toolCounts associations sorted: [:a :b | a value > b value])
			do: [:assoc |
				stream nextPutAll: '  '; nextPutAll: assoc key;
					nextPutAll: ': '; nextPutAll: assoc value printString; cr].
		stream cr; nextPutAll: 'Tracking: ';
			nextPutAll: (isTracking ifTrue: ['ON'] ifFalse: ['OFF'])]