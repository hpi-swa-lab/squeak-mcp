private
createClass: arguments name: name
	| comment superclassName instVars classVars poolDicts category superclass newClass 	oldAuthor |
	comment := self from: arguments get: 'comment' ifAbsent: ''.
	superclassName := self from: arguments get: 'superclass' ifAbsent: 'Object'.
	instVars := self from: arguments get: 'instanceVariableNames' ifAbsent: ''.
	classVars := self from: arguments get: 'classVariableNames' ifAbsent: ''.
	poolDicts := self from: arguments get: 'poolDictionaries' ifAbsent: ''.
	category := self from: arguments get: 'category' ifAbsent: 'As yet unclassified'.

	(name first isUppercase) ifFalse: [
		^ self errorResult: 'Class name must start with an uppercase letter'].
	(name allSatisfy: [:c | c isAlphaNumeric]) ifFalse: [
		^ self errorResult: 'Class name must contain only alphanumeric characters'].
	comment isEmpty ifTrue: [^ self errorResult: 'comment parameter is required for create'].

	superclass := Smalltalk classNamed: superclassName.
	superclass ifNil: [^ self errorResult: 'Superclass ', superclassName, ' not found'].

	oldAuthor := Utilities authorInitials.
	[
		Utilities authorInitials: 'MCPServer'.
		newClass := superclass
			subclass: name asSymbol
			instanceVariableNames: instVars
			classVariableNames: classVars
			poolDictionaries: poolDicts
			category: category.
			newClass classComment: comment.
	] ensure: [Utilities authorInitials: oldAuthor].

	^ self successResult: (Dictionary new
			at: 'action' put: 'created';
			at: 'class' put: name;
			at: 'superclass' put: superclassName;
			at: 'category' put: category;
			yourself)