logging
pruneEntriesOfType: type
	| count |
	(#(mouseDown error) includes: type) ifFalse: [^ self].
	count := 0.
	log copy do: [:entry |
		(#(mouseDown error) includes: (entry at: #type)) ifTrue: [
			count := count + 1.
			count > maxEntries ifTrue: [log remove: entry]]]