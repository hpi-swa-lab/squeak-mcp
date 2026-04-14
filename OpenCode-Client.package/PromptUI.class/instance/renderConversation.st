display
renderConversation
	| text |
	text := Text new.
	conversation do: [:msg |
		text append: msg asFormattedText.
		text append: String cr asText.
	].
	^ text