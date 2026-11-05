accessing
inputSchema
	^ Dictionary new
		at: 'type' put: 'object';
		at: 'properties' put: (Dictionary new
			at: 'action' put: ((self
				parameterNamed: 'action'
				type: 'string'
				description: 'What to do, see the tool description')
					at: 'enum' put: self actions;
					yourself);
			at: 'debugger' put: (self
				parameterNamed: 'debugger'
				type: 'string'
				description: 'The id of the debugger from list; can be omitted if only one debugger is open');
			at: 'frame' put: (self
				parameterNamed: 'frame'
				type: 'integer'
				description: 'Frame number, 1 is the top; default: the frame selected in the debugger');
			at: 'expression' put: (self
				parameterNamed: 'expression'
				type: 'string'
				description: 'For evaluate: Smalltalk expression; self and the temporaries are those of the frame');
			at: 'source' put: (self
				parameterNamed: 'source'
				type: 'string'
				description: 'For accept: the complete new source of the frame''s method');
			at: 'class' put: (self
				parameterNamed: 'class'
				type: 'string'
				description: 'For create: the class to create the method in (default: the receiver''s class); append " class" for class methods');
			at: 'category' put: (self
				parameterNamed: 'category'
				type: 'string'
				description: 'For create: the method category (default: as yet unclassified)');
			yourself);
		at: 'required' put: #('action');
		yourself