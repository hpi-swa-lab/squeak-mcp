formatting
formatAssistantMessage
	| prefix text color |
	prefix := 'AI: '.

	self isThinking ifTrue: [
		text := (prefix, '(thinking...)') asText.
		color := Color gray.
	] ifFalse: [
		text := (prefix, content) asText.
		color := Color r: 0.1 g: 0.5 b: 0.1.
	].

	text addAttribute: (TextColor color: color).
	text addAttribute: TextEmphasis bold from: 1 to: prefix size.
	^ text