instance creation
open
	| window |
	window := self current buildWith: ToolBuilder default.
	window openInWorld.
	^ window