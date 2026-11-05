private
pathFrom: arguments
	"The field names to follow. Clients may send the array as a JSON string, so accept that and names separated by / too."
	| path |
	path := self from: arguments get: 'path' ifAbsent: [#()].
	path isString ifTrue: [
		path := path withBlanksTrimmed.
		path := path isEmpty
			ifTrue: [#()]
			ifFalse: [path first = $[
				ifTrue: [Json readFrom: path readStream]
				ifFalse: [path findTokens: '/']]].
	^ path asArray collect: [:each | each asString]