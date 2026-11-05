accessing
inputSchema
	^ Dictionary new
		at: 'type' put: 'object';
		at: 'properties' put: (Dictionary new
			at: 'expression' put: (self
				parameterNamed: 'expression'
				type: 'string'
				description: 'Smalltalk expression answering the object, e.g. "PSPresentationTool allInstances first"');
			at: 'maxReferrers' put: (self
				parameterNamed: 'maxReferrers'
				type: 'integer'
				description: 'How many direct referrers to list (default ', self defaultMaxReferrers printString, '); their total number is always answered');
			at: 'timeout' put: (self
				parameterNamed: 'timeout'
				type: 'integer'
				description: 'Seconds after which the search is stopped (default ', self defaultTimeout printString, ')');
			yourself);
		at: 'required' put: #('expression');
		yourself