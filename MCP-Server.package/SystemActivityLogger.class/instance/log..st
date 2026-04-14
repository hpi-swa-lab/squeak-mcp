logging
log: aDictionary
	| entry |
	entry := self createEntryFrom: aDictionary.
	log addFirst: entry.
	self pruneEntriesOfType: (entry at: #type).
	^ entry