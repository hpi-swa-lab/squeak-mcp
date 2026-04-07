private
renameClass: arguments newName: newName
	| oldName oldClass oldAuthor |
	oldName := self from: arguments get: 'oldName' ifAbsent: ''.
	oldName isEmpty ifTrue: [^ self errorResult: 'oldName parameter is required for rename'].

	oldClass := Smalltalk classNamed: oldName.
	oldClass ifNil: [^ self errorResult: 'Class ', oldName, ' not found'].

	oldAuthor := Utilities authorInitials.
	[
		Utilities authorInitials: 'MCPServer'.
		oldClass rename: newName.
	] ensure: [Utilities authorInitials: oldAuthor].

	^ self successResult: (Dictionary new
			at: 'action' put: 'renamed';
			at: 'oldName' put: oldName;
			at: 'newName' put: newName;
			yourself)