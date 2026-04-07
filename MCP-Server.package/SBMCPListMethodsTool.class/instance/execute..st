executing
execute: arguments
	| className theClass results |
	className := self from: arguments get: 'class' ifAbsent: ''.
	className isEmpty ifTrue: [^ self errorResult: 'class parameter is required'].

	theClass := (className endsWith: ' class')
		ifTrue: [
			(Smalltalk at: (className copyUpToLast: Character space) asSymbol ifAbsent: [nil])
				ifNotNil: [:c | c class]]
		ifFalse: [
			Smalltalk at: className asSymbol ifAbsent: [nil]].
	theClass ifNil: [
		^ self errorResult: 'Class not found: ', className].

	results := theClass selectors collect: [:sel |
		Dictionary new
			at: 'selector' put: sel;
			at: 'category' put: (theClass whichCategoryIncludesSelector: sel);
			yourself].

	^ self successResult: results asArray