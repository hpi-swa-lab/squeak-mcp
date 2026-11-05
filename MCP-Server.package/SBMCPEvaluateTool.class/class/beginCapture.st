transcript capturing
beginCapture
	"Evaluates run in their own processes and may overlap. The first one installs one shared capturing transcript, the others use it too. Answer it."
	^ self captureLock critical: [
		(ActiveCaptures ifNil: [0]) = 0 ifTrue: [
			RealTranscript := self realTranscriptFrom: (Smalltalk at: #Transcript).
			Capture := CapturingTranscript new originalTranscript: RealTranscript; yourself.
			Smalltalk at: #Transcript put: Capture].
		ActiveCaptures := (ActiveCaptures ifNil: [0]) + 1.
		Capture]