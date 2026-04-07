accessing
inputSchema
	| properties |
	properties := Dictionary new
		at: 'category' put: (Dictionary new
			at: 'type' put: 'string';
			at: 'description' put: 'Category name or prefix to filter classes';
			yourself);
		yourself.
	^ Dictionary new
		at: 'type' put: 'object';
		at: 'properties' put: properties;
		at: 'required' put: #('category');
		yourself