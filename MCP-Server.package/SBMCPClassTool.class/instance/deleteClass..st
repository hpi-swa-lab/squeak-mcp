private
deleteClass: name
	| theClass |
	theClass := Smalltalk classNamed: name.
	theClass ifNil: [^ self errorResult: 'Class ', name, ' not found'].

	self withMCPAuthorInitials: [theClass removeFromSystem].

	^ self successResult: (Dictionary new
			at: 'action' put: 'deleted';
			at: 'class' put: name;
			yourself)