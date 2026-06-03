accessing
current
	"The single shared MCP server. Reuses an existing instance if one is
	around (preferring a running one) so we never end up with two servers
	fighting over the same port. Stops and discards any stray duplicates."
	| instances chosen |
	(Current notNil and: [Current isRunning]) ifTrue: [^ Current].
	instances := self allInstances.
	chosen := instances
		detect: [:each | each isRunning]
		ifNone: [instances isEmpty ifTrue: [self new] ifFalse: [instances anyOne]].
	"Stop any other strays so only `chosen` can own the port."
	instances do: [:each | each == chosen ifFalse: [
		[each stop] on: Error do: [:ex | nil]]].
	Current := chosen.
	^ Current