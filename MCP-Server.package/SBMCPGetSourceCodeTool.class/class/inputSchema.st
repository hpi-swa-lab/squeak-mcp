accessing
inputSchema
	| properties |
	properties := Dictionary new
		at: 'class' put: (Dictionary new
			at: 'type' put: 'string';
			at: 'description' put: 'Class name (append " class" for class methods)';
			yourself);
		at: 'method' put: (Dictionary new
			at: 'type' put: 'string';
			at: 'description' put: 'Method selector';
			yourself);
		yourself.
	^ Dictionary new
		at: 'type' put: 'object';
		at: 'properties' put: properties;
		at: 'required' put: #('class' 'method');
		yourself