Class {
	#name : #SBMCPServer,
	#superclass : #Object,
	#instVars : [
		'server',
		'port',
		'sessionResults'
	],
	#category : #'MCP-Server'
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

{
	#category : #'as yet unclassified',
	#'squeak_changestamp' : 'tobe 8/14/2025 14:37'
}
SBMCPServer >> bindingOf: aSymbol [

	^ aSymbol -> (sessionResults at: aSymbol)
]

{
	#category : #'as yet unclassified',
	#'squeak_changestamp' : 'tobe 8/14/2025 13:44'
}
SBMCPServer >> createClass: aClassName superclass: aSuperclassName instanceVariableNames: anInstanceVarString classVariableNames: aClassVarString poolDictionaries: aPoolDictString category: aCategoryName oldName: anOldName [

	| superclass newClass oldClass |
	"Create a new class with the given parameters, or rename an existing class if oldName is provided"
	"Validate class name"
	aClassName ifEmpty: [
		^ Dictionary new
			at: 'error' put: 'Class name cannot be empty';
			yourself].
	"Handle class renaming"
	anOldName ifNotNil: [
		oldClass := Smalltalk classNamed: anOldName.
		oldClass ifNil: [
			^ Dictionary new
				at: 'error' put: 'Old class ', anOldName, ' not found';
				yourself].
		"Perform the rename"
		oldClass rename: aClassName.
		^ Dictionary new
			at: 'success' put: true;
			at: 'action' put: 'renamed';
			at: 'oldName' put: anOldName;
			at: 'newName' put: aClassName;
			yourself].
	"Get superclass"
	superclass := Smalltalk classNamed: aSuperclassName.
	superclass ifNil: [
		^ Dictionary new
			at: 'error' put: 'Superclass ', aSuperclassName, ' not found';
			yourself].
	"Create or redefine the class"
	newClass := superclass
		subclass: aClassName asSymbol
		instanceVariableNames: anInstanceVarString
		classVariableNames: aClassVarString
		poolDictionaries: aPoolDictString
		category: aCategoryName.
	^ Dictionary new
		at: 'success' put: true;
		at: 'action' put: 'created';
		at: 'class' put: aClassName;
		at: 'superclass' put: aSuperclassName;
		at: 'instanceVariableNames' put: anInstanceVarString;
		at: 'classVariableNames' put: aClassVarString;
		at: 'poolDictionaries' put: aPoolDictString;
		at: 'category' put: aCategoryName;
		yourself
]

{
	#category : #'as yet unclassified',
	#'squeak_changestamp' : 'tobe 8/14/2025 14:20'
}
SBMCPServer >> evaluateExpression: anExpression [

	| result randomName |
	"Evaluate a Smalltalk expression and return the result"
	"Validate expression"
	anExpression ifEmpty: [
		^ Dictionary new
			at: 'error' put: 'Expression cannot be empty';
			yourself].
	"Evaluate the expression"
	result := Compiler new
		evaluate: anExpression
		in: nil
		to: nil
		environment: Smalltalk globals
		notifying: self
		ifFail: [^ nil]
		logged: true.
	"Generate random name for this result"
	randomName := self generateRandomName.
	"Store result in session dictionary"
	sessionResults at: randomName put: result.
	^ Dictionary new
		at: 'success' put: true;
		at: 'expression' put: anExpression;
		at: 'result' put: result printString;
		at: 'class' put: result class name;
		at: 'variable' put: randomName;
		yourself
]

{
	#category : #'as yet unclassified',
	#'squeak_changestamp' : 'tobe 8/14/2025 14:43'
}
SBMCPServer >> evaluateImage: anExpression [
	"Evaluate a Smalltalk expression that returns a Form and return it as base64-encoded image"

	| evalResult result form base64Data |
	
	"Use the standard evaluate method"
	evalResult := self evaluateExpression: anExpression.
	
	"Check if evaluation was successful"
	(evalResult at: 'success' ifAbsent: [false]) ifFalse: [
		^ evalResult  "Return the error from evaluateExpression"
	].
	
	"Get the result from the session dictionary using the variable name"
	result := sessionResults at: (evalResult at: 'variable').
	
	"Validate that result is a Form"
	(result isKindOf: Form) ifFalse: [
		^ Dictionary new 
			at: 'error' put: 'Expression must evaluate to a Form object, got: ', result class name;
			yourself
	].
	
	form := result.
	
	"Convert Form to base64-encoded PNG"
	base64Data := self formToBase64PNG: form.
	
	"Return enhanced result with image data"
	^ evalResult copy
		at: 'image' put: base64Data;
		at: 'width' put: form width;
		at: 'height' put: form height;
		yourself
]

