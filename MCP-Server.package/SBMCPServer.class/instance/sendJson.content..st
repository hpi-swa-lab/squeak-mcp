responses
sendJson: request content: aDictionary
	"Send UTF-8 bytes; a WideString would go out as raw 32-bit characters with a wrong Content-Length."
	request send200Response: aDictionary asJsonString squeakToUtf8
		contentType: 'application/json; charset=utf-8'
		do: [:resp |
			resp headerAt: 'Access-Control-Allow-Origin' put: '*'.
			resp headerAt: 'Access-Control-Allow-Methods' put: 'POST, OPTIONS'.
			resp headerAt: 'Access-Control-Allow-Headers' put: 'Content-Type']