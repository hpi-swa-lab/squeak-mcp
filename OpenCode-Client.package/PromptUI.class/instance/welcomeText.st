initialization
welcomeText
	^ 'Welcome! Type a message below and press Enter or click Submit.' asText
		addAttribute: (TextColor color: Color gray);
		yourself