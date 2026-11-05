results
describe: aMethodReference kind: kind query: query
	| description |
	(self isClassComment: aMethodReference) ifTrue: [
		^ Dictionary new
			at: 'classComment' put: aMethodReference actualClass name;
			at: 'line' put: ((aMethodReference actualClass comment asString lines
				detect: [:each | each includesSubstring: query caseSensitive: false]
				ifNone: ['']) withBlanksTrimmed truncateWithElipsisTo: self class maxLineSize);
			yourself].
	description := Dictionary new
		at: 'method' put: (self nameOf: aMethodReference);
		at: 'category' put: aMethodReference category asString;
		yourself.
	kind = 'implementors' ifFalse: [
		(self lineOf: aMethodReference matching: (self needlesFor: kind query: query) skipPattern: kind = 'senders')
			ifNotNil: [:line | description at: 'line' put: line]].
	^ description