private
writeContent: content toFile: filePath
	| fileStream |
	fileStream := FileStream newFileNamed: filePath.
	[fileStream nextPutAll: content]
		ensure: [fileStream close]