private
versionsOf: aClass selector: aSelector
	"The stored versions of the method, newest (the current one) first, as ChangeRecords; like Squeak's versions browser. Empty if the method has no source in the changes or sources file."
	^ (ChangeSet
		scanVersionsOf: (aClass compiledMethodAt: aSelector)
		class: aClass theNonMetaClass
		meta: aClass isMeta
		category: (aClass organization categoryOfElement: aSelector)
		selector: aSelector) ifNil: [#()]