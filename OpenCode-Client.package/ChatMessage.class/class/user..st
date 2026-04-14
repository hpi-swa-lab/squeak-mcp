instance creation
user: aString
	^ self new
		role: #user;
		content: aString;
		status: #done;
		yourself