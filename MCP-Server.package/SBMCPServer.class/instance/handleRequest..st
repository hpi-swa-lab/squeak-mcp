http-handling
handleRequest: request
	request method = 'OPTIONS' ifTrue: [^ self handleOptions: request].
	request method = 'POST' ifFalse: [^ self send405: request].
	(self validateAcceptHeader: request) ifFalse: [^ self send406: request].
	^ self handlePost: request