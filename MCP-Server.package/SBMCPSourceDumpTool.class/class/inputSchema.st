accessing
inputSchema
	| properties |
	properties := Dictionary new
		at: 'path' put: (Dictionary new
			at: 'type' put: 'string';
			at: 'description' put: 'Directory path where source files will be written';
			yourself);
		yourself.
	^ Dictionary new
		at: 'type' put: 'object';
		at: 'properties' put: properties;
		at: 'required' put: #('path');
		yourself