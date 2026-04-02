private
deleteMethod: theClass className: className methodName: methodName
	| oldAuthor |
	(theClass includesSelector: methodName asSymbol) ifFalse: [
		^ self errorResult: 'Method ', methodName, ' not found in ', className].

	oldAuthor := Utilities authorInitials.
	[
		Utilities authorInitials: 'MCPServer'.
		theClass removeSelector: methodName asSymbol.
	] ensure: [Utilities authorInitials: oldAuthor].

	^ self successResult: (Dictionary new
			at: 'action' put: 'deleted';
			at: 'class' put: className;
			at: 'method' put: methodName;
			yourself)