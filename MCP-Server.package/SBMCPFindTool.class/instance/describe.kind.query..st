results
describe: aMethodReference kind: kind query: query
	| description |
	description := Dictionary new
		at: 'method' put: (self nameOf: aMethodReference);
		at: 'category' put: aMethodReference category asString;
		yourself.
	kind = 'implementors' ifFalse: [
		(self lineOf: aMethodReference matching: (self needlesFor: kind query: query) skipPattern: kind = 'senders')
			ifNotNil: [:line | description at: 'line' put: line]].
	^ description