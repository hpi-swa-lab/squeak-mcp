private
printValue: aBlock
	"Values in a broken state may fail to print; that must not hide the trace."
	^ [aBlock value printStringLimitedTo: self class maxValueSize]
		on: Error do: [:ex | '<cannot print: ', (self errorMessageOf: ex), '>']