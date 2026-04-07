tracking
handleChange: anEvent
	| itemKind entry |
	isTracking ifFalse: [^ self].

	itemKind := anEvent itemKind.
	(#(#class #method) includes: itemKind) ifFalse: [^ self].

	entry := Dictionary new
		at: #type put: itemKind;
		at: #changeKind put: anEvent changeKind;
		at: #timestamp put: DateAndTime now;
		at: #author put: Utilities authorInitials;
		yourself.

	itemKind = #class
		ifTrue: [self populateClassEntry: entry from: anEvent].
	itemKind = #method
		ifTrue: [self populateMethodEntry: entry from: anEvent].

	changes addFirst: entry.
	self changed: #classList.
	self changed: #methodList