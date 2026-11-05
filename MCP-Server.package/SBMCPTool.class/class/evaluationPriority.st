evaluation
evaluationPriority
	"Evaluations and test runs get their own process at this priority, as a background process. Not below it: tools fork their own background work just below, e.g. the Git tools' commit cache at userBackgroundPriority - 1, and an evaluation waiting for such work at the same priority could wait for minutes, as processes of equal priority do not preempt each other."
	^ Processor userBackgroundPriority