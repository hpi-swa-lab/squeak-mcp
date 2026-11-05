private
addMethod: arguments class: theClass className: className
	| source category error methodSelector |
	source := self from: arguments get: 'source' ifAbsent: ''.
	category := self from: arguments get: 'category' ifAbsent: 'as yet unclassified'.

	source isEmpty ifTrue: [^ self errorResult: 'source parameter is required for add'].

	methodSelector := (theClass parserClass new parseSelector: source).
	(theClass includesSelector: methodSelector) ifTrue: [
		^ self errorResult: 'Method ', methodSelector, ' already exists in ', className, '. Use modify action to change it.'].

	error := nil.
	self withMCPAuthorInitials: [
		[theClass compile: source withSqueakLineEndings classified: category]
			on: SyntaxErrorNotification do: [:ex | error := self syntaxErrorMessage: ex in: source withSqueakLineEndings]
			on: Error do: [:ex | error := self errorMessageOf: ex]].

	error ifNotNil: [^ self errorResult: error].
	
	^ self successResult: (Dictionary new
			at: 'action' put: 'added';
			at: 'class' put: className;
			at: 'method' put: methodSelector;
			at: 'category' put: category;
			yourself)