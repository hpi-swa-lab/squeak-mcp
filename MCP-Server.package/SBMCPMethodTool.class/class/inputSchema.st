accessing
inputSchema
	| properties |
	properties := Dictionary new
		at: 'action' put: (Dictionary new
			at: 'type' put: 'string';
			at: 'description' put: 'Operation to perform: add, modify, or delete';
			at: 'enum' put: #('add' 'modify' 'delete');
			yourself);
		at: 'class' put: (Dictionary new
			at: 'type' put: 'string';
			at: 'description' put: 'Class name (append " class" for class methods)';
			yourself);
		at: 'method' put: (Dictionary new
			at: 'type' put: 'string';
			at: 'description' put: 'Method selector';
			yourself);
		at: 'source' put: (Dictionary new
			at: 'type' put: 'string';
			at: 'description' put: 'Complete method source code (required for add)';	
			yourself);
		at: 'old_string' put: (Dictionary new
			at: 'type' put: 'string';
			at: 'description' put: 'String to find and replace (required for modify)';
			yourself);
		at: 'new_string' put: (Dictionary new
			at: 'type' put: 'string';
			at: 'description' put: 'Replacement string (required for modify)';
			yourself);
		at: 'replace_all' put: (Dictionary new
			at: 'type' put: 'boolean';
			at: 'description' put: 'Replace all occurrences (default: false, errors if multiple matches)';
			yourself);
		at: 'category' put: (Dictionary new
			at: 'type' put: 'string';
			at: 'description' put: 'Method category (default: as yet unclassified)';
			yourself);
		yourself.

	^ Dictionary new
		at: 'type' put: 'object';
		at: 'properties' put: properties;
		at: 'required' put: #('action' 'class' 'method');
		yourself