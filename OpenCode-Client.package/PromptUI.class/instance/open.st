ui
open
	| window |
	builder := ToolBuilder default.
	window := builder open: self.

	"Enable submit on Enter key"
	(builder widgetAt: #inputArea) ifNotNil: [:w | w acceptOnCR: true].

	^ window