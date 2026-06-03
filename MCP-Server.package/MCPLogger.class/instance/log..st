logging
log: aString
	"Append a timestamped line to the log file. Opens/closes per call so output
	is always flushed even if the VM hangs afterwards. Swallows file errors so
	logging can NEVER break the MCP server."

	[| stream |
	stream := FileStream fileNamed: self logFileName.
	stream setToEnd.
	stream nextPutAll: DateAndTime now printString;
		nextPutAll: ' ';
		nextPutAll: aString;
		nextPut: Character lf.
	stream close]
		on: Error
		do: [:ex | "ignore logging errors"]