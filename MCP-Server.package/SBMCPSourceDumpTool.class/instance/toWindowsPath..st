private
toWindowsPath: unixPath
	"Convert /mnt/c/foo to C:\foo"
	| path |
	path := unixPath.
	(path beginsWith: '/mnt/') ifTrue: [
		path := (path copyFrom: 6 to: 6) asUppercase, ':', (path copyFrom: 7 to: path size)].
	^ path copyReplaceAll: '/' with: '\'