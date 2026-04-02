accessing
inputSchema
	| properties |
	properties := Dictionary new
		at: 'action' put: (Dictionary new
			at: 'type' put: 'string';
			at: 'description' put: 'Operation to perform: create, modify, rename, or delete';
			at: 'enum' put: #('create' 'modify' 'rename' 'delete');
			yourself);
		at: 'name' put: (Dictionary new
			at: 'type' put: 'string';
			at: 'description' put: 'Name of the class (for create/modify/delete) or new name (for 			rename)';
			yourself);
		at: 'oldName' put: (Dictionary new
			at: 'type' put: 'string';
			at: 'description' put: 'Old class name (required for rename)';
			yourself);
		at: 'comment' put: (Dictionary new
			at: 'type' put: 'string';
			at: 'description' put: 'Class comment (required for create, optional for modify)';
			yourself);
		at: 'superclass' put: (Dictionary new
			at: 'type' put: 'string';
			at: 'description' put: 'Name of the superclass (default: Object)';
			yourself);
		at: 'instanceVariableNames' put: (Dictionary new
			at: 'type' put: 'string';
			at: 'description' put: 'Space-separated instance variable names';
			yourself);
		at: 'classVariableNames' put: (Dictionary new
			at: 'type' put: 'string';
			at: 'description' put: 'Space-separated class variable names';
			yourself);
		at: 'poolDictionaries' put: (Dictionary new
			at: 'type' put: 'string';
			at: 'description' put: 'Space-separated pool dictionary names';
			yourself);
		at: 'category' put: (Dictionary new
			at: 'type' put: 'string';
			at: 'description' put: 'Class category (default: As yet unclassified)';
			yourself);
		yourself.
	^ Dictionary new
		at: 'type' put: 'object';
		at: 'properties' put: properties;
		at: 'required' put: #('action' 'name');
		yourself