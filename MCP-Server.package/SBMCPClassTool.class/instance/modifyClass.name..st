private
modifyClass: arguments name: name
	| theClass superclassName instVars classVars poolDicts category comment superclass 	oldAuthor newSuperclass newInstVars newClassVars newPoolDicts newCategory modified |

	theClass := Smalltalk classNamed: name.
	theClass ifNil: [^ self errorResult: 'Class ', name, ' not found'].

	superclassName := self from: arguments get: 'superclass' ifAbsent: nil.
	instVars := self from: arguments get: 'instanceVariableNames' ifAbsent: nil.
	classVars := self from: arguments get: 'classVariableNames' ifAbsent: nil.
	poolDicts := self from: arguments get: 'poolDictionaries' ifAbsent: nil.
	category := self from: arguments get: 'category' ifAbsent: nil.
	comment := self from: arguments get: 'comment' ifAbsent: nil.

	modified := OrderedCollection new.
	oldAuthor := Utilities authorInitials.
	[
		Utilities authorInitials: 'MCPServer'.
		newSuperclass := superclassName
			ifNil: [theClass superclass]
			ifNotNil: [
				superclass := Smalltalk classNamed: superclassName.
				superclass ifNil: [^ self errorResult: 'Superclass ', superclassName, ' not found'].
				modified add: 'superclass'.
				superclass].
		newInstVars := instVars
			ifNil: [theClass instanceVariablesString]
			ifNotNil: [modified add: 'instanceVariableNames'. instVars].
		newClassVars := classVars
			ifNil: [theClass classVariablesString]
			ifNotNil: [modified add: 'classVariableNames'. classVars].
		newPoolDicts := poolDicts
			ifNil: [theClass sharedPoolsString]
			ifNotNil: [modified add: 'poolDictionaries'. poolDicts].
		newCategory := category
			ifNil: [theClass category]
			ifNotNil: [modified add: 'category'. category].

		newSuperclass
			subclass: theClass name
			instanceVariableNames: newInstVars
			classVariableNames: newClassVars
			poolDictionaries: newPoolDicts
			category: newCategory.

		comment ifNotNil: [
			theClass classComment: comment.
			modified add: 'comment'].
	] ensure: [Utilities authorInitials: oldAuthor].

	modified isEmpty ifTrue: [
		^ self errorResult: 'No modifications specified'].

	^ self successResult: (Dictionary new
			at: 'action' put: 'modified';
			at: 'class' put: name;
			at: 'modified' put: modified asArray;
			yourself)