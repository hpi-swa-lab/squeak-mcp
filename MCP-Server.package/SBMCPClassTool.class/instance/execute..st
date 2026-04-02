executing
execute: arguments
	| action name |
	action := self from: arguments get: 'action' ifAbsent: ''.
	name := self from: arguments get: 'name' ifAbsent: ''.

	action isEmpty ifTrue: [^ self errorResult: 'action parameter is required'].
	name isEmpty ifTrue: [^ self errorResult: 'name parameter is required'].

	action = 'create' ifTrue: [^ self createClass: arguments name: name].
	action = 'modify' ifTrue: [^ self modifyClass: arguments name: name].
	action = 'rename' ifTrue: [^ self renameClass: arguments newName: name].
	action = 'delete' ifTrue: [^ self deleteClass: name].

	^ self errorResult: 'Invalid action: ', action, '. Use create, modify, rename, or delete.'