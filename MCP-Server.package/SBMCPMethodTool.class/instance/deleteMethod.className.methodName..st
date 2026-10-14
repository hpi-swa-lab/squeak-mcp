private
deleteMethod: theClass className: className methodName: methodName
	(theClass includesSelector: methodName asSymbol) ifFalse: [
		^ self errorResult: 'Method ', methodName, ' not found in ', className].

	self withMCPAuthorInitials: [theClass removeSelector: methodName asSymbol].

	^ self successResult: (Dictionary new
			at: 'action' put: 'deleted';
			at: 'class' put: className;
			at: 'method' put: methodName;
			yourself)