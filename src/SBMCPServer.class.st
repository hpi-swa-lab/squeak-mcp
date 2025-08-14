Class {
	#name : #SBMCPServer,
	#superclass : #Object,
	#instVars : [
		'server',
		'port'
	],
	#category : #'Sandblocks-MCP'
}

{ #category : #'class initialization' }
SBMCPServer class >> defaultPort [

	^ 8080
]

{ #category : #'instance creation' }
SBMCPServer class >> new [

	^ super new initialize
]

{ #category : #'instance creation' }
SBMCPServer class >> startOnPort: aPort [

	^ self new
		port: aPort;
		start;
		yourself
]

{ #category : #'tools - find methods' }
SBMCPServer >> findMethodsWithSubstring: aString [
	"Find all methods containing the given substring in their source"

	| results |
	results := OrderedCollection new.
	
	ProtoObject withAllSubclassesDo: [:class |
		class methodDict keysAndValuesDo: [:selector :method |
			(method getSource string includesSubstring: aString caseSensitive: false) ifTrue: [
				results add: (Dictionary new
					at: 'class' put: class name;
					at: 'method' put: selector;
					at: 'category' put: (class organization categoryOfElement: selector);
					yourself)]].
		class class methodDict keysAndValuesDo: [:selector :method |
			(method getSource string includesSubstring: aString caseSensitive: false) ifTrue: [
				results add: (Dictionary new
					at: 'class' put: class name, ' class';
					at: 'method' put: selector;
					at: 'category' put: (class class organization categoryOfElement: selector);
					yourself)]]].
	
	^ results
]

{ #category : #'tools - source access' }
SBMCPServer >> getSourceForClass: aClassName method: aSelector [
	"Get source code for a specific method"

	| class method |
	class := Smalltalk at: aClassName asSymbol ifAbsent: [^ nil].
	
	(aClassName endsWith: ' class') ifTrue: [
		class := (Smalltalk at: (aClassName copyWithoutLast: 6) asSymbol ifAbsent: [^ nil]) class].
	
	method := class compiledMethodAt: aSelector asSymbol ifAbsent: [^ nil].
	
	^ Dictionary new
		at: 'class' put: aClassName;
		at: 'method' put: aSelector;
		at: 'source' put: method getSource;
		at: 'category' put: (class organization categoryOfElement: aSelector asSymbol);
		yourself
]

{ #category : #'tools - source modification' }
SBMCPServer >> setSourceForClass: aClassName method: aSelector source: aSourceString [
	"Write source code for a specific method"

	| class |
	class := Smalltalk at: aClassName asSymbol ifAbsent: [^ false].
	
	(aClassName endsWith: ' class') ifTrue: [
		class := (Smalltalk at: (aClassName copyWithoutLast: 6) asSymbol ifAbsent: [^ false]) class].
	
	[class compile: aSourceString classified: 'as yet unclassified']
		on: Error
		do: [:ex | ^ false].
	
	^ true
]

{ #category : #'tools - class inspection' }
SBMCPServer >> getMethodsForClass: aClassName [
	"Get all methods for a class"

	| class methods |
	class := Smalltalk at: aClassName asSymbol ifAbsent: [^ #()].
	
	(aClassName endsWith: ' class') ifTrue: [
		class := (Smalltalk at: (aClassName copyWithoutLast: 6) asSymbol ifAbsent: [^ #()]) class].
	
	methods := OrderedCollection new.
	
	class methodDict keysAndValuesDo: [:selector :method |
		methods add: (Dictionary new
			at: 'selector' put: selector;
			at: 'category' put: (class organization categoryOfElement: selector);
			yourself)].
	
	^ methods
]

{ #category : #'tools - system inspection' }
SBMCPServer >> getAllClasses [
	"Get all classes in the system"

	| classes |
	classes := OrderedCollection new.
	
	ProtoObject withAllSubclassesDo: [:class |
		classes add: (Dictionary new
			at: 'name' put: class name;
			at: 'category' put: class category;
			at: 'superclass' put: (class superclass ifNotNil: [:sc | sc name] ifNil: ['nil']);
			yourself)].
	
	^ classes
]

{ #category : #'tools - system inspection' }
SBMCPServer >> getAllCategories [
	"Get all class categories in the system"

	| categories |
	categories := Set new.
	
	ProtoObject withAllSubclassesDo: [:class |
		class category ifNotNil: [:cat | categories add: cat]].
	
	^ categories asOrderedCollection sort
]

{ #category : #'http handling' }
SBMCPServer >> handleRequest: aRequest [
	"Handle MCP protocol requests over HTTP"

	| jsonData method params result acceptHeader |
	
	"Handle OPTIONS for CORS preflight"
	aRequest method = 'OPTIONS' ifTrue: [
		^ self handleOptionsRequest: aRequest].
	
	"Only accept POST for MCP messages"
	aRequest method = 'POST' ifFalse: [
		^ self send405MethodNotAllowed: aRequest].
	
	"Validate Accept header as per MCP specification"
	acceptHeader := aRequest headerAt: 'accept' ifAbsent: [''].
	(self validateAcceptHeader: acceptHeader) ifFalse: [
		^ self send406NotAcceptable: aRequest].
	
	[jsonData := Json readFrom: aRequest getContent readStream]
		on: Error
		do: [:ex | ^ self mcpErrorResponse: aRequest message: 'Invalid JSON' id: nil].
	
	method := jsonData at: 'method' ifAbsent: [''].
	params := jsonData at: 'params' ifAbsent: [Dictionary new].
	
	"Handle MCP protocol methods"
	method = 'initialize' ifTrue: [
		^ self handleInitialize: aRequest id: (jsonData at: 'id' ifAbsent: [1])].
	
	method = 'tools/list' ifTrue: [
		^ self handleToolsList: aRequest id: (jsonData at: 'id' ifAbsent: [1])].
	
	method = 'tools/call' ifTrue: [
		^ self handleToolsCall: aRequest params: params id: (jsonData at: 'id' ifAbsent: [1])].
	
	^ self mcpErrorResponse: aRequest message: ('Unknown method: ', method) id: (jsonData at: 'id' ifAbsent: [1])
]

{ #category : #'http handling' }
SBMCPServer >> handleOptionsRequest: aRequest [
	"Handle CORS preflight OPTIONS requests"

	^ aRequest send200Response: '' contentType: 'text/plain' do: [:resp |
		resp headerAt: 'Access-Control-Allow-Origin' put: '*'.
		resp headerAt: 'Access-Control-Allow-Methods' put: 'POST, OPTIONS'.
		resp headerAt: 'Access-Control-Allow-Headers' put: 'Content-Type, Accept'.
		resp headerAt: 'Access-Control-Max-Age' put: '86400']
]

{ #category : #'initialize-release' }
SBMCPServer >> initialize [

	super initialize.
	port := self class defaultPort
]

{ #category : #'http handling' }
SBMCPServer >> send405MethodNotAllowed: aRequest [
	"Send 405 Method Not Allowed response"

	^ aRequest sendErrorResponse: 405 content: 'Method Not Allowed' contentType: 'text/plain' do: [:resp |
		resp headerAt: 'Allow' put: 'POST, OPTIONS'.
		resp headerAt: 'Access-Control-Allow-Origin' put: '*']
]

{ #category : #'http handling' }
SBMCPServer >> send406NotAcceptable: aRequest [
	"Send 406 Not Acceptable response"

	^ aRequest sendErrorResponse: 406 content: 'Not Acceptable - Accept header must include both application/json and text/event-stream' contentType: 'text/plain' do: [:resp |
		resp headerAt: 'Access-Control-Allow-Origin' put: '*']
]

{ #category : #'http handling' }
SBMCPServer >> validateAcceptHeader: aHeaderValue [
	"Validate that Accept header includes both required content types"

	| acceptHeader |
	acceptHeader := aHeaderValue asLowercase.
	
	^ (acceptHeader includesSubstring: 'application/json') and: [
		acceptHeader includesSubstring: 'text/event-stream']
]

{ #category : #'mcp protocol' }
SBMCPServer >> handleInitialize: aRequest id: anId [
	"Handle MCP initialize request"

	| response jsonString |
	response := Dictionary new
		at: 'jsonrpc' put: '2.0';
		at: 'id' put: anId;
		at: 'result' put: (Dictionary new
			at: 'protocolVersion' put: '2024-11-05';
			at: 'capabilities' put: (Dictionary new
				at: 'tools' put: Dictionary new;
				yourself);
			at: 'serverInfo' put: (Dictionary new
				at: 'name' put: 'Squeak MCP Server';
				at: 'version' put: '1.0.0';
				yourself);
			yourself);
		yourself.
	
	jsonString := response asJsonString.
	
	^ aRequest send200Response: jsonString contentType: 'application/json' do: [:resp |
		resp headerAt: 'Access-Control-Allow-Origin' put: '*'.
		resp headerAt: 'Access-Control-Allow-Methods' put: 'POST, OPTIONS'.
		resp headerAt: 'Access-Control-Allow-Headers' put: 'Content-Type']
]

{ #category : #'mcp protocol' }
SBMCPServer >> handleToolsCall: aRequest params: aParams id: anId [
	"Handle MCP tools/call request"

	| toolName arguments result response jsonString |
	toolName := aParams at: 'name' ifAbsent: [''].
	arguments := aParams at: 'arguments' ifAbsent: [Dictionary new].
	
	result := self performTool: toolName with: arguments.
	
	response := Dictionary new
		at: 'jsonrpc' put: '2.0';
		at: 'id' put: anId;
		at: 'result' put: (Dictionary new
			at: 'content' put: {Dictionary new
				at: 'type' put: 'text';
				at: 'text' put: (result asJsonString);
				yourself};
			yourself);
		yourself.
	
	jsonString := response asJsonString.
	
	^ aRequest send200Response: jsonString contentType: 'application/json' do: [:resp |
		resp headerAt: 'Access-Control-Allow-Origin' put: '*'.
		resp headerAt: 'Access-Control-Allow-Methods' put: 'POST, OPTIONS'.
		resp headerAt: 'Access-Control-Allow-Headers' put: 'Content-Type']
]

{ #category : #'mcp protocol' }
SBMCPServer >> handleToolsList: aRequest id: anId [
	"Handle MCP tools/list request"

	| tools response jsonString |
	tools := {
		Dictionary new
			at: 'name' put: 'find_methods_with_substring';
			at: 'description' put: 'Find all methods containing a substring in their source code';
			at: 'inputSchema' put: (Dictionary new
				at: 'type' put: 'object';
				at: 'properties' put: (Dictionary new
					at: 'substring' put: (Dictionary new
						at: 'type' put: 'string';
						at: 'description' put: 'Substring to search for in method source';
						yourself);
					yourself);
				at: 'required' put: {'substring'};
				yourself);
			yourself.
		Dictionary new
			at: 'name' put: 'get_source_code';
			at: 'description' put: 'Get source code for a specific method';
			at: 'inputSchema' put: (Dictionary new
				at: 'type' put: 'object';
				at: 'properties' put: (Dictionary new
					at: 'class' put: (Dictionary new
						at: 'type' put: 'string';
						at: 'description' put: 'Class name (append " class" for class methods)';
						yourself);
					at: 'method' put: (Dictionary new
						at: 'type' put: 'string';
						at: 'description' put: 'Method selector';
						yourself);
					yourself);
				at: 'required' put: {'class'. 'method'};
				yourself);
			yourself.
		Dictionary new
			at: 'name' put: 'set_source_code';
			at: 'description' put: 'Write source code for a method (full method replacement)';
			at: 'inputSchema' put: (Dictionary new
				at: 'type' put: 'object';
				at: 'properties' put: (Dictionary new
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
						at: 'description' put: 'Complete method source code';
						yourself);
					yourself);
				at: 'required' put: {'class'. 'method'. 'source'};
				yourself);
			yourself.
		Dictionary new
			at: 'name' put: 'list_methods';
			at: 'description' put: 'List all methods of a class';
			at: 'inputSchema' put: (Dictionary new
				at: 'type' put: 'object';
				at: 'properties' put: (Dictionary new
					at: 'class' put: (Dictionary new
						at: 'type' put: 'string';
						at: 'description' put: 'Class name (append " class" for class methods)';
						yourself);
					yourself);
				at: 'required' put: {'class'};
				yourself);
			yourself.
		Dictionary new
			at: 'name' put: 'list_classes';
			at: 'description' put: 'List all classes in the system';
			at: 'inputSchema' put: (Dictionary new
				at: 'type' put: 'object';
				at: 'properties' put: Dictionary new;
				yourself);
			yourself.
		Dictionary new
			at: 'name' put: 'list_categories';
			at: 'description' put: 'List all class categories in the system';
			at: 'inputSchema' put: (Dictionary new
				at: 'type' put: 'object';
				at: 'properties' put: Dictionary new;
				yourself);
			yourself
	}.
	
	response := Dictionary new
		at: 'jsonrpc' put: '2.0';
		at: 'id' put: anId;
		at: 'result' put: (Dictionary new
			at: 'tools' put: tools;
			yourself);
		yourself.
	
	jsonString := response asJsonString.
	
	^ aRequest send200Response: jsonString contentType: 'application/json' do: [:resp |
		resp headerAt: 'Access-Control-Allow-Origin' put: '*'.
		resp headerAt: 'Access-Control-Allow-Methods' put: 'POST, OPTIONS'.
		resp headerAt: 'Access-Control-Allow-Headers' put: 'Content-Type']
]


{ #category : #'private' }
SBMCPServer >> mcpErrorResponse: aRequest message: aMessage id: anId [
	"Send an MCP error response using WebRequest"

	| errorDict jsonString |
	errorDict := Dictionary new
		at: 'jsonrpc' put: '2.0';
		at: 'id' put: anId;
		at: 'error' put: (Dictionary new
			at: 'code' put: -32600;
			at: 'message' put: aMessage;
			yourself);
		yourself.
	
	jsonString := errorDict asJsonString.
	
	^ aRequest send200Response: jsonString contentType: 'application/json' do: [:response |
		response headerAt: 'Access-Control-Allow-Origin' put: '*'.
		response headerAt: 'Access-Control-Allow-Methods' put: 'POST, OPTIONS'.
		response headerAt: 'Access-Control-Allow-Headers' put: 'Content-Type']
]

{ #category : #'private' }
SBMCPServer >> performTool: aToolName with: aParams [
	"Route tool calls to appropriate methods"

	[aToolName = 'find_methods_with_substring' ifTrue: [
		^ self findMethodsWithSubstring: (aParams at: 'substring' ifAbsent: [''])].
	
	aToolName = 'get_source_code' ifTrue: [
		^ self getSourceForClass: (aParams at: 'class' ifAbsent: ['']) method: (aParams at: 'method' ifAbsent: [''])].
	
	aToolName = 'set_source_code' ifTrue: [
		^ self setSourceForClass: (aParams at: 'class' ifAbsent: ['']) method: (aParams at: 'method' ifAbsent: ['']) source: (aParams at: 'source' ifAbsent: [''])].
	
	aToolName = 'list_methods' ifTrue: [
		^ self getMethodsForClass: (aParams at: 'class' ifAbsent: [''])].
	
	aToolName = 'list_classes' ifTrue: [
		^ self getAllClasses].
	
	aToolName = 'list_categories' ifTrue: [
		^ self getAllCategories].
	
	^ Dictionary new at: 'error' put: ('Unknown tool: ', aToolName); yourself]
		on: Error
		do: [:ex | ^ Dictionary new at: 'error' put: ex messageText; yourself]
]

{ #category : #accessing }
SBMCPServer >> port [

	^ port
]

{ #category : #accessing }
SBMCPServer >> port: anInteger [

	port := anInteger
]

{ #category : #'server control' }
SBMCPServer >> start [
	"Start the MCP server"

	server := WebServer new.
	server listenOn: port.
	server addService: '/mcp' action: [:request | self handleRequest: request].
	server startListener.
	
	^ self
]

{ #category : #'server control' }
SBMCPServer >> stop [
	"Stop the MCP server"

	server ifNotNil: [
		server destroy.
		server := nil]
]
