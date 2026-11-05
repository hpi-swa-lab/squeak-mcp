accessing
inputSchema
	^ Dictionary new
		at: 'type' put: 'object';
		at: 'properties' put: (Dictionary new
			at: 'morph' put: (self
				parameterNamed: 'morph'
				type: 'string'
				description: 'Smalltalk expression answering the Morph to capture, e.g. "PSPresentationTool allInstances first". The morph is drawn by itself, so covered or off-screen morphs work too. Omit it to capture the whole display.');
			at: 'maxSize' put: (self
				parameterNamed: 'maxSize'
				type: 'integer'
				description: 'Longest side of the image in pixels (default ', self defaultMaxSize printString, '). Larger captures are scaled down, smaller ones are kept as they are.');
			yourself);
		at: 'required' put: #();
		yourself