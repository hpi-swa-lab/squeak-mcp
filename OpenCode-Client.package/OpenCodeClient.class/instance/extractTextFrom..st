private
extractTextFrom: aResponseDict
	"Extract text content from response parts."
	| parts textPart |
	parts := aResponseDict at: 'parts' ifAbsent: [#()].
	textPart := parts
		detect: [:p | (p at: 'type' ifAbsent: ['']) = 'text']
		ifNone: [^ ''].
	^ textPart at: 'text' ifAbsent: ['']