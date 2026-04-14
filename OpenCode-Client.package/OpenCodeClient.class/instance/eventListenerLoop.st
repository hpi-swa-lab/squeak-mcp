private
eventListenerLoop
	"Main event listener loop with auto-reconnect."
	[true] whileTrue: [
		[self listenForEvents]
			on: Error
			do: [:ex | Transcript show: 'Event stream error: ', ex description; cr].
		(Delay forSeconds: 3) wait.
	].