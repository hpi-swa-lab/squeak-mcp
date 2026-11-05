accessing
inputSchema
	^ Dictionary new
		at: 'type' put: 'object';
		at: 'properties' put: (Dictionary new
			at: 'kind' put: ((self
				parameterNamed: 'kind'
				type: 'string'
				description: 'senders, implementors (query: a selector), references (query: a class or global name), instVarReferences (query: an instance variable name, class: the class defining it; subclasses are included), source (query: text, case-insensitive), selectors (query: part of a selector), dependencies (query: a class category or prefix such as "Presenter-Core" or "Presenter"; answers which other categories its classes and extension methods need: method references, also in blocks, superclasses and extended classes; scope keeps only target categories starting with it)')
					at: 'enum' put: self kinds;
					yourself);
			at: 'query' put: (self
				parameterNamed: 'query'
				type: 'string'
				description: 'What to search for, see kind');
			at: 'class' put: (self
				parameterNamed: 'class'
				type: 'string'
				description: 'For instVarReferences: the class that defines the variable');
			at: 'scope' put: (self
				parameterNamed: 'scope'
				type: 'string'
				description: 'Optional: only methods of classes whose category starts with this (e.g. "Presenter"), and extension methods in matching *categories');
			at: 'limit' put: (self
				parameterNamed: 'limit'
				type: 'integer'
				description: 'Maximum number of results (default ', self defaultLimit printString, '); the total count is always answered');
			yourself);
		at: 'required' put: #('kind' 'query');
		yourself