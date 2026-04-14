private
listenForEvents
	"Connect and process SSE events."
	| response stream |
	response := self httpGetStream: '/event'.
	stream := response stream.

	[stream isConnected and: [stream atEnd not]] whileTrue: [
		self processEventLine: stream nextLine.
	].