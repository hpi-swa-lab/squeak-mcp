results
needlesFor: kind query: query
	"What a found method's source line should contain, best first. For senders of a keyword selector: all its keywords, else the first one, as they may be on different lines."
	| keywords |
	(kind = 'senders' and: [query includes: $:]) ifFalse: [^ {{query}}].
	keywords := query keywords.
	^ {keywords. {keywords first}}