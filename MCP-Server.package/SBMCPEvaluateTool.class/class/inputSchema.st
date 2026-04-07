accessing
inputSchema
	| properties |
	properties := Dictionary new
		at: 'expression' put: (Dictionary new
			at: 'type' put: 'string';
			at: 'description' put: 'Smalltalk expression to evaluate';
			yourself);
		yourself.
	^ Dictionary new
		at: 'type' put: 'object';
		at: 'properties' put: properties;
		at: 'required' put: #('expression');
		yourself