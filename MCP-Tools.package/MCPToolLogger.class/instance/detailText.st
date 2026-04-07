accessing
detailText
	| entry result resultDict timestamp |
	(selectedIndex isNil or: [selectedIndex = 0])
		ifTrue: [^ 'Select a tool call to see details'].
	selectedIndex > entries size
		ifTrue: [^ ''].

	entry := entries at: selectedIndex.
	result := entry at: #result ifAbsent: [Dictionary new].
	resultDict := (result isKindOf: Dictionary) ifTrue: [result] ifFalse: [nil].
	timestamp := entry at: #timestamp.

	^ String streamContents: [:stream |
		self writeHeaderFor: entry on: stream.
		self writeArgumentsFor: entry on: stream.
		self writeResultFor: resultDict orRaw: result on: stream]