{
	#category : #'tools - find methods',
	#'squeak_changestamp' : 'tobe 8/14/2025 13:30'
}
SBMCPServer >> findMethodsWithSubstring: aString [
	"Find all methods containing the given substring in their source"

	| results methodReferences |
	results := OrderedCollection new.
	
	methodReferences := SystemNavigation default allMethodsWithSourceString: aString matchCase: false.
	
	methodReferences do: [:methodRef |
		| class selector category |
		class := methodRef actualClass.
		selector := methodRef selector.
		category := class organization categoryOfElement: selector.
		
		results add: (Dictionary new
			at: 'class' put: (class isMeta 
				ifTrue: [class instanceSide name, ' class']
				ifFalse: [class name]);
			at: 'method' put: selector;
			at: 'category' put: category;
			yourself)].
	
	^ results
]

{
	#category : #'as yet unclassified',
	#'squeak_changestamp' : 'tobe 8/14/2025 14:46'
}
SBMCPServer >> formToBase64PNG: aForm [

	| base64String pngstr |
	"Convert a Form to base64-encoded PNG data"
	"Convert Form to PNG bytes"
	pngstr := WriteStream on: #[].
	PNGReadWriter putForm: aForm onStream: pngstr.
	
	"Encode as base64"
	base64String := pngstr contents base64Encoded.
	
	"Return with data URL prefix"
	^ 'data:image/png;base64,', base64String
]

