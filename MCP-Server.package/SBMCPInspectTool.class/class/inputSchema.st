accessing
inputSchema
	^ Dictionary new
		at: 'type' put: 'object';
		at: 'properties' put: (Dictionary new
			at: 'expression' put: (self
				parameterNamed: 'expression'
				type: 'string'
				description: 'Smalltalk expression answering the object to inspect');
			at: 'variable' put: (self
				parameterNamed: 'variable'
				type: 'string'
				description: 'Instead of expression: the variable of an earlier evaluate or inspect result (cleared when the image is saved or the server stops)');
			at: 'path' put: ((self
				parameterNamed: 'path'
				type: 'array'
				description: 'Field names to follow from the object, as the answer lists them, e.g. ["submorphs", "1"]; dictionary keys are written as printed, e.g. "#name"')
					at: 'items' put: (Dictionary new at: 'type' put: 'string'; yourself);
					yourself);
			yourself);
		at: 'required' put: #();
		yourself