accessing
inputSchema
	| properties |
	properties := Dictionary new
		at: 'expression' put: (Dictionary new
			at: 'type' put: 'string';
			at: 'description' put: 'Smalltalk expression to evaluate';
			yourself);
		at: 'timeout' put: (self
			parameterNamed: 'timeout'
			type: 'integer'
			description: 'Seconds after which the evaluation is stopped (default ', self defaultTimeout printString, '). The answer then says where it was.');
		yourself.
	^ Dictionary new
		at: 'type' put: 'object';
		at: 'properties' put: properties;
		at: 'required' put: #('expression');
		yourself