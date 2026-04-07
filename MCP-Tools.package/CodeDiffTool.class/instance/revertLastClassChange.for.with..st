actions
revertLastClassChange: change for: className with: allChanges
    | changeKind previousChange oldDefinition |
    changeKind := change at: #changeKind.

    changeKind = #Added ifTrue: [
        (Smalltalk at: className asSymbol ifAbsent: []) ifNotNil: [:cls |
            cls removeFromSystem].
        ^ self].

    changeKind = #Removed ifTrue: [
        oldDefinition := change at: #oldDefinition ifAbsent: [].
        oldDefinition ifNil: [
            allChanges reverseDo: [:c |
                oldDefinition ifNil: [
                    oldDefinition := c at: #newDefinition ifAbsent: [c at: #oldDefinition ifAbsent: []]]]].
        oldDefinition ifNotNil: [Compiler evaluate: oldDefinition].
        ^ self].

    changeKind = #Modified ifTrue: [
        (change at: #oldDefinition ifAbsent: []) ifNotNil: [:def |
            Compiler evaluate: def].
        ^ self].

    changeKind = #Commented ifTrue: [
        previousChange := allChanges size > 1
            ifTrue: [allChanges at: allChanges size - 1]
            ifFalse: [nil].
        previousChange ifNotNil: [
            (previousChange at: #comment ifAbsent: []) ifNotNil: [:comment |
                (Smalltalk at: className asSymbol ifAbsent: []) ifNotNil: [:cls |
                    cls comment: comment]]]]