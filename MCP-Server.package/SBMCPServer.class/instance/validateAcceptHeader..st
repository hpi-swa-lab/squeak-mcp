http-handling
validateAcceptHeader: request
	| accept |
	accept := request headerAt: 'Accept' ifAbsent: ['*/*'].
	^ (accept includesSubstring: 'application/json') or: [accept includesSubstring: '*/*']