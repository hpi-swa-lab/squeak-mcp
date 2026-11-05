transcript capturing
realTranscriptFrom: aTranscript
	"Skip capturing transcripts, also ones left over by older versions."
	| transcript |
	transcript := aTranscript.
	[transcript isCapturingTranscript] whileTrue: [transcript := transcript originalTranscript].
	^ transcript