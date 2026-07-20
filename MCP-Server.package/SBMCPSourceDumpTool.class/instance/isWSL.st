private
isWSL
	| proc output |
	Smalltalk platformName = 'unix' ifFalse: [^ false].
	proc := (Smalltalk at: #OSProcess) command: 'uname -r > /tmp/squeak_wsl_check.txt'.
	(Delay forMilliseconds: 200) wait.
	proc succeeded ifFalse: [^ false].
	output := [(FileStream readOnlyFileNamed: '/tmp/squeak_wsl_check.txt') contentsOfEntireFile]
		on: Error do: [:e | ''].
	^ output asLowercase includesSubstring: 'microsoft'