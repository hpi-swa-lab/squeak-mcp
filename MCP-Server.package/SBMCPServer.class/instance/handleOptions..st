http-handling
handleOptions: request
	^ request
		send200Response: ''
		contentType: 'text/plain'
		do: [:resp |
			resp headerAt: 'Access-Control-Allow-Origin' put: '*'.
			resp headerAt: 'Access-Control-Allow-Methods' put: 'POST, OPTIONS'.
			resp headerAt: 'Access-Control-Allow-Headers' put: 'Content-Type, Accept'.
			resp headerAt: 'Access-Control-Max-Age' put: '86400']