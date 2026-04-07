private
coloredDiffFrom: oldText to: newText
	| oldLines newLines oldSet newSet result |
	oldLines := oldText lines.
	newLines := newText lines.
	oldSet := oldLines asSet.
	newSet := newLines asSet.
	result := Text new.

	oldLines do: [:line |
		(newSet includes: line) ifFalse: [
			result := result, (Text
				string: '- ', line, String cr
				attribute: (TextColor color: Color red darker))]].

	newLines do: [:line |
		(oldSet includes: line) ifFalse: [
			result := result, (Text
				string: '+ ', line, String cr
				attribute: (TextColor color: Color green darker))]].

	^ result