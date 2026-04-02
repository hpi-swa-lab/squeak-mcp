private
deleteClass: name
	| theClass oldAuthor |
	theClass := Smalltalk classNamed: name.
	theClass ifNil: [^ self errorResult: 'Class ', name, ' not found'].

	oldAuthor := Utilities authorInitials.
	[
		Utilities authorInitials: 'MCPServer'.
		theClass removeFromSystem.
	] ensure: [Utilities authorInitials: oldAuthor].

	^ self successResult: (Dictionary new
			at: 'action' put: 'deleted';
			at: 'class' put: name;
			yourself)