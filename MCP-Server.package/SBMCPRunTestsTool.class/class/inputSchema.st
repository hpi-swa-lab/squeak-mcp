accessing
inputSchema
	^ Dictionary new
		at: 'type' put: 'object';
		at: 'properties' put: (Dictionary new
			at: 'tests' put: (self
				parameterNamed: 'tests'
				type: 'string'
				description: 'What to run, separated by spaces or commas: test classes (e.g. "PSTableTest"), single tests ("PSTableTest>>testMerge") or class categories, which include their subcategories ("Presenter-Tests").');
			at: 'timeout' put: (self
				parameterNamed: 'timeout'
				type: 'integer'
				description: 'Time limit for the whole run in seconds (default ', self defaultTimeout printString, '). Single tests also have SUnit''s own timeout.');
			yourself);
		at: 'required' put: #('tests');
		yourself