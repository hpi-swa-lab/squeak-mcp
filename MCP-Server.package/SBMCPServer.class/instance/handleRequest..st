http-handling
handleRequest: request
	MCPLogger default log: '>>> request ', request method printString.
	request method = 'OPTIONS' ifTrue: [^ self handleOptions: request].
	request method = 'POST' ifFalse: [^ self send405: request].
	(self validateAcceptHeader: request) ifFalse: [^ self send406: request].
	^ self handlePost: request