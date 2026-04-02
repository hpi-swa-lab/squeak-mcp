private
modifyMethod: arguments class: theClass className: className methodName: methodName
	| source category oldAuthor error existingCategory |
	source := self from: arguments get: 'source' ifAbsent: ''.
	category := self from: arguments get: 'category' ifAbsent: nil.

	source isEmpty ifTrue: [^ self errorResult: 'source parameter is required for modify'].
	(theClass includesSelector: methodName asSymbol) ifFalse: [
		^ self errorResult: 'Method ', methodName, ' not found in ', className, '. Use add action to create it.'].

	category ifNil: [
		existingCategory := theClass organization categoryOfElement: methodName asSymbol.
		category := existingCategory ifNil: ['as yet unclassified']].

	oldAuthor := Utilities authorInitials.
	error := nil.
	[
		Utilities authorInitials: 'MCPServer'.
		[theClass compile: source withSqueakLineEndings classified: category]
			on: Error do: [:ex | error := ex messageText]
	] ensure: [Utilities authorInitials: oldAuthor].
	
	error ifNotNil: [^ self errorResult: error].

	^ self successResult: (Dictionary new
			at: 'action' put: 'modified';
			at: 'class' put: className;
			at: 'method' put: methodName;
			at: 'category' put: category;
			yourself)