private
inUIProcess: aBlock
	"Answer the value of aBlock, evaluated by the UI process: morphs drawn from another process could interfere with the UI's own drawing and layout. If the UI process does not get to it in time (busy or blocked), evaluate it here. Errors are passed on to this process instead of opening a debugger in the user's world."
	| done timedOut result error |
	done := Semaphore new.
	timedOut := false.
	Project current addDeferredUIMessage: [
		"After a timeout, this process draws; the UI process must not do it at the same time."
		timedOut ifFalse: [
			[result := aBlock value]
				on: Error do: [:ex | error := ex messageText ifEmpty: [ex class name]].
			done signal]].
	(done waitTimeoutMSecs: self class uiTimeoutMSecs) ifTrue: [
		timedOut := true.
		^ aBlock value].
	error ifNotNil: [self error: error].
	^ result