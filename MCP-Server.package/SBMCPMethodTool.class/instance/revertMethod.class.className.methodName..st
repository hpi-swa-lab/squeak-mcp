private
revertMethod: arguments class: theClass className: className methodName: methodName
	"Compile an earlier version with its own author stamp and category, like Squeak's versions browser (see ChangeRecord>>fileIn:): whoever wrote it keeps the credit."
	| versions number record category error |
	(theClass includesSelector: methodName asSymbol) ifFalse: [
		^ self errorResult: 'Method ', methodName, ' not found in ', className, '. For removed methods, use Squeak''s Extras > Recover Method Versions.'].
	number := self integerFrom: arguments get: 'version' ifAbsent: [nil].
	number ifNil: [^ self errorResult: 'version parameter is required for revert; see the versions action'].
	versions := self versionsOf: theClass selector: methodName asSymbol.
	(number between: 2 and: versions size) ifFalse: [
		^ self errorResult: (number = 1
			ifTrue: ['Version 1 is the current version']
			ifFalse: ['There is no version ', number printString, '; ', methodName, ' has ', versions size printString, ' versions'])].
	record := versions at: number.
	category := record category ifNil: [theClass organization categoryOfElement: methodName asSymbol].
	error := nil.
	self withMCPAuthorInitials: [
		[theClass compile: record string withSqueakLineEndings classified: category withStamp: record stamp notifying: nil]
			on: SyntaxErrorNotification do: [:ex | error := self syntaxErrorMessage: ex in: record string withSqueakLineEndings]
			on: Error do: [:ex | error := self errorMessageOf: ex]].
	error ifNotNil: [^ self errorResult: 'Version ', number printString, ' does not compile anymore: ', error].
	^ self successResult: (Dictionary new
		at: 'action' put: 'reverted';
		at: 'class' put: className;
		at: 'method' put: methodName;
		at: 'version' put: number;
		at: 'stamp' put: record stamp asString;
		at: 'category' put: category asString;
		yourself)