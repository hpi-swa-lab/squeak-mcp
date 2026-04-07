private
classDetailTextFor: className changes: classChanges
	| sortedChanges firstChange lastChange statusText result |
	sortedChanges := classChanges sorted: [:a :b | (a at: #timestamp) < (b at: #timestamp)].
	firstChange := sortedChanges first.
	lastChange := sortedChanges last.

	statusText := (lastChange at: #changeKind) = #Removed
		ifTrue: ['Deleted']
		ifFalse: [(firstChange at: #changeKind) = #Added
		ifTrue: ['New']
		ifFalse: ['Modified']].

	result := Text new.
	result := result, (self styledHeader: className, ' (class definition)'), String cr.
	result := result, 'Type: ', statusText, String cr.
	result := result, 'Changes: ', sortedChanges size asString, String cr.
	result := result, '-----------------------------------', String cr, String cr.

	(lastChange at: #newDefinition ifAbsent: []) ifNotNil: [:def |
		result := result, (self styledHeader: '-- Class Definition --'), String cr.
		result := result, def asString, String cr, String cr].
	
	(lastChange at: #comment ifAbsent: []) ifNotNil: [:comment |
		comment isEmpty ifFalse: [
			result := result, (self styledHeader: '-- Class Comment --'), String cr.
			result := result, comment asString, String cr, String cr]].

	result := result, (self styledHeader: '-- Change History --'), String cr, String cr.
	sortedChanges doWithIndex: [:change :index |
		| oldDef newDef author |
		oldDef := change at: #oldDefinition ifAbsent: [].
		newDef := change at: #newDefinition ifAbsent: [].
		author := change at: #author ifAbsent: ['unknown'].
		result := result, 'Change #', index asString, ' (',
			(change at: #changeKind) asString, ' - ',
			(change at: #timestamp) asString, ' by ', author, '):', String cr.

		(oldDef notNil and: [newDef notNil]) ifTrue: [
			result := result, (self coloredDiffFrom: oldDef to: newDef), String cr].
		(oldDef isNil and: [newDef notNil]) ifTrue: [
			newDef lines do: [:line |
				result := result, (Text
					string: '+ ', line, String cr
					attribute: (TextColor color: Color green darker))]].
		(oldDef isNil and: [newDef isNil]) ifTrue: [
			result := result, '(no definition captured)', String cr].
		result := result, String cr].

	^ result