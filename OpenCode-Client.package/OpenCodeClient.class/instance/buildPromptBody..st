private
buildPromptBody: aString
	| promptText activities |
	promptText := aString.
	activities := SystemActivityLogger current consumeActivitiesForPrompt.
	activities ifNotEmpty: [
		promptText := promptText, String cr, String cr, activities].
	
	^ {
		'agent' -> 'general'.
		'parts' -> {
			{'type' -> 'text'. 'text' -> promptText} asDictionary
		}
	} asDictionary