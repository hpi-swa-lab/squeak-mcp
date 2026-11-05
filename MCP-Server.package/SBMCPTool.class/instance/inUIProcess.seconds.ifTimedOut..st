ui process
inUIProcess: aBlock seconds: seconds ifTimedOut: timeoutBlock
	"Answer the value of aBlock, evaluated by the UI process: morphs and tools changed from another process could interfere with the UI's own drawing and updates. If the UI process has not finished it after seconds, answer the value of timeoutBlock instead; if the UI has not started aBlock by then, it never will. Errors are passed on to this process instead of opening a debugger in the user's world."
	| done timedOut result error |
	done := Semaphore new.
	timedOut := false.
	Project current addDeferredUIMessage: [
		timedOut ifFalse: [
			[result := aBlock value]
				on: Error do: [:ex | error := self errorMessageOf: ex].
			done signal]].
	(done waitTimeoutMSecs: seconds * 1000) ifTrue: [
		timedOut := true.
		^ timeoutBlock value].
	error ifNotNil: [self error: error].
	^ result