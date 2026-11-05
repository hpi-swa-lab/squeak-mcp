private
listVersions: theClass className: className methodName: methodName
	| versions |
	(theClass includesSelector: methodName asSymbol) ifFalse: [
		^ self errorResult: 'Method ', methodName, ' not found in ', className, '. For removed methods, use Squeak''s Extras > Recover Method Versions.'].
	versions := self versionsOf: theClass selector: methodName asSymbol.
	^ self successResult: (Dictionary new
		at: 'class' put: className;
		at: 'method' put: methodName;
		at: 'versions' put: (versions asArray withIndexCollect: [:each :index |
			Dictionary new
				at: 'version' put: index;
				at: 'current' put: index = 1;
				at: 'stamp' put: each stamp asString;
				at: 'category' put: each category asString;
				at: 'source' put: each string;
				yourself]);
		yourself)