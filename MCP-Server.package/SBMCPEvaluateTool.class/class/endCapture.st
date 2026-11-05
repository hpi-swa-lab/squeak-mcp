transcript capturing
endCapture
	"The last running evaluate puts the real transcript back, unless someone else replaced the capturing one in the meantime."
	self captureLock critical: [
		ActiveCaptures := ((ActiveCaptures ifNil: [1]) - 1) max: 0.
		ActiveCaptures = 0 ifTrue: [
			(Smalltalk at: #Transcript) == Capture
				ifTrue: [Smalltalk at: #Transcript put: RealTranscript].
			Capture := nil.
			RealTranscript := nil]]