{
	#category : #'as yet unclassified',
	#'squeak_changestamp' : 'tobe 8/14/2025 14:29'
}
SBMCPServer >> generateRandomName [

	| chars name |
	"Generate a random variable name for storing evaluation results"
	chars := 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'.
	name := String streamContents: [:stream |
		stream nextPut: (chars at: (Random new nextInt: 52)).
		5 timesRepeat: [stream nextPut: (chars at: (Random new nextInt: 52))]].
	
	"Ensure uniqueness"
	[sessionResults includesKey: name] whileTrue: [name := name, (Random new nextInt: 99) printString].
	
	^ name
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

{
	#category : #'tools - source access',
	#'squeak_changestamp' : 'tobe 8/14/2025 14:42'
}
SBMCPServer >> getSourceForClass: aClassName method: aSelector [

	| class method |
	"Get source code for a specific method"
	class := Smalltalk at: aClassName asSymbol ifAbsent: [^ nil].
	
	(aClassName endsWith: ' class') ifTrue: [
		class := (Smalltalk
			at: (aClassName copyWithoutLast: 6) asSymbol
			ifAbsent: [^ nil]) class].
	
	method := class compiledMethodAt: aSelector asSymbol ifAbsent: [^ nil].
	
	^ Dictionary new
		at: 'class' put: aClassName;
		at: 'method' put: aSelector;
		at: 'source' put: method getSource string withUnixLineEndings;
		at: 'category' put: (class organization categoryOfElement: aSelector asSymbol);
		yourself
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

{ #category : #'http handling' }
SBMCPServer >> handleOptionsRequest: aRequest [
	"Handle CORS preflight OPTIONS requests"

	^ aRequest send200Response: '' contentType: 'text/plain' do: [:resp |
		resp headerAt: 'Access-Control-Allow-Origin' put: '*'.
		resp headerAt: 'Access-Control-Allow-Methods' put: 'POST, OPTIONS'.
		resp headerAt: 'Access-Control-Allow-Headers' put: 'Content-Type, Accept'.
		resp headerAt: 'Access-Control-Max-Age' put: '86400']
]

{
	#category : #'http handling',
	#'squeak_changestamp' : 'tobe 8/14/2025 14:29'
}
SBMCPServer >> handleRequest: aRequest [

	| jsonData method params acceptHeader |
	"Handle MCP protocol requests over HTTP"
	"Handle OPTIONS for CORS preflight"
	aRequest method = 'OPTIONS' ifTrue: [^ self handleOptionsRequest: aRequest].
	
	"Only accept POST for MCP messages"
	aRequest method = 'POST' ifFalse: [^ self send405MethodNotAllowed: aRequest].
	
	"Validate Accept header as per MCP specification"
	acceptHeader := aRequest headerAt: 'accept' ifAbsent: [''].
	(self validateAcceptHeader: acceptHeader) ifFalse: [^ self send406NotAcceptable: aRequest].
	
	[jsonData := Json readFrom: aRequest getContent readStream] on: Error do: [:ex |
		^ self
			mcpErrorResponse: aRequest
			message: 'Invalid JSON'
			id: nil].
	
	method := jsonData at: 'method' ifAbsent: [''].
	params := jsonData at: 'params' ifAbsent: [Dictionary new].
	
	"Handle MCP protocol methods"
	method = 'initialize' ifTrue: [^ self handleInitialize: aRequest id: (jsonData at: 'id' ifAbsent: [1])].
	
	method = 'tools/list' ifTrue: [^ self handleToolsList: aRequest id: (jsonData at: 'id' ifAbsent: [1])].
	
	method = 'tools/call' ifTrue: [^ self handleToolsCall: aRequest params: params id: (jsonData at: 'id' ifAbsent: [1])].
	
	^ self mcpErrorResponse: aRequest message: 'Unknown method: ', method id: (jsonData at: 'id' ifAbsent: [1])
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

{
	#category : #'mcp protocol',
	#'squeak_changestamp' : 'tobe 8/14/2025 14:48'
}
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
			at: 'name' put: 'create_class';
			at: 'description' put: 'Create a new class or rename an existing one';
			at: 'inputSchema' put: (Dictionary new
				at: 'type' put: 'object';
				at: 'properties' put: (Dictionary new
					at: 'name' put: (Dictionary new
						at: 'type' put: 'string';
						at: 'description' put: 'Name of the new class';
						yourself);
					at: 'superclass' put: (Dictionary new
						at: 'type' put: 'string';
						at: 'description' put: 'Name of the superclass (default: Object)';
						yourself);
					at: 'instanceVariableNames' put: (Dictionary new
						at: 'type' put: 'string';
						at: 'description' put: 'Space-separated instance variable names (default: empty)';
						yourself);
					at: 'classVariableNames' put: (Dictionary new
						at: 'type' put: 'string';
						at: 'description' put: 'Space-separated class variable names (default: empty)';
						yourself);
					at: 'poolDictionaries' put: (Dictionary new
						at: 'type' put: 'string';
						at: 'description' put: 'Space-separated pool dictionary names (default: empty)';
						yourself);
					at: 'category' put: (Dictionary new
						at: 'type' put: 'string';
						at: 'description' put: 'Class category (default: As yet unclassified)';
						yourself);
					at: 'oldName' put: (Dictionary new
						at: 'type' put: 'string';
						at: 'description' put: 'Old class name for renaming -- do not specify unless you want to actually rename (optional)';
						yourself);
					yourself);
				at: 'required' put: {'name'};
				yourself);
			yourself.
		Dictionary new
			at: 'name' put: 'evaluate';
			at: 'description' put: 'Evaluate a Smalltalk expression and return the result';
			at: 'inputSchema' put: (Dictionary new
				at: 'type' put: 'object';
				at: 'properties' put: (Dictionary new
					at: 'expression' put: (Dictionary new
						at: 'type' put: 'string';
						at: 'description' put: 'Smalltalk expression to evaluate';
						yourself);
					yourself);
				at: 'required' put: {'expression'};
				yourself);
			yourself.
		Dictionary new
			at: 'name' put: 'evaluate_image';
			at: 'description' put: 'Evaluate a Smalltalk expression that returns a Form and return it as base64-encoded image';
			at: 'inputSchema' put: (Dictionary new
				at: 'type' put: 'object';
				at: 'properties' put: (Dictionary new
					at: 'expression' put: (Dictionary new
						at: 'type' put: 'string';
						at: 'description' put: 'Smalltalk expression that must evaluate to a Form object';
						yourself);
					yourself);
				at: 'required' put: {'expression'};
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

{
	#category : #'initialize-release',
	#'squeak_changestamp' : 'tobe 8/14/2025 13:59'
}
SBMCPServer >> initialize [

	super initialize.
	port := self class defaultPort.
	sessionResults := Dictionary new
]

{
	#category : #private,
	#'squeak_changestamp' : 'tobe 8/14/2025 14:31'
}
SBMCPServer >> mcpErrorResponse: aRequest message: aMessage id: anId [

	| errorDict jsonString |
	"Send an MCP error response using WebRequest"
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

{
	#category : #private,
	#'squeak_changestamp' : 'tobe 8/14/2025 14:42'
}
SBMCPServer >> performTool: aToolName with: aParams [
	"Route tool calls to appropriate methods"

	[aToolName = 'find_methods_with_substring' ifTrue: [
		^ self findMethodsWithSubstring: (aParams at: 'substring' ifAbsent: [''])].

	aToolName = 'get_source_code' ifTrue: [
		^ self getSourceForClass: (aParams at: 'class' ifAbsent: ['']) method: (aParams at: 'method' ifAbsent: [''])].

	aToolName = 'set_source_code' ifTrue: [
		^ self setSourceForClass: (aParams at: 'class' ifAbsent: ['']) method: (aParams at: 'method' ifAbsent: ['']) source: (aParams at: 'source' ifAbsent: [''])].

	aToolName = 'create_class' ifTrue: [
		^ self createClass: (aParams at: 'name' ifAbsent: ['']) 
			superclass: (aParams at: 'superclass' ifAbsent: ['Object']) 
			instanceVariableNames: (aParams at: 'instanceVariableNames' ifAbsent: [''])
			classVariableNames: (aParams at: 'classVariableNames' ifAbsent: [''])
			poolDictionaries: (aParams at: 'poolDictionaries' ifAbsent: [''])
			category: (aParams at: 'category' ifAbsent: ['As yet unclassified'])
			oldName: (aParams at: 'oldName' ifAbsent: [nil])].

	aToolName = 'evaluate' ifTrue: [
		^ self evaluateExpression: (aParams at: 'expression' ifAbsent: [''])].

	aToolName = 'evaluate_image' ifTrue: [
		^ self evaluateImage: (aParams at: 'expression' ifAbsent: [''])].

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

{
	#category : #'as yet unclassified',
	#'squeak_changestamp' : 'tobe 8/14/2025 14:02'
}
SBMCPServer >> replaceVariablesInExpression: anExpression [
	"Replace unbound variables in the expression with values from sessionResults"
	
	| modifiedExpression |
	modifiedExpression := anExpression.
	
	sessionResults keysDo: [:varName |
		| value replacement |
		value := sessionResults at: varName.
		replacement := value storeString.
		modifiedExpression := modifiedExpression copyReplaceAll: varName with: replacement
	].
	
	^ modifiedExpression
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

{
	#category : #'tools - source modification',
	#'squeak_changestamp' : 'tobe 8/14/2025 14:00'
}
SBMCPServer >> setSourceForClass: aClassName method: aSelector source: aSourceString [
	"Write source code for a specific method"

	| class |
	class := Smalltalk at: aClassName asSymbol ifAbsent: [^ false].
	
	(aClassName endsWith: ' class') ifTrue: [
		class := (Smalltalk at: (aClassName copyWithoutLast: 6) asSymbol ifAbsent: [^ false]) class].
	
	[class compile: aSourceString withSqueakLineEndings classified: 'as yet unclassified']
		on: Error
		do: [:ex | ^ false].
	
	^ true
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

{ #category : #'http handling' }
SBMCPServer >> validateAcceptHeader: aHeaderValue [
	"Validate that Accept header includes both required content types"

	| acceptHeader |
	acceptHeader := aHeaderValue asLowercase.
	
	^ (acceptHeader includesSubstring: 'application/json') and: [
		acceptHeader includesSubstring: 'text/event-stream']
]

{
	#category : #'as yet unclassified',
	#'squeak_changestamp' : 'tobe 8/14/2025 14:23'
}
SBMCPServer >> wantsInteractiveErrorCorrection [

	^ false
]
