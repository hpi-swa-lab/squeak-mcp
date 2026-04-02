responses
sendJson: request content: aDictionary
	request send200Response: aDictionary asJsonString
		contentType: 'application/json'
		do: [:resp |
			resp headerAt: 'Access-Control-Allow-Origin' put: '*'.
			resp headerAt: 'Access-Control-Allow-Methods' put: 'POST, OPTIONS'.
			resp headerAt: 'Access-Control-Allow-Headers' put: 'Content-Type']