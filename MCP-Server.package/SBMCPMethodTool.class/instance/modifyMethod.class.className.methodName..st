private
modifyMethod: arguments class: theClass className: className methodName: methodName
	| oldString newString replaceAll existingSource occurrences newSource category oldAuthor error 	existingCategory |

	oldString := self from: arguments get: 'old_string' ifAbsent: ''.
	newString := self from: arguments get: 'new_string' ifAbsent: nil.
	replaceAll := self from: arguments get: 'replace_all' ifAbsent: false.
	category := self from: arguments get: 'category' ifAbsent: nil.

	oldString isEmpty ifTrue: [^ self errorResult: 'old_string parameter is required for modify'].
	newString ifNil: [^ self errorResult: 'new_string parameter is required for modify'].
	oldString := oldString copyReplaceAll: Character lf asString with: Character cr asString.
	newString := newString copyReplaceAll: Character lf asString with: Character cr asString.
	
	(theClass includesSelector: methodName asSymbol) ifFalse: [
		^ self errorResult: 'Method ', methodName, ' not found in ', className, '. Use add action to create it.'].

	existingSource := (theClass sourceCodeAt: methodName asSymbol) asString.

	occurrences := 0.
	1 to: existingSource size - oldString size + 1 do: [:i |
		((existingSource copyFrom: i to: i + oldString size - 1) = oldString)
			ifTrue: [occurrences := occurrences + 1]].

	occurrences = 0 ifTrue: [
		^ self errorResult: 'String "', oldString, '" not found in method ', methodName].

	(occurrences > 1 and: [replaceAll not]) ifTrue: [
		^ self errorResult: 'String "', oldString, '" appears ', occurrences printString, ' times in method. Use replace_all true to replace all occurrences.'].

	replaceAll
		ifTrue: [newSource := existingSource copyReplaceAll: oldString with: newString]
		ifFalse: [newSource := existingSource copyReplaceFrom: (existingSource findString: oldString)
			to: (existingSource findString: oldString) + oldString size - 1
			with: newString].

	category ifNil: [
		existingCategory := theClass organization categoryOfElement: methodName asSymbol.
		category := existingCategory ifNil: ['as yet unclassified']].

	oldAuthor := Utilities authorInitials.
	error := nil.
	[
		Utilities authorInitials: 'MCPServer'.
		[theClass compile: newSource withSqueakLineEndings classified: category]
		on: Error do: [:ex | error := ex messageText]
	] ensure: [Utilities authorInitials: oldAuthor].
	
	error ifNotNil: [^ self errorResult: error].

	^ self successResult: (Dictionary new
		at: 'action' put: 'modified';
		at: 'class' put: className;
		at: 'method' put: methodName;
		at: 'category' put: category;
		at: 'replacements' put: occurrences;
		yourself)