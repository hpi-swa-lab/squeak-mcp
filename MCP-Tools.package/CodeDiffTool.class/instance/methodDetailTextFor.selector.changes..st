private
methodDetailTextFor: className selector: selector changes: methodChanges
	| sortedChanges firstChange lastChange statusText result |
	sortedChanges := methodChanges sorted: [:a :b | (a at: #timestamp) < (b at: #timestamp)].
	firstChange := sortedChanges first.
	lastChange := sortedChanges last.

	statusText := (lastChange at: #changeKind) = #Removed
		ifTrue: ['Deleted']
		ifFalse: [(firstChange at: #changeKind) = #Added
		ifTrue: ['New']
		ifFalse: ['Modified']].

	result := Text new.
	result := result, (self styledHeader: className, ' >> ', selector asString), String cr.
	result := result, 'Type: ', statusText, String cr.
	result := result, 'Changes: ', sortedChanges size asString, String cr.
	result := result, '-----------------------------------', String cr, String cr.

	"Show before/after for modifications"
	(firstChange at: #changeKind) = #Added ifFalse: [
		(firstChange at: #oldSource ifAbsent: []) ifNotNil: [:source |
			result := result, (self styledHeader: '-- Before --'), String cr.
			result := result, source asString, String cr, String cr]].

	(lastChange at: #changeKind) = #Removed ifFalse: [
		(lastChange at: #newSource ifAbsent: []) ifNotNil: [:source |
			result := result, (self styledHeader: '-- After --'), String cr.
			result := result, source asString, String cr, String cr]].

	"Show change history with diffs"
	result := result, (self styledHeader: '-- Change History --'), String cr, String cr.
	sortedChanges doWithIndex: [:change :index |
		| oldSource newSource author |
		oldSource := change at: #oldSource ifAbsent: [].
		newSource := change at: #newSource ifAbsent: [].
		author := change at: #author ifAbsent: ['unknown'].

		result := result, 'Diff #', index asString, ' (',
			(change at: #changeKind) asString, ' - ',
			(change at: #timestamp) asString, ' by ', author, '):', String cr.

		(oldSource notNil and: [newSource notNil]) ifTrue: [
			result := result, (self coloredDiffFrom: oldSource to: newSource)].
		(oldSource isNil and: [newSource notNil]) ifTrue: [
			newSource lines do: [:line |
				result := result, (Text
					string: '+ ', line, String cr
					attribute: (TextColor color: Color green darker))]].
		(oldSource notNil and: [newSource isNil]) ifTrue: [
			oldSource lines do: [:line |
				result := result, (Text
						string: '- ', line, String cr
						attribute: (TextColor color: Color red darker))]].
		result := result, String cr].

	^ result