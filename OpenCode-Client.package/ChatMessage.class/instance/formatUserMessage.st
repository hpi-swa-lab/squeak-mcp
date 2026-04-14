formatting
formatUserMessage
	| text |
	text := ('You: ', content) asText.
	text addAttribute: (TextColor color: Color blue).
	text addAttribute: TextEmphasis bold from: 1 to: 4.
	^ text