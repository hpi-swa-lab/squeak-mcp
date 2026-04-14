private
httpGetStream: aPath
	"GET with streaming response, return response (caller should handle cleanup)."
	| client response |
	client := WebClient new timeout: 300.
	response := client httpGet: (serverUrl, aPath) do: [:req |
		req headerAt: 'Accept' put: 'text/event-stream'].
	^ response