evaluation
aboveEvaluationsDo: aBlock
	"Evaluate aBlock, which forks an evaluation and waits for it, with this process above the evaluation's priority: processes of equal priority do not preempt each other, so a busy evaluation would never let this process stop it after its time limit. This process only waits meanwhile."
	| process oldPriority |
	process := Processor activeProcess.
	oldPriority := process priority.
	process priority: (oldPriority max: self class evaluationPriority + 1).
	^ aBlock ensure: [process priority: oldPriority]