instance creation
pendingAssistant
	^ self new
		role: #assistant;
		content: '';
		status: #thinking;
		yourself