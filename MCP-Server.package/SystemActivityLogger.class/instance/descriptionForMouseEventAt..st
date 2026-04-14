event handling
descriptionForMouseEventAt: position
	| targetMorph window |
	targetMorph := (World morphsAt: position)
		ifNotEmpty: [:m | m first]
		ifEmpty: [nil].
	(targetMorph isNil or: [targetMorph == World])
		ifTrue: [^ 'Desktop'].
	window := targetMorph ownerThatIsA: SystemWindow.
	^ window ifNil: ['Morph: ', targetMorph class name] ifNotNil: [window label]