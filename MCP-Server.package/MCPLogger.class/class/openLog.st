ui
openLog
	"Read the current log file and show it in a Workspace window, scrolled to
	the bottom so the newest lines are visible. Guarded so a missing file or
	UI failure can never break the caller (e.g. the XR world menu)."
	| fileName contents ws window |
	fileName := self default logFileName.
	contents := [(FileStream fileNamed: fileName) contentsOfEntireFile]
		on: Error
		do: [:ex | 'Could not read log file ', fileName printString, ': ', ex messageText].
	ws := Workspace new.
	ws contents: contents.
	window := ws openLabel: 'MCP Log - ', fileName.
	"Scroll the text pane to the end so the newest log lines are visible."
	[| textMorph end |
	textMorph := window allMorphs
		detect: [:m | m isKindOf: PluggableTextMorph]
		ifNone: [nil].
	textMorph ifNotNil: [
		end := contents size + 1.
		textMorph selectInterval: (end to: end).
		textMorph scrollSelectionIntoView]]
		on: Error
		do: [:ex | "ignore scroll failures"].
	^ window