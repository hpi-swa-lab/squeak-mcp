server-control
toggle
	"Start the shared MCP server if stopped, stop it if running.
	Guarded so a failure can never break the caller (e.g. the XR render loop).
	Returns the resulting running state (a Boolean)."
	| srv |
	srv := self current.
	^ [srv isRunning
		ifTrue: [srv stop. false]
		ifFalse: [srv start. true]]
		on: Error
		do: [:ex |
			(Smalltalk at: #MCPLogger ifAbsent: [nil])
				ifNotNil: [:logger | logger default log: 'MCP toggle failed: ', ex messageText].
			srv isRunning]