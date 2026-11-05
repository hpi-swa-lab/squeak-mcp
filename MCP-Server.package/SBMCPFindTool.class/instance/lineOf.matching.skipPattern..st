results
lineOf: aMethodReference matching: needleSets skipPattern: aBoolean
	"The first source line that contains all strings of a needle set (ignoring case), trying the sets in order; trimmed. For senders without the method pattern, which may be the selector itself. Answer nil if there is none."
	| lines |
	lines := aMethodReference sourceString lines.
	aBoolean ifTrue: [lines := lines allButFirst].
	needleSets do: [:needles |
		lines
			detect: [:line | needles allSatisfy: [:each | line includesSubstring: each caseSensitive: false]]
			ifFound: [:line | ^ line withBlanksTrimmed truncateWithElipsisTo: self class maxLineSize]].
	^ nil