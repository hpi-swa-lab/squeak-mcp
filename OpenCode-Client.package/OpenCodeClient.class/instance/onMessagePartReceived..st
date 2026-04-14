callbacks
onMessagePartReceived: aBlock
	"Set the callback for streaming message parts.
	Block receives a Dictionary with keys: #type, #content, #delta"
	onMessagePartReceived := aBlock