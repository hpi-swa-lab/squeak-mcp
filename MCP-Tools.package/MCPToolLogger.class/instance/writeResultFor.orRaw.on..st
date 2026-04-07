private
writeResultFor: resultDict orRaw: rawResult on: stream
	| lines |
	stream nextPutAll: '--- RESULT ---'; cr.
	resultDict ifNil: [
		lines := rawResult printString lines.
		(lines first: (50 min: lines size)) do: [:line |
			stream nextPutAll: '  '; nextPutAll: line; cr].
		lines size > 50 ifTrue: [
			stream nextPutAll: '  ... (';
				nextPutAll: (lines size - 50) printString;
				nextPutAll: ' more lines)'; cr].
		^ self].

	(resultDict at: 'success' ifAbsent: []) ifNotNil: [:val |
		stream nextPutAll: '  success: '; nextPutAll: val printString; cr].
	(resultDict at: 'class' ifAbsent: []) ifNotNil: [:val |
		stream nextPutAll: '  class: '; nextPutAll: val printString; cr].
	(resultDict at: 'result' ifAbsent: []) ifNotNil: [:val |
		stream nextPutAll: '  result: '; cr.
		lines := val printString lines.
		(lines first: (50 min: lines size)) do: [:line |
			stream nextPutAll: '    '; nextPutAll: line; cr].
		lines size > 50 ifTrue: [
			stream nextPutAll: '    ... (';
				nextPutAll: (lines size - 50) printString;
				nextPutAll: ' more lines)'; cr]].
	(resultDict at: 'error' ifAbsent: []) ifNotNil: [:val |
		stream nextPutAll: '  ERROR: '; nextPutAll: val printString; cr].
	resultDict keysAndValuesDo: [:key :val |
		(#('success' 'class' 'result' 'error') includes: key) ifFalse: [
			stream nextPutAll: '  '; nextPutAll: key; nextPutAll: ': ';
			nextPutAll: (val printString contractTo: 200); cr]].
	stream nextPutAll: '==========================='