tracking
populateMethodEntry: entry from: anEvent
	entry at: #className put: anEvent itemClass name.
	entry at: #selector put: anEvent itemSelector.

	((#(#Modified #Removed) includes: anEvent changeKind)
			and: [anEvent respondsTo: #oldItem]) ifTrue: [
		entry at: #oldSource put: (anEvent oldItem
			ifNotNil: [:item | item getSourceFromFile asString])].

	(#(#Added #Modified) includes: anEvent changeKind) ifTrue: [
		entry at: #newSource put: (anEvent item
			ifNotNil: [:item | item getSourceFromFile asString])]