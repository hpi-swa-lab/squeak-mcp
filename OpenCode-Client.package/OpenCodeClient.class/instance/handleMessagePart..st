private
handleMessagePart: aPart
	"Process a message part and notify callback."
	| type content delta |
	type := aPart at: 'type' ifAbsent: ['text'].
	content := aPart at: 'text' ifAbsent: [''].
	delta := aPart at: 'delta' ifAbsent: [nil].

	WorldState addDeferredUIMessage: [
		onMessagePartReceived value: {
			#type -> type.
			#content -> content.
			#delta -> delta
		} asDictionary.
	].