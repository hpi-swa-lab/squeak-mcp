private
httpPost: aPath json: aDictionary
	"POST JSON to server, return dictionary with #code and #content."
	| client url body response result |
	url := serverUrl, aPath.
	body := STONJSON toString: aDictionary.
	client := WebClient new timeout: 300.
	[
		response := client httpPost: url content: body type: 'application/json'.
		result := Dictionary new
		at: #code put: response code;
		at: #content put: response content;
		yourself.
	] ensure: [client close].
	^ result