responses
send406: request
	 request
		sendResponseCode: 406
		content: 'Not Acceptable'
		type: 'text/plain'
		do: [:resp | ]