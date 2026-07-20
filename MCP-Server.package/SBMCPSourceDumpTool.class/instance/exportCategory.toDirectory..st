private
exportCategory: category toDirectory: directory
	"Export a single category to a file. Returns #created, #updated, or #skipped"
	| fileName filePath classes newContent existingContent |

	classes := SystemOrganization listAtCategoryNamed: category.
	classes isEmpty ifTrue: [^ #skipped].

	fileName := (category copyReplaceAll: ' ' with: '_'), '.st'.
	filePath := directory fullNameFor: fileName.

	newContent := self sourceForCategory: category classes: classes.

	(directory fileExists: fileName) ifTrue: [
		existingContent := (directory readOnlyFileNamed: fileName) contentsOfEntireFile.
		existingContent = newContent ifTrue: [^ #skipped].
		directory deleteFileNamed: fileName.
		self writeContent: newContent toFile: filePath.
		^ #updated]
	ifFalse: [
		self writeContent: newContent toFile: filePath.
		^ #created]