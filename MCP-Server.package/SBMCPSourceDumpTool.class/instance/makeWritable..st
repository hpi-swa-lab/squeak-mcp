private
makeWritable: path
	"Make directory and its contents writable - cross-platform"
	| proc1 proc2 |
	self isWSL ifTrue: [
		proc1 := (Smalltalk at: #OSProcess) command:
			'attrib.exe -R /S /D "', (self toWindowsPath: path), '\*.*"'.
		proc2 := (Smalltalk at: #OSProcess) command:
			'chmod -R u+w "', path, '"'.
		(Delay forMilliseconds: 500) wait.
		^ true].
	self isWindows ifTrue: [
		proc1 := (Smalltalk at: #OSProcess) command:
			'attrib -R /S /D "', path, '\*.*"'.
		(Delay forMilliseconds: 200) wait.
		^ proc1 succeeded].
	proc1 := (Smalltalk at: #OSProcess) command: 'chmod -R u+w "', path, '"'.
	(Delay forMilliseconds: 200) wait.
	^ proc1 succeeded