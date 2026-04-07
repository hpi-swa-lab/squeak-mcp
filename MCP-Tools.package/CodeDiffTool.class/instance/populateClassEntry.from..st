tracking
populateClassEntry: entry from: anEvent
	entry at: #className put: anEvent item name.

	anEvent changeKind = #Renamed ifTrue: [
		entry at: #oldName put: anEvent oldName.
		entry at: #newName put: anEvent newName].

	((#(#Modified #Removed) includes: anEvent changeKind)
			and: [anEvent respondsTo: #oldItem]) ifTrue: [
		entry at: #oldDefinition put: (anEvent oldItem
			ifNotNil: [:item | item definition])].

	(#(#Added #Modified #Commented) includes: anEvent changeKind) ifTrue: [
		entry at: #newDefinition put: anEvent item definition.
		entry at: #comment put: anEvent item comment]