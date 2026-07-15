logging
logError: aString
	self log: (Dictionary newFrom: {#type -> #error. #details -> aString})